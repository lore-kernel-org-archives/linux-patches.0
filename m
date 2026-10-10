Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5944A48167A
	for <patches@lists.linux.dev>; Sat, 10 Oct 2026 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791638968; cv=pass; b=eKUkbZC/vCLQkm9AmN9zeopGoqqMgl6kbGs1eoOt3OksUEM1Ky+dztr7jkbQ7R5mQ/SiehlB0CrLlykr+zSsEcQCsVHv2PA4VZ64VUXZlxZloUvN0R2Rf7ZTt8TKyzxSWwPbjJYbWiLtR+NwwR3ka2k0eimvHpF5dZuG50j61LM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791638968; c=relaxed/simple;
	bh=0mOLJ1qbIO4bHtL723mklyC/FW/EWWw0glxLKNa5KhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qNSlfQBPcwoV3vo1vB9MctDNbISQ1sEWzIqbwDnCF/aOsSoUCwVz/pAviRrYzJI7qrftCwC6JJXk+bB7waL+1M2/GiT3EUdPd8+ksOCOUeY0Gh9Z5UOXLNiBekZQV1k8kEDzVBkGrjTmMCMnZbmj64d/VVFZPQl5hFXS70C/DhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=EpodbYUd; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="EpodbYUd"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2a4e013a44so93118466b.2
        for <patches@lists.linux.dev>; Sat, 10 Oct 2026 06:29:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791638965; cv=none;
        d=google.com; s=arc-20260327;
        b=nBqtgtpfTVSekqU003lUoZRw9AdfJYheW+A+aH/t1/nqRiQ6Q/BlIYnuinIONzlB2h
         Gpt+CtxkhGW/AcbpF4gYsUxyUf0oMu/ZHT1lQHqhmOUA1wtBbBHr0ifHlGWBvAszD1bJ
         pISnxDPVobVjY6Xd9OYD36T10xVwQA4SMxGSRV3zPqySV2g44kAoUJLKd54AUxLBsU9D
         PG7X1iwCeedRFDxjM/k8/hydTxZFnzQyprn0LSPuTj2oGpqBFsR1HpL+JXh3RNzlPYZp
         OUAwXIlRfYoFbJXc5dEsojYQ+NJy0aYxNXIzEo85cxtysxiBO5C4oZuQijC72UILEpMk
         xKyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6/nHQi/CMAK+j6F/l0YNH4Qaf56yMgapiWA9WJPD8E8=;
        fh=2ggB1jqzs3dNH2arLeDp2ByfhczyYKRW34tkJDbDU1g=;
        b=LTYLZFJTeBokDDDCiD/acyngjKXlzcZtlnbxLg3X0XgUHEEt0tmmHjgcepNE7vvEzB
         4EgLjVsy0L2biM/UyN89cPFM4wObGGG1bfWAnG3sNCoY/kES0Wz39h0vbOwAv5zD3ogd
         LeS1qLvXee3MvwEXUhhz3GBnCRIJob5GSUrWdbSv+ekCelYby34uBn6XdT0RaMK/5xv5
         /395DVfv7aemBjxRLKds+BEywhqI00zcBnwIGhNnin98htJbXlgR1MBuFlB1gZnxBlKP
         PgYm0k3hVGdJO3j6+l1ih7V0t6Y4JcPH9eIfBQxCkGzlv+y+1KRNy8NpU/ksE0OwHWDv
         FqGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1791638965; x=1792243765; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6/nHQi/CMAK+j6F/l0YNH4Qaf56yMgapiWA9WJPD8E8=;
        b=EpodbYUdcwyglf4g7NB6K6f1e1utjiJ1ZeNbGnOEoTsnFxmlqjCi16kp/Acb3CIh2r
         6MC2u346b7OcQYH6v69ETfFvlWBRUxvmqAH0LtWe7jnAaFPasMVlzxUmRQp1R0OLQtTa
         +MT4d6knOaHfGDwPL3hepC/KOS1qBiScyBaRv4eD4wcFtwK+ikzpT/DwaIU4omlnEdR4
         xqxpwX5iBJGt/AhRRQY3TXvhXvRJiracqiNJXvCFZaGIRZ9gmQSemWnKQtwItxo1bCMR
         CzVSAy0rrHL4OEdxf+vM6i24KSLFyGEFHMiga1nfnCY6/V64eR0ucMGKgnUKk61BTo4e
         3zDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791638965; x=1792243765;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6/nHQi/CMAK+j6F/l0YNH4Qaf56yMgapiWA9WJPD8E8=;
        b=x5NM9OAE37McE6YEC37qNB2s8iVsG20HrCgoSAar1qpu8v3N7RB79ayc7m3CMg/RZv
         CfsQOR/qg6NAJU8lcJ+rRCzphgRmC4oMEkSwxN4aLHgPKSzDaPM++uSzRJQv7A5PVmPZ
         a9zyDDL3i1Ocz40L3BHzgYZ4glYil7L4PEuH2PzytsNEmz1EIne8xisSxVqeW+oHXtyb
         dHxiCJx6NEYK/iyQj4ovc8Y5a+UT1iPjED8HlHMIEkQRB8Vce7QSO41i11q+OmwyxfAr
         l43/QCxzn2Mu0L0FR9vcQm7rrq/mxBh+IM2gchEdhOyEiv/GkuKWU75GTPQKEij9zakR
         DypA==
X-Forwarded-Encrypted: i=1; AKwUvBzAGQ8ikMGDYRTu17svDY918veLEtBibClJUIut7pc3pQ97bKmmeEhTeV5UnieLMzpWD6bUmL4L@lists.linux.dev
X-Gm-Message-State: AFq9FYLwRSYvUFJB0jAf48X9s7wJIhGMlSLvAxMkf0++QHLlKNVS/HEH
	tbqqbzRahoDqdo5RO28/mgbRwNlDJKDwdk5D3vWIgxRyYBImiXyWNi9NaI7Q79sxAW1j+AO85VN
	38ZVxPsMF/JoN4rLNY8XI5Zg5nLCe4O+c/I5ZlwQG+g==
X-Gm-Gg: AYBFou1rUWOEFh+446fjpMC331CJFVjBQK67u0H6V2cKmTDftpPDbVmq0WSGDP6bE1/
	AT3kSC253jJiUgdbCeWYSYRljKq2q+dZUxJDXum8wsYXOqGO/J8rOZWUc0TGE6kLkuFC6igt7Rl
	YqWA1VUhzDtLtAMErQbvxQE+55M4s71I4HqTYeJM/dEiUGkkPmE9m7y6lj45TKAiHDPYtTvz18P
	4IrTXbqHN4FSp86N17My5eS5yUZwNB7yiF2D3+qI/4t4RpvUXU+TNFKdnNwCyFSrtbugT6P7C1T
	aUCq69ObiwkLZ1yYnUbxbcyAVB9JJCX+cqFXCinPj8XTZHV0FL3YUaA=
X-Received: by 2002:a17:907:6e92:b0:c29:6400:ef8e with SMTP id
 a640c23a62f3a-c31aa0098a2mr468624466b.42.1791638965252; Sat, 10 Oct 2026
 06:29:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009140946.008206689@linuxfoundation.org>
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 10 Oct 2026 22:29:08 +0900
X-Gm-Features: AclHuK9jyG7nhFSraKVNersbzp_MigR0JEtHr1nx66h6cqyz_SecNiHhQNS9bdk
Message-ID: <CAKL4bV57zkwfGiTzGvK5Ho9AWVJfMamrbzOctPh8RkNKZ3339Q@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Oct 9, 2026 at 11:24=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.10 release.
> There are 428 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Oct 2026 14:08:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.2.10-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.10-rc1rv-g77b730c57839
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Sat Oct 10 21:48:22 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
