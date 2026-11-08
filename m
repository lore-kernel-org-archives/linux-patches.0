Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794181512;
	b=tRLctkW0axScFxcIFAsSc5o+rehELW4bJX1ie7FFkhAdEpEgoBgchBIXr4cUDQe7gJRV
	 GB9GN4XmxLeyKRihO0AyELOrnH0WkX9phq9DEgW4B7nzVFcoRtjz45EZl7lRw2GR0KhmA
	 lAERUbMoMmZEBUKFbIqeDg9IxRrSlp8IbeFZcKHVqlhVoAUuEuahD5zuhAgaP/4tzNaR6
	 jGe/Yi7IloqMYxA/ZqsnO6aBgnF7fXLtqxV9HWwzf/bERCLwue3h/ZgEQyBVppZ1VUfVy
	 tw6lzCVTSyGIwE2MtRj/HcyYS5TRIij/egwXR8Ldqzbxgq2Oc0YrWwYH01+KzFqixdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794181512;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=VikSRRRNpdKJE0WF6UFdQBJodvSbYqajLrXcSX/fVls=;
	b=yjsrJFfHBfrnJ130lWOftkrx6htxq5ZaGunDpF8aQ0NtCdDRgSIaM70OQCi46Zq4TjJD
	 z//qZY5Z40oXOtpd81QHqAF1EFIcz4dkrQ5h0do7RBPVLKj0rpkMk3okVAKRUmyspb3UE
	 oN04z9oT8WM1PknoD+jsaeVrfBrSBM1j1xucKl7HcbxIb+bSMh/RHztDjHoucoRqK/BVG
	 bY2MvWhNc9t7Y/Mk4aB/6pNYV/jWemXuBjpw/5Md1qv6hWbsySgF4enlri/I+REr/HN3c
	 IkEYHrQJMOsxZRertBWgeEamw7HSh/428Afx4/Hp1hfVPMxdwvDNCQdkiK5YV03+eJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxtx.org;
	spf=pass smtp.mailfrom=linuxtx.org;
	dkim=pass header.d=linuxtx.org header.i=@linuxtx.org header.a=rsa-sha256 header.s=protonmail header.b="o0zIiT/t";
	arc=none smtp.remote-ip=185.70.43.18
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120B8606A321
	for <patches@lists.linux.dev>; Sun,  8 Nov 2026 23:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 120B8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linuxtx.org header.i=@linuxtx.org header.a=rsa-sha256 header.s=protonmail header.b=o0zIiT/t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxtx.org;
	s=protonmail; t=1794181507; x=1794440707;
	bh=VikSRRRNpdKJE0WF6UFdQBJodvSbYqajLrXcSX/fVls=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=o0zIiT/tiBwjSHE7zGKqqHB6XIuIsQSY3I1aU6HJmdyW8KD1Czpcev33me2g9BD0E
	 zLGmcUOqUTrZiq11hrBzYbGQyqGDzGBF8321xmCfkla/nfwfpejz1zjb8df6nn2Wo0
	 dk278k1osBlJ/nxNCTdz8axmy2FkXaY8TVeiJ1ewVVVuDP7XZaJACASU4pl3zKqzle
	 i9cHBYY0/BCJyvK3M9Rr2iBPRi/VCvy9OhQA4NHTs66t6M1UZImjo74u5qkB1QsBQA
	 edMn3Fc2Sf3qerL/Vjru8HNGLYmofAWoZ3OjAcUiaGwiRMDjMJLCEm+o/IAF4D5xkT
	 XPZLlsFaMp8gw==
Date: Sun, 08 Nov 2026 23:44:58 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Justin Forbes <jmforbes@linuxtx.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Message-ID: <l47r12UjQ37KpnSfiFLGWoj3CmSMXtXpMu6w_v110bmVBq_CvgmiSZcW-ORmp53F8G8U6dklhzsqXZEIV5O_BNubJnIl30AqXxpL7hiLqWg=@linuxtx.org>
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
Feedback-ID: 225434474:user:proton
X-Pm-Message-ID: af00ea36dc055098ae50b0bf4e714589887acbfd
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Saturday, November 7th, 2026 at 7:01 AM, Greg Kroah-Hartman <gregkh@linu=
xfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =09https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.4=
-rc1.gz
> or in the git tree and branch at:
> =09git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-7.3.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

Tested rc1 (with the reverted problematic patch) against the Fedora build s=
ystem (aarch64, ppc64le, s390x,x86_64), and boot tested x86_64. No regressi=
ons noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
