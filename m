Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FAA5028C;
	Thu,  5 Dec 2024 22:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733437317; cv=none; b=tfka1aJJTDKO8lLGPGp1AjFscrsda4W7Agdciy2aVnuhH14mX0+to9FfevpvPV1wFL/bhD7I+S3McPdCxpRuifburr5HgqCqqlcazOoVJXYU4LfnCOwWk8uEbQfniYTX1dE4Oj46xLVI8M9DhxKoi3ZJ1w3y/w+TfvDuliyFGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733437317; c=relaxed/simple;
	bh=Cwa97oyVcB0+KnxmE2xDjfUSlj2KLG05bUzt8wXdrQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvHfBhNRhz6hAlacodlmjUTn71aNMWfEvuUv+vBZD4LhFqul4NB5OW8G4GsDHTtHRK4Zo145ewBS5TF1ovjTXxP3gFk1nwyu77f7I7+wASNt0+RrxSR4H5ltlaBWIDj581Jb1b83ele8FE7+GqYKgvPoYT9Htdab9kkRMdP1dgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vzb3GEeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vzb3GEeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A622DC4CEDD;
	Thu,  5 Dec 2024 22:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733437316;
	bh=Cwa97oyVcB0+KnxmE2xDjfUSlj2KLG05bUzt8wXdrQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vzb3GEebsl9YsolZ+gOH4FAm+j+OW/SfyOXc828g3tKggRTEfyI0+qlXsjT/ohk/7
	 rnkQSjp2BDbZutSr1aRChpOZscdxcr93tKRw+9iLANEMcc/lEdcBNDuSH364pku9HK
	 a0Jq1HroGOANRX/0ItK7PgDHw4+5eMJMU3he0I6KiOJRprUmNsiCfnJ3WeA8LSMnRM
	 OV8rqmXI+UfJJdj+ozkLitWFky0jJ9fBuF0S7W5dmF6it94THta2Y3V8S2DXBAAapM
	 E16cX+pVYPZbOLpiJhOzmzvCcwdxFbfgSgTxnMt0+0SetNuBI7UMjLvYSqh1p0+0zs
	 UvPkX0SGnReDQ==
Date: Thu, 5 Dec 2024 14:21:55 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Daniel Gomez <da.gomez@samsung.com>
Cc: patches@lists.linux.dev, fstests@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, gost.dev@samsung.com,
	sandeen@redhat.com
Subject: Re: [PATCH] common/config: use modprobe -w when supported
Message-ID: <Z1Ing_noobsMJCRS@bombadil.infradead.org>
References: <CGME20241205002632eucas1p1550f6c9513d111b21cb22cacb09ed680@eucas1p1.samsung.com>
 <20241205002624.3420504-1-mcgrof@kernel.org>
 <95e41652-65c9-4fd7-9cc4-344b90b006b6@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95e41652-65c9-4fd7-9cc4-344b90b006b6@samsung.com>

On Thu, Dec 05, 2024 at 08:41:22AM +0100, Daniel Gomez wrote:
> On 12/5/2024 1:26 AM, Luis Chamberlain wrote:
> > We had added support for open coding a patient module remover long
> > ago on fstests through commit d405c21d40aa1 ("common/module: add patient
> > module rmmod support") to fix many flaky tests. This assumed we'd end up
> > with modprobe -p -t <msec-timeout> but in the end kmod upstream just
> 
> I can't find modprobe -p and/or -t arguments in the manual. What do they
> mean?

I had proposed -p to mean patient module remover with a default timeout
set, -t to override. In the end this went upstream instead over a lot of
dialog with just -w <timeout>.

> but i can't find the module remover support in kmod.
> 
> 
> Nit. I find useful using the long argument instead of the short one (e.g.
> --wait instead of -w). as it's usually self-descriptive. But I guess we
> don't have that long option for -p and -t?

It was one or the other that went upstream, we implemented this on
fstests upstream as an open coded solution while we wanted for this
meachanism to be agreed upon and merged. I just forgot to come back to
this after -w was merged and decided upon.

  Luis
