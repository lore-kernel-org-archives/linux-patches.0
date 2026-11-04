Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827104;
	b=tgVjIovbWdirnN0X5UPWPVm0P6I6o0GOAlmrYlJaZrxdT/dbZtZMYEOrbFbatQpUpmL0
	 TASa+N/FEl205cqq3O2C1xB5QnqTf5gQKaMQUHEJ+cGPmoWPpHa/JYy/xR6WbTwlBVPHo
	 Fjk4qh4bI32hd+dAhkMciMzopu42Seuo5K65P98cWhQG6ok/JxNMFp+Bjf2pjyb4MRpVE
	 ZdKA7Tu1lDys/eNe9+Opd0I/7f3/8pGnCK6jYHXhVz5AzSLrHbP84/KFhCk3a/8bsF6Oq
	 pkMbQFOFgogFi+99eZomvrJgcJBGJhS8h5qF+jSRshmpbDmm5ssGmpx8iDXKYSiLFQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JGr1RvGkoNorSnPNcTPwiHCnpRyyyvrTbpm1NoeiZjE=;
	b=1yMT2CVIrnFLXsYoZjycb8cWfP/v2AJJqN+TEzR8g4sFZihIIJVFcPzb32eKaHUxLVpj
	 r1/Sf3u0uw3PIJhLqHgJwLGvIZTpu57JfGkSFy4vfbZHnabvJMxUywy4IhRM+xHJm4+H8
	 6O2M1aGJIdEvT/lY4wAepyodzHS1jp8323CSkP5TXHhHgjVjA7owIVQnpYbeOeKSRDVMP
	 RwAP4UgH9Q1vIf1SNDMXdCsH6PfYclpOUTJpNbSFztSdhytkW2EnAojDRWuvaMIA3G0ai
	 AvPYih5acSXY7EAKrJsdo+wyE77tkEXySjH6/yy/UN7iab9f3t5SIQ5U41yUj4OLEMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dng7HwK4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435A4606AE00;
	Wed,  4 Nov 2026 21:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dng7HwK4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E321F000C1;
	Wed,  4 Nov 2026 21:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827104;
	bh=JGr1RvGkoNorSnPNcTPwiHCnpRyyyvrTbpm1NoeiZjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dng7HwK46lkdl+qtx8OeokwXDPt73JV8CHICRonNC7Ut2YGPVaKVUcWMS7clcyppc
	 K5kFNyHZsLIQXz6LsQ8oASKID1RS45EsPZ+Shcz8HHEYhf6piTxZXBvfP9zu4V8sma
	 nCXtzGkVBG7eO6ZOnWb/h3wWq2xATzFq+6cu23m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.3 197/547] rust: bug: pass TAINT_WARN to warn_slowpath_fmt() on UML
Date: Wed,  4 Nov 2026 16:06:21 -0500
Message-ID: <20261104211043.737749499@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit 951d09ca450ca76a695016ea76c3fa653bd20439 upstream.

On UML, `warn_flags!` calls `warn_slowpath_fmt()` directly. Its third
argument is a taint number, but `warn_on!` passes its bug flags there.

As a result, `add_taint()` gets 2304 instead of 9 (`TAINT_WARN`). The
warning is not recorded: `/proc/sys/kernel/tainted` stays 0 after
`warn_on!` fires, where it should be 512. It also causes an
out-of-bounds write in `add_taint()`.

Pass `TAINT_WARN` directly, as C does on UML.

Cc: stable@vger.kernel.org
Fixes: dff64b072708 ("rust: Add warn_on macro")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Link: https://patch.msgid.link/20261001123103.2198104-1-tomo@flapping.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/bug.rs |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -85,6 +85,7 @@ macro_rules! warn_flags {
     ($file:expr, $flags:expr) => {
         if false {
             _ = $file;
+            _ = $flags;
         }
 
         // SAFETY: It is always safe to call `warn_slowpath_fmt()`
@@ -93,7 +94,7 @@ macro_rules! warn_flags {
             $crate::bindings::warn_slowpath_fmt(
                 $crate::str::CStrExt::as_char_ptr($crate::c_str!(::core::file!())),
                 line!() as $crate::ffi::c_int,
-                $flags as $crate::ffi::c_uint,
+                $crate::bindings::TAINT_WARN,
                 ::core::ptr::null(),
             );
         }


