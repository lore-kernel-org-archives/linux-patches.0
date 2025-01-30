Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F851547C9
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 20:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738270234; cv=none; b=OLsDaOeINabR/fUGgFq1Bwzy3ewMCctqXghnxLSbt2ynelgDXdLIoHzYLWDctWMhntxsWccnlnBPg9Vu4iMxr2rKH1+Xq7bG4co2lhoPRY6DM3FTwx/a8KOWLByseairZ2S/ZaEeBC9iV7Ok8HdXtBtHvn22ii+4Xzczkk65J+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738270234; c=relaxed/simple;
	bh=Qj7emfc0qplYYCs5OcbTy59HCcddBdEnCOXARYroSIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n0w+JzoURWWpvpIIklwonlJSSJ9uql2eOwv0uG82TwjCRZdftWxpnRINrrEeJPWEzenTldrAo4v5RVyKtB7SmU/dUd50JUWnZdH7Tlp/Gins8jE5O0tYlvZoI3h1CJ0NowOb/Q84ibDCkrbIJwtzkyorN3xuTryc/qISWZMeRdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WJUCzPbA; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJUCzPbA"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3eb3c143727so1090065b6e.1
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 12:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738270232; x=1738875032; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iZo8hpxoqHa3DYL5NC5WhT0YUjb7CkDNTgoxTkCC3eA=;
        b=WJUCzPbAyMqm+mcF5/1skbRgAuMNiyGaJJf8QsKqVamFL+SESfn8PHXAJ0itbXi+XZ
         ENnF9kHWeymtGn0Ctc6XVu6hwNyCqjHKiwy/95Qo36aXOIOH/HEZw1dRKqmu+7lF2wkr
         OptwtanelRq7tM6o6+L9cSa9SnYLgRB5rQ6SRUKlwYnMSjSlBSr4QaatZkL3TMbvVJ5L
         cyHGsdjESZEafL1UjTzXCAsmulqRvS1yTTYoOXji9FfqWrei7dSy6BLRBWV6o2RW0AVJ
         AmjMYqJtZB+ppsQA4sPfrfe83qeq9QqvoTosJDVRoE9rm0pvXM4fKU8FbqTSZKAOr0Lo
         wopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738270232; x=1738875032;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZo8hpxoqHa3DYL5NC5WhT0YUjb7CkDNTgoxTkCC3eA=;
        b=F6u9TYSsR8ZLCKoDvxhwj8mC3oUey6aPjpdCEcsRIvqGX9E3n2Ku9QT1dRJH7X67co
         zq0Lh9WDiSG3u+orrI2kfrl5aVyFOeQhAfh7QvoSW60vhz5PeFZslEpibDIDIPKm4CFu
         6Rw/ES6o/h5CFZPqAYLIInDocPV31XZFnB59hnfI5AUqVhxuEjWCiRxNTxno27STOwwi
         pU09WuYvmeVtJNetPvs4Nt91sA1uDo1oDcTcJg15wLs9pZIdSp0fB3D/9D+wssIA4ZAy
         0C2lNTBsVBDJCqZNM4l0KpbrC3A/7L9QatZvsopemyvShTiCXOgszFZB2W5LhWIupxJd
         8sIA==
X-Gm-Message-State: AOJu0YzrWKtDS7mxAwTZKImjQIZnwXveuP35GmEkhafdcKXm33rxNpv0
	Nfu0Hx3JJsi7Duxmlw6aaUzsPz5Zyp6Y3I1a+sDwxwyp+L4DvDpu
X-Gm-Gg: ASbGncuM7V7mVuchddH88pS0Ek2KJZHyJ026W8iI5h/m7gTcXPKfD+JhfKfqhsg+2T5
	vo4JOWJN3enOjzyoz57UcgodPYzo3s5T3Wpvczp98pVamp1O3ZyU4eHFjTd89xCGgW1TOz/zC4C
	4cd+6HNZlFWMPNeErcjFMPyazdogpID49ez0czGOdBpyG5t0TcJSHr8Ne0Xs1fJwGsIy7D1PavK
	sLnrq1ezuv7CnIKUsL/Ay0uf+Nsnc27NugO9X0Q1rSLGUDOCu71r1+nfDZn5/x4peXJ43rK8KNL
	f2vkvwe5uMRrTUdikSrYiKfTf/oLnx4/KifjMJmfkIY=
X-Google-Smtp-Source: AGHT+IFE2iqVirz904ovcR70x7P4qhg9/LDhLdjk7U1HIgwqjlgumoEt4jW0fBUgkqML6erNY0PKTA==
X-Received: by 2002:a05:6808:bcb:b0:3f1:b1af:7206 with SMTP id 5614622812f47-3f33c347363mr1106763b6e.10.1738270232256;
        Thu, 30 Jan 2025 12:50:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f33368be99sm410742b6e.47.2025.01.30.12.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 12:50:31 -0800 (PST)
Message-ID: <f51208a1-927e-4069-bb92-d29d4bc74db5@gmail.com>
Date: Thu, 30 Jan 2025 12:50:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/133] 5.10.234-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130140142.491490528@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 xsDiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz80nRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+wncEExECADcCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgBYhBP5PoW9lJh2L2le8vWFXmRW1Y3YOBQJnYcNDAAoJEGFXmRW1Y3YOlJQA
 njc49daxP00wTmAArJ3loYUKh8o0AJ9536jLdrJe6uY4RHciEYcHkilv3M7DTQRIz7gSEBAA
 v+jT1uhH0PdWTVO3v6ClivdZDqGBhU433Tmrad0SgDYnR1DEk1HDeydpscMPNAEByo692Lti
 J18FV0qLTDEeFK5EF+46mm6l1eRvvPG49C5K94IuqplZFD4JzZCAXtIGqDOdt7o2Ci63mpdj
 kNxqCT0uoU0aElDNQYcCwiyFqnV/QHU+hTJQ14QidX3wPxd3950zeaE72dGlRdEr0G+3iIRl
 Rca5W1ktPnacrpa/YRnVOJM6KpmV/U/6/FgsHH14qZps92bfKNqWFjzKvVLW8vSBID8LpbWj
 9OjB2J4XWtY38xgeWSnKP1xGlzbzWAA7QA/dXUbTRjMER1jKLSBolsIRCerxXPW8NcXEfPKG
 AbPu6YGxUqZjBmADwOusHQyho/fnC4ZHdElxobfQCcmkQOQFgfOcjZqnF1y5M84dnISKUhGs
 EbMPAa0CGV3OUGgHATdncxjfVM6kAK7Vmk04zKxnrGITfmlaTBzQpibiEkDkYV+ZZI3oOeKK
 ZbemZ0MiLDgh9zHxveYWtE4FsMhbXcTnWP1GNs7+cBor2d1nktE7UH/wXBq3tsvOawKIRc4l
 js02kgSmSg2gRR8JxnCYutT545M/NoXp2vDprJ7ASLnLM+DdMBPoVXegGw2DfGXBTSA8re/q
 Bg9fnD36i89nX+qo186tuwQVG6JJWxlDmzcAAwUP/1eOWedUOH0Zf+v/qGOavhT20Swz5VBd
 pVepm4cppKaiM4tQI/9hVCjsiJho2ywJLgUI97jKsvgUkl8kCxt7IPKQw3vACcFw6Rtn0E8k
 80JupTp2jAs6LLwC5NhDjya8jJDgiOdvoZOu3EhQNB44E25AL+DLLHedsv+VWUdvGvi1vpiS
 GQ7qyGNeFCHudBvfcWMY7g9ZTXU2v2L+qhXxAKjXYxASjbjhFEDpUy53TrL8Tjj2tZkVJPAa
 pvQVLSx5Nxg2/G3w8HaLNf4dkDxIvniPjv25vGF+6hO7mdd20VgWPkuPnHfgso/HsymACaPQ
 ftIOGkVYXYXNwLVuOJb2aNYdoppfbcDC33sCpBld6Bt+QnBfZjne5+rw2nd7XnjaWHf+amIZ
 KKUKxpNqEQascr6Ui6yXqbMmiKX67eTTWh+8kwrRl3MZRn9o8xnXouh+MUD4w3FatkWuRiaI
 Z2/4sbjnNKVnIi/NKIbaUrKS5VqD4iKMIiibvw/2NG0HWrVDmXBmnZMsAmXP3YOYXAGDWHIX
 PAMAONnaesPEpSLJtciBmn1pTZ376m0QYJUk58RbiqlYIIs9s5PtcGv6D/gfepZuzeP9wMOr
 su5Vgh77ByHL+JcQlpBV5MLLlqsxCiupMVaUQ6BEDw4/jsv2SeX2LjG5HR65XoMKEOuC66nZ
 olVTwmAEGBECACACGwwWIQT+T6FvZSYdi9pXvL1hV5kVtWN2DgUCZ2HDiQAKCRBhV5kVtWN2
 DgrkAJ98QULsgU3kLLkYJZqcTKvwae2c5wCg0j7IN/S1pRioN0kme8oawROu72c=
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 05:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.234 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.234-rc1.gz
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
-- 
Florian
