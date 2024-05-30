Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE9347A73;
	Thu, 30 May 2024 17:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717091009; cv=none; b=A98EnyAWWBBUP6nELFgF3gRN5PuxOUGMOTO+n8Gd1B3BPeHleE72DL048A/4DWCP+7IRY8cT2sFgIrUdR5bksLx2JbigiNgI7IRTJJSQtzOLuDPO2trmGVOj7w6RQI1mC0fmAxEMYseKi92PgiU75cD3Vw6klduA+WwdrFT2tFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717091009; c=relaxed/simple;
	bh=8fcphnfj+O2CwB7e1G0DKa0lKG2nE+NF5g3drom6Aiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YwHi14jFGLwho1XJd4wfnvSr3o86xoQC4HksJVX2C+KZccT5mZrL5+PNg/qJbYJGlbajvyDdJRHxd4ca81ehzIEP4AMFDOTYt4jJ6Gzrf2Vj6A0f8rFW1ihA/h5lGKI/uYQ2IdqD2atETdmur04jGDk+2u/65ao1NPiuAM/JTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMcGGFQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMcGGFQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B43C2BBFC;
	Thu, 30 May 2024 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717091009;
	bh=8fcphnfj+O2CwB7e1G0DKa0lKG2nE+NF5g3drom6Aiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aMcGGFQyFAeT1sScSa+Y1stGV15mVtxb5fUMSCFGMM06VxG5JpaOJjozldpE+AYUP
	 w0T0zK2gt2Z77DddsikCWJLJmpve4SEv5rcnTg4ProZVOeFR87tJx4ETV84OazMuBm
	 I50Xu1AffzkmoOeBkB46pqCp1/RJTkEm4Si0k3jFhrpq8O4JYsohzLIjKnM1fLnYCi
	 h3GbpFPIlhP5D8w9jsOlFv+XqLuefxaiy/vUvbXLGNXfcheYet2zzvwjEn0smU5fsZ
	 CV+K4AHPNw77aKq0/Y281I27I9+y1LBbeFywbz9kUuvbBUyUmKFTe3JQNmBB20a9Zf
	 wmihACkzroVqQ==
Date: Thu, 30 May 2024 10:43:26 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-serial@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
Message-ID: <20240530174326.GB3018978@thelio-3990X>
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
 <d7c19866-6883-4f98-b178-a5ccf8726895@kernel.org>
 <2024053008-sadly-skydiver-92be@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024053008-sadly-skydiver-92be@gregkh>

On Thu, May 30, 2024 at 09:40:13AM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 30, 2024 at 08:22:03AM +0200, Jiri Slaby wrote:
> > >  This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
> > >      291 |         struct mxser_port ports[] __counted_by(nports);
> > >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> > >    1 error generated.
> > > 
> > > Remove this use of __counted_by to fix the warning/error. However,
> > > rather than remove it altogether, leave it commented, as it may be
> > > possible to support this in future compiler releases.
> > 
> > This looks like a compiler bug/deficiency.

I apologize. As I commented on the nvmet-fc patch, I should have
included where the flexible array member was within 'struct mxser_port',
especially since I already knew it from
https://github.com/ClangBuiltLinux/linux/issues/2026.

I hope we can all agree now that this is not a compiler bug or issue.

> I agree, why not just turn that option off in the compiler so that these
> "warnings" will not show up?

I think the only part of the warning text that got quoted above should
clarify why this is not a real solution.

For the record, if this was a true issue on the compiler side, I would
have made that very clear in the commit message (or perhaps not even
sent the patch in the first place and worked to get it fixed on the
compiler side, as ClangBuiltLinux has always tried to do first since the
beginning).

> > What does gcc say BTW?

GCC does not have any support for __counted_by merged yet. I suspect
that its current implementation won't say anything either, otherwise
Kees should have noticed it in his testing. As you and Gustavo note
further down thread, sentinel is flagged by
-Wflex-array-member-not-at-end.

  In file included from include/linux/tty_port.h:8,
                   from include/linux/tty.h:11,
                   from drivers/tty/mxser.c:24:
  include/linux/tty_buffer.h:40:27: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
     40 |         struct tty_buffer sentinel;
        |                           ^~~~~~~~

Gustavo has a suggested diff to resolve the issue at the GitHub issue I
linked above that seems like a reasonable fix for both issues that is
small enough to go into stable trees that contain f34907ecca71 like this
one?

Cheers,
Nathan
