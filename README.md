# gohttp-smol

Compiling a simple Go web server using Docker as a repeatable build environment.

## Why?

I found [this article](https://devopsdirective.com/posts/2021/04/tiny-container-image/)
on Hacker News about how to make very small Docker images. The final solution
used a multi-stage build to compile the Go binary with static linking flags, and
used the `scratch` image as the final base image.

The thing is; `scratch` doesn't have anything in it. It's _literally_ empty. So
it made me wonder: Why even use Docker at this point? What value is it adding?
Since it's not bringing any dependencies with it that aren't already in the Go
binary, really it comes down to using Docker as a packaging format more that
anything else. It's a glorified tarball at this point.

The other thing that it does, which I think actually provides some value that
you wouldn't get with a simple `go build` in a Makefile, is that it performs the
build in a clean Docker image every time, the same on everyone's machine.

So this project is just a simple experiment; can we use the same base Docker
image that go builds on to provide a repeatable build that a whole team could
use, but that _doesn't_ use Docker as the final distribution format? In practice
this is possible by simply using a `docker run` instead of `docker built`
command and a pretty long string of command line flags.

## Why would you use it?

I would use this to run local builds and _maybe_ CI builds as well. Something
like [GitLab CI](https://docs.gitlab.com/ee/ci/) already allows you to choose
whatever Docker image you want to run a step on, meaning you really only need
the `go build` command to create a repeatable build in CI. I do believe that
having a way to build and run locally consistently for everyone in the team is
super useful. It makes it easy to run and test locally, and can help you escape
the situation where your software is hard to run locally because of its many and
complicated dependencies.

If you're deploying straight on the host OS this is also a very useful option.
Something like a traditional VPS deployment, straight up EC2/GCE/etc with an
autoscaler, or even a more flexible orchestrator like [Nomad](https://www.nomadproject.io/).

## Why _wouldn't_ you use it?

I said earlier that the only advantage that the original article's Docker image
offered was that it used the Docker format as the final packaging solution.
Well, if you need to deploy your software on a containerized platform like
Kubernetes or ECS, then you'll want to have a Docker image anyway. If that's
your situation, just stick to a good ol' `docker build` and carry on with your
life!