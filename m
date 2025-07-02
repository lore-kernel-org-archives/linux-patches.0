Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5445026E149;
	Wed,  2 Jul 2025 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751459114; cv=none; b=pjxql43iwfLRM04jr/NKG7h0j+Y4fnEapIvbkpof8EreyS5tXLF9TxwDjbZBhcez5rfu4736N0IyKvO4s95iTEz5DySvmYHNvqV4Kaye9EsIWVXPxwbM1PZNcyFBXl7+s4fMnoUGX9s8XQN5igtLwUc86y8ImeMnJNs44/VvQvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751459114; c=relaxed/simple;
	bh=awyRL1yYt8sOIPQl7z6BBiYEjvvn7LK2Bmvq7YpEkfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQ2CTh3sosC4YQVF0fho676mfGOpJu8CgvvTLIOVsZuNWYm0TlNDbphbOcNPIdKU1HfqhkubGOaZ7FPTAU6DToD6y0DbtScCKE6iJAUJ85tAqqxF1pfDqwI/78S01br0srMxhH4k8E1l73KpJiuEH0uGfaaLf14vWB7kTjOK6os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bk3JnrS1; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bk3JnrS1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751459112; x=1782995112;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=awyRL1yYt8sOIPQl7z6BBiYEjvvn7LK2Bmvq7YpEkfw=;
  b=bk3JnrS1Ww7x+GBKUSSk0jejwCBclPI+qcIuZY0lSEMqnudW5ZqAPqfn
   9bEWyHwlcGEMHf+T4+oeQizEsMjoDXrw/B/iuAV5xKKqBOLprR6he2gcv
   O//gumla51+9tDcoc9JwH0xbXz5fe+ELM53vg8G8dUcnWdNh2nutZStx4
   MLaO+bBYQdT7TABRVl4OoBmkaqbLWRkprwXbe5NK59YvE07HI8M57TVGa
   oiJuspE5uhS2y6O5zJgKp51p8v40Wc8IGU80Raayqm+wfR8aHUcYpWKZt
   3XwKHzVTvADtHkP/Tx811E3lTfKu+BkkRinrMqvS+vtuuiPROOJt4xxwZ
   A==;
X-CSE-ConnectionGUID: Y0tijliNQbeWwcBtqjqPJg==
X-CSE-MsgGUID: 14m9BmIPQzOnAhkLOcFd2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64796954"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="64796954"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 05:25:11 -0700
X-CSE-ConnectionGUID: M/pd+uxBSpqle+u6j1dQ6g==
X-CSE-MsgGUID: Gn+FyFxnSqCVVTdscJqX0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153685464"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 02 Jul 2025 05:25:08 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uWwWQ-0000cR-1H;
	Wed, 02 Jul 2025 12:25:06 +0000
Date: Wed, 2 Jul 2025 20:24:11 +0800
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
Subject: Re: [PATCH v2 2/2] rust: update ARef and AlwaysRefCounted call sites
 to import from sync::aref
Message-ID: <202507022055.C7y9sGGN-lkp@intel.com>
References: <20250625111133.698481-2-shankari.ak0208@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625111133.698481-2-shankari.ak0208@gmail.com>

Hi Shankari,

kernel test robot noticed the following build errors:

[auto build test ERROR on 0303584766b7bdb6564c7e8f13e0b59b6ef44984]

url:    https://github.com/intel-lab-lkp/linux/commits/Shankari-Anand/rust-update-ARef-and-AlwaysRefCounted-call-sites-to-import-from-sync-aref/20250625-191416
base:   0303584766b7bdb6564c7e8f13e0b59b6ef44984
patch link:    https://lore.kernel.org/r/20250625111133.698481-2-shankari.ak0208%40gmail.com
patch subject: [PATCH v2 2/2] rust: update ARef and AlwaysRefCounted call sites to import from sync::aref
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250702/202507022055.C7y9sGGN-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
rustc: rustc 1.78.0 (9b00956e5 2024-04-29)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250702/202507022055.C7y9sGGN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507022055.C7y9sGGN-lkp@intel.com/

All errors (new ones prefixed by >>):

   PATH=/opt/cross/clang-18/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   INFO PATH=/opt/cross/rustc-1.78.0-bindgen-0.65.1/cargo/bin:/opt/cross/clang-18/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   /usr/bin/timeout -k 100 12h /usr/bin/make KCFLAGS= -fno-crash-diagnostics -Wno-error=return-type -Wreturn-type -funsigned-char -Wundef W=1 --keep-going LLVM=1 -j32 -C source O=/kbuild/obj/consumer/x86_64-rhel-9.4-rust ARCH=x86_64 SHELL=/bin/bash rustfmtcheck
   make: Entering directory '/kbuild/src/consumer'
   make[1]: Entering directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
>> Diff in drivers/gpu/drm/nova/driver.rs at line 1:
    // SPDX-License-Identifier: GPL-2.0
    
   -use kernel::{auxiliary, c_str, device::Core, drm, drm::gem, drm::ioctl, prelude::*, sync::aref::ARef};
   +use kernel::{
   +    auxiliary, c_str, device::Core, drm, drm::gem, drm::ioctl, prelude::*, sync::aref::ARef,
   +};
    
    use crate::file::File;
    use crate::gem::NovaObject;
>> Diff in drivers/gpu/drm/nova/driver.rs at line 1:
    // SPDX-License-Identifier: GPL-2.0
    
   -use kernel::{auxiliary, c_str, device::Core, drm, drm::gem, drm::ioctl, prelude::*, sync::aref::ARef};
   +use kernel::{
   +    auxiliary, c_str, device::Core, drm, drm::gem, drm::ioctl, prelude::*, sync::aref::ARef,
   +};
    
    use crate::file::File;
    use crate::gem::NovaObject;
   Diff in rust/kernel/sync/aref.rs at line 10:
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
>> Diff in rust/kernel/cred.rs at line 8:
    //!
    //! Reference: <https://www.kernel.org/doc/html/latest/security/credentials.html>
    
   -use crate::{
   -    bindings,
   -    task::Kuid,
   -    sync::aref::AlwaysRefCounted,
   -    types::Opaque,
   -};
   +use crate::{bindings, sync::aref::AlwaysRefCounted, task::Kuid, types::Opaque};
    
    /// Wraps the kernel's `struct cred`.
    ///
>> Diff in rust/kernel/device.rs at line 4:
    //!
    //! C header: [`include/linux/device.h`](srctree/include/linux/device.h)
    
   -use crate::{
   -    bindings,
   -    str::CStr,
   -    sync::aref::ARef,
   -    types::Opaque,
   -};
   +use crate::{bindings, str::CStr, sync::aref::ARef, types::Opaque};
    use core::{fmt, marker::PhantomData, ptr};
    
    #[cfg(CONFIG_PRINTK)]
   Diff in rust/kernel/pid_namespace.rs at line 7:
    //! C header: [`include/linux/pid_namespace.h`](srctree/include/linux/pid_namespace.h) and
    //! [`include/linux/pid.h`](srctree/include/linux/pid.h)
    
   -use crate::{
   -    bindings,
   -    sync::aref::AlwaysRefCounted,
   -    types::Opaque,
   -};
   +use crate::{bindings, sync::aref::AlwaysRefCounted, types::Opaque};
    use core::ptr;
    
    /// Wraps the kernel's `struct pid_namespace`. Thread safe.
   Diff in rust/kernel/sync/aref.rs at line 10:
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
   Diff in rust/kernel/pid_namespace.rs at line 7:
    //! C header: [`include/linux/pid_namespace.h`](srctree/include/linux/pid_namespace.h) and
    //! [`include/linux/pid.h`](srctree/include/linux/pid.h)
    
   -use crate::{
   -    bindings,
   -    sync::aref::AlwaysRefCounted,
   -    types::Opaque,
   -};
   +use crate::{bindings, sync::aref::AlwaysRefCounted, types::Opaque};
    use core::ptr;
    
    /// Wraps the kernel's `struct pid_namespace`. Thread safe.
   Diff in rust/kernel/sync/aref.rs at line 10:
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
>> Diff in rust/kernel/cred.rs at line 8:
    //!
    //! Reference: <https://www.kernel.org/doc/html/latest/security/credentials.html>
    
   -use crate::{
   -    bindings,
   -    task::Kuid,
   -    sync::aref::AlwaysRefCounted,
   -    types::Opaque,
   -};
   +use crate::{bindings, sync::aref::AlwaysRefCounted, task::Kuid, types::Opaque};
    
    /// Wraps the kernel's `struct cred`.
    ///
>> Diff in rust/kernel/device.rs at line 4:
    //!
    //! C header: [`include/linux/device.h`](srctree/include/linux/device.h)
    
   -use crate::{
   -    bindings,
   -    str::CStr,
   -    sync::aref::ARef,
   -    types::Opaque,
   -};
   +use crate::{bindings, str::CStr, sync::aref::ARef, types::Opaque};
    use core::{fmt, marker::PhantomData, ptr};
    
    #[cfg(CONFIG_PRINTK)]
   make[2]: *** [Makefile:1831: rustfmt] Error 123
   make[2]: Target 'rustfmtcheck' not remade because of errors.
   make[1]: Leaving directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'rustfmtcheck' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'rustfmtcheck' not remade because of errors.
   make: Leaving directory '/kbuild/src/consumer'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
