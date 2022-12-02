Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7041FA9
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 10:18:09 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id j5-20020a05600c410500b003cfa9c0ea76so3871579wmi.3
        for <patches@lists.linux.dev>; Fri, 02 Dec 2022 02:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TWifImDgU7rHybo8rHu3koXB7xojTPgIH7LvV9QbOUE=;
        b=a9SSakxT3CPnWDAc/fAmnACSKYR07SGM0Xx+z4D4+CznUE2v01eUhlTuKTvgEfV5HH
         ddXwNgHUB/APv0c+HTnhQYZcB+O3GBq1WiUyfBnzj/+5hXSa9LK5iI3FAyyVz8zGbMB/
         z1TmPzyeCY9muLjATJkTVZ/GWQGVsS6gW8GS44uBo71nclfXW4TzJqjb30+4qNx7taBP
         Up0AWlIT7ENFmpJMjA3NstTymOaGulfNY4gywP2jFz5YDx/CaIgwMI5FWEN7ZUHPj9PB
         DVAOSed14WLZ6DruDcA7ZIfv5TCGJTYwdWOwHEsUGNzPTRLzhf481wtmz47X1C0NP5MO
         2lQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWifImDgU7rHybo8rHu3koXB7xojTPgIH7LvV9QbOUE=;
        b=uDgUyT2+0c2f8XzAYS4ymzWv/g1sWVYeedah55j4tdfTXYsI83yNQYkMbwTpMOBWPe
         M4NCtg5qB8ltZ0xApQ9934GLxJYTwLGESBn4vOcetx61oaWLZ/aWJgAIbXrlBvxn9SeL
         8P8+Q8st7bFZ+dyLEW3zmMQXDRYOfWz40vlyn1ry8a5I3s1zeunmnPOHHTLdrqTKyZ7g
         9vH/JPY6sgVxgEJCFBROAjZwe7uKa8ENwrDZ8AGqoWBOSM1IaQPG5dWEzZ9T0OPApdEW
         rp/iR9BPM2011u/O9lqizqMYM2pE8IxE5iYDzmQst1nBJx/npEz0ASx5g5UwAhPalg5U
         epUQ==
X-Gm-Message-State: ANoB5pntv09sTTgDIevzf37oV3QFJUyzgjb5QmtJzYqhkT6v01FeXlla
	jpepyjstVE9ci9MpAN3kWJs=
X-Google-Smtp-Source: AA0mqf7VLLsEPMXxHahA+d8woSWlMcxL1IgEpAx0Dwakte6+dL8FX3JxCY9ChD8h0xMV7ramnFgajA==
X-Received: by 2002:a05:600c:3d16:b0:3c6:de4a:d768 with SMTP id bh22-20020a05600c3d1600b003c6de4ad768mr38070878wmb.61.1669976287300;
        Fri, 02 Dec 2022 02:18:07 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id n3-20020a05600c3b8300b003cfbbd54178sm13831873wms.2.2022.12.02.02.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:18:07 -0800 (PST)
Date: Fri, 2 Dec 2022 10:18:05 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
Message-ID: <Y4nQ3ZqWHD2U8iP6@debian>
References: <20221201131113.897261583@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>

Hi Greg,

On Thu, Dec 01, 2022 at 02:11:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Dec 2022 13:10:41 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2263
[2]. https://openqa.qa.codethink.co.uk/tests/2264

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
