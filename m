Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897CB3081B2
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759251973; cv=none; b=Ft534PTTSNN/T3CbCjDNCtKYTBqd5jgzcZKU1BM6c85s9JEDYasCdljpdHZCe3bdiPBjhuKWHdFg9/NlQMFhsgwbHMpvu17RKsw79tDeDahsfS0eB3zhsvSdxFvkY0taYSEbu9i2GBQTWGsknXzmJz0HWCwur9Dw9E9Fr7VUCsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759251973; c=relaxed/simple;
	bh=z0OeE8KKG8p4YUEXLYKNB265pXE5/l7+L7QRs6INbAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sl+I6sE6R/WJ+O//BjW1rpzjeOHfV3ZdpbzMSi1FQpm1yCAvmyg1cUJbSmxn6zPgUnUvwsohK8NAVQF51HGI2i+LXuX/HjC+Q9RO9G3J1I1Pj+sQ8KueciCQIqMPt2MYdXwPd6vZlKiDMBbX3knA3glJsuFzVxQdm/c57p6EV8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a2RNS9E3; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a2RNS9E3"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-7ea50f94045so980866d6.1
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 10:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759251969; x=1759856769; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dYca6WxwMn8N7DVnp/rlZBC4kI148ITA0or7jK+Xv0Q=;
        b=a2RNS9E3AF0QLzqy8Dj2fZUmiDZYvOdzVvoxmjfSsdO74VJgxCLX30GsHIhFxyiNAp
         IIxNPaqwE0fVpBbX6f0m+PZncKdglb+Ble+Gy0X0hyAriTmFVm4YeC/bOjLq2eQbiZJT
         v14dZbFoF5mRUejO60y0nhbeems5sEyjmBhORmNXCY51Jsl+3IS6R34XqITbKMdukOZZ
         wMvG3sqKymsW9ixkkR9vrARMBoDwVQWdUIyiZImFVHtHk3dnPE5exCwI71mkK+Wrggr+
         tTAPgSgExFl9HBePNdLwYpz6UKgBQg7NY5nS7V51PJHX9EQlLcpANhgJSe0lKp4mNuas
         K2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759251969; x=1759856769;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYca6WxwMn8N7DVnp/rlZBC4kI148ITA0or7jK+Xv0Q=;
        b=XQEm39LFnJm/X5+nIzeeBg9K5f8D6zb3b7tnoccpGDp0LnvYn4ZDqSsvHW69u3OSmw
         A0sR9FRO+BpsNTTJPFFq7fDfzn6uUxvPlxbcF+1+wedithSPVLlavw/HAJbwlWe2yAAC
         Eik/aWj0JDJymuzPXbrEPnhEjmDv4uYGMAAcG3+xzV+E9s52C8rqRE7iGf/QHdTqlnuI
         LyiwD/X9jS6oB+hG/LWcMKd2M171J28Q1xQuaYPnxwX/+z3e3gF1OQJX4lCqTknHwXFn
         U7mEHaOLDV3dUKGwWY2CWV/AL8P7eUzrnEVAlWDyz/NGHbJmZs3ngjifIZ8SgXkGNlaz
         +zbg==
X-Gm-Message-State: AOJu0YzwYbXHv1Nqmawl0X++Jto2bwyuP1auK/9c8NzhyKO7tazMB0Nt
	JtccWI3IDHT/yLq1Gl45KdfXi9mPb7Q9mUa2dpadrS0Z7RdPcLJ0hDdJ
X-Gm-Gg: ASbGncvQAo1Xzq6086gMIk/Zz80UctBIXUsRm1MefLqYOVvZgvnibPF9VsjecwQ1p9Z
	MNeTPLXCspv5K2y67NAyMbKSdu32v63YhWIazLtYGNf8qclVBUEbmQPQr7R8dyoVk94QERG1fsU
	FrF+eEEYRnl6vjzLtMWstY8mDL9Ci0FZqQS+zZ3wivb4VNltTXL9AsX8Y0K7pBEsTNTwZ0omeB9
	zu9bl9MeyWLIEZJt+wbJ3+1kaz0j6nIZ8UZfdkC82R9T9nfztNsl9XK8TUL3PqiIQ/7VNOGCL2U
	WSgRmg6bauk6tWqPsSAUUV3nU4qxUPnr0Ytn0HZj7cva7PMfC1cbsv3QHP+YQ5R7JYylTHwn4J2
	OoFIi3Hf63RnAZKXOFDZgTcAtBnt8UZ2HqK7IVpCIsgy2viL6hn4nCI9dmdjifbGK5Ocj+winb5
	1z3lPzXOOH
X-Google-Smtp-Source: AGHT+IF4D6Nsl38GnCXyOtksgIhWMh1L+lM9odVVJFrjIv/5VTtQCbZa7dmUDr1LBiNm7pc7h/TPoQ==
X-Received: by 2002:a05:6214:cac:b0:70d:ba79:251e with SMTP id 6a1803df08f44-86997d2ada7mr64406166d6.13.1759251968994;
        Tue, 30 Sep 2025 10:06:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-80135b54636sm98871316d6.6.2025.09.30.10.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 10:06:07 -0700 (PDT)
Message-ID: <b1e7efb7-ff4c-486e-9f27-1e5b26d4b044@gmail.com>
Date: Tue, 30 Sep 2025 10:06:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/81] 5.4.300-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143819.654157320@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 07:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.300 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
