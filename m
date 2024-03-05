Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA8052F60
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 09:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709630983; cv=none; b=qJeG5eUsoUuPI8dkDQY2mQ2m2W3jFECTbFMhqGa+CyOJ8a2CdYbq+ZQwbdtt4KW++rVO0riJym2OmRPKbeel/MAEh4nhZHtTnLWE9Tyttd3PevYRAtEsVFN7xWhgKeQt3CUsafFOwGdmNz5XCD+q2P0e8pn5wwQktOsYT5Db83k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709630983; c=relaxed/simple;
	bh=fwwZcoGwaB5irpy1rxHWbnfBT46aa54lt77MG6kaomM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cB7JTtJcKkODFExOkXXwe1lzITOLeyqC3pwE1ZyDVTOviOmz6DZF4XMqC2I2KUDI+DiYE/I6sX1c+dlQPTvegS/62M+jndurmtSQf01p+IsMwTbs1kaOw3EH+FJQJXdP2cfcX3vhV1xZmffZkszpXPii4K/CTDSF8M0nZyD0Rgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=lodnGez2; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="lodnGez2"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-33d568fbf62so2883718f8f.3
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 01:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1709630980; x=1710235780; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kax6J8q+YyZ2/tOmW0rK7vE9BJFxUzpNAhhYIq1f1zs=;
        b=lodnGez2QZR16yNmll/USvIP0JSyFwqPX79wyiCm1AW7OL5OPvXE2qbOMR/lpi92f5
         dZbJ72unCRmszvXxHi8dQ6OhABgSMDHsYHxq3Jao/hRqnQwE2wibTaWOm4oYPSANp+zY
         MbEefkisxTDb7wDiKIh9LGf9vsV71IxjcjMnIqi+ZL/sHm5m9j5/ffZMFLQ1fIT1lj2a
         3/V1v3H5SwNyxwMQvA4vjni8gH6Es4ttyHverD+Hli3xa717y3U4gBHqSNO/O3dhSJuR
         FfNFanR0Nymi6D4XW+ekSmdpUnlDDMc0nQS2MftV7+Grn6kFTPUB8oYrTK/qiS+SDsA9
         +fEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709630980; x=1710235780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kax6J8q+YyZ2/tOmW0rK7vE9BJFxUzpNAhhYIq1f1zs=;
        b=eOfArhLfKt0Bng5/X2hMPiFdXwsC7D2cENBTP1F4nhMheGrIBsu3eX/v7JdsGLKEH/
         51oyzaOJ8hDUz3glcmutgo0qIiyZbwG2aJ+JCx4BBhtamasCB35da/9IcioqZADb0ggD
         TyZYY8eHhGYFgHcnZ3ie7rbuB3JQKPo/wNRLZOMko1i0n9/DXxNfoTAXdIrFOSsbfFST
         9LppivMobd6GOI5n04u57Gm3m/ZrpC/o98IeIBbnOAgPJgR2ybWH4akcAQYitfdXLSCD
         7NcbYDGKXAZksiwR1UheFI4sHou3pFGzjEDA7Y5D52wk7DUinG9epjbuOINi4yEy7AaI
         YlHg==
X-Forwarded-Encrypted: i=1; AJvYcCWwd3snXtGEicWtVn491ImHQDfcJQtFuoxvp6p5N94016XX6FF/Z7SmTSxOMMJNXnLuz/RTwRDGsnECaKw8E7vkvgLvSLKMKQ==
X-Gm-Message-State: AOJu0YwWQa45nE5CAqDe0xEtCRWckdKWPwBS1oDU2KBdylQLDdlrxtWX
	Kqfof1TyyZrc+AlLL79fK0GYYwXqHar0MbMCL2giI44dteLg7YuKi7ZmcAgEAi2Z/rximTaLGgW
	2HOBcdEWK/8cvlrPmIqDLsJ5ho/TC/tOM2mznNg==
X-Google-Smtp-Source: AGHT+IECVfZbaj8vE32BJFSRyojq5sxoYbaE05unjWleIgRKFNOLgHqoAT9uxruPOMGn+ALi7kAOewyVZuDWxdEwu+Q=
X-Received: by 2002:adf:a154:0:b0:33e:47e5:e70b with SMTP id
 r20-20020adfa154000000b0033e47e5e70bmr1011317wrr.3.1709630979563; Tue, 05 Mar
 2024 01:29:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211549.876981797@linuxfoundation.org>
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 5 Mar 2024 18:29:28 +0900
Message-ID: <CAKL4bV5WJ_xZ76KBnOvf6WFAfVtj++4zE=hXRgGyOGD55xgwqg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Mar 5, 2024 at 6:37=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.21 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.21-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.21-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Tue Mar  5 17:15:13 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
