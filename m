Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5F22EFDBD;
	Fri,  4 Jul 2025 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751618143; cv=none; b=C2A7R8JXavOaJsODwm3LCYHtz2JsEOH9FiHCW2KVVpScWZtLcnjAjJ+0Iyn3NVw1zsZL1RLuJpDUjMHgP7rqS+lZ88Xoz65PkqpPp3JB/HmCcGHPL2ubZExEhXounA29mHxYWonMqlfJjyrxe8aR6mmpSSkKFdbvD9sFfTWcFqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751618143; c=relaxed/simple;
	bh=zxwCqZquG7ZOWpHVXLNpTp2Mz/Ll3TT49a73dAZdNQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/Js9nQK7Pm5lNn4Nh97NjPWrShYhLBTBBCY2XN7CNfRlRZu4M4JhxsqnM8q4I+VSxkfM6Rh1F6kTB/J++Q0zBWYE7ahG+mLQJIYJH67ZMrItfV5hMwRf8LynOSnpGbtL3sNYnes2SArGit/hZABBTbxLMi+vwxc+moK4FCXd3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhZrZNTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhZrZNTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191B2C4CEED;
	Fri,  4 Jul 2025 08:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751618142;
	bh=zxwCqZquG7ZOWpHVXLNpTp2Mz/Ll3TT49a73dAZdNQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BhZrZNTArXoW9F7V9pBeR1dBBrVXM/ofGs2g2ujXdCQiF3knu/+XeOXkpPlVmIqz/
	 XTJmBuRh8MJbymBFCyTjgmFCQPGTyxbC2+/7CEBHFJcQvhOcad2MdxRsyLS7DinsYL
	 JfH+WsFCixkCXdn9UENvpSwXR62M8xkx5eTLUSDA=
Date: Fri, 4 Jul 2025 10:35:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
	Krzysztof Wilczy??ski <kwilczynski@kernel.org>,
	Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 6.12 020/218] Revert "iommu/amd: Prevent binding other
 PCI drivers to IOMMU PCI devices"
Message-ID: <2025070424-supplier-duckling-857b@gregkh>
References: <20250703143955.956569535@linuxfoundation.org>
 <20250703143956.766086832@linuxfoundation.org>
 <aGaY4Y9trrnMlxO-@wunner.de>
 <aGd3vc6EjHQhp5ED@wunner.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGd3vc6EjHQhp5ED@wunner.de>

On Fri, Jul 04, 2025 at 08:42:05AM +0200, Lukas Wunner wrote:
> On Thu, Jul 03, 2025 at 04:51:13PM +0200, Lukas Wunner wrote:
> > On Thu, Jul 03, 2025 at 04:39:28PM +0200, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > [ Upstream commit 3be5fa236649da6404f1bca1491bf02d4b0d5cce ]
> > 
> > This should not be backported to stable kernels.  It does not fix
> > any known issues, but conversely it is known to cause an error
> > message on boot, for which there's a fix pending here:
> > 
> > https://lore.kernel.org/r/b29e7fbfc6d146f947603d0ebaef44cbd2f0d754.1751468802.git.lukas@wunner.de/
> > 
> > Long story short, please unqueue this one. :)
> 
> Gentle ping - I just noticed that upstream commit 3be5fa236649 is still
> on the queue/6.15, queue/6.12, queue/6.6, queue/6.1, queue/5.15,
> queue/5.10, queue/5.4 branches (which were all updated 6 hours ago).
> 
> Please drop the commit from all of them.  This commit is not eligible
> for backporting to stable.

Sorry about that, I was hoping that the fix would hit Linus's tree.  Now
dropped from all queues.

greg k-h
