Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FEF4AA402
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 22:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016017; cv=none; b=e6LxZ2q/9S6IvFX9RSl2oQzQI80fgk1GoDMEs1vSVfR1nVwHHr60pwZIyhbZO9kCgoB38Tv576u9A/bY9r+1LKEa1h2NVYqsJxFOJ7krEv3s9t8qnuAyYrHycd2SkDdnTY9+vT668zgcu7NRvxFAlBOeZv0w5Lo99zZWDnzhYbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016017; c=relaxed/simple;
	bh=OJJLDBSVtpI8wz96AabglhUFLbr4QIfvWBzdT8ARCdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lqjrDZo/7UJE1jD4zkB7AUgcvucbZ/JKCzBBjZf9Nq2S03fdm9kxFSZ6vcFiLXrFbFrYeqCgIcBK60OWDi6OgelmTde3/Lv6B0u7wl4eQKED0ACmsGRwXwj2NOsjsYzfAr58j4k1ZqHeNAuA2LFbD9hhpSWDNapa4ubEkl1toE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iEKz9LNK; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEKz9LNK"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-156cbe59622so385395c88.0
        for <patches@lists.linux.dev>; Wed, 14 Oct 2026 15:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792016012; x=1792620812; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QxweolJrlHVj2MNzfSYncB6B+aQ1Kt9zKOvPMQbgcwo=;
        b=iEKz9LNK6pg6PXEM0lpYeQ+AJTbtGB2vCdZ1eO9xz3IgUag1dQRUkGI71di9yBGKMh
         Z+JU3az3tPFE7ObQGMjk2BkbomiX52SUPOXp9c2kbz4SCwuLE174DOdVBIKY6e4xuMiC
         u+DVoefes+agkE03U8qMP2Ka032pKPdGMvPvzO9z5rqybzrE0s+pGGZAPdbLnJGI41aE
         6kW28oz7w6oiA2kJmFmX6MhaoNYiXpv8BZXgbI1oTIzWkv8+pyJ/4RAyKWcYMYIhYPFJ
         KZfdS+qil70R2OUWEgi/Fp6q/Whns/vIfhpE4MbZ91lyahD9o6qE6RuZcuPmqmz0xUje
         ntCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016012; x=1792620812;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QxweolJrlHVj2MNzfSYncB6B+aQ1Kt9zKOvPMQbgcwo=;
        b=1hcF31NFNB5S2Ilgdt+Jq+bnch4EfCQERyHf3V9doO4xmj1I8meSsjx2UWGixWJqjb
         h+9XF3zX4KQUIdtsCKFHvXtEO10HaziKRX/n3nBgv0E/G/VvvgnTopAEeF2ApOdDzK4G
         +NgQBS87GkxXNKqAqc9/2del19souuFKXKbO9MQ4DLAdEo2f2C3Hi91zcOkKY+6j0pWi
         cO8gG/NFBZuNyVnb8bEjjRyR6cGwwYgpZVFGzZurNwmEPMVRjoBBpdB6E/loO9WYdWgC
         hLl3tktc7P0/GAGS+pN1AaefeRSHrwpdf81tJi5szS6sNzUmii5dDPlQNANGEoh7XMsa
         J8lw==
X-Gm-Message-State: AFq9FYJBn4uTIS5ezTv66JSNsWpeezVLBPwqub4XR3Hxl6UdMs0fnGVs
	Ub1Bz9oAsMCZKO5k/pOJRaFkVRjqATHdHgZWQWD2QfM+th0Nvt6NsndE
X-Gm-Gg: AYBFou0xCjsOS8iR9UAdETzCTeRZftCzpg6mPQKhsNWEkiOaUQPXIBgVRcs436FwDJ2
	vbrzHBoxLskVNpGOcYwHdBU5RleCX1fbNXjPJUwEirPpC+Bx0h8mtjOOn+IDPBRYmUVKLDaXCCy
	TiiohANFFVmdUdvwCpwdjKsdk/IEeeXyXircR6KVB9o46+2RsYCCDWbfEhyge9bwyuLv36p/0AO
	SSXe4Cp5Aec3G7iVOnM6Slh0ELHyLCjT7k4uZG68oN3MReUdVufsoczGRwOkRgVKXumyk2u0+GT
	eVAkLO/btlGhqHDzA/Z9HKsRYSeVjdT3nZBJUjTauT9znQyjWAh2u5cxcj7tv1Rsh4wmyDNf2++
	IPx7L6gwOPOD0fjPiFUixQu/5BVrXtqWOqIeQuNmnx6bixdvGAH/cpnicKj1jnk+sGCnIuSJr+A
	diUzCUxWeT0VzqG2gcYNQ455lU1aTfTf56irqJ10nqwQS2M/ZCWyAxWGXQpmAtPjT0DXlEws7bN
	wdMquAyTET6VWR0PQn2X1wI
X-Received: by 2002:a05:701b:2713:b0:143:26cf:8615 with SMTP id a92af1059eb24-16a6169558fmr24799867c88.25.1792016012151;
        Wed, 14 Oct 2026 15:13:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a4429603sm47377549c88.17.2026.10.14.15.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 15:13:31 -0700 (PDT)
Message-ID: <08247c8e-3719-4c8e-9782-962c648d1c84@gmail.com>
Date: Wed, 14 Oct 2026 15:13:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261014123758.782265692@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/26 05:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Oct 2026 12:37:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
