Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB341DDF0;
	Thu, 10 Aug 2023 11:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16513C433CA;
	Thu, 10 Aug 2023 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691667577;
	bh=PHQToYDN1jJ253CQ1B38WCDAhcL8w2XEWsk0JX64JF0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=iKw0G5u57xT52/doYQByyteDSqEIXToTy58H40JTM9AKefIzbpdknnu96l1NY2FqZ
	 8f0fA4wFVZ/nsRmOJ9tdrTHQDSQ23sUonoZTfA24FDIPJeUpVoAxWcqkg/UqaQsowy
	 5QswTGSOgoCvVLQSHoM/m18QMSTfPLlncZSUMGJ5A7eUpvRG68PYipLvdIwgvTGriC
	 55f83nvabRzEMZLucdbIEt7Q0rZwsoQ0aaZN+IgC1EkZdHOzTVeauuYNa2gK+d0Xqh
	 sOKabj9U0LKI1TfsSjOwtkrMXxiWr79KIauyzNnoXD/YG26HoBiT+S9ZqgUdRkYpic
	 UvGxSqZT+jSIg==
From: Mark Brown <broonie@kernel.org>
To: pierre-louis.bossart@linux.intel.com, lgirdwood@gmail.com, 
 peter.ujfalusi@linux.intel.com, yung-chuan.liao@linux.intel.com, 
 ranjani.sridharan@linux.intel.com, daniel.baluta@nxp.com, 
 Nathan Chancellor <nathan@kernel.org>
Cc: kai.vehmanen@linux.intel.com, ndesaulniers@google.com, trix@redhat.com, 
 rander.wang@intel.com, sound-open-firmware@alsa-project.org, 
 alsa-devel@alsa-project.org, llvm@lists.linux.dev, patches@lists.linux.dev
In-Reply-To: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
References: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
Subject: Re: [PATCH] ASoC: SOF: Intel: Initialize chip in
 hda_sdw_check_wakeen_irq()
Message-Id: <169166757481.31924.7230160819556948759.b4-ty@kernel.org>
Date: Thu, 10 Aug 2023 12:39:34 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2

On Wed, 09 Aug 2023 11:12:07 -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR):
> 
>   sound/soc/sof/intel/hda.c:423:6: error: variable 'chip' is uninitialized when used here [-Werror,-Wuninitialized]
>     423 |         if (chip && chip->check_sdw_wakeen_irq)
>         |             ^~~~
>   sound/soc/sof/intel/hda.c:418:39: note: initialize the variable 'chip' to silence this warning
>     418 |         const struct sof_intel_dsp_desc *chip;
>         |                                              ^
>         |                                               = NULL
>   1 error generated.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: SOF: Intel: Initialize chip in hda_sdw_check_wakeen_irq()
      commit: 9c28423d3caae63e665e2b8d704fa41ac823b2a6

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

