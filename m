Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEBD5381
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 11:40:58 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id g3so7340784wri.6
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 03:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677757257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oC1DbDlSWN0TGCPVLZNEcsLa7RZfu8RnAEjQdiG3KSw=;
        b=TpBM3QY97ZtmZG+k4ZeAN2Fdtgk+wGLaR9y0Sa/G+BkfuUurnoBacXmmraBjEYcwm3
         +lCDCBnqzxOnXhgEROFU0F6MGUFEPY64W9+Ed/P1RIm90G3H6FsReK5PjvHVnUYJSEII
         KK1QWHR07aOirAUScWhytYOw4oVGc7y9fnO9NSAp/1dJ1lWuB1ty9JgEpIpvRh2yN2HK
         jvpo8rdcqyHyE1bCqskIVB0nyL0tzj6A/EQCSuj420ocjhxhh0Nm3WTsOktL1ZU6wbD2
         wUOqVV0XWMiAbFc4bJRS44kqqaBgpf5uIVfKOxE1z4pcIU9HnwlxlMp68wAJz4VhzeOw
         D9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677757257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oC1DbDlSWN0TGCPVLZNEcsLa7RZfu8RnAEjQdiG3KSw=;
        b=A3E/868M2s8OnRoaWSSIicOutG7i12ELGyyR+sh/Qwl6Vj2fNOONekMN5ncj+4E6jH
         kpseBTVkdcVkwS3b3ENmN9UPzbotKzIZiVzndoD5cfhUC88PPmK4HUAPqZryphQvTxCN
         e5Ri7EYdInPCDw1gOgfeKFMlLRXo1WcNU2Lh6jPVDhl2/nq8in/gBBrlLfosL0pGiLpY
         rTKTnwOshQbuGlpl6LgYZX5C6tJkxu7OzPsVhgk3WJvdj7f/fxDx+vnZhq1tuaV+eKEU
         keYe+TMdO1lie57Fp4gjFACTBlvLgoV0e87d5j73mVmDAZU/kwOh9XS6n8WmeTOa/SdD
         GSxg==
X-Gm-Message-State: AO0yUKV2Rnc3+F+L6bQ5E1a886NPp62otzyxxb9TXsANvXqsIkSLDd18
	SQamNbLRfzLHw9b0QEXpCxlb1dXzLMc=
X-Google-Smtp-Source: AK7set8cbosfnmyBbKxsgdiY/Kpjqi6P6a9mCfqoAUbLFvws3qsrucJMAviDpLV2Jy+dyziHoyTEbQ==
X-Received: by 2002:a5d:5186:0:b0:2c7:454:cee3 with SMTP id k6-20020a5d5186000000b002c70454cee3mr6951668wrv.7.1677757256882;
        Thu, 02 Mar 2023 03:40:56 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id bi25-20020a05600c3d9900b003e89e3284fasm2623054wmb.36.2023.03.02.03.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:40:56 -0800 (PST)
Date: Thu, 2 Mar 2023 11:40:54 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Message-ID: <ZACLRjbPOKjeGrc2@debian>
References: <20230301180653.263532453@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>

Hi Greg,

On Wed, Mar 01, 2023 at 07:07:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2976
[2]. https://openqa.qa.codethink.co.uk/tests/2984

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
