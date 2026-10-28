Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221475;
	b=Et5Osls77uBqni2A5Fc5FVbJy7+CNqT1h7T9Nx6KvXEaxGqc57UDerJWx8a7plYiNTeB
	 W2LJIFLqo7yJkRGJTH6aYLTmEMecRLGVvwT5jXFsHDVnKZbDA9amsZmt41R80egmvOxVp
	 D9v0B9jVP6f3UlgnFC/z75CEwSv35vD+kYHT7AG7BxAOU+S96JrJ81p39E2F7cFws3u5Q
	 y67jCdpiYYjjIThjgU5CdCyxmGG8T9/AsmKEnUokNvvhz8pr/5hZloTaftjam8cXio2GN
	 u0baOZxTMTCgsQXuDlGCadFEDprf+np/gzABCsE6blSr+VhpzNbgz4fzP/zRvgMz2eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=EMYPMS5FO1bwNUoeczH2HUUreu/6T5PLlD+DKwBPIWo=;
	b=b4WO29l5q8ZtUldMnnZ5gZhUS2gr9cBL5LCnPvHezDifYwoGRkEOjkG1Klu+COjZzQEU
	 rtosJWgIdXfLuEjEpgZHIuhbVU4zuXk6mkqYy4wtFTFQP48lXCY4OuRyfKt8YZZZrLFOr
	 /4hs2OFI4SaWI/+i+UYnkqKbeC3aJOZELB5sCH1tGkF0TRGQ4oIl69VN8doeAXzcloXvd
	 u8yAqJ2bX0eBlHlfZCajNtHsN1VSp0nT5y0d0/us8FuGtrTwvV4TQjVf8Rm98Vd6Ftwij
	 cbhp9iBeR8V/rzILflUsROSrO/gJLggm76xfBc16Php/w2PAZu6nEForKHy2CMMg9pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T5jGn2Uy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7AF606A31C;
	Wed, 28 Oct 2026 21:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T5jGn2Uy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEF51F01825;
	Wed, 28 Oct 2026 21:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793221474;
	bh=EMYPMS5FO1bwNUoeczH2HUUreu/6T5PLlD+DKwBPIWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5jGn2UyEkA8BDqyiSluS0fW9XUoYBNbIWU+LwRgRzxntOVRER+isjJrvyeJ5dOiK
	 SV9tSi2musBQcoaACMjgljbKfviy+euPxbf9Y3Env5gf+/NqRQRLdSLbPT5+LYN945
	 MvQVyuyb/FlomK4m4CKdnOe0fxy+U0wTcYFoCF4KGwRJBtCse14MGp/t1ATD4KX1ap
	 gBTY9yFUdakNV9SUs8xW5lZ65Esg0gEBv7GxSTCB0StvHR0Sax5YXthBsHp1MqSfdK
	 lWoKZgPlkrJFf6GCG3nmGpq1RjPhOCvqga5UDm7tln+CGgwbr1dLMZk031giQTndjm
	 LrQvK6jOQcToA==
From: Sasha Levin <sashal@kernel.org>
To: Aviv Bakal <avivb@amazon.com>
Cc: patches@lists.linux.dev,
	stable@vger.kernel.org,
	robin.murphy@arm.com,
	ilkka@os.amperecomputing.com,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] perf/arm-cmn: Add workarounds for CMN-S3 on Graviton5
Date: Wed, 28 Oct 2026 17:04:32 -0400
Message-ID: <20261028210432.2386109-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <179250706537.3484860.18363532452101434862@amazon.com>
References: <20261019135441.1420968-1-sashal@kernel.org> <20261019135441.1420968-145-sashal@kernel.org> <179250706537.3484860.18363532452101434862@amazon.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Oct 20, 2026 at 05:37:45PM +0300, Aviv Bakal wrote:
>Please drop this from AUTOSEL -- it's new-silicon enablement, and its
>parent commit 56603c28d916 isn't in 6.18.y, so the static_assert in
>arm-cmn.c would fail.

Dropped, thanks.

-- 
Thanks,
Sasha
