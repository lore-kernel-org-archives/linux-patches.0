Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419DD3161BE
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 20:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783023935; cv=none; b=thPrRXe9h+VmssoPReS2XUgfbcBTYUwYMvi1GMzZBzThiPeZGky/b50AMfb9655+IZmlTwVN2gvyGc53z5U/Ehes3ydW6OeG76gCmTz3ayDGjnAWbXinbT4rta3SP9aNF4eMXqBiJdgl9YTBkbAYE/vkyt+MLGoY5kLhy2TX/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783023935; c=relaxed/simple;
	bh=vLz0RP/pwjcvD8700PkIjsBrjDT44NCOXMuN85WlfJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tCteiv7qdfOXNiNQtMlZubq/xD2fKcsBOInvINtQgA6FvLAJOJTgoYtYywgDGBBSmWklXmoGJC16/Q2zTEl6rTJXeFSJmzNTuiN0rLgs3itSo7RXjbetjmUW3WBKZSRm76MLH8cJ8Sj70EYk6GqOA2Z9XlyEUzqKGINVajxVqSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ivSDZcOi; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ivSDZcOi"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4758bd3731bso774647f8f.0
        for <patches@lists.linux.dev>; Thu, 02 Jul 2026 13:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783023933; x=1783628733; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CE19y7mESN6tMsAW2lIFx+MqHczMs9gwLQhyQhGrzrk=;
        b=ivSDZcOiwjtdU4jkegZDfTTZfrrIR3x/r6dqEsFknf8rH6O1Z0ekyTiErGjth/BwyI
         d4z4xY1ql0RErOHjoi2QUNQiPttZ+lyvuyKqh8lQUTCFVd4sdi09v6v/UH06e9wKuMDS
         x8nAbUu2gBanhMPTEseC0qkGGG+hl2serx+Fi9IUliyXtJrv/d1uydcMZCEVOPZuLq9T
         v8hYThfap8Ygpbz1ux6GwTg2xdH+C6gIdERivLD+hZaaKsxpIqmoZG5u0ka9J7yoe9nt
         V+LRBiHLdeecPN8SgEB9N0KXHwf8CHFq4hXw58WCBkwIq/SDwHE8DZ/J4LUDVxFF9fDf
         2P6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783023933; x=1783628733;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CE19y7mESN6tMsAW2lIFx+MqHczMs9gwLQhyQhGrzrk=;
        b=cs4XyRBs8BR7k96jbyHcsAeNgsDtWNIFPxJoxSb+KHrKOJTkYf514B3OizOzRlbwsA
         ymJX017lruKSMcrqds72myBonT6HmdZqoeSz5DYsdnGt2RwORbS/Xy43XwwNzeYCq7w9
         7XYLNoXSD7wBktq7u1qEBX1uZm4wd6A9Sy6oXuO30BmKkytvsSqerflZYDscura89iDZ
         Mheno4RhfYreUtVhIyS8I30BE0YwXj9uX8TuWBd6hOdurJQheSUMlFKRKaODL8230IWX
         tZ8i0ZaRadrv2Vrwx1LL6xrul0AE0YSGQEbFtVoK9f6EUisgcrXQq5QvJDJOZ/8aLMC5
         PALw==
X-Gm-Message-State: AOJu0YxCIPRBEB+Tk/csRs7KFYGp8wO8E0NAqe0VLa+5obifnTqKU0Sl
	MC+70aNUf38KMLuuYWd2DRCNcm2Miou9eOleAXaIersczHtuVXzO6Bs=
X-Gm-Gg: AfdE7ckpuADT//eVb64syzUhNtGn6brt8ZJjdVLXlFq2Jsivl3o1ZeB3+HRrcY1AJfR
	ANmzeOWAAhQ4OD8w9F1XoSQT8wSzSoPBRPA2kCZrusPTJgblaDHlEZAy+Mce6kHGKnIDfeOChTl
	LEogBET03rvIRVCb/m4A/aKBoeZz3NsYkQADf98BmG2liRJ9oY/8jiPjePimTEU0zrA/qCiDebP
	S7oF12QcuJCLSogokSN+k8zvyTo1XZ8m+M4WBk8hKPMdZvDzI5tgl1XWI1KEJf5uF9B8mOjZviB
	/vjRGI0JaoPG3+00I171xDdRMuEK8RyA93Wg6VD8YM67mKJJltJbnmqeN3HHVXDOXL5TpBGbd6L
	0dh1Zz1TAMMyBSc0ANY+8oYpodYXKZ2zKKA90jsGpKqAvMqpSFQ0Ini/sG9Gv+IqWVM8p7LN1cB
	yvxkkEu5eIf2e2KWSmIVv9Xjp5yI0VyNbV5WtAU8IX9zK+CIy8D9ZE/o+mdTXj4bQ=
X-Received: by 2002:a05:6000:188a:b0:474:88ef:cdec with SMTP id ffacd0b85a97d-479347abc89mr2414532f8f.6.1783023932557;
        Thu, 02 Jul 2026 13:25:32 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac307.dip0.t-ipconnect.de. [91.42.195.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477dd94cb64sm12216643f8f.23.2026.07.02.13.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 13:25:32 -0700 (PDT)
Message-ID: <eb95ea8a-7a4d-4e04-83ca-67242a746a1b@googlemail.com>
Date: Thu, 2 Jul 2026 22:25:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/129] 6.1.177-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155112.163984240@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2026 um 18:18 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.177 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

So while I'm watching the Spain vs Austria soccer match, I managed to do some kernel building and testing...

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
