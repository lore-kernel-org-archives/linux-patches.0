Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABBD496D22
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406033; cv=none; b=thH6a1al0IsGLnibhR0WPUv1wWc8/oSvFzIj4UsY0b9Q+MUlEWhnptEhEUt4T0HKXaRV25SuJMEmH7YSUvXKl6Ar4UfAnxwMd9yZP3y1GBZgMYWvSYXm5a2Fnz/MJHcdRKoMKE/zM1fGFuLKZdg52EfF5907gMzKSwkz1ltZv8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406033; c=relaxed/simple;
	bh=uLTJwvuhHJuRdXlB1C8pmGPIC2/l0e58nI7GsoLCsMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RimBxIABvb/5/wsGxm7kojm2weylY4LvPiRnQC2cCzgQA2p4pxqscvE0P5IX7XWdi53F5BaL2vlbL/bqIqSBjUa7d1X+5nw7MI+2K4/Se5pnKnpaCVdLZ2RdUCsoxXF+UN9FS1oFZ9FLbP5NsWUp/JlmKJ4fBxAnE/iu4oFL0kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N0upUvRY; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N0upUvRY"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8706dfdcd4fso34684497b3.3
        for <patches@lists.linux.dev>; Mon, 14 Sep 2026 10:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789406030; x=1790010830; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ovEgINGmapqd39G2xDwqgD2EjPG8Mps/2I0DRD6EygU=;
        b=N0upUvRYtZXa5vZCRnbXEXrcI8YzjNUm/BdCJgEEZ5JbA/ZdnRpCFbRq8Kbesh4zHM
         MsaF0rKGiN13U/95EOGtx8XQWNURl6Xq8KzYfVqgOtY+kdb1da0uCkYcyR0/B1YsAJfF
         7BMBOvC+zA0MbFwFNEK4xeI9teMJfKQ+zGKlSN5+JjK1AxcWg3imaliUfIbvh40gIikZ
         YQ26qmDRmH860OGHpkFGbzQIUpQtH+cTuO69zY+7k9AtYZUPxxfjw1Ks1qgWcoe1MgL2
         ScHOhpAgljo9gptKGlOV/KQyX/Fo19HA6ElWIdTFVG75kRZCDMC92NbOo8yhHucL46ER
         rdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789406030; x=1790010830;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ovEgINGmapqd39G2xDwqgD2EjPG8Mps/2I0DRD6EygU=;
        b=qznZPLTsCrSCzhvwNmJaZsOmAPNVHuW2ottEkIQjUI7zD2uMwPqJc/+I/Ys3qioayB
         4cAxr/3ctZC+Yf+WMZC/Ffg3+OJXyWunGsASsJAhobR1751w/JjNIiOtUnqUJ2xFuphv
         GRlkkbKuloaENvV33Uj37Jcvlw13lHkPRXUGhMsWRH38AXPtz3ueBcK4RxZSyBs4e7+k
         vswNq7y2gJ7slmEAjSBqenbtKpGZk60pgjESJzqaWtgJ0bkYpp6iCfIciO6KHBRT6Jqq
         BCuTy074eBPQ889fqDd9N3QbTGQgDB9EBUOruuNykXkGyXa5acqdoo25ZHgsJyFnelwB
         KsEQ==
X-Gm-Message-State: AFuF++nJEwPMrpjAXQ0VnvV6uTdW/hH1qgBE/+3GgTMB4xgtZNN98koL
	4RjzFLJ3rz8VDFUd5BVaydOAVDEWbQ+/MpyrNU8OjR2wFolKboXhGbQ6
X-Gm-Gg: AYBFou3wxmpGDN8dCdFvBWTZUmwUVg6my/CZyF8GgFPmXFn6qKEbDWv2x2u2/k63mQD
	rx264z6cVJtqUfI3QSmTNMNImXe/oosIpIvYNqRul/rstpT5TCzlY8uIUFk9IM9hH5Q3yRychKc
	d/uSM0/UOKtGwVCKFqcmkqYLaSOOMT14LYCzWhwyaAStO5g9vG2jELdFDhVaJIjoOK36AxsK1DB
	uEoAjTZEZP8hQsv7m9nRxIB8QqYegCXrQN1s7JAjCUxmpaFf2Aj75Bxtq7l5UMaf8DWPXXp4nGx
	c77bHJQcq14QQoATYOQqu82qWdsc/CqeEVBzgz4B/ysXzBzP2ZUKdgWnik9PggRF+oOD+mL84Wq
	qbsMldhhqvbRlsUm8vm5T66iX8eLtDDPBU6FZCN7lRd9leAueNLDgUZTOYud04baZ5404RRcrr4
	jsIIf1PHti4HGjbwPTBI6ww91QpHX+gQNNEE1FMAqrXius1oS1GsYeJDQBJBX3b4JaLoKHit/GZ
	uYA+28H0wlFe34MMYhkBZQnVQ==
X-Received: by 2002:a05:690c:12:b0:873:5bb2:6c23 with SMTP id 00721157ae682-88d22ece335mr12117147b3.42.1789406025821;
        Mon, 14 Sep 2026 10:13:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8847db4476bsm39563067b3.5.2026.09.14.10.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 10:13:44 -0700 (PDT)
Message-ID: <72168bd0-27ce-4bf7-82a1-0d1719ddc15f@gmail.com>
Date: Mon, 14 Sep 2026 10:13:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/798] 5.10.270-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065516.948645775@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 23:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.270 release.
> There are 798 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.270-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
