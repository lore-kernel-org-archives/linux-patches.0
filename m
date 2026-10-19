Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428889;
	b=oFOMvxUNlQjv0f57jbqKrkXzlm9BFjdUYTLn2SR4joBngaye7F7MgitR8vWoo2ypLg9D
	 nXqSAvX83LLJebpKGKVBQlLuOFTZQgGmo04QfasVXk0kNAkIsGR8cRjBc0xjZ+sweNxbb
	 bnd9oZeAkuQWKkeatPLUTRfKOORvi1/GqjFlhoerqAoMa4Wcg9FoqWfxn3i9mPLpsKqB1
	 9l0jSircos1zdVgDFm/LavFfVMkug0srzxLRydId/LIE8AqmMeigJfmtzWKufq93DtxXc
	 kpP/vrZQazUcKlY9cvBxnzgohHBCsTisyAWDKrayIGy7f/jatiQ5vd+JlNO3DVoGmgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=eWKprZGp9xOhbzFtnXXnWxmjQyyqaM2s5HKEF0UwXqo=;
	b=BlZWc/XlkcxTeIZi/nceK33UmIIRIUsOhYfjr4LTHFzfLpgGuM/jN364mkLLabjyKkig
	 ne3jiNAjBtlvpUNB4tDCh1sSSThRldiG6mcmsS6z8kRLgJP1CNjd6yQH27/7EBL7U1DpE
	 khUf0qX0p14nlgEOgift3GbnS0HZqfVzK9XI1IF580TlxqBJHblrHj7FxRlridNvmFqCV
	 ckVIacMGyxOALVRHSs+uzC9xdBzotZhl8iC/nFPOCmnbqbpPw6VmJ1lxROZonJ3Wess6T
	 FLvbzbjaM4bu382nlxVNIRSPGszjHXMXQidcqHtSt6V3JZG1lUfjHxz5YmoX6C8igtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dISWeMBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B2460A2602;
	Mon, 19 Oct 2026 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dISWeMBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67A71F000C5;
	Mon, 19 Oct 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428889;
	bh=eWKprZGp9xOhbzFtnXXnWxmjQyyqaM2s5HKEF0UwXqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dISWeMBw5d36ciVRzrtUdZNJ/7F0we8/HSvaG3qTV0vYTOS2y888ahJLuj0S+o0eI
	 B9429i9IQkVdmJVATi5+94yRGgFyTxCZyxyDlZaBFaKkIZ8TxEHbe8B/86jCIYIr0F
	 coKUx3j4Fuukr5Un6c12r2H04ue2Ya9DDV5+VSXcTKBs1R4itbZa9Yr5JnJzb14EGU
	 bhEqu9jIRvNoN4dUejSLJvTL4Qi/v7whU2o9UHnSSk0Ol0SdQ0JhT7K1xdw6nF0TvR
	 btBFTc7ujbfSlzl12fTxHxNWyC6WxTgbD6IiGvIy3yyVTBeHGI+8cqbcjYM/iCW2d+
	 Svtu9ffEjX/5g==
From: Sasha Levin <sashal@kernel.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	linux-tegra@vger.kernel.org
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
Date: Mon, 19 Oct 2026 12:54:30 -0400
Message-ID: <rc-reply-0002-a26fc6391c09@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8e765406-3ba3-47d7-bba6-e15a2cb56857@nvidia.com>
References: <20261017160431.119607952@linuxfoundation.org> <8e765406-3ba3-47d7-bba6-e15a2cb56857@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, Oct 19, 2026 at 11:18:07AM +0100, Jon Hunter wrote:
> The above commit is causing the following build failure for ARM with the
> multi_v7_defconfig:
>
> drivers/mmc/host/atmel-mci.c:2661:31: error: ‘struct atmel_mci’ has no member named ‘bh_work’

Dropped c125ee35a49a ("mmc: atmel-mci: Fix use-after-free in atmci_remove
due to race condition") from the 6.6 and 6.1 queues. Thanks for the
report.

-- 
Thanks,
Sasha
