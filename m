Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612FE1F12E0;
	Wed, 10 Dec 2025 07:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351268; cv=none; b=eCd81KzJCWrd/SJb8hWWmtUfELYLX9JFyZ8hpyvMS1pbG1ihMtjcP6dzDUKZLDABEephEMgUqI8C9Mzkot/i754DIcOuy6iIMYWJZ/IOy2w5C4u4EHYIMaa7kmSIfBkXzW+ieLR0uibUWZ+cAde5m1y5faztBW8w76aJa3xPMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351268; c=relaxed/simple;
	bh=64djoh73/AUUyoyzFvfxmwa9TloOMm7ZnhzSF0+2XSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpjIscOfLJAjSXm4sqMaE6KkH6uxTg0lgqv3VXYtSoIAyTKNZqN+COxSIrFHpbBHMfe5DLhN/lt57VIo+X1tkE6Is/+zI4WpqZGkEfr9xIRmQ9c+ok8d6LGJgQ7+tOm9eVe9ga/hs23EHH4Gd69RXndDIcmNE6h9eHL12U0PS3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dP9COKVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dP9COKVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E49C4CEF1;
	Wed, 10 Dec 2025 07:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765351263;
	bh=64djoh73/AUUyoyzFvfxmwa9TloOMm7ZnhzSF0+2XSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dP9COKVCrltYVQKHvKuhLPOAqOFEIgxQ151oVcqVd4TUzzLBSRRJts4OMSrNs8xvz
	 bY4Gc5nJLMK8gTWKoRTPYbEbnKdzC0Sq5JUrv9FEFDdiWH1Q2zcrpg1lx5BThS5er5
	 vsEa1Rt8hp9ANLOPPXn8O8SLjDkw+FSA7vFtIVeIFJbGfreTjN59o32SjmYnwmzSI6
	 cY0sI1NQtCPWLYlLBCA7k/024TFOkGMTTh66jDcRc4oibeSHRoJW9fzdnGZS+mDMCL
	 JHYtS//DMI8oU25i+0PFU4Jrdley5nlSjx7jcnFbCiMrPATeYBi0MxBcmCMZXn8xte
	 1KU6W9QonGSDQ==
Date: Tue, 9 Dec 2025 23:21:03 -0800
From: Kees Cook <kees@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Aaron Ballman <aaron@aaronballman.com>,
	Bill Wendling <isanbard@gmail.com>,
	Cole Nixon <nixontcole@gmail.com>,
	Connor Kuehl <cipkuehl@gmail.com>, Fangrui Song <i@maskray.me>,
	James Foster <jafosterja@gmail.com>,
	Jeff Takahashi <jeffrey.takahashi@gmail.com>,
	Jordan Cantrell <jordan.cantrell@mail.com>,
	Matthew Maurer <mmaurer@google.com>,
	Nikk Forbus <nicholas.forbus@gmail.com>,
	Qing Zhao <qing.zhao@oracle.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Tim Pugh <nwtpugh@gmail.com>
Subject: Re: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
Message-ID: <202512092319.ECBB8613@keescook>
References: <20241119185747.862544-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119185747.862544-1-ojeda@kernel.org>

On Tue, Nov 19, 2024 at 07:57:47PM +0100, Miguel Ojeda wrote:
> The kernel supports `RANDSTRUCT_FULL` with Clang 16+, and `bindgen`
> (which uses `libclang` under the hood) inherits the information, so the
> generated bindings look correct.
> 
> For instance, running:
> 
>     bindgen x.h -- -frandomize-layout-seed=100
> 
> with:
> 
>     struct S1 {
>         int a;
>         int b;
>     };
> 
>     struct S2 {
>         int a;
>         int b;
>     } __attribute__((randomize_layout));
> 
>     struct S3 {
>         void (*a)(void);
>         void (*b)(void);
>     };
> 
>     struct S4 {
>         void (*a)(void);
>         void (*b)(void);
>     } __attribute__((no_randomize_layout));
> 
> may swap `S2`'s and `S3`'s members, but not `S1`'s nor `S4`'s:
> 
>     pub struct S1 {
>         pub a: ::std::os::raw::c_int,
>         pub b: ::std::os::raw::c_int,
>     }
> 
>     pub struct S2 {
>         pub b: ::std::os::raw::c_int,
>         pub a: ::std::os::raw::c_int,
>     }
> 
>     pub struct S3 {
>         pub b: ::std::option::Option<unsafe extern "C" fn()>,
>         pub a: ::std::option::Option<unsafe extern "C" fn()>,
>     }
> 
>     pub struct S4 {
>         pub a: ::std::option::Option<unsafe extern "C" fn()>,
>         pub b: ::std::option::Option<unsafe extern "C" fn()>,
>     }
> 
> Thus allow those configurations by requiring a Clang compiler to use
> `RANDSTRUCT`. In addition, remove the `!GCC_PLUGIN_RANDSTRUCT` check
> since it is not needed.
> 
> A simpler alternative would be to remove the `!RANDSTRUCT` check (keeping
> the `!GCC_PLUGIN_RANDSTRUCT` one). However, if in the future GCC starts
> supporting `RANDSTRUCT` natively, it would be likely that it would not
> work unless GCC and Clang agree on the exact semantics of the flag. And,
> as far as I can see, so far the randomization in Clang does not seem to be
> guaranteed to remain stable across versions or platforms, i.e. only for a
> given compiler Clang binary, given it is not documented and that LLVM's
> `HEAD` has the revert in place for the expected field names in the test
> (LLVM commit 8dbc6b560055 ("Revert "[randstruct] Check final randomized
> layout ordering"")) [1][2]. And the GCC plugin definitely does not match,
> e.g. its RNG is different (`std::mt19937` vs Bob Jenkins').
> 
> And given it is not supposed to be guaranteed to remain stable across
> versions, it is a good idea to match the Clang and `bindgen`'s
> `libclang` versions -- we already have a warning for that in
> `scripts/rust_is_available.sh`. In the future, it would also be good to
> have a build test to double-check layouts do actually match (but that
> is true regardless of this particular feature).
> 
> Finally, make a required small change to take into account the anonymous
> struct used in `randomized_struct_fields_*` in `struct task_struct`.
> 
> Cc: Aaron Ballman <aaron@aaronballman.com>
> Cc: Bill Wendling <isanbard@gmail.com>
> Cc: Cole Nixon <nixontcole@gmail.com>
> Cc: Connor Kuehl <cipkuehl@gmail.com>
> Cc: Fangrui Song <i@maskray.me>
> Cc: James Foster <jafosterja@gmail.com>
> Cc: Jeff Takahashi <jeffrey.takahashi@gmail.com>
> Cc: Jordan Cantrell <jordan.cantrell@mail.com>
> Cc: Justin Stitt <justinstitt@google.com>
> Cc: Matthew Maurer <mmaurer@google.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nikk Forbus <nicholas.forbus@gmail.com>
> Cc: Qing Zhao <qing.zhao@oracle.com>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Tim Pugh <nwtpugh@gmail.com>
> Link: https://reviews.llvm.org/D121556
> Link: https://github.com/llvm/llvm-project/commit/8dbc6b560055ff5068ff45b550482ba62c36b5a5 [1]
> Link: https://reviews.llvm.org/D124199 [2]
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

I played with this again, and yes it appears to be working. I think,
however, I would like to make the anon struct universal. What do you
think of this?

diff --git a/init/Kconfig b/init/Kconfig
index cab3ad28ca49..839bb5a6b187 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2090,8 +2090,7 @@ config RUST
 	depends on RUST_IS_AVAILABLE
 	select EXTENDED_MODVERSIONS if MODVERSIONS
 	depends on !MODVERSIONS || GENDWARFKSYMS
-	depends on !GCC_PLUGIN_RANDSTRUCT
-	depends on !RANDSTRUCT
+	depends on !RANDSTRUCT || CC_IS_CLANG
 	depends on !DEBUG_INFO_BTF || (PAHOLE_HAS_LANG_EXCLUDE && !LTO)
 	depends on !CFI || HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 1414be493738..ed17db287db1 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -437,14 +437,9 @@ struct ftrace_likely_data {
 #if defined(RANDSTRUCT) && !defined(__CHECKER__)
 # define __randomize_layout __designated_init __attribute__((randomize_layout))
 # define __no_randomize_layout __attribute__((no_randomize_layout))
-/* This anon struct can add padding, so only enable it under randstruct. */
-# define randomized_struct_fields_start	struct {
-# define randomized_struct_fields_end	} __randomize_layout;
 #else
 # define __randomize_layout __designated_init
 # define __no_randomize_layout
-# define randomized_struct_fields_start
-# define randomized_struct_fields_end
 #endif
 
 #ifndef __no_kstack_erase
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b469878de25c..7da987ea7f58 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -833,7 +833,7 @@ struct task_struct {
 	 * This begins the randomizable portion of task_struct. Only
 	 * scheduling-critical items should be added above here.
 	 */
-	randomized_struct_fields_start
+	struct {
 
 	void				*stack;
 	refcount_t			usage;
@@ -1664,7 +1664,7 @@ struct task_struct {
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
 	 */
-	randomized_struct_fields_end
+	} __randomize_layout;
 } __attribute__ ((aligned (64)));
 
 #ifdef CONFIG_SCHED_PROXY_EXEC
diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 49fad6de0674..c52552272495 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -208,7 +208,7 @@ pub fn as_ptr(&self) -> *mut bindings::task_struct {
     pub fn group_leader(&self) -> &Task {
         // SAFETY: The group leader of a task never changes after initialization, so reading this
         // field is not a data race.
-        let ptr = unsafe { *ptr::addr_of!((*self.as_ptr()).group_leader) };
+        let ptr = unsafe { *ptr::addr_of!((*self.as_ptr()).__bindgen_anon_1.group_leader) };
 
         // SAFETY: The lifetime of the returned task reference is tied to the lifetime of `self`,
         // and given that a task has a reference to its group leader, we know it must be valid for
@@ -220,7 +220,7 @@ pub fn group_leader(&self) -> &Task {
     pub fn pid(&self) -> Pid {
         // SAFETY: The pid of a task never changes after initialization, so reading this field is
         // not a data race.
-        unsafe { *ptr::addr_of!((*self.as_ptr()).pid) }
+        unsafe { *ptr::addr_of!((*self.as_ptr()).__bindgen_anon_1.pid) }
     }
 
     /// Returns the UID of the given task.
@@ -291,7 +291,7 @@ impl CurrentTask {
     pub fn mm(&self) -> Option<&MmWithUser> {
         // SAFETY: The `mm` field of `current` is not modified from other threads, so reading it is
         // not a data race.
-        let mm = unsafe { (*self.as_ptr()).mm };
+        let mm = unsafe { (*self.as_ptr()).__bindgen_anon_1.mm };
 
         if mm.is_null() {
             return None;

-- 
Kees Cook
