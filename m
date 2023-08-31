Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9541170A
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 18:56:53 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-68a440a8a20so937216b3a.3
        for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693508212; x=1694113012; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HtK2p2poP/3rtfd8yJfH0otw1ECIcsU4I9M4hwYRP3g=;
        b=lq49X9dGUfislhfkkMWJEpYcddcCr/KEEW7GY850FfgCf7NEPtcRGaPqiYw1an9djX
         6VsjpTqhMByNJ5H/LmUYwROpRvg8oe5j6d3q8C51jolQ09+H5mdp1eiCKahcxKXqzl3v
         a/Wfp6N4omVaE55/rLhqN3sL3PYz3vX/9yYQ7MRAo9aJ2rUCuN+9xKxgKtgHlNtfCdvD
         04TzBmxWEqCpevvkXYW3/qSm4Jca7Uec2alQGqP1JylZ30w4i2/KBeYSzTymaZF46IlM
         TZ+r2W5w+4lLDaaUR142nj8PBJld1D/Ra2EhYTyYnmbhmGbuEfYz0SfVbhBnvZ5ZGzP1
         olVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693508212; x=1694113012;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtK2p2poP/3rtfd8yJfH0otw1ECIcsU4I9M4hwYRP3g=;
        b=XwAHulFaqSPTfJL7/26Sr113vhM5hZByGWJNUe70oKVXZD966uVMFpaKM8ahXSS3nm
         82YhBV41UIWuHRcKPPVeIYbbutd1dJA5+jqAj+aBSHkKYjZs7zd1QPQj7cmx8y1/7WOF
         UFlVB1GByL6PbgWAKwLvumVIu6GCAPWH4OfafpXe9spLAgh5aX40VitZcRljPkzuoh+O
         PsLUTM1XxpIDNMRAfYOKOjFODLgdUWBM1f0pXH+9jfGEmYuFphIJY1A3+rsHGRLFKeNU
         cqNm65CEI0g2O14rxl31n5oI8rLbz0eaaigzCHMPhf9E8w7NdmgiKRZJaNdliUdWn5BN
         sNbA==
X-Gm-Message-State: AOJu0YwpnEEDfwm5wVYURUYZ0Fh8469cJFXbzAowMSU+moLqyJThNr2S
	x5Q51lzogz+yNeQfZzUFMA8=
X-Google-Smtp-Source: AGHT+IGFcgQpNTKl2oph6jmBDsPwKQ21j69FZ9RnP6pkDf4aXnGhmqrpK+TH7ImnKJO0a8EEu3R0zQ==
X-Received: by 2002:a05:6a00:1acf:b0:68a:5877:bfb1 with SMTP id f15-20020a056a001acf00b0068a5877bfb1mr600756pfv.20.1693508212326;
        Thu, 31 Aug 2023 11:56:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s5-20020a62e705000000b0068bc014f352sm1627201pfh.7.2023.08.31.11.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 11:56:51 -0700 (PDT)
Message-ID: <87933236-1f5c-c03f-650a-9511e1df879a@gmail.com>
Date: Thu, 31 Aug 2023 11:56:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 0/3] 5.4.256-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230831110828.874071888@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230831110828.874071888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 04:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.256 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.256-rc1.gz
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

