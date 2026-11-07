Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062690;
	b=nqHG2dbTIZoFmt+t9l7+G0JAMhJW7bCkFjx+YXvUA/75fa4ilyvxu5dN8/vfxskGmGz/
	 PbATiWpP6Q0k6q+QGNdlGD4HcRDu9ZGFMhg8uBNId5Ai9UN+TPhTDjTDVb0dMsIOZY8/N
	 a7P8+xxaGm+ES5zLj65fpuRbOvaZTGNIhUYNZFiRA4dn/cTlCPyxKtS7dSRgps3NAcs2E
	 69fomSylRq1FY4sQopPw9mTz7yObW/IgbfKK972DiiZ/m8z/Yh5CLitbBuyrzGBhkFjde
	 TUsCEGpHLwGLzwXfZvXD6VQfqRwhBpf/YU0e158A5Az7GvhfRksUgetcQsGwZ74bLnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u3t118KE15tN8k4GVw4JCoC83UyxSu/9gTrqf+uBph4=;
	b=vFamRNA+Px1zK8RAklE6m8kuxUqBQRMi7xZkSrix+AJQQWBIxPSNsJxiHo4QKxY44o6I
	 Z0l/ku6T00zT8P43C2J1n1n7kn0fnQ2MErwHQCJvrZvHoY7xPD8d+mw27iuhakYSNtj3l
	 LtM83WgHJKQR91PK15JLS6tOskzh4e22lbk4HPpO2CLrLVpkIqlQI/PhoKtG1aoLyr7Cq
	 mVABzs1sN6+uffWrtI6jX5TX3tk7ThaL8uVeekbRSxTQBGrU4nlyBXLIh2o99tIgpS2eP
	 VYpIc4Gsg3xNCHq7I8US309uGYdPMR2a3rLNbLgwNsuMllPH4yIva3oXLngVOY3CvIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjsTTcpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE8B606A326;
	Sat,  7 Nov 2026 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjsTTcpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ECB1F0089F;
	Sat,  7 Nov 2026 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062689;
	bh=u3t118KE15tN8k4GVw4JCoC83UyxSu/9gTrqf+uBph4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjsTTcpewzCtreQX+zBxg+f6qaVBJtTTMnvJ5s72At3Dne+CZULBtiC4sU7x8vy69
	 l7g+6eOY1YHzK3jSwnbgiiXOlei0x3singqOCP0bSCtt6p+Ou94SDrfcc4PGmE3alW
	 U47OYx1QKi5/MZ3Mg8Un0eZBuw2/qMT++j0Iqo0I=
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
Subject: [PATCH 6.18 017/869] rust: hrtimer: declare cfi_encoding for hrtimer_restart
Date: Sat,  7 Nov 2026 08:44:59 -0500
Message-ID: <20261107134852.563877443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
[ Replaced bindgen's custom enum attribute option with sed
  post-processing to support older bindgen. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile               | 1 +
 rust/bindgen_parameters     | 1 +
 rust/kernel/time/hrtimer.rs | 6 +++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index 3867ff14fbdec..3f1abad648e66 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -368,6 +368,7 @@ $(obj)/bindings/bindings_generated.rs: private bindgen_target_flags = \
     $(shell grep -Ev '^#|^$$' $(src)/bindgen_parameters)
 $(obj)/bindings/bindings_generated.rs: private bindgen_target_extra = ; \
     sed -Ei 's/pub const RUST_CONST_HELPER_([a-zA-Z0-9_]*)/pub const \1/g' $@; \
+    sed -Ei 's/^pub struct hrtimer_restart\(/#[cfi_encoding="15hrtimer_restart"]\n&/' $@; \
     sed -Ei 's/^pub struct irqreturn\(/#[cfi_encoding="9irqreturn"]\n&/' $@
 $(obj)/bindings/bindings_generated.rs: $(src)/bindings/bindings_helper.h \
     $(src)/bindgen_parameters FORCE
diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index 9e02500dc9792..6f76fdcffd58d 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -24,6 +24,7 @@
 --opaque-type spinlock
 
 # enums that appear in indirect function calls should specify a cfi type
+--newtype-enum hrtimer_restart
 --newtype-enum irqreturn
 
 # `seccomp`'s comment gets understood as a doctest
diff --git a/rust/kernel/time/hrtimer.rs b/rust/kernel/time/hrtimer.rs
index 856d2d929a008..35ff2ef7d9441 100644
--- a/rust/kernel/time/hrtimer.rs
+++ b/rust/kernel/time/hrtimer.rs
@@ -498,14 +498,14 @@ unsafe fn start(this: *const Self, expires: <Self::TimerMode as HrTimerMode>::Ex
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



