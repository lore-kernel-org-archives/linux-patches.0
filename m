Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D233B71B3;
	Sat,  5 Sep 2026 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788609474; cv=none; b=rK+oRERpwz1/iD4p0IhMk50Fu17Z52+tcLHzZY3oTBXQNVFqNkzXkkxlYw9BJlMFkPduKQCmP7YLLNz1ppDJLpq+5XcUOU8SOugTA+YYALnWKpFnbH9fT437IqM/g//YCfe1fOaSPRPWuSApdFwJ7Dx/REdFPalGi3yp2kghvg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788609474; c=relaxed/simple;
	bh=J4m0aGoop9DX/IlbnSjewByWc4FMN2teTH/dvFBKOyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMIZmz1YW3o69InUoY6VYEUueF+rXVRXqCqY842wSrGRBhmVt+3wmanU0U82mADLSwPidoj7nsXteZ90q1qlBCx/K933MwfoHyl7n9b0DV1tmvKnaNNjjiVZvCTglgLZ96LWJ4ThrsELRcgVtiii35JJm8mEWoiGqcDM7zT6rR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRIEiSll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRIEiSll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6E51F00A3D;
	Sat,  5 Sep 2026 11:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788609472;
	bh=/x9C5bNxNWl9gURHOdoOE+fPK6NtP9yr0zoY9jWPaYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=zRIEiSllWjjqKMphf2jfhctZ0NlrXjWQRUU/AfOo6qNsCmAQeLVGIh/ycZGD0zEwP
	 YR0g0dr+06CYTBIYyLs2S+/F8a5umC2Yd6op83rlS2imO8nJSMDLYE9lBTSnuy7y2w
	 Aix1OCYdeLxdsFOw2HgXwlLM4M9AuUPhixPage20=
Date: Sat, 5 Sep 2026 13:56:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org, Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
Message-ID: <2026090538-irritant-tattoo-caa5@gregkh>
References: <20260904045747.813364717@linuxfoundation.org>
 <20260905114111.124795-1-ojeda@kernel.org>
 <apwBsCGpUG69KdGc@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apwBsCGpUG69KdGc@codewreck.org>

On Sat, Sep 05, 2026 at 08:49:04PM +0900, Dominique Martinet wrote:
> Miguel Ojeda wrote on Sat, Sep 05, 2026 at 01:41:11PM +0200:
> > I see the same arm32 build issue:
> > 
> >     mm/page_vma_mapped.c:110:11: error: call to undeclared function 'huge_ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >       110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
> >           |                         ^
> > 
> > In addition, in UML (x86_64) there is also nearby:
> > 
> >     mm/page_vma_mapped.c:110:9: error: assigning to 'pte_t' from incompatible type 'int'
> >       110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
> >           |                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >       111 |                                       pvmw->pte);
> >           |                                       ~~~~~~~~~~
> 
> See this 6.12 thread[1] for this build failure (I didn't check but
> assume it is the same, that missing commit only made it 7.3-rc1 but was
> also backported to the 7.2 tree, which also explains 7.2 didn't build
> fail)

I should have this fixed up now, will push out a -rc2 so that you all
can test it as I'm away from my big build box at the moment :(

thanks,

greg k-h
