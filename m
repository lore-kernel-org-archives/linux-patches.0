Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A383A269
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 08:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708502647; cv=none; b=eU1oMo6rBlW6uDIvDkUyV4HhcVcU33gKFXc4KN13EdHex8Tcmcsr4KS3QtAVXXlJC05ENrDRUJ77gXuKLUwEzzYhhvOKF3nq1rB6HLgFQJXI22+gortCFHtwVl3V/ZF8nZGBCZvqCtCqdFsA9Z/iOGBYFltRp9Kwtmh3wBfuwfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708502647; c=relaxed/simple;
	bh=Xlmeetw085DuaqiFxm9wsy9UTenb8e44B5Ow7mPywuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6873ZEkj7MgKeg6xwySpHIcrZdGd/+8R7X6FuAp49pTWBYQDsWOsW7hMgmpjW5WkIOA3CLjn2nepmP+34Y46kwOmEwQd5x/6IcFUHIhIgt/SVwiaZ5qXRZre2Q9wXCBRMKomj7o1kB6oAEnoyBbMKIakxUNU73Wcd9EtbjeRgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=TXgN36s+; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="TXgN36s+"
Received: from francesco-nb (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id C14B72155B;
	Wed, 21 Feb 2024 09:03:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1708502635;
	bh=pdYH5n/IXnfBISfef+cF5+AWDA7+4uPdRZNYOigC4hU=; h=From:To:Subject;
	b=TXgN36s+lzCAOJb+VJ6/kmmxux8GwzFGUm0ljY6jozvIh0b2ahoAevzT2unK8fPV9
	 pxc3NYumem1P3xHOOEyrMNpuxRx4o3XstVoRsotQSrzoL+iRmbOid5KPT64d4feA2w
	 QytuobRTIZyvlOEXTk3ECCj5nZOfqmukNOgI31amG9zrmnBrXLRb87Bt1JJMi2LFwO
	 dq6FW42c9U2KX3anLeSoRNEhd3i4fJv/zhMqHb7/LpGaxhmo55TLqlHBADE6EUCKYp
	 wRust8JCYG9BovDClt8QWn+82S1WwiOWYNdhWFAScZu1sjGnftQMO+C2/d2vltR5k4
	 4u7yJdsKeSlaQ==
Date: Wed, 21 Feb 2024 09:03:53 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>, Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 174/197] wifi: mwifiex: Support SD8978 chipset
Message-ID: <20240221080353.GB5131@francesco-nb>
References: <20240220204841.073267068@linuxfoundation.org>
 <20240220204846.279064097@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220204846.279064097@linuxfoundation.org>

On Tue, Feb 20, 2024 at 09:52:13PM +0100, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Lukas Wunner <lukas@wunner.de>
> 
> [ Upstream commit bba047f15851c8b053221f1b276eb7682d59f755 ]
> 
> The Marvell SD8978 (aka NXP IW416) uses identical registers as SD8987,
> so reuse the existing mwifiex_reg_sd8987 definition.
> 
> Note that mwifiex_reg_sd8977 and mwifiex_reg_sd8997 are likewise
> identical, save for the fw_dump_ctrl register:  They define it as 0xf0
> whereas mwifiex_reg_sd8987 defines it as 0xf9.  I've verified that
> 0xf9 is the correct value on SD8978.  NXP's out-of-tree driver uses
> 0xf9 for all of them, so there's a chance that 0xf0 is not correct
> in the mwifiex_reg_sd8977 and mwifiex_reg_sd8997 definitions.  I cannot
> test that for lack of hardware, hence am leaving it as is.
> 
> NXP has only released a firmware which runs Bluetooth over UART.
> Perhaps Bluetooth over SDIO is unsupported by this chipset.
> Consequently, only an "sdiouart" firmware image is referenced, not an
> alternative "sdsd" image.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Kalle Valo <kvalo@kernel.org>
> Link: https://lore.kernel.org/r/536b4f17a72ca460ad1b07045757043fb0778988.1674827105.git.lukas@wunner.de
> Stable-dep-of: 1c5d463c0770 ("wifi: mwifiex: add extra delay for firmware ready")

I would drop this and 1c5d463c0770.

Thanks,
Francesco

