Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBD384DE9;
	Thu, 11 Jul 2024 09:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720690599; cv=none; b=Fr0SKP7i1Sb18bSAEMbK+IFTs2zIxQ0jhiJq82r+ZhytZrSiEVwig4qIgDMYiWnfgPY/UCN6iwZH+579t+EPAQjpwwPd9qLE9BP8EFhe1pWLtDZyX0d6HV/PmCEonnsodHfctQoQw7HmO6KDympbMAn3PPUTN7GoNhCQE1G1/AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720690599; c=relaxed/simple;
	bh=XWqQYgddqa9+/ghYj/7z6w/2AwQebFFTzhF1lakgHBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2xFYSVJ62F0oMUUKW1Rsmn75ML3Pis9z1I8pj/IeY8RL4/ybegAhUG4dStwr92Xs28pDcNfB9Sb+rffr4wuMr1EBA6/VxaAij9/vrpKyWDs+DuslYI98rXox5abXm9do2qa5C15Jw7Kv61r8wjupSmIav/Xaqko4cG6dIomdqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8Wy15yI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8Wy15yI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F65C116B1;
	Thu, 11 Jul 2024 09:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720690599;
	bh=XWqQYgddqa9+/ghYj/7z6w/2AwQebFFTzhF1lakgHBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H8Wy15yIPczOgchDiMUogrENunf6TFLFyRcoH+FhqRVtWGyS8//IdKYlCExa9gccM
	 YEuTicb8ceFCumZ/Z8GB0fto/jr5+in7wGvZxQ5H5mOUOdC184deJ2vGUtjzQyRnVM
	 VC6nRsa0vTvUxZ19EM1NlXGlJ4/8iLuVVOy8IldQ=
Date: Thu, 11 Jul 2024 11:36:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 009/102] irqchip/gic-v3-its: Remove BUG_ON in
 its_vpe_irq_domain_alloc
Message-ID: <2024071125-conjure-sulphate-0307@gregkh>
References: <20240709110651.353707001@linuxfoundation.org>
 <20240709110651.723892970@linuxfoundation.org>
 <be1737a6-66e4-e009-9225-a5a0cfe87b24@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be1737a6-66e4-e009-9225-a5a0cfe87b24@huawei.com>

On Tue, Jul 09, 2024 at 08:05:14PM +0800, Zenghui Yu wrote:
> On 2024/7/9 19:09, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Guanrui Huang <guanrui.huang@linux.alibaba.com>
> > 
> > [ Upstream commit 382d2ffe86efb1e2fa803d2cf17e5bfc34e574f3 ]
> > 
> > This BUG_ON() is useless, because the same effect will be obtained
> > by letting the code run its course and vm being dereferenced,
> > triggering an exception.
> > 
> > So just remove this check.
> > 
> > Signed-off-by: Guanrui Huang <guanrui.huang@linux.alibaba.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> > Acked-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/r/20240418061053.96803-3-guanrui.huang@linux.alibaba.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I don't think this should be backported to stable. It doesn't fix
> anything but only remove a useless BUG_ON().

Thanks for the review, now dropped from everywhere.

greg k-h
