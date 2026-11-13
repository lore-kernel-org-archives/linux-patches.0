Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794604210;
	b=v7xEUs/v8mPJO0z8dh5Z7NxoGQByl+7YmN6OFF/fHWva5bRidag5GcRH7GqNeQF/VOxW
	 U3FkKQIf5ls/fWw1E8BiTu/tNZvFVp2KvVN6XU+nG4SUmJu/1ijRljOHhLeiqNktULnW+
	 u7gbwbWUC+vweLxdE9XncNoQnl7AWl2Z00/s/MIHy4L0AZGiUMwbYjelVzoAQlFHgDJuh
	 BJnqmc37YHUqu9d/ExwLoqL5wE+oC0bboB36J4z0OIa/VOHsbqOb15hLtd3U0DJeoQSgB
	 +dq3cgbxgef2ppAYJK1XQtNmwhZiQ0gP9ZYuLlkQHi6eg/Ycug8FReRExfP0s83vTog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794604210;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UP0VIkxwdkwdfopi/I7Ka3p31rBuKNZ6NklI8tykK3M=;
	b=k7aErII8M1GBYQwalAF2uLl6lAhGDoB11zLbKbJOBmItz3pExE1tEXpJHwoC1A5zz9fC
	 Kxby0GsxIwvQ+p+Yxc8xeOhH0NI4QE0I3SDQAI1IyTjNg/zGNI+TlfGfobAOqQoWKrxhF
	 BOl+Xm+JRzXBITfbxs+rSvGoUZPQaaZEGm7EcfZgrTWloQDb6RaNkCGEWjXchM++IQAe/
	 3gOAdBI/jvOjIQPLbGyTUYqjJp2N5z9fc+FS67Zdwu5XPEhLr88fbp++0ZHC4tHJyG7gC
	 /KhkBiC5XVBTtXI030zirovQ45w68udcYBb9VvazKhbzNPuZg4QHiazzyZUIDg/Dwdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tc3ZLhkm;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E4C606A337
	for <patches@lists.linux.dev>; Fri, 13 Nov 2026 21:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08E4C606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tc3ZLhkm
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b1535be329so1409709a91.3
        for <patches@lists.linux.dev>; Fri, 13 Nov 2026 13:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794604209; x=1795209009; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UP0VIkxwdkwdfopi/I7Ka3p31rBuKNZ6NklI8tykK3M=;
        b=tc3ZLhkmid2LlKe0VjJ5Arnp3j8wShfFfJUOpVLEfpHOPv4xkDwRtTAEuGM8harge6
         s8oOTKGt2XydLYAUGRGH5McOmKMuS7W6NzP8Z8d1wn1RWt74sF8xTH8PU0LN43D764fh
         wfr1Q4caKKBz5mTv9cqzpwCclcrnujywldj8KAIgsbXG/I5ugQOneR9y6mxmPUXpwbre
         FB3mSsKYlMl3MLEiyOmanPyXo+1uv/agvBn9e14dzaVaibZw/98ZlW7drzkdkpONn5Dg
         uQJGwvAqOIshhHWG5a7j0+Fxp+4G0o7qPxANGiI8QZMH/OQATc958Bz07qhetx0IKD/p
         pQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794604209; x=1795209009;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UP0VIkxwdkwdfopi/I7Ka3p31rBuKNZ6NklI8tykK3M=;
        b=AKOh6ki1zmfUCUX7eGLkXdr79yXZGz18H6FSFxtk4iebwJjJOfgJ8IkobsLxyq8NgG
         zuNDrgOCjKWRFZ5DPClY1lrZ1mAp82weg+NqpP2ZXi+j5cifrehvMql5nbz/2bIqgWya
         nPoLQihGe2FkTr5p1W210FhRW/WdTQ/51TswZ/VznRUtI92XV1Iao2YJt1Yh0lkYBRac
         wr5tgjDFXvNWrU5vHLpWgzVeQnAFRWAlcZwACeqlmA9GdBf9yqT45u+tFwPzJ3N0Li/e
         qjX+ywAB6sRXI4IlVWgZvwkOwLij0nJh77yoCqXMy39fA1uikDA1GEFf7OiADkBSsA/a
         +rSQ==
X-Gm-Message-State: APuU4Z9o61gjsEdfs9Z9ij+qGSoc5PviYmzJ8mAdKhRvH1KsxXtzp8rW
	HwajFeYlJy/yvIjxJ5eYsAWFOimdy7X0uALhnFwjnF9sb2YaIEsndDnF
X-Gm-Gg: AYBFou0R5v0pyIA1rvhfNxnUqsJZPu110BN4H7r37nEmbC+HJDdc79JXG1rUhLr5xWE
	wTDY8qJGqz0bEW3GN8LB4pAa5GuvfEBMpNF4fx6JMAFBHMaYZIWHvyzkHU5f8dSnZhDdoK7eKqo
	v4jSPus+Zi3cnVyyQ+CnNSL+RKSDBjTLr/Wj7MiMdXxa0FAD308/c4GSMElnoAv31PfESKIkz7U
	K/jGTm/bZHdzi0gTOxmmk57iUEbchUSI7OmQD97gfPvFsqdkJBgdxrSAJoFtr7zfHaZVHmQkWtO
	XgJ86Sdk9Qa8R18FTelJ4zK0/crgIypF2nXgNA9sqA/MQReZdQVQPpqThFrkM0Ax9ownrzb/9VN
	WyO0Of+bQqsg9d5ZxHWmt/Ell05XjzamQ2DZYCn00GVG7BeD/YctsaLHlAd57ONSDz1HUuWx5mt
	ZiPrbV44zKRGh4F7v1gs/0MGOH5BhxhuCD0hSZYYOfGjPbPR39k1kvZ6CtxIP6EYlFbdcQyqh7B
	lIv8QyKKnqLUuLXJBd4+Q5YaQ67VEQqYp7GKpLbHSGquF9lVQoQecEA5DyAuQBL2+xpE63KjFuG
	QDW+F1deJVS418j+PTfuNy9qtNPyPg5sT7Dy8eX6OcPlzdy0rlOdP7++
X-Received: by 2002:a17:90b:4a:b0:3a7:bb1d:3688 with SMTP id 98e67ed59e1d1-3b1b0a0db47mr3267098a91.27.1794604209023;
        Fri, 13 Nov 2026 13:10:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm11082549a91.1.2026.11.13.13.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 13:10:08 -0800 (PST)
Message-ID: <41448f6c-347c-4dbe-bbf6-d9429c7f1608@gmail.com>
Date: Fri, 13 Nov 2026 13:10:06 -0800
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
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261113153753.358973689@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 07:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.5 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
