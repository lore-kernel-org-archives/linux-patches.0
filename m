Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827109;
	b=epKUFpcSekBx+pyWCjGCrbx4cweMC76zVaIsKxcfx1PARv/ljuuqnJZ+fE2BigI7gLBL
	 T+YJAKchus0M96RnDyWVqTX/dYTZVHue3ilmDU+a4+2XkAg01gB5p86Vz/9UefX1ynIpa
	 K6FsbRkeB1pbsc0GK27ik9RB5k6l1ZmzXHGG6haAJN4h0HRXku1eWaXeymxLZsO4arZzn
	 41mReTWrP8Ft3cVC/lTWFpbgLXrqhMOyNafc7jdObd18Hr4bDv06W6NrdtUUFidb3OOaU
	 wspEVIVVdR+znIN/6KfpU5CFtzz/0p8BmLihmjfE0aXazMhrWVhdtn/twWHmm8F//cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FYWPhHg8ZLxrR0mRMBvngLUfXUrHm5kuoUH4VZ1U9FY=;
	b=bVNQ57AIu4uQwar5m+oRQznYmtBPf+tCzMoGj+u9lIrMsTVipSYpdOkpaTaT1vt+HC6g
	 KL0vxq0uEWFGw7joAD/fJaRNHfpvYxr3IIIoqFtMIJiNZXefp0+yQ3sgnGZYeshymMtlx
	 9t/VOOyroYgEUivMoPNS7js5C3DP0lFh1WyU6TeTxtclPgcXfVNEHXuCOobetKpu8zNDk
	 TKm0jBrYZpUrOAKqIE28a21BYGCJtKYUzbYNvLDB6QaNf2FpeNnZTF4fOH4H5R67X1sDj
	 og63K+naiEYuytpE5eG4OsrXlHEISqLUlWr4ugVehgitdfTnSmxnOCmYN62V80jZEaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Po7WC1eG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961D160877EB;
	Wed,  4 Nov 2026 21:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Po7WC1eG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71281F00919;
	Wed,  4 Nov 2026 21:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827109;
	bh=FYWPhHg8ZLxrR0mRMBvngLUfXUrHm5kuoUH4VZ1U9FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Po7WC1eGUp/21IGDBrnONJeX6fZxfC4rsZOc7ul/O5zHqj5ylcwgA3mHq9OfnxDA0
	 PwfUcLHbWkbgcaJLIREjYv8kuTIacG0dOgFHP+n5c74p9w/bzoJHU/1uW1GNAnhqKm
	 k98J0mW68IqLC6PiR7rhuPGdhWD5c6NgU1TbdTwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	spidermana <xuyiwen14@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 7.3 200/547] rust: cpufreq: reject NULL from cpufreq_cpu_get()
Date: Wed,  4 Nov 2026 16:06:24 -0500
Message-ID: <20261104211043.825334305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>

commit 02c5d7bfa8724789f6620f7787532666edc891a1 upstream.

cpufreq_cpu_get() returns either a referenced policy or NULL.
PolicyCpu::from_cpu() passed its return value to from_err_ptr(), which
rejects ERR_PTR values but accepts NULL.

If the lookup fails, Policy::from_raw_mut() therefore constructs a mutable
reference from NULL. Dropping the resulting PolicyCpu then passes the
invalid pointer to cpufreq_cpu_put(), causing an oops in kobject_put().

Reject NULL with NonNull before constructing the Policy reference. Return
ENODEV instead.

A KUnit negative-control run reproduced the oops with the original
conversion. The same test passed with this change. The reproducer is
available on request.

Fixes: 6ebdd7c93177 ("rust: cpufreq: Extend abstractions for policy and driver ops")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>
Reviewed-by: Onur Özkan <work@onurozkan.dev>
Reviewed-by: spidermana <xuyiwen14@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/cpufreq.rs |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -14,7 +14,13 @@ use crate::{
     cpumask,
     device::{Bound, Device},
     devres,
-    error::{code::*, from_err_ptr, from_result, to_result, Result, VTABLE_DEFAULT_ERROR},
+    error::{
+        code::*,
+        from_result,
+        to_result,
+        Result,
+        VTABLE_DEFAULT_ERROR, //
+    },
     ffi::{c_char, c_ulong},
     prelude::*,
     types::ForeignOwnable,
@@ -29,7 +35,10 @@ use core::{
     marker::PhantomData,
     ops::{Deref, DerefMut},
     pin::Pin,
-    ptr,
+    ptr::{
+        self,
+        NonNull, //
+    },
 };
 
 use macros::vtable;
@@ -687,12 +696,13 @@ struct PolicyCpu<'a>(&'a mut Policy);
 impl<'a> PolicyCpu<'a> {
     fn from_cpu(cpu: CpuId) -> Result<Self> {
         // SAFETY: It is safe to call `cpufreq_cpu_get` for any valid CPU.
-        let ptr = from_err_ptr(unsafe { bindings::cpufreq_cpu_get(u32::from(cpu)) })?;
+        let ptr =
+            NonNull::new(unsafe { bindings::cpufreq_cpu_get(u32::from(cpu)) }).ok_or(ENODEV)?;
 
         Ok(Self(
-            // SAFETY: The `ptr` is guaranteed to be valid and remains valid for the lifetime of
-            // the returned reference.
-            unsafe { Policy::from_raw_mut(ptr) },
+            // SAFETY: `ptr` is non-NULL and `cpufreq_cpu_get()` took a reference on it, so it is
+            // valid for writing and remains valid for the lifetime of the returned reference.
+            unsafe { Policy::from_raw_mut(ptr.as_ptr()) },
         ))
     }
 }


