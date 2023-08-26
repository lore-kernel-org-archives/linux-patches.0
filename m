Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC690A34
	for <patches@lists.linux.dev>; Sat, 26 Aug 2023 20:57:05 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7927f241772so65654439f.1
        for <patches@lists.linux.dev>; Sat, 26 Aug 2023 13:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1693083425; x=1693688225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mWUWofiHOM7DQZ0jywZUsI2/zykuQKvwiKBt6rB56lo=;
        b=mJqCZhKdhJl28wKlasaVGmbc1QTnf4wLX1OXSt/1aXeGR6g6ROsW2/3UifS79ahvuU
         jVoyrX0b5D78upqnUXdWjmV8eZ3YavtNXd5zMLi1le3GjGo/z8QXS0CbfHLOvGPwAgyW
         PwvutqPaRUPNk8UTRdOPQDzW/PHU7U2+745Lg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693083425; x=1693688225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWUWofiHOM7DQZ0jywZUsI2/zykuQKvwiKBt6rB56lo=;
        b=TQDjp2fiT1zLPpX1jBIqrrrivNdAjMBVqzJ5nptGpwg+EKKtMkpeOqbvPXAPUEa4Dp
         rox/uKnCo1qBBqm4narzfAbr22ZaATeo4KSnyGAUpfM75TlEAaYZJ235YA9PG/qVp0LC
         CCCBedPiLmf+sx4NblpdFED43HTG/tpLv3P6CQeMQpJmUwg9dj7vp5trWLl5tO8Xmd4q
         FvWoEaSmR5fAHWjE3hUKwBBXvvXSJlfdFOtXA0Gdhf3zqGlPmOyakz5i8RCk5oPW+Em+
         hTR39sB95lYE6EcA5/9aEXk6W980TQg5x6hhITX0T1/qhARMUki3eXC3ZMEZIz2fTWhZ
         R/Nw==
X-Gm-Message-State: AOJu0YzC/7xdqLS8TLPUlqShnUuS4k4AnvfEUKlQPzQNqC3tTmSdeaAL
	ISjK/wDNYXQTYLc7odyKQbWA5g==
X-Google-Smtp-Source: AGHT+IGc3nTRI3b/cUNX8UYrIAn+RQLsp6nClKr7WUYpeFfGQ8nyHTKBM8UKU0sFB1eF3aRoiypWtA==
X-Received: by 2002:a5e:cb07:0:b0:785:5917:a35f with SMTP id p7-20020a5ecb07000000b007855917a35fmr12739426iom.8.1693083424770;
        Sat, 26 Aug 2023 13:57:04 -0700 (PDT)
Received: from localhost (156.190.123.34.bc.googleusercontent.com. [34.123.190.156])
        by smtp.gmail.com with ESMTPSA id n17-20020a02cc11000000b0042bb2448847sm1355102jap.53.2023.08.26.13.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Aug 2023 13:57:04 -0700 (PDT)
Date: Sat, 26 Aug 2023 20:57:03 +0000
From: Joel Fernandes <joel@joelfernandes.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 0/4] 6.1.49-rc1 review
Message-ID: <20230826205703.GA2311600@google.com>
References: <20230826154625.450325166@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230826154625.450325166@linuxfoundation.org>

On Sat, Aug 26, 2023 at 05:47:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.49 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 28 Aug 2023 15:46:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>

thanks,

 - Joel


> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.1.49-rc1
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "f2fs: fix to do sanity check on direct node in truncate_dnode()"
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "f2fs: fix to set flush_merge opt and show noflush_merge"
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "f2fs: don't reset unchangable mount option in f2fs_remount()"
> 
> Peter Zijlstra <peterz@infradead.org>
>     objtool/x86: Fix SRSO mess
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                             |  4 ++--
>  fs/f2fs/f2fs.h                       |  1 +
>  fs/f2fs/file.c                       |  5 +++++
>  fs/f2fs/node.c                       | 14 ++----------
>  fs/f2fs/super.c                      | 43 ++++++++++++------------------------
>  include/linux/f2fs_fs.h              |  1 -
>  tools/objtool/arch/x86/decode.c      | 11 +++++----
>  tools/objtool/check.c                | 22 +++++++++++++++++-
>  tools/objtool/include/objtool/arch.h |  1 +
>  tools/objtool/include/objtool/elf.h  |  1 +
>  10 files changed, 54 insertions(+), 49 deletions(-)
> 
> 
