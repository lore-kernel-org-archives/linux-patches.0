Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F32213D8A8;
	Fri, 17 May 2024 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715965587; cv=none; b=M44MfnwCNkF+l8H9jIK8TzggDRYx0XJM0TnVvTUrbDqiLl1bssmCURKYATUlrJOTTkAMQaT4l2nqgnJK/mEsVMASaTs8A37XRq+1imEpQ/ptR6XfzAV6iqdMQSQyUCjeAqvGcd63VbYp5+BN6JR8RAciCYObPhqdISSgLuNWsBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715965587; c=relaxed/simple;
	bh=d/iGbHWjoWyhaPNdJOqLEjIUxOpDm9so2jUuJZJzu2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TlYcqPjwHwUY3BPDDvBlABxLP2vIsAX5c70Mj/ia+FPcUyE2OX7zStVQ94sds0S7QOhUEoSDKcnkh8/IUagWuINAKw4T1h3ZugxuW9eznHYWwl8ECU3RLZASjepHDMxmoIAAS50/rnzN+5yjZOJKNl0tke18zx/Ue286EZ/Fxfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kN1Y0UuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kN1Y0UuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F007C2BD10;
	Fri, 17 May 2024 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715965586;
	bh=d/iGbHWjoWyhaPNdJOqLEjIUxOpDm9so2jUuJZJzu2Q=;
	h=From:To:Cc:Subject:Date:From;
	b=kN1Y0UuH04ZwTXw78nZc2j7OWDOkVAh1V8+M07v5xX8rXGFAwXboWN+LOFXsVBZE2
	 OX4gggZQoG6yMWMH7iswxvn0RX1bbAxDy+j3L6xspb70ItJRTFQChJW79H36LlqUnC
	 j+70ITQqVIM4xqVzpEqenPq54HTeaIkMWGNTlkhfx9T8Rv3w7l+eFdinjBGMShf+Q/
	 cNYw3cysnFvYOF/ihYqZkNukuSvCHUxyX8QZ7SpuF3oDC1KJOEyHHY9PVGfGgTMXqy
	 P263L7jLJzUxF9iVssXkCQp97/oN0A7jIAqfbkc995EWqjmp7YlnRzhQPmVnj9s3rq
	 FsWdNP7s6dqXQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	llvm@lists.linux.dev,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH] docs: rust: introduce the new kernel.org LLVM+Rust toolchains
Date: Fri, 17 May 2024 19:06:15 +0200
Message-ID: <20240517170615.377786-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

These combined LLVM+Rust toolchains are now available, thanks to Nathan
Chancellor (ClangBuiltLinux).

Thus introduce them in the Rust Quick Start guide.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/quick-start.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index cc3f11e0d441..6fe69a601134 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -16,6 +16,13 @@ under names like ``rustc``, ``rust-src``, ``rust-bindgen``, etc. However,
 at the time of writing, they are likely not to be recent enough unless
 the distribution tracks the latest releases.
 
+Prebuilt stable versions of LLVM+Rust are provided on `kernel.org
+<https://kernel.org/pub/tools/llvm/rust/>`_. These are the same slim and fast
+LLVM toolchains from :ref:`Getting LLVM <getting_llvm>` with versions of Rust
+added to them that Rust for Linux supports, depending on the Linux version. Two
+sets are provided: the "latest LLVM" and "matching LLVM" (please see the link
+for more information).
+
 To easily check whether the requirements are met, the following target
 can be used::
 

base-commit: 97ab3e8eec0ce79d9e265e6c9e4c480492180409
-- 
2.45.1

