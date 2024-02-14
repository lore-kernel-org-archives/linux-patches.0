Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121F11B965
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 10:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707907435; cv=none; b=TH77HRTD9kTHATmahoidE+xTL3sc0R0Prv65JyqRZF8CYDPnuQ5NJP3xcaGvYkCxfVoRB9PfRi1JkDCybeCogqnSLdWjwzhIpwpW6oXU58gGBhOuKPaxIqn64knYIkUBLNwMkADB4RJZxkAh2KzStMSfa+qb+P8WAE0p3Rm0t7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707907435; c=relaxed/simple;
	bh=a8YEg1E55UuynaTEvvoea8h2L4h+1Nibf4RxcjpEfD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l1pnczGUDGH0KRMkvZoyCkn09FnLLtqVnx21sxMrvHv+0xbVdyNYi/SUzdCC/hP9RnTAk8K2AP6wwvRRuJ3/FsJQgXRMqt9QEX6GcpM3C717DAKo51DIHhxshznDThLqKzsg9E3Imv/3rZOrTE6jSHEVV7/0H3LHo+hSbHyjgSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=ytSy1aKj; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ytSy1aKj"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d073b54359so78411621fa.0
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 02:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1707907432; x=1708512232; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R58F2rwTQFTBG9lBUJ+1oSCw6gGEYpe2zfusW2rUTHA=;
        b=ytSy1aKjSd8UdL8FFNkuZAYmd2482236/83pPqV5LOjZm4+I8pLHorCqkux90dkKW+
         ErQAjn40fYMTZPJaEJsbxe0skme3957HqJRJnDLkdTkDXBZ72KWT0M6HXpoWYitqxQGD
         rzozmAtlmcgNqN3l8vnKKsxcN/9wN/vGvfCYaHfiwteCJsoQwhdK7EpTO5BYwO3IUE4e
         1/Cj2dB6LnLEGqvNmhjz15nr5hqPNa24Qxyg5x5IoLpA5TBQaRTCLNNfV+tgy7zE2DyT
         BImkqd/CO+/pdf0q/FJVmXxip0YLQYae0NP35XaIP77eqNoBa3Q4KTZHivqsLF/4Radp
         eUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707907432; x=1708512232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R58F2rwTQFTBG9lBUJ+1oSCw6gGEYpe2zfusW2rUTHA=;
        b=YGqEsK9FDyG/d4UQ4e8FNXL4JeJ1ROynjC2dhwB0jdQRT3XpTVLvoPsNJiitlN//DN
         vO1L7MC02ZB++aD/4qrGPN/J9Rta7XzhLO9F6ynammWTqC/ddBqvcJJKaxszdu2Nz679
         Epfvcnmtlf1UePfWDIGj6IT2gkdJqfams1L7IbzV31iHgkjL5xX9sDfTMfp89a9Jytf3
         ZAMwsbu+zY7LO2KvFJIkBe0XNYZhY6QB0eSAJp0TylGNGpk0u6LnkiSDj2l6s8ZE+p1H
         nDhxbJ23gtC2ZmsrnbTd1LwI+AFnJrLB/KJ7AdZEK6rTphPqiqpyT5GweIUrSqFuzhXQ
         l4tg==
X-Forwarded-Encrypted: i=1; AJvYcCUz3vdT4Q+cAg0C4c22Ns2SM3NdrTqdx9M7IaZnmYXa5mZoxLuguvybY/2JUlA0yYv5kfGQaP3IFJ2yrtYXHa43DDB2Ds8FgA==
X-Gm-Message-State: AOJu0Yzbf9khH2WSAnpYhDK3RM5ozTfEOsafvPkaByxsSE+Lct9TNs3d
	uqvDGrJrd6DfKyQE+D0cikQHmkk132eiSvPS6VqyjR/XONS0y2YW7Dmno6kSQJF6vAdgkD4vr/D
	hdG1ok5SmiXDxZqQR/ov5r0YkomtwR1DYY9VJxQ==
X-Google-Smtp-Source: AGHT+IHQZnUwzBf0N85Ucz7ROvmIBymqrgYpKyTIfawNtwOmMMJ5P+XT7mwQx8Qm/x33GUgxEAZN4qv2PSdXBiI07ak=
X-Received: by 2002:a2e:a4ae:0:b0:2d0:b758:93a5 with SMTP id
 g14-20020a2ea4ae000000b002d0b75893a5mr1554451ljm.18.1707907431744; Wed, 14
 Feb 2024 02:43:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240213171852.948844634@linuxfoundation.org>
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 14 Feb 2024 19:43:40 +0900
Message-ID: <CAKL4bV4HnafwMHihUmGJdjM5koNiLPHPuDhFC=c6SzF=Ns2J8g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/121] 6.6.17-rc1 review
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

On Wed, Feb 14, 2024 at 2:27=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.17-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.17-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Feb 14 18:48:07 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
