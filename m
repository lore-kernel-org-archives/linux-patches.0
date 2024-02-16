Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9895314691F;
	Fri, 16 Feb 2024 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708109181; cv=none; b=mCJbu/lj+zAp8D+Bn8kkwydUABal+rSugUJTjtPsh4KGOMEBu/lOQywSPmV+gsMzD+jMyc8ojE6VNqJei8voZkCUbdA5S0u/W5y01/yDGzQz9BErlyuzXm/H6Lpi1Hh9d5QeM2h5T8yi3MCarKcGQntZPyCu82S4kKD9AaNSBsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708109181; c=relaxed/simple;
	bh=LcjvOvjEXzkOCTEy61gj08EIdshAwDu7VquV5xvMt3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BrCOm21PtZqjiR9qdBghbzLaymCUAvYB+14IXppAanDGq/qEsbSUcL4FVv1W3mVyRfyGTwWKu764uENTDsoPbeYprn/x39pZjX4YECQ4rSIGqHqECk5kah6lQdhZvrruo8/IeU4NVxr6ITAIvLexqVjmjGQZG6oBu7uTPxcaopU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT/cqhPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT/cqhPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CDFC433F1;
	Fri, 16 Feb 2024 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708109181;
	bh=LcjvOvjEXzkOCTEy61gj08EIdshAwDu7VquV5xvMt3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vT/cqhPPHJetmA9NSdmrixhGoLhlczK07b3nwyV9cKR/N3/Q7XLV0aRnZ5ohLJ2uY
	 4uOXy9JlUyMXbHv/+xqfSLJfnidJyBRABC1O6uecPHJwlu1/ji/lxhO7tM2/uAwXOi
	 NdoLhK8KgjBd9NQ/48YALhsv4X4MvZL0hKNsaRqQ=
Date: Fri, 16 Feb 2024 19:46:13 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Frank Wang <frank.wang@rock-chips.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 6.7 093/124] Revert "usb: typec: tcpm: fix cc role at
 port reset"
Message-ID: <2024021630-unfold-landmine-5999@gregkh>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171856.446249309@linuxfoundation.org>
 <571afc70-dd77-4678-bdd0-673e15cdd5ad@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <571afc70-dd77-4678-bdd0-673e15cdd5ad@leemhuis.info>

On Fri, Feb 16, 2024 at 07:54:42AM +0100, Thorsten Leemhuis wrote:
> On 13.02.24 18:21, Greg Kroah-Hartman wrote:
> > 6.7-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Badhri Jagan Sridharan <badhri@google.com>
> > 
> > commit b717dfbf73e842d15174699fe2c6ee4fdde8aa1f upstream.
> > 
> > This reverts commit 1e35f074399dece73d5df11847d4a0d7a6f49434.
> 
> TWIMC, that patch (which is also queued for the next 6.6.y-rc) afaics is
> causing boot issues on rk3399-roc-pc for Mark [now CCed] with mainline.
> For details see:
> 
> https://lore.kernel.org/lkml/ZcVPHtPt2Dppe_9q@finisterre.sirena.org.uk/https://lore.kernel.org/all/20240212-usb-fix-renegade-v1-1-22c43c88d635@kernel.org/

Yeah, this is tough, this is a revert to fix a previous regression, so I
think we need to stay here, at the "we fixed a regression, but the
original problem is back" stage until people can figure it out and
provide a working change for everyone.

thanks,

greg k-h
