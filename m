Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063807;
	b=b5wM+HkhaJkoa1azJGrqRI0IpdyvG2//7WyJ5zuAiwU5VUB9SKu0eSSxG2zjtpmK1ObB
	 VPX6FBDRJjD0gasRenhtKr1yXCYXXyJWWwoL7pMxcGHOQcNx0z8f6K/y4pRHzX1KBWZfy
	 ICNzcQtAnCLJd4Rvm4JqG0fI/nLDxotlZwsr5C7tqwSgSCJMrBlio72sIzEOVKVa5mtb8
	 PakSHlkodSSVIkvINJuzLPsTAEaqAiD12oZaMwAd9Lx8OZJ1TuN2L8LZrF4n7FEnIMgVq
	 Ajbxrmo96edly4zx201CVYdHF9sTYHtOG00AiUMMxpyrrmqcnYYW2NFDFj27zvZgTzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=npIdTjGWtITuZqu+dwB/IuGt2ONz1z4dCPFZlQtyR5U=;
	b=H+D9OaHTV5s4axI/+kWFZ/uG7QvsXuQOBde1S5Cs7oiXhVO0fDvGEKRRIk7dP2HqoSIQ
	 PM3vx4H5KFaB0Ph9zzoae32qh0B9VZVIS5B48AQlnvs1A6PT4+Tlo72Bf40KaJUPhc38i
	 g+v2uhbqdKEh3SS9wgSKOWc7sdsXNIDtGvjupcpzX6jd52Wqja6lF8eaTw0i5zZJDNf8m
	 1PtaiGBk92TTBT8bgcn0yeGl8OLJfDLMbreGr9ONspTp47M5qNoQxZDGs26/u5E/sk7rX
	 w7szuDCZ2E3lzomMSQ9TLMX+/AmttnyCHnJYze/tZENwZgOo8Cr7XGUHUEk/lZEW7WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iG5H9SJo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D7A606EE81;
	Sat,  7 Nov 2026 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iG5H9SJo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680121F0089F;
	Sat,  7 Nov 2026 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063806;
	bh=npIdTjGWtITuZqu+dwB/IuGt2ONz1z4dCPFZlQtyR5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iG5H9SJoKiIink6xsg2SyudfF2kDXiIt2P/deRM2pzIRzV7EmZALzO3KyGMYXnHap
	 vikmo9PDbu3FCNRfIhMSrO9LpITcxUKh08yMG4qG+jK9lFdBKMK1N+K7cFPJ1TC/Ke
	 8VVwwsFeXY7y+zkDjWpnvfKUH5vEyIAyH+2HTTA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0008/1257] rust: hrtimer: declare cfi_encoding for hrtimer_restart
Date: Sat,  7 Nov 2026 08:38:24 -0500
Message-ID: <20261107134939.663072966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Sami Tolvanen <samitolvanen@google.com>

commit 39fe6892fd52faed6325ff7f13a92da01ab35727 upstream.

The hrtimer callbacks return bindings::hrtimer_restart, which bindgen
generates as c_uint. C calls them through hrtimer->function, which
returns enum hrtimer_restart. kCFI encodes enum types by name even with
integer normalization, so the type ids never match and every call fails
the CFI check.

Generate hrtimer_restart as a newtype with a cfi_encoding, as is done
for lru_status, and adapt HrTimerRestart to the newtype.

Fixes: 8a8afe9349fb ("rust: hrtimer: introduce hrtimer support")
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Tested-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Acked-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261019-rust-cfi-fixes-v1-2-9503472ba738@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
[ Adjusted insertion context. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/bindgen_parameters     | 2 ++
 rust/kernel/time/hrtimer.rs | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index cbc0a302647e5..45f6eb56a1f73 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -29,6 +29,8 @@
 # enums that appear in indirect function calls should specify a cfi type
 --newtype-enum fwctl_rpc_scope
 --with-attribute-custom-enum=fwctl_rpc_scope='#[cfi_encoding="15fwctl_rpc_scope"]'
+--newtype-enum hrtimer_restart
+--with-attribute-custom-enum=hrtimer_restart='#[cfi_encoding="15hrtimer_restart"]'
 --newtype-enum irqreturn
 --with-attribute-custom-enum=irqreturn='#[cfi_encoding="9irqreturn"]'
 --newtype-enum lru_status
diff --git a/rust/kernel/time/hrtimer.rs b/rust/kernel/time/hrtimer.rs
index 2d7f1131a8131..07344ed5fbd58 100644
--- a/rust/kernel/time/hrtimer.rs
+++ b/rust/kernel/time/hrtimer.rs
@@ -834,14 +834,14 @@ unsafe fn start(this: *const Self, expires: <Self::TimerMode as HrTimerMode>::Ex
 #[repr(u32)]
 pub enum HrTimerRestart {
     /// Timer should not be restarted.
-    NoRestart = bindings::hrtimer_restart_HRTIMER_NORESTART,
+    NoRestart = bindings::hrtimer_restart::HRTIMER_NORESTART.0,
     /// Timer should be restarted.
-    Restart = bindings::hrtimer_restart_HRTIMER_RESTART,
+    Restart = bindings::hrtimer_restart::HRTIMER_RESTART.0,
 }
 
 impl HrTimerRestart {
     fn into_c(self) -> bindings::hrtimer_restart {
-        self as bindings::hrtimer_restart
+        bindings::hrtimer_restart(self as c_uint)
     }
 }
 
-- 
2.53.0



