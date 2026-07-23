Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A3142AFB7;
	Thu, 23 Jul 2026 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819885; cv=none; b=QuNvfjWoaiQKmUYRh7WTcccf8zO9Pfd4fp66FaWwWST2QtznKQn3LqRfFpomb2iCjLbGdB08QdWJ9VfAfSHiRZcWlILxFsM27V/V9X+2VzXNZw8Wv+F7LANpz0eDk0TCSPe7H08Cr6II8Qhg7vZ09IgnUU93XXX/RhzVKQm0Pm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819885; c=relaxed/simple;
	bh=2T7nmM3mhRxlBSfjbJ+XmcTjTnVn51Hn5ZeDzChYsJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZtZniIJQzDAvNSN1Xmf7CPOYe2Jt+kSwssrq85hMQd820h4xKs3KDSrwp3qMyOrw/BVaJtEhTP9mdbikIAzT98aQlz/elnStTXJkfxPiFKzrAvQ52iizTUU8R0q49jf8xPtF3FiTHtkmjD21TmHuodkUk5tUx80TzsUKImruho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OreCp9uy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OreCp9uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9911F000E9;
	Thu, 23 Jul 2026 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819883;
	bh=qjRCPXomKSjphdAldTpSRSYsWggsHazfxgaRK7XWVLw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OreCp9uyv5cCbuH2IsD8GYJev6QpIM1TlPo7fXjFz3xdSqI+H1wKZynSzx4R5psVE
	 6AHRU2lGaKOnKr5NjuIXQeUqRlTdb70LoK+yeVVdnehHF2JhAZlqJCgPLBdK63tNUc
	 XvgTmaishQDvqiX2sgBDDxv4z0H5sYkgRc3mZIVx8ydlVWdisWDvRtGJJSE2S21v6C
	 wMqnnL2UexQ3hElUrv0LWjJfDj2hxzvtwVi3SV7IgbC7F0Qk5sNZsccfT3shjWERGK
	 2CWJOGwLbJJd9TJBwdhCSoiNEl3+l4aORVWW+W4sZyjJC7ApDlkEeGOuC/TqkA1NEG
	 2MGte3U0BEjFA==
Date: Thu, 23 Jul 2026 16:17:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Message-ID: <16237d02-bc2c-4401-a1e5-1d81961a65c9@sirena.org.uk>
References: <20260722142834.868902312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2Nmix2e3CdKJ9H49"
Content-Disposition: inline
In-Reply-To: <20260722142834.868902312@linuxfoundation.org>
X-Cookie: (null cookie


--2Nmix2e3CdKJ9H49
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 04:31:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm seeing a regression in the proc read kselftest which bisects to
"proc: protect ptrace_may_access() with exec_update_lock (part 1)":

# selftests: proc: read
[  167.845745] ICMPv6: process `read' is using deprecated sysctl (syscall) =
net.ipv6.neigh.default.base_reachable_time - use net.ipv6.neigh.default.bas=
e_reachable_time_ms instead
[  167.914113] sysrq: HELP : loglevel(0-9) reboot(b) crash(c) terminate-all=
-tasks(e) memory-full-oom-kill(f) kill-all-tasks(i) thaw-filesystems(j) sak=
(k) show-backtrace-all-active-cpus(l) show-memory-usage(m) nice-all-RT-task=
s(n) poweroff(o) show-registers(p) show-all-timers(q) unraw(r) sync(s) show=
-task-states(t) unmount(u) show-blocked-tasks(w) replay-kernel-logs(R)=20
[  168.019358] Unable to handle kernel NULL pointer dereference at virtual =
address 0000000000000098

=2E..

[  168.270588] Call trace:
[  168.273035]  rwsem_read_trylock+0x30/0xe0
[  168.277047]  proc_map_files_readdir+0x94/0x3dc
[  168.281498]  iterate_dir+0x118/0x224
[  168.285077]  __arm64_sys_getdents64+0x70/0x160
[  168.289524]  invoke_syscall+0x44/0xe4

Full log:

   https://lava.sirena.org.uk/scheduler/job/3014030#L10663

bisect log:

# bad: [f5410b1bf27f296237f0ad05c8473d8e9a7ac467] Linux 6.12.97-rc2
# good: [6d15a1029d425b15c59463910ebdccc4afe760d6] Linux 6.12.96
git bisect start 'f5410b1bf27f296237f0ad05c8473d8e9a7ac467' '6d15a1029d425b=
15c59463910ebdccc4afe760d6'
# test job: [f5410b1bf27f296237f0ad05c8473d8e9a7ac467] https://lava.sirena.=
org.uk/scheduler/job/3014030
# bad: [f5410b1bf27f296237f0ad05c8473d8e9a7ac467] Linux 6.12.97-rc2
git bisect bad f5410b1bf27f296237f0ad05c8473d8e9a7ac467
# test job: [9c20411fdaad93e7408587bd3091f7503ef93ab5] https://lava.sirena.=
org.uk/scheduler/job/3014886
# good: [9c20411fdaad93e7408587bd3091f7503ef93ab5] thermal: testing: zone: =
Flush work items during cleanup
git bisect good 9c20411fdaad93e7408587bd3091f7503ef93ab5
# test job: [9aa948a6f8287277c395a9296d2ef196a4a52b33] https://lava.sirena.=
org.uk/scheduler/job/3015136
# good: [9aa948a6f8287277c395a9296d2ef196a4a52b33] platform/x86/amd/pmc: Ch=
eck for intermediate wakeup in function
git bisect good 9aa948a6f8287277c395a9296d2ef196a4a52b33
# test job: [e5744e5ac81be38feb1b9519fe911b21ab5051d6] https://lava.sirena.=
org.uk/scheduler/job/3015323
# good: [e5744e5ac81be38feb1b9519fe911b21ab5051d6] reset: sunxi: fix memory=
 region leak on ioremap failure
git bisect good e5744e5ac81be38feb1b9519fe911b21ab5051d6
# test job: [1a47ba727805fe69a6af0cf5c58f6f953f6b3620] https://lava.sirena.=
org.uk/scheduler/job/3015469
# bad: [1a47ba727805fe69a6af0cf5c58f6f953f6b3620] treewide: Switch/rename t=
o timer_delete[_sync]()
git bisect bad 1a47ba727805fe69a6af0cf5c58f6f953f6b3620
# test job: [a593a39fda99d6d9161502d92d348b2102db059b] https://lava.sirena.=
org.uk/scheduler/job/3015711
# good: [a593a39fda99d6d9161502d92d348b2102db059b] PCI: Move Resizable BAR =
code to rebar.c
git bisect good a593a39fda99d6d9161502d92d348b2102db059b
# test job: [37a0b322a8872dd78832c2631e615b24053e4f8e] https://lava.sirena.=
org.uk/scheduler/job/3015958
# good: [37a0b322a8872dd78832c2631e615b24053e4f8e] Bluetooth: 6lowpan: fix =
cyclic locking warning on netdev unregister
git bisect good 37a0b322a8872dd78832c2631e615b24053e4f8e
# test job: [3402cd2dfaaa8f3e03d354e994d97361d8aeeafa] https://lava.sirena.=
org.uk/scheduler/job/3016246
# good: [3402cd2dfaaa8f3e03d354e994d97361d8aeeafa] ksmbd: centralize ksmbd_=
conn final release to plug transport leak
git bisect good 3402cd2dfaaa8f3e03d354e994d97361d8aeeafa
# test job: [ecefa46f7bae6b671bd90f8a5456bacda4dbc3c6] https://lava.sirena.=
org.uk/scheduler/job/3016441
# good: [ecefa46f7bae6b671bd90f8a5456bacda4dbc3c6] HID: add haptics page de=
fines
git bisect good ecefa46f7bae6b671bd90f8a5456bacda4dbc3c6
# test job: [56f46798a52ac271c5dae5c25eeb36eb3ce48f3b] https://lava.sirena.=
org.uk/scheduler/job/3016753
# good: [56f46798a52ac271c5dae5c25eeb36eb3ce48f3b] seqlock: Introduce scope=
d_seqlock_read()
git bisect good 56f46798a52ac271c5dae5c25eeb36eb3ce48f3b
# test job: [6258bb18b077de959eeda9968d49ef94b383a451] https://lava.sirena.=
org.uk/scheduler/job/3016884
# bad: [6258bb18b077de959eeda9968d49ef94b383a451] proc: protect ptrace_may_=
access() with exec_update_lock (part 1)
git bisect bad 6258bb18b077de959eeda9968d49ef94b383a451
# test job: [a95c6a2607658a19a6daf8a2d06851316c4fa8dd] https://lava.sirena.=
org.uk/scheduler/job/3017038
# good: [a95c6a2607658a19a6daf8a2d06851316c4fa8dd] seqlock: Change do_task_=
stat() to use scoped_seqlock_read()
git bisect good a95c6a2607658a19a6daf8a2d06851316c4fa8dd
# first bad commit: [6258bb18b077de959eeda9968d49ef94b383a451] proc: protec=
t ptrace_may_access() with exec_update_lock (part 1)

--2Nmix2e3CdKJ9H49
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiMKIACgkQJNaLcl1U
h9Db0wf/eZJFGfNgYtrBPpJTUyPM+vB15WSUpQY1KrDqMTcdycsVnXqCvNGdfVOI
OMQAwnONL1f2HqQ/JS8fm0gIpiUu5W8fqS45C6ucKPpFNYKO1b5LjlQlC02Ja3iu
11H208Xp/KtaRHasMWCysaqRgBD1iSS6dYpixNrEDUTYG+Tbu5Mbomftu3yxGFu4
42QnQV8LH383G0xVb9TJ8p70jCCA09PRAY0iqxAeb8kl6Az9haZ9/IurIET5OQq9
MLW9GNfuMPGrwpiJt1qjd0EdBRGPZmZFDCQNmW3HuHutXwWTHC9j3jhonXAhW1v4
QMp+AvExiDqPa0y6ZDI/KvaQRwN7aw==
=pD9E
-----END PGP SIGNATURE-----

--2Nmix2e3CdKJ9H49--
