Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A4F20E6;
	Sat, 17 Aug 2024 07:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723878609; cv=none; b=QaOnqOcSJMT2IK+A8AqoWNf603iq85tT/lGn/6XpidVK9XGBOhulCkuCyY70+Szcdz+aL48DlXurxDX52c/Ij44FVbyTgxr4t77nZCKVYZqaKk7hAxUShP5A/2zCaGG6UTbm/IiBwvLu48l8wZ2KhvNA5DJF8tl7Vpl4TbUh5GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723878609; c=relaxed/simple;
	bh=tIqCjtm+/HuN2gETnbefaJy4X5JoZecAjfCwKAX8KZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JKGAW2Ozz3vi6QZdJ4QVMebmZakCnWUxKH3gq0YkZ2ElTmLwXtneJtX8H04blwhdBw4XR0gkoLyDWfThAGGwPUhxI3RtQnybzb4Uxk1F81FHPc0cfnLbx+YPfaz4i6/u5tHdmwJyGzA/zN/3JHcVp/KbREmdBgMqhtrJMLRzFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojTOqX66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojTOqX66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32824C116B1;
	Sat, 17 Aug 2024 07:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723878608;
	bh=tIqCjtm+/HuN2gETnbefaJy4X5JoZecAjfCwKAX8KZQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ojTOqX66Z8jB8mmsfZqdgbj8FuEDxLkczwk27xkChaO7KbKMLY50m0xV6lNNjh3UA
	 WfadxEb7KQrZB0dW1pIrH6Zi4d7B3dNPRUD7b2apezmSrL0qDj7oUdwa7P3hLAQNeg
	 X4SAClVqyKRBpN+w9gn7BjWWvhf4DljsK5xsh7arFoBs+XXQo+hOFJAFVEFGJaf7um
	 6Pm41d7WRqZGG1N7BPmmNkrWZ6jQNztqQivjW3r7/RTMD3+etTMz0o4rfW+F5sNK+A
	 gnoZdsmTfiljMCMcNSpBKEHxXYrXUUSw/+wpDbapwAZQMwef931TWevZYR5zBWb+ke
	 d2f7bG8JFxM0g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Ali Bektas <bektasali@protonmail.com>,
	Lukas Wirth <lukastw97@gmail.com>
Subject: [RFC PATCH] rust: use the hidden variant of `rust-project.json`
Date: Sat, 17 Aug 2024 09:09:55 +0200
Message-ID: <20240817070955.75717-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Very soon after we requested it [1], `rust-analyzer` added support for
`.rust-project.json` [2], i.e. the hidden variant of `.rust-project.json`.

While this is only a (tiny) issue for kernel developers that use Rust
(i.e. so far a very small number compared to the total), the file is not
really something most kernel developers need to see, care or modify while
working, so it is not really needed to show it by default in listings.

It also follows the pattern of other files that are not directly related
to the project (unlike e.g. a `Kconfig` file).

Thus migrate to it.

Cc: Ali Bektas <bektasali@protonmail.com>
Cc: Lukas Wirth <lukastw97@gmail.com>
Link: https://github.com/rust-lang/rust-analyzer/issues/17816 [1]
Link: https://github.com/rust-lang/rust-analyzer/pull/17818 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
This is a patch for the future -- we need to wait until most Rust kernel
developers are using a new enough version of rust-analyzer. Thanks Ali
& Lukas!

 .gitignore                         | 2 +-
 Documentation/rust/quick-start.rst | 2 +-
 Makefile                           | 8 ++++----
 rust/Makefile                      | 2 +-
 scripts/generate_rust_analyzer.py  | 2 +-
 scripts/remove-stale-files         | 2 ++
 6 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/.gitignore b/.gitignore
index 7902adf4f7f1..a79fc2a71c62 100644
--- a/.gitignore
+++ b/.gitignore
@@ -176,4 +176,4 @@ x509.genkey
 sphinx_*/

 # Rust analyzer configuration
-/rust-project.json
+/.rust-project.json
diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index d06a36106cd4..02f9dee6d236 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -259,7 +259,7 @@ The `rust-analyzer <https://rust-analyzer.github.io/>`_ language server can
 be used with many editors to enable syntax highlighting, completion, go to
 definition, and other features.

-``rust-analyzer`` needs a configuration file, ``rust-project.json``, which
+``rust-analyzer`` needs a configuration file, ``.rust-project.json``, which
 can be generated by the ``rust-analyzer`` Make target::

 	make LLVM=1 rust-analyzer
diff --git a/Makefile b/Makefile
index 0a364e34f50b..9ef90963330c 100644
--- a/Makefile
+++ b/Makefile
@@ -1483,7 +1483,7 @@ endif # CONFIG_MODULES
 CLEAN_FILES += vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
 	       compile_commands.json rust/test \
-	       rust-project.json .vmlinux.objs .vmlinux.export.c
+	       .rust-project.json .vmlinux.objs .vmlinux.export.c

 # Directories & files removed with 'make mrproper'
 MRPROPER_FILES += include/config include/generated          \
@@ -1621,7 +1621,7 @@ help:
 	@echo  '		    (requires kernel .config)'
 	@echo  '  rusttest        - Runs the Rust tests'
 	@echo  '                    (requires kernel .config; downloads external repos)'
-	@echo  '  rust-analyzer	  - Generate rust-project.json rust-analyzer support file'
+	@echo  '  rust-analyzer	  - Generate .rust-project.json rust-analyzer support file'
 	@echo  '		    (requires kernel .config)'
 	@echo  '  dir/file.[os]   - Build specified target only'
 	@echo  '  dir/file.rsi    - Build macro expanded source, similar to C preprocessing.'
@@ -1809,7 +1809,7 @@ help:
 	@echo  '  modules         - default target, build the module(s)'
 	@echo  '  modules_install - install the module'
 	@echo  '  clean           - remove generated files in module directory only'
-	@echo  '  rust-analyzer	  - generate rust-project.json rust-analyzer support file'
+	@echo  '  rust-analyzer	  - generate .rust-project.json rust-analyzer support file'
 	@echo  ''

 ifndef CONFIG_MODULES
@@ -1958,7 +1958,7 @@ quiet_cmd_tags = GEN     $@
 tags TAGS cscope gtags: FORCE
 	$(call cmd,tags)

-# Generate rust-project.json (a file that describes the structure of non-Cargo
+# Generate .rust-project.json (a file that describes the structure of non-Cargo
 # Rust projects) for rust-analyzer (an implementation of the Language Server
 # Protocol).
 PHONY += rust-analyzer
diff --git a/rust/Makefile b/rust/Makefile
index 1f10f92737f2..311675e97332 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -351,7 +351,7 @@ rust-analyzer:
 		--cfgs='core=$(core-cfgs)' --cfgs='alloc=$(alloc-cfgs)' \
 		$(realpath $(srctree)) $(realpath $(objtree)) \
 		$(RUST_LIB_SRC) $(KBUILD_EXTMOD) > \
-		$(if $(KBUILD_EXTMOD),$(extmod_prefix),$(objtree))/rust-project.json
+		$(if $(KBUILD_EXTMOD),$(extmod_prefix),$(objtree))/.rust-project.json

 redirect-intrinsics = \
 	__addsf3 __eqsf2 __gesf2 __lesf2 __ltsf2 __mulsf3 __nesf2 __unordsf2 \
diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index f270c7b0cf34..8b3a063b7c34 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -1,6 +1,6 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
-"""generate_rust_analyzer - Generates the `rust-project.json` file for `rust-analyzer`.
+"""generate_rust_analyzer - Generates the `.rust-project.json` file for `rust-analyzer`.
 """

 import argparse
diff --git a/scripts/remove-stale-files b/scripts/remove-stale-files
index f38d26b78c2a..1e8c3278a133 100755
--- a/scripts/remove-stale-files
+++ b/scripts/remove-stale-files
@@ -21,3 +21,5 @@ set -e
 # then will be really dead and removed from the code base entirely.

 rm -f *.spec
+
+rm -f rust-project.json

base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
--
2.46.0
