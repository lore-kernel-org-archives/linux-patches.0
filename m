Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E931D6B0
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 17:46:14 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1bdf4752c3cso34120205ad.2
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 10:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695059173; x=1695663973; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2CcOTnEgUoTNMyg7Li7SLw44CUpQbtm5k7rtpHppxpI=;
        b=DqjizaC7GBMcvd34OwssGSL4q50ZGW3fk4qDLNCB8it/phn3luC1OdUj6HRYkxbg0c
         LJiSxraHGYvRIpOPDbsOWpWWWCOsRP5vl+PUTz8KabqqlOc/lnBMFjbWndAiVzrbl+5v
         U3ckCJJOe5MIbzsunjpCHIY5B78kk7q7MkzRsbgBwnOtkIB0TeCA6hONlFZrpUJCSoTi
         pB93rHmb0WAmcQ01b6+lNHw0wwVsVCQEi4/g3wPP7fFVfyzj/ncSloGupCs6s88rtN8a
         XPKJMkk2zpUNAZQfexKf0O/azUbOr3ZlLjWdIOSpCtczegpM0VYt/buWzbwTbaEzfvre
         pQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695059173; x=1695663973;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CcOTnEgUoTNMyg7Li7SLw44CUpQbtm5k7rtpHppxpI=;
        b=u/fGUiSBvVZ2I0wBTrVNlECkEwa5o/FkGSFyOYKCaLk/C9FgILIs95oA56CX6/6fF+
         +5PU2D2kEbQMMUBP4KtW27q4WHD38bNUQUT64MAlnwlFxu8iUEDUjHou46BFYqwrz/JD
         TkIeQS7jR2CVWBDG9C7UHNxduY+F0ooT3+nv1FUu9GaaYOOdMy2A8QyaruUd+wTy2uS+
         Hr22B3098GxndrgSwI8E6ZPZhf8w3Bvts34RNirMwfVkpjAofMwJ+9MZ6PCrauWhlYVs
         yDo2GSqYsPnAWDPPZ8gTCPoZSonjQdxUel6WMUra/vfuJgMlXHFWacY//Ftema1STM7H
         Mscw==
X-Gm-Message-State: AOJu0YzWE69IjTa793x+MEI5ogxZRScm+aI5pZR+ChX2jA1OzFEllKGv
	d7r5Q5MiiRhIrkKvhKG/5hw=
X-Google-Smtp-Source: AGHT+IGk3ewbfzHW2WRQS+m1g6CW4GIWtkM0uJSbYwzCwwNQpt4lq4j12/S2RFTJCVhrljnuLpVDZA==
X-Received: by 2002:a17:903:1107:b0:1c4:3294:74ca with SMTP id n7-20020a170903110700b001c4329474camr8553475plh.17.1695059173413;
        Mon, 18 Sep 2023 10:46:13 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b15-20020a170902d50f00b001bf846dd2d0sm8598504plg.13.2023.09.18.10.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 10:46:11 -0700 (PDT)
Message-ID: <8a57183d-49c0-066b-fcc0-d378aa80cbe1@gmail.com>
Date: Mon, 18 Sep 2023 10:46:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/406] 5.10.195-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230917191101.035638219@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/2023 12:07 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.195 release.
> There are 406 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.195-rc1.gz
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

