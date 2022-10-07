Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9464A35
	for <patches@lists.linux.dev>; Fri,  7 Oct 2022 17:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qu0RZlUOKHKbdJ93oyFutpaLoUL4bQrVrDVJWi930ac=; b=Q0GO23CTsRrxoMOQjBT07b+fbV
	xuHE10+DAr4bRVKdI21rVUamN7uWea2x2WNRmw/k4O6MPz8tcxa0e8gdbRgtcikOsgRm6U9bVNtj9
	NemvdrSzkjq+5qZFSIqDfYcP8/khTwRJLWO0ENyhwlnjl6OavwwZ8pJQTslvlxA2g5xz9ZiMn/EMg
	/E+xc4H9GfCHrxZhwZiHBU/LTfFOo8WVgshOfZdrGzyNdpgp83WFv+VRxyL/XYtl5vEpxXugq7AaZ
	2mOeZtggX+2Xr6/40reAzY+9g41G18YaYwerbGXemmx2SzKVpAHhNMH0SqaJq6UMRCnjJCBos635x
	D2zSOXeQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ogqyr-0022Yg-Rl; Fri, 07 Oct 2022 17:17:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 911D3300155;
	Fri,  7 Oct 2022 19:17:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 753BC2BD94364; Fri,  7 Oct 2022 19:17:43 +0200 (CEST)
Date: Fri, 7 Oct 2022 19:17:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-26-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-26-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:56PM +0200, Miguel Ojeda wrote:
> Note that only x86_64 is covered and not all features nor mitigations
> are handled, but it is enough as a starting point and showcases
> the basics needed to add Rust support for a new architecture.

Does it fail the build if required options are missing? Specifically are
things like kCFI and IBT enabled? Silently not handling those will
result in an unbootable image.

As to missing mitigations; does it at least visibly warn people?

I'm very *very* uncomfortable having to 'support' a half-arsed compiler
like this.
