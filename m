Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5328B16F85A;
	Mon,  1 Jul 2024 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859050; cv=none; b=XfyUYuDGlpPku4BTUvnt7NFCjJjj12lL2PhZdvQI9b3hppu1+BiUat8QN9AbRx/NWiPuKk/JDUUsCTw3s4SjdFrEVLBSzB3dG8m7NAnsqGFg7SRvlGfDkYQD2RBpz9DzwS9hOXWeS5GGOqoGzS9d6nlBcYC9yn823FXi58fTtLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859050; c=relaxed/simple;
	bh=zVhKqiDyQv5ZxblaWNctxIc8aVp6zkdLOh1twpo4mPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewKxrdfHzF1xPAHDySVWwRvZqJ04l3JXHU/hW7p6eMGUR7f/pyeAIyqL9HgnobG1vNXlamfo0DVkfacauj9gCtdJSk6m5migApTqQ7hQQp0+IslAVNhpU6/tMtoF6/vgslkw3KhKDcbSTjwJrt43h4nRAauDMLKOiU9uPUCC08Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmxXY9T0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmxXY9T0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CE6C32781;
	Mon,  1 Jul 2024 18:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859049;
	bh=zVhKqiDyQv5ZxblaWNctxIc8aVp6zkdLOh1twpo4mPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmxXY9T0gVgM1GjHGIB2bLLksN4SLVL2FgPfNS44HUpwo/dMA3cWl+dw1Y4UoIUY9
	 Ue7OCEz7UGPdjCcNu+ncK7oJ+MVOruRi1H56W1uuwYpCCe33kaMCKTNMP3gtxpOTj0
	 T6W1BXuvUWu7GHtHccpwQkY5rA1Km3hO4MibGHW277k/zISGw1xJ2gK5aEzAGdtq1M
	 BzkZvcP06SmB2Z+fdYj/h7a3tP0U+VtafkaF0IMZBkpf7r3B7x1Q2ALzprwoyG4JTk
	 pdUF+w4zRCs3s2OYemzeCh4V4cR4BJD5oabI2akzw69EEYJ2/yfWbIe3eDpB7y34yG
	 J4Yhs+2V7YBAA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH 10/13] rust: start supporting several `bindgen` versions
Date: Mon,  1 Jul 2024 20:36:20 +0200
Message-ID: <20240701183625.665574-11-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With both the workaround for `bindgen` 0.69.0 and the warning about
0.66.0 and 0.66.1 in place, start supporting several `bindgen` versions,
like it was done for the Rust compiler in a previous patch.

All other versions, including the latest 0.69.4, build without errors.

The `bindgen` project, like Rust, has also agreed to have the kernel
in their CI [1] -- thanks! This should help both projects: `bindgen`
will be able to detect early issues like those mentioned above, and the
kernel will be very likely build with new releases (at least for the
basic configuration being tested).

Link: https://github.com/rust-lang/rust-bindgen/pull/2851 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/quick-start.rst | 5 +++--
 scripts/rust_is_available.sh       | 8 --------
 scripts/rust_is_available_test.py  | 5 -----
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index f411cad4cc02..f624b913ff89 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -100,9 +100,10 @@ bindgen
 *******
 
 The bindings to the C side of the kernel are generated at build time using
-the ``bindgen`` tool. A particular version is required.
+the ``bindgen`` tool.
 
-Install it via (note that this will download and build the tool from source)::
+Install it, for instance, via (note that this will download and build the tool
+from source)::
 
 	cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen-cli
 
diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index cfda8157dce9..537accc73334 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -161,14 +161,6 @@ if [ "$rust_bindings_generator_cversion" -lt "$rust_bindings_generator_min_cvers
 	echo >&2 "***"
 	exit 1
 fi
-if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cversion" ]; then
-	echo >&2 "***"
-	echo >&2 "*** Rust bindings generator '$BINDGEN' is too new. This may or may not work."
-	echo >&2 "***   Your version:     $rust_bindings_generator_version"
-	echo >&2 "***   Expected version: $rust_bindings_generator_min_version"
-	echo >&2 "***"
-	warning=1
-fi
 if [ "$rust_bindings_generator_cversion" -eq 6600 ] || [ "$rust_bindings_generator_cversion" -eq 6601 ]; then
 	echo >&2 "***"
 	echo >&2 "*** Rust bindings generator '$BINDGEN' versions 0.66.0 and 0.66.1 may not"
diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_available_test.py
index f5ebafff002c..927cd8bbc09c 100755
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -231,11 +231,6 @@ else:
         result = self.run_script(self.Expected.FAILURE, { "BINDGEN": bindgen })
         self.assertIn(f"Rust bindings generator '{bindgen}' is too old.", result.stderr)
 
-    def test_bindgen_new_version(self):
-        bindgen = self.generate_bindgen_version("bindgen 0.999.0")
-        result = self.run_script(self.Expected.SUCCESS_WITH_WARNINGS, { "BINDGEN": bindgen })
-        self.assertIn(f"Rust bindings generator '{bindgen}' is too new. This may or may not work.", result.stderr)
-
     def test_bindgen_bad_version_0_66_0_and_0_66_1(self):
         for version in ("0.66.0", "0.66.1"):
             with self.subTest(version=version):
-- 
2.45.2

