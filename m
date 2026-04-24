Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC3E36895D
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 19:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777058672; cv=none; b=m8SII61VJSALAjjesdeUAeQvlP6IlKlq7xoaHgF47iM7r1g0cWRHyOtgFixDtLTC8LRLtNei3Zy8z5pxr2m9ctoRKJHKpa0r3aIAiskyhHILIhqdK68hajvZj0c3kKawiFTBD9uOVrQ8n0OZqiyAX7Xs19H/IJbX+7Ui34vdGQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777058672; c=relaxed/simple;
	bh=8vADkQE1+kvpmQPAkB6KDeoJ+/zOXaTQ8Gf+2tvNUWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IXksLk0CMZz2vNM6WPmx+cLGFxTyA0t1F8U4NbwAzI7Xv33CoVDF2YK60JcFZ7w+0SwcTEc/JpUvS1qxIgB7zFTdSQ7HOKoozclqgASXvbNFQVrl485xJfbDAPS2/GV1faCBBInGYqMXFYYGNL+/vsUUDzAng6lAMkQtdHkv7MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHoZo+Xz; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHoZo+Xz"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2ba895adfeaso9067420eec.0
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 12:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777058670; x=1777663470; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CqBKFLkfnS5UJck4WAoyvk2PosDlu3H91T8tM7aG8cM=;
        b=RHoZo+XzAYz3WZ5Jxfq4ezGuCETVVGnVHtFE2vyjzpfAoNgnDfC84/v8S5wREVp7DP
         nDf+218W+liCXoI6/SNH6vC7AZsyZTSTnwO2t3/lFCRFGF+0GGSrBL0hqFA/YWWBQ0XL
         XH0zBloY0yXk386wagN0Z996oNaYqLmymedQtDxsxCvN8oNkFKST9/tE0IuEMQuqamtn
         sygKMTTnXgoNckx4skW9gct59Ukq+FgqjghN7CQUEAEO+oVfpJtCLh0fSjGGRp5sKTZ9
         rNRtHWnbUPgzt9CLuQ5id057mCUNfRLVyFsRNvYAPOYC4RRv2kw+6ksRDNqW6ml91uZd
         NY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058670; x=1777663470;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CqBKFLkfnS5UJck4WAoyvk2PosDlu3H91T8tM7aG8cM=;
        b=R1j8g/87sEtdzE0+2/x7rGXipkfnPVPDRuYtaZXWQSWLZWjmSpUb4me6iwxEOy63Iv
         UiI5uXiiqWzLvXN1+jyr1ZKC6t8AkHw7mSb7sEBT/i2A69tYINm4DIZ1WtE2qm5tZ/Of
         1evAnSMGykcQEwlWmnfzJ9KAPAwduR/cGqOduPnq6HxI4mHhQ2TB/hjc6TKYYTOQei/j
         VYfYXskFqmO2cU1judPifIsbsTbTH61d7MRP5q0rgJgyd2M3Vdty8J/tQakA5QodxjLq
         688N/uWpcDW+HZkzISgL28KpwWDJQ0vtDP3umHDKZUd2tHUj0sfIdxYsLAdYFU6wRsC4
         mu6g==
X-Gm-Message-State: AOJu0YziZDB+4WvG94P8LwpGYbvjfFNsU5Vrz7u7yib1OxbDU0zMglFQ
	rGtdP4B9XYe1snXU09nS3aKkIB556Mi1mXIaR3nRaYx/A2d7DS2+BF3R
X-Gm-Gg: AeBDievZKN8yeS1fB/GeTMYbnpcKcGuVj7KBr0vcVUlvpYb95n9TkIENEaK86uTkUit
	TNcDll9HKpYIxsAZxsYmAiWUERXdDeNIYSQiMQF0qmMOmb7gsopKFQGXtm7V7kHbxQPV1kMiaAb
	VIGiDZ5AKwaQh3pzs7cmCrYIy6g5HzkPJVvYQTWOvFEotFPSFPdWvX4HxYxoCJm5yAGuJe7gOSi
	tZVKxOgdtjCi/m6eJqDqi6c327Df8o/lIP29griSTRCHq4E/Fgmrqe0QhIV74LOWG0emAopihHu
	JMy2CQ1LT8Q7eBRh9MiMkhrBAZVhMItVrT5peN/BtIS5vPS1vpmnZ6Y3JEmDaReAfEuCNgajFeQ
	3XjIK1SSXC5QAzy3NAeFst8NGeIgsYwHRa8+IJZ3kNX+zl9i81a205c9UygfIFXxe4B3CnjeiUA
	OdadO6YVFs+n9mMBTp8+NrL4Q337Z7+FTB/SP/tePSnDSkpkclp9Y+aiSvr5Yi
X-Received: by 2002:a05:7300:51d1:b0:2ea:ed29:5a73 with SMTP id 5a478bee46e88-2eaed295db0mr56056eec.19.1777058670315;
        Fri, 24 Apr 2026 12:24:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53d9b056fsm43560585eec.29.2026.04.24.12.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 12:24:29 -0700 (PDT)
Message-ID: <ba5f6e92-286e-4789-8270-040e55e6a24b@gmail.com>
Date: Fri, 24 Apr 2026 12:24:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260424132532.812258529@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 06:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.136 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
