Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF3E274B3D
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 23:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645232; cv=none; b=hLJoNd5HXtXS2mp1AEdNjV43eMsvCx8duSkUZ/781+9gdrSA3gYOIB9YoeFvBfmzI0WUvBJy6ruZlMTt6RA3U7o6ZQrOy934QFxLiwKdQSR7/LPPBvPqJZPW37LEDfFQE7Vf0lAdM2mSp6qXFLPiJ0UAQSKdMyn+CawE5d0xOw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645232; c=relaxed/simple;
	bh=xAe4svIGBTEkv+groVjH8FKVpdlrcojWAhm1WDZ7nJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nws8QP/SMBChceTPrUOYKuw78oOV+V0cQNXp075wZxLLmgRkLJ3NFTyAzy3cB2k6jsz4KrILjNAZGTledg7WMv6CyIlMsz+YBrQFXIM7q235wbqyxQAeQf/J8TFAwAfd69Aium6XXbAuDLPtcYLNiwACEV2H6QuSo7dndFoNQ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=oP8mm4Hq; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="oP8mm4Hq"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24458317464so66221015ad.3
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 16:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1755645230; x=1756250030; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RymNDBodT5MUud6sKSaHadH0Ax0mvSOm7rKts0yhCjY=;
        b=oP8mm4HqkFgzYgevn4gNawdj60shMs/7IGVPNP3QOO5xGW5FX0yCbrkS0rm+tmY0V7
         wapFFkkRLt60vXiDOT7TQd8rbUTyFwhczbstVz74ByW2EPG3I/XAVWh+4kBPaW3P7/h/
         XgBOKhAo8L3zDBOV1q+xoJlGfKXgsMqZOlPUE4ezqw3krGuBTwuQfKNPllwA/5SJCdSP
         M2YhjqbWHz0IywgcWRWbjNh1CikOLdA1TWy9e27H4dgqz46ASvy98ULmgRKWC8ZAH8AR
         ANiPRaUkGdgqGOLET+RYGaJzzQrGk8iH9zI3gnRpGt2/nNLTtmTuTUYI2APBkznH2dkv
         RqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645230; x=1756250030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RymNDBodT5MUud6sKSaHadH0Ax0mvSOm7rKts0yhCjY=;
        b=jJ8PbBtJHmD8W/1FVn9VELee0j6Kf5y6PIdojr4YkEbpsUmvY7eEkPkDr0naXJ953q
         c+1Q2cxUcdLopIhzgZcP28FhAABQ3yg7JJoHMkCEyrVewyBIeHtk/zyrh6zd+lXxRtdc
         iurCrPIBO8Quot7GdbNdt2LFzwNi15go4nOrDLLR95YE9un0H7apOvDU1jJbbZt7Foqu
         CXkf6hs9LqJWkwA3xsDNWqSZDPIEdbZVQv6aAMVs+juAX+yZCnwj5nlo2ug3PMjioxyB
         IHUcXTnaZeuaKlF492/+QBQWCZSCYphJrIp056ac9Sn6vR3fAg2NEUpRw8xf/Nxgj+qt
         wJwA==
X-Forwarded-Encrypted: i=1; AJvYcCWargmMcsOj1D3en9K3CYNhyafLmn8/do3/y3r1Obq/eS5h0XPAIjkl7Ib0rsQQkrGwBg3nKYfu@lists.linux.dev
X-Gm-Message-State: AOJu0YzTX/XbYRSvV8eSJgBrkqP6UZoG7hyrjVBzgbZoZtfcbmccFKii
	VTeWjxXnN+8XQimAURAS4AvmadDan5NMmPJNMNO7U1X3iWxYqNwHpeu+kK0TZ8pbUsIOYNQ2HCB
	QiWRzdCBmmjb/WrbO01YSnn5+LDxHRxH6Bpli3bbu/g==
X-Gm-Gg: ASbGncsWC+Wixkya3jmfuFTeqy+Bx9MNus1MrWqBRRz7f1n78Qh+s8rt46Ryr7/DRqw
	DeKD/NbjjNUL9MxMxCmDJku/zaldN2auoVYZR8mr1e6S/whppQTGC7ymENtaLuJpQsqPjo9sOWp
	iS0FpP1FMl0jw5f5LlkOaA7rgfISXgos/fMjjsFDJJN4uwPoN3HOpAtJKxZosonhyjWuwJIyC8Q
	sgJ4t8=
X-Google-Smtp-Source: AGHT+IFaZF/ws/2o+IVsHz9PC52v3WyioUyPmwUMSCJO2aOKx5RBikHgg3DVCfdX521mViGqwYkoA21PN/BpPcwTrHI=
X-Received: by 2002:a17:903:2ce:b0:240:84b:a11a with SMTP id
 d9443c01a7336-245ef124770mr8124485ad.17.1755645229801; Tue, 19 Aug 2025
 16:13:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250819122844.483737955@linuxfoundation.org>
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 20 Aug 2025 08:13:32 +0900
X-Gm-Features: Ac12FXxH2I6qrc5dZhBRts0fiH57_1LDeKBa6_to3NcZTtdevZEnOqUrhz1C2LQ
Message-ID: <CAKL4bV69Q670+9Y0FaLJL83cO0SM0TKsjsvYuNSk-yFtsE6JHg@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Aug 19, 2025 at 9:36=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 564 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Aug 2025 12:27:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.16.2-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.2-rc2rv-gb81166f7d590
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Wed Aug 20 07:32:44 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
