Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793287202;
	b=V9T3qZF5dqiz3IGWvQKP6s4QXxq4rybEnJ1VGq7GJXcGaGlI+aWUP5zQsISxtBxbqfvw
	 iG2RdtXj+Sc08gZWlywP6VWPQkSh8d6vy5+DI0pER3qtiJb7h3Rk96ZG1U/y3Tt0g7Hq8
	 LRLV0SvuRts7th+pH5Cs/f2A7diw10yb16kCtFtw2fFngDP/lwZpilr74Ck2Fl+N/UPFN
	 7Btdev56udexw/uFM8XV2XiF2liW9NUXajbM7OUBlbWZ2nqiVk6lo+3C+Dyt1MHKTSHrz
	 MDBIi4L2OgsVL5KsdOZ5PBNAfqqig9bYl1b1BLLdJjYRxGuio7F7e+VWzDkaO2e6OYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793287202;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=x473ufmcJ5W3DLAFHIuNnT5Lpmdr63e0NBlGNs5sk3o=;
	b=NF3IxG1UwiqjLm+I9LzZ85Lx4XxVpZ4ZaZ5m9yDAnyh+ype6YqIwgppnFPVyFondHCWw
	 5QMO4+J9AQLHgCZzBn0A8kIl8p7m7s7U/JKHUaiLX1AR+PlIPfECjnCSpllOr5A5YGffZ
	 BSYi7n/jjr7Fw+nh9YAe0MSz8NmT4l2TKgKjQsJyDFRr5Ulh1nMNZyBhGTquA+z8wZYbM
	 DeuIEaQWDv7m3N9CK1H71uy+ov+m+UuSZzJpXuRMPRaT6LpmqvdvPXVnpXUjqAYfhjqx+
	 kK6rQUvWpS9K1pcvZhCNJEh3bfEhasD6iOaljv+WfLQnLoGIG4BpcxXrNsrbw5o3Rgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=NchV4nlf;
	arc=none smtp.remote-ip=209.85.161.51
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76708606A31A
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:20:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76708606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=NchV4nlf
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-702fd86d674so1565211eaf.2
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793287199; x=1793891999; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x473ufmcJ5W3DLAFHIuNnT5Lpmdr63e0NBlGNs5sk3o=;
        b=NchV4nlfiFO93lAyRfRYrXfTbfmDPFw5fylFsaOxJnf5REE1aXQie+/DHgdgSqu5Zq
         nf1WiAbgSQSbTDxLWgEP/HIQnkRUyv5XQMRaS8IwNYMJ9ioMXhPa0gHfRkyIZFt8avv1
         sRyYC0RleveCGWHLny2fu1s2fLB7pxT+/m8bc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793287199; x=1793891999;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x473ufmcJ5W3DLAFHIuNnT5Lpmdr63e0NBlGNs5sk3o=;
        b=MZEMesnPArZ/SQccvvErOT2jFkYZxvdTDFSUQJr/k1h1hAk9qwQGLMiO2QjornM2ru
         YcSaGdTpZZYi4ivP8uRgs9VvhrHVRAvmFq1yHNKRpPVftUEDZrRosKCRGBLY0Tjz1/37
         6k3PKQUvrJyuhdkFjmlfeRQPUeQNXqr3rI2LImMNwDKj2gYb1FVgdbRVkwG98tnZIkuI
         LrtJcYKQYCLrGYrRlbHVX90mF52wGdjzRFizRAKPia/Y3kpqKY2o1gff/A+tCWrA3eDT
         l7a4k2VTpdOnvzYQpBztb1SGiIIiweW9zkGEQlCSOFybvmJ/hg6NqXNatWsoTDJbq76T
         6R+Q==
X-Gm-Message-State: AFq9FYKfyHtgANOx7kPTLNiQB1gEBOsSdV6q1K/qtNRapbx1n/QW37eU
	JZQYXhrZd9p7YnMH8oEynI2KEl65VVQkhE/w7pV06U8gA8JN9Ixf1yPp0XcJJZBdbW4=
X-Gm-Gg: AYBFou3f4WC4DmM/RftRMaKiIRV3eJ6DGBAGoIjRK4ialpnRSsh5lYkwJgTDGY3d5tU
	orr0pozPxJtTE05XiRHoqKHriOtEsMPNtWAly22srQ+hKdAFhtAWK6KCDyM2iS7MkQL+9xJn3vR
	vXISKGix+Fo9Bgt/0SfG39z0p03KSYKHWHZs+h3ngHL9tkCJvko7afr63i8rFZv/RGhhMmTao7T
	Lx4QwmmeDvS6aqSGi5vezSUgnGSxacwtDUskG6eD4tTxmuPhBSKZPgsjV8l+4qxwM+MU+knDH3x
	ip/ppt5DKwBGrqx69qrxdicYRLdIXuHmmd5BklqYJA9jLg3k7F2YyL0mkcfay72O9Mz0vhnaIRZ
	e8PHdewSrSX7F/5vxc0f7jL1YiV7H/9H65HmDToiQLgiWYHvpi5Q/vsobJ/GrXeLc6N9TgsvOfQ
	R5wjg1YB2r4QkTRYL8uUsZXluTLU/vsI2LE+0ngxK6RvCuWadgMNrVprO1SmMgdYWR4xRpYDF2T
	nMtoNw0V8u6yD9B+YXZdYDqdya++yIpJiVTeMRSTNlMfmdc1EUQ3+NSJzZLn3/38Ew7BFVG0g8K
	QK3AJsQXYOywVgI3c6dvXg2YislzCLRThpYNHg==
X-Received: by 2002:a05:6820:1c96:b0:6de:d2c1:e95d with SMTP id 006d021491bc7-713f01f0633mr3625060eaf.72.1793287199393;
        Thu, 29 Oct 2026 08:19:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a8b793fe7csm4994076fac.15.2026.10.29.08.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:19:58 -0700 (PDT)
Message-ID: <d6d7f806-c771-4b8b-aeb5-c3e1308780f8@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:19:55 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/88] 7.2.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.14 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
