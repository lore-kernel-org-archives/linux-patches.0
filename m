Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9833F483C
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780931984; cv=pass; b=fz3lxHP/8E4gM0DiFfjJ+kVnEASGTwdNT4nQZ5d6fl53kfbgCHSgw4fh33PkCu2j4JqYaXoPFm+lD0iJbiEMMgAw4f6qDkSvvjZv+DFA/ltbqIf4nKdk53lIHUeFDy1AcFp3+9km+LGXmi7jXDi0BPD80V+JcRHxbM0PUVPXWRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780931984; c=relaxed/simple;
	bh=g9C5YtZTmU1NxdMueziYBeIH6PBdski7wanO95VY8dY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jXxYA5Kf55ArNdTcl4sToIJ7hwJKc1juqhmWTjBR/q+S93D18FmwPwKcf67frBOTCVOp7HlqmEVpmWorVcCJKVT6d7pzgmw9Sqa83gWeMTaop6VtGCP4aED7uy80N0dZveAmyp3mO8B3d+b0eN8oHQxy7jpSvyL0lfmJmzOujfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hThoPwqm; arc=pass smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hThoPwqm"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3965f215817so40048831fa.3
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 08:19:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780931981; cv=none;
        d=google.com; s=arc-20240605;
        b=lhrd/SadoBmxhqENKymnCkiteowZuVvPiPPbr+zgCSoUcKgg2inI+IGF1gEGT8iWmq
         T79btBCrygB1CFqJ3w5mN3gB2Uyt4KI98gUAJPhYNhJRAyap0xGmsec6EHvSHYj6nxI0
         aZD5Z6+JrMShlJzB6RYwYafZtmT5ql0sgDJTrN+uapyqPnhQFEyfnyk/92GhpVrImM/k
         gCjhpOYFffyG4xiXXAJ5UaTMy6JU4nQ8y4ppZNjeY4bxiSJAyYJc/Brz/9mnZmM02ykx
         8vnrHiGMg/ZRMF6wBs2+80r2wStXfvl2WXRlhDcnbEBMBXRwTyZJ6cBfcc629YKwy8rx
         jDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vXk1HD8jDBLdfN/s8w4XsyhJnLEeKFkiXtViPqwERKg=;
        fh=3ypEnG70x1E2kBrqIDU1w/fMH/uPh/paGJu1w7iHdUk=;
        b=eRL83Q2Dw80FC2v8iTy5QE+oEGD5M1Pj/8aXJJLd3pyybxXl4N4b4pjdXRXIGHR3z3
         FpgsMYY94JE8ifuniC0/0rJDEquGQUrsNPQ0MqxIZYN/YHXuV6Y0ZW87FJv/EklJ2Llp
         P2kViojQKDP0iLC83a2rIWRsZaG95GXK3IM2sVqLjoXdjMfjPcp4JIpsTvyqFCPh2Gwm
         2jr8Os1785oIkHjxG+8ucinaZA55YaKHjDYwd/5MDMJMOHg31JHhZ+cq1EpaScL5TFFY
         JlPqY7ExKEntFDnEPqB0+F1o7W93Z2vEgnG5vMA0FNOZZHcGQsxB7uI/MOqlASnVPCcE
         EZ7A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780931981; x=1781536781; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXk1HD8jDBLdfN/s8w4XsyhJnLEeKFkiXtViPqwERKg=;
        b=hThoPwqmGlEm4MUpybDk6FnYqyt4rl7onOUi/OQrI0rRn7wIfFU59LQBSCFIEyyf3Z
         LIuq+j+WXof9BMOjJcv5kNKOKIM1t0RUNmWMwUjgK1mNK/Qoh3Iol1rnEtCTOSmi9Gur
         Wd4y7LAK2sHT7zTzYMVkSHFzdNLNng/13pEsoAIbTpELOgFXxZ2CNcVVFGwc9hVl7Cxe
         k/Bxr+5+MRT7FKL8/yxP/L6OMuxqEWaeNQWNKwoMQZoQFuhvC4ByAZkK6aWAldAq9yI3
         /Bvfc/eX7iQlZ9s7GE9fYOpfZLkwqjMoAOaGiwRFmY34IywcbzDdHyj1BM11EMQNKziC
         hPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780931981; x=1781536781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vXk1HD8jDBLdfN/s8w4XsyhJnLEeKFkiXtViPqwERKg=;
        b=ciwBfAlT9CAMsJi4/aAD5luCgjhEMvMacdXDOFPKb4rkFRAo2SxfvMZhs+hj1uirB4
         b4cWQBXPp2aQRa0tT8f+lITPXtIGIylWXakwK8HudAFymU7dXKrsM60sqkTN0QBnLGPp
         6qZN4WKbvKMPiQoBA/GKZdzJqnXT0/4FeCAi6SqVg/gmuLIAokIA8CMbC8RgTrz7woIV
         tmPL2wg7cPiD+72TxupbF0DMVoGsF9RU2Ur8PEGWGy5OEwwyQh1OHQF2RtZAMBVUEPVi
         IeCdLoKvGVukQPwF5mlDI+cvRZH+swBtdEzBWysptXgAsxqBcpq5eIt70UETypXfevRg
         H7Aw==
X-Forwarded-Encrypted: i=1; AFNElJ9WUPSPzyzIPvS/sSEz7ZNTnkrGyYaAPHDr5ABiFOCW9AIurUMHqwEPxJsSSsEErvSCMOBtqz/K@lists.linux.dev
X-Gm-Message-State: AOJu0Yxj26gepOWFXnucYVXgepEHFGxnCzDhgW1+glQjRxOF24flku07
	7xbZ1pQvlg7SDjVbWl9T6js4Dvqim2O0iw5jwWj+HnoW+Dq7U4t8R0H1uEfGtYerjE1+tqEPB8l
	ZdTFgF8kP1mW0U5qxBzhr0ZIbIggn+5U=
X-Gm-Gg: Acq92OHtR8qq48usAWlMIkaMIe5isjuXp+A0mV3c5TCGcw63u98dIX2NDBgREUVNeYG
	Fr+1hMJS/B5UCZiR/i8CNBVTrzexW9fPFlZ/iMoya2ZUQ8GzTzWPf77zqPuw7B8GwxGfSPRJ7gd
	SvS51wFHqa1R1p5DZKPiAfsrHse8Ll9HmXCfGzlWiUiukokaNEGk5+eOmwY86f4NBwliOgIEHTt
	4xy/YpbfdplJbyIQgsK33JlVWQPHoYCTadolPXCWkbRaDhi9F6lmdhvcNs9/JDUplR9I+X8P2w0
	/8Tw5ktZc564+u6/voqVtrW9+/0QVBne+tj849HYGO7nGR6E5Q==
X-Received: by 2002:a05:6512:334e:b0:5aa:6f0e:8404 with SMTP id
 2adb3069b0e04-5aa87bdd11fmr2789965e87.21.1780931981030; Mon, 08 Jun 2026
 08:19:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095728.031258202@linuxfoundation.org>
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Mon, 8 Jun 2026 20:49:28 +0530
X-Gm-Features: AVVi8Ccg3Zr3aemmSHt7GHXbKrsk0DAsls7Z7yyiG3r_z6vUzVOxyRDNWRLOd-s
Message-ID: <CAC-m1rrbuVGfALvHyDt+qgju7Cu4nSdo3VjaWi7K0B+_9i1PWg@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
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

On Sun, Jun 7, 2026 at 3:33=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.12 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Jun 2026 09:56:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
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

kernel version: 7.0.12-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 877a01113f80e75b29ea891dd8ce9e1822a04a60


Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Regards,
Dileep Malepu.
