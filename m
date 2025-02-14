Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C176134AB;
	Fri, 14 Feb 2025 18:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739559249; cv=none; b=YNuDLa+Nc32ONBab1mlb3viEkKcDO54QbA0M7kaWN1vxws5oL7SAz84rrpJUHaHe5M8JIaih7R5/C77I8O9KNkEH12OwX51FnhvPhOqAcaDyDRbDC9piuiLOqj35yEAZMwgFvoQzd0xEMLBRU2Iwt2dHnXCSh6xz/zhc9We8UjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739559249; c=relaxed/simple;
	bh=CdQQmkY1frX7rOg0v2xluKUqZNensdHIXPSt4opexaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GMGunnQyn3lHUy68tJ29NaE3s/++Sdm++ti7M6zBVxX9XFHRO/ljtWUJg2OsqHbATOYUfIMI/X3xefsIFHE02fPu9iKGhr6wU2qHCuRAdQbMIaa1IYUvovibOhzJdlyDX71NblxSheMVBa3D4qq+8s74O/hU9btRgOwi+fN3+8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7ZLoy6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7ZLoy6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78ABDC4CED1;
	Fri, 14 Feb 2025 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739559248;
	bh=CdQQmkY1frX7rOg0v2xluKUqZNensdHIXPSt4opexaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M7ZLoy6rqavRg54OkYuZ4gCGwK2Kfskj7/v95wA6g5S7D7E2f2XKeXxUmI5BWhWxk
	 KJaBTpD29KJrRmFnVaUpfhIdIHw+mJuYlFYSs/al4A1U9BY4ASxcqwVcqXD6o46t6m
	 s4HQyupRwUaoiTWrcF8g6RoWL3Z3HXuYI1fM5D+ISoMbX5/6UWbzKmd2SKjHmr3jgT
	 6tbzmDMZMRFo3yt5hff4YOROaD6Cht/NgQoCqid7XRohpJrtoV34aG+87yOltQKFcM
	 yVF1tI5IDaSJY+YH3B2tsY8RfvTsPT47Jlu9Md8b9ev0uKIQKk03gSjcU5RZuuX5AS
	 owigVcUFG72Ug==
Date: Fri, 14 Feb 2025 10:54:07 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v3 0/6] enable bs > ps device testing
Message-ID: <Z6-RTxfPGWrAsNvC@bombadil.infradead.org>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
 <shkzvixvm26ojvvergul7orla45jsmgw5fcozm7en55sh7zen5@63udt7eqtvf5>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <shkzvixvm26ojvvergul7orla45jsmgw5fcozm7en55sh7zen5@63udt7eqtvf5>

On Fri, Feb 14, 2025 at 11:34:07AM +0000, Shinichiro Kawasaki wrote:
> On Feb 12, 2025 / 12:54, Luis Chamberlain wrote:
> > This v3 series addresses the feedback from the v2 series [0] and
> > makes some minor new changes, the change are:
> > 
> >   - Fixes all shellcheck complaints
> >   - Addresses spacing / tabs fixes
> >   - Adds _test_dev_suits_xfs() as suggested by Shinichiro and makes
> >     tests which require this depend on it
> >   - Clamps _min_io() to 4k as well for backward compatibility
> >   - Few minor enhancements to help capture up error messages from
> >     mkfs from block/032
> > 
> > This goes tested against a 64k sector size NVMe drive, and also
> > using ./check so regular loopback devices are used. This helps
> > test 64k sector devices, patches for which have been posted [1].
> >                                                                                                                                                                                               
> > [0] https://lkml.kernel.org/r/20250204225729.422949-1-mcgrof@kernel.org
> > [1] https://lkml.kernel.org/r/20250204231209.429356-1-mcgrof@kernel.org
> 
> Luis, thank you very much for the improvements. I made comments on some of
> the patches. FYI, I reflected my comments on your patches, and pushed them to a
> github repo branch [2]. Please take a look in them and see if my comments make
> sense or not.
> 
> [2] https://github.com/kawasaki/blktests/commits/bs_ps/

Looks good, thanks for doing this, passes all my tests too, please feel
free to merge :)

  Luis
