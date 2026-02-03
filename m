Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BAE274B59;
	Tue,  3 Feb 2026 09:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770109724; cv=none; b=P3NiiduW/5B7IP1JlHrpeijg/XxTJuAVdN0HDxLo5BOJ6YSHE6Ea6BjD5vY7gEBQ0CGpygeU3apy1S0VSXNOKW+XZ8RqYgcGblcQTuYBk3DaqjqEY4oReXd+n01YeOD7e46Zkt57A85aVGFJG4yxSONSkRIOfvowtkuUALsa5P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770109724; c=relaxed/simple;
	bh=cFz/tPYSm3tLT861mZLJJj4g1c0ioBaYgzttMSvII80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QSifzwe6q4BduFPqKuxb8xdhPCnc5NNAvpPPSwy4P7Kx7zNnJTobqbDWFSYcuDbdUfqiXOb/BgKGsN78Q3PiCo0xJm6cmFxUEZ6w4PkgpkkarwiH3kd2ekk67o0cviQVwmt9UhIyIoNJFJUmF7J9cnQV+ggO6el+c/w6o46qqGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nl1Ijh8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nl1Ijh8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA006C116D0;
	Tue,  3 Feb 2026 09:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770109724;
	bh=cFz/tPYSm3tLT861mZLJJj4g1c0ioBaYgzttMSvII80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nl1Ijh8tmUw6dOsQHRSq/5/G489fyc0fpXqGdNtQ0NRYQDo1uVHlIRTjPgcKPCswM
	 ONU90AmSKSjwM1xeUUZA8JIwwfgg6aGIz2+0TbAJGvIbsdCpct87/JpUru5yOyMtw5
	 kSMJ8RW0+AwLDgRNQWfa6eur64Qw8cjBRy+fKfLi3Uv7RTV9P4KBkMcLukLwPi9oxP
	 f5NOBO2Fsb3hB3Ke6JNe5iKLUMhDJOH+/ywt1eSJaZtrWj4ImWt1bP9GMiIb6lWdH3
	 9uI32baRwb+UQpuVeH0riZTCrco/TgE3Q+rJ4pyfvIL0CKrxNJfLc1ZC7WpY4Y6EMK
	 Qv/DqRw6b8jPQ==
From: Maxime Ripard <mripard@kernel.org>
To: Neil Armstrong <neil.armstrong@linaro.org>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	Langyan Ye <yelangyan@huaqin.corp-partner.google.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Maxime Ripard <mripard@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] drm/panel: ilitek-ili9882t: Remove duplicate initializers in tianma_il79900a_dsc
Date: Tue,  3 Feb 2026 10:08:39 +0100
Message-ID: <177010971609.2807136.13257550414662424946.b4-ty@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114-panel-ilitek-ili9882t-fix-override-init-v1-1-1d69a2b096df@kernel.org>
References: <20260114-panel-ilitek-ili9882t-fix-override-init-v1-1-1d69a2b096df@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 14 Jan 2026 13:43:31 -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y / W=e):
> 
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:95:16: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>      95 |         .vbr_enable = 0,
>         |                       ^
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:90:16: note: previous initialization is here
>      90 |         .vbr_enable = false,
>         |                       ^~~~~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:97:19: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>      97 |         .rc_model_size = DSC_RC_MODEL_SIZE_CONST,
>         |                          ^~~~~~~~~~~~~~~~~~~~~~~
>   include/drm/display/drm_dsc.h:22:38: note: expanded from macro 'DSC_RC_MODEL_SIZE_CONST'
>      22 | #define DSC_RC_MODEL_SIZE_CONST             8192
>         |                                             ^~~~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:91:19: note: previous initialization is here
>      91 |         .rc_model_size = DSC_RC_MODEL_SIZE_CONST,
>         |                          ^~~~~~~~~~~~~~~~~~~~~~~
>   include/drm/display/drm_dsc.h:22:38: note: expanded from macro 'DSC_RC_MODEL_SIZE_CONST'
>      22 | #define DSC_RC_MODEL_SIZE_CONST             8192
>         |                                             ^~~~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:132:25: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>     132 |         .initial_scale_value = 32,
>         |                                ^~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:126:25: note: previous initialization is here
>     126 |         .initial_scale_value = 32,
>         |                                ^~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:133:20: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>     133 |         .nfl_bpg_offset = 3511,
>         |                           ^~~~
>   drivers/gpu/drm/panel/panel-ilitek-ili9882t.c:108:20: note: previous initialization is here
>     108 |         .nfl_bpg_offset = 1402,
>         |                           ^~~~
> 
> [...]

Applied to misc/kernel.git (drm-misc-next-fixes).

Thanks!
Maxime
