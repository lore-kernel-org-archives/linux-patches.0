Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF9E1C6FF5
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770233477; cv=none; b=jfYSjNS31HdrY8MaKC9R3+6oUJz86yCAu75y0sRk5I3iG8U/LyDcxXz+FGcdfeLvycK2L2MgcQypRDa2AisnbY9nGTCq2MhSSIJs9jHBtHjNa5UnLZE02oESsc/srjbNA3oePRzs13MmmSNTGdjDv3ot58goWaOew4/nEkdmxWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770233477; c=relaxed/simple;
	bh=1wVbNCL7mJuBFv3mVOLcFDU0DouuXiCE9Qn43xJuscU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4/ySyUDP6nKugJxaQJnj10Qsy1FrRrq8jnefTKgRpao99hzsUGiXbDM6DqNzxbQA3STRyCC0sc+uwd+qwZmESwO2BaJKVYXDK23QDS9I8v7XjsS8ut42+rWznD9QsEPwwmox0F7VqeZqlV6tfJa5m/7U5Nca2CuPC39hzqzk84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=krlNiskb; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="krlNiskb"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-66307e10d1dso102182eaf.0
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 11:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770233476; x=1770838276; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z/NZCfJ3FeJBJ3Z7n7uLLlEjb4EHcHxxuD7Rih9R6Vw=;
        b=krlNiskbfHbjWj6NNBEaoYF5QYBs0QZ/sXhSKCBSGyfa7H6rLXmlgVMbYp6ZYNUVn+
         pwZ2qYl3p0ZLsuweoHYZ4jP3s5a6KcvvVDamZvW/aA0psS9+8fCg6nqgIEVh+650YoTj
         HjzakDbKQ7B82OaAM1xoikvyjCz10aakdA38EWb+uxQZiF055BW/L0so+Uf8yLIAW7lf
         P13gR4kBC0Ff5A8Mrwwmwn1ZZtw1oIlhKAm5XfifqDxdAEda84v59bPeJPG1GkGV/NFF
         3UJX/QmT/WUxyMA1caU/Y8zAMVCHkFFJDXx4+1Nl4d1psqsyCMkCoxsUfX/Lzh39srVZ
         UoqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770233476; x=1770838276;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z/NZCfJ3FeJBJ3Z7n7uLLlEjb4EHcHxxuD7Rih9R6Vw=;
        b=YYeIsawMvylym3zutXTipimMQD42XPzyHG7qMD5Qy6ckhUutBVUZSy7DKiT5B1COk/
         7o6+qCxabb2TzekW6cUXJEkbZwYrRBRyOkkJiMMKdGqwqlZ+Vr4nwApSEwEikUkIk12P
         Wu06/3zp7tigMWYiSEPSgvzAGm8qrP5O2EU3Y+6bFC0M/a5ep6sr0XhbUNWitj1w63vl
         RrjH+8JG1aR1nq5MWWRUKMBHIzxI9xm+VP4u4615Ue63hrsLzEdl1mEZzOqQSGVCSFrU
         HHjt4kMOrAdfmRdVs8iTcwQFfWDRSwHo6lD+uQm1T7belrKKW0P5iyeSGnyK0hmjeYP0
         g72Q==
X-Gm-Message-State: AOJu0YzKeEPki/163wkpYqRdItdRwSpoAqHGEfWbk63w6PJpYvj2BKeY
	GIy0HWOVUhbDAuumpS29/LZr4+47TqmuwEAUcqBSSoW9CuOQGKq5bo81
X-Gm-Gg: AZuq6aJr2yAbKmsgwyqaq1KliQV93C8K1EbWz43QfKEQA6aL5Q6WlLjAcxsK++eppBg
	2XZDCRbRlATW7fir819Cr16LdZL6zk/pSyoFQzGOGnsJvEUs+t3drNLzXdgQ8V9DKddvt3epTB8
	jZTGhTCC1JN9u6ZIaFUlCzuQI+qLNx9cWio950pUUy8LyeID/pVt/rZ140oK44EYxzHeTGV5jfi
	yORY/pabctmGcIyQPH/PXllCIk4hjnTYCBsS/byqAKJWNQ+eKZu/mqTT3s4dXBotRCNTige0FzE
	eRoi0exzDBaekBM506irYyXJHbLvMH3r22/iVu9LnhWGmlatBC+F1TTPuEGD5cp6U5PJVifgQoS
	QxooIWp39IRg8NT+PyBIjBP5pmueLHavtO99rm+EYFil273c4Z0vzoyKpGzoFFX1UkdY00qkM4e
	70PX50zuRZkDYPyxm4sRmWLSLV3usJ7woJPtorufZ0W4UeQEI1
X-Received: by 2002:a05:6820:6ae3:b0:659:9a49:8f70 with SMTP id 006d021491bc7-66a22979c30mr1849320eaf.53.1770233475810;
        Wed, 04 Feb 2026 11:31:15 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66a354bdd76sm1813640eaf.11.2026.02.04.11.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 11:31:15 -0800 (PST)
Message-ID: <5598b605-df7f-4490-ad73-45d6dce9dfa0@gmail.com>
Date: Wed, 4 Feb 2026 11:31:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/161] 5.10.249-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260204143851.755002596@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 06:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.249 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.249-rc1.gz
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

We have a new warning:

drivers/scsi/scsi_lib.c:321:17: warning: ISO C90 forbids mixed 
declarations and code [-Wdeclaration-after-statement]
-- 
Florian
