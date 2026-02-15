Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C04A548EE
	for <patches@lists.linux.dev>; Sun, 15 Feb 2026 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771149183; cv=pass; b=GtdRyDrqTGIHncHxpVNpUlOXoDiD0Ky9TsjAt9M0phxxvevWjLzGaYC9AcBdXrYfiOurgia8r7Vr8R5xUifxjlieBx+EEMsGUVT0CCPMZ/bheXMHdLIeYoqxPDGSFtUj7xU9DgI6XEITSjA/KeEsdNn3CY0KKORqaA5EL11yqJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771149183; c=relaxed/simple;
	bh=kQikKF6juBdGKxuw8IzgwBn4/K2a8sJRjg4e9moexBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Na46KqQQghqqD58245vNNduwuOyATZOg9FLQNZ9P8LABQ5N8o/dR4wAufjOIJodm5LNkvN5+V8DjEC0dR/PMbrJwN5SRZ0OkNvz2Sdpo+nc6OkJzZKDuqHFKQ8ASu3tiEQnom7nXUVpnOrN/n+oIYNFhPJ1S+JH8+7S1NVsXAnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M2/mX7zt; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M2/mX7zt"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-386fb2c31e2so16295901fa.1
        for <patches@lists.linux.dev>; Sun, 15 Feb 2026 01:53:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771149179; cv=none;
        d=google.com; s=arc-20240605;
        b=cyJ/wKdzXjBTX/VXBKXkv3sGwvUSUrmPNRrvHssMcMmGR5opcK7eEkxm/SgddqtuUG
         wmk0MMYJNAKwnnOFdL/RhAWmsiWh1jR9Ple/Cd52qdbFOwf7cSO1xp/fnggZZrhwVA1x
         3/RTaOWyhp5+B9CVm+u2Kt6wQjU63TT5/Ov2Nr9hvWRriUyUDFun1ThS9OaFboisFpYd
         nyjs1nU86nm3UALFY2Qb6RdnZuF0IaOtwvsR95IcWuv0QWnZUABGJYmqTSs0FVj9bMUN
         pT7zDy2IL5gvlPvneQ2cWx6Z0/OGxdUm8FkCLxljfSi2IWmvB5GKS2f9QieGXRB+us5P
         XnZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iZyRXh8wmezgi23bMQ+xFQaZsVQ+vGJeFePHICiWcJQ=;
        fh=1K2Jm6uQXueTWvJZ0htDeJynrvLbYS3DtHLBVYJKIMQ=;
        b=H2Cezi/gArQd9v/PWGOv/D769qpsp/TRPw7DaI8VlxhtbjOlgO+MdBjao88u8MuW0L
         u3hG8oMeccLXOfJd7fPLyfqoS6hZzhZPz6IL4Ypt6CoXX8tBYFCpnsLfeLQQFU3YBmPI
         faU435gmeKR7kDAD8+9ODeSxocXW9AXXhniKW7L354usprSsj5JvBcVHfJl04uJ0qWxQ
         yo7rxMKm5grHi/Kc6ICmA+q2bcDwvBmzjZFb3mOMaVIps2XpMdM8tG6+xjaoQfwKOOJe
         zyi4FN2qSddYfg80IUfvHhyu0eSbl1TMHq8wPVRStxSsTp1NrywFSERQWxV0i0R+bhz1
         DScg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771149179; x=1771753979; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZyRXh8wmezgi23bMQ+xFQaZsVQ+vGJeFePHICiWcJQ=;
        b=M2/mX7ztLfwKUlgDtba0mfyDV+8A0qfjcNhiWHOidOFEG4qV/3IyuLg9UjkMamX7M4
         0VyVZhtCRvlv7UCZ2Zlae1QLMRtpiTeuzDOFJ4ZGzs7qUHvsWuN1EZV3+0fimynOuCzE
         y8f4/hJJ6/fBpLUbuuJWFVx8plZwAZS9uQW3TO3R0i2Gt3bg843JJgykFoWa7k3coFz7
         tb4jnIj69KL8mPMC4VT+vamBr9MJuv8hf/etVsYsoOiIDAFCkbYwuWRLO9oguZdb11Ds
         dEWmXrgeXsxa5znKVdj/d+rQRUBlQDBP4E2rb1b7LaTLcJv+WZlCcozcyfue42WFaGWs
         XLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771149179; x=1771753979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iZyRXh8wmezgi23bMQ+xFQaZsVQ+vGJeFePHICiWcJQ=;
        b=HO3JOuTLyV9QX3K4JsOSamSyUqHtCj+TLqr7FbeGDWIV+olE90BCWNRtJt8luT+22u
         napvqUHhAaYFoN/uszRO8NfLJnU78cqrFqSXJPc+TXXLeaG0xD+E2VEozR14ef4FGY3k
         9A8uUUxDugvy2rrlKXGYUeM+zClLnCntga0gYMCFHiuquZv+3isB2/5NWsVWIAxUtUaH
         piPKQt+g3QbrRhjPmTnlxP+FAtxw66XjEumDA4imI39jAdSxhZH/vUE1peA/txBklyv5
         7STT5/kL0m8umS2Y+Mh2VuBXYxV6wYEzf9yaHjJzhjqXBc4FMlMztCXRZVyP12WcSAkE
         pGng==
X-Forwarded-Encrypted: i=1; AJvYcCWGeKolx3N5clInd6YgFilh4lN/axlpOshNSnxo9MK4D720ntRPfInC9hFPGZvuo0Iop9mSk3RH@lists.linux.dev
X-Gm-Message-State: AOJu0Yxajm3t573X/fNFRsq43xTjnidbfYdEhgYzvjPdOAKWneSXlelI
	7FkUjbm8TUzGPc7glNxn2Oan9rsGXChM49V9XV3zLYubyXDgTImrEVcbIYvu/JxWPDSxm2HQDjq
	Y0vrzrU7M31M+lGCWX/HD3isIlyuE22c=
X-Gm-Gg: AZuq6aJvPmfCgYGn5P54CDKmzdCMABGsUipv9R6KX6SYFQrGbJfA999pp+gT9ltHs6w
	St+ixFysHqVveS/Yer4PKkllmQLz24TI1GzwAbv+r8Nq372OGV6J/LqNn6EFosZ65YXYH4w7VBx
	kTdhbJDwaNC4dTmtpPBUzwKibp83ZvaeIWdBnDbNEmt2sQ2MrP0faeOgDy87P9tutS49Qe0MgnX
	cLPsbLlPeizvuMETUFv6s5vmrS6MBoE3WcoZ/AfcobjTeEc1saYihNCkVSDtX8Y+YT0Qc1iRXi6
	lKPiUuoyRntAFWPIsDUXYVCqC/WQsENeT1+8LkLY
X-Received: by 2002:a05:6512:3f0f:b0:59e:508b:c00d with SMTP id
 2adb3069b0e04-59f6d38d4c9mr1367158e87.51.1771149179242; Sun, 15 Feb 2026
 01:52:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260213134708.885500854@linuxfoundation.org>
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sun, 15 Feb 2026 15:22:47 +0530
X-Gm-Features: AaiRm5228V0C2EobLJmqGCpcjuPo_PX51gEoGd8XHRSjnUrUWBkc7U1Y2kcKbNQ
Message-ID: <CAC-m1rrHNiCp1sKgE_V3++fHBe7nAtMKmMneZmQ48MBDBRA4ig@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
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

On Fri, Feb 13, 2026 at 7:22=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report of linux-6.18.11-rc-1

Build and boot tested on 6.18.11 using qemu. The Kernel
was successfully Build and booted in virtual environment without
any issue.

Build details:
Architectures: arm64, x86_64
Kernel version: 6.18.11
Configuration: defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit: 1dd43fd284b6ab499dac1355db7b07d12669f73b

Tested-by: Dileep Malepu <dileep.debian@gmail.com>
