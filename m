Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82083E1CE5
	for <patches@lists.linux.dev>; Mon,  4 May 2026 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777913591; cv=none; b=BCEddtI8Fjlb8LHRyGSBcdBikfUKrkikm43Lfx/ZCaWY8L2X6t2RZ7PK+MTDQa6Bl+pVcsza8Y5EDvamMaSKwxoBYxrrNCMaUpL6+7g+rMGJXRh1FdxKLHZvu9bfZyei9PFhJgWUvrZ558bLb2NHKDul+UwSgyObmVCn8DFVMAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777913591; c=relaxed/simple;
	bh=VvoTMuBC6NabAMOjcL5+KrfCtlrzYsEb/kwkobz/TJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LITaDZZJ0tHQ6LdFEHBkddIBUpmlwjnyzfIWNb7S/Si9ikixYYxMGIgBbDQk6vl9arfSV/I0mgSfHIbDlQdAdEhJwSS3OcDNiy0Cx15pAKD8n7aP6hwh4tLw/p6ZK3uD9amhvOv+ud/iBQ6MrKCUAF+4dod34LCJ4S6NV/QA88A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=L5hhkTGp; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="L5hhkTGp"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so41688725e9.2
        for <patches@lists.linux.dev>; Mon, 04 May 2026 09:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1777913588; x=1778518388; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cq1UVChEUo34oLEdykFyKbSvPVU5W9ODBCkDev8EMiQ=;
        b=L5hhkTGpw0vIOleSV7VoC5YOrtR+qFnCsHTxPn1qH3QXdeGg5nqlwCwKbVHEoa2qti
         qrhthj/fbOwdo+yl6NeEMFkLgiBMF1S4651mjxnwdEmcVyc6kO+TjIbTk39GjHBsp5eR
         wiVdXc5Xe+2usrVH2dyZ0Yy4wAUjf8ee+4XF9MEmgdHVLOjmTiW8iTKDD9TpRLOBVIli
         nj6QSojRB2FbuYAnX2gIgywlGegFYmolfEY7ftQj395CwRlXdZI3SWCcJfLzSAaIqFbT
         MYDACwiCD192Yesxnez1PArigI3a0pdazLoWqAe4QTIFQ61DDfZPZ1BZF+FVJSj7uK8S
         KwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777913588; x=1778518388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cq1UVChEUo34oLEdykFyKbSvPVU5W9ODBCkDev8EMiQ=;
        b=eAp6iwS9llzHvPYnAfJHYr1zytpY0mKtRicPOvKqJuhUyNCL3HPoWBFR2lhg4STV8E
         2skqlNbFq08ld0Z8BINwmNdPWF4jaX5wwh38psSWRXIqk/5vnjmCA7tMPC9/20hSy4jV
         e/hauJWZY9cMXXULE2okVHSRH55dumrA/5i+uqzL+PJFMxDiFo+j42+x41DVb4mascKL
         6xlE63/VF+vWnoKGRJqDHX7j53GcD4rhkZE9KMeT2mmqVW+lKgUmj13nj4xvE9AQmzL/
         6kx9IrQ6cDMQL106TxP2DV7HbO8m7z1uF3cx3xyILPuY8eamwD2ZWr+AkXABe2hVwOnQ
         s6LA==
X-Gm-Message-State: AOJu0YzojfaX2ROs6iEdLhiJaFRK2aYY/ajnxEZTBNB2t4YGIf5nZW6R
	ToWIQ2gBmMvn0SUMLUrcsIcZ6/m2/cc7IzqDChASkZk9bDFJp3a5cQI=
X-Gm-Gg: AeBDietcSCtFmxjoG1OaSE+E88mW3LlmGdw0oV4C4fdVTCqkJVESTPB7GBe/e+qxsrv
	yySSr3WkgaXTGOo7cWNb4wswn61lxlI73/UThK5Z3/wttY3D0OWhgH0Iko4ETvHzVuIAFGqpFxC
	kOGELB/pHOOpwmQaXaGm51PSi9MZoCBD7Bwx1WEUQ0PPkF8KJNcxkm/q/wkxneiXlymPwy9zQhO
	Hcmg6zr11GgDmAYIrkzf1Z3YngMvdCIqj2zDghLIpYhmyELZGSE5WmiktaLNSaxi2wLPbs1fKRq
	sofE+1H6Ksa4XQl/CtNioCxmyHlQBfJojKYv0CCD8v5YI6kkpp3/XGjHqnz6b3um/8FphyCyZEc
	XOsOF11o0DL99F/SLnq8g+xY2RZrhTj6VknY5ZwwvXO/jbV7WVLDLvKvhEqoCZe0YbXwrEV/G60
	o0ECyYqgPpazcm46mkkZDcF6yr1+9CKnQ563AqLZYisdTHxRAj/yQoD4bTAm4Hahn7CRoZX5+cb
	bDQ9BObv8/OCw==
X-Received: by 2002:a05:600c:5303:b0:48a:53ea:13eb with SMTP id 5b1f17b1804b1-48a9852c5c0mr190080195e9.5.1777913587969;
        Mon, 04 May 2026 09:53:07 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace33.dip0.t-ipconnect.de. [91.42.206.51])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fe953besm118466215e9.2.2026.05.04.09.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 09:53:07 -0700 (PDT)
Message-ID: <58125764-0397-4b11-939d-605a30e4055e@googlemail.com>
Date: Mon, 4 May 2026 18:53:06 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260504135142.929052779@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.05.2026 um 15:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.27 release.
> There are 275 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

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
