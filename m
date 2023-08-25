Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1D02CA9
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 15:37:39 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-68a6f6a66e1so881262b3a.2
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 08:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692977858; x=1693582658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e+saBHYK+xhBpnjSnJ33QCnhXDW63MFo57oZwPs45eo=;
        b=SFewzDuqul+WkUO3DOSumcOuLxkTx9ljg/4eRbxd8u26cqvLb5PzxpYIh7umhQ40MY
         1HVAjUgCGGbPOtBOS3qOBiOqns8klVbhWTGyeD+YGb8VWdFmHd/LC70gUlX95YpsOEqF
         A5MMDbgcVvCZNCHF8xvNhGfI0Cat3NMtvOQG9IXr1+qqEuJIQNEmJvXmUIBHEJym1aR7
         /dgzOLhNzjFgmG84z+d2e16siDCyRIO5PFu+AGyGtu54dtfU40MVz8LH32HYV/0CxQ5j
         EqSt3ZbApBLXNpNUjed6oB21DVHHvtV4Q3BbYRIlTTk5U9bbPXqKNsvJxxLawW3P5nqk
         7bcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692977858; x=1693582658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+saBHYK+xhBpnjSnJ33QCnhXDW63MFo57oZwPs45eo=;
        b=JtRNAQ6FhhcNR3UWZTzSmtLIEIxXgGWL2vMK1ju8CPf4Z4nVWRsKr7BsyBRekJOG7z
         zrT22PkgQPfIrBiWM4JgAo3y/3pXAMlE01RYa/lxaa117um5wl4jAgCfA/6u342U2NJl
         tAIoAO6h7BH+dTdFfx9FiSkXb6nZ5ARWa5snkpU3mMkdMAoLsbeJe0/HpYzYDPFY52Lh
         pSHUfjsxwQ+78RfToImeQweuiWiEaQQ29HVq7EwcvAbiUb/E742wXXyVSHOZIfbCwq3T
         qE3nqsu9blAdznfMERyS3mnzleBG0CSKxZVOxA7iYC/hNEnuQyz4PGRDbrMW6h2SN2XA
         kGfA==
X-Gm-Message-State: AOJu0YxR8BRZVnQTp1xh9piPmvza2cvkCk3J+zjophsWwsLKJWvetT7c
	Poa7guyZNYZhQ//s/M1OP+Y=
X-Google-Smtp-Source: AGHT+IHIcpWzIAbpWHjgF/1AlkdUYfEc+qeKCCfqVXekZK/bA3hhdjFFMu4sjsYr4aB45ClFqBsoRQ==
X-Received: by 2002:a05:6a20:3246:b0:14c:1db8:5c5 with SMTP id hm6-20020a056a20324600b0014c1db805c5mr3314671pzc.27.1692977858565;
        Fri, 25 Aug 2023 08:37:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ff0f00b001b801044466sm1856594plj.114.2023.08.25.08.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 08:37:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 25 Aug 2023 08:37:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.192-rc1 review
Message-ID: <cb6af915-a92d-428d-89a6-44406660c312@roeck-us.net>
References: <20230824170617.074557800@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>

On Thu, Aug 24, 2023 at 07:07:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.192 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 17:05:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 487 pass: 469 fail: 18
Failed tests:
	<all riscv32>

As already reported, all riscv32 boot tests fail. The failure
is no longer seen after reverting the riscv specific patches.

Guenter
