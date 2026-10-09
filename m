Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAE741DED5;
	Fri,  9 Oct 2026 06:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526705; cv=none; b=tVFousbow1xCIs39MUmKVer8fm8MqNQfTKuNTsOhnmkbmwY4Ropi0EP0tZqCI4bX3lL6QdKwCLuGb3lHPPbh30Oh7YBmndBokntyLS/XEp2jT4qFK1iEWnYZURw45NDYb9cH7w/DCglRrXaYCFSkVxRLoXqJeBezAnEQpMfDuUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526705; c=relaxed/simple;
	bh=eyjhEMclw03xo/8402Gw2AMd5tL3tDFmApe57xxcQQU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=t+Fx3PgpNIBUrha3RsPMUt+N8YaDZWj5GehVxDLkm46moK9b/A1dM9ydaKFuINgCgU/ZLwUTu4mlR8xuMNq0vaU76Q2oFVAN8rJ+LIjb7iGjS+flaLBHrjRfHLKbx8y9Qkzq1XJKSbH2hlGr/qS1T9r7pox44fvlmURh5wwlZ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kN9+z67M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kN9+z67M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D259F1F000FF;
	Fri,  9 Oct 2026 06:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526704;
	bh=iBwxYr2ziMnbq0l3WFfSK57WP0aL3t7jC84o0ZEXv8Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kN9+z67MydvZj4Y4Mw04wot1Vw1d9poise2EhZ88gyFItjszD2IqwhHF/HOkxhwXc
	 4BECd3siIfbDkfGox2kJJTnXtCzcQWetuV1yKlFPJjZVV1CdJUCXglsu+8395XJh6d
	 CPrUYIS7ErRtm/KyYD4hUA8WEXHbg4alwXp5wh9N14nZd3Du8Yv6P1ra8HSY7ZHFWX
	 I5eQTjkbazXoVKTwBNQgIQ5nawPdQ3Cn9Rmnz8DPOErBDKqrspNukWKkpORiIK425/
	 nVTlLSfquqDerPCo8jdefvKWLK+VFcZSWphBC2SQiJy+oWnq2Tl3cXXmMwaCRsa1oE
	 Yole7S6/IwreQ==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Cc: patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>, Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net: natsemi: xtsonic: make probe function static
In-Reply-To: <20261008183013.3223131-1-rdunlap@infradead.org>
References: <20261008183013.3223131-1-rdunlap@infradead.org>
Date: Fri, 09 Oct 2026 08:18:21 +0200
Message-ID: <87fqyfs8gi.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Randy Dunlap <rdunlap@infradead.org> writes:

> Avoid a build warning by making the probe function static:
>
> drivers/net/ethernet/natsemi/xtsonic.c:200:5: warning: no previous protot=
ype for 'xtsonic_probe' [-Wmissing-prototypes]
>   200 | int xtsonic_probe(struct platform_device *pdev)
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
