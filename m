Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED902561B6;
	Wed,  2 Jul 2025 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751454117; cv=none; b=YxttPK5HMNYN4jKdIKh3BOIgYqf0taEOLSOzEf8XKbmKzpc5bd1n2PRraGlebtlbUpocU0cEdllI/V7+7FqIGTfqa3vYBo5gUp/jEtgkyleq8SKa7KxmrkBqaTSaK7/ctdhwPQgjZGTNXll1dTukReR+9TILRyWwgXf1eI1HQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751454117; c=relaxed/simple;
	bh=vk9xFYF2tM63tWK0lwWvjJGavzdkJM4pk3eHgL+p5iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZqjGy+GaPiASFJMbFOopEkMLYCiIJ/aKYBywWkCjtBpX6BfuMIGT00xZYxsQLrL++dHLhzXQ0OEWH2f6dvb00yVhoHoJpUCBkY4pnMdeJuoBJYaVUNovZIAai15BsLflHyFnsTOhlox+067Kc6AKFtxW5HIBR5iDwj3C2lk/Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a5JjRyE5; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a5JjRyE5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751454116; x=1782990116;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vk9xFYF2tM63tWK0lwWvjJGavzdkJM4pk3eHgL+p5iE=;
  b=a5JjRyE5LljjU8/j/Z7fRO/bQYCMfutwNPBcK8cZ/kyJ5yi5cCklKJa7
   EYH7225izh0ICVgQcoJWl2QjVyHk6g4oXkONMN1USQUvWoPsG1kMW/yLN
   G10HMf5WOsXri4Bcak3F6SArVuQhfhWZ0Z4OTuxCQgMKky7AJw+BBULfX
   1L/XqrNZuIFnKuhkObOyNUqRR1qY1oSRMqohXhp8yjw8oMdv9YGWw9TZQ
   9aUkiU7dRBHsP1JXPYFI6ycyhqhf5FpNet9fZ7x7buzAQCNEC9qcJbqdV
   jrYMZfte/d8Z1XDkIIH8tdJTsc78tQ2Z4BMDSkk0FOITRusi0ERKwbLp2
   g==;
X-CSE-ConnectionGUID: RCu1XxszSBOJsf+YeAwVtA==
X-CSE-MsgGUID: rTnATMnTRey2JV1NEkaSUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="79183706"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="79183706"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 04:01:55 -0700
X-CSE-ConnectionGUID: TKdxGbLaThynfIdl2VgMkw==
X-CSE-MsgGUID: wfLo+LikQHu8xgNbgqPuTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="154777677"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2025 04:01:52 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uWvDp-0000Xj-2G;
	Wed, 02 Jul 2025 11:01:49 +0000
Date: Wed, 2 Jul 2025 19:01:08 +0800
From: kernel test robot <lkp@intel.com>
To: Shankari Anand <shankari.ak0208@gmail.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	patches@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Shankari Anand <shankari.ak0208@gmail.com>
Subject: Re: [PATCH v2 1/2] rust: move ARef and AlwaysRefCounted to sync::aref
Message-ID: <202507021852.OMX5AiRy-lkp@intel.com>
References: <20250625111133.698481-1-shankari.ak0208@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625111133.698481-1-shankari.ak0208@gmail.com>

Hi Shankari,

kernel test robot noticed the following build errors:

[auto build test ERROR on 0303584766b7bdb6564c7e8f13e0b59b6ef44984]

url:    https://github.com/intel-lab-lkp/linux/commits/Shankari-Anand/rust-update-ARef-and-AlwaysRefCounted-call-sites-to-import-from-sync-aref/20250625-191416
base:   0303584766b7bdb6564c7e8f13e0b59b6ef44984
patch link:    https://lore.kernel.org/r/20250625111133.698481-1-shankari.ak0208%40gmail.com
patch subject: [PATCH v2 1/2] rust: move ARef and AlwaysRefCounted to sync::aref
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250702/202507021852.OMX5AiRy-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
rustc: rustc 1.78.0 (9b00956e5 2024-04-29)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250702/202507021852.OMX5AiRy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507021852.OMX5AiRy-lkp@intel.com/

All errors (new ones prefixed by >>):

   PATH=/opt/cross/clang-18/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   INFO PATH=/opt/cross/rustc-1.78.0-bindgen-0.65.1/cargo/bin:/opt/cross/clang-18/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   /usr/bin/timeout -k 100 12h /usr/bin/make KCFLAGS= -fno-crash-diagnostics -Wno-error=return-type -Wreturn-type -funsigned-char -Wundef W=1 --keep-going LLVM=1 -j32 -C source O=/kbuild/obj/consumer/x86_64-rhel-9.4-rust ARCH=x86_64 SHELL=/bin/bash rustfmtcheck
   make: Entering directory '/kbuild/src/consumer'
   make[1]: Entering directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
>> Diff in rust/kernel/sync/aref.rs at line 10:
    //!
    //! For Rust-managed objects, prefer using [`Arc`](crate::sync::Arc) instead.
    
   -use core::{
   -    marker::PhantomData,
   -    mem::ManuallyDrop,
   -    ops::Deref,
   -    ptr::NonNull,
   -};
   +use core::{marker::PhantomData, mem::ManuallyDrop, ops::Deref, ptr::NonNull};
    
    /// Trait for types that are _always_ reference-counted.
    ///
>> Diff in rust/kernel/sync/aref.rs at line 10:
    //!
    //! For Rust-managed objects, prefer using [`Arc`](crate::sync::Arc) instead.
    
   -use core::{
   -    marker::PhantomData,
   -    mem::ManuallyDrop,
   -    ops::Deref,
   -    ptr::NonNull,
   -};
   +use core::{marker::PhantomData, mem::ManuallyDrop, ops::Deref, ptr::NonNull};
    
    /// Trait for types that are _always_ reference-counted.
    ///
>> Diff in rust/kernel/sync/aref.rs at line 10:
    //!
    //! For Rust-managed objects, prefer using [`Arc`](crate::sync::Arc) instead.
    
   -use core::{
   -    marker::PhantomData,
   -    mem::ManuallyDrop,
   -    ops::Deref,
   -    ptr::NonNull,
   -};
   +use core::{marker::PhantomData, mem::ManuallyDrop, ops::Deref, ptr::NonNull};
    
    /// Trait for types that are _always_ reference-counted.
    ///
   make[1]: Leaving directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'rustfmtcheck' not remade because of errors.
   make: Leaving directory '/kbuild/src/consumer'
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'rustfmtcheck' not remade because of errors.
   make[2]: *** [Makefile:1831: rustfmt] Error 123
   make[2]: Target 'rustfmtcheck' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
