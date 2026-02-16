Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D0029D26D;
	Mon, 16 Feb 2026 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771252217; cv=none; b=T0Lnii5dySYXft8mXQjC2AZ5Kwwecaza2NmbFWeVXFQneOd4IfhQ9l7r1thWAPi2pLrXLPmA+iBTUKu3VAWrHvmqNrIypR99Lmw66nhnmu0UDVnZY0gR1fXFeHmfo0hrceNvaU3jTKRWr/n7ETm+4vKoVcQ+lYZ2WTP3Ui5yiC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771252217; c=relaxed/simple;
	bh=dk7KETQ+jdTJJ4iRt8klYdFr2UEC6Go6Y9+Hk5VhyTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DC1Px464lrt0P6U3fCuQCqeEIV7x9oiHDd7UMV7S9ku5TBlq+rSFuOWwcCPtSxS2bdqA+huqs5dMaU89bh9wOvDDeVoKtexdBuzIjSyNkpcSC0JTTRT1p0Qwc3cg9a31RMW/FyOxK7er1DbotuVcQIvPJhttguuBImMayH3Ll7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NUHN1Y49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NUHN1Y49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D280EC116C6;
	Mon, 16 Feb 2026 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771252217;
	bh=dk7KETQ+jdTJJ4iRt8klYdFr2UEC6Go6Y9+Hk5VhyTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NUHN1Y49ZD4qhrzOCneXQ7qAwmggCFHsuFykwxmDqCCv3LNjznxzDdKpAfLJCaFhx
	 d+knq7xIyE+gfUB3+lzpHH2XIgPyjRxNFY2TMesS9P+r+DaFEoSbt+FjfcY8nJiytx
	 vfd7r49j5rrm2MNK7kPjJdPJTZAAvVffLR0JmStwPEjoaWRNlrc/I8TFkEBhFrt3LC
	 y+Xnv8M0Dxk6cmFgYFyApcdNccvKDtGv7XaBzwqLFjMXZrfSm4U7RTYP5/TLLu4cLH
	 /IZqGrfIWjdQKYYbDr6C+WZ6jDK7JmqLr6yTd390/DdHrA5hb4SGtEXuCiDYiMdwTo
	 ZecB1caGBXlAA==
Date: Mon, 16 Feb 2026 14:30:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
Message-ID: <299bba39-aac3-470c-ac6d-a91c6f385a7a@sirena.org.uk>
References: <20260213134708.885500854@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CB/aoQ83BkUT1eDG"
Content-Disposition: inline
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
X-Cookie: Beware the one behind you.


--CB/aoQ83BkUT1eDG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 13, 2026 at 02:47:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Gui-Dong Han <hanguidong02@gmail.com>
>     driver core: enforce device_lock for driver_match_device()

The breakage caused by this commit is also present in v6.18:

# bad: [1dd43fd284b6ab499dac1355db7b07d12669f73b] Linux 6.18.11-rc1
# good: [41cec610f690603820c80c4871dbb55bec77b9a2] Linux 6.18.10
git bisect start '1dd43fd284b6ab499dac1355db7b07d12669f73b' '41cec610f690603820c80c4871dbb55bec77b9a2'
# test job: [1dd43fd284b6ab499dac1355db7b07d12669f73b] https://lava.sirena.org.uk/scheduler/job/2455845
# bad: [1dd43fd284b6ab499dac1355db7b07d12669f73b] Linux 6.18.11-rc1
git bisect bad 1dd43fd284b6ab499dac1355db7b07d12669f73b
# test job: [089bf791a33e50d36076ea125c4e22bb1c2b5aab] https://lava.sirena.org.uk/scheduler/job/2455946
# good: [089bf791a33e50d36076ea125c4e22bb1c2b5aab] smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()
git bisect good 089bf791a33e50d36076ea125c4e22bb1c2b5aab
# test job: [e18919e76dea3e81777152e8b1f1cb372553980f] https://lava.sirena.org.uk/scheduler/job/2456117
# bad: [e18919e76dea3e81777152e8b1f1cb372553980f] wifi: rtw88: Fix alignment fault in rtw_core_enable_beacon()
git bisect bad e18919e76dea3e81777152e8b1f1cb372553980f
# test job: [0cdcedf25f18018967d7e2502ebae5c9dae31f06] https://lava.sirena.org.uk/scheduler/job/2456413
# bad: [0cdcedf25f18018967d7e2502ebae5c9dae31f06] crypto: octeontx - Fix length check to avoid truncation in ucode_load_store
git bisect bad 0cdcedf25f18018967d7e2502ebae5c9dae31f06
# test job: [347b70a70ac75713a5eedca2ad8dfd8909568a88] https://lava.sirena.org.uk/scheduler/job/2456864
# bad: [347b70a70ac75713a5eedca2ad8dfd8909568a88] Bluetooth: btusb: Add USB ID 7392:e611 for Edimax EW-7611UXB
git bisect bad 347b70a70ac75713a5eedca2ad8dfd8909568a88
# test job: [3a565630eb78e6417cf31027126af35ce1abb02e] https://lava.sirena.org.uk/scheduler/job/2457270
# bad: [3a565630eb78e6417cf31027126af35ce1abb02e] driver core: enforce device_lock for driver_match_device()
git bisect bad 3a565630eb78e6417cf31027126af35ce1abb02e
# test job: [779b9063ea1a0b8d568a7f3f33f9bafb03f49d53] https://lava.sirena.org.uk/scheduler/job/2457699
# good: [779b9063ea1a0b8d568a7f3f33f9bafb03f49d53] smb: client: let send_done handle a completion without IB_SEND_SIGNALED
git bisect good 779b9063ea1a0b8d568a7f3f33f9bafb03f49d53
# first bad commit: [3a565630eb78e6417cf31027126af35ce1abb02e] driver core: enforce device_lock for driver_match_device()

--CB/aoQ83BkUT1eDG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmTKfIACgkQJNaLcl1U
h9DkTAf/WMQ/MeBZUk58k4tX92uQ7qVI4SY08hOg7DDwsvMZxnJCmNV6ziQ1ocow
tRnzo3yLAZ9mkPY2q8v5Cj8zSWZp+itv6dauVpvtoatVGHeWIAtmzH15G8+Qh7Zr
uKnFRECjMe/RQWeGQOpIWvw5sjom+6NwC0MGrmsNdVxIvnoc6TqXMim4thRC0aM1
uZQHH/tgC1ZSNA83BXr/O4Oiumk4P1EAw4ue4iIiRhpMZnY1xU4caOm8NeLmQ6mJ
O3JNBwxDKNhXaiQaTmCOyQzF5/g6+pwLLMOhJYi5LfXIbvrT3ae35OgjKpW9QJzD
tgnQGKJBgzI8szH+F0e1srxKawhkzg==
=9R51
-----END PGP SIGNATURE-----

--CB/aoQ83BkUT1eDG--
