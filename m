Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02269272803
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 03:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771383739; cv=none; b=T8ZSkUuV7/8O8FD+mM54yjBWxsjuNYLS9/JAnuDtKfdlM+v41aKE7aIfxCmqv19rsIj7KJbJ9I224UMYEZTebV2Fn8UGdsYpURzbrPUiGt7bAp6ZIbxcz8CzRzSHDInVoAvyjmzrtTu0Sb0tSR5Czf2kQv+VgMjpjgMl9EXiN74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771383739; c=relaxed/simple;
	bh=iabCyX/FazQvASx9cQ/P/1vUPgbITwBZP8883+/bhRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GbN4shJxjbAsWugWKWBpP9eVVY7tuEzIE4pChm92Xie9KjjvTS7gPOjqezGZus/cPhTrEF+cPDB26nPWDzrIIJo1gUVd6tloU3VVSm4Ag3k6vi5CiIAhteeNRhioAFXmoqkH89sXHGVV+sEgCbTIoOAWEqSxHpUvJMn7wFNL0p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=V8Rnkl3J; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="V8Rnkl3J"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so45036365e9.1
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 19:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771383736; x=1771988536; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ufKmFUfyYC4SwG+YM6+9bsmvByn4DxRB3ES5FQ8xo94=;
        b=V8Rnkl3JJ88n738R8g+kocg1VK5bpkemWwKG+pS0kTveSRPt9kl1SwxhbDxSDtzk19
         LtjQnAhW8Y7cEraJrb87R1qcdt1pdtzArHM3nBvESrKw7aNs8zBwte6AbTh2fu9ggTlu
         aw4BN0inmJi4ZHz5R8LBAgWzV/7JFUn914srjdvkM+ORWwkERKGvPs+2x3klPtz0imcx
         RwXDGefzfv+/I1Vh76jk7WMN2aov2eCBKKcjjSpw9dKV8Qd3CpD1yHIce8EXz/QdtrUJ
         obl9N4KRKv58npD7yXoB4O7YCX8OT6pZh7CowP5kkH/KzI3QzhvBGiAtPqly6D/VhKHc
         mYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771383736; x=1771988536;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ufKmFUfyYC4SwG+YM6+9bsmvByn4DxRB3ES5FQ8xo94=;
        b=THuDSUU64VMHy4YOyXR4gD+XoExF244bzYF582dxvERY+uQOSVeGoJqm05Gz/e9ORH
         ME1oxRMzUwfMRz6S6Xrqhm3ESNv4n5HKAyavZ8ZhDtSkMNOsjczyiJilr7hAbeCv+9/v
         PaxS3zXfhLUyPuG0xqmecdFdQyVnU5EvzP3ATn21SI6ogtuLUP7BmizqD3cJYUM8sY/P
         akZirimp7ISjDL4Y0O3aUopS5ObZYh7/Tat5Zkh3K5AEM2+8Z5WvDiYugYbD2OhgZVAZ
         VDWxzyEi/wxZ9oe5Oj1p1ke01Cbsgc+LimnV3brxhwpR3UaXWBZc2UWZi35uhofUJKvA
         xPew==
X-Gm-Message-State: AOJu0YxdQQW43m27h7DQ+c1ntaUfyTc9JzgxoyWbM/sE9D+t1zwQZ7bn
	SJGBOlBBABMZdfc6clk5DE7NChK71jUe73xfE0dcKVWMBPYph/JU6tQ=
X-Gm-Gg: AZuq6aI4x4bepNaV40YLouI1xm9pYCD/FQGpWGyQJNfZHP7Wdo2hJSor+BhZdMc+5Xa
	SQMQ25V2sfZE/nGxPje/G9JMz2w5j3seldRHy5na5w0u4ooZnPiC91B80ndPw1C6uCtjyREOtHT
	DjNUZ51vkMeBG7FpjqHTyFijAD+zkIzW2vu8fUGQY9ODZK7XV+yzp2ECTx/dcrhkZkTA8c2GKYT
	e//GPv8N3SDJ5dbzE0AHhK310nwpa1Lue42FQjeLhBGXEIWrtoRP/0drEeFVpzX8gQL3rghdn+o
	F1xfGb7BaI4IEipyJkM+mkz3dlnLEX6JCjuD7UNQXP9cbVI4s3ZxzxWePzLlC1nRsxEbW5kmf2U
	crRRNnArD3ngx5rgnUbXdOLZMWHWzobaZptzkJUAipwpqBFaKOVnrsomJPzASXkmCJHiE5tr0Td
	J2sFqkU7C5n24aCxUkmswbS20O4wTWJx1UHzRKHilGmMIVx3BsCVrr82YpbYnMZdRumtmDsew8n
	Ig=
X-Received: by 2002:a05:600c:6992:b0:477:9eb8:97d2 with SMTP id 5b1f17b1804b1-48398a4978cmr6455245e9.8.1771383735812;
        Tue, 17 Feb 2026 19:02:15 -0800 (PST)
Received: from [192.168.1.3] (p5b0574ca.dip0.t-ipconnect.de. [91.5.116.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d82a4afsm984807165e9.11.2026.02.17.19.02.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 19:02:15 -0800 (PST)
Message-ID: <c36c9e46-37ae-4665-a062-c5a5f85421ac@googlemail.com>
Date: Wed, 18 Feb 2026 04:02:14 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/42] 6.12.74-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200005.998240758@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.02.2026 um 21:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.74 release.
> There are 42 patches in this series, all will be posted as a response
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
