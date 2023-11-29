Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B05EE93
	for <patches@lists.linux.dev>; Wed, 29 Nov 2023 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Qz0gmzYx"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ce28faa92dso1701735ad.2
        for <patches@lists.linux.dev>; Wed, 29 Nov 2023 12:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701289348; x=1701894148; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=itd9NKciBX2zxONHPt0DHyuGmDjJYND+/iJlNldlRJY=;
        b=Qz0gmzYxg3+nfuTtsZB6fdmJcVmCC2qG8QovoW5MXN2aoxM2ac2A/a0UCnQWuJtHqW
         dF+1SJpkseSHh0frqrgMotmQ+WHfrWLek33bkGg4c+N/m9DePD/dfVY+vD6muleOyAGy
         NCfUqxpGOIIu06ClEsWUZ/KuncBl7VoXwk/lE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701289348; x=1701894148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itd9NKciBX2zxONHPt0DHyuGmDjJYND+/iJlNldlRJY=;
        b=KWEf2ksWUx68YNRy2Ut8rSLFxdCkE8S6KAzBtoHRIwLtVdYafcZ3bQCSTEmoiqTmld
         lLqOOX5AxCybEa82cTf9loZX9fBsaOl7FjWPJpDN2cBzpBQh97GJYMYC0R3ho3bkeWch
         DcZ7pYea86iLkBwQvx59RTxZrtByEk9iRLM6QwYTCv8DGM6wAtuEjesZp65EbRH+ODm+
         DfYJBRWX9lrMV/EIcrcUQkQTndGOmUdg1rVthuO9nlScWH/dD236BdUg4/tZsTE857a4
         ox3YUTpROlZBfUtY5LQFujLTNCxUFBJ0a9f2o5xSXpZuQPq8jGg8ODRZ3KVciBnFYvWd
         zFZA==
X-Gm-Message-State: AOJu0YwwRABayS2vlFKA645W78EjApKj2AX9I47vLeQlWabIBz3CZkLg
	niAOlx0gyfkPtLuikfUDAxsSRQ==
X-Google-Smtp-Source: AGHT+IGy4I6YEv72N7gHiWShs+tJ4XFlnr2sELy4UZbWmy+HzCFRKq117eRrCVzUM7vWcNMg7dhwJA==
X-Received: by 2002:a17:902:ce8c:b0:1cf:c3f7:7d4d with SMTP id f12-20020a170902ce8c00b001cfc3f77d4dmr16221436plg.67.1701289348165;
        Wed, 29 Nov 2023 12:22:28 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ij30-20020a170902ab5e00b001cc3a6813f8sm12975074plb.154.2023.11.29.12.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 12:22:27 -0800 (PST)
Date: Wed, 29 Nov 2023 12:22:27 -0800
From: Kees Cook <keescook@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] lkdtm: Add kfence read after free crash type
Message-ID: <202311291219.A6E3E58@keescook>
References: <20231127234946.2514120-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127234946.2514120-1-swboyd@chromium.org>

On Mon, Nov 27, 2023 at 03:49:45PM -0800, Stephen Boyd wrote:
> Add the ability to allocate memory from kfence and trigger a read after
> free on that memory to validate that kfence is working properly. This is
> used by ChromeOS integration tests to validate that kfence errors can be
> collected on user devices and parsed properly.

This looks really good; thanks for adding this!

> 
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/misc/lkdtm/heap.c | 64 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
> index 0ce4cbf6abda..608872bcc7e0 100644
> --- a/drivers/misc/lkdtm/heap.c
> +++ b/drivers/misc/lkdtm/heap.c
> @@ -4,6 +4,7 @@
>   * page allocation and slab allocations.
>   */
>  #include "lkdtm.h"
> +#include <linux/kfence.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sched.h>
> @@ -132,6 +133,66 @@ static void lkdtm_READ_AFTER_FREE(void)
>  	kfree(val);
>  }
>  
> +#if IS_ENABLED(CONFIG_KFENCE)

I really try hard to avoid having tests disappear depending on configs,
and instead report the expected failure case (as you have). Can this be
built without the IS_ENABLED() tests?

-- 
Kees Cook
