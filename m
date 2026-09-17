Received: from mail-pj2-f15.google.com (mail-pj2-f15.google.com [74.125.227.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E931649D5BF
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 16:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661981; cv=none; b=VrWy7LrnqY5zJTo8MoYNUwkO4iCK39Lf00Vq3koCg5yPGjgafyEOR/YUQcpR0ztGDLxRNddWGU2u0QhkRxY5dhM7xvFblIyXn47aVi0Jv5FlUhNsYN5Ex4qvLOF4hA6DHE1H23cWX03Fn0IqijNQoA2GTbYS1C0a8wJHYBwcedk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661981; c=relaxed/simple;
	bh=sBK9rAYvIWibzdWVpiEd2/Z/LGtFEqTtl0liEEnA1+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qlZSJ4LUEc+DEwpn72nrkVjGrmI+ug6TVyRteHMKzP/1l9/AFqLVWTTvEDIocsERzFJ06Hgnv8n7MFVA3F4JybqzPrB5MGIh92V4MEgZqAXpyfh9FwHTg8uRgFVmG0KBV62yz77fYqS6sQpGAuRBMaQsHy/vmmo2vTwXwTLE8Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/W4fNMf; arc=none smtp.client-ip=74.125.227.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/W4fNMf"
Received: by mail-pj2-f15.google.com with SMTP id d9443c01a7336-2d747f01363so8475815ad.2
        for <patches@lists.linux.dev>; Thu, 17 Sep 2026 09:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789661978; x=1790266778; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n3Q3dw1h6lNTZbcjfSRox23JL1XpMzI4Vd4A66LaGv8=;
        b=A/W4fNMfjs52eIBMo4lXnduSb4Siz2foitvY/OwictfzYg/gvXmV/+BTrPWkkaBZQW
         bZ8iAkVRtweUWYTgHULzyI15nIGwkLpMF6Nq3brJBib0RzmyDte3SiK4/MO4Tg0O0RPY
         Qa+jc3TEdVuzp3/xrV7CDEGJ8gimwoPevhb35Tt5jjv00jE51niqCAqOr6d+EGXyNqng
         33Om+/Q9Vgf+AJ/n6JTNhxZnofn2akSBvnPfI/fuhlCj8wQgHVnzcuhts2G5Dgtnpb1w
         AigJz6MHABIBhvO0ApTKS1Et2/72GnXjvXBQYDqGyx/C9DBYeavxWBARHcdDqpM5QcnB
         7UUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789661978; x=1790266778;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n3Q3dw1h6lNTZbcjfSRox23JL1XpMzI4Vd4A66LaGv8=;
        b=YqAmhTp6sH05AW00aFFyL9P/zhksaCEtCzAGHXl0Osb7PYcIrbqqo+eGyp4nH7OHIv
         Tn7iM7ONo93rHdMWULhFnPETzryvZD66o6cBsq/aHiR5HBQ9hejxYkctT9gUmZR78vJw
         FaQcvtFVpsto9cexUMNFc/8BTg4NPOwrNQs6cUGg5SqbTAq4HNZMyDG9UounY6JcxAph
         vTuAQrgW7Sb/9kUnD2FwrivFI99V7p22tMZjTOQSTV6phQrmLPaS2F9Mw4Tcb6nQLsov
         SYXZaspKr0kZHozi5yYcCKi91YVbJnazGKV1WY3YYCr0jIL/LtmAeVks4NYgdkx6Na5V
         9Idg==
X-Gm-Message-State: AFuF++kqahlP3Z17OeQdFFwCOtBtxwX5NMX0m5KW8GmlA2ufKm7yn7G9
	vYmYkqoVcIYi1zUt+t0PXE7mpyySzYDNpfCgGxVIzOPFKsBQX37gSLcT
X-Gm-Gg: AYBFou2MzTxki16jDQ4yGcwJCfSh0lNUPHVXqh/VWw677WwyHJv62lDB9+P9Qir4UR9
	MDk2fWlKk3xnLcIJjYUeIj4YcHIUfGgBHCizTCu4AY9vJpysTzWHp7SU1gml9wBeSJ4r02h6xrv
	4kaFQp0tVRSgu+lSUzOHyz1QjpYh+tg/Gr29rSRoRNdRAqFjSqPApRuctUdffp1BH+SmXTXxFai
	E/7toum49JusgbDE6EHNrUBj76EpEx4JjrADp6O7I4eVzUS0SfabV2B7L/MO0zqaBiVf7rG0P6Y
	M+kzDe4dUPCjum9cClv4n58TWNKn+AHM4dsHpX/gk37XQytcHfMoETPEg8MJXFbieF2+ifHvzTa
	Xn/CYjXM1QV6GPgbhoXn6LcVdiDZhPb2/x4OjK5ChbqPuSAvfoM1zan4xSAO/xl1UMKdXV5tVhL
	iZ7NivSbNBtqHlkIq7dIMJHSyccJRoytD0aekddII4HYBy/Lr+p18afrKgM9WMMAfPI/BBxWQMu
	B7Z+JMJ/rjz+3L/+GFqgdDb8g==
X-Received: by 2002:a17:903:32cb:b0:2dd:ad74:ac80 with SMTP id d9443c01a7336-2ddad74adcbmr14361355ad.27.1789661977897;
        Thu, 17 Sep 2026 09:19:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89c3316dsm29772185ad.0.2026.09.17.09.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 09:19:36 -0700 (PDT)
Message-ID: <6edcfdb5-f73b-474c-96c2-96913ca5ed25@gmail.com>
Date: Thu, 17 Sep 2026 09:19:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260917151350.597953846@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 08:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.7 release.
> There are 733 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Sep 2026 15:12:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.7-rc1.gz
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
