Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0359E1F709E
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 16:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743007272; cv=none; b=PWxZnRLZKzJ77GxDBlrFQkDc42+eE73m9g/3HzExfLQQoGNhkpxHawixeDm6PEsZf90eT4aYkx9hJZTqXDUayy81+/jhQTFtupYd2N48MuQwBln9c+whwtAyG0COk+F2VwsU4D892oKUNPkvH3HQRxcK6XPNR68YjtbQ/vp1swg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743007272; c=relaxed/simple;
	bh=TRPCTeOblCNc+WaPMVcdL7R3jZ+yjzK8dIVH4te2LzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oSCZCBwcngPCBUD9FWSY1yHuqDSQpFvvWW2OMxgN0eL84JMdfdGhgI6ehBeD2HJSXBFv0wXjAdzwb4s+2W1lepRp/0QMY5jiK48JjFClYNXO6WcIqq9LGKVsDLJmiaCgCm/8cVMPxHWn8MSRTxM4AaO7sViL0SHsMarTCIrIkbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fdh1wBor; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fdh1wBor"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3feaedb4d2cso4068430b6e.1
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 09:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743007270; x=1743612070; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DuR6RrNn5JVp/SGXjPsHV3iRc5Uc6pEi1SUbL9dqAmA=;
        b=fdh1wBorbx7Rs7bNzcixc3G7CVzm1gauDDQBaa8WZvgMoqFUUQ1QP5nuMLnmtUC2BM
         4h+usobdfVQU10411th7keboGd7rlPHH2lraDNfB2i4N8X7AKYUaOQNZSE2GwuZqUHpE
         FeyhjNvFgf2nCU6JF9TRbcF/33QXsHxre7xeGTCHRghEVaJeRVGHDxcJ3Vfh1SnUws5F
         DF3t4ya/EmY2RjuILjdFKIAJYkznki+p89JSzIO82dv35dlMVakzxMiXw/TcS8JpvUTB
         hvTbWfhO3kF/OirMm1QGTwg4LbClU4LIqCKszrX36rrnxd4edr95ckiiva+AZqpt1UU2
         4pKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743007270; x=1743612070;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DuR6RrNn5JVp/SGXjPsHV3iRc5Uc6pEi1SUbL9dqAmA=;
        b=iwHQ33kOHSyv2vHVqH3jM8f9FXlgT/2jRT7rtwphCs+WyhHj6Shu/ipPAQsMCe86E1
         xsRrcGWVF26aM/To0b8dLiyTm0KxORsz9FsX9zyAbY68Y7kkxDyU4A7OglwS3zRIZiee
         DO2KzhLCbVM57789ch1i6fjgDYp8O2hcO/iWikxfyz0DK8RGrJEn7engKF/jduDjGjM2
         PM9wrKP5AbVdE65CVF64HjhdTP/S4h/wlI7xp/CruA611lhm0JA/PrRDvbUL8q6S0Ip+
         bWuHBwzI2jUEnICLKFsmlxfz0CSBxZmWWVQnPeopEHFyDcQjT3c5DaNZX3FrEFauUQcy
         XpIQ==
X-Gm-Message-State: AOJu0YyWz+EEakIwvZCJbz3Sto4y38mp2bb6L05qQkQPUFPc8/eGR1N6
	vjY28Ciims8+K/Sh3KglCETTYeZsPO1k1XgPMFEcKINQMYFqc9a1
X-Gm-Gg: ASbGncvEgI81x6NHO39TqdeqE1iRB6lJkuafernKawe2Bek7d8DgDIhkliLJPwof/oP
	szMuLhC2pEzioNtQGOgdO5mS3FN8pGbPKp8VkzIzBwRU/J8RNQiwpk9d/UAYL6Kwa31KaXB8P9U
	tmQkssJyYD8CfKDl3O5FiuZ4N3/OEgr6ygz+HvHf6sKk7IG/o99xNtE6ACiABFXzbk/qKFYOK4o
	6gCEU1ugbc7TbDzbZkCVlKgI1F43tJRcPDdwVS3VZpVUzuuqDXuoTe8XitrBEHby7RogRu/br/A
	w3Y8DLCzMqjPq9YHot3b9V9/NRgDnSJXyqvcdm8ld0seGnsj2P8kK46Qj2I1ntqVpy7SgONx
X-Google-Smtp-Source: AGHT+IEmQtI7rlWgL7N8H1faOpD3vZb0pZHTQTAvPeHVI00gjl3GJfby348T43wqGb8GCvK22tFxLw==
X-Received: by 2002:a05:6808:bc7:b0:3f8:91d1:d950 with SMTP id 5614622812f47-3fefa6309b1mr121472b6e.38.1743007269922;
        Wed, 26 Mar 2025 09:41:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3febf6e95d8sm2431122b6e.13.2025.03.26.09.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 09:41:09 -0700 (PDT)
Message-ID: <542780c5-5ccd-457a-9a61-4df9144d38de@gmail.com>
Date: Wed, 26 Mar 2025 09:41:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250326154349.272647840@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250326154349.272647840@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/26/25 08:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Mar 2025 15:43:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
