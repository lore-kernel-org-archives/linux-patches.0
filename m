Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF3A38B7D6
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 04:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769054877; cv=pass; b=fAt66koGuxlys6PQHLVgdLMhztZBWsIo4Bu+EJh1LuDukFy62CfiNE98O82W0Fsaxlhk6IGIgSW2CW0diiZlrCtDd7sKTgTpIM8Sct45Iq+i2HnmlYkY3u1rs1+pdZTHKUvsBwdzJYQ4ShEJNBKDXl/JO24esIwslPUlCM4vgOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769054877; c=relaxed/simple;
	bh=zOEKbmOpIJoYf0QX2Nc01sHC/57YLEFU0c56dT9X9Dc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PCKd3+h/ZW1nuhLCKMKVe4v8lj0ElwGIe0bqjz5TFjmjj9f0j8YxnRZnp3W3HtC0UUXOfXUf5AuaqOBPddvZD9AkQU/N83wy2XdLxYZ7uLWSEZTe/pPi0GTdN6l3HQwrK9TVoYyC2xECfn0MLh9NeqfbPuh//hpszLmmhzBRFSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=YZGlqi0O; arc=pass smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="YZGlqi0O"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12332910300so1453219c88.0
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 20:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769054875; cv=none;
        d=google.com; s=arc-20240605;
        b=gG2OECv1vFc4FHaOVVp/Zf+7yfDQrHIchKDZiiMuFIYpPT/SX/Pk0xOWCJGGB/3GWg
         E5E4j/joBHB7tsV+Sq+iZao0cU5ZsBuy33SD3H52geXXONunQANsEi4gcmki91fg+TVE
         hN4DPD0bbyY7jnm6G5wrkOC1LBh41T9KYn+vTLPK85P994e5JNyrAvoIsVARL4nnMf58
         ht95Y+KsxW9cQ8+LeEjIrWuEdWN3LHyeg4JiqboW+PJOJXvAHQL+89J4YpofWKLDhDie
         39vykbHF4IqD+r8c7lsw9+/irbvgrtzFXxWids394D5/GCZtFvqPuqXAuYXTNz8bjG33
         fxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9pCTvGEnBVVPW1tjjQf5zQXP0S6Qi4+0eKihAsvxNO4=;
        fh=Jwh9ruxgcI1RMH9R2D2I1SfYgvGM60tBpMWkEbtBbQM=;
        b=Xiq9fTEP/ADzFeSdaR9PLiPFYEleTxNvk+tebRofVu7i0Ha3hmmz6yc4Ou7HQm34NK
         wMrpNSZ0Dh/9D1bv0VgY5zAwqPZpo0Z4eFGWyLGM/Aj6h+ZDkdel/U5D5ip7+Rsfcy5T
         uewgsgWgsYOYD553qyoadVf9m7SlVDiuJgDTegCSegiLSeY2zP0P5lj6I3oudRXGyy4Z
         R3Jx+hvzDlLG+fElSbpFKBSf2G00/feyhiieXViP1PLgBwkvDGk0+YMpgE3JBaNURKRr
         LHfipPWGkCzISE0e3hr/VULm1eYkQwGBoQSUOdOI44iI//tsneMDom4qmyCI+3JIpeRZ
         h1OA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1769054875; x=1769659675; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pCTvGEnBVVPW1tjjQf5zQXP0S6Qi4+0eKihAsvxNO4=;
        b=YZGlqi0OWAzrrrjn2ng1SCOrOIZgBligH8VEAAoWP2ciOITQVehNQQbj67LxefKO+l
         HdgXWu2roUune9fdHhNwkvoNerJ414YfK8aaJRl5tQJKDyL9XjL0nnE+DfmCiOPc/EhZ
         muKkVS/tuaM2ylijao/wwmGPT3oYymVRHgM410fYGIV5qRwyA2f4ed82Q27qX0Ep3tQ+
         aMimrWHO4aeir0dRzGrwhdkKJCm94iW8i4LYnG/cbOEyh3NTyIaEHPtNLi8AVSYYqfdl
         cT/c1VOoXUg+xCgcNsweP2oIj91wlpAP3zyJQlwR89DLvG7wmA2GOXw0nyTEBIRkJXPS
         2QuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769054875; x=1769659675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9pCTvGEnBVVPW1tjjQf5zQXP0S6Qi4+0eKihAsvxNO4=;
        b=IHWPQEfcpNVdM0If0n5tgnKlRNze4R8W6lMEM03qEkufYVT/MjDvadXtbqBUY91Nkg
         mBQptjFX3UdmNRRGvw7ZwybzCXCKz2/B5rGyb6IaNMGnC7afu9cqTKAI0brHT0OVtHnu
         jBR+EzkP0/0P1MQ9Miw0u/q5bWGWUg8ceJdqRn3xb4me8Y54eWGnaS10KCd+XlFjK5Ky
         LphE3mABafW+IJtYEWo1NuUxdt7v6uX1DB9YMwrBcM+YthCfWS7pSIGEhRKhykA5LpWL
         9zGZyus2fWwhBgncpa5mRlAh76FFUgb57Hnmn+m3T8GJ1JdLi5UYpKRhL1BgWjEkoHNZ
         Uyew==
X-Forwarded-Encrypted: i=1; AJvYcCXL2SD+W1hx0iWIGVcrFqcxB1sYMd6fdcWuBRnIqKOu/G2GrQLeZ8kXNj/Ufi9gSbvz1xEhzQQm@lists.linux.dev
X-Gm-Message-State: AOJu0YwenaNC/TcBu2OrmvOMP57z+IVl9bBbOR/TYP0uEYM2kQZCrg+y
	iZinPnB8GAwjxRNsIieMZiVrLS11ZiJGkgWC07/nv8afkneFNdfKB83QnrDsRhur1S8Pn4OgYs6
	2ZsotvgS/4nsI33vTAkG0ugSMxfwfJkT5JHEMhwdoUA==
X-Gm-Gg: AZuq6aLx2vTg8AbX1tanEDi1+g5HDSCoyTx5p9dWuiNTCZxMqOswgHX/C2Mn+1nAYfe
	vAzJ6LwuVoJ7YQRusfw1Ghili/JyayC0mpBd9S2AlkWMXd1TdB/iRbpV9FjDn4IsFXqwenv9ipX
	DN0Tumvs8anyRLw2IW/pgSH3kr/gfgDViKmj1CnLFcY4UwOi2EAUS9JVVq333o2D88eE9Azo7rb
	hq/Tvo9Jrg8ByNXLauJTb2UpKBNr5/gzxV8oQhB8IifeeuRB3UzlNyEp6vdQyZCMDCjwd3q
X-Received: by 2002:a05:7022:225:b0:11b:9386:a3cf with SMTP id
 a92af1059eb24-1244a782252mr15839946c88.48.1769054874920; Wed, 21 Jan 2026
 20:07:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121181418.537774329@linuxfoundation.org>
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 22 Jan 2026 13:07:39 +0900
X-Gm-Features: AZwV_QjtMtKm1PVMKEeE5bHzzO7zM89c8bLtGqGiKQEvR53QgYUn7BkMdlg5ymI
Message-ID: <CAKL4bV4S-jaGVJ+TkyabzWWraUyJ+-5b1pAwZfB4s1UxRuBh1g@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jan 22, 2026 at 4:38=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.7-rc1rv-g28a73c31d7f5
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260103, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Thu Jan 22 11:47:11 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
