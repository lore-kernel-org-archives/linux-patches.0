Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD6227055E
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 07:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759302098; cv=none; b=Pae5soXaDU5fZHqs+BVCX8eVtWWN4/KEbmcoadi6/ov/SXllehMsuHxOHD/HEo04ZH1xI5o417CjHgTmEaVinyvI7Pish7eyN6OnIbNJntDbbOwwPjsB4++sInSbRLJNTqV1GRoEgWNlML6bPra+JALSxkxD/M5HrnUTA97bRyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759302098; c=relaxed/simple;
	bh=NoddTmT1ZpMZmhvqL/VnxeYOx5G30Q7gAZRFXZdird8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hwGAKtSahOrL1Z71F9G4Dy/y143PVLyMLUK4e1Bnu05jNh/lU44RYJBtFf0qBo7iIYnBeupcbplfzie5SaQ3wbDfMbKyGrz0oy1kYNL3AvswbPuvkIxR/8CfCdHUCbot5d8qOWIZ3CE74NH4o3Lp8Nm5Fl+fTEd33dWw++Ti690=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7b0ff6I; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7b0ff6I"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-57d8ff3944dso4985512e87.3
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 00:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759302094; x=1759906894; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLTUhbN3S9oKDftwQ4KAabVHzCpjwG5/226AXZhhAnw=;
        b=i7b0ff6IO1nAlKjU+lENJ1GeKCC9h006iZS7DXUVokGtivAnqvQePOJwglUdNsfU00
         LA1IQGQZNc+ZDAva5RwIOx0guhxj0aqLRAEXNXSaDLdkP9BG9aSN6mR0Hg4AVfv2WgVE
         ieFnhc2/XDoCglPF0IJDR7Yidgv4AGROKhjzROTyxCU5NnuQDmMQSE2hvK+zRLP0luqW
         3F/ylfyiXF9orfimxuCxDmDx86uXOPLCrlTxdgocCZ7Rfn/Iw38SW887YJQXmMh4uyyH
         es67WHBuJN11L2LvThiK0zxnPFuoyuzY4j3eVzMTl88pA18z5jhS9CVAIUyGSV4GVE8n
         HNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759302094; x=1759906894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KLTUhbN3S9oKDftwQ4KAabVHzCpjwG5/226AXZhhAnw=;
        b=IccI8IlHafBCw/HAJp6lns21bBGQIdFsGMnQLAI46Oqn1X/13TvBu/57z5WsROiRDV
         xGwZx5Lk2z33EAMPkb7gNLgOkdsP2gLfuK8/0e63poJ28U6bkdgfkfMEUKl++lIN6NAe
         4geKoAPXcLKNyvT1wP5CwNozM/Ws0ug4Ex1Ix+5zueOIFg0mG39wWT3YGABR4I5voRI2
         Opg1iRu1PFmTZ14oss2xOyW2j7S/TI8AM3ttamTbtfPinejYRouMEgqCYGOBIoWYDfGi
         8/3SNGKrJ7QEJhXLC6tpt6YOO+FbEMuuy4J3XjwYQdEPxvMtQFMyjluq6uu2G5CfAyk3
         y4YA==
X-Forwarded-Encrypted: i=1; AJvYcCVTFc8BWhdU2924gTj8okwDHMWchXwH51cLXi+SNG4HSmuTNknBiXF6hwBbJ7BOfnJj15HgD+Xy@lists.linux.dev
X-Gm-Message-State: AOJu0YzUuA52UeINiKemgZLSK3PX1gtJvC7WvoYjSMpVg+KnmoFky7dW
	SeNQMlXBMlctQuj0a8Z9S0fA9Ehj9h3Cik+mHNrMsiLJGU/CpUB4KYXO131NMiOT7MzZZXBGa41
	pR04KKkZ9yfM3vAcX/9SuvgazPlhY6EQ=
X-Gm-Gg: ASbGnctxdiF2S+hN1WOMt9NeAlfybBKXQ0sOov7aCtZrGajOOHZW08PGF1o2pASN0Jm
	ZZz1wTS71uesgZkLxTpbVEWmu8dAp9WALqT8ACAgb3XowiQ18Ccg2WdEEK3c81nezVV+6xPeJq5
	tXig/CjPg27f2KHxdA+RF23d7lBIyNV0POLP8dDJ7CdsyttH/y/H8MUmWbLodHUgIlK8poK6C80
	nYTChTAdDlNeqFAcxslbA3Fyx4RGMwyYATIcuVVwMFBJp34AAahraLuemlDV6EVNODn0RXong==
X-Google-Smtp-Source: AGHT+IFwcnpELmeJSQeEEzcc1sfvMTyHOGQce3S8i35SE1Ix9luZWMEUuqlQ1lvfYGfcFV55BA5E5+gdos42rFQPf/w=
X-Received: by 2002:a05:6512:3994:b0:586:83e2:228a with SMTP id
 2adb3069b0e04-58af9f4a92fmr623509e87.45.1759302093749; Wed, 01 Oct 2025
 00:01:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143831.236060637@linuxfoundation.org>
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 1 Oct 2025 12:31:21 +0530
X-Gm-Features: AS18NWB0_y7FqfcK3WyRSleddS4VDm6-xNbmK1P6eeEu7ZgL8DsqI6nEF_XJ2II
Message-ID: <CAC-m1rqxJ+wOODZUacmDcRjzNYJqE8OazoP18mY0KDjt1kPAQQ@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025 at 8:34=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and boot tested 6.16.10-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without
issues.

Build
kernel: 6.16.10-rc1
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: e1acc616e91adfbab433eb599e00d88f0bcdb07f

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep Malepu.
