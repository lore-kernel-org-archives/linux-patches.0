Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2650A63B7;
	Fri,  9 Dec 2022 15:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30431C433EF;
	Fri,  9 Dec 2022 15:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670601358;
	bh=J8o6E+k/8LtCUpKKa8lOQZkdxr+zp18CG3T6nSOV1sc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kSchAmwR3VDys2ljiTS32Vw4Cvkc/1wX8Tp5njW218146mNFNsIEWLCf2sVL2mDXK
	 +9z2Lb+unsNJf6V/Za1XM+cMx0Njy7ll+z+2C6q7FqHhVBiRpWZqgXN7s+GxwpM6QK
	 2qk4cQylmwReNP/GHBfUpup6iZpKjJQEj3IkVV3iv7aZRzUvy9v1vDq8jms8o6Hrc3
	 kHqjXkP+fGX2pFdKY4b8DuzKVV9vCcSb2ZgTA+yQuGz4Y+nbNI1OMJEBVHTTw6o2QO
	 TpL1NM3ITAXFMZWZRCkS/6aFWW6ew4iZMueeygjGWl3RF4WXBBe1UPBmXfSN72yZ9o
	 hvfNqK8VE+iLA==
Date: Fri, 9 Dec 2022 08:55:56 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] x86/vdso: Conditionally export __vdso_sgx_enter_enclave
Message-ID: <Y5NajERIilxBrobj@dev-arch.thelio-3990X>
References: <20221109000306.1407357-1-nathan@kernel.org>
 <Y5M8SZEN1N5Dt15X@dev-arch.thelio-3990X>
 <87r0x8d6mr.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0x8d6mr.ffs@tglx>

On Fri, Dec 09, 2022 at 02:54:52PM +0100, Thomas Gleixner wrote:
> On Fri, Dec 09 2022 at 06:46, Nathan Chancellor wrote:
> > Ping? The default switch was remerged a couple of days ago so builds
> > with tip of tree LLVM are going to be broken again:
> >
> > https://github.com/llvm/llvm-project/commit/241dbd310599e3c1a0f1b0c9ced14c8b8760539e
> 
> Sorry. That fell through the cracks. I'll take care of it.

Thanks Thomas! I get you all are always busy so I appreciate the quick
response.

Cheers,
Nathan
