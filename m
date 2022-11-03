Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6543C7470;
	Thu,  3 Nov 2022 14:28:47 +0000 (UTC)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id 24DEE6602959;
	Thu,  3 Nov 2022 14:28:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1667485725;
	bh=b8oSMj3yGGmLDr9TfZfA5XfxYOJnyYMiLdl3fi78Qd8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=djeisnEtlWVdAM4+wcw30lEKMXQ47/OtybhWyHJyjt805gbTvf80rxPhka6O510M+
	 yCXWtCduQ+6hKRGhs/ofI1XRTu2ZVOF5lPdUtwOW+kuHS9CS5d6MriXeAYTIW21sJT
	 D2a/FBw8kdoMCGoNvmUmMIW68VCX9ef0t+Pz+EexYVFCHBjmJv+tpwg/6LTe75XDB2
	 5nh3hgVXyx2euEA7vVedvRkIr3aVIWOHZU08CegpGfT/YzCYYtb6orMi5Q5VZZQJWF
	 456yqFncyxZeAwXB3iI71Tb4QDwYVVsLHhz8/fV4pndNYL19Rx4lpgpBc73sA4cQeN
	 nOrqHw4hpKLPQ==
Message-ID: <31098aba-ef89-d083-d8cd-3553d3cc8cde@collabora.com>
Date: Thu, 3 Nov 2022 15:28:43 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] drm/mediatek: Fix return type of
 mtk_hdmi_bridge_mode_valid()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>,
 Chun-Kuang Hu <chunkuang.hu@kernel.org>,
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 Kees Cook <keescook@chromium.org>, Sami Tolvanen <samitolvanen@google.com>,
 llvm@lists.linux.dev, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20221102154712.540548-1-nathan@kernel.org>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221102154712.540548-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 02/11/22 16:47, Nathan Chancellor ha scritto:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
>    drivers/gpu/drm/mediatek/mtk_hdmi.c:1407:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' with an expression of type 'int (struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
>            .mode_valid = mtk_hdmi_bridge_mode_valid,
>                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
>    1 error generated.
> 
> ->mode_valid() in 'struct drm_bridge_funcs' expects a return type of
> 'enum drm_mode_status', not 'int'. Adjust the return type of
> mtk_hdmi_bridge_mode_valid() to match the prototype's to resolve the
> warning and CFI failure.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

