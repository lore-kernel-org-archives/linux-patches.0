Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20CF1DF721;
	Mon, 24 Mar 2025 21:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850265; cv=none; b=nWoGXDxLgswImxNP3JI1BWmo7yYklLDt6pdgCfR9AW9YFGyV24zusiUTpa5I/KGj+Id+5Ra+/san3jhp+f38ayAhCQmutGZ1qkZBXMDC2DQKWapvwZQUDaL/SLjOkrrrof9915FqSvGUucuGOmKBJdU61u5hJh1MAS9R6jerdHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850265; c=relaxed/simple;
	bh=Q/RrBja5M4/phEPdp46qnyHArU8edGqutVl3iHroFBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHx80DSh0z9yr7/gSo6m3iugupGW6ygo10jLKbaKbddtx9h7ZMnoxll6rOqDoVFYE97wqJmeUDgKowhD5/oeQyyvWRG0X3TbzBuKNue95tBozGVUZpiu+mBBCPJlPMuGhofk8E7m10TUNTPM2x6M6E+u1BnDyTgZC2JHhgqwTf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=el92AXz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="el92AXz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45779C4CEE4;
	Mon, 24 Mar 2025 21:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850264;
	bh=Q/RrBja5M4/phEPdp46qnyHArU8edGqutVl3iHroFBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=el92AXz2vT1aNLjOMCb25p8Ywf8K27FY8t+MJXfGb8Sj0IKzxf4QNo1DXAURZbLIL
	 xmMS8lqx5S8Ta5msjA+7qc0fvuHjeBH/AOK9lq/wKYDNB5f94KBuqzCQYbOruIyk52
	 ++69zOp+jo6BDwgwKLfLaw851Z1AsORnk+uYmhOzgKSqkg9L7ntMp+0imdO/S6nIJ3
	 VrP42naeKWGRkEWoJsWtsLd0Rrgxwadjo9D0g7CT0yHPK2Iev/s7bpWnO1HP5GqgKa
	 ov4vi1dOtDYOEmoqJtMle5AyAvY7bAVekpsVrDpPfrVrn73MjCqYY4x9iTSgzN0qo5
	 ktOkoaTzvGUsg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Wedson Almeida Filho <walmeida@microsoft.com>
Subject: [PATCH 03/10] rust: alloc: add missing Markdown code spans
Date: Mon, 24 Mar 2025 22:03:50 +0100
Message-ID: <20250324210359.1199574-4-ojeda@kernel.org>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing Markdown code spans.

This was found using the Clippy `doc_markdown` lint, which we may want
to enable.

Fixes: b6a006e21b82 ("rust: alloc: introduce allocation flags")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index fc9c9c41cd79..a2c49e5494d3 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -94,10 +94,10 @@ pub mod flags {
     ///
     /// A lower watermark is applied to allow access to "atomic reserves". The current
     /// implementation doesn't support NMI and few other strict non-preemptive contexts (e.g.
-    /// raw_spin_lock). The same applies to [`GFP_NOWAIT`].
+    /// `raw_spin_lock`). The same applies to [`GFP_NOWAIT`].
     pub const GFP_ATOMIC: Flags = Flags(bindings::GFP_ATOMIC);
 
-    /// Typical for kernel-internal allocations. The caller requires ZONE_NORMAL or a lower zone
+    /// Typical for kernel-internal allocations. The caller requires `ZONE_NORMAL` or a lower zone
     /// for direct access but can direct reclaim.
     pub const GFP_KERNEL: Flags = Flags(bindings::GFP_KERNEL);
 
-- 
2.49.0

