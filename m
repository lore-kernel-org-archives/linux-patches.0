Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C873B2AC
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696356121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1O1P5RRCZO3I2Cb3ZB5a7k3rWZWIpd5L49t63w6uEck=;
	b=fu5GhmuFyPeXed0HegVtO4rsfFV8HM5X1Rgx/UTiWwxeL0MbNFBx0MJLAvyFKJSNzcLpgo
	aLKNPMA1uQMt3k3G9Uy7YBHhqPT9Xd1dn3NOdhK9PQruQfwT/HPaWs0DbDmgku+7YQiV2e
	NLJF1xB0l+cPh/tq8hJORUeTvsP0T60=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-Jg7tPyqzMfKa1MGMGfdgiw-1; Tue, 03 Oct 2023 14:01:55 -0400
X-MC-Unique: Jg7tPyqzMfKa1MGMGfdgiw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-79fd91b8494so75013839f.3
        for <patches@lists.linux.dev>; Tue, 03 Oct 2023 11:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696356111; x=1696960911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1O1P5RRCZO3I2Cb3ZB5a7k3rWZWIpd5L49t63w6uEck=;
        b=NJMfT0eB/azkTejPU6jrpGFFmsDgoWFG2dR7enDaTjYRl1UnVbp/ABMGySAqGtaOFH
         kDknDxSP5V75CsBFeY8f4mIk9Br1Qn6/+9JK0KT+yica1Gu3LhlfdwSrecLrP338W9j8
         MFwnxfrFNIx4lOYUySFHL/jOAq6RwibYHoPvSPVR8QmA/bsX+o1eDX5nN9IbZ4JVqEHW
         3rI3uS3GcBi0F90NyisWfN19+7UcdXFVKS+5I7yu3zLdUV+QeIE+SwPihl8GQg0N6wOV
         mDjaxq8xgAJDt1NNq4PqOuHzHnkIFig/ilc+/EavzzFWEIG4VY/alu8D+S874Tp8pHXa
         mE5g==
X-Gm-Message-State: AOJu0Yzq7N1OCNjum7p8PJp/5FwyTP/03u2udpdI8gm2n/QzSqCpupiT
	XpH9wonhstu/IdlUjSzIwCOiw8DtpIhDKpHymfY5pP1Rork/ySSF2+BRcL8vpDy7q6YysX5Dq/2
	ML6+aOmq9Y2tSFy1d/A==
X-Received: by 2002:a5e:a915:0:b0:794:eddf:daae with SMTP id c21-20020a5ea915000000b00794eddfdaaemr178010iod.12.1696356111549;
        Tue, 03 Oct 2023 11:01:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4yTp9WE3Q/12Yk/wXuK2OODFz+pJdNL9fInAXp4IHhkyJn89d6aKAzKcOPfaMvL+GsZni7A==
X-Received: by 2002:a5e:a915:0:b0:794:eddf:daae with SMTP id c21-20020a5ea915000000b00794eddfdaaemr177988iod.12.1696356111291;
        Tue, 03 Oct 2023 11:01:51 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id fn12-20020a056638640c00b00439e3c9f958sm480243jab.129.2023.10.03.11.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 11:01:50 -0700 (PDT)
Date: Tue, 3 Oct 2023 12:01:49 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: nipun.gupta@amd.com, nikhil.agarwal@amd.com, ndesaulniers@google.com,
 trix@redhat.com, shubham.rohila@amd.com, kvm@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND
 expression and logical NOT
Message-ID: <20231003120149.11c89206.alex.williamson@redhat.com>
In-Reply-To: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 02 Oct 2023 10:53:13 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> When building with clang, there is a warning (or error with
> CONFIG_WERROR=y) due to a bitwise AND and logical NOT in
> vfio_cdx_bm_ctrl():
> 
>   drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^            ~
>   drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to evaluate the bitwise operator first
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^
>         |              (                        )
>   drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand side expression to silence this warning
>      77 |         if (!vdev->flags & BME_SUPPORT)
>         |             ^
>         |             (           )
>   1 error generated.
> 
> Add the parentheses as suggested in the first note, which is clearly
> what was intended here.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/vfio/cdx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> index a437630be354..a63744302b5e 100644
> --- a/drivers/vfio/cdx/main.c
> +++ b/drivers/vfio/cdx/main.c
> @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *core_vdev, u32 flags,
>  	struct vfio_device_feature_bus_master ops;
>  	int ret;
>  
> -	if (!vdev->flags & BME_SUPPORT)
> +	if (!(vdev->flags & BME_SUPPORT))
>  		return -ENOTTY;
>  
>  	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> 
> ---
> base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
> 
> Best regards,

Applied to vfio next branch for v6.7.  Thanks!

Alex

