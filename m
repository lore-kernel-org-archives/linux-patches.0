Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19832538D
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:26:09 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id r4so4453488ilt.8
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 07:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678890368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Bb6BqyZSkkDx4xoda/AlCz3K7+pWLz5fsJlOVsRCSK4=;
        b=iaxVKbT2pXx7PjPzTxBTkY8MW92024Hz4QkYyrHPY2Bxiw8SsxjdF/B9I6fXBEtJ+V
         NfrhW16kDczpBhZneos4/kyiGVNHEcvUrM9wIabSG/eW9onX7o0bKzJZw8j+HodqRHzm
         yXjCzpiG5GqaBgjrzdu1QTDfS5e3UXrRXfeVfwSSUpyREeeL9QYQv6uREdzCqCIGopov
         WqftZ4LUBpRRiju8MmLBOFZuMcM+IlMeiWn45lDZJOKfrWs8pZSxVvtpCtmVy0rDRXp6
         Tv0pa/wZM7xGXU+vJNU6SMf+cKJy7xbovVVrrglcvoX3ICF76BdgBO3T6vJ/OBFnegMo
         c5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bb6BqyZSkkDx4xoda/AlCz3K7+pWLz5fsJlOVsRCSK4=;
        b=jfcPw2de9yBIYTirkiLvnfzLYLSjdxlwKx+GfYqOPZvRrMS9cMmiziR/bPVgGnNj21
         QY5OI9kMBrViR2YRdxOpAJEmm28tt1jhfufgXU111iNUZdh2wnnAJpVPS4OI7aBGoWCY
         JGQ5WvZ2/8jYOuEyLc5rSw6PrtDbEIOcdR2sQf2nCEBqgpg2i9YclETdulWpsgvzus1v
         rYd6Zy4lfNEIhQhaAeDh21zQZdhVLeAyaKPwXXH15+QF3Na02Rb6PmvJcFi6oTsKLJQ5
         KqB8apJx4AWIfWoyixSgoXtP5nG/LHwo1T9REMYPr9qNKcXctbtoPhizpEhWU0+BZAq5
         7lrQ==
X-Gm-Message-State: AO0yUKU36Dgzni3BWJRYYVvHJiPkUQ2S1DDLYrZKZ/dpFZ7fR94eLF7I
	IDYByE+d9gKr650ZYYbXoV4=
X-Google-Smtp-Source: AK7set8C1jd4zWOBmgHem4sZfx6LWTQakUR6pnDF2vFmpvHZu+QCkV+nayXhi1TTSmLykuKYfxTbgg==
X-Received: by 2002:a05:6e02:c63:b0:315:69ef:345d with SMTP id f3-20020a056e020c6300b0031569ef345dmr3310631ilj.16.1678890368132;
        Wed, 15 Mar 2023 07:26:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m17-20020a056638225100b00404d129c1ecsm747391jas.138.2023.03.15.07.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:26:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4584471d-d216-3edd-058c-e362e048462f@roeck-us.net>
Date: Wed, 15 Mar 2023 07:26:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115731.942692602@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 

Another build failure, almost drowning in the noise.

Building riscv32:allmodconfig ... failed
--------------
Error log:
drivers/pci/pci-driver.c: In function 'pci_pm_runtime_resume':
drivers/pci/pci-driver.c:1297:9: error: implicit declaration of function 'pci_restore_standard_config' [-Werror=implicit-function-declaration]
  1297 |         pci_restore_standard_config(pci_dev);
       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
At top level:
drivers/pci/pci-driver.c:536:13: warning: 'pci_pm_default_resume_early' defined but not used [-Wunused-function]
   536 | static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Guenter

