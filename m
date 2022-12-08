Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F4B7F3
	for <patches@lists.linux.dev>; Thu,  8 Dec 2022 09:42:55 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id h10so944911wrx.3
        for <patches@lists.linux.dev>; Thu, 08 Dec 2022 01:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ssjl6nNbYIcMMvWXmfrSrcrvUMoKlpyQqbaApupR4d0=;
        b=okzDRwtvM7IxGFEPge95DAbqjdbg27DWzn3nf71+0EVULGdDD8pryn/Okzv8o7UiIt
         qK5SyIwrjS31tUf1olehlOnRJDLgG6qSZeEeVe0tzeCw+J1SrFmhEUIPoMSy5V/pKRyX
         ez4uwOQNWOLOn2lR3yZYgv+0teCr5zeABSvkO705CQxIHKewtHAeFpEM6Ya8an4TaxyR
         p/EbPPs7WfpsI2PzYVRiu++teTkQLPUo1j3uSPJMF9C1qSYqF58bJX2qqSUcq6limjm2
         nNL9ZIzWKcbfuP8fnbUxfrVekeY8fSuUFSEmExPF+jWFRsIHC+1aOatyUMBu5c96ulp/
         hxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ssjl6nNbYIcMMvWXmfrSrcrvUMoKlpyQqbaApupR4d0=;
        b=XKujkQKhTUfL6B1Ykfq/x2626SxFZpj1I+kdCWOkFCXTk830wCPQPHjojGWJwjCcLH
         6xnWQx6YTjPG7MZ2PTLC9UK9FdVJ4JsZim4QoSGrpw25bfBtmam3uLr0t161T2eDDZ6b
         JkVNwsbRzPKTPqm9cXp5YOv3bPQ4eqLA9HJzC/AYziGiXIPqnhKk2uaZqQwIohkwWPnC
         zTwW5K8TM0owZ+FpVldXKm7CT/MoraCu/ZOvje2v5rUaaT/GCwW/doRIen3ZZHtVThxW
         WMIGeNfaZfY8gMBExRQp/Nc3atUsROeIx9gFyQSvVlpwAIakX9HCIc1JT0gLftj52Em3
         U+LA==
X-Gm-Message-State: ANoB5pkzAywPOAzt3UjdZh92/qmGCw//oEZW9EuoHlwHS1aZAIGOF787
	c+owJ8sOmov5i5HIskdm0wQ=
X-Google-Smtp-Source: AA0mqf6B+DLCqcsYtcnrYTBrUMfA1faDYe6r9sZqr1+4KOT+ygAkmvcEGWWMs8y/QsIZOXH4CpOKZA==
X-Received: by 2002:a05:6000:1004:b0:242:9e3:72b8 with SMTP id a4-20020a056000100400b0024209e372b8mr1156829wrx.31.1670492574076;
        Thu, 08 Dec 2022 01:42:54 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id bq8-20020a5d5a08000000b002302dc43d77sm11753479wrb.115.2022.12.08.01.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:42:53 -0800 (PST)
Date: Thu, 8 Dec 2022 09:42:51 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
Message-ID: <Y5Gxm5M607FW7+ug@debian>
References: <20221206124054.310184563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>

Hi Greg,

On Tue, Dec 06, 2022 at 01:42:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2312


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
