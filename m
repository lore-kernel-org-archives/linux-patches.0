Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3138F4508FB
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 23:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769039033; cv=none; b=NRNU+iG70OO7WBySscrfTCat8mVGbHNiAJcCfjnqAryv8tL0wFV/RPY9ADcpm+0YLeLHfg+QJFhnfZrXS34es/zeC2gv5W6sDAxrrlmOCbPHdwgzx7zWGGpNk7NKHBD3btnqzr+T+LrXCe24k0vwNhDQJn7eMK5Q/nB0tKkhLCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769039033; c=relaxed/simple;
	bh=9HH2ST+6YAomJJ5sRQVl3r/BwtxPLEbEQWXMBApKL3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KvaQPuO8flWXTgDmEArmuJh+fGhDJaD6l63OxYSH9KTwBn6RSXfZZeQ/aH7yaBmc9dAEmY/dNfrePwS+aU+rjw9VlvmM5bLOYV1GoEwPjjtsMO1tzxUrUu9rFjmygpdgWn6Ue2LsK7k1VkrYkFwXPIdam+YWvp1hJCcIvwvwZNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iY8ztQVg; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iY8ztQVg"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1233c155a42so638572c88.1
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 15:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769039030; x=1769643830; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gRhGi1QIfFeTS7wFhhUbasQQpPGOG/cl8/8BZth9tJU=;
        b=iY8ztQVgd4fMlTLxjIFmoQn/hcRaUMnK8jXe0+u6HdnXpBXF1qknYPhrLVm6aH8ltb
         y7ngI1GRlYzw/zvet/tKeGFrsJbclusjWjhGIXnCVEvMqxhPbPjUhQ9czgTRix1V2dO7
         xOJ9O+SNUOnYPQPflfS+HzmmfaqFj+2PBqdqLlbOSJc+lJ/wrTx52J0eyIRSz5keyBM7
         pBaXOjmL79R50Vz2jazxo8U/UCJnjQK2PFGLa3B1AvLyj1sovPQhRc3PgKGez0EuiEaK
         f3MIV1tYK7jvJER8aMljESIe//ErRL6Z/hMuI437HF6pYWzaZnihxQENXA8uOHu25vNp
         dM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769039030; x=1769643830;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gRhGi1QIfFeTS7wFhhUbasQQpPGOG/cl8/8BZth9tJU=;
        b=LIiCyxB/veqI7iUa314jrNd6DMRQn2oGYQcr2rxSZBbFEh/Lucn2uZ4Bbu1Ekp3hMT
         5iWcf0LlZs52thqMD2qiMw+xLtkAetLP6sM0u6Kz4NPc0d2+SbcLS8kE/qxJf8mKzXBb
         tAwlqXO+ah27eJKtMX5WrZJ4bUEN6VLpQHo7tt8dVuvhwgz8ZNzylGazh01se/8oGkXx
         tDImTkBaWWyHS77tif4WP3Uvisl/z6tyCPkDc7qmE1PZqJ/GmykG7M8w1gkdfOmBy4r0
         pbNWjjUXj88BC6akVeZ7es7BbcLWWvq7rvxo1owTcRwKCucDjrSp+3kHFJoahkG8a1jl
         9xzQ==
X-Gm-Message-State: AOJu0Yyg53c5fpEM/yY+MduLqklZOoOKOOi10WNmsA/08QXNtEQmjsru
	e1w6BxKkX8ESI3ntbXoBdBHvXu+UDgiHt6fqkAAPEp6IwQyfcgFJZXa4psx5zA==
X-Gm-Gg: AZuq6aLOczYMETwqSxExrc3vQaXClRAVp+0Sp1ItRrMVj6zVG7mlLr7enz9b+jQTvag
	bi+Q5pVCFvL9OVspTsHMQoQtfJipopJhZnUncM2hNYcFxgWPkRSWiCsT3hjijHdEatzuq6ket+e
	H/gUiCkai1DQ6jjvUoT2+F7SFYOKSsQ6iZX8Ld1bngKb8L624VhxkYw91I4TSafm5Slaww+L3WR
	DtojLtIQx5MnQDyetsECGG9lYYFoCtF5+bl7UFhT7BBqza/yrtjHgBCtJ5VPc0LoJW9yOWAWi0D
	DJJZrGOUJ7K59AVRCV9JSlAwGHBHQpKYDM2MPWFJMgj6mazBD8LFwxh1w+9wvWgRtbTTAqoRxgE
	CtpocbiuPLd2M8jADBYDTGoLD5xhjwAY+P3SylpCWhDhOfGlEPuEPciPTWU8O5EjXZyyunWz042
	SkHY8m+IsdR/5T3mfcpY8ZK3pjunhV9hKNV9rLoO9iWkpfenAN
X-Received: by 2002:a05:7022:689d:b0:11b:998d:bded with SMTP id a92af1059eb24-1246aab32d9mr4116309c88.28.1769039029789;
        Wed, 21 Jan 2026 15:43:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244af22aaasm24410674c88.17.2026.01.21.15.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 15:43:49 -0800 (PST)
Message-ID: <fc6a16ab-881c-4a6c-98b7-2aae6b4c6884@gmail.com>
Date: Wed, 21 Jan 2026 15:43:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260121181411.452263583@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/26 10:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Jan 2026 18:13:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.67-rc1.gz
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
