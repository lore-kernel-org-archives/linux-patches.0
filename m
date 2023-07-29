Received: from mgamail.intel.com (unknown [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722A828E3;
	Sat, 29 Jul 2023 23:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690673134; x=1722209134;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lg5Z2zadJltzEJU5eTPAO7fkXvwEPhVsT0zhAmujkSU=;
  b=Ux/xsRnl3WhBb4Otez1dvh5R8O6L2i2/GVQXpbsVNd3Gi53+LmMtwvHX
   QhiNfALZVnPqsJT4MfCoGjf+eVUGK0GfGIA6JrAO5i1PDfpD6VPStdG2d
   VsNptawZC4TP2Po/xS+tcM2WQr+zMEYANj0i60FT4XCCfEaJ6+tbfTB/j
   6SVevxs3T6I26KZFFi7AOr7pxEKWgsOXfrubThExThfm4I+VoIaBpOI3z
   YFA/EQehO04EiFmxfzvPJVprQ0jvMC8wA+YuEqXePurkV47Dfk6HIoa9W
   ftkR1VsBtVhEwNVcxB5hodCXMyddpUW9mlOaXUap8PPUXIcJ3y67PdavC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10786"; a="366266756"
X-IronPort-AV: E=Sophos;i="6.01,240,1684825200"; 
   d="scan'208";a="366266756"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2023 16:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10786"; a="974471634"
X-IronPort-AV: E=Sophos;i="6.01,240,1684825200"; 
   d="scan'208";a="974471634"
Received: from lkp-server02.sh.intel.com (HELO 953e8cd98f7d) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jul 2023 16:25:29 -0700
Received: from kbuild by 953e8cd98f7d with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qPtJQ-0004Kl-2g;
	Sat, 29 Jul 2023 23:25:28 +0000
Date: Sun, 30 Jul 2023 07:25:07 +0800
From: kernel test robot <lkp@intel.com>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 1/2] rust: upgrade to Rust 1.71.0
Message-ID: <202307300737.8GuKiWIl-lkp@intel.com>
References: <20230729220317.416771-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230729220317.416771-1-ojeda@kernel.org>

Hi Miguel,

kernel test robot noticed the following build errors:

[auto build test ERROR on 7c74839b2acc9b5a5d16d3a1737741dd64e1804b]

url:    https://github.com/intel-lab-lkp/linux/commits/Miguel-Ojeda/rust-enable-no_mangle_with_rust_abi-Clippy-lint/20230730-060434
base:   7c74839b2acc9b5a5d16d3a1737741dd64e1804b
patch link:    https://lore.kernel.org/r/20230729220317.416771-1-ojeda%40kernel.org
patch subject: [PATCH 1/2] rust: upgrade to Rust 1.71.0
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20230730/202307300737.8GuKiWIl-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce: (https://download.01.org/0day-ci/archive/20230730/202307300737.8GuKiWIl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307300737.8GuKiWIl-lkp@intel.com/

All errors (new ones prefixed by >>):

>> thread 'main' panicked at '"ftrace_branch_data_union_(anonymous_at_include/linux/compiler_types_h_146_2)" is not a valid Ident', /opt/cross/rustc-1.71.0-bindgen-0.56.0/cargo/registry/src/index.crates.io-6f17d22bba15001f/proc-macro2-1.0.24/src/fallback.rs:693:9
   stack backtrace:
      0: rust_begin_unwind
                at /rustc/8ede3aae28fe6e4d52b38157d7bfe0d3bceef225/library/std/src/panicking.rs:593:5
      1: core::panicking::panic_fmt
                at /rustc/8ede3aae28fe6e4d52b38157d7bfe0d3bceef225/library/core/src/panicking.rs:67:14
      2: proc_macro2::fallback::Ident::_new
      3: proc_macro2::Ident::new
      4: bindgen::ir::context::BindgenContext::rust_ident
      5: <bindgen::ir::comp::CompInfo as bindgen::codegen::CodeGenerator>::codegen
      6: <bindgen::ir::ty::Type as bindgen::codegen::CodeGenerator>::codegen
      7: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
      8: <bindgen::ir::comp::CompInfo as bindgen::codegen::CodeGenerator>::codegen
      9: <bindgen::ir::ty::Type as bindgen::codegen::CodeGenerator>::codegen
     10: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
     11: <bindgen::ir::module::Module as bindgen::codegen::CodeGenerator>::codegen
     12: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
     13: bindgen::ir::context::BindgenContext::gen
     14: bindgen::Builder::generate
     15: bindgen::main
   note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
   make[3]: *** [rust/Makefile:316: rust/uapi/uapi_generated.rs] Error 1
   make[3]: *** Deleting file 'rust/uapi/uapi_generated.rs'
>> thread 'main' panicked at '"ftrace_branch_data_union_(anonymous_at_include/linux/compiler_types_h_146_2)" is not a valid Ident', /opt/cross/rustc-1.71.0-bindgen-0.56.0/cargo/registry/src/index.crates.io-6f17d22bba15001f/proc-macro2-1.0.24/src/fallback.rs:693:9
   stack backtrace:
      0: rust_begin_unwind
                at /rustc/8ede3aae28fe6e4d52b38157d7bfe0d3bceef225/library/std/src/panicking.rs:593:5
      1: core::panicking::panic_fmt
                at /rustc/8ede3aae28fe6e4d52b38157d7bfe0d3bceef225/library/core/src/panicking.rs:67:14
      2: proc_macro2::fallback::Ident::_new
      3: proc_macro2::Ident::new
      4: bindgen::ir::context::BindgenContext::rust_ident
      5: <bindgen::ir::comp::CompInfo as bindgen::codegen::CodeGenerator>::codegen
      6: <bindgen::ir::ty::Type as bindgen::codegen::CodeGenerator>::codegen
      7: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
      8: <bindgen::ir::comp::CompInfo as bindgen::codegen::CodeGenerator>::codegen
      9: <bindgen::ir::ty::Type as bindgen::codegen::CodeGenerator>::codegen
     10: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
     11: <bindgen::ir::module::Module as bindgen::codegen::CodeGenerator>::codegen
     12: <bindgen::ir::item::Item as bindgen::codegen::CodeGenerator>::codegen
     13: bindgen::ir::context::BindgenContext::gen
     14: bindgen::Builder::generate
     15: bindgen::main
   note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
   make[3]: *** [rust/Makefile:310: rust/bindings/bindings_generated.rs] Error 1
   make[3]: *** Deleting file 'rust/bindings/bindings_generated.rs'
   make[3]: Target 'rust/' not remade because of errors.
   make[2]: *** [Makefile:1281: prepare] Error 2
   make[1]: *** [Makefile:234: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:234: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
