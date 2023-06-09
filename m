Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAE2EC2
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 08:50:29 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-30af86a96b4so1035691f8f.3
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 01:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686300628; x=1688892628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QlhS76abjw2unQxYRogEYbRc9c+4vaUtoOax7Eo2mpE=;
        b=HR37tdNjO6ngZIOBuyeFvQy2tBqrULVrePY3fvThMC7JwDm37IkcfhapHMoCtDTLgV
         lqerEAxML/bRSOfdiKXc3+WImhNAecjxZOgX8WM3OpYRxiebfChwkSlq9fvM7gVHzTPR
         PyNQXwAvhXkZyUQDQSFDrcBZefBpMmjdKXKi/4KVetoyS9agAQtS0yL5PRlr0JHEbSi1
         9mw+M3mPOlKY/tRcfS0jh47bGjUquy9qidY5g8qiJfi+G3bQKhP/4yoUOuDAmkJKiU58
         vgHe/KVqJHA8YgdkveAQq0yEqJ+ly0RDcrGftWmUY1A/wsddrcsuFUxDEsH2Zd0L33jo
         vZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686300628; x=1688892628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QlhS76abjw2unQxYRogEYbRc9c+4vaUtoOax7Eo2mpE=;
        b=Xmv/YX0ZrKWC3ECKj+P1r1clGP3N1frsKAQvL1AE7p6jrk/cOCOIL2rue2Qp3VXrOi
         1vZTAAo4j42o7YyEyBoNpqE/Xd8DiLMow4rfV4lNr2yBvM9Q+5BbW9KmFjMpu07wxcW7
         3XfSkVHfA9MCJPLWnZmdz9V3L94QfLx1nD7eVNlahyV4TYRFbPO30QCha4X8CwH0Majc
         euAfVLl6e0MHil7wKv8+J6gi8S0RRMVB0xGdcYhO1JYalWnwyq5ISnzGEe+jZoW3q3uX
         rPg01KH1Q+Jsu9S1jagbw4Y+z6fkfi38oFP4v65IK8oDHG6QAudYHwQof+gXnoGxA25u
         E3HQ==
X-Gm-Message-State: AC+VfDyJ2KEWP2B8k61D5+Pou16xfampzepYOOxKKkazD9kI+QpVpzP9
	3/opl9fq+PngBJ8ixMl2AP0=
X-Google-Smtp-Source: ACHHUZ5FL2uwDQQk+Qwd1oRh5/2afHTPCb6VVpooihXZdU7XJeSEFfMWqX1FLahYOnplauNKXdw8kA==
X-Received: by 2002:a5d:5052:0:b0:30e:4c8d:c6c with SMTP id h18-20020a5d5052000000b0030e4c8d0c6cmr295484wrt.55.1686300627965;
        Fri, 09 Jun 2023 01:50:27 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id m6-20020adfdc46000000b0030e5bd253aasm3852053wrj.39.2023.06.09.01.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 01:50:27 -0700 (PDT)
Date: Fri, 9 Jun 2023 09:50:26 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/224] 6.1.33-rc2 review
Message-ID: <ZILn0m8jsz8+jnMF@debian>
References: <20230608175726.909746266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608175726.909746266@linuxfoundation.org>

Hi Greg,

On Thu, Jun 08, 2023 at 08:00:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.33 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
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
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/3828
[2]. https://openqa.qa.codethink.co.uk/tests/3812
[3]. https://openqa.qa.codethink.co.uk/tests/3827

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
