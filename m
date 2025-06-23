Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEC9BE4E;
	Mon, 23 Jun 2025 06:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750661262; cv=none; b=OC0c4BpkpfZm9PetwgfP1njskaQHr2si44cmHPHdxxF/eQK5tIYtCeZnA/bW1d8G48QZIXqkJRDJ2opXntl6fPlHD1xY29kWAB0gdGY5G6XxcTKtI3bsR51OdJP4efAIEQCnVccI2Q375v1riiIi52B1KD0MbycmZv3PZPBNFjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750661262; c=relaxed/simple;
	bh=Gn837mX6w8WPQ8SwBue8RMOzUhYMNFiDvKsbSLr45OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOpgrGSu+w/XjP3bHH9X/STmQ8Zb0APvbmBr1D5KhpX/fluSiFZpb4SIMQZASKNtLPzWxAQgtnwpvUn8qarhfft2R57Xutv3M++kM9PljiybsnYlOj6NB7vCMK3o6/0OX0rXWFwbHzbYqnYt0JuoyzCMKrgdUfdhsxvph0n5Syk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+2ssh9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+2ssh9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C072CC4CEED;
	Mon, 23 Jun 2025 06:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750661262;
	bh=Gn837mX6w8WPQ8SwBue8RMOzUhYMNFiDvKsbSLr45OU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P+2ssh9n4VI2srxXNUXiAejmYlrf6oqD1vqzmtFKyiTY8puHaY/RuttH7ZZ+ncdgP
	 0hkH5H3WoOl3Fq9qC8SCLnZOZEaBjq9fb8w98fJa1dTvKqpPl+eu9Jy1AZdzq/H+OO
	 JtMLkZtAvBahUd0ENyHppt8Ov3ZpWENM2iM/+4a8=
Date: Mon, 23 Jun 2025 08:47:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH 6.1.y v2] arm64: dts: imx8mm: Drop sd-vsel-gpios from
 i.MX8M Mini Verdin SoM
Message-ID: <2025062315-sanctity-pyramid-1743@gregkh>
References: <20250604212401.8486-1-francesco@dolcini.it>
 <20250623064132.GA7788@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250623064132.GA7788@francesco-nb>

On Mon, Jun 23, 2025 at 08:41:32AM +0200, Francesco Dolcini wrote:
> Hello Greg,
> 
> On Wed, Jun 04, 2025 at 11:24:01PM +0200, Francesco Dolcini wrote:
> > From: Marek Vasut <marex@denx.de>
> > 
> > [ Upstream commit 8bad8c923f217d238ba4f1a6d19d761e53bfbd26 ]
> > 
> > The VSELECT pin is configured as MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT
> > and not as a GPIO, drop the bogus sd-vsel-gpios property as the eSDHC
> > block handles the VSELECT pin on its own.
> > 
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> > Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> > Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Just a short ping on this, to be sure it gets queued for the next 6.1
> stable kernel

I think our emails got crossed in the ether, I just applied this :)
