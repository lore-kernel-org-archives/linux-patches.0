Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B6A3C494
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 08:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708504753; cv=none; b=IyZXzdnLjpR7qWwslNPxl0ir0zTChF6HsMR2Bcjkjw/dUEKIcw0yNcdv06lYZYtUqrkUXuNhZ+UfRXTsJvI4uUXridrrRAmStfHcMERv+aMTveobudyi1GW33hiLY67h0vKgrzxtU9JIeG3cGnwTCSLyi7NObIjxtyJUGpOaP24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708504753; c=relaxed/simple;
	bh=7xuuAgXnq3NtSUZgao9fIVu1WKzYNnMu76nRlz0Q4fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PWH8RHbuSqfQ0h0mVbJiZfZ/uoLEWGCPKXHkhqQrYgIHJ8Iu8PR10k9V9ZwjTi7VZZrUh8C+RC7PsvrgRvnyAONweMLwH2ZRLRr8577FEKiJn4INZcr+Y67UOac0JDCqsguqAtPfMLmTNknNnU3AW0mC3DSQ2xbDdda1pU9kp3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=sCBh7wf/; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="sCBh7wf/"
Received: from francesco-nb (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id 06A342212C;
	Wed, 21 Feb 2024 09:39:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1708504748;
	bh=fe/oFgkFR0NQ27A9TiXiKt/mNSjEI5EhIHLy0lmYY9I=; h=From:To:Subject;
	b=sCBh7wf/AhoqbS5ZROHIsFby4qjwpnufbdXKV/aLHfyymaq8EtXq5kw94LK7g1NmJ
	 UMNO3ynGJfiN/+tHNyGf3GfEDXZTY+fGU6AcOAuanPG1RI3iTHjlR3KKC/wnvbuh7o
	 Wd6i/aSCkcjcvYNCN0wnPTsYhTC33guz3y53v2yRhC5Up948sXSSb7VSoKfDo1pEYB
	 rZsFxZYgptCZAfEv637bDnzi3/xD3H7pwg7tc8yEi0Os+JV67zRK0/3Isr2aAN0kzs
	 qYkPKldCIhh+U4HtDsd8ZgIVD4pkmmk2AjBOjqDYT4vkQjbi1/ncAaGBv4DgoKdjqH
	 YEXvUN/IugywQ==
Date: Wed, 21 Feb 2024 09:39:04 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francesco Dolcini <francesco@dolcini.it>, stable@vger.kernel.org,
	patches@lists.linux.dev, Lukas Wunner <lukas@wunner.de>,
	Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 174/197] wifi: mwifiex: Support SD8978 chipset
Message-ID: <20240221083904.GA5872@francesco-nb>
References: <20240220204841.073267068@linuxfoundation.org>
 <20240220204846.279064097@linuxfoundation.org>
 <20240221080353.GB5131@francesco-nb>
 <2024022106-speculate-scallion-67a7@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024022106-speculate-scallion-67a7@gregkh>

On Wed, Feb 21, 2024 at 09:12:23AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Feb 21, 2024 at 09:03:53AM +0100, Francesco Dolcini wrote:
> > On Tue, Feb 20, 2024 at 09:52:13PM +0100, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Lukas Wunner <lukas@wunner.de>
> > > 
> > > [ Upstream commit bba047f15851c8b053221f1b276eb7682d59f755 ]
> > > 
> > > The Marvell SD8978 (aka NXP IW416) uses identical registers as SD8987,
> > > so reuse the existing mwifiex_reg_sd8987 definition.
> > > 
> > > Note that mwifiex_reg_sd8977 and mwifiex_reg_sd8997 are likewise
> > > identical, save for the fw_dump_ctrl register:  They define it as 0xf0
> > > whereas mwifiex_reg_sd8987 defines it as 0xf9.  I've verified that
> > > 0xf9 is the correct value on SD8978.  NXP's out-of-tree driver uses
> > > 0xf9 for all of them, so there's a chance that 0xf0 is not correct
> > > in the mwifiex_reg_sd8977 and mwifiex_reg_sd8997 definitions.  I cannot
> > > test that for lack of hardware, hence am leaving it as is.
> > > 
> > > NXP has only released a firmware which runs Bluetooth over UART.
> > > Perhaps Bluetooth over SDIO is unsupported by this chipset.
> > > Consequently, only an "sdiouart" firmware image is referenced, not an
> > > alternative "sdsd" image.
> > > 
> > > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > > Signed-off-by: Kalle Valo <kvalo@kernel.org>
> > > Link: https://lore.kernel.org/r/536b4f17a72ca460ad1b07045757043fb0778988.1674827105.git.lukas@wunner.de
> > > Stable-dep-of: 1c5d463c0770 ("wifi: mwifiex: add extra delay for firmware ready")
> > 
> > I would drop this and 1c5d463c0770.
> 
> Why?  Commit 1c5d463c0770 was explicitly tagged for stable inclusion,
> what changed?

1c5d463c0770 is a fix for bba047f15851c8b053221f1b276eb7682d59f755.

So there is no bug, unless bba047f15851c8b053221f1b276eb7682d59f755 is
there.

The mistake that we did at that time is that it should have been

Cc: stable@vger.kernel.org
Fixes: bba047f15851 ("wifi: mwifiex: Support SD8978 chipset")

Sorry about that.

Francesco

