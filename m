Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723FA1FD1;
	Sat,  7 Oct 2023 11:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2pkUPld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472E6C433C8;
	Sat,  7 Oct 2023 11:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696679626;
	bh=dqUCLf7VJJQ0WmX/MCm12hiJxadk/DBDL9bDj5rTUg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W2pkUPldZaTK/U7f0cFp/yf/G63SlUhl3nWK3cjfVeiNanEE7E9G2CMVFUHlLgvBB
	 7Vr0vlqLLcAmWY7UkdAVjMhXigqf8FVEPeV1idcOBdEOYz7DSTQ2XOYnJk/+quBebH
	 G9YW5ejUnFDKPcawvr4tWTQFF3r8BQEUIYsLULnE=
Date: Sat, 7 Oct 2023 13:53:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	stable <stable@kernel.org>, Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-media@vger.kernel.org,
	linux-modules@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH 4.19 178/273] media: dvb: symbol fixup for dvb_attach()
Message-ID: <2023100730-imprint-follow-56ec@gregkh>
References: <20230920112846.440597133@linuxfoundation.org>
 <20230920112852.017230256@linuxfoundation.org>
 <b12435b2311ada131db05d3cf195b4b5d87708eb.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b12435b2311ada131db05d3cf195b4b5d87708eb.camel@decadent.org.uk>

On Thu, Sep 28, 2023 at 01:36:06AM +0200, Ben Hutchings wrote:
> On Wed, 2023-09-20 at 13:30 +0200, Greg Kroah-Hartman wrote:
> > 4.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > commit 86495af1171e1feec79faa9b64c05c89f46e41d1 upstream.
> > 
> > In commit 9011e49d54dc ("modules: only allow symbol_get of
> > EXPORT_SYMBOL_GPL modules") the use of symbol_get is properly restricted
> > to GPL-only marked symbols.  This interacts oddly with the DVB logic
> > which only uses dvb_attach() to load the dvb driver which then uses
> > symbol_get().
> > 
> > Fix this up by properly marking all of the dvb_attach attach symbols as
> > EXPORT_SYMBOL_GPL().
> [...]
> 
> This (and other) backports missed a couple of affected exports:
> 
> - sp8870_attach in drivers/media/dvb-frontends/sp8870.c
>   (renamed to drivers/staging/media/av7110/sp8870.c upstream)
> - xc2028_attach in drivers/media/tuners/tuner-xc2028.c
>   (renamed to drivers/media/tuners/xc2028.c upstream)

Thanks for catching this, fixed up now for 4.14.y and 4.19.y.

greg k-h
