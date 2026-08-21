Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A4C214A9B;
	Fri, 21 Aug 2026 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324488; cv=none; b=o37/99xcFjxbR+IXBGrQQkYZ0OuFZ92my1+kSAIZrBBR6XdoqaK4yvtG/dKdqmKAiwXaBnzBdDgobVMCr6xKluFvHj9AZ+FqCMoCeb0nL+VjfZV8akV08ZkBo18afZii4ObNN6AQmzbEhMpOboHbaq19IaI+qurrQYfC5NMpUJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324488; c=relaxed/simple;
	bh=whu5fjwiUlFPefoo4/CounJ3VK5SVMCUdmdqP10oxtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1/g67SCFtGRc9TdaRM1VQwghDZbVzyzZIIm1VgpguCv+B4toOMazEeLI1Vcw5fDT8CZKUrpHpnguo9SMb2yAKC+TqqRXfPaeyuV65OTrPMsko3fOngYjDqWoRZGyw3+UdFOxQ69rLy83tdrkmIhCRWVRKK+ThQb+KO4H5/L6N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMvc9CQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMvc9CQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A87A1F000E9;
	Fri, 21 Aug 2026 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787324486;
	bh=OCyC7qz1wYsatBxE4GtW96338TTTiqecOWuIrKab4K8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iMvc9CQPMIAovE5oo1gPfx/iYyhdiWnGkE319RmIvn6cMhhjp+dnsesWgloBOd51U
	 uHYI3C0wd5TbvUGsnVkDPTJ7t/4ko6BkRemvfibmFa7wtKdHBSxDo3i/9JHmJBx17V
	 zjdGlEyNrsZ92GNFihdD8aZKh/EKEEqULRFsCzpA=
Date: Fri, 21 Aug 2026 17:01:24 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Shiji Yang <yangshiji66@outlook.com>
Cc: frank-w@public-files.de, horms@kernel.org, kuba@kernel.org,
	patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.12 090/337] net: ethernet: mtk_eth_soc: support named
 IRQs
Message-ID: <2026082149-excess-bamboo-f872@gregkh>
References: <20260807143420.466574387@linuxfoundation.org>
 <OSZPR01MB77959549273821C1F6A75832BCA32@OSZPR01MB7795.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSZPR01MB77959549273821C1F6A75832BCA32@OSZPR01MB7795.jpnprd01.prod.outlook.com>

On Fri, Aug 21, 2026 at 09:31:32AM +0800, Shiji Yang wrote:
> Hi, this patch caused the following errors on non MT7988 SoCs:
> [    7.071127] mtk_soc_eth 1e100000.ethernet: error -ENXIO: IRQ fe1 not found
> [    7.078022] mtk_soc_eth 1e100000.ethernet: error -ENXIO: IRQ fe2 not found
> 
> Please backport these patches to fix it:
> 070e98dd4e26279280e15db8f37077a001ca1b4c ("net: ethernet: mtk_eth_soc: only use legacy mode on missing IRQ name")
> e81d36d48880ab3f2b351ce3df799acaa8b11c4f ("net: ethernet: mtk_eth_soc: improve support for named interrupts")

Why did neither of these have Fixes: tags?

Anyway, I'll go queue both of these up now, thanks.

greg k-h
