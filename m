Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E490C7B
	for <patches@lists.linux.dev>; Sun, 19 Jun 2022 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655647546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+J06pEWNoK09LE9zoo+UMEiuOGdfbFj8J1eghL4774g=;
	b=KRKAgMzwr8kYsAXFOXWquiOwlv0Wh5hgIWwUgkf6Bh/UKNxacxmoDd872w2rbypA+Dt9xO
	g0r2DXYX5kYH+QIS4s6cpTjbUYBkU5B5IBeeZolvnSjQCWbw+DpCCL2FhqNeD0AH82LCgH
	1VRvkQHrC8ZWCpN0AN2lhAFbKiOJTP0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-ScwNKUeRMmevrew8kYZuMw-1; Sun, 19 Jun 2022 10:05:43 -0400
X-MC-Unique: ScwNKUeRMmevrew8kYZuMw-1
Received: by mail-wm1-f71.google.com with SMTP id z13-20020a7bc7cd000000b0039c4a238eadso2494687wmk.9
        for <patches@lists.linux.dev>; Sun, 19 Jun 2022 07:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+J06pEWNoK09LE9zoo+UMEiuOGdfbFj8J1eghL4774g=;
        b=it3nGBtZpSgdObSmBXX/cQD+uo0zVHPnkSOMHd+V9JsLc4ubWJ6P0Vr2v2gveAY7+a
         mZ6g1R6tq1U4vDfdi+yOpddGRJyHx3DcsYTv5wXQTcaoeRzFecxKEdVf2s+wFHlQC4YZ
         fTCNOf4yl9haacz4TTxr8oiGOBtuNKQcdX42gHVUd0fqCHPApOxfKdXEn+EtM827DJuq
         +H4QzzOyysirGYRBKRIrBvo8K9QGmRx53M2KNktigvAxmixPElBX/A5Bq/3OiiNlvJWM
         qSKTswWUUzjRe4Bbiri4LtYLEqELKS8yxFDPRR7QVj11Staw6VAt+6UvnH0B3U31iMXs
         Gn4w==
X-Gm-Message-State: AJIora+eWXEbpQdkefHVMVWyITGMZHYQVayKIeFAfSWmrGUoo65wElUG
	Og0ZUq30f6SubQq2bRHxBfBLNpfVDqz7uZ4rQ1DGst9ZGXbYdc175AzRCIf3VbfMhinNwnb3Vzl
	okeAcyGw/7H2oy0OHmg==
X-Received: by 2002:a05:600c:1d1c:b0:39c:7ac8:1faa with SMTP id l28-20020a05600c1d1c00b0039c7ac81faamr19974645wms.202.1655647542047;
        Sun, 19 Jun 2022 07:05:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sqkvbNnOzZl+cwco0T7PXHEFnwFug7R2dDPBw4OF+u7KwsLzh4D4k2GwyDOt/mPsx86e/HuQ==
X-Received: by 2002:a05:600c:1d1c:b0:39c:7ac8:1faa with SMTP id l28-20020a05600c1d1c00b0039c7ac81faamr19974621wms.202.1655647541837;
        Sun, 19 Jun 2022 07:05:41 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id l1-20020a1c2501000000b0039747cf8354sm11553979wml.39.2022.06.19.07.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 07:05:41 -0700 (PDT)
Message-ID: <40d294df-de91-3f36-7d70-13cad54ac34f@redhat.com>
Date: Sun, 19 Jun 2022 16:05:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm: hisilicon: depends on MMU
To: Randy Dunlap <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org
Cc: Xinliang Liu <xinliang.liu@linaro.org>,
 Chen Feng <puck.chen@hisilicon.com>, patches@lists.linux.dev,
 David Airlie <airlied@linux.ie>, Xinwei Kong
 <kong.kongxinwei@hisilicon.com>, Huang Rui <ray.huang@amd.com>,
 John Stultz <jstultz@google.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Tian Tao <tiantao6@hisilicon.com>,
 Christian Koenig <christian.koenig@amd.com>
References: <20220531025557.29593-1-rdunlap@infradead.org>
From: Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20220531025557.29593-1-rdunlap@infradead.org>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=javierm@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello Randy,

On 5/31/22 04:55, Randy Dunlap wrote:
> Prevent a kconfig warning when MMU is not enabled by making
> DRM_HISI_HIBMC depend on MMU.
> 
> WARNING: unmet direct dependencies detected for DRM_TTM
>   Depends on [n]: HAS_IOMEM [=y] && DRM [=m] && MMU [=n]
>   Selected by [m]:
>   - DRM_TTM_HELPER [=m] && HAS_IOMEM [=y] && DRM [=m]
>   - DRM_HISI_HIBMC [=m] && HAS_IOMEM [=y] && DRM [=m] && PCI [=y] && (ARM64 || COMPILE_TEST [=y])
> 
> Fixes: 4f7f1973b0c8 ("drm/vram: fix Kconfig")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

