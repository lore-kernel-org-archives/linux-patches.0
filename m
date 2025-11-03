Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED191C84D7;
	Mon,  3 Nov 2025 01:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762134269; cv=none; b=NKdDXFzrsYpW79J9QQKe7vWHBAjJc2ab3irky37LKmixNPEpM9r2mDlYROY68+YCyuQqTRytzK/tTo/THXItlplJPfjd3IxFkKnzTdvQvgrWc8kq933Loq3foArnWD6sTLezlfOCSjSabMDZnpGV8B2CrivAlDZ9kUbx2XIdH+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762134269; c=relaxed/simple;
	bh=sVX4FIAq95ahP6Nry8xF7cVDyQMWcwDFWp7+zU+5KUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ulh/K9u15CRjf6FzzgYu8FA4CAVEqa9l+Eq0GVkn3Ck8RuNhOpRtAGpK3fYuCDB5QviMpkOiSbsAg/tatK9RMnV0oaRZlI72/UauHxXWBSUUUN/FCVVmEdVFXTbuejeLDfmhur0+tmK3yGRtTOXgRKI3OUMM9T5WbVNerGfNbL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHjcZGl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHjcZGl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0B3C4CEF7;
	Mon,  3 Nov 2025 01:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134269;
	bh=sVX4FIAq95ahP6Nry8xF7cVDyQMWcwDFWp7+zU+5KUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gHjcZGl8HuKNgmt8XyKwfY04mPvZodWlFKpULdddOBKpdobiB6PuVsipahraUvlZi
	 BmnIT/bQ/DVrCFyslHOBkOC4bnrplshCDhWADs5MS9zYSCXBp86B3zbs12t9TQx6Jr
	 CZ6fjQvcluRBkXK9d+vgzDfrbwC6nv4wWl80DaTQ=
Date: Mon, 3 Nov 2025 10:44:27 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kees Cook <keescook@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: Re: [PATCH 5.10 013/122] compiler.h: drop fallback overflow checkers
Message-ID: <2025110317-monstrous-flounder-584d@gregkh>
References: <20250930143822.939301999@linuxfoundation.org>
 <20250930143823.531610305@linuxfoundation.org>
 <92fe5b00bb5a4298d1a48c4c220e15a761e22a45.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92fe5b00bb5a4298d1a48c4c220e15a761e22a45.camel@decadent.org.uk>

On Tue, Oct 21, 2025 at 08:02:36PM +0200, Ben Hutchings wrote:
> On Tue, 2025-09-30 at 16:45 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Nick Desaulniers <ndesaulniers@google.com>
> > 
> > [ Upstream commit 4eb6bd55cfb22ffc20652732340c4962f3ac9a91 ]
> > 
> > Once upgrading the minimum supported version of GCC to 5.1, we can drop
> > the fallback code for !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.
> [...]
> 
> Well, that only happened in 5.15.  So either 5.10 should also have:
> 
> commit 76ae847497bc5207c479de5e2ac487270008b19b
> Author: Nick Desaulniers <ndesaulniers@google.com>
> Date:   Fri Sep 10 16:40:38 2021 -0700
>  
>     Documentation: raise minimum supported version of GCC to 5.1
> 
> or this should be reverted.  (I don't care about such ancient versions,
> but I do want this to be a clear decision and not an accidental change.)

This should be fixed up in the next release, thanks.

greg k-h
