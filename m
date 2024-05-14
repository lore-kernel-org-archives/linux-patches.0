Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DD212DD9C;
	Tue, 14 May 2024 11:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686677; cv=none; b=CePMUCKYJuDHSlBs2tPByaBDYer7fw0Tdg/JHw861ORYkVhYm3xF+MPWuGmPYISgJJfuEM1qYJBWaUleAfk387Gbk7L+UHneLpi74Fem2LSngjXQn7Gg1TFIRqKpmTh16lAtf+VukPpVgpG2Kh0i+zDktNwvb+BKdelqV1wB7bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686677; c=relaxed/simple;
	bh=2aClJt7OWeUcVf1sEJS+xCJKzTvbK/YyJK7AD9Oedj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlRJBsoFivJVVVMNw4agho3ChRuUViaesR+c/cjZEP1s019LyrAJFJE7LYoPPqjoo4VvWUiefHKolNfAXyZQ3Urdm9aYp6PGtiasWXzfyTF03PxJP44QGlPChyQEXVR7eJdNOsMC31ZfzY6ys8VJy3oP3QrUu32pRfCMgZ1dLt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G27ak1TZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G27ak1TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D912C2BD10;
	Tue, 14 May 2024 11:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686676;
	bh=2aClJt7OWeUcVf1sEJS+xCJKzTvbK/YyJK7AD9Oedj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G27ak1TZeVtZ/ACrqwTv5g99ycMh6ZUWIoB6iWjfkjF8UDbRqiSGnN/nLhx1DIspi
	 0aBNo/ShyQy4PGQYxYQ4NgnpA4Dr92HcQ8yjpTdeNFyKMcaCoEUVNFbJgOv9CCVcPv
	 nRGIGDjrOU2Oa/bNF5zwKfoMk3v3oQPccaTftYjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <andrea.righi@canonical.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Eric Curtin <ecurtin@redhat.com>,
	Neal Gompa <neal@gompa.dev>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 189/236] btf, scripts: rust: drop is_rust_module.sh
Date: Tue, 14 May 2024 12:19:11 +0200
Message-ID: <20240514101027.538054836@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <andrea.righi@canonical.com>

commit 41bdc6decda074afc4d8f8ba44c69b08d0e9aff6 upstream.

With commit c1177979af9c ("btf, scripts: Exclude Rust CUs with pahole")
we are now able to use pahole directly to identify Rust compilation
units (CUs) and exclude them from generating BTF debugging information
(when DEBUG_INFO_BTF is enabled).

And if pahole doesn't support the --lang-exclude flag, we can't enable
both RUST and DEBUG_INFO_BTF at the same time.

So, in any case, the script is_rust_module.sh is just redundant and we
can drop it.

NOTE: we may also be able to drop the "Rust loadable module" mark
inside Rust modules, but it seems safer to keep it for now to make sure
we are not breaking any external tool that may potentially rely on it.

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Eric Curtin <ecurtin@redhat.com>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Acked-by: Daniel Xu <dxu@dxuuu.xyz>
Link: https://lore.kernel.org/r/20230704052136.155445-1-andrea.righi@canonical.com
[ Picked the `Reviewed-by`s from the old patch too. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/macros/module.rs     |    2 +-
 scripts/Makefile.modfinal |    2 --
 scripts/is_rust_module.sh |   16 ----------------
 3 files changed, 1 insertion(+), 19 deletions(-)
 delete mode 100755 scripts/is_rust_module.sh

--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -179,7 +179,7 @@ pub(crate) fn module(ts: TokenStream) ->
             /// Used by the printing macros, e.g. [`info!`].
             const __LOG_PREFIX: &[u8] = b\"{name}\\0\";
 
-            /// The \"Rust loadable module\" mark, for `scripts/is_rust_module.sh`.
+            /// The \"Rust loadable module\" mark.
             //
             // This may be best done another way later on, e.g. as a new modinfo
             // key or a new section. For the moment, keep it simple.
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -41,8 +41,6 @@ quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ ! -f vmlinux ]; then					\
 		printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
-	elif [ -n "$(CONFIG_RUST)" ] && $(srctree)/scripts/is_rust_module.sh $@; then 		\
-		printf "Skipping BTF generation for %s because it's a Rust module\n" $@ 1>&2; \
 	else								\
 		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J $(PAHOLE_FLAGS) --btf_base vmlinux $@; \
 		$(RESOLVE_BTFIDS) -b vmlinux $@; 			\
--- a/scripts/is_rust_module.sh
+++ /dev/null
@@ -1,16 +0,0 @@
-#!/bin/sh
-# SPDX-License-Identifier: GPL-2.0
-#
-# is_rust_module.sh module.ko
-#
-# Returns `0` if `module.ko` is a Rust module, `1` otherwise.
-
-set -e
-
-# Using the `16_` prefix ensures other symbols with the same substring
-# are not picked up (even if it would be unlikely). The last part is
-# used just in case LLVM decides to use the `.` suffix.
-#
-# In the future, checking for the `.comment` section may be another
-# option, see https://github.com/rust-lang/rust/pull/97550.
-${NM} "$*" | grep -qE '^[0-9a-fA-F]+ [Rr] _R[^[:space:]]+16___IS_RUST_MODULE[^[:space:]]*$'


