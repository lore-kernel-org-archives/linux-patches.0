Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF3C4C7B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 11:31:45 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id k37so10505620wms.0
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 03:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677756704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YxUs9fQ/V1M0mvAOjqgHaLDvTdZPjpXWiCFQQKoRef8=;
        b=X9G8Um8lNvQnCQ2XEDiNS52KENiWE3MzXGpyyqtLwyNTINESdlkQvKstE2YVhJ5ymE
         4EpeWaeiKQf5uoLqgv5S+AKDN0AS9p5ieIZjoa6FBBFU1gZuu1++gjCYVU1b88YhIVCI
         I5I2CzILdhSd/FzG0bCNFtwag2fRLhyDiLF18w8HFxfReXQDwCcTNevpKPqy+7IfFECB
         snGtbDksKb/eNd8nAnC3m7znkzF1ncUW1LU03GciiDRFByObZtjsj1qcd3O9v2Lgp23I
         OCODtP1w2UKjytsnQrQ/Yvd1scDnQ3CwZQyiDuQ9JNZianpT+9XRuMZluN0GwUs4cvOo
         ej6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxUs9fQ/V1M0mvAOjqgHaLDvTdZPjpXWiCFQQKoRef8=;
        b=baX7e8i4xmMASEPIaWX9h9haZe3Z6Z9sVx/eS1YaapeOFTbaxOZTFy3TZWCULAuoti
         +ABIaoY0LHVuG8EcPu4fEtJe4ALYDq2ZQrcVOMiUddkg3lScs+tD5BZMF+vQXDBlXuLz
         G8JgCBGbZM+Xzn+a+fswWJ/K+TcU25BB66BQQ4Ia7EvrjqGFPtlFVC5CdsSmEjIgpinx
         f0ef6FB3ncoUAqu2L0KhNmLfX6Gzh0b2qeTn+67gOC0WbhMHOvbNksWvsUdiMg30p1rU
         WRXqFN244Hc71IJEkmAvhZEzL9athdCIpbF9wxgNbPL4yOK6DaiGGwq61o36+wC3EFoI
         YdVg==
X-Gm-Message-State: AO0yUKVAB35J576XNg4rZ3JBxqEZo8bNXAi58jF1eUEs3FkjSqptfK4b
	YCrsUYO0w8+MDI4eRtZDOjI=
X-Google-Smtp-Source: AK7set+39WtzZQ8rxQtBAPLpClVuwY6Ygm+lRAIOqb8ODnldgD+6kl5CDffdMQIPnyDfhBJvYMBlUw==
X-Received: by 2002:a05:600c:3093:b0:3e2:153e:6940 with SMTP id g19-20020a05600c309300b003e2153e6940mr7461131wmn.3.1677756703833;
        Thu, 02 Mar 2023 03:31:43 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id l8-20020a05600c4f0800b003b47b80cec3sm3171681wmq.42.2023.03.02.03.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:31:43 -0800 (PST)
Date: Thu, 2 Mar 2023 11:31:41 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 0/9] 4.19.275-rc1 review
Message-ID: <ZACJHW152iBecARu@debian>
References: <20230301180650.395562988@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>

Hi Greg,

On Wed, Mar 01, 2023 at 07:07:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2971


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
