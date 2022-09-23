Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905FE163
	for <patches@lists.linux.dev>; Fri, 23 Sep 2022 17:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39DEC433C1;
	Fri, 23 Sep 2022 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1663952830;
	bh=Zi+X8uctJFup7TbjedrP/+Pjx2XQ+XyqRpfIjKiqz5c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=BSztG1GiNRCbiEZ9nEehKrwGLVvxFPufNR7ae5EdtcCrBEyGfjiDER6M94hGNwPNv
	 lcHYxiQqfrT8g//ifN58fpdYsf2CPW9fNyQQO5sjASPDwdnUFSJbNVGgzFftJ2vg0P
	 IRen6gE0IZDx1OJyeDHtK6KgMRjiiixkSABZPXlRP5lHekakdq7QirLfmRI5gD6429
	 yNqqo53SzDDFrv9aqeTtQJ54TrEtW5XOdc1wV5L29+TUyA1CJ6cb3xv4kXFpVsPHab
	 a2qaaOXHeBlD1mCx2b5Wze/Rh5fl8s67jApIgjzEpefkSHu3QODtK/t7KxIiZ1Yc7X
	 NUgtnGYHOla9A==
From: Mark Brown <broonie@kernel.org>
To: Cezary Rojewski <cezary.rojewski@intel.com>, Nathan Chancellor <nathan@kernel.org>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>, Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
 Liam Girdwood <liam.r.girdwood@linux.intel.com>, Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, Bard Liao <yung-chuan.liao@linux.intel.com>
Cc: patches@lists.linux.dev, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, alsa-devel@alsa-project.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <20220922153752.336193-1-nathan@kernel.org>
References: <20220922153752.336193-1-nathan@kernel.org>
Subject: Re: [PATCH -next] ASoC: Intel: sof_da7219_mx98360a: Access num_codecs through dai_link
Message-Id: <166395282771.610218.7443739355228325098.b4-ty@kernel.org>
Date: Fri, 23 Sep 2022 18:07:07 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-fc921

On Thu, 22 Sep 2022 08:37:52 -0700, Nathan Chancellor wrote:
> After commit 3989ade2d1e7 ("ASoC: soc.h: remove num_cpus/codecs"), the
> following build error occurs:
> 
>   sound/soc/intel/boards/sof_da7219_max98373.c:198:27: error: no member named 'num_codecs' in 'struct snd_soc_pcm_runtime'
>           for (j = 0; j < runtime->num_codecs; j++) {
>                           ~~~~~~~  ^
>   1 error generated.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: Intel: sof_da7219_mx98360a: Access num_codecs through dai_link
      commit: 0402cca4828dd9556d36ddef67710993b7063f7c

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
