Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE4D1FA166
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 13:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736341339; cv=none; b=FjGonXCU1OhDPsmURsP6iI+xUlq4oMo0waZIHAPNHHuJS5gXTe6QzQS83ZA/B8iwFgx/ELf5TgU06XO+HZngiCN3p6Y0sbOO73eTQ8ea1WYIZRVKJNSg8YZIaVCbd8aIg5tPW5xMWalxfA6M3GTE9tQbG+VQZlD0KEIj+VSpqAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736341339; c=relaxed/simple;
	bh=pfXKttkEL2SWWU2rinTk0BU61tt2kEqGuqQajYKioxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQqBOKNnP58ueJ/2EvglSNo6Fxjdm+p4Ldik1ptG4xIWTR5jiA6NeohVD4nxpT1swUIEAZGZNk7t7pjeOW4sR8icxzHJqiZ/I5kcXnZLV/fCPMOcHPEVmJxqHgWq938SY8ZR+vXrifMGmliGJ6tOCh+sHw5Lbu3XUJ2Zkyvj/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gEUhJJ6+; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gEUhJJ6+"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53ff1f7caaeso17670984e87.0
        for <patches@lists.linux.dev>; Wed, 08 Jan 2025 05:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736341336; x=1736946136; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LtdjdENjpDlREgBVNAk/GURw9RLq4teFMIc2Gk3yyCc=;
        b=gEUhJJ6+k/nga0vBdA9i2CCCXYfYwlpJMfJAOEFhVynA4WZYooRl9omIqpg/g0h606
         BLb8//X1IgG6UCXu0rigLRafM+kSEJyYWzMQVQeEiwd7gtCkuh5oDd+44fnRWQtAfVUk
         eENfOxKFTxVqFALKTIdrRyS+mRa6JTYme0znV4O32khvnXI3qzsBdy+ZhvNQ/NEN/q84
         f2AfmKB/r3d7vSIwm/fjm0wZGPB7nOdvLxpxGIdIphivKvtycR44uWBuU15RLoHE4bJh
         Sn8OCZuk7uY13zelEw0kwoq7YRqIbUsRLwcYgbu4WodXZdmLeqK1LKp26QtRENaRuaYK
         yduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736341336; x=1736946136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LtdjdENjpDlREgBVNAk/GURw9RLq4teFMIc2Gk3yyCc=;
        b=NyzPipP786nuol+URDkY5aoFMCx2CwF17YCgGxVcNZohQ+J1HY2KcYeH9ScFqjW4Kv
         B4CTWYxP9F6tEEjAJOA/6tJNI5IKhPCaVgt+YXJadtbrBgpRd9d1Q4Y8AJbn8SeOItP9
         QTU8KXEGnsdkxDStYCDIzyz18KjUShHW1ycZpX5zYNGL52AlYqq/SS6A8WWkzsxNOPjz
         wobOIQQzpiHeTqou2sP5AQOZoCIQPZ8nNHTeDXltNwWi739RYsyQMo4eenjirx2BBgn1
         qbqnw3UINaGtAEh0ta5pJNS4l1aTPm5ZoQ646849+ZkEP9zjGcwJYuHaK4rtmlb++UUN
         4onQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvBDunj3QTX0FD2PA74vb3uGQJB8XpmTOucEt0yTvm6VaSYyh9leI2V8Vvoso7qmv2WnKyS7Cz@lists.linux.dev
X-Gm-Message-State: AOJu0YxvMPwfwLoIe/AjltEJBql7UmRKGi1hN18r8eWbA+H6i2Xb/D4r
	qRUaBmSsbY0jy2EnqyjCAVSFPis2Pvz8xYLHZH/QnZh0MzeJSF5QuRUQLUCT4sQ=
X-Gm-Gg: ASbGncv36fl6iUMJd1af4I0dOh55pQY01dAteSi31gx2RgA0aF/XCEa6V4fuZJ7U9kk
	s1ipIPLeZctN280wDes1h36s4llXPMokQTMNXWYCiJthPtpXu4zAw6anWFK8Oh7teU2Jsl60DcZ
	UhDW//zMUkTeUhDTAaoB/2RaDpm9eD6E7dyH30wUeax3xgesoY+IyyrvuqjsQmsgxnxtu8zDM5Q
	cy5ZgY2L5QsCUgvTrZUSIrCOJ+CQn8sFH2EvEBo/kDjQgJwWHTeBKeOAb8HPNx4imKuKZ6hhIHb
	bZB5lhFGIWLDGCB/EbRcQkXyp5JMqhkQrZCm
X-Google-Smtp-Source: AGHT+IF11Wgw4NNBGE9Alqz5c2ikDMgSytLQymr22qioeMYiszQ6HPLJGryvXEb7CVA6I7N4H4lGkQ==
X-Received: by 2002:ac2:4e08:0:b0:542:23b3:d81b with SMTP id 2adb3069b0e04-5428450707amr631936e87.5.1736341335696;
        Wed, 08 Jan 2025 05:02:15 -0800 (PST)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--b8c.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-542236000ddsm5590003e87.82.2025.01.08.05.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 05:02:15 -0800 (PST)
Date: Wed, 8 Jan 2025 15:02:12 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Rob Herring <robh@kernel.org>, linux-arm-msm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@google.com>, 
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Subject: Re: [RFC PATCH 6/6] arm64: dts: qcom: sc7180: Add SoC specific
 compatible to soc node
Message-ID: <n3fn5mnrrinrgrvadqgymv3cx355qpx5kk27nlrz2emoxfmjyt@ymwpfxf7lv4r>
References: <20250108012846.3275443-1-swboyd@chromium.org>
 <20250108012846.3275443-7-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108012846.3275443-7-swboyd@chromium.org>

On Tue, Jan 07, 2025 at 05:28:43PM -0800, Stephen Boyd wrote:
> Allow an SoC driver to probe for these devices. Add the SoC specific
> compatible to the soc node. Leave the original simple-bus compatible in
> place so that everything keeps working.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Konrad Dybcio <konradybcio@kernel.org>
> Cc: <linux-arm-msm@vger.kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> index 76fe314d2ad5..257890a193e6 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> @@ -782,7 +782,7 @@ soc: soc@0 {
>  		#size-cells = <2>;
>  		ranges = <0 0 0 0 0x10 0>;
>  		dma-ranges = <0 0 0 0 0x10 0>;
> -		compatible = "simple-bus";
> +		compatible = "qcom,soc-sc7180", "simple-bus";

If the new driver requires this compatible, it will break compatibility
with older DT files (and it should be avoided).

>  
>  		gcc: clock-controller@100000 {
>  			compatible = "qcom,gcc-sc7180";
> -- 
> https://chromeos.dev
> 

-- 
With best wishes
Dmitry
