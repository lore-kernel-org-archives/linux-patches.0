Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AEE155A52;
	Wed, 15 May 2024 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715789867; cv=none; b=SinGpaYah7pc/W4h0I1BzGb98Nk2FRB9xQff7zZfJUY0eeRhUxVLYM9b1LzdsxF60Gvflppcjd+OqUaq5KuRJyj9TllPhnWpeeDmcLOPx/UzhqhMFdbJkB3NCzbyfzETWneGna9/fEeUQSNrZ1HVBpYbpNODmrKW+dey03L+0wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715789867; c=relaxed/simple;
	bh=uLTSFmR26jysz/t1r0pgjgFB0W2gGfXMncXxbWXDUbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=paPx+MSBpKp7fu8nvkMkP7IfAQIq0GP9JXdsxrIsoyRyIikY5hGssvBRvr4KxQ1mST9QkhBmhsb+QCSQX6oxBbgWYU0DcVc0IfDmC+b9IAY/1vF/dpsbiz9w/OhFSpycyRkGpGjRDugYG+tPkeH06H/n/2vSOAi52DFI2iS5nW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bB1XiwhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bB1XiwhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99916C116B1;
	Wed, 15 May 2024 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715789866;
	bh=uLTSFmR26jysz/t1r0pgjgFB0W2gGfXMncXxbWXDUbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bB1XiwhUpKp1t8bJCEHlCNxXE7ah418QzlRO5wyZ0lNBhEYwNFfJk5Qh8WYqv+BRF
	 /j3bJoLC8/rVZ+zk/inwN/d2cDjW1n/J0ZLEH/83rvDwoxI1GkvoGYvf/FhYOJAUvk
	 id/t+ZTSQrhfvRCaRRhV5vZaV3oa8dq2yhr8PPXMnqmaugbhnYKr4Tq+T35XfLKocI
	 WTutv/nu6A/+hGB3VMQYnkq1X4mRVvX/F9pQapCsOtTNj+Wkwk7blfaURXd3TqZOqU
	 DhI6542mPzalK46wAIC+Z2xHXL/qBrbbiTb7Oknh7GN1ELgr/+ZxX8i0KDVQID/L4e
	 rcS1VnKLnZz7A==
Date: Wed, 15 May 2024 17:17:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Doug Berger <opendmb@gmail.com>
Subject: Re: [PATCH 6.1 000/243] 6.1.91-rc2 review
Message-ID: <39483cfc-4345-4fbd-87c2-9d618c6fdbc6@sirena.org.uk>
References: <20240515082456.986812732@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cprXTNmPew9yvJ45"
Content-Disposition: inline
In-Reply-To: <20240515082456.986812732@linuxfoundation.org>
X-Cookie: When in doubt, lead trump.


--cprXTNmPew9yvJ45
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2024 at 10:27:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This seems to break NFS boot for me on Raspberry Pi 4.  The first sign
of trouble is a WARN:

[   31.969792] ------------[ cut here ]------------
Setting prompt string to ['-+\\[ end trace \\w* \\]-+[^\\n]*\\r', '/ #', 'Login timed out', 'Login incorrect']
[   31.974485] NETDEV WATCHDOG: end0 (bcmgenet): transmit queue 4 timed out
[   31.981327] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:525 dev_watchdog+0x20c/0x214

Full log at:

   https://lava.sirena.org.uk/scheduler/job/265447#L1021

ramdisk boots seem happy.  A bisect claims that "net: bcmgenet:
synchronize EXT_RGMII_OOB_CTRL access" is the first commit that breaks,
I'm not seeing issues with other stables.

# bad: [ca2e773ed20f212ed18c759aef3993ae7bfea631] Linux 6.1.91-rc2
# good: [909ba1f1b4146de529469910c1bd0b1248964536] Linux 6.1.90
# good: [a48685468888cca7b6e9df4b944a11be93de7837] MIPS: scall: Save thread_info.syscall unconditionally on entry
git bisect start 'ca2e773ed20f212ed18c759aef3993ae7bfea631' '909ba1f1b4146de529469910c1bd0b1248964536' 'a48685468888cca7b6e9df4b944a11be93de7837'
# bad: [ca2e773ed20f212ed18c759aef3993ae7bfea631] Linux 6.1.91-rc2
git bisect bad ca2e773ed20f212ed18c759aef3993ae7bfea631
# good: [b86d51ccf09b413520133f135d69e2ed90aae95d] btrfs: fix kvcalloc() arguments order in btrfs_ioctl_send()
git bisect good b86d51ccf09b413520133f135d69e2ed90aae95d
# bad: [e84fd70ea88224569d12d7fb011a29796f1d7eb9] net: bcmgenet: synchronize UMAC_CMD access
git bisect bad e84fd70ea88224569d12d7fb011a29796f1d7eb9
# good: [b8c64a29b20e55e5d910d59ae3cc8b188c3d8048] usb: xhci-plat: Don't include xhci.h
git bisect good b8c64a29b20e55e5d910d59ae3cc8b188c3d8048
# good: [f87acc39c53bf614274607090a25f51f567f16c2] mptcp: ensure snd_nxt is properly initialized on connect
git bisect good f87acc39c53bf614274607090a25f51f567f16c2
# good: [cd586168e27d7403c49cfe8c5e3f40f44e63f2f4] kmsan: compiler_types: declare __no_sanitize_or_inline
git bisect good cd586168e27d7403c49cfe8c5e3f40f44e63f2f4
# bad: [3443d6c3616b41676a7f02b0fbb55da47067dbc4] net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access
git bisect bad 3443d6c3616b41676a7f02b0fbb55da47067dbc4
# good: [7d43b80d8a20d95c876cd6a4f2cc94f9da4637f7] tipc: fix UAF in error path
git bisect good 7d43b80d8a20d95c876cd6a4f2cc94f9da4637f7
# first bad commit: [3443d6c3616b41676a7f02b0fbb55da47067dbc4] net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access

--cprXTNmPew9yvJ45
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZE4CMACgkQJNaLcl1U
h9CTQQf9HoF7NMyOCqfkWU+/x144f7ZUa2bjkO46zn8GEX6agCSlR41uN7X4V4+Y
ZmzXblkCcUPtBUXs+ih9J13aqn1jilD2i/v+LsGeOdcdK8GO13JrFLCzj0FXUzvP
S7ytNGdr7B5x68IrfEjaSA9Ck5nOfkbhzpkj713hpOM9NPWgiUuaqaFT90TalO8Y
YLafWkUNECuUZJAt32JsbbPI5l+CTjCxrtZQfsnIQa0Wwtiub37A4TSqwpbheUlr
0nJDwlMgTITtPg0j+PCAlikMsPOA6OGUTporTdqERT7rUsOLLXvznTdudZZ1dKFA
tiJs3SQbjLO4rzMAN1orIGPA0wKFvw==
=+prd
-----END PGP SIGNATURE-----

--cprXTNmPew9yvJ45--
