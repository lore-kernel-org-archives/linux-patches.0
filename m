Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5099175A8F;
	Sun,  1 Mar 2026 23:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772408916; cv=none; b=uSfb/He5ldyS7Z5kZeYdJUcywOSnia1HQ1VGBuYAcYEsizsbjjlV1EILVNLPk2knDlJmCEsAXPqZYHDJdBd+jQMiUkN8JBoXGqfW55wpN/b4KxDvzv9ZRdzIUlZ9me0YJy7Pw0AmZiecOmH1UeoLMYKeUTRlNq2FR/IOOTdgiiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772408916; c=relaxed/simple;
	bh=WwQ2DDpoaNtJHXhOnaPhMLbDz5hKG8b6mYnmYF9mTX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRjPs9mkMaztbTIuBPpuvua7jfPxtIY47++xNEp/0QA/urrlEylr40s2C45scBXPHQfBJyeBHWXisGVvlaBPymC354FkIwF+0LSDagLKfkC1nAPa685z/v09MOTHjvtEMVQKU78XTbE3bPI/Nm9p8rAoQRfM9ZUD77sS8QWj1Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rbIfMhrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rbIfMhrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0805C116C6;
	Sun,  1 Mar 2026 23:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772408916;
	bh=WwQ2DDpoaNtJHXhOnaPhMLbDz5hKG8b6mYnmYF9mTX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbIfMhrsYHXSGF2wNsLonSM0X41LJ8egS+CGySUP1q2SWJ8yu2dlp4X5+ZGMiDEpZ
	 gFX14S06Lh5FrU/hJdKwkUhjtJ8NzfGQ9uKCYVemO04YcsbD5fBmlx9y4C5v1zCRMB
	 CkuxdMYQfnb02Cd70yy3GO3+yVKBbiWJ0TaPOPrY1XqD8I6EEW2LB/AdktuY42cy1f
	 jFHbS9wWnjkMu+ZCpUyd3wzdxfHJ8xZTK3RhvWikq6kc6tSXtANmoa7jvZBFNTPtWt
	 8rpOrBsp3DgWQ0ncLRUeEWKVxRBgZuo02kJNQqa2K3Bxaj8H5WwIZlLJO2gkS+ZnQe
	 z82JB0eloFPbA==
From: Miguel Ojeda <ojeda@kernel.org>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
Date: Mon,  2 Mar 2026 00:48:16 +0100
Message-ID: <20260301234816.196557-1-ojeda@kernel.org>
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
References: <20260228173244.1509663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 28 Feb 2026 12:18:33 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 844 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Compared to 6.19.4, the `COMPAT` build error is now fixed. The other
warning fix (`unwrap_or`) will still take time to arrive.

And like 6.18.y, I am seeing a trivial Clippy warning on Rust nightly --
we will most likely send the same targeted backport to clean it:

  https://lore.kernel.org/rust-for-linux/CANiq72nWYJna_hdFxjQCQZK6yJBrr1Mb86iKavivV0U0BgufeA@mail.gmail.com/

On top of that, I noticed an `objtool` warning in loongarch64, but it
happens on mainline too, so we will deal with it there:

  https://lore.kernel.org/rust-for-linux/CANiq72mAQxbRJZDnik3Qmd4phvFwPA01O2jwaaXRh_T+2=L-qA@mail.gmail.com/

Thanks!

Cheers,
Miguel
