Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C95A59;
	Thu,  2 Oct 2025 07:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759388993; cv=none; b=tM9ItL7YdDMNdR25ePA5wqK5CLzWWDvvYw5QBZlJs3axHjXVu9iBbtxtU3jZ3kJ99B94hPanl+J/dnpEZ/nnJ8lXQJwh33/AFxDM8BIrH5ZXa/6wy8brLQtqX9ZIhKYvo+6B3W7m5buVpADBjHbqADaTBZ+RQ2TZpt8WzaYjNIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759388993; c=relaxed/simple;
	bh=qd03jEKdRKh9WJLAKjCIv/ylrq9qbmYcLZEjH4jmla4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3PhoBKvL7yA7oRQRtODrSvbaOa8gBanMkScr46F5hu3l+YFJPSlZPJvn8UJ8aCsbPE8WhqeFt0IvlcD5tNb3t28Mf/o5eEVwjRHbcgKdCCTbP5O2TiK7THN0SoD1JijuYB0COdQEOqdAvedAQEaLUzo4t3eA2GPybs21XSwgQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=003wUiyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="003wUiyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6D3C4CEF4;
	Thu,  2 Oct 2025 07:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759388993;
	bh=qd03jEKdRKh9WJLAKjCIv/ylrq9qbmYcLZEjH4jmla4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=003wUiyYdLVHmPXN7UvYVblqn3RqCgiPpbCvydv/FLR8WWyloZ6RNLtFujg/yqbK3
	 iZYRKK2YZEC46mFWHfW6pLJaQcNwRUGjAAkkOlc8OwhAecWSASn2tCXX+ozLAOD5d9
	 qrtpwuvRYkJHwtbCxnNbFxllIZbFAzIfzY8+ExhI=
Date: Thu, 2 Oct 2025 09:09:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aditya Garg <gargaditya08@live.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>, Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 07/73] HID: multitouch: Get the contact ID from
 HID_DG_TRANSDUCER_INDEX fields in case of Apple Touch Bar
Message-ID: <2025100237-reprint-siesta-f3fb@gregkh>
References: <20250930143820.537407601@linuxfoundation.org>
 <20250930143820.858284690@linuxfoundation.org>
 <MAUPR01MB11546CD5BF3C073E67FEE70BCB81AA@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MAUPR01MB11546CD5BF3C073E67FEE70BCB81AA@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>

On Tue, Sep 30, 2025 at 08:53:35PM +0530, Aditya Garg wrote:
> 
> 
> On 30/09/25 8:17 pm, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kerem Karabay <kekrby@gmail.com>
> > 
> > [ Upstream commit f41d736acc039d86512951f4e874b0f5e666babf ]
> > 
> > In Apple Touch Bar, the contact ID is contained in fields with the
> > HID_DG_TRANSDUCER_INDEX usage rather than HID_DG_CONTACTID, thus differing
> > from the HID spec. Add a quirk for the same.
> > 
> 
> All these hid-multitouch patches were a part of appletbdrm driver upstreamed since kernel 6.15.
> 
> Due to 2 different trees, and some delay in review by hid maintainers, these got upstreamed in 6.17.
> 
> So, in case you wish to backport to stable, IMO, backport only till 6.15, which in practicality is just 6.16 as of today.

Thanks, I'll drop this from everything except the 6.16.y tree.

greg k-h

