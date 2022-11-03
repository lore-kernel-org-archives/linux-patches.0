Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEE36FAE
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 12:17:47 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id bs21so2498262wrb.4
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 05:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WdkIuvjlP1dhOTYraDqnPb0//zs6VzB71u/zOGD5n9Y=;
        b=opRHxLtj1y1lqRuQOQjiwtOjTo3eUOpN/LjEJnVIUe38vkiaKzx0h+i85y9PRIEWqa
         OceIU8GDV8nJIMezFJ0EwoLMdet8qobRfpJlU7LR9hJvrFuK8XxOfPVmIksczwhGtBTZ
         TJPMQli+KMVd3jOu/DdVbVGd6lCzoy4XsFh/6GV71IrEgr//xR/kD0TXa/dIAmnj78mF
         aMNtAhHuLmqKiAxFIir0uoSCj5drX7hYKX1v+ZdrvH1JcPnOtQK30ZhWpVGySuzOQ1/8
         tIXP+5PeZ9c8ts/EeF+bUoAZyDSVegoxdv52hhLxGzNtF/cmGZaNf9muGUKOPYq2LujT
         BmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdkIuvjlP1dhOTYraDqnPb0//zs6VzB71u/zOGD5n9Y=;
        b=PXxvujkr22V/DJZhIF4f1A0PfUCHDTjxYgGyeaEaF5oEP92gtBpraixRoJwTqWweJN
         YnWFFy2ErQwPD6Ujj/4FEshbhyF+hQLFgvxVRzaQeCGM43jYifTwqbr1gNQMGdWLGsRy
         JCvUmMdOwOCtvvk9q2Uak/5KIPnWbpQ537VcqlsBAN+UT2HwTXwUiR4bq+bgDzhuRDfg
         RhL47pEZ5TAZRX7whz15BNh5C5Sy0+AI+idEFnUcfDGhI+rrTENM/8jH5Y9nOXwBwG9+
         qxz+qDB1dCAqxMhaTYxLhRs4X8haLOaPm1Q1sAe1WemMzLqTQj+caL5Hu5d7JaXjkoyw
         Syzw==
X-Gm-Message-State: ACrzQf0OGakp7173AlUKMElHC0dLKsux/AR9zYUxONrPltPZyN8uW3eN
	KLrhAr7QqQ6uikQXK7sV8TY=
X-Google-Smtp-Source: AMsMyM45IdI/GW7mL260kptwwJsBWTRJKxir0xVshJKMALJZG3UBPzRYP1XB6DISbWnmCOdDGnzn7Q==
X-Received: by 2002:a5d:6e8e:0:b0:220:5fa1:d508 with SMTP id k14-20020a5d6e8e000000b002205fa1d508mr19373229wrz.337.1667477866140;
        Thu, 03 Nov 2022 05:17:46 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id a13-20020a05600c348d00b003a6125562e1sm1067384wmq.46.2022.11.03.05.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:17:45 -0700 (PDT)
Date: Thu, 3 Nov 2022 12:17:43 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Message-ID: <Y2OxZ58XaYcfOhcG@debian>
References: <20221102022111.398283374@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>

Hi Greg,

On Wed, Nov 02, 2022 at 03:29:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2090
[2]. https://openqa.qa.codethink.co.uk/tests/2096

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
