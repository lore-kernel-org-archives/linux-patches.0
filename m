Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B7223746
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719325089; cv=none; b=TfswrJGUGjPq2t0nVrvbjNl5aUoaBLAKkxzQFx7aVHqrO8o/sWyDWcB/7xfutZbd87DxpI8ruH28GrSvHnoJf/kWkn+/Rm54g5Q+QsfBE3Fk3l4jPBgAaS8Plt3mxKeWpxB1Ejj7UOuVRXgWNi3axOxrZymHV1aoYYucbn49I3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719325089; c=relaxed/simple;
	bh=BaYfxqnOObdNpzn2swt4a13d8uBre3Ho9RtZd1PZMnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i5cCNp085TZrmKRTw5vo32mHxehrYL3etLjQX89G2A5OqIpzjI1px7hDo6QXI7Vj4YXOjKFAkttAqMmujx1hAEbZaccHwCpNRnM5FqqWc8PATkWxSXpntPMPGEBuulZ4F5tbXuyaigOZpsQ5VoBtJjCMd3mNDmwMPJoi1Z41HIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CrX0q/OT; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CrX0q/OT"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ec10324791so68764311fa.1
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 07:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1719325086; x=1719929886; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ORvOd9QIO0A27sD0yjzAJaWM3oVFw7Nj8mJgN4e+RI=;
        b=CrX0q/OTFmIw8CO5v8oeyUoMFWq09spJFsXYhQPZugwNKxa1vxpfyomwjmEuKUH2Y3
         DZtNlvLye/Y9AtgxZZ3V/D0CJIiu/+6D+ouLc4JrRrOcjR2KgutZWTXJvlsljdhd2Lll
         nj0b+b/fTuAxGoXdGT1v1pEWODsyFygA5KZ/KRUiUqLCgk/Z2hkWKfMxwQVlHYp+7fTG
         GMe0Jf1c5k6lEIsYMbEZt+2Xe0L/b44uGY9HbWAc64xpzJ937A2+AlTpqco8Lo/GWdi4
         2j5qfFdfKKDHSG4N+/UNGM7xMXegLP/UjxB0674XzPQIycuBve2/RxTnQoNdQtvu2kuM
         UXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719325086; x=1719929886;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ORvOd9QIO0A27sD0yjzAJaWM3oVFw7Nj8mJgN4e+RI=;
        b=g73l6iMbQPSKv2up3cUPgwl1k+VPIglkTY7Tx136SGFJuK0kYOQ+fCiYoBWNp/Umd+
         p9Xn9kKZaxR7RRJkqoC/GnHS2UIFot/q4iFcqJgRIZsosj6bM07RLQ9Jxk1afxgMIfEr
         1JXoBU6hwgE2BJvSM3Q1o7FzNpZqQQzeIG1iaVoduDbINnJbFSd0j2INAQVN2Ue/HPWm
         Amv17rSd+WnguqfON+AIJmqf/AV1pKKAAqllcSwXPZsDpk4i/CEixnBsAbmVbwV21sJp
         LQGkFuK6jyv2LBwiIMn5YSRi4xA4XtPMJrMnXfD2pmvIWoFroUX1lCvqzViXiIxCHjLe
         WVOg==
X-Gm-Message-State: AOJu0YxpWf+uFDLhdbGWmPJ7q1wvcDarP/wo+LwaJH2rdaPN77F1kY12
	jAyiiThcXN9bcw0tmtznyYJtE0uWxMQcdPy99p/BiPgEDjBHbz0=
X-Google-Smtp-Source: AGHT+IGmK41bcBWbwZqPaNcNgMM9gGnHoWpBcPBIBZOXSb2Ippp2x4oNHo1MwNsemFX0W8yC03jJUQ==
X-Received: by 2002:a2e:9d88:0:b0:2ea:7e50:6c94 with SMTP id 38308e7fff4ca-2ec5b27e7f9mr48469431fa.16.1719325086080;
        Tue, 25 Jun 2024 07:18:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4a32.dip0.t-ipconnect.de. [91.43.74.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d30427976sm5979314a12.33.2024.06.25.07.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 07:18:05 -0700 (PDT)
Message-ID: <f09ccc14-fa33-4887-a443-669d8e50242a@googlemail.com>
Date: Tue, 25 Jun 2024 16:18:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240625085548.033507125@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.06.2024 um 11:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works fine w/o regressions on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. 
Up and running and compiling 6.1.96-rc1 under it now...

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
