Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D2A10E3;
	Fri,  2 Jun 2023 01:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685667803; x=1717203803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UzCJ2xtSvIRGsRHhm9t1YVI8nd1QRoXT2ZxHMUiLcKQ=;
  b=nhUawYSM9kSK02FWCNOvMcXIF+BKSFFzRxmGRtB3b0qMsm+Vx3sTNKbT
   lSmS6kSahOCuHjROQsfEGrQOxYvoVR7GuuWlCKWXy9hSHZYK6uHqipUDm
   PlI3JIm4nTatcgKI0PDuxF5oJMu33PWxBDvKH5f2xRrvqD6I/YVtEp0//
   +EHmBlO/oBUiGsMSUclfXYhl/3zkFdb9++H0Rl1Fg3B/Ai8JqVY+TVi9g
   KmKvmUz4+FxvLkUk/YMBJhu9krQ5m+qsNCoelLGIfGvk1HQ6KnmXSzg6G
   PR+Jl4qKLPAc4qvGjcYY+Gj0yFdZywdlF0KQpy/MxeAMurF3K6Q2muvIC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="419257238"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="419257238"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 18:03:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="1037721020"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="1037721020"
Received: from gsavorni-mobl1.ger.corp.intel.com (HELO intel.com) ([10.251.210.46])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 18:03:17 -0700
Date: Fri, 2 Jun 2023 03:03:14 +0200
From: Andi Shyti <andi.shyti@linux.intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
	rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
	ndesaulniers@google.com, trix@redhat.com,
	andi.shyti@linux.intel.com, fei.yang@intel.com,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 0/2] drm/i915/gt: Fix recent kCFI violations
Message-ID: <ZHk/0iN9uwphaC+1@ashyti-mobl2.lan>
References: <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-0-54501d598229@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530-i915-gt-cache_level-wincompatible-function-pointer-types-strict-v1-0-54501d598229@kernel.org>

Hi Nathan,

On Tue, May 30, 2023 at 11:24:37AM -0700, Nathan Chancellor wrote:
> Hi all,
> 
> This series fixes a few clang kernel Control Flow Integrity (kCFI)
> violations that appear after commit 9275277d5324 ("drm/i915: use
> pat_index instead of cache_level"). They were found between run time
> testing on real hardware and compile time testing with
> -Wincompatible-function-pointer-types-strict (which is not yet enabled
> for the kernel but I build with it locally to catch new instances).
> 
> If there are any problems or questions, please let me know.
> 
> ---
> Nathan Chancellor (2):
>       drm/i915/gt: Fix second parameter type of pre-gen8 pte_encode callbacks
>       drm/i915/gt: Fix parameter in gmch_ggtt_insert_{entries,page}()

pushed in drm-intel-gt-next.

Thank you,
Andi
