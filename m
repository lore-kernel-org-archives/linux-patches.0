Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BBD7B;
	Mon, 17 Oct 2022 00:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D909C433C1;
	Mon, 17 Oct 2022 00:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1665966496;
	bh=8WWs9l2qmGMghweN7Ckgt8DaX3cG0OZdXxkM6TKYH6g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XvguAicoL8TSob5RaCJ1spC8fTW535GDGPGmIeJqsUbMegUQgUfIZqKLGN8doPap6
	 rlQcttXjKZaERBO515DWE+A4kKsh18wQ4rFtJj6yPsLVghtZ8l21QGuWZNDBiY6bxl
	 ticivMkLffHyBnxcxWZes4OauqiUkqBsk9jAXjGc=
Date: Sun, 16 Oct 2022 17:28:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Conor Dooley <conor@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, llvm@lists.linux.dev
Subject: Re: [PATCH v2] lib/Kconfig.debug: Add check for non-constant
 .{s,u}leb128 support to DWARF5
Message-Id: <20221016172815.f5a5f1f86af7ff1937a2e273@linux-foundation.org>
In-Reply-To: <20221014204210.383380-1-nathan@kernel.org>
References: <20221014204210.383380-1-nathan@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Oct 2022 13:42:11 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> When building with a RISC-V kernel with DWARF5 debug info using clang
> and the GNU assembler, several instances of the following error appear:
> 
>   /tmp/vgettimeofday-48aa35.s:2963: Error: non-constant .uleb128 is not supported

hm, which kernels want this?

I could merge it for 6.1, which seems suitable.  If we want it
backported into earlier kernels then a Fixes: would be nice, to prevent
it from being ported back further than necessary.

