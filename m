Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BEC23D4
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 10:50:43 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id z4so1909158wrr.3
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dLlm8KqzipM9Q047KqhTM7vH+Kqb0gcpAOfLuCPwI4Y=;
        b=JIoxB3XVeJXPld6rLAP2jzXSrMu7w0RwNHILgmVKn8GXP3KVQirTMGrc2RU+43iB/C
         GO8Pgah9n6E3WW4vNcSB0/43bCw/k3jKwJX3SZ3GbbTVsdsXv4fHKQ9NWJKDNKgD4Sma
         ksHrRbTBFCMa8NDWPgLAYbWifsEH+FomzNsosXQqJta1kJD0LGG5KoV1iHYJLow+Hw+l
         qVVaTMFLoYWdVyDfxQ8sdOWfB5+Nxjvrinb8fZ1nNqti+y6VnuiLRijm7dwGQ0MI1lsM
         I92KDcJQH/AE3siWqGSNI+G7A6dJjT+JNCTGMf032a3BdwkoumWpoyq3qVtYua2o//FW
         s6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLlm8KqzipM9Q047KqhTM7vH+Kqb0gcpAOfLuCPwI4Y=;
        b=2x8gVSjoqfBhcF/2UWg1EjIvsnGDepVpo3GFt4PPkwXaBfgV8jQo+rqE2in0HLdQWy
         tQ+sxqSyyZxHqZy2L/kMt1ZzbvSswt153UT2FszmQWcwFAVJpzWBtg9MkDMzGdDi+uqe
         7u8oX1apDZtNxaS5XWK7TVXS64OFD4qskploZFnHa7CvrilMw6lt/kPqp9QtM09VxYb8
         vhIr0nA21NBir2E07zIfchAIn4deomdWLCoj1dgOzzReREsj30iMN7JwF1mMiQOFU3cA
         i3ucbgVTqvJXV9mdljCiv+RR/bHQ7OoyGIEdHZA7IsGKj8/DcZ+cD6ORvF7kCX/oY+1o
         KZ7g==
X-Gm-Message-State: ANoB5pnU/0P8i9j9Q42ZDsxRLJkWlF4DWnBQdvyhGANY2RwvKOR6PRJp
	paA+mOLMYnylYiIIOr1njKM=
X-Google-Smtp-Source: AA0mqf53MR0iYRoPSz5P+x8tgEGk/g0FMK5KFYG1ymhnpN2jUn3FTRSzqqHDLuGCwsNkbacjRicXRw==
X-Received: by 2002:a05:6000:783:b0:241:bc34:3149 with SMTP id bu3-20020a056000078300b00241bc343149mr14131522wrb.351.1669287041820;
        Thu, 24 Nov 2022 02:50:41 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id hg27-20020a05600c539b00b003a3170a7af9sm1393128wmb.4.2022.11.24.02.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:50:41 -0800 (PST)
Date: Thu, 24 Nov 2022 10:50:39 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
Message-ID: <Y39MfyXJr2HgYElm@debian>
References: <20221123084602.707860461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>

Hi Greg,

On Wed, Nov 23, 2022 at 09:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 62 configs -> 1 failure
arm: 99 configs -> 1 failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> 1 failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
As reported by others, arm mips and powerpc allmodconfig fails with the error:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)
      |       


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2209
[2]. https://openqa.qa.codethink.co.uk/tests/2213
[3]. https://openqa.qa.codethink.co.uk/tests/2215

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
