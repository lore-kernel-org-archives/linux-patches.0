Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E99F11CA4
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 16:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A7FC433C8;
	Wed,  5 Jul 2023 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1688573108;
	bh=MaQ9axNX26c9wxnJ0P+IdEAV6VOXIK3LAWryZ90v/Qg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=l3w5MPUrUOOTkdmknB6dx2CtyE52F8JS3tBM0epQzl+7XfY9lWhN2iMZRW8obwzfE
	 2OSTQTiVyWTgkJZ1X/k94tnKvPJuszNC1sD492Gept8Na3v0tjQoPiMHzmOt1y83fG
	 s68wJHzlZ9RN0CRG7CPdagmeRZHbi9Xrsx88wzrORB/C5bBUGC5fH8RL0WgpnFDWaa
	 4gC9pnSi/uYA+dZNAcTrj8jrhduibrdK0zNisA5ZQRLTTIuU6H2awoyad6vEsA8/hZ
	 2fkuXp0LC1Xw55zACnJGJTwUfmUBfAWf8sFQDnYNULgtoqroey94oDHoPstIDJ4AMQ
	 XRIUuMjx8DMpQ==
From: Mark Brown <broonie@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: lgirdwood@gmail.com, vkarpovi@opensource.cirrus.com, 
 rf@opensource.cirrus.com, ckeepax@opensource.cirrus.com, 
 alsa-devel@alsa-project.org, patches@lists.linux.dev, 
 stable@vger.kernel.org, Marcus Seyfarth <m.seyfarth@gmail.com>
In-Reply-To: <20230703-cs35l45-select-regmap_irq-v1-1-37d7e838b614@kernel.org>
References: <20230703-cs35l45-select-regmap_irq-v1-1-37d7e838b614@kernel.org>
Subject: Re: [PATCH] ASoC: cs35l45: Select REGMAP_IRQ
Message-Id: <168857310652.55162.4180283376212806885.b4-ty@kernel.org>
Date: Wed, 05 Jul 2023 17:05:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9

On Mon, 03 Jul 2023 14:43:15 -0700, Nathan Chancellor wrote:
> After commit 6085f9e6dc19 ("ASoC: cs35l45: IRQ support"), without any
> other configuration that selects CONFIG_REGMAP_IRQ, modpost errors out
> with:
> 
>   ERROR: modpost: "regmap_irq_get_virq" [sound/soc/codecs/snd-soc-cs35l45.ko] undefined!
>   ERROR: modpost: "devm_regmap_add_irq_chip" [sound/soc/codecs/snd-soc-cs35l45.ko] undefined!
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: cs35l45: Select REGMAP_IRQ
      commit: d9ba2975e98a4bec0a9f8d4be4c1de8883fccb71

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

