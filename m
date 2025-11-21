Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E3021B9FD
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 23:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763768453; cv=none; b=C+9HxJ5Vh/WdkTTfkg28zBqoTdv2lUeo2FG2m2qmep5iM7sADa+K2EFHvdaVonspI/SqoiFHR3YUJmTBs0oCD1TSpCl7iqjbtYcPT7aZgmFC06sJ2t1qLReX7nWpE7El96m6NS+muSte70JQ3eHdOMMDYMN5h1JglfUuUs8VroQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763768453; c=relaxed/simple;
	bh=3qKLYC0y3/7eM1Ro2EkyDit0kfLQH7qiYWQQLEn79jE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UaSmwUGbr6Wrl8sNy16VML/ZuqIi8v6EXnNKNfEm4YENciCuVzROmUDHVgAhqorkvj0f0/Y0kKmWlhP+5VrPkeEm1eJTUwj6Ppc+4TZZ+J9dCcX23m6noTmk0/PrybNRx3nPv8FFSXgcMe6R5bgWNRDx/EeuZdzfv4xGtCK0sSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Bu8sJERR; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Bu8sJERR"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b98a619f020so1978141a12.2
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 15:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1763768451; x=1764373251; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeX++7UhHM3U5MYi5MXg2Yp5C2j3UwwuMQxs7wJVylA=;
        b=Bu8sJERRkuplm2yze0H+l8svNwY1sKDp+wB3LaOP6gVwVHEBZyDk1mDpDf8/NBzZ4E
         yM7WKZY7bjm+o5Q0vzRg0zLc/vWzFJlAoGaUnWkeKLV779DXQTUKWDzvB5+N+dYmPAP0
         y2gGTb4+EE4TF7MXYGsSnUqyIPPClxGDbj4kLhFmneei/KIcax73cJft1CmdZdWGbcpW
         UIuGfbbnmiDcpKcIoSMDS0hsnIikARBYilA5nGwV+E2FpoZ0JgWL1tvHTKcU4xGOGqZl
         aHCJQVohGnMsDsDqL+MdwBkuXcVxp2VLwQzzMOnyjpm3N0X2JEmX4lk8xW4oxyB7FD/j
         D4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763768451; x=1764373251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aeX++7UhHM3U5MYi5MXg2Yp5C2j3UwwuMQxs7wJVylA=;
        b=wPOPsqk4YWisA5gCSlJlTZu5jmEfC2VMaRR4Y6VIUnDrjT42kLcHlTYzAbe7Ek9R/z
         PFbrDhPtfDLClPl0Z8IH8bgTRyOtbLpJ5GpVnotu0Kce0unzXjMo/gAyxxU8T0IlVLqQ
         IrwJjRH0aCTnOaifBhDqv0gC9g8pxTVYXWqGRJJ17rse4upomqSywFz9WYhsDfRd3u2g
         8WHbjaIEvNNkMoNxEJo33mZVLXeOAa0x3d8I94IgaEuwETwVc9Ok2pJJbgUg40B9lkg8
         IfGHlq4ybZ+Zmnl2sjoqbJBvUVQvC7l3+F8Fqkv3811brblg6HUEb/xgWVdREv16ctq4
         uNHA==
X-Forwarded-Encrypted: i=1; AJvYcCVE46K/gYwDD72tsQLssfk69VFdpebXtMQgLyCeDfRfp7ynhibMFr9jpKxGHMYTokCwTHiZdktY@lists.linux.dev
X-Gm-Message-State: AOJu0YxikO2pHZ/1hIASaQOoeJT5b64vyCn9jm753HuRlm350u9xZVS7
	j7MlnnDRsyQnYSH7LqzMIClS8jSW8GBAV0RVe4HjHCbcflN/4UtKvyPTXQgXzcmtgxwfBo73CHc
	0SFbfxJRqLWc7L8GY5pNW5v7gMNsKAr3+zRXDK1Ba+A==
X-Gm-Gg: ASbGncu17RvsEhueh3SrT767RF9co7CyrmIfk5g7rgnnBYzpCG9v9yT6+yJNUCOKgr2
	uuq5YSyzxHNf13zqnbe8GL9Z6+dff5W7n9FllWCcCKxfkoO2000JkikPaGXZsr1zc7HDrzg5t56
	bkwC7a9S81hrNGPdJ+VivjBTsxqcEO34y4YW4YAnXZgPzA4whtusCEzlN3knPyD2npahajE2MnG
	VRaG8NXS/2gNxy10d+s4Xi1kEejAfExIouRPvqWvsLr3dCwwTMIZqKkZKAUFSlUXbWD7G226Q==
X-Google-Smtp-Source: AGHT+IEvjILi8jPgmj67eLHNTGh2Gf5jq2eQOxSNUsNue7zggTnn0E3XTOioFvOBB0AM1Qz9f6QfZ67h3rcAhVUSWmE=
X-Received: by 2002:a05:7022:504:b0:119:e56c:189c with SMTP id
 a92af1059eb24-11c9d60e728mr1789175c88.4.1763768451161; Fri, 21 Nov 2025
 15:40:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121160640.254872094@linuxfoundation.org>
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 22 Nov 2025 08:40:35 +0900
X-Gm-Features: AWmQ_bn36b82vaOzTxXjSggsbwhgXP5TiPk3YE4ScibLRlbPoKTv2WS9EFlfEL8
Message-ID: <CAKL4bV6qcgNCMMoAb8gWWQnUUUg8mH2OJVnh2+hNahnjQKeDCw@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
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

On Sat, Nov 22, 2025 at 1:07=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.9-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.17.9-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.9-rc2rv-gddfe918dc24b
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20251112, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Sat Nov 22 07:50:12 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
