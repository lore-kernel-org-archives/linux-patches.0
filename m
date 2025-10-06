Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D93184524;
	Mon,  6 Oct 2025 21:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759787710; cv=none; b=KjRPvpTB5uOsMn5EF5X9QRG0tiFdkQ+i5dqVynpaRCNlMlbv9DXxFYY8R/mKS66IDObYceXNXvDC/aWmkwmOly+idcM9O92y7D//AzmVXR+mVRGwx9DhfdnT/ypfiTrXdt5obx6vlpNIxAPEifPtMsfoqEy1U3+jeVaaA1vyIi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759787710; c=relaxed/simple;
	bh=QOuCeBcgcbWQto9WnsHySOKZ81rbgK/I39KFx6jJPbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBQriMSCBsBMffjF44o4A6ox0yC6xlT4GaXWnvNOft0OyWVHJAXepc9iBHuIrZsz17vXZet/csVQ9j5gPYPgTD56iStkiVIz8YJH19NhE9HDKgJPHfFLVxt98m90QoMB7SG2wPU68a0+EyAtWqKU2LSj51zH+624vVq57EIe3Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxcTn8rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxcTn8rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2063C4CEF5;
	Mon,  6 Oct 2025 21:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759787710;
	bh=QOuCeBcgcbWQto9WnsHySOKZ81rbgK/I39KFx6jJPbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HxcTn8rh2qtGoaJOOZNdQsG6QOQSuXkjo9ioB23X2j876uD5kx+XCssfZNvJDHdSj
	 5Tb5LbzdYi3AKBXVuMAlbhzBe9bvJLgUEZImnWQGc0byYLUeLZRKw64qNit4AyUJxl
	 4EmXamrJ0J7h0oV5jBeCGRI90XTCR1KkoV0+tcolM7Zgoep7gcISp4iBDLHzVi6ddz
	 sZbZc+Lpe4V4zDMGLLOWaYO56mTkOQz5gREjezMUTZWmPaSrJkO4o2K+VQbwgM9zSm
	 T7bPxWXmiPIu3yhaRGzsvqXXWs2NLC/+wTXugzEAjzS3AgIsDI+PCEpOPRAEFfh8xy
	 RcIGXtWWzi7VQ==
Date: Mon, 6 Oct 2025 14:55:05 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 6.17-5.4] x86/build: Remove cc-option from stack
 alignment flags
Message-ID: <20251006215505.GB3234160@ax162>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>

On Mon, Oct 06, 2025 at 02:17:33PM -0400, Sasha Levin wrote:
> From: Nathan Chancellor <nathan@kernel.org>
> 
> [ Upstream commit d87208128a3330c0eab18301ab39bdb419647730 ]
> 
> '-mpreferred-stack-boundary' (the GCC option) and '-mstack-alignment'
> (the clang option) have been supported in their respective compilers for
> some time, so it is unnecessary to check for support for them via
> cc-option. '-mpreferred-stack-boundary=3' had a restriction on
> '-mno-sse' until GCC 7.1 but that is irrelevant for most of the kernel,
> which includes '-mno-sse'.
> 
> Move to simple Kconfig checks to avoid querying the compiler for the
> flags that it supports.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://lore.kernel.org/20250814-x86-min-ver-cleanups-v1-2-ff7f19457523@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
...
> ## Backport Status: NO
...
> **Dependency Analysis:**
> - Requires minimum GCC 8.1 for x86 (introduced in v6.15 via commit
>   a3e8fe814ad1)
> - Requires minimum Clang 15.0.0 for x86 (commit 7861640aac52b)
> - Both requirements are satisfied in 6.17 stable tree (verified via
>   scripts/min-tool-version.sh)
> - GCC 7.1+ supports `-mpreferred-stack-boundary=3` with `-msse` (per GCC
>   commit 34fac449e121)
...
> ### Conclusion
> 
> While this commit is technically safe and provides a marginal build-time
> performance improvement by eliminating unnecessary runtime compiler
> checks, **it does not meet the fundamental requirement for stable kernel
> backporting**: it does not fix a bug that affects users.
> 
> The commit is purely a cleanup that removes obsolete code after compiler
> minimum version requirements were raised. Such cleanups belong in
> mainline development, not stable trees, which should focus exclusively
> on fixing bugs that impact users.
> 
> The fact that it was auto-selected by AUTOSEL does not override the
> documented stable kernel rules. This commit should be **rejected** from
> stable backporting or **reverted** if already applied.

Based on all of this, I would agree that it is not really suitable for
backporting (at least not beyond 6.15, whereas the subject says back to
5.4), so why was this still sent for review?

Cheers,
Nathan
