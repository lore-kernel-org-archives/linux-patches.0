Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A2E22FF5F;
	Wed, 16 Apr 2025 11:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744802711; cv=none; b=KQ8u2cf1Kp6q4Nw+9n78qy+mzCS3E0nuqnYBDuR/l7iWT0aN0MmhhLRPawMyg87mikSRbc7jFuSEh6f6VqcTGrwKUSkZWn8kobWUFWCdkazW2JXMjvOzrTjs5/lDOFbLEZete4fXR1NhQVfjhPOmH8UkWFoM5RIR8c1srtN9kzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744802711; c=relaxed/simple;
	bh=4zl+NTSe5fsPwYoKWjImnIMJcXW9wXRvHApi2vuDsSA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o2b4+00WpSry0jvwcWwNscBp1tUJF1m9ZcH9Y6SyQRYRNlMdXv+AzA1k1hgcOt/QwekDVWPG5QYNHvkAtG5nEfOaNzisuCozxHKRBvilUJVWvqu1ewHeMt5i05xFnLKPoNZ/vifMj4ugSS+31Rnl1NAke/ICQ/pwnsc6i/0z58Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NHqzac6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NHqzac6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375D8C4CEE2;
	Wed, 16 Apr 2025 11:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744802710;
	bh=4zl+NTSe5fsPwYoKWjImnIMJcXW9wXRvHApi2vuDsSA=;
	h=From:To:Cc:Subject:Date:From;
	b=NHqzac6/YHElitNytgcMBg28UkNA4x63gmqLfQ1UEACK7bFRSgCGUK/zCjMi+2tPK
	 /AyJa7bN5D1fpZZYb03qmartqYIEQoAWLy+pQ21e0ebPuNyd/oTzdM5iLJ9bi+T6FT
	 HR5bRnTanvgMVF/za2a020GRZeq6jIxojv4l/0AwEyKQRJHFXEypAl07v+WVA2lpjo
	 ZoD4NZhMeU+98g/bBwWfS8jqf+QrHe8dbXw28tPNoADvtzKTC6UJ3SRUXiue3uATlN
	 wkFqRI6HIToj4Oa91tjruoCXGVj9PspUE1ckN2KTrthmFb8D917uWecZfHOXqOBUV0
	 wVSF2Ek5nUXAA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] docs: rust: explain that `///` vs. `//` applies to private items too
Date: Wed, 16 Apr 2025 13:24:54 +0200
Message-ID: <20250416112454.2503872-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sometimes kernel developers use `//` for documenting private items,
since those do not get rendered at the moment.

That is reasonable, but the intention behind `///` (and `//!`) vs. `//`
is to convey the distinction between documentation and other kinds of
comments, such as implementation details or TODOs.

It also increases consistency with the public items and thus e.g. allows
to change visibility of an item with less changed involved.

It is not just useful for human readers, but also tooling. For instance,
we may want to eventually generate documentation for private items
(perhaps as a toggle in the HTML UI). On top of that, `rustdoc` lints
as usual for those, too, so we may want to do it even if we do not use
the result.

Thus document this explicitly.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/rust-for-linux/CANiq72n_C7exSOMe5yf-7jKKnhSCv+a9QcD=OE2B_Q2UFBL3Xg@mail.gmail.com/
Link: https://github.com/Rust-for-Linux/linux/issues/1157
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/coding-guidelines.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
index 27f2a7bb5a4a..6c6c51b4cf46 100644
--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -85,6 +85,18 @@ written after the documentation, e.g.:
 	    // ...
 	}
 
+This applies to both public and private items. This increases consistency with
+public items, allows changes to visibility with less changes involved and will
+allow us to potentially generate the documentation for private items as well.
+In other words, if documentation is written for a private item, then ``///``
+should still be used. For instance:
+
+.. code-block:: rust
+
+	/// My private function.
+	// TODO: ...
+	fn f() {}
+
 One special kind of comments are the ``// SAFETY:`` comments. These must appear
 before every ``unsafe`` block, and they explain why the code inside the block is
 correct/sound, i.e. why it cannot trigger undefined behavior in any case, e.g.:

base-commit: c1b4071ec3a6a594df6c49bf8f04a60a88072525
-- 
2.49.0

