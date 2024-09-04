Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6014D156871;
	Wed,  4 Sep 2024 20:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482722; cv=none; b=W9kdyr/KbW6BXtAZo09yjK/4qQ1J37tgopguoN+3GuJ0+8v/0wZ9TYWjxMDSpMvRQ+q1GcY67z8i+oIN8lOr927EUZwNTXQub92nYnQEr7oz0tHczf8wIAbseMfmmjTYFz7DXcM+Gj5Y1b0wV5RZP/NAejDjrBp17dLx2oFvYVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482722; c=relaxed/simple;
	bh=c3kGndlFIp+qZPOCF675bBzcX634NpzyVuX7M0WNkek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPGBlQON2wMBM4WcGKLVMqCZw9LTf6rtlJp44X0UgElTxFqHpCii8HjW9IQ586PyMhExL9NI4kpCCrGzJFVZGzreWyxQoyKpYMdjrBXrdybCVXirs+7/I8QKdw0VbmZuPbdsSZKox3ViNJeihOUX8vMwM8PXthbXlttpAO+1Nfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qsaii+C2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qsaii+C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF31C4CEC2;
	Wed,  4 Sep 2024 20:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482722;
	bh=c3kGndlFIp+qZPOCF675bBzcX634NpzyVuX7M0WNkek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsaii+C2vqxbx7WMAcWvZb7r4tMqSSnquP7CblVaw6t8f+BVJJMCOC5s++1LwrGQ2
	 W6Ue/ZZ4YIdBpaS2bwkB2R32HGIfrix/tQZ9uBNhEP1ecXEys3DdsLl4yv12GpXyNW
	 QZdwPlVZJ9tQxDkxryhjDdUVF1eyu6CHSjRbmHU9QLFQrEG0FThJUwX8WggCG4F7uC
	 b6JTgWzQZfTFiRjurZ+RvJPTMeXY8dVFykJW1p0FLKREjfZogVO1+Rrtgpp/PqlUQa
	 pLRvSSYhE75d5f5CWpHGTfrfK03MLLk9ieozVHlO6upgLvGSKmxPSbHkqVBYd7qGfZ
	 wIn3O4rtHZ4zg==
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
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 11/19] rust: introduce `.clippy.toml`
Date: Wed,  4 Sep 2024 22:43:39 +0200
Message-ID: <20240904204347.168520-12-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some Clippy lints can be configured/tweaked. We will use these knobs to
our advantage in later commits.

This is done via a configuration file, `.clippy.toml` [1]. The file is
currently unstable. This may be a problem in the future, but we can adapt
as needed. In addition, we proposed adding Clippy to the Rust CI's RFL
job [2], so we should be able to catch issues pre-merge.

Thus introduce the file.

Link: https://doc.rust-lang.org/clippy/configuration.html [1]
Link: https://github.com/rust-lang/rust/pull/128928 [2]
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
index 7902adf4f7f1..907c782962d2 100644
--- a/.gitignore
+++ b/.gitignore
@@ -102,6 +102,7 @@ modules.order
 # We don't want to ignore the following even if they are dot-files
 #
 !.clang-format
+!.clippy.toml
 !.cocciconfig
 !.editorconfig
 !.get_maintainer.ignore
diff --git a/MAINTAINERS b/MAINTAINERS
index 77b395476a80..cb63f1f97556 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19922,6 +19922,7 @@ B:	https://github.com/Rust-for-Linux/linux/issues
 C:	zulip://rust-for-linux.zulipchat.com
 P:	https://rust-for-linux.com/contributing
 T:	git https://github.com/Rust-for-Linux/linux.git rust-next
+F:	.clippy.toml
 F:	Documentation/rust/
 F:	rust/
 F:	samples/rust/
diff --git a/Makefile b/Makefile
index fc66bac4b4f1..234ab97de796 100644
--- a/Makefile
+++ b/Makefile
@@ -590,6 +590,9 @@ endif
 # Allows the usage of unstable features in stable compilers.
 export RUSTC_BOOTSTRAP := 1
 
+# Allows finding `.clippy.toml` in out-of-srctree builds.
+export CLIPPY_CONF_DIR := $(srctree)
+
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
 export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN
 export HOSTRUSTC KBUILD_HOSTRUSTFLAGS
-- 
2.46.0

