Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAE73EA66
	for <patches@lists.linux.dev>; Tue, 14 May 2024 14:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715698100; cv=none; b=sDxT1mShnEyTIG8HUIlUGNEr7HFEItWHYJmZGqamhDmrGlXPb+f0C+Vp1OZPlizieDk2kqYRs58ey2A/c1OX5pb/dJB+RbPIwt2SeKPRyIBBAMKK9MFea2yx1SEDthmzBGObpe/WgjxX9/+A0fIDTRyvV8kWDKW9OGcz1OTRuyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715698100; c=relaxed/simple;
	bh=v5cKs+69XP5Np4L0qIMo+yZTTs38YWffGnAEMsOYqxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FFwKTncnjyQQVNW1uFSwxAiOLwsskdCnN4cRk927aXLiPhbfsvnoaZ7r2ZniQQYT1vt8WZkYiRTiG8ADOqDBoQLOL0aueNglc/OxWJVu1i9Jcz2bB7HedzBMKBBIU0ihV+vU6YU3MMzFb2fsMM2s89vA+Awafz2svnijUTGbezg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Czwq/DQC; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Czwq/DQC"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6f4472561f1so5164660b3a.0
        for <patches@lists.linux.dev>; Tue, 14 May 2024 07:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1715698098; x=1716302898; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZk3CwTUVB475tkoToAu9QenbV4AhIaVymB/BlnOoyw=;
        b=Czwq/DQCpNyDXmvNbi3QHwTCQyB8CRgqu1X7ZW7xUSIezwiBVGa1aJUw/iTeAzJbDi
         m0iiWhTaThiXZL+Qk7awWUgF4/qlMyEvkhLAPgShO1sDMRD81ZtcLT2LXRK2OTYoSGnN
         ILJW9FELiOSo/Pxm90Go1e0O8xSNmUv1eo/cRDHo5Lv+xC6VAz4gm/EFSc4vWiq/1pxD
         HrganTqYKWBbrjp5Hn/NI7Pp21ATZw+P5HsK+C6//RX0TufzcdRgcVrUsVaYGTQh4dL/
         53dUU37s2GSnryZxibkI+vsLDIslNl94DTTyZDM8+YiyvK/OmpdnmVYd5RzsMT4QVb9/
         1pqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715698098; x=1716302898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZk3CwTUVB475tkoToAu9QenbV4AhIaVymB/BlnOoyw=;
        b=CAmZb2op0muTmATiP8GQ2RDKiDY+1Va0btVVrAFdPIDQd2VHXRWrXJFlDiM9B3xbtq
         XfTMSWe01buobmp+ormWvgOr3gL7IvfftyJBUrvLti/1XiyAa1SeAPg3FRcogpCNC4My
         HwbrF7mK+HFuJUCsKCcpg0+Fw2SIA3fPBgQMkqJ9cX8a77+y4urBM9yeHRSRNqwO37Fa
         Isdc2cXmwRuAdhhac7F6mZnOgCIY0WWNdwWNkttPz+kS3st1wDFjXSv+Bv6biA45CFM5
         SEByO7/FiCdc1k/D38jHYQDN7xFaRqsswvclcRkQaKMDznzVWBLiv7HEJGjP8MoD/TZP
         0iNw==
X-Forwarded-Encrypted: i=1; AJvYcCXNgF5FVbX1pcr6xkiFhSlSToM4DBB4UwhczqXQ7Uj5Qtf+oikT7f+MwRmUiN5WunvAsM++JuLnM70j8gGeBty5eR9hNoM0mg==
X-Gm-Message-State: AOJu0YzHQS7ejTYunsrdTYotKGDjfpn46laaRcmKdHhMgMJ0pMMHMwkE
	l0d3gg3Gqm6yMo+a9vdQ4hSm1Vbd5QCRum7rUYTWiLe8scuSIO64DlO3tStFKhgei2bKqR1XimG
	/hqmYB6Hab4+lnR3cOEdfBFN4QTphv/MEnAN4tw==
X-Google-Smtp-Source: AGHT+IEMDE14BQJ7hwbgCihLMNzbQ80px+rakB3WXBnAWf/pBUQIv0Chn06Qv5WDJjyyU8qAjhHS3Rmz0+zRhzvLJo0=
X-Received: by 2002:a05:6a20:748f:b0:1af:acf5:f9e5 with SMTP id
 adf61e73a8af0-1afde0b7309mr20033005637.23.1715698098122; Tue, 14 May 2024
 07:48:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240514101032.219857983@linuxfoundation.org>
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 14 May 2024 23:48:06 +0900
Message-ID: <CAKL4bV4=MjQAWTEvvp9pJ4JD4ZbC=7hjhbc2S=Ri_uPMvRG6Eg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/301] 6.6.31-rc1 review
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

On Tue, May 14, 2024 at 8:29=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 301 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.31-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.31-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.31-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240507, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Tue May 14 23:21:48 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
