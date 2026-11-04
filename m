Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831441;
	b=irZ8KLqwHofFIbvv0pSgbG325CgTOiSDibcGG1tzowU1P8HkfmAMu8EDOQRvxddaWMZK
	 tr4vSq+xIp7E4nXbjtiQ+N+R8oSWlEdzOSo/x8w/laUuScMrBTnOoIMjDxsk5V0tN0qg2
	 /zRLfirZZZe5OMINCYykUd8vlPzNruTGR4o9zzk3vYOw/W4I/VAa3/FwW2Uk2bxqUutRY
	 R571HZxOohFJgO66jyhKY56AIsjWtzADXqpd/Nk7BvVPEEx5sT9hNmfEpWJkS6alg8kfn
	 9N77y4NiwCsrULgiT7EsfLpj4DpUyJYopewNW50MFKDlKG6jViY6k721xCEAm0iiCHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ldpzUiWcTCqRZwAWuHPv2cf+E2FT/cfdyI5f2oZbYZM=;
	b=eR4Q2VEM47EUB1VuXg9i7RmlOVaDj9yQNrUfAJAeI/eAQz6oPFezt3pBW5nn1EJOzpmC
	 zbLT2PLtzdEbsvS5eFHlCC/nbSknXTs73rEBJm3CsQW1n3GENwBQIAwGTyriHzmue16iV
	 Tq7q6fhppb6E197nkONqHyO0GXNlvA83sCg43DuFQijY1LvvoPr5KfnXrhXJaXQ183ZFM
	 k+ye6VS2o0iFuUIpWRgXLGoybLT7HE/Qq72OR206lVk6lL7uDSIvn2IRaJ62ADnF9zC+s
	 rHSf8sv6SuFIxLjJhi4EEdOO7/RHKffhB2NMWem0xIQe8h6C5Wbk0ZE0LM002w47J3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFL0yL6Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C3D606AC07;
	Wed,  4 Nov 2026 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFL0yL6Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207ED1F000C1;
	Wed,  4 Nov 2026 22:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831441;
	bh=ldpzUiWcTCqRZwAWuHPv2cf+E2FT/cfdyI5f2oZbYZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFL0yL6QYxQiYRjebnMtLnaqSgOWn8bN++nG9rezQ9N75BfUSrhv1zZ61PgvBeOzN
	 uRlJiV1ETq+44INduPz+JMIFrhZq76iRNmCZi6JM4+JR7CNSYrnlp6YU7/LDCVqIcv
	 ZcowaoidzqAeZS9pg+tfQ4drafi5r/ePqYnvr4aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Koseoglu <mehmet.mkoseoglu@gmail.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	spidermana <xuyiwen14@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.18 0703/1005] rust: cpufreq: reject NULL from cpufreq_cpu_get()
Date: Wed,  4 Nov 2026 16:07:16 -0500
Message-ID: <20261104211103.275853018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,12 +695,13 @@ struct PolicyCpu<'a>(&'a mut Policy);
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


