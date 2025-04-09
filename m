Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AA325D8FD;
	Wed,  9 Apr 2025 10:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744196022; cv=none; b=AJqcm58oQiZLiAmZA9/057bQF/BOgrA0F2DseRanj8GqMR/g6V3qlmH6o5BafkcoogW7CzUI3HXfISURWhe9ecd13d9gV9mABaWfGHPlGLjZAoNiuahVeBfeXICRp9I/b6Znl71sUV+w3XAzV7mCTVrGxS0wCBNaAwn3kD4wVOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744196022; c=relaxed/simple;
	bh=eVMRJDXERtHOWQOAVkvdKlyQaILN4QE79oCv2jlKIm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDbQe3iv0QPM0ICwmkTKEa1VOyHcHEwS+/AvpvU+n1XkWbCchD7qBf75cFpBhc+eeLr5ottzrTZyeOIdpF9Cbupuvw0Uf0ePPVXWGhnYdpAE1Fqfrm6kaLHnjQ6dxtwcbMXe9gdM1JGY1+Vkex3Zr+7MYCBENmctXLhG0p2Tfek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyA4UbkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyA4UbkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78903C4CEE3;
	Wed,  9 Apr 2025 10:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744196021;
	bh=eVMRJDXERtHOWQOAVkvdKlyQaILN4QE79oCv2jlKIm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OyA4UbkEjktaolmAjfXlkxox+pfJofwNZD8xNyoqyt2DFtR5evFuU2QfWRk1QDU66
	 TlecLHnutC91ybTejVS6sAYAQv2vt8+kBKWtfUDL/1KDXKWyRg43/rAxq4P5JLHvNx
	 ORMX9M1bzLY+sCEgfg37WQV8UUt81Cqg7NKnNeCI=
Date: Wed, 9 Apr 2025 12:52:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Al Cooper <alcooperx@gmail.com>, Kamal Dasu <kdasu.kdev@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 253/279] mmc: sdhci-brcmstb: Add ability to increase
 max clock rate for 72116b0
Message-ID: <2025040954-swaddling-anything-9d90@gregkh>
References: <20250408104826.319283234@linuxfoundation.org>
 <20250408104833.210619151@linuxfoundation.org>
 <20250408160235.GA3698564@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408160235.GA3698564@ax162>

On Tue, Apr 08, 2025 at 09:02:35AM -0700, Nathan Chancellor wrote:
> Hi Greg,
> 
> On Tue, Apr 08, 2025 at 12:50:36PM +0200, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kamal Dasu <kdasu.kdev@gmail.com>
> > 
> > [ Upstream commit 97904a59855c7ac7c613085bc6bdc550d48524ff ]
> > 
> > The 72116B0 has improved SDIO controllers that allow the max clock
> > rate to be increased from a max of 100MHz to a max of 150MHz. The
> > driver will need to get the clock and increase it's default rate
> > and override the caps register, that still indicates a max of 100MHz.
> > The new clock will be named "sdio_freq" in the DT node's "clock-names"
> > list. The driver will use a DT property, "clock-frequency", to
> > enable this functionality and will get the actual rate in MHz
> > from the property to allow various speeds to be requested.
> > 
> > Signed-off-by: Al Cooper <alcooperx@gmail.com>
> > Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
> > Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> > Link: https://lore.kernel.org/r/20220520183108.47358-3-kdasu.kdev@gmail.com
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > Stable-dep-of: 723ef0e20dbb ("mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This change needs a fix for a clang -Wsometimes-uninitialized warning,
> commit c3c0ed75ffbf ("mmc: sdhci-brcmstb: Initialize base_clk to NULL in
> sdhci_brcmstb_probe()"), as pointed out by KernelCI.
> 
> https://lore.kernel.org/CACo-S-297JUFPCNaeSoA0WHSP=sC+QquSZaX=rQto=JZzi1PUA@mail.gmail.com/
> 
> Not exactly your fault, I had a Fixes tag on the original patch but it
> seems like it got stripped during application :/
> 
> https://lore.kernel.org/20220608152757.82529-1-nathan@kernel.org/

Thanks, I'll go queue that up now.

greg k-h
