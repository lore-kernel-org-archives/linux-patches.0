Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAE220D503;
	Fri,  7 Mar 2025 22:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387867; cv=none; b=bsr69Ue9lxSfGamf12K2h5vNyhDKzTsiTYqpr5eD7GQersP0laOp2ohpemQsKLLcWZ3DaGvFfSkHFfakBbaePWSZNDFCcuJTKqE+hp1TNOEHPCz3f62YSbnZDW1xyoAP92AKaLzH8RfvBSQ2kIRCG9jZnlJQGBhsgh6+HtxtMgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387867; c=relaxed/simple;
	bh=ZBX3obtCbnClXxU4zqEndprDVU834ZAq6aEFweF8XFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXz4Mz1D2uj1QaYSh5W1oe16xr5XG4fas80+mEzoa7yOym1HGDK0GTy+1kbSD1ALoAXPMIq/0ohCE8w+eqoN+Q8mW4P3Ofjya8hS76rz+Hggn9eNx0eKNYxjpT7t5ZBT0Nao7CJI13Rh/6D/029FPoLGOV4tq1AKAJoEdX5fr/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kj2iDWfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kj2iDWfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E48C4CED1;
	Fri,  7 Mar 2025 22:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387866;
	bh=ZBX3obtCbnClXxU4zqEndprDVU834ZAq6aEFweF8XFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kj2iDWfPsw97Jf9Q+3iGeNgyPogsV29+D0EancQfQyJcDLyZkJo+2oK5JH4+u7eNH
	 rqvwIoduxXlRdOZNFhT3nV8qJyZYF+48D1DncunhK9VOLLhfXMEhBV3Ao9TNvsJNi3
	 77rbi9Aw0SyKZNbiB/Rlo8yGiVoguGQcKYif1i1NoS30GUdN4skateblZvMxI7srap
	 SSiSPob4gzbUH23//O6lVRoj/9Avj2pMwaxWKOX0jzogKEu7M3y4NVS1WZUfHSx8NC
	 0/mwkXsSeT0/vzC/IJpOWIGnRfdNaiwaDLA52kmg7FBSWhRMmabqN6y8KISX5yENaY
	 +7ppMOXG0vfAQ==
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
Subject: [PATCH 6.12.y 11/60] rust: introduce `.clippy.toml`
Date: Fri,  7 Mar 2025 23:49:18 +0100
Message-ID: <20250307225008.779961-12-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 7d56786edcbdf58b6367fd7f01d5861214ad1c95 upstream.

Some Clippy lints can be configured/tweaked. We will use these knobs to
our advantage in later commits.

This is done via a configuration file, `.clippy.toml` [1]. The file is
currently unstable. This may be a problem in the future, but we can adapt
as needed. In addition, we proposed adding Clippy to the Rust CI's RFL
job [2], so we should be able to catch issues pre-merge.

Thus introduce the file.

Link: https://doc.rust-lang.org/clippy/configuration.html [1]
Link: https://github.com/rust-lang/rust/pull/128928 [2]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-12-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 .clippy.toml | 1 +
 .gitignore   | 1 +
 MAINTAINERS  | 1 +
 Makefile     | 3 +++
 4 files changed, 6 insertions(+)
 create mode 100644 .clippy.toml

diff --git a/.clippy.toml b/.clippy.toml
new file mode 100644
index 000000000000..f66554cd5c45
--- /dev/null
+++ b/.clippy.toml
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0
diff --git a/.gitignore b/.gitignore
index 56972adb5031..a61e4778d011 100644
--- a/.gitignore
+++ b/.gitignore
@@ -103,6 +103,7 @@ modules.order
 # We don't want to ignore the following even if they are dot-files
 #
 !.clang-format
+!.clippy.toml
 !.cocciconfig
 !.editorconfig
 !.get_maintainer.ignore
diff --git a/MAINTAINERS b/MAINTAINERS
index 6bb4ec0c162a..f4e08a0851bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20175,6 +20175,7 @@ B:	https://github.com/Rust-for-Linux/linux/issues
 C:	zulip://rust-for-linux.zulipchat.com
 P:	https://rust-for-linux.com/contributing
 T:	git https://github.com/Rust-for-Linux/linux.git rust-next
+F:	.clippy.toml
 F:	Documentation/rust/
 F:	rust/
 F:	samples/rust/
diff --git a/Makefile b/Makefile
index 8748aa1b2f79..43cc17c514dc 100644
--- a/Makefile
+++ b/Makefile
@@ -588,6 +588,9 @@ endif
 # Allows the usage of unstable features in stable compilers.
 export RUSTC_BOOTSTRAP := 1
 
+# Allows finding `.clippy.toml` in out-of-srctree builds.
+export CLIPPY_CONF_DIR := $(srctree)
+
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
 export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN
 export HOSTRUSTC KBUILD_HOSTRUSTFLAGS
-- 
2.48.1

