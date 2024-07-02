Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B9115B559;
	Tue,  2 Jul 2024 11:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719919807; cv=none; b=ZhlRXhcMd7ZepTly2Cx5zHusqmOkPgXw+GXcduq0eAwRfzHZ/b33c3Fn3aFzXy2qSzZDmL53hshBKAGhkfd4k1HwoE7gS/Y7z/r6X0Hti3Q/OO1ruswyyv5fuTZKE0Tnt6QrYyURVSv1SL74FuCJ1pgJLsO8/iG1asv1zh1P7jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719919807; c=relaxed/simple;
	bh=ZEBaVU6KtOqS65U4pWx3ZRaX/O4ExxXq3npKnwdQAtE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NEJsywPEI4dW8D0XXLgtMqpkX2sL/93uQhVGuB1sJmhqJ1fcYHJWPsuTKiyO+WtuOW+xOxOD98Rat3tZD3gP5scsuVwtBMQTP8/MSHvol7KIKI5azlO0vQf9Fnb2Az8DKNGERlbe/8Dt+4skgCAdjXHAJbuBUrI3CY6ffqiguJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTtgxuOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTtgxuOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA95C2BD10;
	Tue,  2 Jul 2024 11:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719919806;
	bh=ZEBaVU6KtOqS65U4pWx3ZRaX/O4ExxXq3npKnwdQAtE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=DTtgxuOanW2fBW/ZV+zeYbRpGLfSG6m7KVdHV788+OXLEZIkpODkqa1H/yKDiEpUW
	 MLExm6b1b2PESzTM3udHlJ1STxLrYN+LNYaZFhwlnOJoWilrsRWCJ7/KBnzOqgPWls
	 k5FPANYDqv5dp8aTEKrJxiPew2Z7k5vtzL1Q/yc8K6wxOjAaEZK6X0vZzoRf2vwdC2
	 vdgNyZkb/OEATiz3JJqRWcXXR9bfTgv+qpfrqUuinBkFktrRrgR194IGxw5z5MdN20
	 58cINbsQuDUv3XDuNUPrA1+/YumETbMmbCf8EH6BXjbVsnlQ289OF+6+8GDy1/InRC
	 mHexAq0PmuUjg==
From: Mark Brown <broonie@kernel.org>
To: "J.M.B. Downing" <jonathan.downing@nautel.com>, 
 Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>, 
 Nathan Chancellor <nathan@kernel.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>, alsa-devel@alsa-project.org, 
 linuxppc-dev@lists.ozlabs.org, linux-sound@vger.kernel.org, 
 patches@lists.linux.dev
In-Reply-To: <20240701-lpc32xx-asoc-fix-include-for-field_prep-v1-1-0c5d7f71921b@kernel.org>
References: <20240701-lpc32xx-asoc-fix-include-for-field_prep-v1-1-0c5d7f71921b@kernel.org>
Subject: Re: [PATCH] ASoC: fsl: lpc3xxx-i2s: Include bitfield.h for
 FIELD_PREP
Message-Id: <171991980440.18111.17479068162057597635.b4-ty@kernel.org>
Date: Tue, 02 Jul 2024 12:30:04 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14-dev-d4707

On Mon, 01 Jul 2024 11:26:38 -0700, Nathan Chancellor wrote:
> bitfield.h is not explicitly included but it is required for FIELD_PREP
> to be expanded by the preprocessor. If it is not implicitly included,
> there will be a compiler error (as seen with ARCH=hexagon allmodconfig):
> 
>   sound/soc/fsl/lpc3xxx-i2s.c:169:10: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     169 |                 tmp |= LPC3XXX_I2S_WW8 | LPC3XXX_I2S_WS_HP(LPC3XXX_I2S_WW8_HP);
>         |                        ^
>   sound/soc/fsl/lpc3xxx-i2s.h:42:30: note: expanded from macro 'LPC3XXX_I2S_WW8'
>      42 | #define LPC3XXX_I2S_WW8      FIELD_PREP(0x3, 0) /* Word width is 8bit */
>         |                              ^
>   sound/soc/fsl/lpc3xxx-i2s.c:205:34: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     205 |                              LPC3XXX_I2S_DMA1_TX_EN | LPC3XXX_I2S_DMA0_TX_DEPTH(4));
>         |                                                       ^
>   sound/soc/fsl/lpc3xxx-i2s.h:65:38: note: expanded from macro 'LPC3XXX_I2S_DMA0_TX_DEPTH'
>      65 | #define LPC3XXX_I2S_DMA0_TX_DEPTH(s) FIELD_PREP(0xF0000, s) /* Set the DMA1 TX Request level */
>         |                                      ^
>   sound/soc/fsl/lpc3xxx-i2s.c:210:34: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     210 |                              LPC3XXX_I2S_DMA0_RX_EN | LPC3XXX_I2S_DMA1_RX_DEPTH(4));
>         |                                                       ^
>   sound/soc/fsl/lpc3xxx-i2s.h:70:38: note: expanded from macro 'LPC3XXX_I2S_DMA1_RX_DEPTH'
>      70 | #define LPC3XXX_I2S_DMA1_RX_DEPTH(s) FIELD_PREP(0x700, s) /* Set the DMA1 RX Request level */
>         |                                      ^
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: fsl: lpc3xxx-i2s: Include bitfield.h for FIELD_PREP
      commit: f1afb360b6f1f49e943ac85b26d4224ec67d22d3

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

