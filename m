Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9149320DD51;
	Sat,  4 Jul 2026 11:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783164381; cv=none; b=RU8CH4sIA9IMrnd9xf9NOL3VPUssjY62PU0rWaIHok8dNT5u+0VjLQhm4brgoGicBfej/mRCiLeGEwjf26NsNOvLjkdsw+hXyK29Df50WFy5Ns5Z0JMU0xcPZGnZ4tJ6ijEJGopka3F8buFQIzHmqg+yiBpPWMZpUorxU3THRCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783164381; c=relaxed/simple;
	bh=R8i4sagldOv4yQLdQaEhlmYUmwrGWssCooWX4BYUI6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOgyH+FQdKW351mOwRWb9OICnGX/Rp+vzItST43YNar1WEYkwUCX5I4vFR8XFaP0RjD+kZgyjoDrWaQgeyzjWZfT5osp5WWKWJ42rsZTNA4ut/8htssPdcCQcb8hktriMz+sA1+R53y1Qm016bpdtrrhZyvyiIu1Xosy+J2MHxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVoiGzNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVoiGzNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12601F000E9;
	Sat,  4 Jul 2026 11:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783164380;
	bh=3GSvMJxVPm/Nr5IQG5GtIzxy8+wc68YErvrALkKZxes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XVoiGzNhg/qhNfqxVELuAW3ghhxdMZBe++Lem+8qGNwMssJIC9hhnG9QGHhid8bmk
	 PHz4CL0suVAvCqU9AsJWLBwHBpDbODmPMZ4VzXhBlhGUj33GkTiu1IvRZQttISbRlW
	 kQfo5M9GZBZw3BLrx8FHyuRpuFHL3X4HvQLawKF8=
Date: Sat, 4 Jul 2026 13:26:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: maher azz <maherazz04@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
Message-ID: <2026070421-overflow-voyage-73b8@gregkh>
References: <20260528194646.819809818@linuxfoundation.org>
 <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
 <2026062933-storeroom-amusement-0b66@gregkh>
 <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
 <2026070446-blank-duckbill-13ec@gregkh>
 <CAFQ-Uc8AAEGw90BPximQm3cLzB+KiH_PXr-UZEPK9nvueMGtSg@mail.gmail.com>
 <2026070406-squander-geography-213a@gregkh>
 <CAFQ-Uc8CDnGUH3xhjaVBd+Dr=+b7Lfu1SUrGGh2gQ17WW+gqxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFQ-Uc8CDnGUH3xhjaVBd+Dr=+b7Lfu1SUrGGh2gQ17WW+gqxQ@mail.gmail.com>

On Sat, Jul 04, 2026 at 12:20:27PM +0100, maher azz wrote:
> I sent it like half an hour ago the same way I'm sending you this
> email, I sent it in plain text mode with the subject "CVE request for
> a patched Linux kernel LPE vulnerability.",I really don't know what is
> the issue..

Please look in your email server logs for what is going wrong, as I
don't see it here at all.

> Anyway, can you please take a look, since a CVE should've been issued
> a long time ago, Ubuntu 24.04 latest kernel with latest patch is still
> vulnerable and many morea

That's up to that vendor, not us, to fix it there.  Why not talk to
them and what does a CVE have to do with that?

thanks,

greg k-h
