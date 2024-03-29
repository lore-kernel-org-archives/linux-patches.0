Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA7240BEB
	for <patches@lists.linux.dev>; Fri, 29 Mar 2024 07:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711698543; cv=none; b=Lg1syj0HjZ1Ul+NdB5DwkEuA6tDkJy/+twVp4/eLkTVO5KMht5fkQi/PxUWBPrZ3QNsbOVN4Zx5TcC5DyhjzrQn6ZMUreIuoKbdbG3KCM/PIWqXNTKXIs5f+kJFuJPaImnRqdY9rD21wN/+qIDgJ61N8zhqGxJJU8mOknVVInB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711698543; c=relaxed/simple;
	bh=hrVGrm+XFzcuK5528pVjiKN/DLLIKcKujxE3vf+d5Bo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=B3c7ORRGBrye1I38rBj12djRCogwtx2NUDlOkcZErUzMja70mJXHO10wduinkPhL1bjvyutZ7bWf/9/vDTxrXnB68p9hcv4N+LyX51CZ5c+g5iXi2iR1JaJlIp6ZwHiI+k0Mu5ix7nLSyOP+b4VdZmP3RdBu3E2RmMzfO+x3w9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=VzvpHKdQ; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="VzvpHKdQ"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a4e0e3ef357so231184166b.2
        for <patches@lists.linux.dev>; Fri, 29 Mar 2024 00:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1711698540; x=1712303340; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jDMm438h1JKLyWl9ds51rqV5RaMaxu4XMZFZHSuHm0=;
        b=VzvpHKdQnns5vhEgvQti01rxSMGzHGt1to0/p4bizGR7I2cCkHg9GZrtgLeYx+KYUu
         XDW73z2gBn7pI4/hKKgA2sR7ofuuMMz7jtuAF+6O9OhwxEXHnj/KZgAW8EWfUkktTk1C
         1AfNC/8zZUTbBLneiJyZpOpv5DkOirCk1hkU8VJIHJp/iTgSZVO3MfS/WJFHSRscC8Fg
         /NS6nEgm+L2+vywyv9WN5tBQMdUzJmUahAJ4IWXcRw9Hd9m+Cmkcvpaw/48Z6RCobRDf
         04d1C+i1j85MEXiv69uOQn572YHSFcJzRX0Pq4LIqfeuaMUcvAIW43qzsl71tEV07TbG
         zg3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711698540; x=1712303340;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0jDMm438h1JKLyWl9ds51rqV5RaMaxu4XMZFZHSuHm0=;
        b=TlpnRox8Tma24reHHDpTu5vlSa7I1jD4J81nMAnnkCbz5P+fzWIiKUCGihe0oxKTRT
         2LgjdW1PfM2qIWBmSDY/fJNVvz4WOKiTNWnoyrQk/Q/Gu6085xSuIcGyjCiBnoT/EELC
         KwGU0wcwkWLpl4lDxpQ8tACy1NTk3ffs1EENSZQ3vwJ+uBzyydsj/tQE5XC1tDoVi6pp
         p8p+j4iHarC67Kq9rhMHBjqtbRuTuKXz/RF2n5FORjtkL2rgUj29F3KlaNvQJeDbGeff
         zCOd5UMLMTOk3L/rfoAYnk3BoU4AbStqgVh9l9FTJUf+G3KeAR/eiXVu3bfmzKpXD86s
         E/8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUYpPEFWgoV8rQR5s4WUf3+g2PrPo8K6aUyb2U3UMzWkmhogWbygd6ZehRwl1j7KvOlm8WbZZEmIICiq29GgA9B0o//kTBCmA==
X-Gm-Message-State: AOJu0Yy6mwJJl4dUdFXYI88tmO8Ed6YK42vhr/XfsX0nbING4ytv6LHQ
	IEDejfExPWuc5aPN+oCHnCT5akqEwEms73vYVZfK+7dnDsxv2kO6l1TtBuIAXrQ=
X-Google-Smtp-Source: AGHT+IGr6uLJOKPOgi0GFuaum7P1KIsUToVk+xiSUxQLNvhkLwIbmAN2Qaoj5rZNEXI7yD+XPtaWsA==
X-Received: by 2002:a17:906:b104:b0:a4e:1154:fa46 with SMTP id u4-20020a170906b10400b00a4e1154fa46mr1050686ejy.70.1711698540231;
        Fri, 29 Mar 2024 00:49:00 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id ay12-20020a170906d28c00b00a46a9c38b16sm1620903ejb.138.2024.03.29.00.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 00:49:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 Mar 2024 08:48:59 +0100
Message-Id: <D062HPKFGJOW.3TI8AILOBMGIW@fairphone.com>
Cc: <dmitry.baryshkov@linaro.org>, <linux-usb@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH] usb: typec: ptn36502: Only select DRM_AUX_BRIDGE with
 OF
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Nathan Chancellor" <nathan@kernel.org>,
 <heikki.krogerus@linux.intel.com>, <gregkh@linuxfoundation.org>
X-Mailer: aerc 0.15.2
References: <20240328-fix-ptn36502-drm_aux_bridge-select-v1-1-85552117e26e@kernel.org>
In-Reply-To: <20240328-fix-ptn36502-drm_aux_bridge-select-v1-1-85552117e26e@kernel.org>

On Thu Mar 28, 2024 at 5:03 PM CET, Nathan Chancellor wrote:
> CONFIG_DRM_AUX_BRIDGE depends on CONFIG_OF but that dependency is not
> included when CONFIG_TYPEC_MUX_PTN36502 selects it, resulting in a
> Kconfig warning when CONFIG_OF is disabled:
>
>   WARNING: unmet direct dependencies detected for DRM_AUX_BRIDGE
>     Depends on [n]: HAS_IOMEM [=3Dy] && DRM_BRIDGE [=3Dy] && OF [=3Dn]
>     Selected by [m]:
>     - TYPEC_MUX_PTN36502 [=3Dm] && USB_SUPPORT [=3Dy] && TYPEC [=3Dm] && =
I2C [=3Dy] && (DRM [=3Dy] || DRM [=3Dy]=3Dn) && DRM_BRIDGE [=3Dy]
>
> Only select CONFIG_DRM_AUX_BRIDGE when CONFIG_DRM_BRIDGE and CONFIG_OF
> are enabled to clear up the warning. This results in no functional
> change because prior to the refactoring that introduces this warning,
> ptn36502_register_bridge() returned 0 when CONFIG_OF was disabled, which
> continues to occur with drm_aux_bridge_register() when
> CONFIG_DRM_AUX_BRIDGE is not enabled.

Oh, thanks! Seems I didn't see your patch for NB7VPQ904M so I made the
same mistake as there.

Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>

>
> Fixes: 9dc28ea21eb4 ("usb: typec: ptn36502: switch to DRM_AUX_BRIDGE")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/usb/typec/mux/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/typec/mux/Kconfig b/drivers/usb/typec/mux/Kconfi=
g
> index 4827e86fed6d..ce7db6ad3057 100644
> --- a/drivers/usb/typec/mux/Kconfig
> +++ b/drivers/usb/typec/mux/Kconfig
> @@ -60,7 +60,7 @@ config TYPEC_MUX_PTN36502
>  	tristate "NXP PTN36502 Type-C redriver driver"
>  	depends on I2C
>  	depends on DRM || DRM=3Dn
> -	select DRM_AUX_BRIDGE if DRM_BRIDGE
> +	select DRM_AUX_BRIDGE if DRM_BRIDGE && OF
>  	select REGMAP_I2C
>  	help
>  	  Say Y or M if your system has a NXP PTN36502 Type-C redriver chip
>
> ---
> base-commit: ef83531c8e4a5f2fc9c602be7e2a300de1575ee4
> change-id: 20240328-fix-ptn36502-drm_aux_bridge-select-83ddfd8a5375
>
> Best regards,

