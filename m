Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D159443
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745415937; cv=none; b=YV70ymncYjaL3gDbK6SXEubU8zjX8xkRyseE4mBTlzeBkH/w2JsZ/Fjw4ez27bmvU8FDZvBklc23Du+CZXhYy0ahEnqif07hhXwrnur6ZYTDsijkRPy5FbGyYh4hjQ8UmLZW1mHSkGDFaj8cqWJpFHxhu3SqYG/aR356mZdzSKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745415937; c=relaxed/simple;
	bh=THD1ltI7KwFoV39fcHdBsSS/cEOqtzzyJoZjR3DEFoU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=jaJ+Fm6/vrAahn+aNlNRIdyrEZo2krNqgDNR1nGP6ZCCR9tme/VLbIdeHEr4UslTJuQdMTp3D+BGvLMbX9qhY/ukg7HSwlgNXMP9+sPSwN+AiJtlCMUgOB0oMTEaQkm0Q1NoT0mzYAaJj5jmP/b1QqekciQg6mTSshveGFcJ4WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wkOSEl+6; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wkOSEl+6"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so52161765e9.1
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 06:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745415934; x=1746020734; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P8QsglmHWSnLCPZZnCIb0YOMFFG7cMKbE8Tp8ziopqs=;
        b=wkOSEl+65lW/jcURCPUvPeAh81IShiQ755npvca9idZ6DRXSzY7tObac25w+12ZgL3
         gvasFlOhZKcrKaJM5vzLTWncNUT486F9B4IQYUuextnYrREtEGqy36W9VvATYOkQ/a5E
         xobZ/P+ba2Cv2EnuVu9GP1G3dvsGSIN8vHBjJQZ+uDv/Yw9b4i9Cn7APgDCFkrGXhH+8
         iTmJ9oqVUTnE9CGYLAzX6VykJn3O7fgE1eSY//YFWaKqfdh2DzgcohMNfBRaBlp/+mP2
         BygwNfD90F5i24p/OGfnofI9IPfiFTlZ/f0hq3XcJdQ1T5Wd3KmYmXn+7cJv52gPe44n
         qEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745415934; x=1746020734;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P8QsglmHWSnLCPZZnCIb0YOMFFG7cMKbE8Tp8ziopqs=;
        b=IcSlbjkDa6kZOL3W0M3SMHHZ8xvHO9Is7xktu/hNEf5b0sV3DnvXpCPu+BMbU1QM7+
         0ifVD7nR0IU0GmKb4bVlYQyqhk/l/wJoS0xwC1gb94STu2SDAB8UdMxpxBb5ybQf2JhT
         OZwmBo5dQf/MamNL3v3ZYwLTgfVIB5LHmh2eA0miuiYWLWHoJ3KmcVQIVbF0lLDa7VXQ
         t4qroBtsgYTIIf7JQt0gxvrlG+GEqEpjDVWTpA/dFsKZjAQw5ghiVt0GjVudG9Vsbpqj
         ZjbALO17ceHZB0lQdm9dri1M8spUSndOXDS0OlwM4h0zP3cHUSZvqBWIskNH7Q8mj2pf
         hXpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUic4JegoiecOXSl4qH76AvxNZ3vDefjObODVIgxUtVfot6I9RxFQtnWlq19fD4cFo/TWisX0xA@lists.linux.dev
X-Gm-Message-State: AOJu0Yzk8+/HMcoVOCl/6vkrkjM6d3vRAOF9TwGQXKU6IRnIpAi95SXH
	+1e8zdxLLoXjhYqp7tleNEPNHVFqfFVEUdVBiaedBsCD0HoEGozlB+fCbvXqHBw=
X-Gm-Gg: ASbGncvn3FfyHN8OHo6aQn50lcwb8y/PX7gxx8EBpXTg8kEFkhhZEvPs+7HdbNdvLpu
	ySsD6z2Eon6/QqHS0Y8ysUz1p+bG8ndXLPc5AsZxYQ6IMZWckxsURdblqDGDjLpZyupvgaVpw+6
	dv6U7DKLWzxDZVatFCv6+7zyoQq2jfuRJceSpEJLLIs1u641tjc20xNahLC/hxC29yN44cnrBbA
	oA6kbdUxC1xBbztHA96n4mYfHiWn2tL2wLCh6flfXvbfHu3TRcZSSwsl+192e7AO1MFsPnbtu4C
	7RS9tbyZPiGf1iIaJ4X+TEeytHqmXZS9QQ0kEr1f1paij7qrbG0wUL6nXU0dQye1PSnpV47WygO
	Zx/Yu/z/vovJHRUuC9kZtgSs79Nez
X-Google-Smtp-Source: AGHT+IEnfwtHJ3Wn/vXOb22OP5r0g9c7Ff2/QGuF8c6+sb47ABmJh546Gq/OE0qgXK1bZeJ8IDOLkw==
X-Received: by 2002:a05:600c:3485:b0:43d:abd:ad1c with SMTP id 5b1f17b1804b1-4406ab7b67bmr158450395e9.6.1745415934402;
        Wed, 23 Apr 2025 06:45:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3d9:2080:2835:c2f4:c226:77dd? ([2a01:e0a:3d9:2080:2835:c2f4:c226:77dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-44092d16e60sm26380505e9.3.2025.04.23.06.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 06:45:34 -0700 (PDT)
Message-ID: <a6e47775-33c3-44c2-b6d5-58164e4a0a50@linaro.org>
Date: Wed, 23 Apr 2025 15:45:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH] drm/panel: himax-hx8279: Initialize goa_{even,odd}_valid
 in hx8279_check_goa_config()
To: Nathan Chancellor <nathan@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jessica Zhang <quic_jesszhan@quicinc.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20250422-panel-himax-hx8279-fix-sometimes-uninitialized-v1-1-614dba12b30d@kernel.org>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro
In-Reply-To: <20250422-panel-himax-hx8279-fix-sometimes-uninitialized-v1-1-614dba12b30d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/04/2025 23:20, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>    drivers/gpu/drm/panel/panel-himax-hx8279.c:838:6: error: variable 'goa_even_valid' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>      838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
>          |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/gpu/drm/panel/panel-himax-hx8279.c:842:23: note: uninitialized use occurs here
>      842 |         if (goa_odd_valid != goa_even_valid)
>          |                              ^~~~~~~~~~~~~~
>    drivers/gpu/drm/panel/panel-himax-hx8279.c:838:2: note: remove the 'if' if its condition is always true
>      838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      839 |                 goa_even_valid = false;
>    drivers/gpu/drm/panel/panel-himax-hx8279.c:818:36: note: initialize the variable 'goa_even_valid' to silence this warning
>      818 |         bool goa_odd_valid, goa_even_valid;
>          |                                           ^
>          |                                            = 0
> 
> Even though only the even valid variable gets flagged, both valid
> variables appear to have the same issue of possibly being used
> uninitialized if the if statement initializing them to false is not
> taken.
> 
> Initialize both values to true to clear up the warning and remove any
> possibility of encountering undefined behavior.
> 
> Fixes: 38d42c261389 ("drm: panel: Add driver for Himax HX8279 DDIC panels")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/gpu/drm/panel/panel-himax-hx8279.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/panel/panel-himax-hx8279.c b/drivers/gpu/drm/panel/panel-himax-hx8279.c
> index b48b350b62da..92f351e66c25 100644
> --- a/drivers/gpu/drm/panel/panel-himax-hx8279.c
> +++ b/drivers/gpu/drm/panel/panel-himax-hx8279.c
> @@ -815,7 +815,7 @@ static int hx8279_check_gmux_config(struct hx8279 *hx, struct device *dev)
>   static int hx8279_check_goa_config(struct hx8279 *hx, struct device *dev)
>   {
>   	const struct hx8279_panel_desc *desc = hx->desc;
> -	bool goa_odd_valid, goa_even_valid;
> +	bool goa_odd_valid = true, goa_even_valid = true;
>   	int i, num_zero, num_clr = 0;
>   
>   	/* Up to 4 zero values is a valid configuration. Check them all. */
> 
> ---
> base-commit: dcbd5dcc956e2331414fd7020b4655df08deeb87
> change-id: 20250422-panel-himax-hx8279-fix-sometimes-uninitialized-207354fb930c
> 
> Best regards,

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
