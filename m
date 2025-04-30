Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CE62DC761
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 01:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745975438; cv=none; b=e4uphQa4k2EKO2DlXwQydUP6cJ0oIFaTy1QBxBghhTvjCXWMjZaStpfvHfrOWfgD+hFbOUe1b58wwu7578YqoVDECGdC0tktS5I8iw0rUqZAOVNw0uCMxeoAL8u40svRBDohVlnuNb0HK51QqcR3v3ns5o5v9N7FGHOGFfxkGO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745975438; c=relaxed/simple;
	bh=GcA0wqe4bwS+nqsbaE7zGxsfAfwH+z1wdZ2jUKGpfNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TcGIzf/2BvJKPq2M6NK0MZZv0eoQbboW+H0LjhnBXazojg2uor1ldqhdK/RS0mXtcCFcokFP9ej0H18IyoLlcOIUSkNItDt7Woyo9z+ES4SlXvY0qIwLsUXwO82GcvNSeVwgjeyIYM06Cj9qy+jyc7l183xpk4b5aUAX3A+X6H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=exTIOqvz; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="exTIOqvz"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39ac9aea656so7662924f8f.3
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 18:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1745975435; x=1746580235; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fy0EpqkwjDtmTcF94zxnemA5fOntKhPCB9hsiCBnym0=;
        b=exTIOqvzbqak4pJVbtx0iAUY4xEYRdicZg+2k552SYOZ4lTeTNbwstnSvcJH1GPRdB
         /rcl/tqHP1fXJcRrnIm0UmbYWpeq+LblAf8HU28d3khHiQrcwxdhTXaBjUE7l53gqvnM
         IQ9NhHO5YVj4cUwvy3FGgw4TRyI8S51mZMNJTbF9YuDvIj722qboPrj0fssGXiRQX69j
         8rlgjC+4CiJ65/Rnqx/t94G28uwVNzfWepJlOc1jlp2vVMWtW6R1hK1EBblpDNmvdv7C
         tdLQCVoAqUYN6KTOMBFVXzabcobOOozxbbh5LRrVrqJSI57m/nYTCgA5QWnntn13zVhN
         +vzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745975435; x=1746580235;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fy0EpqkwjDtmTcF94zxnemA5fOntKhPCB9hsiCBnym0=;
        b=HEE/YnVkonsx79ShflTAeTdfG0x163jCHJlr3Dw1DoSuzi7inrD84JxGgkHen9lWR3
         I+jQ4n9HUWUi2WUIpiMfGxUBdJfz9NFIB5Dt1r86P4Ues1EkmjrX932CCWJ4yAm+ocsO
         j5nD5+SKp55xE4wDsTtbWkP7hzne2xKwOf06Gxf1WzNAHHgCTtuBA2+4n/wQ4/9BrbPX
         WR/VsVOkeDuJRoK6CDUGxtmznYxhftgJ5FT7bKzCPI8ySsS6hP7yyuHYZLZW4zC7Y/N5
         7zLdVGo9Qf+BUwe0hqnNJFdNGWKuNFjq4scrL46SukitJefOZ+52xlh2sbK+6KqgrNE6
         4tBA==
X-Gm-Message-State: AOJu0YwfMQp6a1Fq25SI1+NLkBhshWy6Y/rR0zMBwuanfyOUHLskQIyH
	1xiS1gJZY/O6TAItej+k/gIca5MzvbaLHTfIyoeF96vfbZzfvog=
X-Gm-Gg: ASbGnctmE8QBpcr3KPQuCkSQHPlxyWDtfDLFvMJpzzDxPh7DtepfnlDmjCfZFapQu2T
	9UAAa6B39rr4gEDz4ky0hDE97QksiI3wRh8QR5J2Sc2CDPkNbxDEvtDAxRCBm5+ZQ3X8OUAEwYW
	Ge6FJTd3IAPKkcysJ0w+i0GYJqIjaWPeFC+pRPXBaZ4SphAzWOj6rcb6rlFPdhqoWX40xsYzwKy
	uwoT68sJ6QuxyvUzPao2/LfSmte/BVS4vvnoaCukpaVMGLIhw0cBPDBCwl2FVZ7yHmWjVr4Odr5
	A/ZVPxn7jgTy8EQyNiLNUKpbs93g0esT8ieWz/nqQr1BkrJ91Ucm1maKmj5zbPLTH5g+wPO2x7d
	KokkplP9Q16jCoGprJxc=
X-Google-Smtp-Source: AGHT+IEfCZyklWz25dz8UgxLE8bMSFKXl1EvDpiL4cI6Uh838bs3W6K4R8SlOQyze6UjmyVl60Hv3A==
X-Received: by 2002:a5d:64a5:0:b0:39e:e438:8e3c with SMTP id ffacd0b85a97d-3a08f7babaamr1003573f8f.53.1745975434662;
        Tue, 29 Apr 2025 18:10:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6c7.dip0.t-ipconnect.de. [91.42.198.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e5c6a0sm15385345f8f.86.2025.04.29.18.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 18:10:33 -0700 (PDT)
Message-ID: <92ed23e2-651a-4730-b5b6-d9e85761c1f8@googlemail.com>
Date: Wed, 30 Apr 2025 03:10:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161059.396852607@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 29.04.2025 um 18:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 204 patches in this series, all will be posted as a response
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
