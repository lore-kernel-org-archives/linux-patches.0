Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AF7362128;
	Fri,  6 Feb 2026 11:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770376270; cv=none; b=t8t56B+bi+3y1mzw6ZVUl0mPZQu0CoTLW+gZoV6jttZDDyNPPXr7W2/Arg+N0dlzGai+rrgb8t7uWXN121t0RIimlGt9drlezZ3QOYzxVK032DnNco9oKfjINJPO9uBxE87KUcYkVJfguUrmwI0vJWsF+N+k78FTrHkxGPlN5l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770376270; c=relaxed/simple;
	bh=CwVF0LjzvXWYlAbtCIziTcJ5dFxHE6Xr4xxR8q8HG0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHiz9Kb5D1ISLVNXLYTBsTyXprNEri5pWEDuB+z9iPMgH7oqxjx4MhDY9BQPKjnXV+f6wmYppKCzCghNArl23FdIU0mho5tLr4+PIZ9OMWTd1cmvbT3ctbdhEvVA0eFUPjxxlcKRfFg3DeJa9le2p8DvweKeqXrGZdMhrVaxndo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVOE9dq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVOE9dq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF0AC116C6;
	Fri,  6 Feb 2026 11:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770376270;
	bh=CwVF0LjzvXWYlAbtCIziTcJ5dFxHE6Xr4xxR8q8HG0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QVOE9dq0RgO+yDIGzkv20U4JYOlPDvJOppQe+PZM4Cvq+vV9Mv1+BkpexY/5aFPdB
	 rkmssplVgUdRjsJH7D+DMqZuHosnGNn2fpLiY+l0t6CrKVAqxHHED1oeZkYOxgOPnk
	 PRExnB9cQMFlC3uYWn47MXojDgFNN/ts9yDWF97M=
Date: Fri, 6 Feb 2026 12:11:06 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Xiang Chen <chenxiang66@hisilicon.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 080/161] scsi: hisi_sas: Use managed PCI functions
Message-ID: <2026020643-tuition-outlying-ad14@gregkh>
References: <20260204143851.755002596@linuxfoundation.org>
 <20260204143854.629264200@linuxfoundation.org>
 <bce38fd1f10ecc0ae3ec3ccf95da89f58ca3e623.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bce38fd1f10ecc0ae3ec3ccf95da89f58ca3e623.camel@decadent.org.uk>

On Fri, Feb 06, 2026 at 12:09:29AM +0100, Ben Hutchings wrote:
> On Wed, 2026-02-04 at 15:39 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Xiang Chen <chenxiang66@hisilicon.com>
> > 
> > [ Upstream commit 4f6094f1663e2ed26a940f1842cdaa15c1dd649a ]
> > 
> > Use managed PCI functions such as pcim_enable_device() and
> > pcim_iomap_regions() to simplify exception handling code.
> > 
> > Link: https://lore.kernel.org/r/1629799260-120116-2-git-send-email-john.garry@huawei.com
> > Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> > Signed-off-by: John Garry <john.garry@huawei.com>
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Stable-dep-of: d5077426e1a7 ("drm/amd/pm: Don't clear SI SMC table when setting power limit")
> 
> WTF?  That's a totally unrelated driver.
> 
> Unless this is actually fixing something I think it can be dropped,
> since there are no other patches to hisi_sas in this series.

Yes, that is odd, and wasn't tagged this way for 5.15.y.  Sasha,
something went wrong with your scripts :(

Now dropped, thanks.

greg k-h
