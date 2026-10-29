Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299443;
	b=A2cS9kSrr+raN4eG7LcVUOpqgAiC8pweAvfk3IoRqLWRD7hNi92yyc6vX084KYlH0/76
	 A3yDvZRghyJ5OXCZJzzcTNzVwQhNV5ZuKgbITN5xXHCcYIM7VVeAtN+ejElt9IGZztal/
	 NNHuugy1qvD+Ck1YHw2FTI8v0QmcjQlE9T84HWAQEl8sscBucpacRmgnrTr2AjtnAqEFG
	 1eJfSz1Jc0nL4w3swz5CFLFuQnRz9B6ohlSK5X37IEDp5ANPzWPMjb7awxtEtnYX5Ibmb
	 EY9orAcL+UgJtmYtC6Bo4W3ntONANvaWSlBlIXZBgzWQzVSiF34JS9V1MZh7vpsB6zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WJeCOUjKD7fEGZgpZ8nq0Eoz0qh9XppYoE37uBgsdzY=;
	b=BbLKhXj7iweracy1bDAbtKm3hZMo4ExKxHL54luQ/SqEKoKPa1y0OOINWGHhLpPmYipf
	 eMlNqXrWlYYahwjbLSmzswX1wnw8wswWvV/9uLzKLK5LZ/uFiory/CEMtvT5y/T+FfaiO
	 8qb0ST5EJrUZuubgZz6Bn1nkkz3gaACSOTFsjD71AFd5pztA1Kr5Dib4+jUeXFMv0zW3Z
	 USucMQLrwvoD5bAuy/HuhU7OR9sozwGgdRHaZ7Fm/6te8WYocIzoW3g2e3ETNc+rEPtdY
	 VO7bA4LF1jGMUfqc85rU1TTprbIsOCuA7fqHw0GWk/0BlrAgX0DzUsXow8+rkUMlkLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iiXqB3oq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1212260A262C;
	Thu, 29 Oct 2026 18:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iiXqB3oq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55521F01281;
	Thu, 29 Oct 2026 18:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299442;
	bh=WJeCOUjKD7fEGZgpZ8nq0Eoz0qh9XppYoE37uBgsdzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iiXqB3oqlfQhhd2E7AjO1TtVHvtRiJXWP5QNwar7+tAbOGEwZd7tqlkWMeJj2X5Vt
	 UhftxKftigCbaYBFzbcbWhPncEEVuI2M0feCaT2TfctCdTbaVJb87F6ljsch/4bE3+
	 UUR6CO4NCKJtO19bplG9E3mtXKKeWzrL04hJ8rFEQn+mDviXf/b7NnCYBRNyOIcQQ3
	 VdiEBEBqs+5SelXZOr/hP5InN8edVhAOTsKqctrTnOmPUjmsHT5q83maJjWpY6DVhU
	 tuooHMzSDTQ7Cotb4X0GssbJp8nzUcai8G0fPCTL6lSdpzhXeKN8KxqcBg7/vh2zoC
	 f5oaCT/VA0mdQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 6.1 1131/1887] netfilter: nf_tables: Extend nft_expr_ops::dump callback parameters
Date: Thu, 29 Oct 2026 14:43:31 -0400
Message-ID: <2026-10-29-1-daily-reply-0024-nft-expr-dump-reset-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <auMz9PJyYo-7FrTW@orbyte.nwl.cc>
References: <auMz9PJyYo-7FrTW@orbyte.nwl.cc>
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

> Not quite an objection (the "no functional change" still holds IMO), but
> I don't get why it is being backported.

Yes, it is only there to avoid a context change in nft_byteorder.c. The upstream
fix 18014147d3ee ("netfilter: nf_tables: fix dst corruption in same register operation")
has a hunk there that carries the two-line nft_byteorder_dump() prototype from
7d34aa3e03b6 ("netfilter: nf_tables: Extend nft_expr_ops::dump callback parameters")
as context.

-- 
Thanks,
Sasha
