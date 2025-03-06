Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337FD156225
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 03:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741232602; cv=none; b=qTLLs2BdoUdsdrFgyFoN33Yu8/QI72TeQGWepaNUjEhZ2tk+5unrWKYFJn8fgw5VZgRwa3T4VY865hahjE/ufghnajPUh3akKGT6+1Y4WMEAV/3N/MCEtr9bEOFEE9rnRSdAG+/dwvly9RlPwv8W1vqYGkE9P/d8x9VrD6SUTIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741232602; c=relaxed/simple;
	bh=/shJ6VX/7A8nICUUOrOyA8xM0QkB+vTBPXISkMYVips=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EJPhLuGSDvHDQO59BadHcAfbHon9wQ3qu3lFbNn8z8jAMyw5UjCTNIg2XNGj4hun7yFU3a+T2OOQUTdUKBeJjZbTZqYzpSX9QG1jmpGabq7dAmPxO0xxG6RSPXfz5dTkKKgtkPym4DNizJdxE8JsrgggbcUwW3KklAo9agLrgr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZkWL00I+; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZkWL00I+"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39129017bbbso68433f8f.1
        for <patches@lists.linux.dev>; Wed, 05 Mar 2025 19:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741232599; x=1741837399; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KvfaYVCJjOxUnzXkJLdVLBxKjcghXR6Hh+HVmJQ9ONE=;
        b=ZkWL00I+OgV6aVMDCVkwFGa2pjNOeEoZG3uszS/ly4o816dfDwF6MgxzaeALgTQvmN
         vH7dLmru7N4Ip9fH0lsybY7dH9tIxoe4V1qXwFEcCA4LIJW1fnlyln1WU6hl9ZQQ2/MT
         cVggEjkz9W7RYmQbmZ4C3OWFJhnRSi0Pg4+swUi4t0+8O3apk7i6sgY0aUY3oGBgN2wA
         0QJoG4MjV+40QP9Xx1l6LiQEq48w/m7+1E8RbQWi/FOU21DEdQlFe6m7dTcnW73d7Cyl
         wL+xyPSurMy9+hxh2B03B6ZpBRuYF+bfMUPI1VlWohHA4KrneFAofgVluGG+l3a7/R94
         4JFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741232599; x=1741837399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KvfaYVCJjOxUnzXkJLdVLBxKjcghXR6Hh+HVmJQ9ONE=;
        b=THUotveTNIDI/RVSo7kom6rHFJlbWwBoFkzp/R5zx/EKjBnc7OZOIA5LL1eyE59QKe
         p0q9//6zo5toCUQ+vrSUYmFrQlQfmIX1RP/oHdR5ZXyr1jWgwLOric4zUiwTJyn8JmqE
         pJT57W3kJDA3Wp/W56x09RKSczh990kgEIoOZ1+snds+J84QtHnFNRcmxx6K5WxrY0jF
         6BF0uQPZz84YB85zB4EySxVWN31Ms2ckZEAa5YCR5ti1Eth48ZiSohnpqqT5OU4/GMt4
         R1WqO5Pgtmleh0t9OSE27al5bsFtEvWUA4T+EoAoc10PBl2ytsOI3sn0xR07NHN9pxvb
         WV2w==
X-Gm-Message-State: AOJu0YxtfHlastPxZ2pfy6XHkkswYBxEFYx5HuOXsh7fc10kM6jcSera
	k4ujKHT8He9CL8ciscfRD2AW4MN6NdNbD2UMU97lJKeEbuSZfFM=
X-Gm-Gg: ASbGncttBa3CpIu2oPFK/yHbCO1kgVJ7AzHPOjJAa2+QFzyuavusspr7cPhdYxiKO6D
	rYFa+jqJzs/TyN23i3wPr2ajvuzowAh50ZvOwIYU4NHDkUMk9zvrY830RHT+MRvO1AMLozK7+4Q
	/enRj9/jrIAJUrT55tsYzl1Uw+ZUamfo+ssNvYJzl8J4Xr7LTeIqbSmNCVUPZ4gNwWzvDMKeiJG
	3BzYRuv1A/wnckTLI+5NKGnU149aP7cL8HMmwUL7ieBhT0Z2clEIDD9jxor/donDGID6nBS0m4+
	QugM0sd2tNLX18NbuKN7YTGkuXcQuNsLHTvfPuCqxfz8I6rdx2AsD2C+8ddbXFo3MZp+uzlp0zp
	CTv99l+BMU8DJui9n3djE
X-Google-Smtp-Source: AGHT+IFZoJr4BpD0Wcdp0F2PVjihayKVse4R5DfOBq2DFLN6HWFFFJhBXhibGrJXCA8RwR8Cs1rHoA==
X-Received: by 2002:a5d:5f8f:0:b0:390:f88c:a684 with SMTP id ffacd0b85a97d-3911f7bb837mr4964247f8f.35.1741232599178;
        Wed, 05 Mar 2025 19:43:19 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4217.dip0.t-ipconnect.de. [91.43.66.23])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfbaa94sm550605f8f.14.2025.03.05.19.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 19:43:18 -0800 (PST)
Message-ID: <997f3cf2-3718-47ea-ba11-a5255aa75ca5@googlemail.com>
Date: Thu, 6 Mar 2025 04:43:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250305174505.268725418@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.03.2025 um 18:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 157 patches in this series, all will be posted as a response
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
