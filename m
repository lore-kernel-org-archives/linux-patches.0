Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794709148;
	b=2pW+nWc0usxDBXObaGy0sRRnbeTc+gxWfmo2KOL9c25eOmkxy5mUKOYMZHMy7ciBAQnL
	 JNPQfkl84WgqoLaS6d9c8iMfZRag0AxMq8NneQ9HIAspkDJ8X6GeoFLfVtPPWvp5y5D6X
	 mFlHEagOHjfsqspwDJh3CGma8z1ZomFC5W1i5yDcES04eVyjF7DKULnDZs+RkQE11eSa2
	 U4ZbVwIB7hnR3JzC+Zp3PPbM2Ozeb89iu/+Vp/var7FMHO/lHgjoExOIvqbmjlAF3vM84
	 C28OxgFfwGgnbZYtUoMhL0VLPzE/58S14mWQlXs9GDomWbzVT3FqR+JrOuFbm9FSdxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794709148;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=tGx2HgaXD8tWJLzPKRK3KyrrowTDeb59x5NUlcX5eVk=;
	b=YSyGdUkw9d2qxnc1r0Wzlq5wKLT8fWAJVrFDin9ycIizM9m0ZgEPjtV+T0rxy2U5VWpv
	 C9idS8WHXTUZyODzAJOTW8qKy/z1gtPu+O6ahn8sf4LZ44wr5WGd6FN6Ns51kbxz7Kt78
	 yI8MMlmaBCDgKxKEK4LtyK1g+y+a/KVbNJIimVGIs8e5TOpayltDbBokAryFxEF+1Xdoa
	 iCDLdA/q/JpW+RcPj6NWS2kJ67ehriVcfSP+wBGvIam+gvUCYE5I02YLddE66ebvOyL7A
	 UFhBdWExm6QYrLOcRPnV8iMG6ptmNg5sLS2rIoEaIR6TDjto3FeefTDunIQyrDluLcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=seanlyon.dev;
	spf=pass smtp.mailfrom=seanlyon.dev;
	dkim=pass header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm1 header.b="wlys4W/C";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=vjyAb5G8;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EF9606A323
	for <patches@lists.linux.dev>; Sun, 15 Nov 2026 02:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33EF9606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm1 header.b=wlys4W/C;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=vjyAb5G8
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 94C1D1D00089
	for <patches@lists.linux.dev>; Sat, 14 Nov 2026 21:19:06 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sat, 14 Nov 2026 21:19:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seanlyon.dev; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1794709146; x=1794795546; bh=tGx2HgaXD8
	tWJLzPKRK3KyrrowTDeb59x5NUlcX5eVk=; b=wlys4W/CUnx6036xKG3r7RZ/oO
	48+zds74VNn/BberRAT4nzOBI4xd3u/TEhgqab5cwTUcRC+SfaMA1luodCfhHIVa
	nn7R7ZehwZvDkQJOy5OMEapO66Aoy0CfPgdO146wOrhjqeLvtjztjXKVgS0V4NPC
	RcFLIrpJfk21Ay/2hI9Bq06vUS+WAyaJPwEotbslpwHPTwBZnFCcQ6y3NVHDZgSa
	7z+7Cu/Bg6ctj5CWBmtP+2hPCyAActA5f9Z0YHWaTY6QvZ2BLomKdfrFLNSQ8QDZ
	ikCuGl/VAq31Zvw1ATSLHtRA9DFJARh+UDZe9MMuop+gsqSZrOv/jjrTNJHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794709146; x=1794795546; bh=tGx2HgaXD8tWJLzPKRK3KyrrowTDeb59x5N
	UlcX5eVk=; b=vjyAb5G8CEDOiMRxmF2zd6DcpNqQTAAsDFUbzJJlv+TfgG22+jZ
	FHIse1zyIQjDEjQb7tHWn+DmPtPnMRTNrG13ta0dtnJnz6wlwilLypMz6CvyeFxy
	NEZOtpRCfkWrQPdC8cBf0a0Six7DqwIGzxu3GKPisdBU5XiyK5ApHHfJNkNzCldO
	vYxtniGdxgX1vXy+nzdZCXl0eqlrc8aOB28jLNpk6NV3aFcFinyiZBLP0HgZuuNa
	FEzSAKeNjjYUasltrf40yV9R1e1E7Nh28UnrdQNsz3edzMEVn34/3+h7CtsDS6tT
	RlK17UiNvfaW6HGy8WFWlZXHXOi33Y+3WzA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=seanlyon.dev a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794709146; d=seanlyon.dev;
	mf=PHNlYW5Ac2Vhbmx5b24uZGV2Pg==;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:tL8SojtC+Tn09AUzgLL3iIqN9AuymsOxaAIUewOuAy4ChQT
	ZtBG5V7VpgG1fRBkbJSyW4zDaOJfjJH4A0uujSskb4FWBkFwQ816k/GmdNlRue8G
	qNUmdP9aqrkkdkkbr+rFSsr1hVP/cqDaIILptz1OObZdtYU7oCG4kbzmB8mwUM4+
	PliJbOJd/R1QK13YUFiM5QzW2/spl6CXbrihMY2RBjVD9cIStpdHp+PlS7fDfkNK
	skCcixkoD1MHntYsEEAQr1hP9wRxcW46z7fMExgymwKh7QjatjK/oOxdevfSwG63
	lixc0J5jc2QHuLwJ03x3P4IbSoEwG7WBiBzh6cg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:fvHTB/VARtjAb8cpM7jVMS4lUfi1b6b/7VwgdHWgE0g=:lgBkp0Dq61QDE6qvDvKXakgYuaK3YjZY+NfSYZD3vto=;
X-ME-Sender: <xms:mRb5agIhUweUyWvMnaCB1tGO5rerOz46fn_vZhHzFDQOkLcOoO-VFQ>
    <xme:mRb5asAo6NNfujyUdfenIEl2gAkkXHgPTFrdrIUqRkhjMqZmFUYKD4nAPKcidzRtk
    dAmHLDFl5mqdws5fCG55jjT2M0iin9AR-G4WTzIiOIqnUzBReamPZ6k>
X-ME-Received: <xmr:mRb5asPAiejqjOfsaELihQO8grKrVWSzD3cGkHyK6wV6sPQq6P-k0H8IHM-owVhYYHecUfMVqgL9EdyUh6s7Go6XynI>
X-ME-Proxy-Cause: dmFkZTGZ6wjmFSKE6GiLbR9W5zS99PuKgfflsSuGnoNEeF4IaDW9skW2rpOUFvrhZW2Reb
    EXjMPN6weJs5xgkLYPt6wG6RmA+gkdAe6lhw+isc8tzvgaPj6QY1BOlzFxeZmAHF4Fdyfv
    zATL+p5ChFAxfDqIXuXjuT+dGt3LWEW7t27tRSM7YUKNz7cccmZBDLszZxTwYP1IOO7A7P
    DfUznCl30beKIlmfLr5KBdt0S7xFVoKQSGUmaM16dvgSr65u1ceTylLLbkDgrhmSrqP+LZ
    EHcE5mYD/W9piBgZE3sHRji4+hJNjJCl9V6olJEzO4NezNg0u8KqJTdxqBgObJ1mOHo0GG
    /1otCi46y0iMi8aAh59AhRpJPMbAeU/iXZlI/FlqwHvdIPVH4QvUJy5CY1BEXgEIi55/Af
    G6GywK+0x27S8T1be0TKhnxfXsQqqgzmYkOJKa6lWsJgxOPXDz4SS3KqapGpf3fwvhDWl6
    yjKNYmIgurRD7bWZaamsfqHcPR33mAIPDUKMPCAbto4oZvMAYrov5bYtHH5NEtsDW2CX0c
    wygq2QFRsJQjJPTs8/JlAnQThXqyt1dp5dQkwssay34MJYWeWtWodh8rmwPMaoNx7tHMAe
    jOSrt+Wq+9O8cSdPNG/NRvoAv8Duxze6UINA49xOpPPMp8jX/HV3h2JbKK9A
X-ME-Proxy: <xmx:mRb5ahUvDedMUktY7B9hl7bwhheDgEm4V4nskWi31MQqEMs_w1KqQQ>
    <xmx:mRb5avSisVF4LIq22KR_ASt0GwZQcDYfgUpZBJ2SgXc1Fs7eMjmcIQ>
    <xmx:mRb5an0wVfJGGFecT8riwPAvaMT7iWrDg2sMoRsUbBNknMacXJaZbQ>
    <xmx:mRb5asgU3NorlWjJNhp9CKVoDIGsgrQgjg7uFVniN9uu7pSrE0jNrA>
    <xmx:mhb5apdKd0W0ExtUptjyipjKzCTRwKj7Gx7AKyF09bIen0M6rAyVMUyI>
Feedback-ID: i07c64b5b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Nov 2026 21:19:05 -0500 (EST)
Date: Sat, 14 Nov 2026 21:19:04 -0500
From: Sean Lyon <sean@seanlyon.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
Message-ID: <avkWmLajdYjq5ddx@ncase>
References: <20261113153753.358973689@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>

On Fri, Nov 13, 2026 at 10:45:04AM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.5 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built, booted, and tested on hardware for x86_64:

- AMD Ryzen 9 5900X, Nvidia RTX 3080 (nouveau)

No regressions found.

Tested-by: Sean Lyon <sean@seanlyon.dev>

Thanks!
Sean
