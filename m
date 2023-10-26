Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C8D2F502;
	Thu, 26 Oct 2023 15:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C9062F4;
	Thu, 26 Oct 2023 08:32:44 -0700 (PDT)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com [10.1.31.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1B5D3F64C;
	Thu, 26 Oct 2023 08:32:01 -0700 (PDT)
Date: Thu, 26 Oct 2023 16:31:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nathan Chancellor <nathan@kernel.org>, will@kernel.org,
	ndesaulniers@google.com, trix@redhat.com,
	linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] arm64: Restrict CPU_BIG_ENDIAN to GNU as or LLVM IAS
 15.x or newer
Message-ID: <ZTqGb3MJD6jYZyVR@FVFF77S0Q05N.cambridge.arm.com>
References: <20231025-disable-arm64-be-ias-b4-llvm-15-v1-1-b25263ed8b23@kernel.org>
 <ZTlYEZ7miLF0gDJj@FVFF77S0Q05N.cambridge.arm.com>
 <20231025183114.GA669177@dev-arch.thelio-3990X>
 <ZTqFrf20z_RTB4sI@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTqFrf20z_RTB4sI@arm.com>

On Thu, Oct 26, 2023 at 04:28:45PM +0100, Catalin Marinas wrote:
> On Wed, Oct 25, 2023 at 11:31:14AM -0700, Nathan Chancellor wrote:
> > On Wed, Oct 25, 2023 at 07:01:53PM +0100, Mark Rutland wrote:
> > > On Wed, Oct 25, 2023 at 10:21:28AM -0700, Nathan Chancellor wrote:
> > > > A recent refactoring in the arm64 tree exposed an assembler bug in LLVM
> > > > with regards to the generation of NOPs for arm64 big endian, resulting
> > > > in near-immediate crashes on boot in QEMU.
> > > 
> > > Could we please put a bit more detail into the commit message about what
> > > exactly went wrong and how this was detected? I know that can be found
> > > from the github links below, but having to go chase that is a bit of a
> > > pain.
> > 
> > Sure, sorry for leaving that out of the initial revision.
> > 
> > > Would you be happy with the below? I've also added a Cc stable, since
> > > this is a potential state corruption issue.
> > 
> > That text looks much better to me, especially since it explains exactly
> > what goes wrong here (which I was unsure of, this helps). Thanks a lot!
> > 
> > Will / Catalin, would you like a v2 with that text or could it just be
> > copied and pasted from Mark's mail during application time? I am happy
> > to do whatever.
> 
> I'll copy/paste Mark's text, no need for v2. Thanks.

If you do, could you fix my typo in the first line? I accidentally wrote:

	LLVM's integrated assemble

When that should have been:

	LLVM's integrated assembler

If you're already picked the patch it's not worth worrying about.

Mark.
