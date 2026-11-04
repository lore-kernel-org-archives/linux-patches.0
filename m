Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831252;
	b=E4ax7L6rBkpCUcUiHZ6FVCMMHbUIT9JZklSI+T++LaszMmqz1dNxte11a3LxelaDd0cK
	 jtxGMLrfLXMl5dP5W/6BDWn+N7/bMMyxF6ndw7mfg1k9LuVBGAqXNchc1c4kmsWChBBqB
	 W8OiRKM6fjQ/biLHdXBw8ja802HIXfL3r1RBKXUXFio77Tw0wUM6HtBgAxVE18BxLS7G2
	 G3ClG2gSSZ9yvcq6NF+PGJKjPrIfiZY/FfuJYA6+ieEjnDhMQzCUmz1reNHJm4ua/LhNc
	 5lcFzXZfHqSHyAikRy+ZFS7bpqJeSfIZV7ctaQJq+rOLCzaKLayWRMwA0PHz0CxNZVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BhOfF86LHzYPi0KWwCv4i5wnnGd0DBLR9fl4Sa6tkM=;
	b=AcLX6brs1W3+PXd2slSQaKUvfa2rLXMeg+FxW+XwQQ9hrFMUK4j5K0uC2jjlVTL5TydX
	 qM+n3KkSOBS+ppiGPpGchG7Y+fRcT1KRY/wc1V9+hZYosrPEcNg9HbJzKNH5iuvsGGeGK
	 xOp1jxZhdwByCkDJp4lVSxExfqeH3xywprpuw2mTDu+Vlz3SLWwa2CiXWQiMkTSDyb0JC
	 b1r0Hv7k1MtEAvCqG9pXCbAyFQTjMFQBZXpJ3t3b/8WMWhfLR7qbM//Z5PQs3a3G/B/uB
	 wpESOjX9BWec2ZUTvG3GveZrFoJ3B8VizfhOu11lYHyCa/PQs9wN7mp94rgcJCyw6AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9tRq3AI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB3C606A33E;
	Wed,  4 Nov 2026 22:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9tRq3AI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0AC1F000C1;
	Wed,  4 Nov 2026 22:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831250;
	bh=0BhOfF86LHzYPi0KWwCv4i5wnnGd0DBLR9fl4Sa6tkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9tRq3AIcmf9DKNPQUraZsZymG6p8YUVZZDHiNeKgh4Pt0mIbSqliAYHjbvIeihIc
	 xiBX97gdpytf1o2MOgKimxyID5cqCmsIuoUAt/e2D3fvjtyP8kqKBbliUmgY2zASm8
	 uJ12cB+NTw4X75Fj8bFcL6JCQO8P8Dr9WIReC/oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0552/1005] rust: bug: fix warn_on macro build error on UML
Date: Wed,  4 Nov 2026 16:04:45 -0500
Message-ID: <20261104211059.353572803@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

[ Upstream commit 30a449e04a32033d8e4844fdb4938a0ebccfa37b ]

Callers that go through `kernel::prelude` have `CStrExt` in scope, but
code inside the `kernel` crate imports explicitly and may not. Using
`warn_on!` from such a module fails to build on UML, which is the only
configuration where `warn_flags!` needs a C string pointer rather than an
inline asm bug entry:

error[E0599]: no method named `as_char_ptr` found for reference `&ffi::CStr` in the current scope
   --> linux/rust/kernel/bug.rs:83:49
    |
 83 |                 $crate::c_str!(::core::file!()).as_char_ptr(),
    |                                                 ^^^^^^^^^^^
    |
   ::: linux/rust/kernel/time.rs:427:9
    |
427 |         warn_on!(self.nanos < 0);
    |         ------------------------ in this macro invocation
    |
    = help: items from traits can only be used if the trait is in scope
    = note: this error originates in the macro `$crate::warn_flags` which comes from the expansion of the macro `warn_on` (in Nightly builds, run with -Z mac)
help: trait `CStrExt` which provides `as_char_ptr` is implemented but not in scope; perhaps you want to import it
   --> linux/rust/kernel/time.rs:27:1
    |
 27 + use crate::str::CStrExt;

Call the method through its fully qualified path, which resolves
without any import at the expansion site.

Cc: stable@vger.kernel.org
Fixes: dff64b072708 ("rust: Add warn_on macro")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Link: https://patch.msgid.link/20260807112427.1039056-1-tomo@flapping.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/bug.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/bug.rs b/rust/kernel/bug.rs
index 53dbdaec3560b..15a84e553fd4d 100644
--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -83,7 +83,7 @@ macro_rules! warn_flags {
         // with a valid null-terminated string.
         unsafe {
             $crate::bindings::warn_slowpath_fmt(
-                $crate::c_str!(::core::file!()).as_char_ptr(),
+                $crate::str::CStrExt::as_char_ptr($crate::c_str!(::core::file!())),
                 line!() as $crate::ffi::c_int,
                 $flags as $crate::ffi::c_uint,
                 ::core::ptr::null(),
-- 
2.53.0



