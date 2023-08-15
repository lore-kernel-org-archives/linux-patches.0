Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0FC1426C;
	Tue, 15 Aug 2023 20:07:29 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-349783c5d43so24713705ab.3;
        Tue, 15 Aug 2023 13:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692130048; x=1692734848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nUCMTDCnmgGsHFEPB7fbXzNbYOHxgFVGtdGWinwxkH8=;
        b=OoUNgnf/w6Vt3crMFnHUNDBtNczDdv1QRfkloganzykB1Jbb+p9FGCJoKArkeyOPEA
         JmWudxeP7/+d4m28l38RpvRc3Dh8rWsg4H6PHlGnlgYbCini+rM0sh/uv/qU56MjXsMI
         +lpuDZm9DIC4vWUo+BJ+WUURoycIaKnXr9XGt47sY8YDZ1CYWHVZGeZPT5PfZW8C/ffC
         ptGLFdeRyij61Yrl9/z6sB+dCAShQ8Lt09HfMgH7u+EYE1XGNha/6fmWF8Jbdi3qggU1
         mBnN6o/cIxc7xeIbc1zdxSgVGYmPGVyhsFHnEEHOwJ71G2GjHRC/hDIEOMmFLu7jAdWJ
         sSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692130048; x=1692734848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUCMTDCnmgGsHFEPB7fbXzNbYOHxgFVGtdGWinwxkH8=;
        b=SF53avPsqUuciPGZEGzSMKg5bws9vZRCqbK0TV06PxsjYxfyUqRa6b1OPRvYmttLdp
         YM3l0ERaoenjJIM1rOoFB2b1N4DRNnyCQHj4uPTswjolPmlGun9BPiU849TWpjm5tByZ
         XMdQlaXiMB9XD6XhcKu0bY1zi5e7No+RTqvqA/yPAxvs+j24GPO6AbG2tJRJyyXf8QW3
         8U8RjucUohFpnw9waLHsFJQyBa37NP6FUPf6MYElAvxRzldYNPpvR8nXKwzKGXf8H7PP
         msS+9nqjrkp4zwf233xsjZuAUsX8T4s1mciVIhK3ul0jBGyT9a6DmSOWyLomari0SBKj
         QK9Q==
X-Gm-Message-State: AOJu0YxtGAdfD4KVCD7s3j0Qoc8ujHgUDZfz6mIe9NWm9OZmsi5a4+if
	t3J52j3KtatnyWTfvOYZ6/E=
X-Google-Smtp-Source: AGHT+IHdog8eeuIH4iCCRfH0UrplHufqLsUdqySFwCsdRxGz3H7GTGJAE/IFmnqMDd79BPqZFXN/fw==
X-Received: by 2002:a05:6e02:1a0d:b0:345:f28f:cc26 with SMTP id s13-20020a056e021a0d00b00345f28fcc26mr20334172ild.24.1692130048048;
        Tue, 15 Aug 2023 13:07:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n10-20020a92d9ca000000b00349477a91dasm4115772ilq.79.2023.08.15.13.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 13:07:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 15 Aug 2023 13:07:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: srinivas.neeli@amd.com, wim@linux-watchdog.org,
	shubhrajyoti.datta@amd.com, michal.simek@amd.com,
	ndesaulniers@google.com, trix@redhat.com,
	linux-watchdog@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, patches@lists.linux.dev,
	llvm@lists.linux.dev
Subject: Re: [PATCH] watchdog: xilinx_wwdt: Use div_u64() in
 xilinx_wwdt_start()
Message-ID: <54b78b80-1d2b-43fe-845c-844a62b62773@roeck-us.net>
References: <20230815-watchdog-xilinx-div_u64-v1-1-20b0b5a65c2e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815-watchdog-xilinx-div_u64-v1-1-20b0b5a65c2e@kernel.org>

On Tue, Aug 15, 2023 at 12:06:50PM -0700, Nathan Chancellor wrote:
> After commit f1a43aadb5a6 ("watchdog: Enable COMPILE_TEST for more
> drivers"), it is possible to enable this driver on 32-bit architectures.
> When building for those architectures with clang, there is an error due
> to a 64-bit division in xilinx_wwdt_start():
> 
>   ERROR: modpost: "__aeabi_uldivmod" [drivers/watchdog/xilinx_wwdt.ko] undefined!
> 
> Use div_u64() to fix this, which takes a 64-bit dividend and 32-bit
> divisor. GCC likely avoids the same error due to optimizations it
> employs to transform division by a constant into other equivalent
> operations, which may be different than what is implemented in clang.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1915
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/xilinx_wwdt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/xilinx_wwdt.c b/drivers/watchdog/xilinx_wwdt.c
> index 1d998db41533..d271e2e8d6e2 100644
> --- a/drivers/watchdog/xilinx_wwdt.c
> +++ b/drivers/watchdog/xilinx_wwdt.c
> @@ -9,6 +9,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/ioport.h>
> +#include <linux/math64.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> @@ -71,7 +72,7 @@ static int xilinx_wwdt_start(struct watchdog_device *wdd)
>  
>  	/* Calculate timeout count */
>  	time_out = xdev->freq * wdd->timeout;
> -	closed_timeout = (time_out * xdev->close_percent) / 100;
> +	closed_timeout = div_u64(time_out * xdev->close_percent, 100);
>  	open_timeout = time_out - closed_timeout;
>  	wdd->min_hw_heartbeat_ms = xdev->close_percent * 10 * wdd->timeout;
>  
> 
> ---
> base-commit: 8a504bd61ec7b3ddd72680e15775f2c7c0f9e894
> change-id: 20230815-watchdog-xilinx-div_u64-85c27c650493
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
