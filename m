Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0B81DDC13;
	Thu, 17 Oct 2024 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729169893; cv=none; b=nPYZOimMBOwRm1gyXfge06Q60yMdj9+su1U0c4OcXhktz8cKSEZrg+Obm6ld7HvJL2CoBkud4zwK9JmZWOa5iyaE9fb2TtXPlTMKjY4Z9Kswwc214jv4CqxqZgS8Xc9FhBHL6ihlVMGCsYbLJlnegkbioZnMQa0BC3u9lszjM3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729169893; c=relaxed/simple;
	bh=gL4T+yl1KZYJy4YZ2VM1mJaJRPIvWl/wGSRE37MzqiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jf6MeQVepjSpHcoi16jck97dVofvXM4Q3m+aO3XVF/m0ygAY8WErVZBikRShUFWGUiJZ1f/ml8F5dfL82tHAnY65/eogT6mUlWojqopDx1f38LXWSNJc3nh9GX3dRZiNDScIJ7cu160rQLqyu3q5oM0vsfxpfSVIRu6bCxXs8F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14cxzPV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14cxzPV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F744C4CECD;
	Thu, 17 Oct 2024 12:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729169892;
	bh=gL4T+yl1KZYJy4YZ2VM1mJaJRPIvWl/wGSRE37MzqiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=14cxzPV8tmbmYDaIZHgKUXrgSSTqfU1geHeQ6le+LWthlTO7Pg69i2NjFjFwF2uMx
	 +HL+9/CCPY5ZdACDIScnjhLn5OYoMgwalSS9OKm3Q4wA0ajrbUhPyzLELMq1gCA7IW
	 c1zMDFPDg7CCcvMbqzSc1YftFrj/KQShJ6ZOyDfs=
Date: Thu, 17 Oct 2024 14:58:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vinod Koul <vkoul@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@intel.com>,
	Moritz Fischer <mdf@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 257/518] usb: renesas-xhci: Remove
 renesas_xhci_pci_exit()
Message-ID: <2024101736-unifier-entitle-c7a9@gregkh>
References: <20241015123916.821186887@linuxfoundation.org>
 <20241015123926.907865055@linuxfoundation.org>
 <ZxEApUzFuY6eFQUW@vaman>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxEApUzFuY6eFQUW@vaman>

On Thu, Oct 17, 2024 at 05:48:45PM +0530, Vinod Koul wrote:
> On 15-10-24, 14:42, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Moritz Fischer <mdf@kernel.org>
> > 
> > [ Upstream commit 884c274408296e7e0f56545f909b3d3a671104aa ]
> > 
> > Remove empty function renesas_xhci_pci_exit() that does not
> > actually do anything.
> 
> Does this really belong to stable? Removing an empty function should not
> be ported to stable kernels right...?

It was a dependency of:

> > Cc: Mathias Nyman <mathias.nyman@intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Vinod Koul <vkoul@kernel.org>
> > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > Link: https://lore.kernel.org/r/20210718015111.389719-3-mdf@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Stable-dep-of: f81dfa3b57c6 ("xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.")

This commit.

And as it did nothing, it's safe to remove :)

thanks,

greg k-h
