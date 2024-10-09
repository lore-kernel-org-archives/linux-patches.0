Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208F198E69
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 12:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728478097; cv=none; b=c3+Po3OpLXBzDmu8kv0wOmr/PVQ0rHHeVEC5vmJai6QzB5hu36vv2YpVTrWsN6nJzfDRn4r0g9XYoAyPj5tLbLWsb1qZA9Gjryz8KgvS4S7LziZ3M9/nrqRMOY/9VLu5myuLDl086f9ywBZbjIkJSN8lLPHA4ML9/3PDWPDmnwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728478097; c=relaxed/simple;
	bh=pt4BlrCslRjBhho4c9a7N8znV+5Jcpu6Z3Ru5pIj9xs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Th432kaUtd5+6ZDskAvDS32P7XFabNh/I6k8tlR4URXXhTImecTs3+slOqpWhq/BHsS6YoC8WZe77/uUYB+KhNS0tJqIUTp4b9az+teGeWCgGx+hXws9c2bAeHw72N6uqfDppkxNgjSyP0wAREBq0PZAEpbk6AXsEoLJEvm09Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=u1EVjb4I; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="u1EVjb4I"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d2ddb61c8so1712225f8f.2
        for <patches@lists.linux.dev>; Wed, 09 Oct 2024 05:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1728478093; x=1729082893; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVzlhFZ7VYm/3cAm2m85K08t6/C9UqqQc41M0VjSFTk=;
        b=u1EVjb4ITYbxVKCgYG/FrKlmPbmFeEoAta1O+WqGWO3uYzIE/MXoD9iWg1KBWAB/V8
         OKAvkKgO7QTInxiwohmZbA4pf8oTwm5wmoSmSzWmbOXROk6O9EOitNAceGd+FvjpGjnP
         d2sF1IwWVMRXpZXlPsHed2kU6QSlu0F8dtKZ8ddZZasHm7FqC75BKXKyW/uR9ITAYfyO
         JfRJ1fuEr1UdzttCFm4cuEllEBCzD0GRm6o2SUCimvZwcdOvcPOVDAwFiKudWRVZsKPh
         8uEzXDrxUtvIqClzp+WYjQvUKaPb72naN9fRfhzZszwKlAKNxvNyZPn0b3iR5/dbMM+n
         QZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728478093; x=1729082893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVzlhFZ7VYm/3cAm2m85K08t6/C9UqqQc41M0VjSFTk=;
        b=e1Zk0Gb5ge7si7uwhfBe8lg3RLPmB+ToWt7dFz+wBEs0rVbZ30U3EBRfBHbkyBRZFs
         GClVMIm9fEc8wCg+qg4c0UeSoB3K1/1bsPZC5XmTzWk9AX7DKMJeJVE1DkRZaIcCd3S7
         QyIzlzrtP/H7ml/u7RjTK04xSkAONiXMk0R0bpUEQ53JdYMXFJorZZamV8TXGXqISDsr
         TR0WgltXSfcPHEDS93n+dRZ5linOUh0DSVwBX4A30uSJidoy6FZoTyK4sraJZE/KgKTS
         pULlo3RPLpg0+eOCG3/d9qe30LQAmXq1jFy/ybsVklNC8L50xbIxFgCyfLOtG6z56KFL
         eyOA==
X-Forwarded-Encrypted: i=1; AJvYcCXqhUAHO8ZIgAqAVtjlIrwJryyCkK3OiAw21GaDIeTATjguBFB2eDkhak7ttLI0PF8j29X0UPfn@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7NNBZCMG8o+zaMLWL5PRXeS5EhcHZ/2QAZf6Uj8QlaKotpqDX
	Y316dyq23x6gwqXh+CYYc9NWTv1LGpCI1PrAnPO4MTV2h6mMREX5G+IgA7SIpM+yBkPYRA/fftc
	DnvA/gFKwu/sa/0paFtdbaUStuW36lypEGqk56Q==
X-Google-Smtp-Source: AGHT+IHuUtJxYouoqf+oCUX6eRYDEQZBxX8IakgpdyX+VxZ5ozg9KjIGdyHqZMwBodfK+iJ1Ts5g04QJNMfKXZ1v+c8=
X-Received: by 2002:a5d:4384:0:b0:374:c3e4:d6b1 with SMTP id
 ffacd0b85a97d-37d3aae2f31mr1784150f8f.44.1728478093253; Wed, 09 Oct 2024
 05:48:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115629.309157387@linuxfoundation.org>
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 9 Oct 2024 21:48:02 +0900
Message-ID: <CAKL4bV5cRzNbEX9dGn7ZxWZpmV5YUDtawtEMrvMnn4Bakg4Omw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
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

On Tue, Oct 8, 2024 at 10:10=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.55 release.
> There are 386 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.55-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.55-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.55-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Wed Oct  9 20:12:56 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
