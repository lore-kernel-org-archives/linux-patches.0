Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDD622068A;
	Sun, 18 Jan 2026 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768725755; cv=none; b=lAsiut2oGwX/GNaa70fnDnGHNr8qpRvUNddgSOIpK9VC9BfwYhQBoLFOVxnELscD2VDrWIha2LCpOPoCIA+dZR4oJ2lYDV91907aVEKnPWlES+wo+fe9tfW//bNxrHhtF6UkYc/ykhnkSJGAkzqn/yHthsnNX4z3Q82l8WjJ5eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768725755; c=relaxed/simple;
	bh=Io6759htdVc4y4QDvsm1vDXwhTKWZsue/LxhQAhkfDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFjduId1Jwxc+3N63C40mF4n2vOtLz4fOUDyoTS/TKO9ASICf3bnXlFQ4xADNq8up9elx3d20WfW1CQaxqff4o7qJ/dfNKAAHFpD9QT8ZdhZ/wSzqAtBL9h4ETwsjzt5ncvTOI41xEQZ1EXVd+mvnkgGUHULFnAb3t9ubP79/No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ajs6A1eA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ajs6A1eA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E61EC116D0;
	Sun, 18 Jan 2026 08:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768725755;
	bh=Io6759htdVc4y4QDvsm1vDXwhTKWZsue/LxhQAhkfDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ajs6A1eA25VWwZ7ESHFYizCcnAPevKX+un5xoapysTCabfGLOGe4rbTZoRc+HbeKG
	 Snz9oPqS4UioyRa2BSWYfrTBDDDe4HGbFagdMExboyaY+5an7KgWoX/W9UsWGxum7u
	 jw46BDvReVLlmt3ZiePWwH4hiL5DUD0zBUdSnH48=
Date: Sun, 18 Jan 2026 09:42:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>, Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 205/451] firmware: imx: scu-irq: Init workqueue
 before request mbox channel
Message-ID: <2026011806-uncapped-marvelous-d81b@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164238.316830827@linuxfoundation.org>
 <b510c4fd58410b0d1125aedcae95a38f28990142.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b510c4fd58410b0d1125aedcae95a38f28990142.camel@decadent.org.uk>

On Sat, Jan 17, 2026 at 09:08:35PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:46 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Peng Fan <peng.fan@nxp.com>
> > 
> > [ Upstream commit 81fb53feb66a3aefbf6fcab73bb8d06f5b0c54ad ]
> > 
> > With mailbox channel requested, there is possibility that interrupts may
> > come in, so need to make sure the workqueue is initialized before
> > the queue is scheduled by mailbox rx callback.
> [...]
> 
> This is an incomplete fix; you also need to pick:
> 
> commit ff3f9913bc0749364fbfd86ea62ba2d31c6136c8
> Author: Peng Fan <peng.fan@nxp.com>
> Date:   Fri Oct 17 09:56:27 2025 +0800
>  
>     firmware: imx: scu-irq: Set mu_resource_id before get handle

How did you determine this?  There's no "Fixes:" tag to give us a clue
as to if it's needed anywhere or not.

thanks,

greg k-h
