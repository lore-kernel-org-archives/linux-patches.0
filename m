Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022397;
	b=rvoycp+uZd8NYqlbVECyoE+vuNkD0cidA6HqJ03LlRivTjL9DkNCEeYwAAModxbCo8NJ
	 tI3mwA0rlu4vmndP8A6guQUNGaG08s/Hz7l6qxBAwiZMrZbhrzkC/BUjPn/ukb7fYRWxp
	 UTSOoqA42lYznZ7z86qSdF691Hc5lrxVFA4/IjHyDejIzVy3BXvBxBAtlwhFtEEhxkWJW
	 tDVMxxfon43899V88RyHNhl946973ZPAunk8njBHspkDk/NnoIwZNoCrCc92V5/il8DWO
	 mMA7BYK6ctjhs0MG/hJz2TDLPLK3M3u+A1qHDsAioq0XbUE77W2/6o/t8FflFXyr83w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DfxWGwl+qYuoOd7qeCDUauFcz3VhM0FcqRHisv7vtcs=;
	b=yiIZMGPdjxxnEQPbzq7ocfNUJeYd6ZEzl5Tvs6aj9qxzH4E3OIhj+7X1QC7jy6i2PDNa
	 ri0YcGMvJMAfZDFgWSEP4tJ4Ygs6I0NzZC8Y0bNEIVjSs2JSieU0M1ifvln6Z8Gfu77jH
	 SHlgLR5gyTSMX8cdVKlgGmU1Wwobw57NmM8HFa0yB7x+wncPFyqITJ8qboukpcOM6Ob5r
	 TiW+gjBKWVhCGMYp6yWdpVgqXhsKvEQnnDaEWVUwAjvQbkhrsbZBcYPa3UvlthT+xdeCY
	 sq6NR4mxh0bVOwoeCLCGAN/GfAvoQNd1fV1VTQX8XWfnqhPekTwEgMpmwY1RIql0iXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJ3rbVkm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649FD606A320;
	Wed, 18 Nov 2026 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJ3rbVkm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4E51F000C4;
	Wed, 18 Nov 2026 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022397;
	bh=DfxWGwl+qYuoOd7qeCDUauFcz3VhM0FcqRHisv7vtcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJ3rbVkmp1xBc0p2dd9RIh8hO5DoqJayQGb6EAKJt60I/bQr1FJh8Qp/WcSxzUNGe
	 ZExN/ybaie7Vv51TYyCUKf9q4Q6VZR0ePjP/7Q2t/Mojq36BcGlmqfxW1CmZBBqsII
	 KbfgswHPClle/Sj/uTcZCUHAc37ObHTuYcevcWuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.3 2647/2651] rust: bindings: derive Zeroable for bindgens opaque array wrappers
Date: Wed, 18 Nov 2026 16:04:47 +0100
Message-ID: <20261118150419.366830431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Sasha Levin <sashal@kernel.org>

commit 57d916a3eb765ee0577d269bb2ac1bdf3a7a7f40 upstream.

bindgen 0.73 emits the blob of some opaque types, such as ones aligned
to more than 4 bytes, as a `__BindgenOpaqueArray` or
`__BindgenOpaqueArray<align>` newtype instead of a plain array. The
newtype only derives `PartialEq`, `Eq`, `Copy`, `Clone`, `Debug` and
`Hash`, and the `MaybeZeroable` custom derive does not reach it, so a
struct that embeds such an opaque type is no longer `Zeroable`.

`spinlock` is opaque (see rust/bindgen_parameters), and with lockdep its
blob becomes a `__BindgenOpaqueArray8<[u8; 72]>`. Commit 71ec3c7d6db8
("blk-mq: quiesce a queue that joins a quiesced tag set") added a
`spinlock_t` to `struct blk_mq_tag_set`, so an allmodconfig build with
bindgen 0.73 now fails:

  error[E0277]: the trait bound `bindings::__BindgenOpaqueArray8<[u8; 72]>: pin_init::Zeroable` is not satisfied
    --> rust/kernel/block/mq/tag_set.rs:41:49

Which wrappers exist depends on the bindgen version and on the opaque
types of the configuration, so they cannot be covered by unconditional
impls in rust/bindings/lib.rs like `__BindgenBitfieldUnit` is. Derive
`Zeroable` for each wrapper in the generated bindings instead. The
pattern allows for the spacing of bindgen's output when rustfmt is not
available.

Fixes: 71ec3c7d6db8 ("blk-mq: quiesce a queue that joins a quiesced tag set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/rust-for-linux/20261030223702.GA1673281@ax162/
Link: https://patch.msgid.link/20261031152846.746656-1-sashal@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -514,13 +514,20 @@ endif
 bindgen_c_flags_final = $(bindgen_c_flags_lto) -fno-builtin -D__BINDGEN__
 
 # `--rust-target` points to our minimum supported Rust version.
+#
+# `bindgen` 0.73 emits the blob of some opaque types as a
+# `__BindgenOpaqueArray[<align>]` newtype, which the custom derives do not
+# reach. Derive `Zeroable` for those wrappers, so that a struct embedding such
+# an opaque type (e.g. `spinlock_t` with lockdep) is still `Zeroable`. The
+# pattern also matches the unformatted output used when `rustfmt` is missing.
 quiet_cmd_bindgen = BINDGEN $@
       cmd_bindgen = \
 	$(BINDGEN) $< $(bindgen_target_flags) --rust-target 1.85 \
 		--use-core --with-derive-default --ctypes-prefix ffi --no-layout-tests \
 		--no-debug '.*' --enable-function-attribute-detection \
 		-o $@ -- $(bindgen_c_flags_final) -DMODULE \
-		$(bindgen_target_cflags) $(bindgen_target_extra)
+		$(bindgen_target_cflags) $(bindgen_target_extra); \
+	sed -Ei 's/pub struct __BindgenOpaqueArray[0-9]* *< *T *> *\( *pub T *\) *;/$(pound)[derive(pin_init::Zeroable)] &/g' $@
 
 $(obj)/bindings/bindings_generated.rs: private bindgen_target_flags = \
     $(shell grep -Ev '^#|^$$' $(src)/bindgen_parameters)


