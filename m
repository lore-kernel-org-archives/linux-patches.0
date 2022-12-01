Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B1D1116
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 11:19:45 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id h11so2122757wrw.13
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 03:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i66hpYzpd8grtubkOrknYnz1Y3ETSD1rR4jLwv+APCs=;
        b=LA4RlQTjdUhRFiTwf3YIGXZnSxA8C3Mcp0aKJMHfsviDYCr0XNK5E/W5/LCdZcRdX5
         ggFBVCJVIb/7WYePpVsIQdWEIGK+0kzvCcyNd0HtFqNXaUQf+CMCNc7FE+gxpS0iLj2o
         Veet64rh3Pz/cPcG5oB7RXNKbIjtpB1xLc/D+7wErOFBqi3SVwOIdmd318/am3bmZZdX
         oWIa/HhmGGsahSgUTf3GEoi9TGuMbV2BsDg/xlxGezwhloIzSnZUPwhXpO1YcTqP4oC2
         pwFFdjeazAn1e+YviO2tji9L67xGJj0y9Fo2ndT4xvWYkyR8ahyQQi6wcxVkyVRlkt6X
         NVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i66hpYzpd8grtubkOrknYnz1Y3ETSD1rR4jLwv+APCs=;
        b=l1vrFY382z0uq5ApNueLE/60+q6Jt5/y8xQRnpMkTBRkDs/g7IwHevMgzCXCAVM32m
         sRcK04VQVKk8DxXVNVgdGaBs2g7HCv1zBwfA08Goq0eutvEXWLJOMrsbdGYFito/wRWr
         AKgrfQRQPYx9P+ABnn+w8iYfHJXbk6pOzUaq0bHfIW7pJit6QDg7fqfu1J/zWyra2uDn
         +XdhiBDIFhPx3xR09JDveEdppSLO4LbJBxwQCvUItw7NFXCq/Fo4aU0tTKiIkU3jHgPf
         8NVF/aMAwVGKflSiyHeOLLnCQZS6pV7QDrO+VzShsnN7K/SBxh4XAdmKSt6Ph6cmQc1e
         U3Ng==
X-Gm-Message-State: ANoB5pn519txEwQuZhwmbyu8bKZ2Bmr0l6RGo8CKg9u0sJmuLnm3wtxw
	6/aFS26qT/Wor94M1NebFitdmIiAff0=
X-Google-Smtp-Source: AA0mqf4dl/pPDOQM5xaL3GUWHByF0Celz1bpsSl1wzbvK2NKtXqgDRnYOZx19SL6fgVPWeE+o3NXWw==
X-Received: by 2002:adf:eb0c:0:b0:236:6deb:4498 with SMTP id s12-20020adfeb0c000000b002366deb4498mr41467708wrn.52.1669893583918;
        Thu, 01 Dec 2022 03:19:43 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id m21-20020a05600c4f5500b003b4fe03c881sm9687169wmq.48.2022.12.01.03.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:19:43 -0800 (PST)
Date: Thu, 1 Dec 2022 11:19:41 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <Y4iNzY5UmvkKBP1p@debian>
References: <20221130180528.466039523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>

Hi Greg,

On Wed, Nov 30, 2022 at 07:21:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.157 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2254


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
