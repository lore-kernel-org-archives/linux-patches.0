Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4B1C173E;
	Fri, 30 Aug 2024 22:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055941; cv=none; b=pz56kRNncOiDuGlg53RjWALdvTyjL1vmFWYrnS2pcx4y4T68IJqsX96hgkF0dtCfx2LYpXXFmRGOLDXjicNl+6H/P8P1qsLNLBfboKvUWmdwXL1zLGHZCKzIu3b210C6tD44yEvh0Md+fQxPcFCm/O37uR7UoyGooRro+zo7yXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055941; c=relaxed/simple;
	bh=anF0WgWFP/8S4oikTTao4/i90jjTIJNVyR3wOLf+fzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rhBCOoRnKESQ+m6caZEyKr/7B7/WBJNqnW2rbZ4Q04zBEYynYYhLU1wDwrXoFjuQpVUk3792I762K1UyFIbs6gQQM8xjLzfsJvylYJ/8upJTpHRlk7i2EK5c44zuxHbw3iZWhxPjq80KR6lUQbCY4wzwpOJkpAytJQjCZe+eTgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMl/C+RY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMl/C+RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CA0C4CEC2;
	Fri, 30 Aug 2024 22:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725055940;
	bh=anF0WgWFP/8S4oikTTao4/i90jjTIJNVyR3wOLf+fzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PMl/C+RYV754nRylCZjpG5FFaw2xHaRHyJXXZRgGFnLtUZHiyVbuMHOBghjmPHY++
	 9VAZ7DLpvGfeNBBdwmrK2rrS3OWuaeUsLRKjXt1unL9lpWWT8B5qlEW0axVrWTpyOQ
	 iAp9BeEQlEz0n5W4YqixKQY3BmYv1tJkY6TO7Crdy2xT9UGWoBhrEpG+jBhbmCr65O
	 eSVITMJ0HpBG6KWlI52bHWNbd8qqjMJ4e3A3B45C5w63VVoRaMGcUW1l45lGhtb3Ng
	 nq4Iw7ypSyj3dkyro9ZSuqNvn272y2wh0KU0GnaXtQPMZucAvwpMEVceYSjzHCOKkc
	 YCK51I98pEgGw==
Date: Fri, 30 Aug 2024 15:12:17 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <keescook@chromium.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Benno Lossin <benno.lossin@proton.me>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Christoph Lameter <cl@linux.com>,
	Dennis Zhou <dennis@kernel.org>, Gary Guo <gary@garyguo.net>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.6 230/341] change alloc_pages name in dma_map_ops to
 avoid name conflicts
Message-ID: <20240830221217.GA3837758@thelio-3990X>
References: <20240827143843.399359062@linuxfoundation.org>
 <20240827143852.163123189@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240827143852.163123189@linuxfoundation.org>

Hi Greg and Sasha,

On Tue, Aug 27, 2024 at 04:37:41PM +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Suren Baghdasaryan <surenb@google.com>
> 
> [ Upstream commit 8a2f11878771da65b8ac135c73b47dae13afbd62 ]
> 
> After redefining alloc_pages, all uses of that name are being replaced.
> Change the conflicting names to prevent preprocessor from replacing them
> when it's not intended.
> 
> Link: https://lkml.kernel.org/r/20240321163705.3067592-18-surenb@google.com
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Tested-by: Kees Cook <keescook@chromium.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Alex Gaynor <alex.gaynor@gmail.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Andreas Hindborg <a.hindborg@samsung.com>
> Cc: Benno Lossin <benno.lossin@proton.me>
> Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Gary Guo <gary@garyguo.net>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Stable-dep-of: 61ebe5a747da ("mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/alpha/kernel/pci_iommu.c           | 2 +-
>  arch/mips/jazz/jazzdma.c                | 2 +-
>  arch/powerpc/kernel/dma-iommu.c         | 2 +-
>  arch/powerpc/platforms/ps3/system-bus.c | 4 ++--
>  arch/powerpc/platforms/pseries/vio.c    | 2 +-
>  arch/x86/kernel/amd_gart_64.c           | 2 +-
>  drivers/iommu/dma-iommu.c               | 2 +-
>  drivers/parisc/ccio-dma.c               | 2 +-
>  drivers/parisc/sba_iommu.c              | 2 +-
>  drivers/xen/grant-dma-ops.c             | 2 +-
>  drivers/xen/swiotlb-xen.c               | 2 +-
>  include/linux/dma-map-ops.h             | 2 +-
>  kernel/dma/mapping.c                    | 4 ++--
>  13 files changed, 15 insertions(+), 15 deletions(-)

This patch breaks the build for s390:

arch/s390/pci/pci_dma.c:724:10: error: 'const struct dma_map_ops' has no member named 'alloc_pages'; did you mean 'alloc_pages_op'?
  724 |         .alloc_pages    = dma_common_alloc_pages,
      |          ^~~~~~~~~~~
      |          alloc_pages_op

https://storage.tuxsuite.com/public/clangbuiltlinux/continuous-integration2/builds/2lNUl0tacZpSlu9Edrlk3QoSElM/build.log

This change happened after commit c76c067e488c ("s390/pci: Use dma-iommu
layer") in mainline, which explains how it was missed for stable.

The fix seems simple:

diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
index 99209085c75b..ce0f2990cb04 100644
--- a/arch/s390/pci/pci_dma.c
+++ b/arch/s390/pci/pci_dma.c
@@ -721,7 +721,7 @@ const struct dma_map_ops s390_pci_dma_ops = {
 	.unmap_page	= s390_dma_unmap_pages,
 	.mmap		= dma_common_mmap,
 	.get_sgtable	= dma_common_get_sgtable,
-	.alloc_pages	= dma_common_alloc_pages,
+	.alloc_pages_op	= dma_common_alloc_pages,
 	.free_pages	= dma_common_free_pages,
 	/* dma_supported is unconditionally true without a callback */
 };

but I think the better question is why this patch is even needed in the
first place? It claims that it is a stable dependency of 61ebe5a747da
but this patch does not even touch mm/vmalloc.c and 61ebe5a747da does
not mention or touch anything with alloc_pages_op, so it seems like this
change should just be reverted from 6.6?

Cheers,
Nathan
