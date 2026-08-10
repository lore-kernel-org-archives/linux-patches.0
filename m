Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A883B14B4
	for <patches@lists.linux.dev>; Mon, 10 Aug 2026 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786401042; cv=none; b=EAaATvMvE2Lof4es1BozoLgl2gBJ+b8KfYnQsoEcc++v4HBa+BXNOOnlNDc45cbNqfPidc9mNf/FTkULx8MN8MhdrRDFb2EpkqPSjlqy3efgzSO9e07deGbApVn2dGWkirMYCvSQF0hQof/dNcg7KsRV9/8RHstCniN9ricr8vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786401042; c=relaxed/simple;
	bh=hsHr4G4ly9k5dRJk92lZAUzitwrVDUCT8/JP7brInqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rbK3BDMIBdQ9LRzmfVrY1/lHh/KN3TsV7RA9fKN5FSBvb+dkC5Nr2YxRDD206VIm1tlF6kN2BxBX5cXEeqgiLU5CD5GOQ/JODTuK8xJTn0elUyvMgJhieHbT/XWPF2B2yzt5ZDbOn9ti3n/AW6GRA7VE4p/OQFQwUwOykNGCbiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ky2ZINKc; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ky2ZINKc"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cad8076b01so2293565ad.2
        for <patches@lists.linux.dev>; Mon, 10 Aug 2026 15:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786401041; x=1787005841; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5HufdBgIAJR7/ctK7fDRqhrzMJOl3BE9kKRvhiw5OD8=;
        b=ky2ZINKcfbs4tYlFvKjkzdAyRB50U+JtGasTRy9jQTemuWvOx1QZLbIRueZ1/R2v+k
         g+LNz1RFOmy80AnC9N8lIE5X37RP6HKD7SwTZGhH07FKM/3EAPuevNugVuCoAOjGNCr2
         BNqUeqDEjAxYD7HUTG4on0kBCC+XGX/hwy8wVLtu0lxlDkVFB6qOYv37EabRJ8cZ0i4E
         YkgKsFvsPFvc2MbRamNW+2Z9A10eVEK8maSSrhAaFFNepPj3IDDGjyW9vtqUOJysynYi
         c7DXcPA+ZNYB4BLmetCeotnvvSHlYYzh44F7ofYnvQcdyO6ke5KZAtnybZw0dD6iHi8n
         zmVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786401041; x=1787005841;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5HufdBgIAJR7/ctK7fDRqhrzMJOl3BE9kKRvhiw5OD8=;
        b=DrSbYqyWjIjuwd2AewdtckQPnYVu0xLkJilmM7QxDTrRMeb/+ScUYJ5dNMlCzxqnqm
         nSxIk7DkgL+A+8YKl3G7rRcmt3M+mnoNH8vTrpMGprEesqypDwvjK1nTNnNxhFaQkzNH
         i3q+JvcZ8PDRfRQ0jL7tIe2HRfbEmKeXkoBmUjYbrBAhNhze5x68nfYIfxjsysFllclF
         yopPFsUA7TtKJQwyGC3/NxO/tDJRiAUYO3Swh3aEq4vD7SrTSbvidlxgcyuIHymC1ZfX
         rYD94nYSYv/eJi8mQqW3fhjKQwdG8nsY/mUBrMQE54egOMjI5BmFaNdrN7wMQmFcry9Q
         qaig==
X-Gm-Message-State: AOJu0YzYNMPvgvUeJceOdPg0fv7UCF8rQN5zLEyqb0uB5hIpsrOjgeNP
	uO2Cvoe3e6I/AZNhbAmwQZct3K0OZhk1HQU6dLu4UeZQq1vZawss+d15
X-Gm-Gg: AR+sD11dFF1pUVMK+hNgUji4nkHWUZdnD0pHfWdDtFSvwHJI+f0/4B9MsEkLpKjEBb6
	Uqs1rb6tXHafyxvh5s/XnNsItd63+mvKW+W8TZTntZSUDSUVB3l5HexHFVTPrUmK301lUp9JJg9
	igfPUxowAefdPrcIMnpOBCG3Ivom31CtuFgWz63+Up9uhYJRHNRfpEz0f6RZd4Y9U9H4oh8omQD
	PWLAYWlakG+CJ3cOqDYDBQ6/e8UvaE4GBcBwXwt1RtYy6VGKicPUvE5cGAKcP69JsySDI/T+Iz7
	oHWvysBdWqtC2ICYl5zkou+9TGi+CB0UXrclnlvQFB24VnebJMRg+8f3uTeZaK9q6/zIXdWxGfJ
	Ojpje19NB2IP756Vb8PN2KCfs+NipnODgw+pBE/m5fQBwcMPqA1iiwfW1PkC3lTPXvB2JHfThb8
	BR9DB+XaUG3Y80WkkLEa0V4KCJpPqsIsxd8tkxRk2gp2D3PycRZsgl/cQ9TV6ZrbB6eyvWKWWkV
	NHG+3o7J502KM51QxYzucs8SQ==
X-Received: by 2002:a17:902:e852:b0:2ca:10c6:f69b with SMTP id d9443c01a7336-2d0ca7b54ebmr482605025ad.5.1786401040876;
        Mon, 10 Aug 2026 15:30:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be8a6809sm49065994eec.10.2026.08.10.15.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 15:30:40 -0700 (PDT)
Message-ID: <ae1a6450-67a3-41e3-a79c-3b9f69e3c79a@gmail.com>
Date: Mon, 10 Aug 2026 15:30:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, Ilya Maximets <i.maximets@ovn.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Sasha Levin <sashal@kernel.org>
References: <20260807143418.516897842@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.103 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.103-rc1.gz
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
