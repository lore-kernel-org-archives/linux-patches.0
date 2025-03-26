Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047ED194C75
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 20:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743021872; cv=none; b=f2NBX0a9QVy514AFpViRlR91R41YCkhNLbd0QnRotEYZqEu0TdGOCg6EP3vz1i5FtjZRGmx19PtL8hhIU+IvpL578qcrpyofCTFZS4egVDYcl9+qKHhQ9LDJ8n79G51M66XBJ5BvJV+hCmAqwbvQJyGVL+xt6f6uqeeoJUgtqwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743021872; c=relaxed/simple;
	bh=g//N0IrGfLT13tbIdvSmMzlmGx9e3qigUl8AcPpeR50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aawW6dtkKORVHVfyNsJpQYcQ9G8ITSAmM3n+B9+riehC6AcP6L/XXj7kVkyL433+sGwXDcj3ehTeGIF1ZhSgyk0NGphytsFzrJdyYT0W1qKOqTXNsKtSXfoEJmsax0nO1qZ2WURhnBzK1f3le01JDi6mE/v/g5bwMexnXlKiQj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bVMHoTrh; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bVMHoTrh"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d0359b1fcso1836715e9.0
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 13:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743021869; x=1743626669; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BzroiA3DdY1mmxM19Ga6jmT6lbdk6d02D0Ys+Q3T2kM=;
        b=bVMHoTrhEUG1uDtSgTx6fAv2sJTy1zxcxJZQhcPTtwxKIO9+Fiv5c2tWfDXMJ2duLz
         I0jLVzW/29ofz19IqhTPTohqrchcjAHPTajuQH1PC75l5BQUoxgdx04FZ/1OTjk83pDC
         2Lykw7GUXNmeQDYy+lbfEy1wWQhUQULU/dXY0kTHFmfPFpysGqAvC9gCfwIDU/RfyaxP
         PIN8YkyY2gHQ62LIfm6DTQtAklCA0xOIhmbG9Yhq+OlLfMvIkOwh09e6s5xkHdAskFul
         +EaujHuNROnvx9NCJUDFqgKcfZjuaYEg9TL2TETg5kL6CdXdLQFMmsEuC3f09kdjlsnu
         9eew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743021869; x=1743626669;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BzroiA3DdY1mmxM19Ga6jmT6lbdk6d02D0Ys+Q3T2kM=;
        b=RGzXQawEVChdaygwzS4sSSR9tNBlFgllEwckYHMuB40syNOAeCgja6IBZ+8unujQAN
         1ESFdauoQeR80OTZRjLE1uYLW6YkNYRBTQbdByjR+I2AYy0MGayJHI5iPfGpNhn6/C3o
         3OSvYuDWGgBsS8mSynySXU3Q+qv2/xHRFIsMGnfDFMMWLhwXZf7YYB/0nqpgIa6v4MkE
         DYhvUVCNHSvt1yDi/vtUj5AS0zHX2jTK4QFmBxcNxQCTD84n00y9MHPHHdoKwIGXKDwt
         N+bN/OyrD+kmyDH3byvQRr6gdVbIlae2/LaKGHmmQ6dhuQ8NulH5sIxDiRteWUnOlR94
         zJHg==
X-Gm-Message-State: AOJu0YymXsEPlf2wbMfQmpsgkvhisnvMk2e/LcOifbOTfqn7gxedEvHX
	2XV9+mZqxTyobyaK3e5qvfXl6FepQ5JFBveWMwM1czYue8moMPi5Vejw
X-Gm-Gg: ASbGncu4YHpKIsolhI20xK+6Nd1/V1+bqDYpquH46fZAaNu26cotbzUpxwMnSU3e2cC
	stLuYw1LYliCyw8YTDmOnG9KQQYBBaATK9iiACibx8CwMJZW+A89OQ17tZ+wVRG8EdNd2VfIQVV
	GVxkpVU0Wj0helLq1BuyHlAcDVMml5Fbd0eZxjbsmpSkHiUqTXFOzI7Dc0ot0ly3r25I0CzKgJd
	6VZR5/NMoG+rX20FO6L55parnpc1gYGuB/R9BNK7bGguXAMtcDfzl3uuAO5mq/hN9yMTYVdzAzE
	v51XVNrj40epeidrl/ehF6yERe+MgV95hBUl26Da6qrr1Cq+6LfMEm0V4xN5GJC1hjzZARjaJ4U
	BNoLGg9BQyA5JUXGAfAbZ
X-Google-Smtp-Source: AGHT+IFIn/5O+GJWIEYHRBcJK/SGhnNc1/rveGzy77iS8kfb/uPpf0KJWaUAcFjw4m7l+ZGWiB3cbA==
X-Received: by 2002:a05:600c:1f94:b0:43d:5264:3cf0 with SMTP id 5b1f17b1804b1-43d77643432mr55561185e9.11.1743021869132;
        Wed, 26 Mar 2025 13:44:29 -0700 (PDT)
Received: from [192.168.1.3] (p5b057a21.dip0.t-ipconnect.de. [91.5.122.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a3b4bsm17650135f8f.25.2025.03.26.13.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 13:44:28 -0700 (PDT)
Message-ID: <58a1ccf9-2da4-4fb3-9310-78eb2d4ccb3f@googlemail.com>
Date: Wed, 26 Mar 2025 21:44:27 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/76] 6.6.85-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250326154346.820929475@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250326154346.820929475@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.03.2025 um 16:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.85 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
