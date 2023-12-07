Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C469337D08
	for <patches@lists.linux.dev>; Thu,  7 Dec 2023 10:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qG080GU1"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50bf4f97752so605410e87.1
        for <patches@lists.linux.dev>; Thu, 07 Dec 2023 02:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701945200; x=1702550000; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtvnOGwWaVIVLZJl01FFTM/jnDNkRfH72/dI2rop8EA=;
        b=qG080GU1P5BX4xF6zbQa3K6QJ6egXn1+4a8wCB5Im3m4e8uiPAmkAoTuBefX0K6DVn
         AhkzbGo2i9kE1QXV6Oc/g8PIdEjlFj5zVKGxg710rswztU9+JwdY8cUcATMfRxWsf8bE
         HrMAevIgyrAELiPYxg/DGgD/HWvF2lW9VQggtmsMoP2CUQXhw8musBhBruH8w7inIAIi
         Ffi0mTC5RYzHb7Zqy2FTKdO6fHgXxPlMUw6LwgRJrd9/NUtHdM5fCfva36kWvMI8EU/E
         0mYsLkVI+dw6esF2nAFzETwjiYDrssfm7Ii4c23C55FBSTsmhxeA4rrm1wd6ozTh8rBt
         llJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701945200; x=1702550000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wtvnOGwWaVIVLZJl01FFTM/jnDNkRfH72/dI2rop8EA=;
        b=CIxt4nCSk/sNmElm1d2P0lPuvWDKkKEPCEIVHwaCYMHHvkHT1mFZxrurxdqOQimaGK
         t69rOrYQCR9mEry+RiBIJDOmMiJJxY3ZuHMM70Yn51qSx3fAeebSKoLSVDTcjeX/wCOz
         NtZcUNU8/q+V9ptEBOSphoJybc77OVuiUa9CZh0p0GT2pnnZ0uV4QepvwcYCYwWsm9sc
         WMhddMnekztegPS6JcsUGkCUApp88SMgutzfhgRldOV06WER5Cl/w1pbigRlwugLe4ei
         ExTg7vtQXRXH48wnem65x4wsCVOuu06/xqbiL4RvqQrQvVsaHJN2V944jXZnN0IQCEWX
         33Rg==
X-Gm-Message-State: AOJu0YxoqiUKitKrjdKLabgjMZGeCzDPYzlwIqWWHdUupspky7BaF2hd
	+AsV5xxnHWXBl2SUAefSmPoNNQ==
X-Google-Smtp-Source: AGHT+IGSMWWakZ98zfiQ4cPt4yvm/RbUov0IOgNHxy9Y4PELxlYrrQBKHwhxpK9eEMyi4LcWGo/Fhw==
X-Received: by 2002:ac2:495d:0:b0:50b:f4f9:75cf with SMTP id o29-20020ac2495d000000b0050bf4f975cfmr1424840lfi.9.1701945199891;
        Thu, 07 Dec 2023 02:33:19 -0800 (PST)
Received: from eriador.lan (dzdqv0yyyyyyyyyyyykxt-3.rev.dnainternet.fi. [2001:14ba:a0db:1f00::227])
        by smtp.gmail.com with ESMTPSA id o17-20020ac24bd1000000b0050c19506428sm138326lfq.170.2023.12.07.02.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 02:33:19 -0800 (PST)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: heikki.krogerus@linux.intel.com,
	gregkh@linuxfoundation.org,
	linux@roeck-us.net,
	neil.armstrong@linaro.org,
	bryan.odonoghue@linaro.org,
	linux-usb@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 0/3] A few fixes for transparent bridge support
Date: Thu,  7 Dec 2023 12:33:16 +0200
Message-ID: <170194519137.470483.63867654987574718.b4-ty@linaro.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
References: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 05 Dec 2023 13:13:33 -0700, Nathan Chancellor wrote:
> This series fixes two Kconfig issues that I noticed with the selection
> of CONFIG_DRM_AUX{,_HPD}_BRIDGE along with a fix for a sparse report
> that I noticed while seeing if these had already been resolved.
> 

Applied to drm-misc-next, thanks!

[1/3] usb: typec: nb7vpq904m: Only select DRM_AUX_BRIDGE with OF
      commit: 5908cbe82ef77f6019349c450d7f1c8b3c29bb0e
[2/3] usb: typec: qcom-pmic-typec: Only select DRM_AUX_HPD_BRIDGE with OF
      commit: 03c0343bdf8d43fee6dfe92a7b66308b60e9e77c
[3/3] drm/bridge: Return NULL instead of plain 0 in drm_dp_hpd_bridge_register() stub
      commit: 812cc1da7ffd9e178ef66b8a22113be10fba466c

Best regards,
-- 
Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
