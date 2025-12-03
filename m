Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC33B244665
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 20:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764795405; cv=none; b=Yl3FQUE19b9K9sHYlENBuyzXBMcy7EjbTyIJLshAcTr6TBsIQCAUj2ECDEmI+hgOTtb6UMkMJva27s4smHt63+1Ry4KfDrPrGZkMXrAAV7vu9ikhMaN4urQS5OqASe3fey2pPj/jgpw1/Lb87fQyEeZrsQDkwlRg1g4zQBau7Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764795405; c=relaxed/simple;
	bh=0ONdcZVg8PdvJ/9rHYnr4KEKWh5qQSXQC7u5JITcI8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j3CmI/X0vOEUHHGi/dQCxnoTJLLRLwyTvuzLMP71fFzPCSAM5vHtEIxvi7SA5pV+Y8RBB90oBWh6NmKsFO/OdFcbDcAcj8FzlC93YRCbrw5Y6VKIT5Jhw2KiRjWYR73wcPNcIBJJmtR+kwfDNhIC4QAmY0B0ePzIZMtQgDRC6to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=DSnt3gXO; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="DSnt3gXO"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2984dfae0acso3710205ad.0
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 12:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1764795402; x=1765400202; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSm2OrFTk9JAzRimfII6T2rfsk8cHMG3JDmsWZ/gbRg=;
        b=DSnt3gXOK+M5bGb8jREKeZ6zD5wLCnPdOXOny1Wo8S7r4PE/pz/BjrBvbOENg1aKh1
         W49CgDaltWetC3kba4mO5lKmSBO5qDK1JyH9ErDLzj2CQ1DKkJie3NyTQv4AnLWIeGdi
         Zg45XKFAyU2LeCytqgDu6hjTnBvnwKs54g3ed8ghK8OY7zw8xrwAE4ib/dZ9HkeyOgm5
         IYxXk28FApTARU6rRLowpsqalT85hVOqLbmnHc+SXUTJzWppyqAoPrUZOiWo9nL5CJJV
         DjyIVBmJRTtG63Y1SYk9CygpRiePG93CSQgd/u7civdG0glomPGZVsrFwqF3AwWv4Tk9
         DPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764795402; x=1765400202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KSm2OrFTk9JAzRimfII6T2rfsk8cHMG3JDmsWZ/gbRg=;
        b=D/wnoT6P3M3+ur5kE28sfGzDXan7t5tz/tkrGXWXsBJKpcb10lTtUxxM3Kvpfz4ETp
         4xjv1Ftgyb6/GjATT7/drPptEbjrMzuDNsFq1Ij4FhderdCH6M7RcuDgUh1O5u8RZmU6
         QiD999i2qhc5h3Cjy7Kfalsc/uxoWCQ7bO3qljUuIzMV7imSOj5R3aXNO/OuaGY6WPin
         3LgNPXrWv2JK5y+/iOaydBuWNq1rmea7OUauqEPWLsoPnMn9CD4QR+lBIyvHH5yLuvsy
         B5D0K1PG80oAMVvbtxcZKFHOtUPL1HsinkNLpTzzxA94fkUwJtr6XrY/3g5W2XlVZaIq
         3ayA==
X-Forwarded-Encrypted: i=1; AJvYcCU4gSxSQE4nvbKW2iIGdWtAK6L8Zq8YS8MEiWnlTvjdRbu24bwtM2FRRwZ56l4HyQ8l+VJxTIqv@lists.linux.dev
X-Gm-Message-State: AOJu0YxfCzI/3Ge0d4Gulny2+OWGrplBdVp5xRzkLYCQYJMUrTfwI1XV
	PsX5IJIin0ZHtrPYt95U8HhlBM41NKCaniHoCUk0UHEsb8gDnfdlrYkJDLNOGtWmNSRQIPdu8tf
	35vkgA4wZ8+O3Yeyaj7LgOrt2ktVm75ngjvmHpDCLWw==
X-Gm-Gg: ASbGnct2549F6uTLYGzK1yKBoFRCKgtT2Au0GLPl4Nl66VjtfqYpZxzd/1JAb6hnLzM
	hDwxhf/3CTobuRnVb32JX0a79fjmTQ02Df7G2Q+uRgtFkFQpS7gARnuzFyENtt1x7ulb8s0zEcP
	JD8aX8UbJQ//WPoVMW1rn10UyIkuyMaUFnc0HEPjrEMZbFGT9ZkbuBs7FZw4+uSSBql6PB0NVNw
	6RR+f9K8b3tBSbbffMsoL3LUJKtA4mcKG24yyq4NC7kWd5pKzzetMPk6QE5ONPMC0Mhi7hH+A==
X-Google-Smtp-Source: AGHT+IE5YvU9BXC4pEDCKyQ8pvGMRGvjOddkTOL8aNzisJC7QAW6R7gSA7nVMwOaBNdF+Qn3PNm5V0gjPnWDN1UbZ4I=
X-Received: by 2002:a05:7022:6625:b0:11d:c049:2fa3 with SMTP id
 a92af1059eb24-11df649f9a9mr418502c88.30.1764795401944; Wed, 03 Dec 2025
 12:56:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152346.456176474@linuxfoundation.org>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 4 Dec 2025 05:56:25 +0900
X-Gm-Features: AWmQ_bn11sXI1U7UXWaMI3_3cEiTsmxIqY6MUQmN6SkkQuffHABuBSk2RK61BOI
Message-ID: <CAKL4bV7NQgNstsGXj=uWrvXU8JV2kEA5DHEaySofYXSKYQDMEA@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Dec 4, 2025 at 1:45=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.17.11-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.11-rc1rv-gc434a9350a1d
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20251112, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Thu Dec  4 05:27:29 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
