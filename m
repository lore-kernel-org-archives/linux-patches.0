Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C158D357CED
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 05:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792302854; cv=none; b=XUHiSvwyc8/wg0Z5vSSRHVPcZCBlFbHbrDuUeAiHX16oUrY8XZYowkBK5Wfsvml886KUW670c3f6GnjhY8GhIMe0xBG36NYyJQb4opyvvgOOL7zzbOUPC5TS2UFd9K9qbXcvG5jt0FydlAYaJfCKWhdcG81TpyWHEdFMuqrXf/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792302854; c=relaxed/simple;
	bh=EdPcVm2BdnZo7LqxTWBGzpYFcYxn+421Yy2CZBIkVoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k87xTM4OVk2DrzI2vBpc1p2VDl2C6O32c6fCz96CNDONqUcHJU3+N4cDl8Bn6CJXPbmJ2cRfH98ZZ+HhyXMZdMSs8Y4Nky7vAqBE0DFWhZdQAKLvdT+MjG9GatY+RdLJe3yqOf1Gel09Y0OzEbMQS/p2tsWdGsC/rH2+Hr4g1TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FpIDj3hZ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FpIDj3hZ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a19cba5c14so12076845e9.3
        for <patches@lists.linux.dev>; Sat, 17 Oct 2026 22:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792302851; x=1792907651; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T4lMxErc8YOBMSPew3QfIeHbs46LEjg8tsqnaE0Su8c=;
        b=FpIDj3hZLP5Hz4KoBcd3neUIjdLuN86jxqhPc1WemUnRGD0u2m8bPbYk5M5R+07+R0
         DXrCE2EZyrHYG9fjGeXDiBgIkwkl6gUbjxgWgkaoowy1oYlCQ0MJi+1oR3ojwGIE53Lp
         KJpJ99+mLW+YaMy6TwiShbuMnMmzQcSxhDkwPXCERYwSfzuiseoz0o6igADmm4JFCFB5
         zkE3gbYPNfZgpNabF+JlHqsznBZXEYEC/Cj8cK+RzEFuItjRNAcIXDT1IQ3usPLk68s5
         sLUVAUNJXFTP5qBeGTi3FAZTOGMLziiEo3XWGZcCgqCR3QvyY3KRe9eVg+nQyF3zcDzO
         uueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792302851; x=1792907651;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T4lMxErc8YOBMSPew3QfIeHbs46LEjg8tsqnaE0Su8c=;
        b=hKKVQCp8Vz2edRuPNJI1dfHc5skOOqrlm/FvHqDDHnlRgbGifwdjvcN8yFDes5BPGM
         E9fa3JPCIIpt05qjMe4uVInaNXnl951XPlu8IjgOvnWwZKZClin28fIt880Z3V9twMuX
         1sC0Vq2xFkss/gaaDPoyq239lB8RGeTxOmoV0WUNQ4tB3nuzZho1asYBUNnooFtTE7Ls
         3IATqsNB/WJyG/MzNknu1g0eX5wG2Vp6nHpjYT/KlYqtGG8fdTgPlrFBF+DFXRBT7xq6
         7myl5y1oPD+B2T7XEHitqV9DDvsNV8ndXG6iCj3jpjMwe+WJVLnWTsWjvmUbyvdeCGih
         L4xQ==
X-Gm-Message-State: AFq9FYJq7RWxy4bFiTJkJsj/oLPpowBfg4nAgPN0h0xhH1Ncf9EwD7uN
	1ZAxedHefa3nKqC7w1z/hpUqwYXSayhh8pXWLXgUCFS9gqFKW7b+528=
X-Gm-Gg: AYBFou2+jcLLvoCH0ZNSzaBz0vz6BD7+22RkDFzNL9AQagZt9lAAuwu+jt0qxf7AnRj
	bvBHQlmrAVS6pHq/zLMTbyp/iaG2LMOZdjhG6r1L2fHOmASa2MKmaYh2q1dkTmzFvKjiV+za4Np
	koJqMAqS6AZJtDcaNSCTM/tax9gHzVzBWHz20SXNwWfMATF+bsZnFqo0WmsfWIWsDhZicKAO269
	0ZZzWgacP/sAiOL5KxI5e7k82eXhZVnxxEIhkAWOBDnJJG54AJNeZUKxSi2RD9F71ds6O9cpZSW
	pnVkr1f6AMJFBHeLu1F2IlaUOIzO7/fa2hCc3o2zJj9S35Tenpn/8C8OLS7TMR6v4NMjQtQERuG
	T8Mvll1hFxZt1bfgF+iqG/S2hb+snTe3CDNHYuM0ZIR1mPuYCKLNhbYxTA4ltYioUMCDHEZLb2S
	NQgMWiLxuPdYQbdtbhx6T6XJxFWwFF42wAV3H6MQkc50zNcMnuiHwkg2d5RwXY2WO1OvmiHTn54
	UQVn+Gc3EJMFov/Q+rPef6HPGLjbXnx7NIyBkhyNUKuII0o
X-Received: by 2002:a05:6000:29c8:b0:48a:fcf9:acb5 with SMTP id ffacd0b85a97d-48e07988970mr4036344f8f.2.1792302850733;
        Sat, 17 Oct 2026 22:54:10 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b14.dip0.t-ipconnect.de. [91.5.123.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8bd9sm15448129f8f.35.2026.10.17.22.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 22:54:10 -0700 (PDT)
Message-ID: <827e9f8d-5654-4964-a999-5ce94bd98fd4@googlemail.com>
Date: Sun, 18 Oct 2026 07:54:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017160431.119607952@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.2026 um 17:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc-Kernel crashes with a kernel panic on my 2-socket Ivy Bridge Xeon E5-2697v2 server, when I boot into it. Will 
bisect the issue, but unfortunately I have no time for this today, because I will be off for playing a chess team match 
in an hour, and that's about all I'll do today. Will hopefully do the bisect on Monday.


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
