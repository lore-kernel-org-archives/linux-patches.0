Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2211233F0;
	Fri,  9 Dec 2022 13:55:00 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1670594093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ab75hFCZtUT7NrQrs3DM49B+BwGSoyqvD4tFdAumbY8=;
	b=RY1QOIM2IVUHyu82WZu8x/LEwRJC+kSbaeaJMlfJQYdu94BG4e7bwwSPU1tQ10LRASCLUp
	AUVCjuT/RIcF0y3FQn5exvMNkS7wwVmSTUQ1oN5xjGu0vMcL5d3HdFE3V4fB9TLojNSZG9
	oB3QnTwBMtNPz4dDwOYtyKbhwFCXH8kq+AulIRwDOguTqLD4etEJVmAzjCL/POQkx3z+gE
	fGL+lUDIthdxP4+1eQ+A9jsma+DWxZLYvt8t0lMeAh4MJDE2ohx6yf53JsxXPogUqpdiu5
	FdJ15QHYjtViEtUBA3paOnmbmOU1k10P5k8f2p2XN85DNdbH881AXs2K9PjLSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1670594093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ab75hFCZtUT7NrQrs3DM49B+BwGSoyqvD4tFdAumbY8=;
	b=oW4Vnw2FpxWvCwG7welZP6XVKyLewZIllvjl7J9QiidSpN3OjGxaGVJ1wEBxHXEw/g2YNk
	fItVdWWz4MTVemDA==
To: Nathan Chancellor <nathan@kernel.org>, Andy Lutomirski
 <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] x86/vdso: Conditionally export __vdso_sgx_enter_enclave
In-Reply-To: <Y5M8SZEN1N5Dt15X@dev-arch.thelio-3990X>
References: <20221109000306.1407357-1-nathan@kernel.org>
 <Y5M8SZEN1N5Dt15X@dev-arch.thelio-3990X>
Date: Fri, 09 Dec 2022 14:54:52 +0100
Message-ID: <87r0x8d6mr.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Dec 09 2022 at 06:46, Nathan Chancellor wrote:
> Ping? The default switch was remerged a couple of days ago so builds
> with tip of tree LLVM are going to be broken again:
>
> https://github.com/llvm/llvm-project/commit/241dbd310599e3c1a0f1b0c9ced14c8b8760539e

Sorry. That fell through the cracks. I'll take care of it.

