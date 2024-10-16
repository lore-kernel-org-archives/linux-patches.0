Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD452076B3;
	Wed, 16 Oct 2024 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729091986; cv=none; b=EMlTzUvFyvARd23kG6ZJuLbm4QcWQL9dfyQB1onN7daUBKHUBTuxyvmPlrHAmDFAdPOVEa6TuLw8MpknMTVvxpcvJKOwfzm07qwDEt4qmtYOS1TbsDb0TuSulzedQw00MGCthsNJITP3X3VDzu7j8ktiwWclxorYP925kce9gng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729091986; c=relaxed/simple;
	bh=9tawWsXOr7a9uNsOj09sklWZDzYGbRNHPnpkMUvRBeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C569dkmbDBDsOYSbCvf5BYgeIzTSFUjqHNfFVNr2G6Xw7HXmaFC2bTLkxQuI9GmNkyxYYvMBeO4eyoEpZAzr6j6Hm5+oft5xkksah8CgXllTVBZSQ2Yvab5JqTloZIhN1mOUc2ZyKP33OGkDQktm7U+gnh8wR+UqYLZOToKutqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l59W5P20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l59W5P20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F48C4CEC5;
	Wed, 16 Oct 2024 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729091986;
	bh=9tawWsXOr7a9uNsOj09sklWZDzYGbRNHPnpkMUvRBeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l59W5P20smFSHFiu2vnnYkATCLiJrpvR4QXUZRCxI5lOXF5MG7ffJw4d/zA9fyBEF
	 w/kD5szhUmuWjGgU0pZk+Y6QlH6JkoXWP8C5Vw0uKOnmN+nF78Nt4is4PBwyzAeFTI
	 H3hXdltlHccbReFf3YeWBDrW7M3G3AkKzNdxaLmhb/7XtSZXM4VU1xpkB8d9/b09G+
	 aX7zY4Vk7zwMXvIhEe0+nt3q5UAlGI6G1hMbPkNNVtugPLnTV6kjdpvhmRnp6XfWdd
	 +3kEmKUiDjfWOkNofq8uo3Glr0BR//dhSEcWyXKMIsAyeL3jOx8f4yFWbEbK63PfNU
	 KC0HI05AwjAFg==
Date: Wed, 16 Oct 2024 08:19:44 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Penkler <dpenkler@gmail.com>, linux-staging@lists.linux.dev,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] staging: gpid: fmh: Drop residue from
 fmh_gpid_fifo_read_countable()
Message-ID: <20241016151944.GA3153413@thelio-3990X>
References: <20241015-staging-gpib-fmh-fix-residue-used-uninitialized-v1-1-23ef05b099da@kernel.org>
 <2024101607-unmovable-serving-6a0d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024101607-unmovable-serving-6a0d@gregkh>

On Wed, Oct 16, 2024 at 09:59:31AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Oct 15, 2024 at 01:09:02PM -0700, Nathan Chancellor wrote:
> > Clang warns (or errors with CONFIG_WERROR=y):
> 
> <snip>
> 
> Nit, the subject should have had "gpib" not "gpid".  I've fixed it up
> when applying, thanks for the fix!

Thanks for doing that and not making me send a v2. Looks like I messed
it up in the function name too :/ I was also putting gbip at one point
but I caught that one, it's not a great abbreviation to try and remember
heh.

Cheers,
Nathan
