Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9B32EBB83;
	Mon, 20 Oct 2025 08:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760948897; cv=none; b=coEU+C5C3koHxWhdLriswkLYW2kR6NSDHfOmEAcBeV8ywy78afcMSIzGg4JZb5MyROXO4Pr8QhLWYE6CjicbvXpOKNSbMXOLhK0woXz0Mvm6gtBBoaBr8ZQEajmWuo/Qj5hdCs+0eaBsoudzJWyScVdSWQGFE27qptMTpfhf334=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760948897; c=relaxed/simple;
	bh=zeGVUJQKM0VxiUKiRwCXA3JlS8XFgA6+AtvAVygUk0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSkd0RsS7e2z2Lz6vjNiM3bGiDGgI3wbym3387xxYFNJbYg0Xv3asvNiIGsxgSL48qr2txHMn1Lvf+yJbt0VGReVE+S+v1obdirkfL07XwSuYe5TN/wtDFksx86aMT4t614We06kT2mcnD15ahKNwVyLuJm90/U9z73lpRtbPiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h94D+eQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h94D+eQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B44C4CEF9;
	Mon, 20 Oct 2025 08:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760948897;
	bh=zeGVUJQKM0VxiUKiRwCXA3JlS8XFgA6+AtvAVygUk0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h94D+eQL3uAjXGsKaORgbEgieezjGS6hy/s9BHL3iiQmOZHUQKcnss33uwt/6RK5C
	 JE2KTCOz/nbe/de8G3e6gv5yRvf5fLxPQSfkiONiXrNehz4MQybCuYvdLAbdp++SJQ
	 mwiR7ZNrfD3ye4PWKCgdnlAYFcqtAth2bp1qh2Nk=
Date: Mon, 20 Oct 2025 10:28:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Naim <dnaim@cachyos.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>, Kenneth Crudup <kenny@panix.com>,
	Genes Lists <lists@sapience.com>, Jens Axboe <axboe@kernel.dk>,
	Todd Brandt <todd.e.brandt@intel.com>
Subject: Re: [PATCH 6.17 068/563] PCI/MSI: Add startup/shutdown for per
 device domains
Message-ID: <2025102008-preheated-diffused-015d@gregkh>
References: <20251013144413.753811471@linuxfoundation.org>
 <20251013211648.GA864848@bhelgaas>
 <2025101753-borough-perm-365d@gregkh>
 <6f19c559-35b4-4cd8-8bcd-615898dd8a4d@cachyos.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f19c559-35b4-4cd8-8bcd-615898dd8a4d@cachyos.org>

On Sun, Oct 19, 2025 at 01:29:18PM +0800, Eric Naim wrote:
> On 10/17/25 14:56, Greg Kroah-Hartman wrote:
> > On Mon, Oct 13, 2025 at 04:16:48PM -0500, Bjorn Helgaas wrote:
> >> [+cc Kenny, Gene, Jens, Todd]
> >>
> >> On Mon, Oct 13, 2025 at 04:38:49PM +0200, Greg Kroah-Hartman wrote:
> >>> 6.17-stable review patch.  If anyone has any objections, please let me know.
> >>
> >> We have open regression reports about this, so I don't think we
> >> should backport it yet:
> >>
> >>   https://lore.kernel.org/r/af5f1790-c3b3-4f43-97d5-759d43e09c7b@panix.com
> > 
> > It's already in a release :(
> > 
> > If someone will be so kind as to forward me the git id of the fix when
> > it lands in Linus's tree, I will be glad to queue that up.
> > 
> > thanks,
> > 
> 
> Hi Greg, the fix has made it into Linus's tree. The git hash is e433110eb5bf067f74d3d15c5fb252206c66ae0b

Thanks, now queued up.
