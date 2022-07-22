Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41536AD4;
	Fri, 22 Jul 2022 19:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29A1C341C6;
	Fri, 22 Jul 2022 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658518771;
	bh=HMkRawVg1v3Lnz/EtuASgrNBKcNpgRvjw4saC+2EsIY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=CVjIv3SgS3hzCKr211xAM0WjagvfZ6fsUvXwbESRvktcjlMTl0AdUMpe0aJch1aD8
	 z8Z1OnUycsdLfYnXARrIRoXUKSX/kCCjhzs4rUNxUMQ+ZNjy7Sjbodqq7DZu2qCouG
	 ZKAD79ZX/u/oz5w9FkvnVG5gV5gU1nlAi1DZxBgRFPW8DpwfbLOxihyP4KQxStNmkK
	 n9ORYRFlRQurH+jqy8TVF1hAx/pFE6HC0YEbw1qrQlOKwRx5AjHVZU5L2EEx8bEYEH
	 FX8e1VYtQHWdL64RNDYyHE1T62OFuCo6WqRHmKlNsnGGDmqbDJgE6LmvojU/eioCnU
	 /kr+01FP2AxFw==
From: Mark Brown <broonie@kernel.org>
To: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Cezary Rojewski <cezary.rojewski@intel.com>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, llvm@lists.linux.dev,
 Ranjani Sridharan <ranjani.sridharan@linux.intel.com>, Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Bard Liao <yung-chuan.liao@linux.intel.com>, alsa-devel@alsa-project.org, Nathan Chancellor <nathan@kernel.org>,
 Liam Girdwood <liam.r.girdwood@linux.intel.com>
In-Reply-To: <20220722111959.2588597-1-amadeuszx.slawinski@linux.intel.com>
References: <20220722111959.2588597-1-amadeuszx.slawinski@linux.intel.com>
Subject: Re: [PATCH] ASoC: Intel: avs: Use lookup table to create modules
Message-Id: <165851876839.1163063.3967103245993487825.b4-ty@kernel.org>
Date: Fri, 22 Jul 2022 20:39:28 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-d952f

On Fri, 22 Jul 2022 13:19:59 +0200, Amadeusz Sławiński wrote:
> As reported by Nathan, when building avs driver using clang with:
>   CONFIG_COMPILE_TEST=y
>   CONFIG_FORTIFY_SOURCE=y
>   CONFIG_KASAN=y
>   CONFIG_PCI=y
>   CONFIG_SOUND=y
>   CONFIG_SND=y
>   CONFIG_SND_SOC=y
>   CONFIG_SND_SOC_INTEL_AVS=y
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: Intel: avs: Use lookup table to create modules
      commit: 1e744351bcb9c4cee81300de5a6097100d835386

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
