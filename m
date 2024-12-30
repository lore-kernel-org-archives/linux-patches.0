Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E0A2746B
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735603081; cv=none; b=D4jwsrmroVxfErMD3tkA/21xP5vEwqov3G9qc/M+jbeQsUQtgRqGDZPMoHYF+cjHIOjinj2Xv1npDcGzCyx0T3YUkOaC7lJU/SukBVnNObmjAdTrTtJQ0yOiCDjFEsDaHrtux2OLYuRukXLy7Bb7rNPY38Lt7rX4c/qxsOP2xjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735603081; c=relaxed/simple;
	bh=mpotLnomCc5336iZTVOejgVk+D0osmwfN/w/GnFevgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QtQe6bPBxU+1fnFxqAjXBTEIP7EW7QpUmyl4XopNROPftIa/KPK0WFIelcPwE4LcFhh2LWMKiiP1wHbMXLNmzQ3cHp9B+HoYF2Q7souExc/i4kN9dT+OxjTjiTBVv7uuwq7wveDaiQTPvupBlFOqezilpCblp2meV8lNHcnjxEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=KHPCdF8n; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="KHPCdF8n"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2ee8aa26415so12842722a91.1
        for <patches@lists.linux.dev>; Mon, 30 Dec 2024 15:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1735603079; x=1736207879; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdySRgIzeWbL4+mbJcrgAY7hTQmkXMfHN4DzlvZotS0=;
        b=KHPCdF8nTVFsmRoo2L+JtmD4QzkLBclIVc5woPQ0Oe5gAkI4qTgWzTiCOpVysbJYMC
         dF3gNKorId+r6KKT6fjAc45KfLFmTINJVn6gEmf62GxOyw3P0TptPp4Shw1F4kruzufd
         wu/eV0QACaz9zPZ7a1OiL8hJ7AhW+dOk9unmkUHgJK10WnbwVmJ8/h/HxIfYTYkw+KdB
         Zy0eEjFBi4pjxEl0fgguJaHi5Yfden7Oor2BhUU2i/UKpzTjK3Dv1VLiPVnUr5Ct0Lun
         XVdk4Bz9Fk9YNkBqZC3VYU/u0AUIcYwBRbvAbkw5LeGGBr6kTtQ5ZBy2+6m1av/SNOly
         sc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735603079; x=1736207879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EdySRgIzeWbL4+mbJcrgAY7hTQmkXMfHN4DzlvZotS0=;
        b=EZHS/sH9OaRxhtpeWcalZtdAYBvpgcVIWjxLgnazrdlhBnnjReSrJ00OCVppqubK/f
         yJVU6iHGo9WhJuyVyFhY3PyLrqOQ9bP8eZmtJmyUxyDjSLhdugEoHqI6IBzqCQX46KVe
         YvvI+fkvKmwYNpOJaXn0n9REYshb06yJCGY2MEPe3Zc7vyszUt7ZxP7g9UeWmb7SBM9c
         62fFWlCzhdSFuBrSAmzwGKsj7tqpD9MmOmaOJoEd+6CIt9TWo4gUvy/IIjctVmoyEprT
         atkY1xu6abEVFLhwFDO8mYkeGA26EDKTMhRXlEfXmnR8rfSkHmuwJJ4fhASoT3mmouN2
         /AaA==
X-Forwarded-Encrypted: i=1; AJvYcCVQS3kOCdeCkeuIBPOk5Dgu+b08iN8gukjelO6JD/20qC6r/ugeXaol8PM6krEJlgbcL5igeDEJ@lists.linux.dev
X-Gm-Message-State: AOJu0YxLZ0xpSmC4vHz5KT+6jqBLWijtdvwxTHCAcusMGbkZ0X20sSAx
	bLvgyi/+vCoq1wtJfudN7c6B7daeQ12uUxE2vA6NyzzyOItWztuVthFxRhs5BZEabS6EMnRyasT
	dIgNNZ+UDzBcHFYQ5xjhvWnNxXGaEQi6qj9+pZQ==
X-Gm-Gg: ASbGncvd21FTYXwEYyZTy7icBrDm2F0bXvnMxvdxfZZchM47m8IrdW9D6hDqjJgNrg/
	CQOW8bQ6zOpH8oUdjHPPIok1xeiX1vMf7z1Tj
X-Google-Smtp-Source: AGHT+IFobOXNLY9qEKs5y+aGOdne6kS1ZMuYLhusmsD/lmEd2xaP49r5W7HpC0vdELRmimogbgDp5TkxMrlC/qI87t0=
X-Received: by 2002:a17:90a:f950:b0:2ea:5054:6c49 with SMTP id
 98e67ed59e1d1-2f452d258bfmr67525796a91.0.1735603078949; Mon, 30 Dec 2024
 15:57:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241230154218.044787220@linuxfoundation.org>
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 31 Dec 2024 08:57:47 +0900
Message-ID: <CAKL4bV50-=Hf1PSTAHVuz89xnvb6D+WngfDFsNxa-mZBYiqVdA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/114] 6.12.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Dec 31, 2024 at 12:54=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.8 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.12.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.8-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Tue Dec 31 08:05:25 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
