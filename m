Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8824E6AB4
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 07:40:07 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-313e742a787so295882f8f.1
        for <patches@lists.linux.dev>; Tue, 03 Oct 2023 00:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696318805; x=1696923605; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WfwaRtkJhgz1kzbARp9S8/ZcPDCtTZfWdoKPp3HywLc=;
        b=mXcdTirZjT2vp8xAme856MKmDFocGVA/uKcW/pHs0KjS6GdikCIJgUtj4CUOB003Gf
         Q8LJ83AWXuFzOcjp33Xwes/XLYuE6/vv9P7DgBIaGALSJaXXWCO2CWlm9TqeotoyywKH
         Fw5AWCgc1wyUkbyt/vYiaK0E7OJMAoQu0Hy3HG/eGbNPmBaU/XCckKZXp2iwB/cS2Z2/
         uHCQflEgfTTBCW0xqOWswj6LEhQ/Wwu99FTKVEwdQX5/SduzDmL/9Kq8p1C8R0YTSs9X
         lRkndtQ1urrGAASvpIvAfK8ewmnTwTHBOQPbo9sPaddSqGcq9cRf3R24zrKc/a+7A9yM
         cd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696318805; x=1696923605;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WfwaRtkJhgz1kzbARp9S8/ZcPDCtTZfWdoKPp3HywLc=;
        b=u2AL/8uZtcE+IK3M2RezCZGSDs+g+W40DwoHXSda0bQsJvjrmJF3ES7eYd/G6+bL85
         39/vHn9Z63mNoLR5xXIqHbeKR8ckgQ0Z8xzAK8W3A8hlxWd6zbHwBRJ4Wo+epb5afIpj
         v5SI239bEYRbWT4bZBIwGxEZslH27acUTV41lMLgYCmr+dm1oV1kXjd8h2j48bKC1GIX
         rKqvKQj8MGBpnyqvDUzMd+9EWyGCs/rSaxr2BM2NOpHckh0X0p7ISOK/I21xiVepVBO4
         cmZiJUYy2PKeFhOaGMWCk/RjkXJTuvN/hO72k2RlRUEE6nX2GEKQIvCJ4BuhtbO4aS+4
         3Jrw==
X-Gm-Message-State: AOJu0YxgtWaMMpDoXaq886kybgp2MYVXFp7/C5i+ZwwJhJCpBJ6fbB9I
	Zn86fxWgZyKKxdfGxbuhcuEwCQ==
X-Google-Smtp-Source: AGHT+IFQumuMjOTW1uKZQSkiTBfGJlr5/807UTqWQzzYkCW1RNhEqi/kZVZ3yktWLc1ySpsCpLVbYw==
X-Received: by 2002:adf:e806:0:b0:31f:fa48:2056 with SMTP id o6-20020adfe806000000b0031ffa482056mr1239081wrm.27.1696318805632;
        Tue, 03 Oct 2023 00:40:05 -0700 (PDT)
Received: from [192.168.69.115] (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d444f000000b0031c5e9c2ed7sm896779wrr.92.2023.10.03.00.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 00:40:05 -0700 (PDT)
Message-ID: <1fbe8877-aaa5-1b6f-e18c-1d231a31d2e7@linaro.org>
Date: Tue, 3 Oct 2023 09:40:02 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, nipun.gupta@amd.com,
 nikhil.agarwal@amd.com, alex.williamson@redhat.com
Cc: ndesaulniers@google.com, trix@redhat.com, shubham.rohila@amd.com,
 kvm@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Nathan,

On 2/10/23 19:53, Nathan Chancellor wrote:
> When building with clang, there is a warning (or error with
> CONFIG_WERROR=y) due to a bitwise AND and logical NOT in
> vfio_cdx_bm_ctrl():
> 
>    drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>       77 |         if (!vdev->flags & BME_SUPPORT)
>          |             ^            ~
>    drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to evaluate the bitwise operator first
>       77 |         if (!vdev->flags & BME_SUPPORT)
>          |             ^
>          |              (                        )
>    drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand side expression to silence this warning
>       77 |         if (!vdev->flags & BME_SUPPORT)
>          |             ^
>          |             (           )
>    1 error generated.
> 
> Add the parentheses as suggested in the first note, which is clearly
> what was intended here.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support")

My current /master points to commit ce36c8b14987 which doesn't include
8a97ab9b8b31, so maybe this can be squashed / reordered in the VFIO tree
(where I assume this commit is). That said, the fix is correct, so:

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Regards,

Phil.

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/vfio/cdx/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index a437630be354..a63744302b5e 100644
> --- a/drivers/vfio/cdx/main.c
> +++ b/drivers/vfio/cdx/main.c
> @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
>   	struct vfio_device_feature_bus_master ops;
>   	int ret;
>   
> -	if (!vdev->flags & BME_SUPPORT)
> +	if (!(vdev->flags & BME_SUPPORT))
>   		return -ENOTTY;
>   
>   	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> 
> ---
> base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
> 
> Best regards,

