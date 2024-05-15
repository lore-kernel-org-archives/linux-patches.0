Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D72CCD0
	for <patches@lists.linux.dev>; Wed, 15 May 2024 12:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715774596; cv=none; b=hlESm0Rw0xpaHAAtM20EAXto37JpuiNIyPjp4bKBPWnZ7IvkBlCJCofKiaysxnyA92v6kYRFoGNVIXgdxthOa3NWcGZf7ipcucU8Tc+vkLSE72MJZXcwIRIP7FDWku3QgF0Fp/1/XmjYZdO74WFVbCP8yXpx2NLYGZRgKXaYd2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715774596; c=relaxed/simple;
	bh=cZULlQnzOZ2Pej2Sv06sBDw4hjTWF4t0tcOP2mtKUnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JuuSItBBqE7tuItNzYTkydNH5w+YxTGhdrXW8ayXsbbjmL14i+/oXHikNtedIaIhBnAR7Ok6zJyExDvNXNWTkclfv70bB1UnGoJcgKWVQd8/oBBSXrZVjDUkHzoZqBgh22XRWjlCMIOV5gqAzbIFXB1x97rsyZd20ThD6fdHYO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Masb01gc; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Masb01gc"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1eeabda8590so48991475ad.0
        for <patches@lists.linux.dev>; Wed, 15 May 2024 05:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1715774593; x=1716379393; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DcB2okqnAgkynFg9jcCuDayVN3zRAZHBcQStj5iFBs=;
        b=Masb01gcdDIO/C9EbxBGRH5ZMvqJm336//2F6WM0QgBW69GllcXPkwSmeBYE9uhHzK
         3s/y7zIxsnMSLG0AVtJ9l+NOCm4puPUfPGbXgHfSlzKN+oprteStTGkiOef9kQLwOXDb
         pyn7oRs7D8ZoTKylyYLniM2wHCmdI97TpP55RImttl/dGWb/rqBKnsJTY0CmoIByUQqA
         19oaqSEhj0DEVVoMWH0m3ffKlCOoGY/J/00byTNRYQaUVtNAZv9zLcA17LWhXSzcnAdl
         DrmuDBlvWlZNsoQ2cfKnhKuogYf9i93KmZPKDg5/ESDKms9iPddQ3r4U/FieP05OMTRb
         LSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715774593; x=1716379393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DcB2okqnAgkynFg9jcCuDayVN3zRAZHBcQStj5iFBs=;
        b=t0bJcBmDkYYsP2VG60zEMGuRhEo5xC+63Ghp4xJXZmyEQ7UB7/8sbnKa4/s/HH3ueW
         zpowephjui8cEEoU2sxa7iqqLupQLMBzslMO1t2oGMw7aYcZdCD1wurDfjAduXhXOiNK
         5v+1QiEethMquEwKOR3NsA2mWVWsQ1hfKYvCc47wzxkiPmhPbz4NlsiB5xV2f6+j67gv
         ShPqZLgBtlVup5M47k/pBWo0R3wFQSh4o/LNGF1dR0WC3pHhcrHoYtkjYAciBBpAxnfZ
         gAH1xcUgj+S2OEDR9TVNZdbejJKxSNgWuXUgjMOXHENv1ZbCRu5xKprcB1lG1bKwHAIu
         FsFw==
X-Forwarded-Encrypted: i=1; AJvYcCUzf1xWquzyv2SS9RhvuNTYDrk2gLnXU8MepOzNXQ4DbaP87A4iTUFdZ+QQ34E3vK7wqv0mdMpEQClw1YIEEA0SDkDpwtQ7VA==
X-Gm-Message-State: AOJu0Yx7vTxR6m6jvoQIE9J3PyInegzeU6G0eb4D5ab/5+OvIg1zHnut
	ZcFwfhBiiFNljgWrrZPFTlC2iXC1ybTmG+dgRuphbM32bvOuC7WmgqGxFFYZOjogOVfgAo76t32
	r9j/qoxb209NKRu1FHQtPiyAw0ZogDockKyl9Jw==
X-Google-Smtp-Source: AGHT+IFy3gmVgZkNpyZFzjDzx0VAz+u8/kXHpLODxZzc9kj++XjUCO678HSP+AFx1+KEX/6z3WmoITL5ipamNpy1768=
X-Received: by 2002:a17:902:7d95:b0:1ee:b2ff:c93a with SMTP id
 d9443c01a7336-1ef43f3e4admr144321025ad.40.1715774593154; Wed, 15 May 2024
 05:03:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082510.431870507@linuxfoundation.org>
In-Reply-To: <20240515082510.431870507@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 15 May 2024 21:03:01 +0900
Message-ID: <CAKL4bV5YkLqnZJsLB6t-n0ZeSSZAHYsaE0c6=-=ohK8PBG8AvQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/309] 6.6.31-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, May 15, 2024 at 5:27=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.31-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.31-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.31-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240507, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed May 15 20:35:08 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
