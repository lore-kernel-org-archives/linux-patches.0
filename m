Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FBA52F65
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 18:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6fYqppK"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1cf98ffc257so12472655ad.3
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 10:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701370636; x=1701975436; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Exv52TPUf3AOaA6t7+19yZpTBHz2Mm8ZmomI4RQTAVQ=;
        b=O6fYqppK8NxUyZ7mOgY4qYEAl6CVddDxTwxW9+P4WLeevGwIOGSPLSISamvS05CD5p
         uNLdmtdnMAFuKNBdbzdhmLaTZIR18Ao/4PmJgKWeN0CN29OAzBpIhUe4QPmo1PaBtiGr
         pXnWfu/tMZIt753C2SDq8aq/fyl1+Bs1kzLw1AdcVslrwghg3+2slEMcvCMryN+vZ0IF
         IpZGUr4mNborzbzEKncIrfMk+7esDG3GMPPo06r2YBc4s4BO3g9grhbgFZKmI5lFEnDW
         mAAFlyILV5b/3pKn6BGolyMMld9W3CQKsEveNn9m15OOyHCsbG4tL6qbdzMce+vNykvP
         UclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701370636; x=1701975436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Exv52TPUf3AOaA6t7+19yZpTBHz2Mm8ZmomI4RQTAVQ=;
        b=uXuMxp5adSeVEeGfFgZGkpx2l7gjSP3KOc6MLSnIaACHN3zmktolQbRUDNEYut81XX
         iVgd/dqg/GmXD270/OV/BuaRP7M4f8qLEKy8raAhMW8xJ3/kYs7e0/cecJXaU3Z6Erhn
         18JUHhe6cOTS1ok34r9DKKrY3ty/zJUiT6uzSgICBrGcuGTgrLyLcTEksVrscDwk7Jyu
         7vwMWTfqZIg4KMU20lxC5gP1SbnyZ0md2Eq/1GeWxy2q+JkL9HMqhoXbRa/qNMSmT+6C
         /m3liSpdefRI8N5vp0r+kpF57qD1PP9iyCnzDOWHpoUuiXX5kYGT1MacF5HID4tNZsjg
         vK1g==
X-Gm-Message-State: AOJu0YxREe5wgCLV66gLPGfcMpBukQn18KcALqKKi+H2zIr+3iGbobub
	7Giy0bKe7e0WBTOkOB8dlAo=
X-Google-Smtp-Source: AGHT+IH3DiDL+xLbUZQ8OmJ6Q3v/3rNl8ObJgH8sk5z8qRThL6ymywtmzmNIIwFczx569F+2B1xuqw==
X-Received: by 2002:a17:902:e88f:b0:1cf:cf40:3cef with SMTP id w15-20020a170902e88f00b001cfcf403cefmr14406808plg.64.1701370636097;
        Thu, 30 Nov 2023 10:57:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id je20-20020a170903265400b001c739768214sm1748127plb.92.2023.11.30.10.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 10:57:15 -0800 (PST)
Message-ID: <c9c5517e-5df5-4755-b47f-3582d0b19d8f@gmail.com>
Date: Thu, 30 Nov 2023 10:57:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/69] 5.15.141-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231130162133.035359406@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/23 08:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.141 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.141-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

