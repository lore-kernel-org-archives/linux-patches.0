Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C7E15AE
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 08:55:58 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-402d0eda361so62739795e9.0
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 01:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694508957; x=1695113757; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ddS0ZkKFz8dmDcsSnwtGwTHKJaIvnEUsLWicZrz9JKY=;
        b=S28lUQF/e/JDAfEzwOJe83ayNffIx4FsapYqqq+PpRj4Ll6qHerCbHJi7BmkJbu0I/
         Z2by5n/YXkDbxpbneWHlRvr4XLjFu81agKTJpngfeWFiADQDQV9Z7qqBbdmFEsEvV/jv
         rF0LU/aiUor1lu5sRzQ41Tr0MH/EdU/0uJQvRIM7r9posOK/hA8SlhpCa/DKSOOxuhC4
         LF5Y5/EM3jTcq/fcYHccHoRaAGnWbDLIcKkmVHDPDVtwZBJl62fBmanXZuYQulzWml3u
         f7nwiShG4xewvdoJ1fZDi0yMnURWQV3MNWEIXQmbBwadOqLjDGaINHluYM7FlvUSfqI2
         BTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694508957; x=1695113757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddS0ZkKFz8dmDcsSnwtGwTHKJaIvnEUsLWicZrz9JKY=;
        b=tSPUYXKZjwG7aXjqR6p+xc7SGCHSjSZnDRdpY9SP/B0HAP1dl4GDgup3uCLMCVoYsl
         JxeqELVk89wkyw7YnpcJ6Df3MvJ9W6zafJqPEaNBI0SfH9qE4+qSmV86KqQ9MZDnAOZO
         KNB104iIOhNLQSfJQCoWWr5IsMvR3HaVq+k5+nqagJHWPhmyoXm8ONzxl+gkmoqBmabf
         Z0DIX5t3ypUUv/vH7o6a+gViDcXOiUaLQHmdCmWL9l5ZvlLGWRbDIgpHp8EaXiccXBXI
         XGrIksEEaF5ZkD29TDvZHQgpj8rajJ2t73tiBspmqFGBr0cvPoEnCM43jqMTAHv9pVTB
         iyYQ==
X-Gm-Message-State: AOJu0Yx91UJ54jCulAegJnyip4FhkknujLo/oYZJXsNAqhh6IxOG101b
	TzpOx2sBqIcmrlAa+q7huf4=
X-Google-Smtp-Source: AGHT+IE1E8L1noKwkbnXmhynwzkunFsBvTCSPHqmDk6jy85DHdMD6gSvgYUpjupeFJsK1bNPDAbO4A==
X-Received: by 2002:adf:fd4d:0:b0:319:67da:ed68 with SMTP id h13-20020adffd4d000000b0031967daed68mr10496784wrs.7.1694508956739;
        Tue, 12 Sep 2023 01:55:56 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id n7-20020a5d67c7000000b0031c56218984sm12231475wrw.104.2023.09.12.01.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 01:55:56 -0700 (PDT)
Date: Tue, 12 Sep 2023 09:55:54 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/739] 6.5.3-rc1 review
Message-ID: <ZQAnmlIBrsGlGGRZ@debian>
References: <20230911134650.921299741@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>

Hi Greg,

On Mon, Sep 11, 2023 at 03:36:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.3 release.
> There are 739 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 13.2.1 20230827):
mips: 52 configs -> no failure
arm: 70 configs -> no failure
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/5005
[2]. https://openqa.qa.codethink.co.uk/tests/5007
[3]. https://openqa.qa.codethink.co.uk/tests/5006

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
