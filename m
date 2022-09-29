Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8088010F7
	for <patches@lists.linux.dev>; Thu, 29 Sep 2022 08:07:10 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id cv6so612637pjb.5
        for <patches@lists.linux.dev>; Thu, 29 Sep 2022 01:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=0Jfzl2sNnfhcmOJ2w1p67/kZD3Vw/dvkwuexZ9m31YM=;
        b=P87hvSDDuEWClVP5xzHvYmmh4LTLu551xTpJzaPDMe4LieY8KERFX8Ujs8zWUvrz98
         sKa5I87UXH+5n827rMS1kwkkgnMtwMX/RACxh9QuHtK3d4B6XF1aJXV+2XA1AmWLsvh/
         S+WtRHcrRei+OaTUo91sWFJpZtpfNO/ld1FhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0Jfzl2sNnfhcmOJ2w1p67/kZD3Vw/dvkwuexZ9m31YM=;
        b=6CrVIay2m6G7V9dOO/aXh0X4lVXzHdUrWQkPXkJyqP4iWXISglXbmUV42KipMO9E72
         STO/1ncubimCyo9KTMvQ8Bbdv9WPkxYP5synPd5S5sRVBLfn7XuX3ku3tdmjUxsMBwS8
         tGA9HISLg01l74D5NEiuw7b8ISzE/0vVcPJ8o88xx752wxtTbhHJquivnqrErZQz925k
         /iiImrtCxRMa+67459e91veaKa2IEQVKncoVVO9tG9an5DLZelt3zv/OEfsuQPQtTyxF
         iXKPzlmAWtTgZLEyr67/9HgVvRv1fNjs+y5ggXpU2FpPV11PpoXMYT/tMk3+1z0L6N5b
         hjKg==
X-Gm-Message-State: ACrzQf1j34T1Qy4m6meO9e80vWbpiO7sGLMRV9X8zVxx+cH2Z7r//Ty8
	k1HUIu4AhJ3FVbrMFCjEIJfyIA==
X-Google-Smtp-Source: AMsMyM4+Mj2J8XHAWgYmKThY6/GgJaz8N5uLUtVAjrhrE54ehACWk51RbxkUw262Lb+XCP8GD1+8FQ==
X-Received: by 2002:a17:90b:4b09:b0:202:ad77:9ee1 with SMTP id lx9-20020a17090b4b0900b00202ad779ee1mr2469916pjb.10.1664438829765;
        Thu, 29 Sep 2022 01:07:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902654400b00176b84eb29asm5185479pln.301.2022.09.29.01.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 01:07:09 -0700 (PDT)
Date: Thu, 29 Sep 2022 01:07:08 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Felipe Balbi <balbi@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: Fix argument to sizeof() in
 uvc_register_video()
Message-ID: <202209290106.E6EFD95D4@keescook>
References: <20220928201921.3152163-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220928201921.3152163-1-nathan@kernel.org>

On Wed, Sep 28, 2022 at 01:19:21PM -0700, Nathan Chancellor wrote:
> When building s390 allmodconfig after commit 9b91a6523078 ("usb: gadget:
> uvc: increase worker prio to WQ_HIGHPRI"), the following error occurs:
> 
>   In file included from ../include/linux/string.h:253,
>                    from ../include/linux/bitmap.h:11,
>                    from ../include/linux/cpumask.h:12,
>                    from ../include/linux/smp.h:13,
>                    from ../include/linux/lockdep.h:14,
>                    from ../include/linux/rcupdate.h:29,
>                    from ../include/linux/rculist.h:11,
>                    from ../include/linux/pid.h:5,
>                    from ../include/linux/sched.h:14,
>                    from ../include/linux/ratelimit.h:6,
>                    from ../include/linux/dev_printk.h:16,
>                    from ../include/linux/device.h:15,
>                    from ../drivers/usb/gadget/function/f_uvc.c:9:
>   In function ‘fortify_memset_chk’,
>       inlined from ‘uvc_register_video’ at ../drivers/usb/gadget/function/f_uvc.c:424:2:
>   ../include/linux/fortify-string.h:301:25: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>     301 |                         __write_overflow_field(p_size_field, size);
>         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This points to the memset() in uvc_register_video(). It is clear that
> the argument to sizeof() is incorrect, as uvc->vdev (a 'struct
> video_device') is being zeroed out but the size of uvc->video (a 'struct
> uvc_video') is being used as the third arugment to memset().
> 
> pahole shows that prior to commit 9b91a6523078 ("usb: gadget: uvc:
> increase worker prio to WQ_HIGHPRI"), 'struct video_device' and
> 'struct ucv_video' had the same size, meaning that the argument to
> sizeof() is incorrect semantically but there is no visible issue:
> 
>   $ pahole -s build/drivers/usb/gadget/function/f_uvc.o | grep -E "(uvc_video|video_device)\s+"
>   video_device    1400    4
>   uvc_video       1400    3
> 
> After that change, uvc_video becomes slightly larger, meaning that the
> memset() will overwrite by 8 bytes:
> 
>   $ pahole -s build/drivers/usb/gadget/function/f_uvc.o | grep -E "(uvc_video|video_device)\s+"
>   video_device    1400    4
>   uvc_video       1408    3
> 
> Fix the arugment to sizeof() so that there is no overwrite.
> 
> Cc: stable@vger.kernel.org
> Fixes: e4ce9ed835bc ("usb: gadget: uvc: ensure the vdev is unset")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for tracking that down!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
