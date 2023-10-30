Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5881A588;
	Mon, 30 Oct 2023 19:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JL3pNNQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDDBC433CB;
	Mon, 30 Oct 2023 19:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698693635;
	bh=UPMZ+xQmEGa91GQ0MSguOeCpnzIle8Ii2hBLfbabYwc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=JL3pNNQrc2OhpvM+XF6vsbnBt/hiTjKLPv8fx+D3+eoy9c9Ooso1S6RLqoTZj6Rz/
	 ll6bDQG+rdmW32KLO5rltjz8BHc8nskbp4Ftcop3aL0HfptxW55IQ2oqo3I1ObJflv
	 EozGF9A2FuU+9VcvPEJWNoEkpfIMwB+bUGgas2O9syaQEuoHPqXMDZNW89LsqsXRd6
	 Tr6+zMm7o1Qakx/cBa/r2J4Pj4PdW29t0Yq07F8O/YwMnKKQdyNaUuOLSj1IlflgB2
	 Xtt1JiBr5751pVEbYK8hmEzD1X1vdOYR/8Ch/zq+FVy5XdZKocUW2s/ZRGGt3qIjm/
	 mRkUEh+PkryHw==
From: Mark Brown <broonie@kernel.org>
To: wangweidong.a@awinic.com, Nathan Chancellor <nathan@kernel.org>
Cc: lgirdwood@gmail.com, ndesaulniers@google.com, trix@redhat.com, 
 alsa-devel@alsa-project.org, llvm@lists.linux.dev, patches@lists.linux.dev
In-Reply-To: <20231027-asoc-aw88399-fix-wuninitialized-v1-1-b1044493e4cd@kernel.org>
References: <20231027-asoc-aw88399-fix-wuninitialized-v1-1-b1044493e4cd@kernel.org>
Subject: Re: [PATCH] ASoC: codecs: aw88399: Fix -Wuninitialized in
 aw_dev_set_vcalb()
Message-Id: <169869363339.44249.15683316983953713532.b4-ty@kernel.org>
Date: Mon, 30 Oct 2023 19:20:33 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-0438c

On Fri, 27 Oct 2023 09:54:25 -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   sound/soc/codecs/aw88399.c:441:18: error: variable 'vsense_select' is uninitialized when used here [-Werror,-Wuninitialized]
>     441 |         vsense_select = vsense_select & (~AW88399_VDSEL_MASK);
>         |                         ^~~~~~~~~~~~~
>   sound/soc/codecs/aw88399.c:431:28: note: initialize the variable 'vsense_select' to silence this warning
>     431 |         unsigned int vsense_select, vsense_value;
>         |                                   ^
>         |                                    = 0
>   1 error generated.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: codecs: aw88399: Fix -Wuninitialized in aw_dev_set_vcalb()
      commit: cba4590036855f4e3110d43c14385d2401080dbb

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

