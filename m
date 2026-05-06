Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7304A3DA7C4
	for <patches@lists.linux.dev>; Wed,  6 May 2026 10:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778063660; cv=pass; b=sB1WvB55TY19kVx19fAGNe/iUapf8i8A9ohgXRkP+xinERqftoW9f7/oI2tdnBdaY8fsx8sZ/XNoD/CeaA0oyc8q48+ofXjaIb1E29Rhnu6RrVDsoXfcmdMszlnOFmwkeOvnz08p4r0ziB/LvGTjS7VF+69c+dptYppGsWsL8Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778063660; c=relaxed/simple;
	bh=ymu/ULNMpf6rOlkJLsdppPQLIdg6x6fe6eAOnsCUVqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RF0qDlPhkvj8W1qr2OY4VcM9oglf4pgwYJAqk4IuuuvMMmpn7GiG4kTOAj7cHL1hKweXUMtXZ6hg/2M+evYEY222BPu6xXwX/GqsHjA8X+xNdJIjYWqgb/kOQ5yWkx/e2A0MPps6GpHInx5a5VRudZJojJn+UAhe2l06HaaHH7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HYzQX+JU; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYzQX+JU"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38e7d983f79so64285611fa.0
        for <patches@lists.linux.dev>; Wed, 06 May 2026 03:34:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778063658; cv=none;
        d=google.com; s=arc-20240605;
        b=J5j4eDeyERlyTMSDnQUPq7KXMpYNUAA/xQ53AiZ4T70TY+fiN78bYHLgMCDEMpogDa
         AAxx6ghdXUnZ4NuH25vja4rCnzbfD/E8o3C1wWS2ZV+1md/H8pKgCbHo9CBUjbkTQY8Y
         zZ1r9G5n+NIb3+FlCzO+od31pnJoS4KPir4Gkof6ucbeieO6OBSu1Mv8sg0ZR2FOUum7
         Q/QSvWFf8yORAMRDP8WQR300n11UWSnVM2HylvbPhjT9x+l7scSGjpEriirS72uaP11I
         pjFYUIsBRghcMhZz+9ynFgJcs6Xpnkl9An1R7nNzPDXhFkcHE4JeLWyEI9Fn3sF1cMvj
         oerg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zu6wn52XuUTERulX1xQyyyKBkcflJXL7rnBSTp2R7Zw=;
        fh=HNiG3BVy65d/HI0qTnhAUNoKwXbSolE8QmuPyU2JpIY=;
        b=E4G5lp74RHM1Y76boTLlvazP4E4rgY8dPAd2jNSuAZesmD4T8SiMd6RKNdN4Fe/4ZI
         D/cRDYbNMfNegehC3xCONq//iCDvxcLdSaeFv8Y47lRyr8j8s/bhzRjs+LBq1YhMYM6D
         0Anr2ceeyvWASwgagJNoDSD02PjsSv0kK1lYTZL1pG1RP3bVUsdl6ddR02h0kJerj8XI
         s20O8t08We9WyhDRCF2ErDJoW3mzNAEBU7WJl+R27SnibJ8V8zM263W+7ROrEV4y1aVv
         RnEOfyoyvIx/IiJqQG5VxRI86yEqYUo/Xt84sE3JNxV1pY5InjBCSwfm5RsB4LtuIO1w
         M2aw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778063658; x=1778668458; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zu6wn52XuUTERulX1xQyyyKBkcflJXL7rnBSTp2R7Zw=;
        b=HYzQX+JUF4EWrd2cUpvs/+g5S/rIZUo7C+hVxeUrlUYVceWc2VUYGP5y8L0a46uTgd
         YajPBQX5Xk0nevw1zwDVtSPwcNJYlHgQh8KUiaJwFx4qhDiQEEgRt0Rl9ABZxPd/Slad
         adi9hM+mwY8uUBc/8A7YESwPPOtFedLFRnNckkXAsGAe+5pjW7AtzNSnpOrDLbFFoBEP
         G6nGzJSk4oHYGQsl09pPrjqpXLlPRjho6rRXBv+DiMDH2hCdHqlu9oqHWugtPp5NWHSO
         xsVgZ1Wo0ynD8935kf/+Vtc93/EWIFZANPRjFrfW1uGh9/jVKMOBeZ7scMi2pAZwk9tg
         YgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778063658; x=1778668458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zu6wn52XuUTERulX1xQyyyKBkcflJXL7rnBSTp2R7Zw=;
        b=ogC9eEDnZT436L9NSj5R0eP3ScpLkEFtxGi4BqL7tkavzYWW7ZHl5pDvCqEVuVibzI
         jgDW0hbnBRFy3V1aePlyGIIyeWMPyP7znwvjngz8+0lziBpDgiLdg/CfcWdsunSEJmk/
         xKmNPWdlpcTJoo2LnRnP+0CMR0oHTEaNn0/GtegASlUjOHr1oBl2vEpTqRjKQEITUYOb
         Yk1hIoVx2Jp79MmLAdIsqveTq+QwqLHTv4RRza0wwocS4sv047r6/evIXppGgS1dD98a
         yboK1zaxfJLSs/pnxR50k5GLd98OWCs1KNX8NTanS0bPD+WjTntDEmEzzkXkEa/hQvXA
         zo6Q==
X-Forwarded-Encrypted: i=1; AFNElJ9CXsG7iY/Z9+j0zno8mCNMajJ2eXVrV7j3IUxMNDyTFCu+0D8ivRrNO2U2RzYtWh83BdvWClYr@lists.linux.dev
X-Gm-Message-State: AOJu0YypMRH4b/O+jZzidfRDiPLmvXFYBipDu2kXu3T1lyGQjtU4b2kZ
	vdXaekU+Kxjp/JmC+zYVrCd2/Nc1Svn+Mi+R3ej4qWpLGnU7nK0EdcUA1T9OBkEXwpgJxohN60b
	l6luh9WoDPAWnf9VaRQHrXY5JvjV5roU=
X-Gm-Gg: AeBDiesMbfL7+arV0pdQzTdtBBiSH9BBI8fSoppMG+NmTyhrRq/5e28wfYSYM8nh4VJ
	7mFwdBVsSOG7cIGpTnC+O3ilNLDP0qb/63LZNBQE0KRnN+cHvZWNAVkkt4N57xkski8eIYYGa6A
	IDy2ovQTAzD+ypQgxkbnalUZzV9qdVD4Xsz3P2zJaCEYP1SUvGvGUnF1Ri8PwRmuzLFx93iWGYI
	dbUNmrEtb7QVkZg8xHDJJlsmMFpnyOr8Zzo78pyDjLyvnwYcyV1HtUaAYsd7Ir7fd/crSuezuBl
	gFkhpJPz7CNYT3CZ7bmZ7W3UCJsEMU77TYPAa7EXWgohPW8D+g==
X-Received: by 2002:a05:6512:4008:b0:5a8:80ce:ba55 with SMTP id
 2adb3069b0e04-5a887ae1e90mr1184465e87.11.1778063657311; Wed, 06 May 2026
 03:34:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260504135142.929052779@linuxfoundation.org>
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 6 May 2026 16:04:06 +0530
X-Gm-Features: AVHnY4K7yxeD5Ig1FnC-1j_hdVDnXwTmp5bmA4Z2kBvlTKJ4EIy7RnQeAUK2Kbg
Message-ID: <CAC-m1rqbchqj0qiYnC6cRuQTpFX2MpXr-D-YXY+KgrNXx=vZyA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
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

On Mon, May 4, 2026 at 7:48=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.27 release.
> There are 275 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2026 13:50:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.27-rc1.gz
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

The kernel was built successfully and booted without any issues
in the virtual environment. No dmesg regressions were observed
during testing.

kernel version: 6.18.27-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: bc63ee3bfa3240cc8657ef3302d0f3923f8b4bd6


Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Regards,
Dileep Malepu.
