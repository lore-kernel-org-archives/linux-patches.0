Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6D518BC36;
	Fri,  7 Mar 2025 22:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387858; cv=none; b=fqCg1ImDTxHeSRKBURXhP4VQogz88HEFcekEraYU8+tWTxAe3mHUJGJxdRQabqqgOYNBe9bC59UoJ04Yy6H/QAZ4Xn8eGxj0h5V9Ja9L6m8mVruJwOOwj14BaIUQj0K6fQrIZPGWJccKRxFaLawLDjZICE0MdLXIh9soNdhCb6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387858; c=relaxed/simple;
	bh=hlJUrbHWYtR8GsTiBAxxGvIGVPWWZ4T2LwlBy7q1IFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FalPJm7+XH88Jq2nGfxAIzRaMq9xyO2W9+r2IvMN3BdPbtq+WSEyWdpIOgMjkHBjjDQVlh5qpsyWiwnSE7afnerC0MxBl4Nsj1LcRJtTrqM69zDi47q6v1DotPj5is5dJQQQs8z5mo5Wupsm1Fldg7jvEnYgnZt2HKR1ujoZgz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGJ+i1ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGJ+i1ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4D5C4CED1;
	Fri,  7 Mar 2025 22:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387858;
	bh=hlJUrbHWYtR8GsTiBAxxGvIGVPWWZ4T2LwlBy7q1IFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGJ+i1llSSpjBgs7CZog5RCj0RjTb0lkjLfp/cdj8yoDbVamyQ55POLNQ3VVZ9r4k
	 3cueEuihStALCgPOgVQBoA9VLp0GYpQmZuwY/Q9GnNBG/el5gLqNKevWHHpQbMNQqX
	 8wGOYUfViSkjYP6zBNYECIrcAchZz8mBoTUbREwreoer6ZkG6m9g9OOL2E0b3XfzMb
	 c6arNwF6fPM6Dq8AHFynhJsk1Dy3LzKwkmzAZYmXkeJZ1662zC4MEpx54h++fbAeY2
	 xTegfh1+DFtdfka31rY/6kK0xIlW5Fnqs99OEpZZdfE5reJKVjlmSGkGXZ+39ATdMk
	 jJytKnyykczkw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 08/60] rust: enable `rustdoc::unescaped_backticks` lint
Date: Fri,  7 Mar 2025 23:49:15 +0100
Message-ID: <20250307225008.779961-9-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit bef83245f5ed434932aaf07f890142b576dc5d85 upstream.

In Rust 1.71.0, `rustdoc` added the `unescaped_backticks` lint, which
detects what are typically typos in Markdown formatting regarding inline
code [1], e.g. from the Rust standard library:

    /// ... to `deref`/`deref_mut`` must ...

    /// ... use [`from_mut`]`. Specifically, ...

It does not seem to have almost any false positives, from the experience
of enabling it in the Rust standard library [2], which will be checked
starting with Rust 1.82.0. The maintainers also confirmed it is ready
to be used.

Thus enable it.

Link: https://doc.rust-lang.org/rustdoc/lints.html#unescaped_backticks [1]
Link: https://github.com/rust-lang/rust/pull/128307 [2]
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-9-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile      | 3 ++-
 rust/Makefile | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7433df4d22f9..8748aa1b2f79 100644
--- a/Makefile
+++ b/Makefile
@@ -462,7 +462,8 @@ export rust_common_flags := --edition=2021 \
 			    -Wclippy::undocumented_unsafe_blocks \
 			    -Wclippy::unnecessary_safety_comment \
 			    -Wclippy::unnecessary_safety_doc \
-			    -Wrustdoc::missing_crate_level_docs
+			    -Wrustdoc::missing_crate_level_docs \
+			    -Wrustdoc::unescaped_backticks
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
 		       $(HOSTCFLAGS) -I $(srctree)/scripts/include
diff --git a/rust/Makefile b/rust/Makefile
index 45779a064fa4..b16456ac5d77 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -61,7 +61,7 @@ alloc-cfgs = \
 quiet_cmd_rustdoc = RUSTDOC $(if $(rustdoc_host),H, ) $<
       cmd_rustdoc = \
 	OBJTREE=$(abspath $(objtree)) \
-	$(RUSTDOC) $(if $(rustdoc_host),$(rust_common_flags),$(rust_flags)) \
+	$(RUSTDOC) $(filter-out $(skip_flags),$(if $(rustdoc_host),$(rust_common_flags),$(rust_flags))) \
 		$(rustc_target_flags) -L$(objtree)/$(obj) \
 		-Zunstable-options --generate-link-to-definition \
 		--output $(rustdoc_output) \
@@ -98,6 +98,9 @@ rustdoc-macros: private rustc_target_flags = --crate-type proc-macro \
 rustdoc-macros: $(src)/macros/lib.rs FORCE
 	+$(call if_changed,rustdoc)
 
+# Starting with Rust 1.82.0, skipping `-Wrustdoc::unescaped_backticks` should
+# not be needed -- see https://github.com/rust-lang/rust/pull/128307.
+rustdoc-core: private skip_flags = -Wrustdoc::unescaped_backticks
 rustdoc-core: private rustc_target_flags = $(core-cfgs)
 rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs FORCE
 	+$(call if_changed,rustdoc)
-- 
2.48.1

