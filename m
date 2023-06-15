Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36228379
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 01:44:26 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-5ed99ebe076so23786486d6.2
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 18:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686793466; x=1689385466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89wdz+93fOJGDfymVTb02j/BFgyh+BUwRn3kzUFi0mA=;
        b=qaUE7LU4qCjY5uyqrdAzpX1qPmRugFlBpI2GmkRPUr4pVjvrlLmBIDCU7nwGIWB0z0
         pqHFpWka4MhO2OzuZvCfOZkVmA4ww4TSdX6oODkweS9MdUB2fOFlNMDovgeAeFF8/dcW
         Vt0SDng1sMs+/lB52fQcM5ndpuMFP2dqlOYZjTNQcqsOXvxQ7R7UcoaDMaKvo0fL8FVH
         ORuYvcMZIakjsgiG8HoUK4BSILlv9EuTVDvg2Yqd0Zx+hizVMYxo/nOmPhgf+n668FIK
         h2P4h5ed8MHQmnApkYOprfPRCLnBhbi0N6s0eCxXF5aS+hO2O41DnUNFBx9GGqZnXQQq
         NfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686793466; x=1689385466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89wdz+93fOJGDfymVTb02j/BFgyh+BUwRn3kzUFi0mA=;
        b=e4pytpl5HrZWnzjUhqIsWK4BMCO/rRYLf4I9jE6/7/ZBECHTYfUO+HydQS2YGaZFbQ
         /i4iL5cda37LaN2ene6XegADitp1yV0KqtgqqsNsyx3uriWxbly9hjKTkvAoiMvX7IqX
         nmx8iRqPk3itHLazQKXrn6Qg0FWExRznkqYkRglClcmn0Hj/41sUqWJR1HMAJ8B10YFI
         h+QuwUykk4w3/GIrkVVh+QWsbJMGshauNIrw/KNXj2Asw8N/uLpjKkQgyqxDrsdllu5T
         VhrIViuu03LejIJBa7vPnic1uY7bAZ5iWMfnOA39TOO3vDugtv4kN/iTAhDB0LMxgYXp
         eYJg==
X-Gm-Message-State: AC+VfDxdyYMZvSIRlx4MeCoWSDGkvwn9K419WpwPUcCl0Cd+9KorWXo5
	s+lQHx1Ax2U30QpkuLr29t8=
X-Google-Smtp-Source: ACHHUZ6mUyqj0y59odMzK/cplVR3BePgKBfHjKYwcbBBvPuWywGDU8vCFZCC/6crtTOLUqlFQtDlvw==
X-Received: by 2002:a05:6214:19e2:b0:62d:e946:5188 with SMTP id q2-20020a05621419e200b0062de9465188mr13538848qvc.40.1686793465767;
        Wed, 14 Jun 2023 18:44:25 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id n6-20020a0ce546000000b006267daad667sm5270043qvm.94.2023.06.14.18.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 18:44:25 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailauth.nyi.internal (Postfix) with ESMTP id B4EB927C0054;
	Wed, 14 Jun 2023 21:44:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 14 Jun 2023 21:44:24 -0400
X-ME-Sender: <xms:92yKZJY-S4jpDP5jvDIK090rZrVDddT5MmpfL-ks-SACdb-7RDixuQ>
    <xme:92yKZAaGgrBc3GL7bU3acW2W2bcOO-MsxYo19wB-f6J2UkBsc4sMYRH7sLyYfE_PI
    QZwIWkV36QK0TAC5g>
X-ME-Received: <xmr:92yKZL_M5CR2-nRl58TETt-ghJl2ZVdu5dT6uW97PU-35rEvai6EjZqFDHk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvuddgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:92yKZHozVuyOU60t-cpqoSDOB7CTMQd-Nia8sC2Y-d4dTiNr-OzyxQ>
    <xmx:92yKZEpLr4_3UaSVYme33QyFeK8b4_caL00Gl7wxPzCI6VKYzIFRrA>
    <xmx:92yKZNQmZsDIZLNUFHcZ-VV-C80AV7YXgexJXK8cFC3rXBHzp--gOg>
    <xmx:-GyKZAbgaDFx5_yoc2ckHBB68Cre8pwAHI7vNqyE0PEvQ2AWQ0S3DQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Jun 2023 21:44:22 -0400 (EDT)
Date: Wed, 14 Jun 2023 18:44:19 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: David Gow <davidgow@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>,
	Philip Li <philip.li@intel.com>, kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 0/6] KUnit integration for Rust doctests
Message-ID: <ZIps86MbJF/iGIzd@boqun-archlinux>
References: <20230614180837.630180-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614180837.630180-1-ojeda@kernel.org>

On Wed, Jun 14, 2023 at 08:08:24PM +0200, Miguel Ojeda wrote:
> This is the initial KUnit integration for running Rust documentation
> tests within the kernel.
> 
> Thank you to the KUnit team for all the input and feedback on this
> over the months, as well as the Intel LKP 0-Day team!
> 
> This may be merged through either the KUnit or the Rust trees. If
> the KUnit team wants to merge it, then that would be great.
> 
> Please see the message in the main commit for the details.
> 

Great work! I've played this for a while, and it's really useful ;-)

One thing though, maybe we can provide more clues for users to locate
the corresponding Doctests? For example, I did the following to trigger
an assertion:

	diff --git a/rust/kernel/sync/lock/spinlock.rs b/rust/kernel/sync/lock/spinlock.rs
	index 91eb2c9e9123..9ead152e2c7e 100644
	--- a/rust/kernel/sync/lock/spinlock.rs
	+++ b/rust/kernel/sync/lock/spinlock.rs
	@@ -58,7 +58,7 @@ macro_rules! new_spinlock {
	 ///
	 /// // Allocate a boxed `Example`.
	 /// let e = Box::pin_init(Example::new())?;
	-/// assert_eq!(e.c, 10);
	+/// assert_eq!(e.c, 11);
	 /// assert_eq!(e.d.lock().a, 20);
	 /// assert_eq!(e.d.lock().b, 30);
	 /// # Ok::<(), Error>(())

Originally I got:

	[..] # Doctest from line 35
	[..] # rust_doctest_kernel_sync_lock_spinlock_rs_0: ASSERTION FAILED at rust/doctests_kernel_generated.rs:2437
	[..] Expected e.c == 11 to be true, but is false
	[..] [FAILED] rust_doctest_kernel_sync_lock_spinlock_rs_0

The assertion warning only says line 35 but which file? Yes, the
".._sync_lock_spinlock_rs" name does provide the lead, however since we
generate the test code, so we actually know the line # for each real
test body, so I come up a way to give us the following:

	[..] # rust_doctest_kernel_sync_lock_spinlock_rs_0: ASSERTION FAILED at rust/kernel/sync/lock/spinlock.rs:61
	[..] Expected e.c == 11 to be true, but is false
	[..] [FAILED] rust_doctest_kernel_sync_lock_spinlock_rs_0

Thoughts?

Regards,
Boqun

----------------->8
diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
index 3c94efcd7f76..807fe3633567 100644
--- a/rust/kernel/kunit.rs
+++ b/rust/kernel/kunit.rs
@@ -49,15 +49,15 @@ pub fn info(args: fmt::Arguments<'_>) {
 #[doc(hidden)]
 #[macro_export]
 macro_rules! kunit_assert {
-    ($name:literal, $condition:expr $(,)?) => {
+    ($name:literal, $diff:expr, $file:expr, $condition:expr $(,)?) => {
         'out: {
             // Do nothing if the condition is `true`.
             if $condition {
                 break 'out;
             }
 
-            static LINE: i32 = core::line!() as i32;
-            static FILE: &'static $crate::str::CStr = $crate::c_str!(core::file!());
+            static LINE: i32 = core::line!() as i32 - $diff;
+            static FILE: &'static $crate::str::CStr = $crate::c_str!($file);
             static CONDITION: &'static $crate::str::CStr = $crate::c_str!(stringify!($condition));
 
             // SAFETY: FFI call without safety requirements.
@@ -148,9 +148,9 @@ unsafe impl Sync for UnaryAssert {}
 #[doc(hidden)]
 #[macro_export]
 macro_rules! kunit_assert_eq {
-    ($name:literal, $left:expr, $right:expr $(,)?) => {{
+    ($name:literal, $diff:expr, $file:expr, $left:expr, $right:expr $(,)?) => {{
         // For the moment, we just forward to the expression assert because, for binary asserts,
         // KUnit supports only a few types (e.g. integers).
-        $crate::kunit_assert!($name, $left == $right);
+        $crate::kunit_assert!($name, $diff, $file, $left == $right);
     }};
 }
diff --git a/scripts/rustdoc_test_gen.rs b/scripts/rustdoc_test_gen.rs
index 793885c32c0d..4786a2ef0dc6 100644
--- a/scripts/rustdoc_test_gen.rs
+++ b/scripts/rustdoc_test_gen.rs
@@ -75,6 +75,11 @@ fn main() {
 
         let line = line.parse::<core::ffi::c_int>().unwrap();
 
+        let src_file = format!("rust/kernel/{}", file.replace("_rs", ".rs").replace("_", "/"));
+
+        // Calculate how many lines before `main` function (including the `main` function line).
+        let body_offset = body.lines().take_while(|l| !l.contains("fn main() {")).count() + 1;
+
         use std::fmt::Write;
         write!(
             rust_tests,
@@ -85,7 +90,7 @@ pub extern "C" fn {kunit_name}(__kunit_test: *mut kernel::bindings::kunit) {{
     #[allow(unused)]
     macro_rules! assert {{
         ($cond:expr $(,)?) => {{{{
-            kernel::kunit_assert!("{kunit_name}", $cond);
+            kernel::kunit_assert!("{kunit_name}", anchor - {line}, "{src_file}", $cond);
         }}}}
     }}
 
@@ -93,7 +98,7 @@ macro_rules! assert {{
     #[allow(unused)]
     macro_rules! assert_eq {{
         ($left:expr, $right:expr $(,)?) => {{{{
-            kernel::kunit_assert_eq!("{kunit_name}", $left, $right);
+            kernel::kunit_assert_eq!("{kunit_name}", anchor - {line}, "{src_file}", $left, $right);
         }}}}
     }}
 
@@ -101,9 +106,8 @@ macro_rules! assert_eq {{
     #[allow(unused)]
     use kernel::prelude::*;
 
-    // Display line number so that developers can map the test easily to the source code.
-    kernel::kunit::info(format_args!("    # Doctest from line {line}\n"));
-
+    // The anchor where the test code body starts.
+    static anchor: i32 = core::line!() as i32 + {body_offset} + 1;
     {{
         {body}
         main();
