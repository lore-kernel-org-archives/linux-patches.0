Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB2263B7
	for <patches@lists.linux.dev>; Thu,  2 Feb 2023 13:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE2AC433EF;
	Thu,  2 Feb 2023 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675343836;
	bh=De028cR7PVHoyYdcF5i0QwrAwqMYfKncZh1sUh5zT24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H1QFO4STGBmxjWLD+cv7+ywCbat758EcHsuAayI1uXp6uVvcjuVPVUjw6QbFnHAUn
	 GEjaFK1v2DEQAXBQVFEIHIPI5kSzuzNHUy06zalDtmJBpVBHqU4llRx186nJOxImeU
	 Gu1P5iEBxnqj5IlHyhY1FYPfKEtb6mCvH1YPIOzmOTCurg6U9heaYBg+lSHvGPdxhh
	 ggO4ySp+OI8JqNd5l/hVzcgAtH2UFcKZ1lkTfGSvql4lNpWPOWk0cAL899kB1eKRwS
	 TAn7O3Wh4G7VILzSaLYyH397Avw1tW2nQn7xMBQbOV/0vER4vVhwAkZCJ+rTJcIwkY
	 qjDpad7H6Hm6A==
Date: Thu, 2 Feb 2023 18:47:12 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: Re: [PATCH] phy: qcom-qmp: Introduce Kconfig symbols for discrete
 drivers
Message-ID: <Y9u32P3u4nuAiBnT@matsya>
References: <20230114000910.1256462-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114000910.1256462-1-swboyd@chromium.org>

On 13-01-23, 16:09, Stephen Boyd wrote:
> Introduce a config option for each QMP PHY driver now that the QMP PHY
> mega-driver has been split up into different modules. This allows kernel
> configurators to limit the binary size of the kernel by only compiling
> in the QMP PHY driver that they need, or to split the module up into one
> per PHY driver instead of one module for all the QMP PHY drivers.
> 
> Leave the old config QCOM_QMP in place and make it into a menuconfig so
> that 'make olddefconfig' continues to work. Furthermore, set the default
> of the new Kconfig symbols to be QCOM_QMP so that the transition is
> smooth.

This fails to apply for me, can you please rebase

-- 
~Vinod
