Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C23B6FCDA
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 22:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uFOnysxF"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2ca0715f0faso36171071fa.0
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 14:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701813872; x=1702418672; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YcEMEJf4lCydMrLOTT6eApwWgWe19yXNqzmuvh+QqWY=;
        b=uFOnysxFr5QNXGUH7CYcVu9uVsZQ9/TGfv0vAUlck5JKRatB6IL4j2rzRULsoRLRWg
         YNDWu3ZQEcJsxjypityUIG9fxMWAy7P7ZtlbbpfgejM3GGsgciekwmFNjDjfWY/0IvzJ
         KFJ6dqKzFl+iBqyTPEIW/+ZTSvpEqt+xq6MknuvWtKQbb9hhiK/nzx9tzD8PoSlj5UK5
         hvPyOasUMHVChFpBgnVZITd4Qh11FBwbuqkCq31MJ9DJkeyxdZ7wZ5SVcIJywWxdDg+m
         jtQUznGsPZAsC/8fTvyHTDYNdRWdjQGo4KOV8RuTEbDvwkqOWvzMqTrYNyiDze2F8Tb/
         L90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701813872; x=1702418672;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YcEMEJf4lCydMrLOTT6eApwWgWe19yXNqzmuvh+QqWY=;
        b=SYMtfDvMpnQhSMPgWE2m6XBodIRmFD9W+Rgsu65DwPT0w21vlXpyDsTaQlSJ9wEINp
         LHr94VpkFeRXDvwbR5PKRERIbmkZwhNYhJrEIK20CV0UE4qkm51erw3fM6ZDMrX9TEVw
         3GBfKnOpxRs/XAcCdjc+gwE4V/JiyUvWnbTndvESYiN1Eex28xRRB2+30XOQdnf2pv6U
         JveNVKwWQiQ8htl/8uulOa3SbKMs/4k1aVm4X1mGnFUvfo3YRs0uve7GN6EEoBvm56G8
         PFmVnT/kllceMkeQfw78iD9PljUlrAiYKutM+vgX/S8c3yO/ugqilbaeqTjTEaqlWatp
         e60w==
X-Gm-Message-State: AOJu0YyEHvvDYbc2uP3U+TAolOekHsAKZZiQxLv01URVgkwJuH3UmdCk
	9aWeQy3yEYL75Gz57lGoXlvnuQ==
X-Google-Smtp-Source: AGHT+IELJFW4CRavNSvWmbv6+vTpGPUZn67DcntqLGgQXhIS4H64Z9uxXCZut3JO674Qxj6E0JTCBg==
X-Received: by 2002:a2e:b742:0:b0:2ca:20f7:531b with SMTP id k2-20020a2eb742000000b002ca20f7531bmr22788ljo.51.1701813872482;
        Tue, 05 Dec 2023 14:04:32 -0800 (PST)
Received: from ?IPV6:2001:1c06:2302:5600:366d:ca8f:f3af:381? (2001-1c06-2302-5600-366d-ca8f-f3af-0381.cable.dynamic.v6.ziggo.nl. [2001:1c06:2302:5600:366d:ca8f:f3af:381])
        by smtp.gmail.com with ESMTPSA id hq3-20020a1709073f0300b00a1cc1be1158sm1159684ejc.165.2023.12.05.14.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 14:04:31 -0800 (PST)
Message-ID: <bc0bbe57-1739-4338-abfb-bd7011dc904b@linaro.org>
Date: Tue, 5 Dec 2023 23:04:31 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] drm/bridge: Return NULL instead of plain 0 in
 drm_dp_hpd_bridge_register() stub
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, dmitry.baryshkov@linaro.org
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
 linux@roeck-us.net, neil.armstrong@linaro.org, linux-usb@vger.kernel.org,
 dri-devel@lists.freedesktop.org, patches@lists.linux.dev,
 kernel test robot <lkp@intel.com>
References: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
 <20231205-drm_aux_bridge-fixes-v1-3-d242a0ae9df4@kernel.org>
From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <20231205-drm_aux_bridge-fixes-v1-3-d242a0ae9df4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/12/2023 21:13, Nathan Chancellor wrote:
> sparse complains:
> 
>    drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c: note: in included file:
>    include/drm/bridge/aux-bridge.h:29:16: sparse: sparse: Using plain integer as NULL pointer
> 
> Return NULL to clear up the warning.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202312060025.BdeqZrWx-lkp@intel.com/
> Fixes: e560518a6c2e ("drm/bridge: implement generic DP HPD bridge")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   include/drm/bridge/aux-bridge.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/drm/bridge/aux-bridge.h b/include/drm/bridge/aux-bridge.h
> index 66249ff0858e..c4c423e97f06 100644
> --- a/include/drm/bridge/aux-bridge.h
> +++ b/include/drm/bridge/aux-bridge.h
> @@ -26,7 +26,7 @@ void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status sta
>   static inline struct device *drm_dp_hpd_bridge_register(struct device *parent,
>   							struct device_node *np)
>   {
> -	return 0;
> +	return NULL;
>   }
>   
>   static inline void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status status)
> 

Nice

Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
