Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F8E7483
	for <patches@lists.linux.dev>; Tue, 13 May 2025 12:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747140071; cv=none; b=pMgdEriUcRPs8Tjaun34G8alG6YZAZv8gN/4wowkEjy9kwhCp8A35kI4zLGJ897GYOiP8tC5p7riZwypoIQnToZZHaTcmcWpfbsZQDGbylbesByRMD5CMi/yefOa799EvOz40+bvwc/99JPPvPNrWEC7BhWHdwDsbyHZ0zbvPyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747140071; c=relaxed/simple;
	bh=JISFqz2cA0a7f3922N1IeHJedUP3h48dOEe1dzWJ2ps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7xneKksu2xmApZP0UHOIKdyH3HLWc8XFcDmqo7h8UIJXBoJl/f5H1HSXSnWyvBZIU5dlflvs+vXeRIY59+sUkRLQl4qLxSSRstXI6/N+tIfWwyTqUB7WuIPYVMLSi3X3FfhAGCVBxbXNWLK8L9+4K3pMPnSFjR1b3fJJD1kDmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jEtaIYwA; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jEtaIYwA"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7406c6dd2b1so5814044b3a.0
        for <patches@lists.linux.dev>; Tue, 13 May 2025 05:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747140070; x=1747744870; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Bd9UlH4zs5u8+x3Qt1weohrUL2/uFJWKaLnVhGkrJVQ=;
        b=jEtaIYwA/innFaJbwQld2d+dxG6M+fCvW02yzEn16r40sUZpgrXGqnmbSHbsYwBUXC
         98JBqH1t9oRHqnISjZQc9ARk3WE/r097X5THYDxQg8Yaf+8VwQkFCx3SwAhF0YEpa3U/
         nlztTiw6vhEbCeyrhC7VomDxiLtpXVLegXmaZzmqjLhI7nkonKYfs8iid2bsNNFPUj6h
         fMLQozo84kaig7+bqKGC340RCbVewMFE8Gfp7wGd4J90atQ6Nf/xlsKt+srojuiRak6v
         dL8FbK63w/oWBYS0XSTE7yuLKOXQJMNlSFWSQOKnDZ01ocEo9z+AZu/gPVUcV8g+AgSe
         F+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747140070; x=1747744870;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bd9UlH4zs5u8+x3Qt1weohrUL2/uFJWKaLnVhGkrJVQ=;
        b=i03eFOzP187WyzABaAK1PlY1TnrjJvWTZaQTQz4z85MnJnV1p6rKoj5mFdfjnumUp8
         FAA4xhbWc6cZSqgRSCEH2BbuYPD2AWpOUVefw9qkqyi8gVDfLe+PcYRSxSUEV8VtUg3O
         Pdz1YwLBV+wDqrFPJNTFHdgkmwXsQbhxE9JNxvxiqH/P37lYfR4vfV76/GllEiTLTaIF
         P92ts+44nYuAr6CCTiRoqLN8ih8ELLNoSqgr/Ht9kjbjbH4cNunZM6XxR++gg+YCpOWS
         578McF/qUq/J5xPQbC1VRij1N4ed6g9VGTHLm6s8z9dKwBLQYk29ypJEQg75mp7ZXiKO
         028Q==
X-Gm-Message-State: AOJu0YxLC+DHDtsvAQf5MhXWyvKKIbs9pcpnx9HmJT4s1CvhtzBmc529
	9CQ1avAh4YjJCqJquUmi6QW0D6qVfkEo/GsBp2OwGIVKjfLKGSTN
X-Gm-Gg: ASbGncv48Rpv4yk+S2803KY1BJO80uAqzU+9dHSxMLQYi+ljXQ83FesroWSO494UhoC
	HsISBP0Ee5G0R1PDaFSXFRcJK/8zkbFg9DlcLyMWc4sL7pW17MBL/qvjNKNxZqiyeXLdEAtR4yl
	LbCEMdr1n6A7gpZu6zz+Tck6wUKgDBl8+cvNXkZAmNVpz1CU2ss6G97h5BM8UOfrO7BHjf/P+k6
	UTnDajsm2UQQ/QN2XO7jbvuZ1MeQm+ebddKCinDhUHg7pP7NT65bGmfHI5xWHXtjhQurK2sswbN
	vxNMO0ysSrNoc7zTVFsqx5H0b1bu63ycJ86bVxGohgs7ZmEv5SwASuM993xiKZOXDDlbH/Der6S
	JrRLwKs9IcuSJydbNE0cY9NniXlir4PokiFXSIA==
X-Google-Smtp-Source: AGHT+IFuXNamy6yvaC4RvY3tYndeRO32yoAe6Ahb6JCwtFYauOhRPmpL8s0mAxZzvLPkKLZ4TvdDzA==
X-Received: by 2002:a05:6a21:a45:b0:215:d1dd:df4c with SMTP id adf61e73a8af0-215eb7262eemr4886882637.6.1747140069544;
        Tue, 13 May 2025 05:41:09 -0700 (PDT)
Received: from [192.168.1.24] (90-47-60-187.ftth.fr.orangecustomers.net. [90.47.60.187])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a38c1dsm7615233b3a.124.2025.05.13.05.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 05:41:08 -0700 (PDT)
Message-ID: <a8b6fe44-1152-45f6-9799-597525f38792@gmail.com>
Date: Tue, 13 May 2025 14:41:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172041.624042835@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/12/2025 7:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.29-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

