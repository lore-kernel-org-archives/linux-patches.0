Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801A5134D1
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 07:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oOuWFFwa"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50bef9b7a67so4484995e87.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 23:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701846971; x=1702451771; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zDXbMWEhNI2lTiHePaAGslfA8GicK9kiWYsFKaGDIVI=;
        b=oOuWFFwaHFX8OysuRjdhiUZOJJX98q/kk45qADwdqX0PdywTirSQtgJbOqE80xTNZ5
         ibgdgqWP61fkYubrBfyPJ1bQTsqGrauEXHtn+4CU4vUmkb/usBXo/SynS6jvuieGowT0
         VpU4SCT4oU9Cm4pFg+f4kaSrQamnXYiZv+P6qQ0XZZFuDlPv4t1QSioTZUvrWrR9Ix6n
         1p1ZWzatWmjG40GP0bhtkbU7vZw46wLVIOeHuX75uPDDmdKF0nxMnTMZaCWTj3jbe64q
         NRmYfrIA7ioNpcz7eSlyQuzR8WMMZHFouKv2kvcE6emIczii8GB3ScpYDW2BumZwkmmr
         62QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701846971; x=1702451771;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zDXbMWEhNI2lTiHePaAGslfA8GicK9kiWYsFKaGDIVI=;
        b=D9aWjZ+D7T7mumgcBSSEOPp+YO5Zt8km9zNJJi9Yc8HWcOynRU5Q1DaVLrQRTsOgcQ
         3mK+v3nvWcABmhatAFGG6ueu+szCmSvKr2YDxTaCBQEuYJPKggBjqqQG5/3p2kJYPnNS
         J06JJuTFW+sng0sUkgfm8eEwmFNvjvJNuzXf1gqK06gEVm+UHsOBeE5smSrcctiauyCU
         euoak+DLj40V8xzk3DnvV/8PTfey8c1A2F93sTqDzOLG2Aji/2HnPQRBwRHiS4XXyMpe
         UrLiL0p/qJtfsf0/ERyvttGlDG6Ffa4v/l0m9lnT4aBXkIeXRpFFlg0dwpSZM0vG7r41
         67VA==
X-Gm-Message-State: AOJu0Yx4+0H3eu0MKrC3XbFSiHODwIa8+rbl2Ke3jix4srHbuKCkIUJ4
	l8dWHadB/Ji1UgefMdxiG5EOtw==
X-Google-Smtp-Source: AGHT+IFosgPawxVbHM+ucU/rImmtmf74cewBhXNK/zsrvoN6gu4JaquJiaTw9BlgaIdmcDryu2w2SQ==
X-Received: by 2002:a05:6512:3d01:b0:50b:fdc6:9f30 with SMTP id d1-20020a0565123d0100b0050bfdc69f30mr276013lfv.41.1701846971330;
        Tue, 05 Dec 2023 23:16:11 -0800 (PST)
Received: from ?IPV6:2001:14ba:a0db:1f00::227? (dzdqv0yyyyyyyyyyyykxt-3.rev.dnainternet.fi. [2001:14ba:a0db:1f00::227])
        by smtp.gmail.com with ESMTPSA id f17-20020a05651232d100b0050c10aa4582sm184607lfg.27.2023.12.05.23.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 23:16:10 -0800 (PST)
Message-ID: <fa72affd-ca04-4ea8-9892-d3a7cd1fbc8a@linaro.org>
Date: Wed, 6 Dec 2023 09:16:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] usb: typec: nb7vpq904m: Only select DRM_AUX_BRIDGE
 with OF
Content-Language: en-GB
To: Nathan Chancellor <nathan@kernel.org>
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
 linux@roeck-us.net, neil.armstrong@linaro.org, bryan.odonoghue@linaro.org,
 linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
 patches@lists.linux.dev
References: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
 <20231205-drm_aux_bridge-fixes-v1-1-d242a0ae9df4@kernel.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20231205-drm_aux_bridge-fixes-v1-1-d242a0ae9df4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/12/2023 22:13, Nathan Chancellor wrote:
> CONFIG_DRM_AUX_BRIDGE depends on CONFIG_OF but that dependency is not
> included when CONFIG_TYPEC_MUX_NB7VPQ904M selects it, resulting in a
> Kconfig warning when CONFIG_OF is disabled:
> 
>    WARNING: unmet direct dependencies detected for DRM_AUX_BRIDGE
>      Depends on [n]: HAS_IOMEM [=y] && DRM_BRIDGE [=y] && OF [=n]
>      Selected by [y]:
>      - TYPEC_MUX_NB7VPQ904M [=y] && USB_SUPPORT [=y] && TYPEC [=y] && I2C [=y] && (DRM [=y] || DRM [=y]=n) && DRM_BRIDGE [=y]
> 
> Only select CONFIG_DRM_AUX_BRIDGE with both CONFIG_DRM_BRIDGE and
> CONFIG_OF to clear up the warning.
> 
> Fixes: c5d296bad640 ("usb: typec: nb7vpq904m: switch to DRM_AUX_BRIDGE")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/usb/typec/mux/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

For this patch we'd need an ack from Heikki.

-- 
With best wishes
Dmitry

