Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A40B641
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 12:25:05 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3ab3aceaf2aso558115b6e.2
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 05:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695299104; x=1695903904; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=MrqMyDfh/NoVjPJH/IspBXCIftHgNrpO3X4YYK4Vmmk=;
        b=QWcgP3Q1Q+O+86skPbW2lKEiMnhpBsOOLAmT4nqy2OtQiGc7Mum2TTKAAe8r4LFsrq
         nxAk7Nn5nEiWEg1Len97oGxR9+rVn3RVk/chIN7fi5ir2za/SjoArLTfyNR2PibsW4k2
         C7f14UL3reatLwOcqoiGz6qyCG947mLY8W7xaeTQh0YgBsEgwwyp1++ifVyok3UwoTXF
         h84t9Wg8YFG6xmntqPpWJ2VdJ9YkmrMLh+/AFX/O9BLJ2CZPsUWqefH/R+sR59FChLi/
         XKKMMe2OGSqE1ueAd1U/SHv6y1w6lTg83rwNrPkGoxP+S+szLPUag2TeSP4hIrv+Vf+D
         unfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695299104; x=1695903904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MrqMyDfh/NoVjPJH/IspBXCIftHgNrpO3X4YYK4Vmmk=;
        b=FRGGrBdWB5Chd+LEIYUiUgsg4zFA1Q/T2THEMvDSYEfqhwDBDbBUwfCmHXQ2Ngp8wt
         Xlq25tUStBs/6gDJ4m/xf7hWTGTq9gBGIuYuSlO1gEc4ZQyGgaU+A7oaKfResjCKq84e
         bddjTHu1bhlablJdsC+FsEnqXU7DUOixhFmyDH91FDbEWU2qveg1TGs3QY9PQU2l9iZz
         D3kbBKe0/CaqXc6l7MO0fhnHMqkqfwEqmn4p6rSOmNVmWGMciVRaK2qysQyK30hCSQBb
         dXAn7QREXtn4OEU1OoVpwyRxK4VwrQwmWlI+hdI0kJOJxW60ZlXWBrNktMVslWsTY0s3
         0lgA==
X-Gm-Message-State: AOJu0Yy5myBWMNCRwMYUpFUk/UbXsjyuxJBOoRhwwoTZB3uV/YSph4M2
	2NxPq6H6U8LaQ7M0NMk/ejk=
X-Google-Smtp-Source: AGHT+IF7ZbUBjXhr1E3hDBZvekqd4EWOu7Rd4Hf7dK3IXPmdnMtSy8mWpGFOdQHr4eOR6s3YPupd8g==
X-Received: by 2002:a05:6808:df4:b0:3a8:4903:5688 with SMTP id g52-20020a0568080df400b003a849035688mr4759045oic.34.1695299104626;
        Thu, 21 Sep 2023 05:25:04 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i14-20020aa787ce000000b006870ed427b2sm1271538pfo.94.2023.09.21.05.25.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 05:25:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <0309d2fe-a9c9-f963-b096-ba11fa74a081@roeck-us.net>
Date: Thu, 21 Sep 2023 05:25:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.15 000/110] 5.15.133-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230920112830.377666128@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 04:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.133 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Building powerpc:ppc32_allmodconfig ... failed
--------------
Error log:
drivers/usb/gadget/udc/fsl_qe_udc.c: In function 'ch9getstatus':
drivers/usb/gadget/udc/fsl_qe_udc.c:1961:17: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
  1961 |                 struct qe_ep *target_ep = &udc->eps[pipe];
       |                 ^~~~~~

This problem also affects v6.1.

Guenter

