Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB81C1E7C11
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 06:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750660909; cv=none; b=aa1zMj2AP8ItNI0DhWtze4FIrSKxWev5Yj+LEEt3b/6F9C4dlXZgfhhIXcyHfgyJhR/8GunKvhgKjZH8gBmRf3v1Saw1lQGvPPDgVCZFAvjS6Lm4Ei54BukhP+7O8YLM+h5CtxxzUzbfCHGEz9pTqdlx5jawRM5t1LoqxVboNUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750660909; c=relaxed/simple;
	bh=LB4oyVTpLCaiEWCy+fk6tCbYw2++tKJbaBq/0UJGbXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d06zgxd7W5PznykIBpvCx5DgZDwe7p8Jgu0pCm45kidaX5nRFNAho2H/96JM5Z4ap9GMrWnVtP4DqEvt8ygHdtIUgTaX0SC8y6jN/oXnpTzDj92HGC3K8NLJECmFcaa5NtNwFdn9p4g5SHDoSL92WlX0ME56pIsETTmX2JxcmGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=OaU2DLIa; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="OaU2DLIa"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id B42521FA9E;
	Mon, 23 Jun 2025 08:41:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1750660897;
	bh=P4VY0Ku8UYAmClA1iVtBk9nLVcQ0Z5Yu7AkLFRkF3fQ=; h=From:To:Subject;
	b=OaU2DLIavBehEXG2Fczs94N5gsZGKYRXMp+jBgRkSPQCybVLg+PDt+9Be71MdBSf6
	 WWO4Imrz10O9tdK6p8HovDurFhyF3Z3H/0OzaBSPo7hk5TP27He+GDIMUWya+CFGKN
	 Cy4eA5bvZy9vnSN0D/KhQCczB5Sro6iM6AwWzH60m4uNhwa8+Xp2bTYOYEItnwY3jU
	 KpYqMROZYXon5g9oKXGegBgS0cZUiJz/0Usv1n5R80ud6h5/ySnRTjx0CKgfd0sAmD
	 ojAvR4yavoVdXbqxpxkyv/HY0+9RfV5tmOlz13p3Y5RVX4hD7qUlfnJWHyTljdmWVO
	 ku1i17K1N983Q==
Date: Mon, 23 Jun 2025 08:41:32 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH 6.1.y v2] arm64: dts: imx8mm: Drop sd-vsel-gpios from
 i.MX8M Mini Verdin SoM
Message-ID: <20250623064132.GA7788@francesco-nb>
References: <20250604212401.8486-1-francesco@dolcini.it>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604212401.8486-1-francesco@dolcini.it>

Hello Greg,

On Wed, Jun 04, 2025 at 11:24:01PM +0200, Francesco Dolcini wrote:
> From: Marek Vasut <marex@denx.de>
> 
> [ Upstream commit 8bad8c923f217d238ba4f1a6d19d761e53bfbd26 ]
> 
> The VSELECT pin is configured as MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT
> and not as a GPIO, drop the bogus sd-vsel-gpios property as the eSDHC
> block handles the VSELECT pin on its own.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Just a short ping on this, to be sure it gets queued for the next 6.1
stable kernel

Thanks
Francesco

