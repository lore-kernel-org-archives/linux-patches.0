Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464BD6FCCC
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 22:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VWJLhLK/"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a06e59384b6so18317066b.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 14:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701813812; x=1702418612; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R17jjO/Vw4wRIx9Ju0HZ2kb3C5GDd4Vm8IbDi1LNWjk=;
        b=VWJLhLK/IDEMJ2XGglaNFuLfKLNQ/uXP5Q8Nlj//8VL/1zsuYL+nm2xGkhVt3S9Efd
         /yoLQKXzlos9WrBmpf//is85SqxTLGzUIzGE6b5Pf7PY+W70XxOnvP1OXyCLqkzcz0Tu
         CrU0urjnSWSApRDvfiQuXHM0vf4ooDlY3iVHrQbv55ys+IfSkEXG3STufW5PuUk8Xir0
         lw6BiRmuvc/xazdske/ZZq+GXwfwxq/u2Tq2K7pFgHwl2iMHQimOOPR4LjXV6aJgoTPy
         9Ixl2R5Je9mzFTzKYQV8RUBptkSlRMER33ukqPgIYyoJ4y1dOdt6yxQykCgWDIBc8rzB
         Udrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701813812; x=1702418612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R17jjO/Vw4wRIx9Ju0HZ2kb3C5GDd4Vm8IbDi1LNWjk=;
        b=pDxab/yKa+apmOdJAQ8q3eRFNIJyT/JvcOCsRpJM/s6DCn3KoikgmRkFGnkAoUisME
         QuMtWDWheXUX8Y7pd6dkIZHBXh90s8OL9kQPb8qck/h3iIfSnYvYJgbI4+0ojZXEi5yA
         kP50ubHAPKmQBmO3wLa9x2+cyfbclDRqfnscECpqfi5BsNxzrR4N4e+gU4kRYTcSUBr5
         ufCiTHLJ8+Ah67wSO4dxaS1HDH2PwfqUas922eELnIx1RvHGlz+0AI9M5hORAUZYX9Ob
         i69GGmNi7jmHMZ0T5Z7NDOumoscATuCwSpAYVTjEdqNpUABaqAcx5FSyYQOPvF81mxlg
         S9+g==
X-Gm-Message-State: AOJu0Yy8pGjibipZ4kIfgp+EsWLvynWVJp9x5PdiVwY4mzDf6JC0vQ/v
	rZnaqnkJ0eQR25coyqWDJe8Beg==
X-Google-Smtp-Source: AGHT+IE/hqq5solRByq/6s4+0WTlT9xIiduM2nthd2KHQBztl+NRk6XM/HBt9ZMTdjcUIz5MDEwfZg==
X-Received: by 2002:a17:906:2655:b0:a18:50ad:9ab with SMTP id i21-20020a170906265500b00a1850ad09abmr5106299ejc.74.1701813812535;
        Tue, 05 Dec 2023 14:03:32 -0800 (PST)
Received: from ?IPV6:2001:1c06:2302:5600:366d:ca8f:f3af:381? (2001-1c06-2302-5600-366d-ca8f-f3af-0381.cable.dynamic.v6.ziggo.nl. [2001:1c06:2302:5600:366d:ca8f:f3af:381])
        by smtp.gmail.com with ESMTPSA id hq3-20020a1709073f0300b00a1cc1be1158sm1159684ejc.165.2023.12.05.14.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 14:03:32 -0800 (PST)
Message-ID: <94157ef7-95c9-429a-97c5-3bab2b9074ca@linaro.org>
Date: Tue, 5 Dec 2023 23:03:31 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] usb: typec: qcom-pmic-typec: Only select
 DRM_AUX_HPD_BRIDGE with OF
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, dmitry.baryshkov@linaro.org
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
 linux@roeck-us.net, neil.armstrong@linaro.org, linux-usb@vger.kernel.org,
 dri-devel@lists.freedesktop.org, patches@lists.linux.dev
References: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
 <20231205-drm_aux_bridge-fixes-v1-2-d242a0ae9df4@kernel.org>
From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <20231205-drm_aux_bridge-fixes-v1-2-d242a0ae9df4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/12/2023 21:13, Nathan Chancellor wrote:
> CONFIG_DRM_AUX_HPD_BRIDGE depends on CONFIG_OF but that dependency is
> not included when CONFIG_TYPEC_QCOM_PMIC selects it, resulting in a
> Kconfig warning when CONFIG_OF is disabled:
> 
>    WARNING: unmet direct dependencies detected for DRM_AUX_HPD_BRIDGE
>      Depends on [n]: HAS_IOMEM [=y] && DRM_BRIDGE [=y] && OF [=n]
>      Selected by [m]:
>      - TYPEC_QCOM_PMIC [=m] && USB_SUPPORT [=y] && TYPEC [=m] && TYPEC_TCPM [=m] && (ARCH_QCOM || COMPILE_TEST [=y]) && (DRM [=m] || DRM [=m]=n) && DRM_BRIDGE [=y]
> 
> Only select CONFIG_DRM_AUX_HPD_BRIDGE with both CONFIG_DRM_BRIDGE and
> CONFIG_OF to clear up the warning.
> 
> Fixes: 7d9f1b72b296 ("usb: typec: qcom-pmic-typec: switch to DRM_AUX_HPD_BRIDGE")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/usb/typec/tcpm/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/tcpm/Kconfig b/drivers/usb/typec/tcpm/Kconfig
> index 64d5421c69e6..8cdd84ca5d6f 100644
> --- a/drivers/usb/typec/tcpm/Kconfig
> +++ b/drivers/usb/typec/tcpm/Kconfig
> @@ -80,7 +80,7 @@ config TYPEC_QCOM_PMIC
>   	tristate "Qualcomm PMIC USB Type-C Port Controller Manager driver"
>   	depends on ARCH_QCOM || COMPILE_TEST
>   	depends on DRM || DRM=n
> -	select DRM_AUX_HPD_BRIDGE if DRM_BRIDGE
> +	select DRM_AUX_HPD_BRIDGE if DRM_BRIDGE && OF
>   	help
>   	  A Type-C port and Power Delivery driver which aggregates two
>   	  discrete pieces of silicon in the PM8150b PMIC block: the
> 

Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
