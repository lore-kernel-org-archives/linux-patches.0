Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670F0CA62;
	Thu, 15 Aug 2024 08:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723710021; cv=none; b=h7yaLjQQCvid2FvkGwiKnrHpNF4Z2KCTZS8zDkaIuym/J8DA1hhF5tkqRpwgBSoOXTaIV/OxxKbQIjd3uD4lhTmpfu42nFDG6qH2xZLtKnFMpqxAjVo4nXhEpjl1dmqycd/sKTvztek/AOd3Tsb5vA6trSM4IFG/h9+1QbcAu1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723710021; c=relaxed/simple;
	bh=wd/Y+TeYN12Lhnm2jpny0XtOIGAI+2cFoEeolW+p4wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5xIJyGp8wGeFI+lqo2vt0qU2yEB+y3VTskjR8Ud+5icKroRQ9qBcxdpVB9OqzQxz0uOaghGWA6v97ZIaF+rflhuOh5/ojDGbvBW01EQFnMuViL8g4qUgdqRRRjE3nfKfMO0yji5S8YB92I+g18f6jF65V4e8Bd5MiegX+ck+3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvo7UfAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvo7UfAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22B9C32786;
	Thu, 15 Aug 2024 08:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723710020;
	bh=wd/Y+TeYN12Lhnm2jpny0XtOIGAI+2cFoEeolW+p4wo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pvo7UfAAcuYqLzpfuRr62Ufr7z30dSfnDKrmRdxpQg2OikS2qSa1g/waDKyns6obl
	 rSPUYYm3UYNg5HyI9N2BdRkC8U/7mjquoINEW9jgbc6GVtPRNhN+SC3/xc7rX1oXNA
	 /fGq8pcKBpcocHtMEsz+oGxLJ+/VFrFCZQrQa7xs=
Date: Thu, 15 Aug 2024 10:20:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kevin Holm <kevin@holm.dev>
Cc: "Lin, Wayne" <Wayne.Lin@amd.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"Deucher, Alexander" <Alexander.Deucher@amd.com>,
	"Wu, Hersen" <hersenxs.wu@amd.com>,
	"Wheeler, Daniel" <Daniel.Wheeler@amd.com>
Subject: Re: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
 request in resume
Message-ID: <2024081529-decidable-visor-6b22@gregkh>
References: <20240812160146.517184156@linuxfoundation.org>
 <20240812160156.489958533@linuxfoundation.org>
 <235aa62e-271e-4e2b-b308-e29b561d6419@holm.dev>
 <2024081345-eggnog-unease-7b3c@gregkh>
 <CO6PR12MB5489A767C7E0B1CFAEB069A0FC862@CO6PR12MB5489.namprd12.prod.outlook.com>
 <2024081317-penniless-gondola-2c07@gregkh>
 <12516acf-bee6-4371-a745-8f9e221bc657@holm.dev>
 <2d48c3c0-286d-4ed7-a3b6-5b4742b0e9d1@holm.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d48c3c0-286d-4ed7-a3b6-5b4742b0e9d1@holm.dev>

On Wed, Aug 14, 2024 at 09:43:23AM +0200, Kevin Holm wrote:
> On 8/13/24 21:54, Kevin Holm wrote:
> > On 13.08.24 17:26, Greg Kroah-Hartman wrote:
> >  > On Tue, Aug 13, 2024 at 02:41:34PM +0000, Lin, Wayne wrote:
> >  >> [AMD Official Use Only - AMD Internal Distribution Only]
> >  >>
> >  >> Hi Greg and Kevin,
> >  >>
> >  >> Sorry for inconvenience, but this one should be reverted by another
> > backport patch:
> >  >> "drm/amd/display: Solve mst monitors blank out problem after resume"
> >  >
> >  > What commit id in Linus's tree is that?
> > 
> >  From what I can tell it's:
> > e33697141bac18 ("drm/amd/display: Solve mst monitors blank out problem
> > after resume")
> > 
> > You've send out a message that it failed to apply to a few of the stable trees:
> > - 6.10: https://lore.kernel.org/stable/2024081212-vitally-baked-7f93@gregkh/
> > - 6.6 : https://lore.kernel.org/stable/2024081213-roast-humorless-fd20@gregkh/
> > - 6.1 : https://lore.kernel.org/stable/2024081213-sweep-hungry-2d10@gregkh/
> > 
> > To apply it on top of 6.10.5-rc1 these two patches need to be applied first:
> > f63f86b5affcc2 ("drm/amd/display: Separate setting and programming of cursor")
> > 1ff6631baeb1f5 ("drm/amd/display: Prevent IPX From Link Detect and Set Mode")
> > 
> > I don't know if that solves the problem I initially described as I'm currently
> > on a different setup. What I can say is that it applying those three patches on
> 
> Applying the three patches I listed above, fixes the problem for my setup. My
> external 4k monitors now get a signal both on boot and when resuming from sleep.

Ok, that worked for 6.10.y, but the dependant patches did not apply to
6.6.y or 6.1.y, so I'll only pick this up for 6.10.y for now unless
someone sends me a series of patches backported.

thanks,

greg k-h
