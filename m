Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3731A2F502;
	Thu, 26 Oct 2023 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44278C433C8;
	Thu, 26 Oct 2023 15:28:48 +0000 (UTC)
Date: Thu, 26 Oct 2023 16:28:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, will@kernel.org,
	ndesaulniers@google.com, trix@redhat.com,
	linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] arm64: Restrict CPU_BIG_ENDIAN to GNU as or LLVM IAS
 15.x or newer
Message-ID: <ZTqFrf20z_RTB4sI@arm.com>
References: <20231025-disable-arm64-be-ias-b4-llvm-15-v1-1-b25263ed8b23@kernel.org>
 <ZTlYEZ7miLF0gDJj@FVFF77S0Q05N.cambridge.arm.com>
 <20231025183114.GA669177@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025183114.GA669177@dev-arch.thelio-3990X>

On Wed, Oct 25, 2023 at 11:31:14AM -0700, Nathan Chancellor wrote:
> On Wed, Oct 25, 2023 at 07:01:53PM +0100, Mark Rutland wrote:
> > On Wed, Oct 25, 2023 at 10:21:28AM -0700, Nathan Chancellor wrote:
> > > A recent refactoring in the arm64 tree exposed an assembler bug in LLVM
> > > with regards to the generation of NOPs for arm64 big endian, resulting
> > > in near-immediate crashes on boot in QEMU.
> > 
> > Could we please put a bit more detail into the commit message about what
> > exactly went wrong and how this was detected? I know that can be found
> > from the github links below, but having to go chase that is a bit of a
> > pain.
> 
> Sure, sorry for leaving that out of the initial revision.
> 
> > Would you be happy with the below? I've also added a Cc stable, since
> > this is a potential state corruption issue.
> 
> That text looks much better to me, especially since it explains exactly
> what goes wrong here (which I was unsure of, this helps). Thanks a lot!
> 
> Will / Catalin, would you like a v2 with that text or could it just be
> copied and pasted from Mark's mail during application time? I am happy
> to do whatever.

I'll copy/paste Mark's text, no need for v2. Thanks.

-- 
Catalin
