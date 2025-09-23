Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D482B2F0C64;
	Tue, 23 Sep 2025 20:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758659818; cv=none; b=E8b/O0kJyyh70IM6WSdW0uklOU8hWwjMzdoGtKREcDYSueRxRAPgctciqjG11fWnEf0rlXFp5q+FJcNyKs3P3gp73J/mqJcDG4T/xo2IjeB2ul+Acfib0fZ0bZcssc1YrxX+OjN3aOtJNCogR2evlvrdP7n8cGVVfhpjsR2zHqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758659818; c=relaxed/simple;
	bh=DOz7VuELm/9+CGwRk7bVv7KPATKmmKGHPEqlft/wt58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk3FdkJuHyzj443Cb9hKlFo788upkyk8RZ9Y2nFzh/uYkCEuP67d1pP1KQvNpPtxoEUdXqrPOi/v49KkU4aE4nzRm77GbfeP07dnbcVOFK5lhP7cEWQvAnTlG5ub1vA0Q4KeQ/ak2aPYCm3luLqQLCUozaYJrSSpuFiZzQNaxOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0ZBzGac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0ZBzGac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F8FC4CEF5;
	Tue, 23 Sep 2025 20:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758659817;
	bh=DOz7VuELm/9+CGwRk7bVv7KPATKmmKGHPEqlft/wt58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0ZBzGacSCcZjz4F0Tx5xdDvV9UPvxUKobZJ5LgZYVJq+8B7vN4tIiPfGhzxsObw2
	 +/mJsCY07yBCB376X/rSoKtMaC4opsZLfmkg19aVU+XMV9GpNGd/In+KOs+GuijbHD
	 Ofh3anTJSWMBqsRPlsLv/QvhMJks8y89nJjHs38YNbV6IoueS7zVlwxmeyr2hNykyI
	 7QtygcrwOvd8y12rOs8WB1/TbhXcY7dJ6xoFBkc5CMcvSKv1ooXNy4aqj1cPMnuCK/
	 0Y9hurqZjF/S04hrRtUnVL9yW4UzA9wrwrUR+1Alb1htIqEu8zZB5bnRVYzdaUnc/E
	 MW2JKCp+nPwjg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 00/61] 6.1.154-rc1 review
Date: Tue, 23 Sep 2025 22:36:38 +0200
Message-ID: <20250923203638.690888-1-ojeda@kernel.org>
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 22 Sep 2025 21:28:53 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.154 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
