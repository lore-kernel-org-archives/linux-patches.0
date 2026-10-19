Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06C219F40B;
	Mon, 19 Oct 2026 00:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792368863; cv=none; b=DD8lu6D3lVqPcZSeK8ztIPd8C/43E1pZzp67RO9hrGF/6Li1D80OkmcokoGDQLImXfxsj6celCxvAOeiGEIJLOLxi9xsrRl1fC+cKJ2MXSQBvWTFKn3n+egPyM+lQsPYtzItsUvjUM8qFVvt7WsbXblgCIP3yk/xmaYdAIZEyZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792368863; c=relaxed/simple;
	bh=GiIOqfrFzCMBf+V5v1PGDEiZ71ZjG2EWN6OYiElQyJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ3mu51VbMf0nzpuiiZULNz4qtqwjD8Nr+NYGvAPrhCncDmjDt4UPK5HFPb+ieIeevIGiXIi1eas4HfcO1GhH/cZSL1q4ZCRP72yhHzePEtWH8KZDnw8dGbt+vPSzTpERoQCLBq4rvF/G5fdecH0S4UwZaaf4L8T+UpdnYdklyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIUP+LKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIUP+LKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65091F000C6;
	Mon, 19 Oct 2026 00:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792368862;
	bh=lKspkskkQmk+Bi0bnoCdzA+YUBvleRnu0FCCGCl+QBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIUP+LKy6IYnjeRR05BnKtJk58Za3oufBp9f9ww1RHL8jPbRBP5jg6W5/8rPJjaLZ
	 Sbv0iAbjQ3f9lGG1Pxbmn9wFtGPRfF2PoQZ5ByuzOzG7mZYS1UOfLgKjVVKYGMCi2p
	 mG6iDfRNjVqZXkH7dHAPDVU6XyiEnw2sMdYPnyTxglcJF6ieRVx46bvcnF/lhDK85f
	 ztpXQdIayHL2gl1Ba77yXBgX6rem2sbTcqjNpJiupB9+Z9NeGCF+IAHZBIJU5m8+QF
	 3Y8C3tvlF71wivL4h9vQsjN9nA5HN2zCwuMB5qOrKtEdVzoqUlHzPG5GOlMXTmrvoT
	 lHDY42AZk2HhQ==
From: Sasha Levin <sashal@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 6.12 696/869] kcfi: Rename CONFIG_CFI_CLANG to CONFIG_CFI
Date: Sun, 18 Oct 2026 20:14:13 -0400
Message-ID: <2026-10-18-1-daily-reply-0002-kcfi-rename-config-cfi@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017194548.GA318740@ax162>
References: <20261017160036.979869304@linuxfoundation.org> <20261017160054.817469217@linuxfoundation.org> <20261017194548.GA318740@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 17 Oct 2026 12:45:48 -0700, Nathan Chancellor <nathan@kernel.org> wrote:
> I object to this being backported in its current form, especially as a
> "dependency" of the listed change... The transitional keyword is very
> much needed for this change to avoid silently disabling the feature
> across olddefconfig. Either backport it as well or just do the simple
> thing and properly adjust 52fb1756ea1d for trees that do not contain
> 23ef9d43976:

Agreed, thanks for catching this. I confirmed that with the queued 6.12
adaptation, running olddefconfig on a .config with CONFIG_CFI_CLANG=y
leaves CONFIG_CFI unset.

I dropped 23ef9d439769 from the 6.12 queue, along with the two patches
that depend on the rename.

-- 
Thanks,
Sasha
