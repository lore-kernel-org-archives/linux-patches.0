Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13699348865
	for <patches@lists.linux.dev>; Wed,  8 Apr 2026 21:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775682418; cv=pass; b=PaGmoEwK3KC2oW1RkyDDfDlL0z667l0dbX2rih3ycLaHvXZf69UU54KjGxjEUkMcAIoH99Uf/mpVxWwQ8CzUe9rcDIRMcJOr9dCthaGxo/JoNQTl8JMyeuSkuOXBlU5610ai6RFYSN5UW/fP+zu/vdR5WuVyqyZSDtWehS6Vmr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775682418; c=relaxed/simple;
	bh=hYkns5toT0V2D4zbLc6ooeB7MXWi8+6q72CC0Yh9OQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tLQ9KgzrLa+rQVS1ezNS0K/Pq8S0SIbAatnh1SWuJ7dZZwILUf2TjNh/rA0/SQuq7Akn2Ak/Bj7iSw5mPVOGeKosWJS1bMrHSryKy/g/tziBx+VCnITtvjL06rfgkZlV/SGbyujWmHJCZ9L9DUcL1Zsn59XFAiPTJ+kX68e1XA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2Dgwj7e; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2Dgwj7e"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a3d42263e4so191070e87.2
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 14:06:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775682415; cv=none;
        d=google.com; s=arc-20240605;
        b=ZzdGOf/0UkJk5lw6bjUjfuB9XEunpsXGl4gVQB+LJ3PZOGEPcGDeK7pneF4WpRnyYG
         a7FEzxxagx84wV3TP+dnGc0/YQyUo4ME4H30G6I1inJFf8MpA+XMH9hJ4v/cDHIaZrxs
         hBEKiobCVq2akyk60gOJGsWn2b0GlR+WaqfTcIB9sgMzfN4PkxzVPwS0i1S54PlnSFAq
         hiF/tBJwbCzsTF3lswZpKL5/FPKmM0LkzsnhkcqRZZhhbHOkFqLtQp72HsHmHEUFskiJ
         jVH53uEY6wBykwkniYFi6vLOPxyl/icazWv6gUcg3ytpE1e759nZHFEZIfyLMzh8erAQ
         9BKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YtvBDzOl3ty8gCHQBP+mvKiVADctnqQd/26TJDkcWUc=;
        fh=s1ZhOO2gup5LaWJBtqzORAB7z3dXjEdenYAFv6ipIw8=;
        b=bFbZdkyAX8hwPw4Iu0EEGuaz3zjCe027lSRoIPapDdhOomD6AOvX67wvwqT0QLqDjq
         ghdNHNq8h3m0mKGYbjVtmKKhR5Xpp+bLfTwo/VVZzBki+14jifqgDsM0Dbe+lcoK742N
         Rl5hYsFzrreDTGVKlVOZXIZiYii/L3O3snb0itmzpFNDvfk2SR58P6eYhchoo3P/JqpQ
         +SoV7fkZLi/SDSjDB6tQM2LNH3+tb20x8gruppaiXLbj+gGMtxLDaZkxVHAcuPlYVYfa
         N83aANPi0+Ui3gKwkXfiienyLvy/Vkmy6aPDkwkshbcR9JpjbnAFTV9X8FTzCZPS/7D1
         jYOg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775682415; x=1776287215; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtvBDzOl3ty8gCHQBP+mvKiVADctnqQd/26TJDkcWUc=;
        b=f2Dgwj7est/NDtYtNqAbZhkHYpL9BSlGOqfIRizA0gtlsiQKDGE7mb0tC9uhFPCsWn
         DxWIo2UbxxUu+TXXgOuz+hSkQ9fPOzQ91SCAH6ZVb6bavf/bpB67Sqsfzi+r4cc3sZRJ
         fVdiTD+ZZA48S/Cn6CqdaMGVu6Q8F+OSdHvfuaWWYeLj9qTUBbpspKfLtwPCbzYl93GT
         ZP+dhKW4anDlG4rmPPlWqF5GtWmT9gjv3RBtKk6WVoaaEZZSq6MSjZciibAATBgUTcU8
         UjDnf5kjXTUB1US5Gqo2vxKp/vhTuCNT3ShPtkUvYYI9SHGFEqUfhfaVrdDAJOcTyZ0L
         k1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775682415; x=1776287215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YtvBDzOl3ty8gCHQBP+mvKiVADctnqQd/26TJDkcWUc=;
        b=fHT+WNkopfijS5TmGJ0mVn8TPYafqifFGKs9n5anF/Un7cimJ6wvEdZXG+2SllCf3C
         T6QngN6jmY3xGY+mfKaeo0fKOYIAspR62pqJXm9BtWu0xAVmRY5Eo03hss7MjEurmnJk
         8bTIBYmTCPJ3iU2V6FcXIt0OfK2OhS3R64xO1JNCwy7uVH3RnvoGQyNANw85RG6HDbxd
         xOvNm6pLtebvpQuPXsb6XBAmvba51VZih6ikBOfdWXp8UG4OJ8gRjSUiaAflhTiQZ1GC
         xa36DuJ5a08Gy3RZE8aBJqLLbpIQB2E12N3l1ZSRVgBCPppT20VmDshTUFW1/LOKb9AB
         dnVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2+w/Lriu1tFvxwb/3CA5hWjtcSnDpDrqpTz8Yo+3ieagYU6DF4mCE8+KFYyNLs5rBC19sLHyf@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm0oEzOyb92XxHc1GWXVL0drcR+xqp6rBANxcqxFHEcAjl3DHi
	Fn4GilftuP3kNiRKX1ko7UdcldWvIkLiGVuckf4x8daRRjlUTpDmmuUsPyY4vza/yHcrOfqo2s4
	qf6rjDA1i4G6e34jrGP5F2lj97514/+Q=
X-Gm-Gg: AeBDiesvNKKGVX1Ktuvu44BzIwPE6/d1kkEDDvmLTS9eafwizA8bTVnb5oDl0XN64ck
	pScsRa3nPgdeTbDErNypYozfyif13BcWboAyvLPvBR4io58FBSUIjWfDK++CXub8TkL2GYw5ez2
	qpXYFIlG3bxm//vOk7pdz8tzhIRKUnJoZszClSeXpf2770E/fwmLWAGvSytkwVsylnzkCR9e1P7
	75yh/03IgGo7zVUskXft7Ah02zbbLLJKcXFLFzvKmHxTwM39dXf/8G3Ot/yZ5bMUUsTMCU3gzyT
	gdOgzEHuOte5VjZOf7fRLqP3vGVuxSnc/dVtshk=
X-Received: by 2002:a05:6512:3b1f:b0:5a2:b43d:ac47 with SMTP id
 2adb3069b0e04-5a33754efb5mr7172806e87.5.1775682414811; Wed, 08 Apr 2026
 14:06:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260408175939.393281918@linuxfoundation.org>
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 9 Apr 2026 02:36:41 +0530
X-Gm-Features: AQROBzC3WNywR7tJ5aKj3tpHiHnUXa9bzv0i76xR9qfAhm0cn-jnN-xUeeOkZSA
Message-ID: <CAC-m1rqrSn74FVxYpfMB-v15=EgcJG5Rp4R6kAhFw0k3pKf0qA@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc1 review
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

On Thu, Apr 9, 2026 at 12:21=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and Boot Report for 6.19.12-rc1

The build and boot testing was performed on version 6.19.12 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

kernel version: 6.19.12-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 571831a3f83a43f64984cacb7064dc31c25694bb

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
