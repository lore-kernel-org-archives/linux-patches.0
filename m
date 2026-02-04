Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECDD42B725
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 20:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236448; cv=none; b=YPpclEjJMWhFrlE/JWYblWQVIa4vRyV9DvDSHPbSe8U1VeLAxndcjHk1YzNlrOnlcGp7NFnBrl3+GHF2PAa+oNU088wJ4RY97XQ/pDryigSWbeFHfvdo3akq5h8l9EZ1KvZD3GPtF/NOWohlkVPkcYIbdYO8j9Wm6ZLGBC9tSqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236448; c=relaxed/simple;
	bh=Z6g8ttM+QPeOoNeS/k8nhyL8ZlVQ/Yxv8xokbhjv0aI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aq2h2MCywz8S9/Ge8Z9auz4qPiSCDpi7DvgFtBWgami9Vn2wLhd06FGWZSTxF1O7nC7tSEMF7XplcSOwMb32mBeZWJH0u6qwE7OpwYecS8W2sw8VdsCSYTiWWvevYuoXrTYsj61cdp4Q65eiywxe2zOLy1Vv4lHUQ+14jcBqv0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfQ0etQ/; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfQ0etQ/"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-409440b98b5so143714fac.2
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 12:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770236447; x=1770841247; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oW7X13HpDT+eecT2ERTjNTs1FBfgPMvDToXP+QNG8Zo=;
        b=VfQ0etQ/clH57rgqOVkHWgYVrL8dZ3hVUHbgHjs8ZYLUIdqRRIbillmx2p5btbVDE0
         5r8eqBAu4MTkl/vnwJAhEwjsDyU7fDyn3hoe/LYDAhe4Z8wpYaymyl6FMZuhWRaF9cEu
         JNtAtPkSNHmichiB3ermDjQ+9RHKUwf2NYv4QVEShXDnsNpWurNEvsitW93tOrjhVqre
         GbACYramlDpvB53wrd0DSv3DbtiTu+dtjq89j3J4wdFp8jf4xUWUU9JDY3fgj4dU451G
         4XokwKhxfN8WsoG5S7NEhhQiH9Asw/pQ1Xjw9h890wNFHvvpzYI25m8y7tZvMliLBjSO
         c0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770236447; x=1770841247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oW7X13HpDT+eecT2ERTjNTs1FBfgPMvDToXP+QNG8Zo=;
        b=fDamz1bAql3Uk7lRZQCX9W672nkTb+YkpLSbgfLn1feBpufts0mpQA7/9YIJ4Iq348
         oDhw11Vxpp3wUA5qAcHuDk3vesOYJCEBaYw//yhdRRLAEjkR5x/5ftzxEIdlvcyM5crl
         qOvbVK0Zdren2H9bLF0kFhVNwzPxATyzZ6E9BNJRp+Op9rt4EtVbak87IWFeIOOyYVu2
         XuRAsqvNqYFUpab/4chyZRNmkxDHl3/7PDaECxbEgEkNP57LVnNb3E4iXDBmz1TCJ1cu
         R9k6dGSJnH4Kx3rIibMK8HXKs7AKvtHtXAj6Du+6XJjfVMqOI8uRu2Wc5+v38ugcT2SR
         BMZA==
X-Gm-Message-State: AOJu0YwgBvB6ZkbB65hgIiaaxfWN7aJd9tm2cieug+bdfhPkTsZJvItQ
	3iqmIcLTny8Ak2sz6iFysGHPf9g2DoCIRwDXpW68F9f78nz7/tYCqsxPbq8i9w==
X-Gm-Gg: AZuq6aKNlx2R6KsjZutEEYNSZ6Nh9j3RMxmqqy2nscH6t0ZH/LR00JpztQeKdTMMnow
	AZlkixqryiSb1Wb1zaTlrLB9nL6qRS+cPFtr9TxLPjLrSbDjLLKjW9OdDJfV2xsqEIl1VNVfRWP
	fJTXIjz1gZ0VzPXM2nJIdqYGebgYpUw0j1kIwWUbJsT3vA1XlWB3FlqNeLYHpog1C0BW8K5MaMd
	+bFRev+i5by3HN0W8yyW0uhOKiZarBic71Vl6uhqWccNAeGYJqS6zmOHbj0RA3Ws6k+LYoC9sxO
	1LkrL+tN8xwh/rWqpqncWyU2XDldoZl8gnQGBII0ek+kSu4nhfZBkJNPe40LogqSyrC1NaZyRDq
	9gI180TkuoNBjASAlgDtF2alds9Z2V7QOlUCLAuSCSCRZqQmJJ5gk3SH8kfRMvgsyXJNeU0gWbG
	A0QRtErkMIzPoMrW35counIy2PaJZD7v0hyhqehQ==
X-Received: by 2002:a05:6870:4194:b0:404:38a3:9695 with SMTP id 586e51a60fabf-40a53d3b11dmr2382418fac.22.1770236447363;
        Wed, 04 Feb 2026 12:20:47 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40a54489544sm2337660fac.16.2026.02.04.12.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 12:20:46 -0800 (PST)
Message-ID: <67a8595b-79cc-4ba5-9ee2-c139b14dc88e@gmail.com>
Date: Wed, 4 Feb 2026 12:20:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260204143851.857060534@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
