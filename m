Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E790023AD;
	Fri, 28 Mar 2025 00:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743120612; cv=none; b=QvLsLnkL1sybx3yvLTB87JLF7QxYZspXTr9PQQn4HRnLI+82oRd8yiHM1w6KTlJn91JK05Ryp5N7eI6YZzYcnHhv8MIgAfDN8HxhbHoto7msSgfN1vRXXvAdUKMRrZ1PXHG6p/MoHNdLfSt9wNVnyoaqukq/6dlgM7LjDypkpD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743120612; c=relaxed/simple;
	bh=kRmfQHhdsEfz51+Ij+AlR850u7cAKWODyMGyKix5U20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1mV/cbuQPBBy2mqtvO1W1/BXpWCuy5XstkkCHNIMswmIMUAfndMCyb2o+0mUWS5ZSbS60ijtdTxKAs9SxdhfX67M5SfmvgtgPrS60s7h/regLxlXi+LaclAzDSsRE58odHwa2no+iVL5n1PSoRDL0sLflcz+vseU/tSv35iJ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HFUngHB9; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HFUngHB9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743120611; x=1774656611;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kRmfQHhdsEfz51+Ij+AlR850u7cAKWODyMGyKix5U20=;
  b=HFUngHB9ftL7M9AbK/mvGA1seXQw17vvH4fSdDcKu6c7SqGWce07xWgn
   KTUt3dsCgPB3U0EaRCl3b7vKdAjC+wO0duIfVDGyO9GeXhtH5AtvoahCM
   9GDxCsO0dVDmhqngdt5lJbRCJk4FWmqft64iQd9b8kXHbQXBtGBl8wgNo
   eX3OTLII6PC8MWlQ4gTbmu9svFPV45xrg3q2LLFsjxLhwlnBwtAxw/F3r
   GZZ0bEZdVzcW/fQA7knb37LeCMLkZO/ZhDXB3RJKn/JXNfCWYtxxau5c1
   PA0Hk2LMzBuWzxSKhwkCY4bEfJ3k6L9SrtXkPzqDX4gNnZcC0JELKcqpG
   Q==;
X-CSE-ConnectionGUID: P5ffRD8MTrSNQslRd2EtAw==
X-CSE-MsgGUID: 26sPKxhhQp6wTZR6xgJ7Kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="66948865"
X-IronPort-AV: E=Sophos;i="6.14,281,1736841600"; 
   d="scan'208";a="66948865"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 17:10:08 -0700
X-CSE-ConnectionGUID: bebUCIUZQCqjFD56NdIMiQ==
X-CSE-MsgGUID: 8mO7oFR0THK+ptYySqaUkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,281,1736841600"; 
   d="scan'208";a="125208486"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 27 Mar 2025 17:10:06 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1txxIQ-00071K-32;
	Fri, 28 Mar 2025 00:10:02 +0000
Date: Fri, 28 Mar 2025 08:08:59 +0800
From: kernel test robot <lkp@intel.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: clarify the language unstable features in use
Message-ID: <202503280805.Oq84ECdB-lkp@intel.com>
References: <20250327211302.286313-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250327211302.286313-1-ojeda@kernel.org>

Hi Miguel,

kernel test robot noticed the following build errors:

[auto build test ERROR on e6ea10d5dbe082c54add289b44f08c9fcfe658af]

url:    https://github.com/intel-lab-lkp/linux/commits/Miguel-Ojeda/rust-clarify-the-language-unstable-features-in-use/20250328-051650
base:   e6ea10d5dbe082c54add289b44f08c9fcfe658af
patch link:    https://lore.kernel.org/r/20250327211302.286313-1-ojeda%40kernel.org
patch subject: [PATCH] rust: clarify the language unstable features in use
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250328/202503280805.Oq84ECdB-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
rustc: rustc 1.78.0 (9b00956e5 2024-04-29)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250328/202503280805.Oq84ECdB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503280805.Oq84ECdB-lkp@intel.com/

All errors (new ones prefixed by >>):

   PATH=/opt/cross/clang-18/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   INFO PATH=/opt/cross/rustc-1.78.0-bindgen-0.65.1/cargo/bin:/opt/cross/clang-18/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   /usr/bin/timeout -k 100 12h /usr/bin/make W=1 --keep-going LLVM=1 -j32 -C source O=/kbuild/obj/consumer/x86_64-rhel-9.4-rust ARCH=x86_64 SHELL=/bin/bash rustfmtcheck
   make: Entering directory '/kbuild/src/consumer'
   make[1]: Entering directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
>> Diff in rust/kernel/lib.rs at line 12:
    //! do so first instead of bypassing this crate.
    
    #![no_std]
   -
    // Please see https://github.com/Rust-for-Linux/linux/issues/2 for details on
    // the unstable features in use.
    
   Diff in rust/kernel/lib.rs at line 19:
    // Stable since Rust 1.79.0.
    #![feature(inline_const)]
   -
    // Stable since Rust 1.81.0.
    #![feature(lint_reasons)]
   -
    // Stable since Rust 1.82.0.
    #![feature(raw_ref_op)]
   -
    // Stable since Rust 1.83.0.
    #![feature(const_maybe_uninit_as_mut_ptr)]
    #![feature(const_mut_refs)]
   Diff in rust/kernel/lib.rs at line 31:
    #![feature(const_ptr_write)]
    #![feature(const_refs_to_cell)]
   -
    // Expected to become stable.
    #![feature(arbitrary_self_types)]
   -
    // `feature(derive_coerce_pointee)` is the one expected to become stable.
    #![cfg_attr(CONFIG_RUSTC_HAS_COERCE_POINTEE, feature(derive_coerce_pointee))]
    #![cfg_attr(not(CONFIG_RUSTC_HAS_COERCE_POINTEE), feature(coerce_unsized))]
   make[2]: *** [Makefile:1811: rustfmt] Error 123
   make[2]: Target 'rustfmtcheck' not remade because of errors.
   make[1]: Leaving directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
   make[1]: *** [Makefile:251: __sub-make] Error 2
   make[1]: Target 'rustfmtcheck' not remade because of errors.
   make: *** [Makefile:251: __sub-make] Error 2
   make: Target 'rustfmtcheck' not remade because of errors.
   make: Leaving directory '/kbuild/src/consumer'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
