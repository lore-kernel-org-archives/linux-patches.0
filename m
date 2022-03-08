Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797F84C88
	for <patches@lists.linux.dev>; Tue,  8 Mar 2022 21:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646773969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o7rskMpOUtPRm21R1L+M5BTZ0/kXolxQOCHs+VUDkYg=;
	b=WNTwPqUgX34VDEjA1Jj2YTQdufWO13Y+EuxB0Xid/kQTDXxkqinLMLoQxT1QzJPG9Cbw/J
	BmRzBqnvVf/n0fCkDXbXjaDLF5g4aMZT+jeYaKVpWtlfSQWhzs46OrvKtFvyrjebd5s6hK
	FTBUA6ND5HD7gm4/hCSMew6DmnOUE80=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-3z947MAUNNO5DcpYX_kCiA-1; Tue, 08 Mar 2022 16:12:48 -0500
X-MC-Unique: 3z947MAUNNO5DcpYX_kCiA-1
Received: by mail-wm1-f71.google.com with SMTP id h131-20020a1c2189000000b003898de01de4so172055wmh.7
        for <patches@lists.linux.dev>; Tue, 08 Mar 2022 13:12:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o7rskMpOUtPRm21R1L+M5BTZ0/kXolxQOCHs+VUDkYg=;
        b=x+MgAMn+Z3PKKKWldIl8VRgPQMY8RZ7YOyxHwVeti66GJgmX/VIi1WCRHpb7U5OBfY
         l2MsK+dYjoS5IgUer2rJnZYZJRUrATwsQakae65Dxa/eV7TGY9WasAbtVvxBqX7Nbmm+
         t4L6PGmoGeomaqyCT44bmQE1rx9b67Rvy5RoyED1dkpQjB/eB/WCYVZCVkXAW65DyNtO
         r6N0ZRIJWduACQbr2ShxXBLRwTz2xxFB31CbXDLlEuvyDjiC/lFkjcT20hVyFDmYMtmp
         DBf2eftt7VtC50im94IkvVR65FMjf2SH1NF4epKRwQtcGHQnlx/5xZQxeEkVss1FfYaC
         PUrw==
X-Gm-Message-State: AOAM531Rb7f8bjaDeWq00BjM19B0VU8hA42brnOZitH2m3iJGsm8txPS
	f8HIk9Sx+bmZFik3GdidoDjgtWKMwCQHspVaPFpvuWfsjbLVSVH2Xxg86aWSKtSQP09sNB2zyYL
	h3cQ615JaeudNGhhEiw==
X-Received: by 2002:a05:600c:3552:b0:389:95b2:5f4a with SMTP id i18-20020a05600c355200b0038995b25f4amr947470wmq.24.1646773966834;
        Tue, 08 Mar 2022 13:12:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyi92ZKbMYeek4+BuLtBGmKMZo/pMCdGn7HyfqvI8yntVF5I5HjVRe+w8/RlZKLoqHhy9/qog==
X-Received: by 2002:a05:600c:3552:b0:389:95b2:5f4a with SMTP id i18-20020a05600c355200b0038995b25f4amr947449wmq.24.1646773966581;
        Tue, 08 Mar 2022 13:12:46 -0800 (PST)
Received: from redhat.com ([2.55.46.250])
        by smtp.gmail.com with ESMTPSA id a14-20020a05600c348e00b00389ab74c033sm18008wmq.4.2022.03.08.13.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 13:12:45 -0800 (PST)
Date: Tue, 8 Mar 2022 16:12:42 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	lei he <helei.sig11@bytedance.com>,
	virtualization@lists.linux-foundation.org,
	linux-crypto@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH -next] crypto: virtio - Select new dependencies
Message-ID: <20220308161153-mutt-send-email-mst@kernel.org>
References: <20220308205309.2192502-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220308205309.2192502-1-nathan@kernel.org>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 08, 2022 at 01:53:09PM -0700, Nathan Chancellor wrote:
> With ARCH=riscv defconfig, there are errors at link time:
> 
>   virtio_crypto_akcipher_algs.c:(.text+0x3ea): undefined reference to `mpi_free'
>   virtio_crypto_akcipher_algs.c:(.text+0x48a): undefined reference to `rsa_parse_priv_key'
>   virtio_crypto_akcipher_algs.c:(.text+0x4bc): undefined reference to `rsa_parse_pub_key'
>   virtio_crypto_akcipher_algs.c:(.text+0x4d0): undefined reference to `mpi_read_raw_data'
>   virtio_crypto_akcipher_algs.c:(.text+0x960): undefined reference to `crypto_register_akcipher'
>   virtio_crypto_akcipher_algs.c:(.text+0xa3a): undefined reference to `crypto_unregister_akcipher'
> 
> The virtio crypto driver started making use of certain libraries and
> algorithms without selecting them. Do so to fix these errors.
> 
> Fixes: 8a75f36b5d7a ("virtio-crypto: implement RSA algorithm")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks! I'll squash this into the original commit so we don't
have a broken commit during bisect.
zhenwei pi, ack pls?

> ---
>  drivers/crypto/virtio/Kconfig | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/virtio/Kconfig b/drivers/crypto/virtio/Kconfig
> index b894e3a8be4f..5f8915f4a9ff 100644
> --- a/drivers/crypto/virtio/Kconfig
> +++ b/drivers/crypto/virtio/Kconfig
> @@ -3,8 +3,11 @@ config CRYPTO_DEV_VIRTIO
>  	tristate "VirtIO crypto driver"
>  	depends on VIRTIO
>  	select CRYPTO_AEAD
> +	select CRYPTO_AKCIPHER2
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_ENGINE
> +	select CRYPTO_RSA
> +	select MPILIB
>  	help
>  	  This driver provides support for virtio crypto device. If you
>  	  choose 'M' here, this module will be called virtio_crypto.
> 
> base-commit: c5f633abfd09491ae7ecbc7fcfca08332ad00a8b
> -- 
> 2.35.1

