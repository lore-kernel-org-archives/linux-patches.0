Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0B91E5B9A;
	Wed,  4 Jun 2025 08:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026353; cv=none; b=Ung9WQ4AiF3GE8UX0HyStBpfNbASoQjcBT52R+bnE0gizixt+5jmGKnJC7E/0MrANxBsUKfC6hqrKXeqxbB3wWxAzZo679oeP7oNgKIZx7lz1gHadKT47doVsr3hHIEN2kgKSv3NePfgNkoc+mMWZjDIt8x7ueZv3T1WqwjZers=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026353; c=relaxed/simple;
	bh=sz8CV0iqZ1QeTfFEdCvZfqjSQLCKjA/QtcmaTG4OIEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=faZqjoOSHfDg+VS/Jo/y8ZeSz4JS7jegOmL/ftfMMFjqBquKQRuZG4CK0pVJYW8GURaCZ6LNcc16YaZieT6kLVVKBflugPro8cNo/OlvVuN4uPCf47InSvnCy1Yrb5g2kfhgZVajpKQkKu7TCxZ43QlxOwZ44B9Cz4DVrT+GIRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQo07r8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQo07r8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E708DC4CEE7;
	Wed,  4 Jun 2025 08:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749026352;
	bh=sz8CV0iqZ1QeTfFEdCvZfqjSQLCKjA/QtcmaTG4OIEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TQo07r8/wVWhN8QlPZb/9G8XOQlOVnfhP1n2u3aEg13C7KdhXvYGygH2LaAS72AlL
	 MiqzyFkXqlwLO/7jscbu4CvTeWdDc0FbD0SsG1niiUAfDViQtW9emMpVGnNS9slNcG
	 mbIpE4hzLMVZmLJC/JBiI3hOmelEQhWE9xagBVqU=
Date: Wed, 4 Jun 2025 10:39:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Vitor Soares <ivitro@gmail.com>
Subject: Re: [PATCH 6.12 130/626] wifi: mwifiex: Fix HT40 bandwidth issue.
Message-ID: <2025060408-concur-bubbly-04ea@gregkh>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162450.311998747@linuxfoundation.org>
 <20250603203337.GA109929@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603203337.GA109929@francesco-nb>

On Tue, Jun 03, 2025 at 10:33:54PM +0200, Francesco Dolcini wrote:
> Hello Greg, Sasha
> 
> On Tue, May 27, 2025 at 06:20:23PM +0200, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jeff Chen <jeff.chen_1@nxp.com>
> > 
> > [ Upstream commit 4fcfcbe457349267fe048524078e8970807c1a5b ]
> > 
> > This patch addresses an issue where, despite the AP supporting 40MHz
> > bandwidth, the connection was limited to 20MHz. Without this fix,
> > even if the access point supports 40MHz, the bandwidth after
> > connection remains at 20MHz. This issue is not a regression.
> > 
> > Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
> > Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > Link: https://patch.msgid.link/20250314094238.2097341-1-jeff.chen_1@nxp.com
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Can you please drop this patch from any additional stable kernel update?
> It seems that on 6.12.y it introduced a regression, we are currently
> investigating it and we'll eventually send a revert for 6.12.y.

This is already in the following released kernels:
	6.12.31 6.14.9 6.15
I'll be glad to queue up the revert when it hits Linus's tree.  Is that
planned anytime soon?

thanks,

greg k-h
