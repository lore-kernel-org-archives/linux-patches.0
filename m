Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18ED22126C
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 22:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757371272; cv=none; b=JIHfmDREdzwuFL8Dxx4ug6Jir1zUE5+xkXUJL50HNlpzgiAdeVXXwSVHWPsOBVH2THXSTK1fD1W2mlbKvTyLvVcDHzSA54axnTVW9ShODZYM/MoRaPiorfqp4QqS7pF6tx1BF6jPD5SApdRlMn+U56e5YQ1nE3C8e33PiR6Gr8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757371272; c=relaxed/simple;
	bh=fSqFCqqM3AfsbXjLxbGREr5s7O84Qb4Z6tn5ZtnOX+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kq2XmC3K+wmT5CkcCqciWj+viz7+4Ogh8ZFlK2D2yOa7h6VIEOcv0sXSpRllrQiBvoNZ2j2kt0byr4lzcFyMc7Qc1j1+P28f9sbgXpEu/g+uFfrS5c7v7DatMLLFoFZIvTs58lx9aRe4xLfWt1mWC1BQjLTGGRBQbP4fjQDJdN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTnkhGOL; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTnkhGOL"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-40f9e28b09dso1618955ab.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 15:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1757371269; x=1757976069; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=68HWy37O10tqXYXKmGukX5WuN1MUrjL9lhDEm4zk/jk=;
        b=hTnkhGOLxp70IcsGCVPLYMzfZ8XQOvLcne3feJqzjPDAOJVvJCNIRHzz/uaknkkSLB
         MhbIpY9qdq4vuwN0Q5Pzwu8WTisPNVr/TV5+TVR6MMJM930qB+NjXo9Jr78DB2vni7nT
         NUMt4+AbgQNit+nlHJkaEMLZmEOfZw4JnzG1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757371269; x=1757976069;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68HWy37O10tqXYXKmGukX5WuN1MUrjL9lhDEm4zk/jk=;
        b=LyUEt2dmzuZ3ZfUgvOrQ+t64m3tke1/wfiNdqlZc+CnlitL5zURF9FKq5s92jaddPF
         FHNX+ecB7lZSv4Vp7PnpJadgUVXk9GPAtlp/t4yDQcWYJCfn7gOb3YjLEktyG0oMtYhf
         189kxyVsexB06oyDmBHcboaJB8l8eZeuypr04KWyH76W+j6+qk06SUG9kma3dXKRwokG
         txllJ1ZWtlcWen65rM/PE/NPHBjcjw+vYfPMky605WivrNzGc9QBBY8btR3uLgZSF/TW
         elIN47LdgAIZPbBaP7UwMBLrQdg4YIoWZh1RxJ/MgzOV0Msh/gHiKLuneiUTFzHbyl6u
         /3QQ==
X-Gm-Message-State: AOJu0YyTFGz6YK8ognDURNEIQeETBwvYJvI7VHblm20iG45ckyWWKo20
	ZJLaAS4Iys4akIZ9y9o28loWq/yFpuEA46ix9ifc6dtIIsd9lD2AuwGyz8JWJJ2DYgs=
X-Gm-Gg: ASbGncu3U/4yEjQnxBex48nk9ltwsepY4PvBBUH4x+6B51qYWCwBEO04whWp7LI94Pj
	K7kSPyhGC/zVRqAth01AjnJyFpupRQhdIMM4QmYlQjZ9HNutCQEFoD69hjKTDawubGm6CFJNd71
	aFZjlUFn4964W6Nk8J/p4fkVRx8jaTWRTnAVrTe+TjBTfLF/8GU1mj9LW+3BgZ4DF39Sfs1rRAI
	9cEsL9RszY2TUrZsAu4Bvy1krnnTBD45eOo2D9iZGXc/JiQ2OHUyBMRnFM/Xf8aVra9g5UhJEvA
	J4auEy5UW7AU/10G3StR6N9RG+it7NkkcSbBW03ttysXRnmnnojc8LrCDxLH6dS5ZNd/Vnvj/bB
	ZzAjseCBnp0+e6wD/g0UoPuF8l1oloE4FIC4=
X-Google-Smtp-Source: AGHT+IFWCsaTSHUpmf8Cx1hvBeqVbtqoKD11vWy//iwDgAihm5QVuVHARPtrG8fFcTTACW6fAA4FvA==
X-Received: by 2002:a05:6e02:1d86:b0:3f2:9ebc:ddfa with SMTP id e9e14a558f8ab-3fd7e252fc6mr118637925ab.7.1757371268960;
        Mon, 08 Sep 2025 15:41:08 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4007fc6c9bcsm28400385ab.14.2025.09.08.15.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 15:41:08 -0700 (PDT)
Message-ID: <1d872101-6e5d-41c2-81da-db7dadc6484b@linuxfoundation.org>
Date: Mon, 8 Sep 2025 16:41:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.105-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/25 13:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.105 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
