Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF461FA0
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 12:41:43 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id l41-20020a05600c1d2900b003daf986faaeso4437702wms.3
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 04:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tUsS/S1vhjLGDULVUrqfQT/9OBGJ/diUFEtrNGhsMAY=;
        b=VXXSEFahBgXg/GbFajr+obxLmqF5XdExaJSdjYmFVZmL4NLZLn2FdG47irGA2jV+EU
         2EC9PKZ3hni7876cBe8idyBJSdi0kdNVceDPRnoRtQfBKEkaQF6w3MQ1N6oQ8EFrzMix
         B/3x1DNEysXU8Dva7BEpr8ZnxEmnZwV0w5L3wHVYC/g4MNxXBgEoPDdjDRqwkqJRAxp9
         oLWNBbj2Tx9jt3qkiLd5QtyagbBuBSc7d2LDl9eYZFuSgoY8KZQ9r03PJeC1kQiG4Jhq
         KtAmmU2Py7tB7HWZmUG8H9HW1tadOmlzfnbDzfr4c/3fB4acnTCrt29CRUlGFITIo7CC
         E4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUsS/S1vhjLGDULVUrqfQT/9OBGJ/diUFEtrNGhsMAY=;
        b=UZYHMDgQO5WYW4cmlaP+RiFHXtGUGIs15g8JJFNtVx+riMwwwIqv4EwYukBfLIzJWt
         pFmfc0rwwuqbFWCgwcTatg82rf4pEpwPZ+dVHFbz96fZ7lTZuLbgWGw8JkyA7gMeZYOB
         5b4T8UW0wa3g/gvTugkJrrCZ0pubpRRjeVnOcbi7cPjasoflLpnhdFvBMb+k6buH5t9C
         PwNhPE4ot5rTuAeptpuflNSNdBgVnL44zXgquuokZGf/EiPpEksGTjACU1p2fd3zDq5J
         Vzq9GCtNqCGCD8k3+7DFIt46Z2L7792uA+3BHtvyLRVeR2xk3sfEq8Angm4ybxtccz+X
         m3VA==
X-Gm-Message-State: AFqh2kqwdaLRFVIzyacOHkzZcYZBagFjf1OjmHgqGOtKDJKU58tTyMt/
	+1pwWBCFsWuywdt3XyeVFtk=
X-Google-Smtp-Source: AMrXdXsLgTmUCsSpvSljpNO6M5xKD2LgPxhFYTKrcmAoCAhM39qQe2va32K73GyRUVjhu3TXLOPBBg==
X-Received: by 2002:a05:600c:d3:b0:3da:23a4:627e with SMTP id u19-20020a05600c00d300b003da23a4627emr2895995wmm.6.1673959302119;
        Tue, 17 Jan 2023 04:41:42 -0800 (PST)
Received: from debian ([67.208.52.125])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c350800b003d990372dd5sm46346344wmq.20.2023.01.17.04.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:41:41 -0800 (PST)
Date: Tue, 17 Jan 2023 12:41:39 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
Message-ID: <Y8aXgxQHjmdUzC1F@debian>
References: <20230116154747.036911298@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>

Hi Greg,

On Mon, Jan 16, 2023 at 04:50:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2662
[2]. https://openqa.qa.codethink.co.uk/tests/2666

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
