Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50AF13AA3B;
	Thu, 25 Jan 2024 21:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706219882; cv=none; b=SnUIS94EDT3TajskR2spSF0v0nuGgY1Z9W6h4J9EN4+GiQO80yIHEBm769tivDN32xJIHX2gV6Wxy9b3jDQA/y7obssKPbULHXhitJxdK3zuBoOUXmbjHguRqYL7TitB8xEuaomea62qFDIa/JUtZBzayS/1qj1OltMoX7Nb5Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706219882; c=relaxed/simple;
	bh=dJA8ukUqcFOmBQNm6u0gYzMGn+AjhiGhJRmPJwi3E3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iim5rD43c6OKM47SFR6mplZr8CdUey/BuB9ExKY5Q+TriLcx1K+io20zUJl/FwYjDAYtPLMwI89iGy0KDwmi3knKgUvqnnwTZcsHQK34IgIS/gNpgifEthrVUADmw8AhHdvKAAub3lBGhf/AB+5EQv+LYC5xPH56QpIefnctYaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgHYFBpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgHYFBpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AC8C433F1;
	Thu, 25 Jan 2024 21:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706219881;
	bh=dJA8ukUqcFOmBQNm6u0gYzMGn+AjhiGhJRmPJwi3E3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EgHYFBpg7DKZ2+HpDIdm3/fD0JqC5CqqCYYCuD2ip5rblWMZhf8f1attHwdF2F2le
	 7nOSzgX9lLP9aIHYNb7fJe1ROByKOauOIOVhNe7cl4P90V0922ya7hfTV80E9luxy0
	 AgtTKE84VKjIOV9WX0Iws4BcX7z7Heven/L6LOAw=
Date: Thu, 25 Jan 2024 10:48:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Song Liu <song@kernel.org>
Cc: Dan Moulding <dan@danm.net>, junxiao.bi@oracle.com, logang@deltatee.com,
	patches@lists.linux.dev, stable@vger.kernel.org, yukuai3@huawei.com
Subject: Re: [PATCH 6.7 438/641] md: bypass block throttle for superblock
 update
Message-ID: <2024012551-rebound-unworn-e467@gregkh>
References: <2024012316-phonebook-shrewdly-31f2@gregkh>
 <20240125003452.30195-1-dan@danm.net>
 <CAPhsuW66nd118Mxdvpia+NUq9kX8x5+e=ER+t7ubUBiSUBrX9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW66nd118Mxdvpia+NUq9kX8x5+e=ER+t7ubUBiSUBrX9w@mail.gmail.com>

On Wed, Jan 24, 2024 at 04:53:12PM -0800, Song Liu wrote:
> On Wed, Jan 24, 2024 at 4:34 PM Dan Moulding <dan@danm.net> wrote:
> >
> > > For now, I'm going to keep both commits in the stable trees, as that
> > > matches what is in Linus's tree
> >
> > Please consider reverting bed9e27baf52 in both Linus' tree and the
> > stable trees. That would keep them in sync while keeping this new
> > regression out of the kernel.
> >
> > > as this seems to be hard to reproduce
> > > and I haven't seen any other reports of issues.
> >
> > The change that caused the regression itself purports to fix a
> > two-year old regression. But since that alleged regression has been in
> > the kernel for two years, seemingly without much (if any) public
> > complaint, I'd say that the new regression caused by bed9e27baf52 is
> > definitely the easier one to reproduce (I hit it within hours after
> > upgrading to 6.7.1).
> 
> Agreed. I am thinking about reverting bed9e27baf52.

Ok, I've dropped d6e035aad6c0 ("md: bypass block throttle for superblock
update") from the stable queues right now, and I'll queue up the revert
posted as well.

If this gets straightened out in Linus's tree, and we need to take
anything into the stable trees, please let me know.

thanks,

greg k-h
