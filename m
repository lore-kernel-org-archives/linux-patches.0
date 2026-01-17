Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2779475;
	Sat, 17 Jan 2026 15:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768662954; cv=none; b=TNJEaLF/SF57J8/tZx/iuWGbjoMLa/NsKS2s4xN95QiFVwKPBlI8zwdKsLPMdqkmZtYVrvLI/u+pkc1D3yEOxJb4EMX7iDFX9Jgm9VcUBOvCpeDtt3FbAYLSU15EvRNqR17XFNxjQecBBLUBb124fEc1ekc2qeOpmLtJMfxbzKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768662954; c=relaxed/simple;
	bh=ungQFbdkxVvcbvD5Z8JosFLPpOR/j3d1OiGy2nTeI5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYXgCqv8dSdW8JMa2rp2c8zrI4+jt54L1XaQnkk1olXNWzPOIPJK+04k6YCbhUBiSWH1i4oKOjxMXxkEKfSLx8u1T2Xfx4HM3q7DzFhJ4s+sE25WII8VcZeTMU4d/2h+hF6052BYSoY8FrUVEUqBN11IlutCM5FgF95CRYkT7kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruQpK1My; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruQpK1My"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D86C4CEF7;
	Sat, 17 Jan 2026 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768662953;
	bh=ungQFbdkxVvcbvD5Z8JosFLPpOR/j3d1OiGy2nTeI5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ruQpK1MyyvJB5GCRQHEM8XvnVFS4z+WjDm1GudXzyL9Ojf5g/ujOxue2WxrtZ6V2A
	 8YbfgDQNl77qaZCYdohcrahyETrge35tB/BMMsBCpbAk0MGqXk41r/fKb2WstKCa3o
	 XsXJiKLIodcoEHpPT1QgllBDuxUN+0y07QsBR/2w=
Date: Sat, 17 Jan 2026 16:15:50 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 069/451] clk: renesas: r9a06g032: Export function to
 set dmamux
Message-ID: <2026011712-data-gawk-e7dc@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164233.397731345@linuxfoundation.org>
 <17ac573f3d57068d84078b5d0f0875f9a4f1f2f0.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17ac573f3d57068d84078b5d0f0875f9a4f1f2f0.camel@decadent.org.uk>

On Sat, Jan 17, 2026 at 02:13:19PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:44 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Miquel Raynal <miquel.raynal@bootlin.com>
> > 
> > [ Upstream commit 885525c1e7e27ea6207d648a8db20dfbbd9e4238 ]
> > 
> > The dmamux register is located within the system controller.
> > 
> > Without syscon, we need an extra helper in order to give write access to
> > this register to a dmamux driver.
> > 
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > Acked-by: Stephen Boyd <sboyd@kernel.org>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Link: https://lore.kernel.org/r/20220427095653.91804-5-miquel.raynal@bootlin.com
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> > Stable-dep-of: f8def051bbcf ("clk: renesas: r9a06g032: Fix memory leak in error path")
> [...]
> 
> Similarly, commit f8def051bbcf is a real fix but doesn't actually depend
> on these supposed dependencies.

To apply cleanly, yes it did.  I've dropped the dependancies now and
fixed this up by hand.

thanks,

greg k-h
