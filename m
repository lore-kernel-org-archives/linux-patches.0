Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118B428DF20;
	Wed,  4 Jun 2025 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749043446; cv=none; b=upBqJV/a0p7K6VO6jrafASERr6kTTrSRxNn6IE0JpGDxaFchvEzzHlQqZoCzStT0a1OzKxWJ3bkFsHW93KWPUnLG85Osl5r+C7kWHYrDujIp8hJBfCG95u4I7Rgp2wizWFl2wtiubUiQ5RYCjwzYJ/6E1VbiWu/Fcbm5e3l1n6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749043446; c=relaxed/simple;
	bh=pRvlaKiySBQfbvRfPG/FgK5mXpZgHM4sdEQU61PDsC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKqtOTzBfblsiAAhySOKzwzJ9bBAZXraT8t0N/r3QBFIDImtyvHZkMXPnRGyL2I1kDhWLol4wVm/3zVqVj4zcdv/AaL/Q3A0JlFrJGYzIsdVefI9vc32FkpMp7Ip/09/Lk828gWGSEfigytHthFE6QJgdw+5eKBEKiuwOdDa/to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSDKrD+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSDKrD+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AFAC4CEE7;
	Wed,  4 Jun 2025 13:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749043445;
	bh=pRvlaKiySBQfbvRfPG/FgK5mXpZgHM4sdEQU61PDsC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aSDKrD+KOYl1PW6zbrdOAilee+4o+4Fb9ghaC+nAIXuKX64R12k8kFJ5CjdlkSXk7
	 q5dLWtr/MaX63uBpG71PXu0ldy4XeD9BaPKDDKRZhzfvLwtji0lFxo8TOuOirCIRxO
	 WRi7SLpcBk/MKoVvV25Q5Stv8uwhnmlnPZZXIR5w=
Date: Wed, 4 Jun 2025 15:24:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 6.1.y] arm64: dts: imx8mm: Drop sd-vsel-gpios from i.MX8M
 Mini Verdin SoM
Message-ID: <2025060442-doily-smith-1e00@gregkh>
References: <20250602155845.227354-1-francesco@dolcini.it>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602155845.227354-1-francesco@dolcini.it>

On Mon, Jun 02, 2025 at 05:58:45PM +0200, Francesco Dolcini wrote:
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
> ---
> 6.1.y is currently broken on imx8mm-verdin, because commit
> 5591ce0069ddda97cdbbea596bed53e698f399c2, that was backported correctly on 6.1,
> depends on this one.
> 
> This fixes the following error:
> 
> [    1.735149] gpio-regulator: probe of regulator-usdhc2-vqmmc failed with error -16

You forgot to sign off on this patch you forwarded on :(

Can you resend with that fixed up?

thanks,

greg k-h
