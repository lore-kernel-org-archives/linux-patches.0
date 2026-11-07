Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061383;
	b=GlZ7lUwAfdLS2VcjduvD3iP80/Cr725OqB9vj1asFLwk5481/zdHOSZ6g0fPXFdlkfsT
	 XfdXQNnNBxxGxkhWYjxYlLtr3RR09oWgLecQEX3ShZLSJaI2pMDF9GYQsG306pWzXlDPP
	 9FU3L4pF43kP+iitULTO+EfU6uqLjVFQyQHYw0LXzbfo3No1dcHpx6ZD799ApFxavvWq8
	 0Cyeyk5Qqh5s+Edw72cxxVqP7RNda4G2NXLRRNQkVV0XI7ODPQnWR4t79FlkL7E+MLvZh
	 kwdHmq+LdGG+2qA3VMiczHOnAAj3QyC7t+lhjTIPAWPbdfiosMxI0X1vGwTUAwNvU5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CSiyihMS2dXXmsSrlfTW3hjC+Rc+nZxIBA5UH7TZFRk=;
	b=lIMJM7rm+Zr/vkx8oVpqFFca6PSUjSa5n6c17YZHmEU0jxZJpDMl3ZkqVLisqNY6XGiC
	 XbYiPBjVpXQZ4jtkB7swlppwakSpE0sM436iUARXAlm3x8jNZI47YeNk4VeeK8pFGLvvG
	 MKZBCHKDpcNY5RVthyeq3vAAA+yUzFugom2+brCARkJDDAODHcGnADowSTNS41KdqZYyu
	 oD5owcM9JNmr7ngL35apVevkXm+0DHZgQbx5ePw2gR0wQZwzrgnO/wFIhftRMrzXAcszC
	 GMf8JTZpCA7lMADt9QVBcyBPyy+E8szHkvl7vrtbMb3VRTMD2N7wrWafB1uVMhQAiwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9TpOUET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA371606A33A;
	Sat,  7 Nov 2026 14:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9TpOUET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8989F1F008A1;
	Sat,  7 Nov 2026 14:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061382;
	bh=CSiyihMS2dXXmsSrlfTW3hjC+Rc+nZxIBA5UH7TZFRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9TpOUETSNdgONELZe4EmJasYR7p66U2TZt1Lv3IdUyA0OknpK8osCs1OqKasezsO
	 MqLlV26v+Ic0yNVo3DFNMQt/LA5a2HAAdLDxm2u/k+bJRkodzYppZnRpQAcaEUdMa6
	 d8zGAi9+Ws3o9XRpymm9V0heVKS7uRlinMddG7CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0505/1536] rust: allow `clippy::as_underscore` in the generated bindings
Date: Sat,  7 Nov 2026 08:42:01 -0500
Message-ID: <20261107135011.630471081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit 2ac74c6db40adaa29c50cbb281ae9a6f63de18e1 ]

A CLIPPY=1 build emitted about 15000 `as _` conversion warnings, all of
them in bindgen's generated output and none in hand-written code.

[ The lint messages look like:

    error: using `as _` conversion
         --> rust/bindings/bindings_generated.rs:18947:9
          |
    18947 |         self._bitfield_1.get_const::<0usize, 16u8>() as u32 as _
          |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-
          |                                                                |
          |                                                                help: consider giving the type explicitly: `u32`
          |
          = help: for further information visit https://rust-lang.github.io/rust-clippy/rust-1.98.0/index.html#as_underscore
          = note: `-D clippy::as-underscore` implied by `-D warnings`
          = help: to override `-D warnings` add `#[allow(clippy::as_underscore)]`

    - Miguel ]

bindgen 0.73 returns each bitfield read through a trailing `as _`, and
0.72 returns it through a transmute, which the lint ignores. The
bindings and uapi crates allow `clippy::all` over the generated code.
That group does not cover `clippy::as_underscore`, a restriction lint.

Allow `clippy::as_underscore` by name in the bindings and uapi crates.

Assisted-by: LLM
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Link: https://patch.msgid.link/20260906215822.1201022-1-jhubbard@nvidia.com
Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
[ Removed CI sentence. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
[ sashal: Added only the as_underscore lint allow, omitting the unrelated cast_lossless/ptr_as_ptr/ref_as_ptr context lines missing from this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/bindings/lib.rs | 1 +
 rust/uapi/lib.rs     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/rust/bindings/lib.rs b/rust/bindings/lib.rs
index dfba8d7d419d6..9bb1ce8d039dc 100644
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -25,6 +25,7 @@
 )]
 
 #[allow(dead_code)]
+#[allow(clippy::as_underscore)]
 #[allow(clippy::undocumented_unsafe_blocks)]
 #[cfg_attr(not(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES), allow(unknown_lints))]
 #[allow(unnecessary_transmutes)]
diff --git a/rust/uapi/lib.rs b/rust/uapi/lib.rs
index 34287bda2b910..abdc0e1755466 100644
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -14,6 +14,7 @@
 #![cfg_attr(test, allow(unsafe_op_in_unsafe_fn))]
 #![allow(
     clippy::all,
+    clippy::as_underscore,
     clippy::undocumented_unsafe_blocks,
     dead_code,
     missing_docs,
-- 
2.53.0



