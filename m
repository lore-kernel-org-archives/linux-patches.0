Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EEB1C3F;
	Wed, 23 Aug 2023 21:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B352C433C7;
	Wed, 23 Aug 2023 21:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692824944;
	bh=OF5HJLG5FzsNNhmPY/VyYpOOUEVm3L9+q1JsGFn1ulc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=OlF1Si3rIqIafTdto8/wWcEkfcJW3vMy6f1dXKj8rC8vDSkwCRZARXc8pFOpHcGAX
	 J5EUQvKgGyA2fRcpDucTMc4/V3k604hVLHApj3UeaI/eGyIU00RlhyaJBSz6TT4MLt
	 EvY2XwnGU/GoLcbz5Iy/VrJPyWH17b2TZGWyV1FMaKg8SywCUy2HlB2oIt0t5QcEnb
	 txsYqO9AJad/5by7hrKs0sFTxNqg5giCqJK1hUx5mrpzBoCKpwsXCyCDCvIhPlLp78
	 Wovg8OZsbvZ1lR8Fy8fopf8zMJtuQtgIHgybFhnGJHyUpE8zmWX3oZ+89/D38Kj8wW
	 ylsxKr7FnWYVQ==
From: Mark Brown <broonie@kernel.org>
To: james.schulman@cirrus.com, david.rhodes@cirrus.com, 
 rf@opensource.cirrus.com, ckeepax@opensource.cirrus.com, 
 Nathan Chancellor <nathan@kernel.org>
Cc: lgirdwood@gmail.com, ndesaulniers@google.com, trix@redhat.com, 
 alsa-devel@alsa-project.org, patches@opensource.cirrus.com, 
 patches@lists.linux.dev, llvm@lists.linux.dev
In-Reply-To: <20230823-cs42l43_pll_ev-init-ret-v1-1-5836f1ad5dad@kernel.org>
References: <20230823-cs42l43_pll_ev-init-ret-v1-1-5836f1ad5dad@kernel.org>
Subject: Re: [PATCH] ASoC: cs42l43: Initialize ret in default case in
 cs42l43_pll_ev()
Message-Id: <169282494202.183189.5510150432042109830.b4-ty@kernel.org>
Date: Wed, 23 Aug 2023 22:09:02 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2

On Wed, 23 Aug 2023 09:32:50 -0700, Nathan Chancellor wrote:
> clang warns (or errors with CONFIG_WERROR=y):
> 
>   sound/soc/codecs/cs42l43.c:1371:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>    1371 |         default:
>         |         ^~~~~~~
>   sound/soc/codecs/cs42l43.c:1377:9: note: uninitialized use occurs here
>    1377 |         return ret;
>         |                ^~~
>   sound/soc/codecs/cs42l43.c:1349:9: note: initialize the variable 'ret' to silence this warning
>    1349 |         int ret;
>         |                ^
>         |                 = 0
>   1 error generated.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: cs42l43: Initialize ret in default case in cs42l43_pll_ev()
      commit: a74048432fbb30e7a574747f6e1f47aef17010b0

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

