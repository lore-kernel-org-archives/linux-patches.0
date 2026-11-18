Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.194.8.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041111;
	b=1PsccIDPdeprE4+fjKpYkxGaF3Iwg46bnudhNEq94HZJdRD6r+9aGED1eltECj+hnQMP
	 T6X1QBTpgMgL5x2zS7C4B+8x93WMcuZ4gfhmXgz2gGJC3fik6QJkLmVFai3zn/bEoHblc
	 pueVWG4P2R5c2W3dxWPeFqj8J4TLKzXbtHov76zjaqcrfWMUyi8e+8Qygycsf0PbtHhxB
	 20LVSxl7E4OvvCVJgaTdNrF+sMJF+jx2Y2aavEFYLtKZrFw+3cEX82MSFCI7OKYHhwNO8
	 VvjN3X08g06cca4kP4jfor+L6gWa+Vsw93XYFnTcmxjCA2A7+li7oAdNc2WnhQEfdbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041111;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=aDul+VgzHXJAnaDvASj93S0Y/BexSBs9fmx8vcZBfaM=;
	b=vQeDAMUBBYdY0udE/e4kgdJGbfQxd8qkrMZ/xetiA2lgXHDtlrs/NZJpjOEVttPK26iT
	 Ln2RB6SVDxb42dYynwgC4vlRerfb8OmLWF+RQmo5w7Cy3TnuQeeJSw3xonH+DD4iGaL6U
	 qLlRvzml3M4OKe0a2YhxxNWWkxFcCHMJHMxCuACz9FX21g1qXn7evuy1u+scm/F2H92ev
	 v6ybmR1BZKR0miCcZIkvXs8PHW+nfh0P4W2yyYikt/w19/cY6UTq5xtM2yf31mDhZYwqf
	 mWEQC+hIk/BqBrN2QUNAldMbD010AZTxIz/jCX1AEnY9jviESStiG+uTbbhhPmOEzsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=dolcini.it;
	spf=pass smtp.mailfrom=dolcini.it;
	dkim=pass header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=ZA67krL1;
	arc=none smtp.remote-ip=217.194.8.81
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F01E606A325
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 22:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F01E606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=ZA67krL1
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 517D71F8F7;
	Wed, 18 Nov 2026 23:31:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1795041107;
	bh=aDul+VgzHXJAnaDvASj93S0Y/BexSBs9fmx8vcZBfaM=; h=From:To:Subject;
	b=ZA67krL1mdo4kNiwpFYwe5iDzAplPx0Wri5p7q0pPeSOAbetJQLy+8wwvBaoynJLU
	 Wr2Q1wwKoOSHDjaGwK3zCkAOkShpDlo7jZc0J07nJ4VhR5m89KcHhjuTWM1Vf1kme8
	 I2wSZ+UYfgsPUQAOkLYxUUbHrRxmmCBY7fHh57ZL2a61hswJ5u3WVbWNnK015JD5Oa
	 tJBQWSuiOxe6mW0vyyECkKfINRpUWjBfNf0YgoBE7/vBhVvX50pJA91QdkHEXzq0I8
	 wVGns+7TO63ah2RMSp66VF7QBMM95Bq+pYYUv9gSxDqYmELiDDP2RBpBd4rWuCayaX
	 XXOFY/vB3nqEg==
Date: Wed, 18 Nov 2026 23:31:42 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Aristo Chen <aristo.chen@canonical.com>,
	Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 1238/2651] phy: freescale: fsl-samsung-hdmi:
 initialize default rate
Message-ID: <20261118223142.GA597634@francesco-nb>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150332.571312313@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118150332.571312313@linuxfoundation.org>

Hello Greg,

On Wed, Nov 18, 2026 at 03:41:18PM +0100, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Aristo Chen <aristo.chen@canonical.com>
> 
> [ Upstream commit c01ccf91b257741e9edc374a465126bae9ae4711 ]

This patch introduces regression in any RC release, 6.12, 6.18 and 7.3,
please drop it.

Multiple people is affected, and I did send a revert 2 days ago, see
https://lore.kernel.org/all/20261116162409.218059-1-francesco@dolcini.it/

Francesco



