Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDFE168BD;
	Thu, 30 May 2024 07:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717054810; cv=none; b=rhyOyDZ/UKk8oLnASCm1lqWVFWAoXh9SFTz+sRmuz2uL9YT7V46AhUhtY9UMsjlDHIxkg2vyiTt/J9WNZDZJwTEofLB4H0gGCIUJJLRns0x1fiO4vj6yz1iS4dhcMtY0wiJl4ZCFaR1YMIv3/tWy3PZIdQmWL5XdPcJ72VEaYPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717054810; c=relaxed/simple;
	bh=wNN960FphnubiQ9QbNQbnvG3rJVXxUI69WDQ4o/6EvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzgYyxdSxoXSgyd/NhFIWyxxkBdlKcxgUNOjfGvVPq+T0g2w3u1NKGvuF058C5HYvBKsWiYYxd4KRz7Lg8C770mLNWZ2otN3QfgUhJawCwsQzGUV/3tQ0uWvZWkt4F7SG921d4kNP3mGziZ1O4Mz19ZnL0EMa5mPDneXNBE2uA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayoqaR3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayoqaR3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAFFC2BBFC;
	Thu, 30 May 2024 07:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717054809;
	bh=wNN960FphnubiQ9QbNQbnvG3rJVXxUI69WDQ4o/6EvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ayoqaR3eB0FFbwcg8JkZVAtblT/BzCHcQScR/gPHUtH/y7vPIJKjPvU/+X9iEVzaN
	 oJwFP4vJaOuoRF4EPFu34dPav4543Rz0lNbrOAR9Vt7LIYA73if6sk1jCkaeOB0700
	 H5wFz1FRmjTqxJoE28bumw2DwcLFeIZxEtoovx/U=
Date: Thu, 30 May 2024 09:40:13 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-serial@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
Message-ID: <2024053008-sadly-skydiver-92be@gregkh>
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
 <d7c19866-6883-4f98-b178-a5ccf8726895@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c19866-6883-4f98-b178-a5ccf8726895@kernel.org>

On Thu, May 30, 2024 at 08:22:03AM +0200, Jiri Slaby wrote:
> >  This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
> >      291 |         struct mxser_port ports[] __counted_by(nports);
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >    1 error generated.
> > 
> > Remove this use of __counted_by to fix the warning/error. However,
> > rather than remove it altogether, leave it commented, as it may be
> > possible to support this in future compiler releases.
> 
> This looks like a compiler bug/deficiency.

I agree, why not just turn that option off in the compiler so that these
"warnings" will not show up?

> What does gcc say BTW?
> 
> > Cc: stable@vger.kernel.org
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/2026
> > Fixes: f34907ecca71 ("mxser: Annotate struct mxser_board with __counted_by")
> 
> I would not say "Fixes" here. It only works around a broken compiler.

Agreed, don't add Fixes: for this, it's a compiler bug, not a kernel
issue.

thanks,

greg k-h
