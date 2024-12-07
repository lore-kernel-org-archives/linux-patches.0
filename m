Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFA3360;
	Sat,  7 Dec 2024 06:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733553330; cv=none; b=RLDhhB5oFbrVbICu5v365KfIhjf2Hg/0G0RA2T92yBQ5Q22YUdbiO8Ta0qDQLBdNIKVR817B6eKFJeT6wosnzy+6RAaxMLcwvr4vNa0WR+1jlJFkweXuZGrEJTbQuuU6KvIv0V+0/IKULy7YLwZrG6PzvaQLe0hRdaIjOVmC3Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733553330; c=relaxed/simple;
	bh=3kAwRmDXezRZ3nl8LZP9C+NSCUbMbmoNK/Ky4AMh5to=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2UtNn08q09W0vsP8pmJxAXOmeaDjTT+/dNm6zb+ucszbF+U05Tg68J775WvE9UoYNuf0L0hDJeqTlPr04TPp7gx3B57LHWbt/AhdNqUIyPTemAJywIG05YmlHO1L9wk0L7PJHGoz0Lv5Qy0+riW1uRgiqcGRp30utcrDNe3KUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goL4WReR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goL4WReR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B09C4CECD;
	Sat,  7 Dec 2024 06:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733553329;
	bh=3kAwRmDXezRZ3nl8LZP9C+NSCUbMbmoNK/Ky4AMh5to=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=goL4WReR1HDqoRzsOobDJqfS58HaRdiU+6iWjrD4zUIKjOiMxDPgKa83CwJKHfznv
	 U7bIY/6dpZ71RC57OdqNcOUN/BjgbTUUbIhQq6SBKpIZ9MTgiYV4f5KtrK7KpcaR5d
	 IWVup73tmiTe11MVVAmZmRkauMrYyI+5tV5IRzQg=
Date: Sat, 7 Dec 2024 07:35:26 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Dixit, Ashutosh" <ashutosh.dixit@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <john.c.harrison@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>
Subject: Re: [PATCH 6.12 129/146] drm/xe/xe_guc_ads: save/restore OA
 registers and allowlist regs
Message-ID: <2024120712-cabbie-sniff-1a2f@gregkh>
References: <20241206143527.654980698@linuxfoundation.org>
 <20241206143532.618496043@linuxfoundation.org>
 <85jzcc3fsl.wl-ashutosh.dixit@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85jzcc3fsl.wl-ashutosh.dixit@intel.com>

On Fri, Dec 06, 2024 at 09:03:06AM -0800, Dixit, Ashutosh wrote:
> On Fri, 06 Dec 2024 06:37:40 -0800, Greg Kroah-Hartman wrote:
> >
> 
> Hi Greg,
> 
> > 6.12-stable review patch.  If anyone has any objections, please let me
> > know.
> 
> No this patch should *NOT* be added. It was later reverted in:
> 
> 0191fddf5374 ("Revert "drm/xe/xe_guc_ads: save/restore OA registers and allowlist regs"")

Oops, I missed that, sorry.  I've queued the revert up now as well.

thanks,

greg k-h
