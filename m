Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093AB8F60;
	Thu,  2 Feb 2023 20:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA4EC433EF;
	Thu,  2 Feb 2023 20:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675368940;
	bh=90+83JUa3aCx3Qxq9grwhDgZO6pg9KQsVAzYsh3KHgs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=LScRtsZLI6kbvVNMwo6ZZAvq+OCE/R2Z5Zh+ADsX8OMy3qvMJ0HQWe2ZOLNCEDO1N
	 0/shpbgtZknqV14gPpzKQFEV839L60ptleOboIzjHYrtTWit0yeKmSL078wdpBVvsk
	 OO0QBOXdpJvZzDXM96FH1GInhfGXBJzC1y1s4JDubQ7H0dbr3FceUTntvt8jTsDb8g
	 4y3j/VAki8Djw+gOz6Ro+nKV6HDFnVzWhF3E1aYpyx8r9z3Se2d+H3oDKMabShpRcV
	 U/+W/Spo2vSNp0qqYmbwLwSS464RkHQnWtoAmNjkmUBkCTcYYiODgwb0ZN1EPG0w35
	 5W3TWjeCHL/uQ==
From: Mark Brown <broonie@kernel.org>
To: codrin.ciubotariu@microchip.com, lgirdwood@gmail.com, 
 claudiu.beznea@microchip.com, Nathan Chancellor <nathan@kernel.org>
Cc: nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
 ndesaulniers@google.com, trix@redhat.com, alsa-devel@alsa-project.org, 
 linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev
In-Reply-To: <20230202-mchp-spdifrx-fix-uninit-mr-v1-1-629a045d7a2f@kernel.org>
References: <20230202-mchp-spdifrx-fix-uninit-mr-v1-1-629a045d7a2f@kernel.org>
Subject: Re: [PATCH] ASoC: mchp-spdifrx: Fix uninitialized use of mr in
 mchp_spdifrx_hw_params()
Message-Id: <167536893801.1481377.11250986201319801994.b4-ty@kernel.org>
Date: Thu, 02 Feb 2023 20:15:38 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0

On Thu, 02 Feb 2023 09:34:19 -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   ../sound/soc/atmel/mchp-spdifrx.c:455:3: error: variable 'mr' is uninitialized when used here [-Werror,-Wuninitialized]
>                   mr |= SPDIFRX_MR_ENDIAN_BIG;
>                   ^~
>   ../sound/soc/atmel/mchp-spdifrx.c:432:8: note: initialize the variable 'mr' to silence this warning
>           u32 mr;
>                 ^
>                  = 0
>   1 error generated.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: mchp-spdifrx: Fix uninitialized use of mr in mchp_spdifrx_hw_params()
      commit: 218674a45930c700486d27b765bf2f1b43f8cbf7

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

