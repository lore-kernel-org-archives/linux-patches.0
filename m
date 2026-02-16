Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C841D5AD4;
	Mon, 16 Feb 2026 14:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771252404; cv=none; b=McZEiddIOMJ04ccOuk3Aub0ygXxjHGCUs+2gT8dmxEUstcQVadcVYHX03t9XZYYF0uLiFwXF+hNqPgOMcRWdDODHI48QIfxMIWxR7/w/HAT7zVVby0EOrz3f5hZJRs1RH1hgaa+rGA5u5CKxYK4gvNP2ujoy4Fp0J5PPEzGY4bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771252404; c=relaxed/simple;
	bh=tdvq/uSw/SrS/YKQsh0ba9OJ9N9xO33wfZZWMx/DXKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEiIwU9lK9S7DjITgzGaVN8E4WRoHk5mYHRnzcLcFklWT/SnCJ81FIKCLHwR+bf2L5pSiJBih0vuUoEFA2EW/lfnQ0uooNA/3gSsXPmLfTb3T1cQ3Q0e/cAItIuGpryhiB79tWDGggw7UCnRR7BF6sm7/0oc5HV9ab/AQwF1xps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5wQWQey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5wQWQey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D824EC116C6;
	Mon, 16 Feb 2026 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771252403;
	bh=tdvq/uSw/SrS/YKQsh0ba9OJ9N9xO33wfZZWMx/DXKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d5wQWQeylbWgP1GbWxstrqs1FzxRCEcyUhbch+SYWqRkVL4z4smlWATiKCX0WGcBh
	 rVa6IM6OafPQkweBeAfihJeX791duLHNUzv5e8UwO8l3qAbaD+ygM6w0lgW6QXv5xw
	 5cDDCWi1hUfHY/OcqwiRsMDwGzjX41/9L86GxQ6hGAnVIubw2X3QNwJzRoEnkvFX69
	 lDQOCR82mJsr704qxan+aFzr887YTawp8cDI6Ebc1KuG0TeQY9Xyb3MqyJvPrKDUEW
	 kwGlv5OqT4T3p5PM+A6Mefxo5UgDuJewImoicwptL252dgw664IgusAfaacQmuqfQ3
	 yNV5peljAVPiQ==
Date: Mon, 16 Feb 2026 14:33:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
Message-ID: <7dfd0e63-a725-4fac-b2a0-f2e621d99d1b@sirena.org.uk>
References: <20260213134708.713126210@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3RM9jDFn4myFtdW9"
Content-Disposition: inline
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
X-Cookie: Beware the one behind you.


--3RM9jDFn4myFtdW9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 13, 2026 at 02:47:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Gui-Dong Han <hanguidong02@gmail.com>
>     driver core: enforce device_lock for driver_match_device()

As you'd expect v6.19 is also affected by the breakage here:

# bad: [fdd37e7f30acd1978b8c205b62562dbe7b17b015] Linux 6.19.1-rc1
# good: [05f7e89ab9731565d8a62e3b5d1ec206485eeb0b] Linux 6.19
git bisect start 'fdd37e7f30acd1978b8c205b62562dbe7b17b015' '05f7e89ab9731565d8a62e3b5d1ec206485eeb0b'
# test job: [fdd37e7f30acd1978b8c205b62562dbe7b17b015] https://lava.sirena.org.uk/scheduler/job/2457262
# bad: [fdd37e7f30acd1978b8c205b62562dbe7b17b015] Linux 6.19.1-rc1
git bisect bad fdd37e7f30acd1978b8c205b62562dbe7b17b015
# test job: [f7a05eebaf2882496333b04ca6fc5697be454b29] https://lava.sirena.org.uk/scheduler/job/2457550
# good: [f7a05eebaf2882496333b04ca6fc5697be454b29] smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()
git bisect good f7a05eebaf2882496333b04ca6fc5697be454b29
# test job: [446b9894f78d8b8ba44628370191593e41d96255] https://lava.sirena.org.uk/scheduler/job/2457610
# bad: [446b9894f78d8b8ba44628370191593e41d96255] wifi: rtw88: Fix alignment fault in rtw_core_enable_beacon()
git bisect bad 446b9894f78d8b8ba44628370191593e41d96255
# test job: [1b3bc6d65b96f215b17512174d20a045423f6d52] https://lava.sirena.org.uk/scheduler/job/2457672
# bad: [1b3bc6d65b96f215b17512174d20a045423f6d52] crypto: octeontx - Fix length check to avoid truncation in ucode_load_store
git bisect bad 1b3bc6d65b96f215b17512174d20a045423f6d52
# test job: [a96368be3ad4b175cb3f91323b686e94be00c930] https://lava.sirena.org.uk/scheduler/job/2458025
# bad: [a96368be3ad4b175cb3f91323b686e94be00c930] Bluetooth: btusb: Add USB ID 7392:e611 for Edimax EW-7611UXB
git bisect bad a96368be3ad4b175cb3f91323b686e94be00c930
# test job: [15c160f44ececb2caf42a5d6508991c31d73f59c] https://lava.sirena.org.uk/scheduler/job/2458104
# bad: [15c160f44ececb2caf42a5d6508991c31d73f59c] driver core: enforce device_lock for driver_match_device()
git bisect bad 15c160f44ececb2caf42a5d6508991c31d73f59c
# test job: [d7290ea01ac970dc255508b467fe0016d02be2f5] https://lava.sirena.org.uk/scheduler/job/2458145
# good: [d7290ea01ac970dc255508b467fe0016d02be2f5] smb: client: let send_done handle a completion without IB_SEND_SIGNALED
git bisect good d7290ea01ac970dc255508b467fe0016d02be2f5
# first bad commit: [15c160f44ececb2caf42a5d6508991c31d73f59c] driver core: enforce device_lock for driver_match_device()

--3RM9jDFn4myFtdW9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmTKqwACgkQJNaLcl1U
h9AnuAf/Sk6iW8Jk7tATGvH//wM5RThppEJZyyW8c0zJj3crXgaf9vDi7EFG2Wec
mgbanCs3El19r3QJ/SKmFLNtg+4XeGrK26yyAVesHr4KD8oy1/YOPC5jHhf+R+fO
Mt+y9CMn72mTnK/y0Pkt+tLgZefMgAqsHayemPc0I3RngF7U4zsi23dJUkO53lkO
Xp74trz2duf8cElYMNUwLQay/w/5ibYwOuqE86chR5cl+6ZKyLzPCcxJmud5fSDl
J6P/6kesuOQZEXVYLWbxIyCr/fyEJrEvblnDt3d20y8HabiKnuvrwFgzoI4zz2iu
pLnnedbZlGd9IwqNxnfXFeC0ntyXsg==
=rvTl
-----END PGP SIGNATURE-----

--3RM9jDFn4myFtdW9--
