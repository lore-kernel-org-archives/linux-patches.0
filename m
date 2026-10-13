Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F837535FA4
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791921350; cv=none; b=e+ZaablXzYNznxAZsXmmgOn9MfPn+Ux+o/DDubiJZ0oF2cyu68a6aiQM8S0KtefFCVVL6vU4CTV6AV4XhlBnWFkZrgrUKkKJOCD45k3LtdRZtWKx5/JyfMmoZ/M1P3oaW7HYriuBcNOCnKMscWgz3hD8MM85iMOWttYk7oQ0AGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791921350; c=relaxed/simple;
	bh=kHUiE5axvYANqYFGTvm2buddRW6YsS1oOZ5DJXHz0O8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gy3avJdvEM+HAyE+fKstxmHxn+VKmUa5LOPwyqQZPm0RJJ7cQm1LX+oMcWbi0lE/mvIpEMUMbVinIu8fwnj0/sZcf3kHbjJ7IpW97YftmdR0mN/UdMhgEyRCUeCZkBO1ePRtUtINp8aqqbt8OXMWQQDYoSEeCjeeV3AclRz4kaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bV7aU6/J; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bV7aU6/J"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48bbb06e746so2005968f8f.3
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 12:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1791921347; x=1792526147; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jv8xjU6QFIXZ0JAxxYKajZr9UsaBaFM7IIOQawJA+84=;
        b=bV7aU6/Jb4/eU9bF068bnMMEbZ+kUmfy9dl7bzlhY3lbYE7+Yn0VivDV9/MeK+Fyvv
         z0N3DPVr0zhZZmjuaIk0DHm0mt9TSzQwDeSl0GZa4kUbq1GeaqD56n6tr5ISJpKN83Um
         jejwJi+k90gxvADgqdE0P2Os4b2c3cZRs80abOygGtbpfGslwGWBKkCHS+zyFvUm+o4A
         BV2bIZFUQjKC10q3l3Wag+c/Bt/T9Zwm+Wo6G9CpaKUtv8/TgyXkYJIIGoUqqu6oWnNa
         kL6Q77Sg6TUIzLi4kE1e4sBujRGpt96Ti8gAyeM2Kpk3UcTBoCXxUAzeWsGBUVpuL0/t
         lLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791921347; x=1792526147;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jv8xjU6QFIXZ0JAxxYKajZr9UsaBaFM7IIOQawJA+84=;
        b=BSMjKuyQP7XXHpTStRjnP+BNaUmAAzWw4zN9AMWtPN02Dcw4nOv0/hJvr9vs8hDOw3
         d3UWzbJB1H0iaNP/rZWP8I8B3yyja3pWz+p2TkY4ZP8uca9PRBUP4XfFjv8cR9QeFBj5
         wLnTjHCeYMJIWNcOZHfIQQrUPfMBGN6BSPtOEQ6TnEpSB59kxAanTS2ufDPBKef+RLjh
         +JdMgTWKHU3eUk9ygzcLNfN5I+UJhHUJrt6glehoeYLP5u6l5CXTdL3+1HS88Xh2y9ES
         8bee3NGAEJUy7tC52ZKtG6OnFcX23ALUcZAr+rs1y1bQ0g9cXuIQkfmOXOhdSiLEa/GP
         NmLQ==
X-Gm-Message-State: AFq9FYIuL/hFw4UXTXfhWt6kV0PcfmDmVCERqTRW26pBuSs8ua3THGl8
	1r2pTa8cYBwMWF8qErByOaXZbh7iixn2tTG5Lg3lU8qzb7hL/8TPz9Y=
X-Gm-Gg: AYBFou0dwZPq5k+v6IIcY+t9XCT5Xs6P8eOjB7phlDS2MT++IxBt2q2HuCm3qMHAi7A
	8xKtjjL6zl9I4Kk5EKgmXDd9kipS6VsJUY5iJteDggGjPsgPTE4mxvbUEpEVKR+nVk9w8F3ZNAT
	vDgQmVdUzot6X05BMkyHMHwMUs0NkFR4sNZ0s4NEAOiZjZdLH2I5w0+DTJiC1lFAbzUsFgm2bfL
	dZhggqIeFKs8diZuLTRYDFXIaFVh3q4mJvvcK53eWy6dFlj3wwv3HAlzo0Zi8igwPyaNEzL4/o0
	UNVL6Wx5DjkaMgltcaj2wTMBlXlWefVTr4P1MemDnt+JtOcqOH8p9vlzkVoE5KW8BNSExrnwBII
	bus8Jub3jAJnDXmuIDlEwpPen2fEHXXo3Tppp9Jro5lZv61GNKnvOxcupWLlzR+aZ1g8+k2pqYv
	G5VFAFDYvlL2LvGI7NTGLmpjjtEDNAypc1rTFt2yz3oxRFruJVTNGFwrnnrIUKV+w5ej6VkjJcZ
	WBPFHX9TqcFhJdL6kngCBg9Pe0GC8kXiMnYroK07yil36oz
X-Received: by 2002:adf:e005:0:10b0:48d:dec7:974c with SMTP id ffacd0b85a97d-48ddec797bfmr8286448f8f.7.1791921346559;
        Tue, 13 Oct 2026 12:55:46 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b0e.dip0.t-ipconnect.de. [91.5.123.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ac52d3sm7133340f8f.43.2026.10.13.12.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 12:55:46 -0700 (PDT)
Message-ID: <44a8e6dc-0e5d-414e-8e30-e3ea53b034a0@googlemail.com>
Date: Tue, 13 Oct 2026 21:55:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/497] 6.12.113-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261013112907.864180619@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.10.2026 um 13:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 497 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
