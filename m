Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767CA30CED
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WmvOiLzm"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3b2b1af964dso2471269b6e.1
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 10:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697477342; x=1698082142; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LmGiWDU9PXt+YAggrEnC/Bk/hTqS6qfb5Emwx53MAJs=;
        b=WmvOiLzmG30x+N8ma703W78lb2ABju5Mbfs7L9WiNpRft5eRPzoibjODqywfg/ze+V
         vd4mowkmTzxUqNaRxhB7dVOFMZKG1HSbDWqf013LRNqwGr47cdBY9Nwr8BTzGfn3uB2Y
         0GcYfJuX8sQN+f0hxs34/41CZKZlQi3fVLhCnAgtnoRemwK+xjhfr27McR3IkfsFUv0f
         o6zv28sa35xEzJOQNiuhjPxSI8w0I8i2oYl9SVX2lD/19rXRHjNW/1nmH6JEmdJIQe1L
         3GshiQSopEfNIYiy9z6BhuUkwaRZExZEQxk03Z3cfnei0kGn3CbLnHRxYRlvXCYo818I
         b6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697477342; x=1698082142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmGiWDU9PXt+YAggrEnC/Bk/hTqS6qfb5Emwx53MAJs=;
        b=i386EOBsinKg/nIy/afjeK0RukWYAsMwJAOMII2TByre17vOozg+XDBnoZ15LzkjTt
         ZVHo2uY8xg5MO6NhwFJDGCprAKNalj7yk9q2pqt3VGobxV+i/cWRDpENPxRHQA5kSGKU
         9fwmmpeHNCVVMdhOR4cp9NajD4OIG624QZZDhtC4q+TqBMypH4QjKiUP2/5yclEpafZ7
         roRuTKqdAmaZB72GXxUylk72qM0kIHV51wIHicG17+xlsLP3Z8HuNglVUBBt/imhiE9p
         2GrlCX/3b6Uq4Ox5ZvxcF/sk8GyMa0+iRL/MGufK3ERE82aeaeAU8yccYWhv7zFCgWJ9
         aW6A==
X-Gm-Message-State: AOJu0YzIqKlYGAycJaJLDxQgnC+WG4xRMQJseNE9KGBEywkdZ/O8vcUF
	KRyG+yDd1WJWt3uMmo1o8YfT7Q==
X-Google-Smtp-Source: AGHT+IEn6oj3+OG3g3K+JmO7h2NGo1Dur2TSSO882ulntrX3L84+CAKXG0csoUB1lRoMEXAUKwCvDw==
X-Received: by 2002:a05:6808:91a:b0:3a7:4987:d44 with SMTP id w26-20020a056808091a00b003a749870d44mr36147099oih.20.1697477342559;
        Mon, 16 Oct 2023 10:29:02 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:9add:9fdd:7517:f866])
        by smtp.gmail.com with ESMTPSA id g11-20020a63b14b000000b005657495b03bsm8391754pgp.38.2023.10.16.10.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 10:29:02 -0700 (PDT)
Date: Mon, 16 Oct 2023 11:29:00 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: patrice.chotard@foss.st.com, andersson@kernel.org, robh@kernel.org,
	ndesaulniers@google.com, trix@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	linux-remoteproc@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] remoteproc: st: Fix sometimes uninitialized ret in
 st_rproc_probe()
Message-ID: <ZS1ytespl//DoY3Q@p14s>
References: <20231012-st_remoteproc-fix-sometimes-uninit-v1-1-f64d0f2d5b37@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012-st_remoteproc-fix-sometimes-uninit-v1-1-f64d0f2d5b37@kernel.org>

On Thu, Oct 12, 2023 at 10:04:01AM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/remoteproc/st_remoteproc.c:357:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>     357 |         if (!ddata->config)
>         |             ^~~~~~~~~~~~~~
>   drivers/remoteproc/st_remoteproc.c:442:9: note: uninitialized use occurs here
>     442 |         return ret;
>         |                ^~~
>   drivers/remoteproc/st_remoteproc.c:357:2: note: remove the 'if' if its condition is always false
>     357 |         if (!ddata->config)
>         |         ^~~~~~~~~~~~~~~~~~~
>     358 |                 goto free_rproc;
>         |                 ~~~~~~~~~~~~~~~
>   drivers/remoteproc/st_remoteproc.c:348:9: note: initialize the variable 'ret' to silence this warning
>     348 |         int ret, i;
>         |                ^
>         |                 = 0
>   1 error generated.
> 
> Set ret to -ENODEV, which seems to be a standard return code when
> device_get_match_data() returns NULL.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1944
> Fixes: 5c77ebcd05ac ("remoteproc: st: Use device_get_match_data()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/remoteproc/st_remoteproc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/remoteproc/st_remoteproc.c b/drivers/remoteproc/st_remoteproc.c
> index b0638f984842..cb163766c56d 100644
> --- a/drivers/remoteproc/st_remoteproc.c
> +++ b/drivers/remoteproc/st_remoteproc.c
> @@ -354,8 +354,10 @@ static int st_rproc_probe(struct platform_device *pdev)
>  	rproc->has_iommu = false;
>  	ddata = rproc->priv;
>  	ddata->config = (struct st_rproc_config *)device_get_match_data(dev);
> -	if (!ddata->config)
> +	if (!ddata->config) {
> +		ret = -ENODEV;

Applied and thanks for fixing this.

Mathieu

>  		goto free_rproc;
> +	}
>  
>  	platform_set_drvdata(pdev, rproc);
>  
> 
> ---
> base-commit: 5c77ebcd05acf3789949c8a387df72381d949ca2
> change-id: 20231012-st_remoteproc-fix-sometimes-uninit-7aff1bdb7349
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
