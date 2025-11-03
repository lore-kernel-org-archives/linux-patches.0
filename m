Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1F431A559
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188651; cv=none; b=lcojpd5xaLVqe7X0veGRZDrcthOUnnPSmiDg+qGxD4kEW8qL9FBYDs33aleqWzVe3JB6SJpVq/1hqdE/tFklo1PAz2wYbyGilWg6D4T+sGZrj/BbCyRJVapx016kqRCnXv2+h2CGvsie0jQ6oqRKZ9/gBuwPf3GFTSrH6tCP2hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188651; c=relaxed/simple;
	bh=r+grU7PC+G6N92zehaPAAv5rPvbu0LMva4wOUJ4SsF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NIIF946GuKZBXAmgXC+ymYl2tOnsUEw6mX05iuirARbfHn01azwGgFWUOc7n42L0AsQWnl02dd9BXSiju+w4MDArrVkbQVUgUTFVVVaIKN3OpB9rPWoNZqgp1lkIN+sZFqVaCYIZuixpNtIuQRVyFo7htbfxNWhciadpvajPUJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gSHakS51; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSHakS51"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ecee585f23so29880031cf.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 08:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762188648; x=1762793448; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dtnw78k2roy5z/99UbrJhP9TDpGnLB7iULXtjAYqrvo=;
        b=gSHakS51rdjglXljIhmTVPxO2402y3VGXA0NSpKe9zvRu/gmafhx7/YlMJ1QVbSQRl
         rhz/boiDbKTyO1G2ptXMm/dDW0pfSgvbfvofo25oXHE8vxIPwT00ZLdajbPBtwX5zZ9R
         4woQwJKBZiAA7igMOkMIzT6PxqQ8pc9fS9SP37LKUDtLRpzEevV36S1XrowXY+SHHsvs
         e3Yt7HWfO6axKBSYd9Ur0PqsdqYsqif9xtmhKOH7WIS5Mrgr/3IlzPloqjghwV4rzyYj
         JVp1MU8j4fI4XkC9R9OfMGCT3TdewrRVtpvU/hq9kP/Rntg4NaV60gJY/dd0ZNT2WHaM
         LA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762188648; x=1762793448;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtnw78k2roy5z/99UbrJhP9TDpGnLB7iULXtjAYqrvo=;
        b=YkaXDefDJ6c6WlX8AlBmOqyMk9oyHWBKb2jBHOsqEtS4awodlVOENsLIEiAcyokVMB
         mL+X0+Cw+mVjjLceQvO/+oLbFzUxQNbvYw+8kXYddNVODQOGy5n95o7+u40zbP5bopg6
         SijGIBl84fyKqZw5M7P324RXaoNSHDn2lC6cTd0tcUJeOmjzPIOXPmiEsqBBenR1k8UU
         TaY0Jh9CQQHNjDxl+Esiw9JPeQDW9NDcgAwl0JQgUAXbKdvMYhWnA+5RZ/cLZDfBXyN9
         akr1Yy7dnmb3yPm9AFe+LuOdBTW8c8uGu7UZTiBodCbt51OLetyAgN3GSUXReJ7slX1p
         XJNQ==
X-Gm-Message-State: AOJu0YzJzR7NZ4XR49X1pN0I0bnc7sA13JvsqMVfVFIFRnKr/ORL92Hd
	Eopu+UuKzScMuvYToCVenaF6y63qA5VHvCLGUqGXdh7xwOLbSlAQypOE0zDmbLc7
X-Gm-Gg: ASbGnctReHw+dMoNobpN0PE/rv4gSGTqEUKFQVq0kGtRHoYke/8af6FUMn+dWCJFI/G
	iwe6p6ZBmf7rYPyQCM1jFFhIYu4Ig1d6NqwlQTBCoSRItx7tKuryUV2yCxVSSEvqu2bc+gqEo/0
	KWLBb5Tj9iUTdseYgw3QvOsAaIthAHSnNTN80pWhehIa0DPGMTL+XujclLj/d1QD4+fTxu89yUL
	gwE1QZSx5qmU706lHJXl8FCsRtHu6SAMwnXk/rnr+80pJPbHcDIyN9bBv2PvlXKPdi317u1bAKs
	8mF7BdGsgnNO/qb/LCa5NNLhPK8Q8uVXG3jtfkp3doDqeMaSNu2hSrJ2bl6uRXtNLxcrZ0Ks1Q+
	mdoJdcFhqw9WQPVK6g5hUL6UtNY2txcXGgZ/Fcct0crlNJ90qXNI6nRKv8IcswfULMUh0DUKicr
	2c3Xh2OCE3sIkb5MtFcRJeA39LUyM=
X-Google-Smtp-Source: AGHT+IGaidtdD1Dp1nbq6fggrdpMGwWINS1Q04b+SNwTiL6KnHfGQj14i1rEtQip7/fmniLspjP4Ig==
X-Received: by 2002:ac8:5fd0:0:b0:4ed:2fde:d0b3 with SMTP id d75a77b69052e-4ed30d91bbbmr155504711cf.6.1762188648327;
        Mon, 03 Nov 2025 08:50:48 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ed5fbdf2b1sm1644631cf.17.2025.11.03.08.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 08:50:45 -0800 (PST)
Message-ID: <65b0f959-7f5b-49ec-8e9a-3be884af0cbd@gmail.com>
Date: Mon, 3 Nov 2025 08:50:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251031140043.564670400@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/25 07:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
