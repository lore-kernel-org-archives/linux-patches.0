Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98352E62C0
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 05:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771392465; cv=none; b=Q7/SmMHi0S/E48LciKJgGqFzFv0uOEkCipSnvdZq/G0yTz/37a1LxLz6XwauQX71T8u6N0YTcoRzb28QWl+huou9XToBbSdEJvGX7Jtic+3jHOWGRC7q8o8A43GBGDTA4gsviY8Ik05dSo+XRX6P3LLdraGYbdN6wZEJpq3f11s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771392465; c=relaxed/simple;
	bh=B5FozkfeaeLMGlDnmtXlZiNckvHKetd5T/jIhWcYZqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WRqNo1duR8kkFVMA4dEY2FO/hSipqRMF1jvdd+/fi4qdsvFsXsYHhyxy743Zq0JDAoK7ubDBOkKDp3ePG6/mLZt+W615ZrbzG0G0G5FuaQU6c6+q+UoEo+eXxdoG1ZgKFLeDuYqE5sz+BGRdlm35se72e5hfbpYeCN6DY0h4hdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=if8qKc9q; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="if8qKc9q"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4837907f535so35100965e9.3
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 21:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771392462; x=1771997262; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1GVNW12H5IXWe9p/24Eu3pPv9aw4qit0ROPdy8JhWwI=;
        b=if8qKc9qlLaLOpaay3Ya01mff0zprknJ9h/z/H5ylTUppoACKgLBfHT9WMkYsg8QAT
         M/t2AUHBhKYIvi/Q9qsvDbrBnDSclZhkn5/eoEJOHrzSR0io97BFzEUYkE62ausSUabD
         2H+o6smDPG+qsZG+hBLTpTapCHLhQ7d58QBywVR4UJjzffMOZp6aiLikREPEXCo284He
         LBDOP67aO8M2nFWNF5jHvjaCn7IR8sEQFgr10KrgD089XuAdY24xUweXnuqig2S6dlBn
         YbIkXbMJcYQkxIxapKtYnuf9s8ovyBlWGovExluTjrn6JEeigxh3jCnuraxG+M2zR4jR
         vB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771392462; x=1771997262;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1GVNW12H5IXWe9p/24Eu3pPv9aw4qit0ROPdy8JhWwI=;
        b=OM9Co6vZVnHu/csq6LU2pBF0ne2WsFqg6ZGBRoIk+CzfIOJAcfrJ/rpBo6kfGJ0xle
         sbJ545meYCdX8T3hrdh/Gp75vcpPqi9TYrxFebP3G5rdXIPzWjTJKx33xV0pGeJpSrKL
         /hBe0lJELSVXGLozl1Ye0IoDssxoX7VGCGmFbKVApaJKKJmX6kwTic8w2Hoh+91Rt5Re
         gQTkihPWWoycZ8Vbws6b1NLEnwtw09YWY4uFDFIZrdNya016pqHhzdhKdQPYrvGGa3vO
         R0MxDd0wMrR7Dr5GiwFnP+C+jh5AUWbNZKXjoGUPSfbgwAnRJRy01SRYHK6ERVA8joP+
         h26w==
X-Gm-Message-State: AOJu0YzLMK5PqZfCHYYn6QgDrT5MmnoRHFAtrjdCxmIMEnrixkoh/XNn
	wl3YUJeICn3S3V5rMf4gFK7tgJWzMCO3tiTdjDV/r6JZAmSmbR3NQDI=
X-Gm-Gg: AZuq6aJlvm6+LKMDN2Rs4KBVnjXUNb+HUijTIXVGKq8BerWJVQWKQQvIXrNCnjXQMco
	2va6jUBCFKNN6Q0rMeY08v9H+p0qqhLCRTX3WVzuUwGYiSra6zEviw275wSXAJXhfk93C0EF6sq
	yFJgG3oOizT4C+zIpKHJFF2kHg53jfEZWvDoWLEBmUrgjf7s59zdyGZXY1P5DDeUGbZ/ny0kC1D
	4WuqAIJ/O+2xguVuw/YdJEdv9FkGaaEY7N53kZ3x31jrA/U8p+rl/4FmkRU3VOmrGr6XQxRz29I
	Pg9x9VskjyvEr3IfcPnQIIsuZ4xY6xwiYBCmgxFjK0EayIFgm4eE2J4Cco46dQlyPW7hoDiuQPZ
	lNjzEVKimkle3WuaPmfIBDP2KIWAEILgz6XZf+lvFznS/mhUbMnygJVxewBaet1I9LLL3Wh3tGA
	HvkIqRfoDuDSqvtTxC9LlpRXDB8O8Cq87J15NpJ9/zzVzc7VZoXKl8gaDGf8pdsvsQkONS4o+/b
	ZA=
X-Received: by 2002:a05:600c:1c08:b0:47a:8cce:2940 with SMTP id 5b1f17b1804b1-48379b991c6mr219951295e9.14.1771392462010;
        Tue, 17 Feb 2026 21:27:42 -0800 (PST)
Received: from [192.168.1.3] (p5b0574ca.dip0.t-ipconnect.de. [91.5.116.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d92267bsm851744885e9.0.2026.02.17.21.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 21:27:41 -0800 (PST)
Message-ID: <5f67b793-f229-47cb-b0a3-d7165ac75dcb@googlemail.com>
Date: Wed, 18 Feb 2026 06:27:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/64] 6.1.164-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200007.505931165@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.02.2026 um 21:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.164 release.
> There are 64 patches in this series, all will be posted as a response
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
