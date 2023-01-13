Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C8640
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 12:33:57 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id q10so1608811wrs.2
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 04:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X38tpZ+1CXOR8qiFEphyCxAvJQdynmpy7DlHdAXUfhU=;
        b=S+LESxdEcTgwaXx6q7qU315zb26Q9b2DxAX9z4EOQ2YQVADUQlXXtOS/cT0MIkC4FR
         T/QWpes0Dw9nuoVyMu+AfcLm5Kl2WT2rX+VbQbJrIafJBEH1pELr1dicyt+MQicsFDSP
         WE0oZnHS65aAafTUAKuuVEc0bPZBWPAsZ4KOsjp+9jxh6fpCjuw/z69XaLS6KMPHx87H
         7pUhgMkyjDlp16i6XEKDkY8onbDjKSyz5IsrfvcBN2ZSaCgrfb6tgncRqPBOHEho2dai
         sgeCeBhJ4ItIH+5wC6sVvqNaTrSKFu63J0zQuZGhq4yjIAZDG0Tjg8oKqUZ/QpmnzJVv
         BjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X38tpZ+1CXOR8qiFEphyCxAvJQdynmpy7DlHdAXUfhU=;
        b=H9eWBJFPNx5hBXAB1zL3Io8c7cBBIJY+/TqcH06C3VBIkGV7HOOeqJ8JyF5E3kjb1d
         V5JnkTVXakaNLM3WFKyKRdlvI1BIovZdygNHJAacM5yPNNHWF+AU/C2rGt+G+I10Q3dO
         Njo/gxD5TNmWLv0r0rXDvk7nSV1cnO23R3+6tbi022ME/6YpIY1/ZegBMWYn8xg9Ah1M
         1TtraqLvM4MQZq+7rUh+NV24OsPILMZtCDnw01kdmVqDZQpUE0wyN2nBRB7FuYjITBLS
         5i5+gZdbLmdmSnzar/x4MhVkiInfHfre3gH7p/f4ONOu9Ekvc7v05sN2368sW47Pv/P9
         QNgw==
X-Gm-Message-State: AFqh2krzJgsS2crbBqquTbcBN4b2KA/oafXdyjUtM2DwPoys2MZ+TbV6
	O8sIgFSipIN/HCd5vGOttXE=
X-Google-Smtp-Source: AMrXdXubpLWkRf+lswxGs0k3JkM9S73EMzF7ncZhP8lepyen0bywxN7MJAdwcHMMcA3viZsH2X3eIQ==
X-Received: by 2002:a5d:6d0f:0:b0:28b:456c:1b6d with SMTP id e15-20020a5d6d0f000000b0028b456c1b6dmr53397805wrq.55.1673613236084;
        Fri, 13 Jan 2023 04:33:56 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id k5-20020adfd845000000b002bdd96d88b4sm3345963wrl.75.2023.01.13.04.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:33:55 -0800 (PST)
Date: Fri, 13 Jan 2023 12:33:53 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
Message-ID: <Y8FPsXOMYDbKT9fF@debian>
References: <20230112135524.143670746@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>

Hi Greg,

On Thu, Jan 12, 2023 at 02:45:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2628
[2]. https://openqa.qa.codethink.co.uk/tests/2633


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
