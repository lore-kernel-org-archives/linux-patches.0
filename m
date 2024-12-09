Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C11C19A288;
	Mon,  9 Dec 2024 21:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733779557; cv=none; b=XiphJ3qIykhY4u5a1e6+MivtKGc4D3RuJ0DPFJvZQfaHF250BkNJ+7niknDRi1dwfNWBlDR/nQ7Ym6x0sOuOB7zbcA1GChdfkHCdLsqGWAnjyPAaq8RNhgP1+KvBGFbZL0Mo7QHm8OqRyUCZBcWXY+RH0iNgBj3xpOYv5tx4jT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733779557; c=relaxed/simple;
	bh=IgOP2GAy7Xl+KBtgFiCSBdEWbWEt3lp2v9OABCv/c/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KpjqSJNBHyX0Movt9InFfgJPkY1coEchknogM8EIpv+Jxp+z5wq6bAl1edqKjVNPbjUx0dyo6JuhiOVtHvnV7qNOMCtDIdKp/okJqTMKr/GqXrmNRLM7VT1Rr+Up991RSAifeT3ebCWv4O8jWyjvqBmhQeZaainVk5Q7JciJMzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6G48uLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6G48uLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BF9C4CEE1;
	Mon,  9 Dec 2024 21:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733779557;
	bh=IgOP2GAy7Xl+KBtgFiCSBdEWbWEt3lp2v9OABCv/c/A=;
	h=From:To:Cc:Subject:Date:From;
	b=Q6G48uLCNrTxVSxhI0A5GkCxKyXsxvboG2S26UtMxm755Kw7ZJVj0rhq1q4l6rBwk
	 NidictF/SaXgDubbOMjHFb0SGzgdL4f0XXXK/GzJuuz+8M5ZXyTq7eVzGUdIoUiLk1
	 8JxA8/v6unHzbteEVPzX3yLQzIinELf7+SSv+BTlvE7aVoLS/7TBvoQAL45tkR+2tf
	 RwwuBaM4jw8ouiAyfEtcQHQqACsQXE+IP2mPMypePlsuM0lcxU41e3Aa8HGQi6Yvbf
	 7GN18s3cPTWUiamANO5wyiN0pCsC9QZL0cnnMeCGqk970ov41Fb8u9QruTJBZ6Wi+5
	 /16jZ+cnANVUA==
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
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: document `bindgen` 0.71.0 regression
Date: Mon,  9 Dec 2024 22:25:44 +0100
Message-ID: <20241209212544.1977065-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`bindgen` 0.71.0 regressed [1] on the "`--version` requires header"
issue which appared in 0.69.0 first [2] and was fixed in 0.69.1. It has
been fixed again in 0.71.1 [3].

Thus document it so that, when we upgrade the minimum past 0.69.0 in the
future, we do not forget that we cannot remove the workaround until we
arrive at 0.71.1 at least.

Link: https://github.com/rust-lang/rust-bindgen/issues/3039 [1]
Link: https://github.com/rust-lang/rust-bindgen/issues/2677 [2]
Link: https://github.com/rust-lang/rust-bindgen/blob/main/CHANGELOG.md#v0711-2024-12-09 [3]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 init/Kconfig                 | 6 ++++--
 scripts/rust_is_available.sh | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index a20e6efd3f0f..e8d2b5128f87 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1989,8 +1989,10 @@ config BINDGEN_VERSION_TEXT
 	string
 	depends on RUST
 	# The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
-	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
-	# the minimum version is upgraded past that (0.69.1 already fixed the issue).
+	# (https://github.com/rust-lang/rust-bindgen/pull/2678) and 0.71.0
+	# (https://github.com/rust-lang/rust-bindgen/pull/3040). It can be removed
+	# when the minimum version is upgraded past the latter (0.69.1 and 0.71.1
+	# both fixed the issue).
 	default "$(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/null)"
 
 #
diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 93c0ef7fb3fb..d2323de0692c 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -123,8 +123,10 @@ fi
 # Non-stable and distributions' versions may have a version suffix, e.g. `-dev`.
 #
 # The dummy parameter `workaround-for-0.69.0` is required to support 0.69.0
-# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be removed when
-# the minimum version is upgraded past that (0.69.1 already fixed the issue).
+# (https://github.com/rust-lang/rust-bindgen/pull/2678) and 0.71.0
+# (https://github.com/rust-lang/rust-bindgen/pull/3040). It can be removed when
+# the minimum version is upgraded past the latter (0.69.1 and 0.71.1 both fixed
+# the issue).
 rust_bindings_generator_output=$( \
 	LC_ALL=C "$BINDGEN" --version workaround-for-0.69.0 2>/dev/null
 ) || rust_bindings_generator_code=$?

base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
2.47.1

