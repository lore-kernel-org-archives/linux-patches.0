Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F87438DD4;
	Mon,  9 Oct 2023 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8NkldTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F2AC433CA;
	Mon,  9 Oct 2023 17:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696873023;
	bh=BW2UXyZrvXyT/FZW+LrBqggagNr5D5MBdlmAiZdBZHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j8NkldTqlYjXAwPgzwSb89ZPTQnyDof4SI3tlaYG99WZSrp5QrGoEhumwJzN5ZtZK
	 Z7kQmdB1MEZO39b4QGLSseg2+P1TNcvf4++UwpMBg/D3Tys23SK2POEaI0NNPPiVnI
	 3UQmZwZApjsaLVdRjXh2JiRtifgw9pyaa7El88b8=
Date: Mon, 9 Oct 2023 19:37:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Peter Zijlstra <peterz@infradead.org>, rcvalle@google.com,
	Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	David Gow <davidgow@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
Message-ID: <2023100909-disperser-washable-4cbe@gregkh>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net>
 <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
 <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com>
 <CANiq72khuwOrAGN=CrFUX85UmPdJiZ2yM7_9_su_Zp951BHMMA@mail.gmail.com>
 <CAGSQo00gJsE+mQObeK4NNGDYLpZDDAZsREr15JcjD8Fo0E4pkw@mail.gmail.com>
 <CANiq72kK6ppBE7j=z7uua1cJMKaLoR5U3NUAZXT5MrNEs9ZhfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72kK6ppBE7j=z7uua1cJMKaLoR5U3NUAZXT5MrNEs9ZhfQ@mail.gmail.com>

On Mon, Oct 09, 2023 at 06:31:13PM +0200, Miguel Ojeda wrote:
> On Mon, Oct 9, 2023 at 6:01 PM Matthew Maurer <mmaurer@google.com> wrote:
> >
> > If the IBT part would be helpful by itself immediately, I can split
> > that out - it's only the KCFI portion that won't currently work.
> 
> Thanks Matthew. I don't think we are in a rush, but if it is not too
> much work to split it, that would be great, instead of adding the
> restriction.
> 
> For retthunk, by the way, I forgot to mention to Greg above that (in
> the original discussion with PeterZ) that I did a quick test back then
> to hack the equivalent of `-mfunction-return=thunk-extern` into
> `rustc` to show that the compiler could use it via LLVM (by passing
> the attribute in the IR). At least at a basic level it seemed to work:
> I got a userspace program to count the times that it went through the
> return thunk. I didn't try to do anything on the kernel side, but at
> least for the compiler side, it seemed OK. So it may be way easier (on
> the compiler side) than the CFI work?

It should hopefully be much easier than CFI, it was a much simpler
change to gcc and clang when it landed.

thanks,

greg k-h
