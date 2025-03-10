Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6080E17C225;
	Mon, 10 Mar 2025 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627125; cv=none; b=Tcs8GkwRIg1D2+Yf06qP+rNycdQP5ht8ujMm1u5WGEFAFZ6qsa9hOvsSpWSRLoE6aDJ0igYKRaVuAVun3yBtpRKpR8kIeUKW5Ot4Xk7IWN9CklP6L6SkS8VwvtUQ/WfnXDf63bvmFjMZJZvIyt4V1/tNswHQY4NpVizYuNFaepI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627125; c=relaxed/simple;
	bh=gMC8zxHhylH1oAqJChWuodSqVrxslUVHG8LtSLA8L4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQL6F+6evpQXt3WdOI1dLduUOS4NmKNqBFqELh+0QlxAFNFyalrLwJdA8KACjy+aFH9+RmHTD13Ha21uX3o8JswUyfVxX7fVx5dFHhJ8YM2SUQDV3u7PDfaGPUdKzfS5axSJRiEFf+ZybDFDiSQ4Em44s2sxVyxJLkIDwiTplwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7vPXaEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7vPXaEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741FFC4CEE5;
	Mon, 10 Mar 2025 17:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627124;
	bh=gMC8zxHhylH1oAqJChWuodSqVrxslUVHG8LtSLA8L4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7vPXaEHiEVqKif2+f3KS5vFE6EYiaROhCkfY2Ev3kFNkCLi9kI8QUsZjgl8HFan6
	 zDvjD5B3OvnUyNsw4XxRFYvtUkCcMTr2doQcwF1IdYzhISn+Rr4mi33ws7tftEv67T
	 vi3wEe7K3RFUvpeAJco/oC3AlBZewgFFJyoo5VYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 022/269] rust: introduce `.clippy.toml`
Date: Mon, 10 Mar 2025 18:02:55 +0100
Message-ID: <20250310170458.594728659@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .clippy.toml |    1 +
 .gitignore   |    1 +
 MAINTAINERS  |    1 +
 Makefile     |    3 +++
 4 files changed, 6 insertions(+)
 create mode 100644 .clippy.toml

--- /dev/null
+++ b/.clippy.toml
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0
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
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20175,6 +20175,7 @@ B:	https://github.com/Rust-for-Linux/lin
 C:	zulip://rust-for-linux.zulipchat.com
 P:	https://rust-for-linux.com/contributing
 T:	git https://github.com/Rust-for-Linux/linux.git rust-next
+F:	.clippy.toml
 F:	Documentation/rust/
 F:	rust/
 F:	samples/rust/
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


