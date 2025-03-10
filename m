Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C4C22D4D0;
	Mon, 10 Mar 2025 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627116; cv=none; b=QYFYZwH6+pQ50ZhR/tNWgr4HBuaLhtgi7JZ+psVsQJydqDbT+jT6J0+RdSkJBR3ZWvBBznAfrWaIchfJ6WDorAL+R0fatpikeT8CLIIEo1SkWXWZuRDYrHmKkCFAu2daaHxhvqHol4uHBejXUz7MCXjJ6lHq33fvWUnYb0Orc2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627116; c=relaxed/simple;
	bh=y6Xiyx2xRHl9jbjl4WsEaYEPZzDJ34r2KQfeAUBYQDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGjeROE1NubLCiikXOXiVdnwDHqa6x9cOaOhlECaT5TgVie6AWy9E+tXPtum4/fWwJXOJgROPtuka2/eqTsUzn9r2reWc2O7+HVlfD9FCEMR33OCV3jU1KkXQKPHFYn4OInEt6tiI4I/73PW4f0PIY9zjy6DX6M0E3a2jzqihfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1j1GuICf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1j1GuICf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7E4C4CEE5;
	Mon, 10 Mar 2025 17:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627116;
	bh=y6Xiyx2xRHl9jbjl4WsEaYEPZzDJ34r2KQfeAUBYQDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1j1GuICfCjMONVPed9XfqhpfQj9WZ3N1BYNYLLJzypl3Cp+ziN18PYbTbWXS2MkDy
	 lnWyNPFTXjY+6o9vDvv6QGGN9iDv9yIkFp5COy76IT2gsWP+C7gz2juphouQwDf2kW
	 5UVTPWfVs/jViMegVnMMGqLiKO/8ePdm/fN0Q6KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gross <tmgross@umich.edu>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 019/269] rust: enable `rustdoc::unescaped_backticks` lint
Date: Mon, 10 Mar 2025 18:02:52 +0100
Message-ID: <20250310170458.475126315@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile      |    3 ++-
 rust/Makefile |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -462,7 +462,8 @@ export rust_common_flags := --edition=20
 			    -Wclippy::undocumented_unsafe_blocks \
 			    -Wclippy::unnecessary_safety_comment \
 			    -Wclippy::unnecessary_safety_doc \
-			    -Wrustdoc::missing_crate_level_docs
+			    -Wrustdoc::missing_crate_level_docs \
+			    -Wrustdoc::unescaped_backticks
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
 		       $(HOSTCFLAGS) -I $(srctree)/scripts/include
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
@@ -98,6 +98,9 @@ rustdoc-macros: private rustc_target_fla
 rustdoc-macros: $(src)/macros/lib.rs FORCE
 	+$(call if_changed,rustdoc)
 
+# Starting with Rust 1.82.0, skipping `-Wrustdoc::unescaped_backticks` should
+# not be needed -- see https://github.com/rust-lang/rust/pull/128307.
+rustdoc-core: private skip_flags = -Wrustdoc::unescaped_backticks
 rustdoc-core: private rustc_target_flags = $(core-cfgs)
 rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs FORCE
 	+$(call if_changed,rustdoc)


