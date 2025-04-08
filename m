Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1D3241683;
	Tue,  8 Apr 2025 16:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744128160; cv=none; b=apeXMXmgwTf8fxraBlSLrJpkSV0uIYqvLof7w2xLBDWDpFSylSh6WNdP9nNkPEQW/ywY2jIOeCa3MrfZ4Yy//fpHUhOAoQ6uXzO7HIHbvDNZzzMn5kphli6+w2yURecZ3xbxDfLfblZZWa8/iIFwu41wbuzTQoaRMIE/nXtq3NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744128160; c=relaxed/simple;
	bh=8AvvO/FEXZQRLI5jm/p7Uw3Rs67bmujJ67Fm23tkLZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6pMleypR33br7nGwc0UbZEXnWYRlzU44ytyYeXVc559k3zucrYKZEV5CRP3rHt4IhebAMqqEWe1sLFo1CCOTSdYUbT2ynMD1Ow5MUin8CeU9qnsAYnkUNT8vrk90/G7Ie7IN7wqFCg5bclOoBe4fXI/MV1c9AiuHE2h4bzaJ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3Yl+hpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3Yl+hpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7431CC4CEE5;
	Tue,  8 Apr 2025 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744128160;
	bh=8AvvO/FEXZQRLI5jm/p7Uw3Rs67bmujJ67Fm23tkLZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l3Yl+hpvKOcpUyZu4oeeHJTIk41+vPLbiVMc+CLyssBksbY+ctrMzJzoXIVBNFjzF
	 45BiDzeW8mgfpxxPYPapTqedVTdaMkT9+HKnleGpHDVGUDMOhNHwFYRCC/kTh7fQAt
	 5nGYWtbbw/ggsGRcYxkH+l+zu2CDLADfcn/7vUg/EPXwfJ6WKLUScNUJLzUwhBeW+/
	 uHJltgsRY77gfOEGSj2NjRchPcFBglWHl+kp0A7e1xckC0Uq90HMdhDxDhN0zJdJgh
	 0mduH4U21+apQdAF49CzD1w4XhYj3ACa7r7flHDqTz/kwtam4pYtQ1rbrOwtrZTNpM
	 XNN1Ax9Ba6Enw==
Date: Tue, 8 Apr 2025 09:02:35 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Al Cooper <alcooperx@gmail.com>, Kamal Dasu <kdasu.kdev@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 253/279] mmc: sdhci-brcmstb: Add ability to increase
 max clock rate for 72116b0
Message-ID: <20250408160235.GA3698564@ax162>
References: <20250408104826.319283234@linuxfoundation.org>
 <20250408104833.210619151@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408104833.210619151@linuxfoundation.org>

Hi Greg,

On Tue, Apr 08, 2025 at 12:50:36PM +0200, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kamal Dasu <kdasu.kdev@gmail.com>
> 
> [ Upstream commit 97904a59855c7ac7c613085bc6bdc550d48524ff ]
> 
> The 72116B0 has improved SDIO controllers that allow the max clock
> rate to be increased from a max of 100MHz to a max of 150MHz. The
> driver will need to get the clock and increase it's default rate
> and override the caps register, that still indicates a max of 100MHz.
> The new clock will be named "sdio_freq" in the DT node's "clock-names"
> list. The driver will use a DT property, "clock-frequency", to
> enable this functionality and will get the actual rate in MHz
> from the property to allow various speeds to be requested.
> 
> Signed-off-by: Al Cooper <alcooperx@gmail.com>
> Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> Link: https://lore.kernel.org/r/20220520183108.47358-3-kdasu.kdev@gmail.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Stable-dep-of: 723ef0e20dbb ("mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This change needs a fix for a clang -Wsometimes-uninitialized warning,
commit c3c0ed75ffbf ("mmc: sdhci-brcmstb: Initialize base_clk to NULL in
sdhci_brcmstb_probe()"), as pointed out by KernelCI.

https://lore.kernel.org/CACo-S-297JUFPCNaeSoA0WHSP=sC+QquSZaX=rQto=JZzi1PUA@mail.gmail.com/

Not exactly your fault, I had a Fixes tag on the original patch but it
seems like it got stripped during application :/

https://lore.kernel.org/20220608152757.82529-1-nathan@kernel.org/

Cheers,
Nathan
