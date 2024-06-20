Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEB01946F
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 06:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718865293; cv=none; b=C5Q4l+YauTYR3udCdE0G0izxfn0MqC5SgxWWfno/Tix9AVvpcTMHO4lAQ2Q4ULHVxyR4aY6lVH9whVtZCm+EskTIixsI+xwPmk0/ciTvQagvZiBKOVvSxjXVTmRkqavY4o2789knZ8OdP1i99+9/MxM4F/Dbl2ccOOIfiKEDW2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718865293; c=relaxed/simple;
	bh=SrHVASrlu3Ppa9f14DtCPP4A2oJ+yIy9bAmDdRN3DF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQKAxUMEVQo7aUnqO/GMMNzfj2Zj3LQ1PBmTXOgmizXbck76NrRgdcQPJxqkfSXC/pzO0OHufFjjCJLqbZlbHvdb5oG4+Ocv7ZJRzyteVGEmXo2SJmQr5rez9hLojMTN4A2tWuFsbQJgFQh3bDop5LCA8IALq/sbra8hQJHiKjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CjypwEF/; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CjypwEF/"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a6f9fe791f8so89860266b.0
        for <patches@lists.linux.dev>; Wed, 19 Jun 2024 23:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1718865290; x=1719470090; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l7QKZPgQMRj4pucTx2/beNO5zVyd86YGn11PumdUlU4=;
        b=CjypwEF//EPkAOEu4ETMeIsxOBemUVAZ3A2yp+u7DnoEVg5WM5BrPDMIjCTMFDCl+3
         s6lLOG4epHfwEGZ0SuhXUQyQ+4FZRlpKuip4HXrkJW/3EjYq56GkPi59PPPA3oEcYQym
         0qCsk2zIHapWVyqcbse8+gei1xsfq7LcyBKgv1BrwS4zhX6WEw0aFZ604M0FzISvx2wz
         voJo3xEyXS+lhAC1+HkmA/W88ev7iyrXOb7gW222VWJQk1FskUihYwXjz01k8ObHa88j
         1Ry9J3xpiNTp5h+I4a+rrh2s+bS6K/M/CncFTQhRPLBcgitxeAgZ9HrPDc7Czbcsx/iv
         iqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718865290; x=1719470090;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l7QKZPgQMRj4pucTx2/beNO5zVyd86YGn11PumdUlU4=;
        b=EcdtBs/wNH3BNP1wIrD/+0GfnxB3ZmF6An+fFnGXgfflZinS9RMm634zZxIminB4TQ
         YwFZHT1WMlYgVce/fLP3M88AR7pMmTcBWYLy2JLk0smNef0ITmF7AqvfGzOLxhsFscuT
         frR4V7GmJEXabx469iLKkByg9DixCO5t4bYK76G0ID8u8uaoIWTSI4GJL6WvclLSj5pl
         HLE0sq1xHDkb8Gd7blGepotl9gQ2Svj3vkM7kIlVhXtp9rUgjaVzWoXdQrIaKCB4pIak
         K+OxMNWQ4FAM7nxzMLCh2jsmYrQin/2UweE6TRCQ32aSi5hTxDihCD9biGFqaHel7AKD
         yOwg==
X-Gm-Message-State: AOJu0Yy06MmJlfNJxvK2Z6pDn45KcgdKIvzbgeuRyHT/HEVMD6I/pRSv
	mIQPzpsfKpib2bi4ZyT2pu6v2r/0/SwGl5J8713M2x+WECKZQ1Y=
X-Google-Smtp-Source: AGHT+IG7OWw7lWn5SQ/ID1IIwKfRWUNNqhkxSK6c5AJaiuo89mo3Hkwe+HCpcggg9gxEagYRrEf8QA==
X-Received: by 2002:a17:907:c283:b0:a6f:506d:2cf6 with SMTP id a640c23a62f3a-a6fa438e013mr296201866b.26.1718865289693;
        Wed, 19 Jun 2024 23:34:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4f33.dip0.t-ipconnect.de. [91.43.79.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ecdce5sm728062466b.108.2024.06.19.23.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 23:34:49 -0700 (PDT)
Message-ID: <57c50994-80e5-492b-99a4-97a7cd05bfbe@googlemail.com>
Date: Thu, 20 Jun 2024 08:34:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.9 000/281] 6.9.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240619125609.836313103@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.06.2024 um 14:52 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.6 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.

Builds, boots and works fine w/o regressions on my 2-socket Ivy Bridge Xeon E5-2697 v2 server.

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
