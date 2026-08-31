Received: from mail-106118.protonmail.ch (mail-106118.protonmail.ch [79.135.106.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4D944A708
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 14:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788186343; cv=none; b=Dg5T4H4gPtXV0RCjou+aFulWLW9leLuSyNlUleMvYb9F++7bjUbqVlSHIr4ItQUY5u+F4WKfAR3o1YLRyE31YSzcVo++NU2VaA4W7gUPe7aNWpVgq0BtWPQ5phbD1y3amAYnXNZzDMpORLtnN7rEg3qEJBtDB/BrXSx7+C2P7eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788186343; c=relaxed/simple;
	bh=vZw0hLL4dSeqV3jSVMA6jvCgpb5+g5wnq9JcTayBwm4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HLRdSCjxcRt65dYluP7qD1ZQLBa7BPqXp03TBR6EnsnSt3AEnfTNyFvqMWSAvRlQlKfMHGV97V9fdEEXmAZNjRYLefRr6d5lVu2qQQc6kcdDW4MrV5ArPaPdrTiYcRYH85muBRUBUYKdIrDatYEi9X89iI+JdJDv+U3wYMzwYBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=fpCt/fdg; arc=none smtp.client-ip=79.135.106.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="fpCt/fdg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1788186333; x=1788445533;
	bh=Am4U/GdbWSNMOv42LsGji8ij2jzfV8TWsw2TXnhE03I=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=fpCt/fdgDy4/Qye6+As96aJ/KQKYVB5hKdoBlWvpBDgcbiuMU8mgG5UlKlVSTrjIO
	 XAvfUA2B0sIfgkMQA7hdJpDROCvaheLLycNXMTZ5SlONidGSggHzvpGa0aJB0SalYl
	 822Zi13vlO7spldtmnd5eQIsw+cHdwxMT8uH9xrdn9vM0pK5vyAWL3d0uskcah0Slb
	 7yz2MUriPFDbHGxkDgbpGNjBM/VMbw2p8mHrnyP8GF3x8L4WkK2aRaTyyz55OXFgC/
	 Rr7LrrKyN333FFAfn8gJE/9Ldslu5WJUlM+VP51P/LdmFRJxNU713khO7Nbb+Q6f80
	 p+TsjwW4As23Q==
Date: Mon, 31 Aug 2026 14:25:30 +0000
To: Sasha Levin <sashal@kernel.org>
From: Sergey Lebedev <lsa.uz@pm.me>
Cc: stable@vger.kernel.org, Mark Brown <broonie@kernel.org>, patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] ASoC: rt1320: run the initialisation preset on the first hardware init
Message-ID: <20260831142522.85439-1-lsa.uz@pm.me>
In-Reply-To: <20260831133314.4125787-601-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org> <20260831133314.4125787-601-sashal@kernel.org>
Feedback-ID: 113843758:user:proton
X-Pm-Message-ID: 67733ea88f02bf58460191b0df5284c8101e7578
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Author's ack for the AUTOSEL 6.18 pick of

  ASoC: rt1320: run the initialisation preset on the first hardware init
  upstream 9b30521074f01aff856f539c1241a48342b69f7c

Appropriate for stable, and the reason is narrow enough to state precisely.

Without it the RT1320 on the Microsoft Surface Pro 11 is left unprogrammed =
on
every boot: its SDCA function status reads 0x41 (NEWLY_ATTACHED |
FUNCTION_HAS_BEEN_RESET) and never sets FUNCTION_NEEDS_INITIALIZATION, so
rt1320_vc_preset() and the MCU patch load are skipped. rt712-sdca and
rt722-sdca already carry the first_hw_init fallback this adds.

On the risk side, which is what matters for a backport: the added condition=
 can
only cause the preset to run where it would otherwise not have run at all. =
On
hardware that does set FUNCTION_NEEDS_INITIALIZATION the behaviour is
unchanged, so a later board revision carrying a different RT1320 -- which B=
ard
Liao noted is possible for this SKU -- is not exposed to anything new.

Tested on the affected hardware. With the patch the amplifier reports
RT1320_KR0_INT_READY=3D0x1f where it previously did not, and audio works.

Sergey Lebedev

