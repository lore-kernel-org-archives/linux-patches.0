Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D601C11;
	Wed, 26 Oct 2022 16:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07329C433C1;
	Wed, 26 Oct 2022 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666802343;
	bh=4gG/8lY0Eu0LFKD8NmUND/jh6Wol8H9kVyNLR1/Xkd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lZ9s40w0PWSuBrI9jbQXsQpTGCfO0yEOQit3cPIl0dyiUVx+hOpGQ2xViPxxNpZro
	 /Pe5sv2hxDtnY4ffLDegs8JA76zR/zxB2J+OE4SRQLDz/A3PwpL4+6+Ur1nFK9GEd/
	 DAsgRnG6ZcP/wMoaTb5D/iXrw74lXvP+wj1lh+VVA4zJlIYF/+2O4XPaOPIhDmr4Kq
	 Z4HbaBVr7tC3ZcYs6tgJy9X0Gvd2tiRbOClzgJt90ZUwNBgddah5SFdP8Ss/AqqlYY
	 pzv1n0WZa7SoSlIQLb1LXpUqZz4in0SuPq/3IXRYJ3/oihNK8qYzHjLoENSZ9di7SI
	 1axQsOAMs6bCQ==
Date: Wed, 26 Oct 2022 09:39:01 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautam Menghani <gautammenghani201@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm/khugepaged: Initialize index and nr in collapse_file()
Message-ID: <Y1lipZXfRStgms/7@dev-arch.thelio-3990X>
References: <20221025173407.3423241-1-nathan@kernel.org>
 <20221025184802.7d4611caff603fecf98330b6@linux-foundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025184802.7d4611caff603fecf98330b6@linux-foundation.org>

On Tue, Oct 25, 2022 at 06:48:02PM -0700, Andrew Morton wrote:
> On Tue, 25 Oct 2022 10:34:07 -0700 Nathan Chancellor <nathan@kernel.org> wrote:
> 
> > Clang warns (trimmed for brevity):
> > 
> >   mm/khugepaged.c:1729:7: warning: variable 'index' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
> >   mm/khugepaged.c:1716:6: warning: variable 'index' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
> >   mm/khugepaged.c:1729:7: warning: variable 'nr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
> >   mm/khugepaged.c:1716:6: warning: variable 'nr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
> > 
> > There are two goto statements that will use index and nr before they
> > have been properly initialized. Zero initialize them so that they can be
> > safely used by the tracepoint at the end of the function.
> 
> Thanks.  I've actually dropped the offending patch - I'd like a resend
> which includes a fix such as this and a good reason for making the
> change.

That certainly seems like a reasonable request. Thanks for letting me
know!

Cheers,
Nathan
