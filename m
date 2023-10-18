Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A86637151;
	Wed, 18 Oct 2023 16:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9CbGLM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919F0C433C8;
	Wed, 18 Oct 2023 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697645380;
	bh=NyxodQYdJN0bXaAwMa3qhqruplmUOckpXetLVK/mv+U=;
	h=From:To:Cc:Subject:Date:From;
	b=Z9CbGLM/xDgsJI+RiGEhkR5IrBIVA64HzatG1ofgD+AuTv2gqNlE0kqg16r/Trjml
	 jQq0sGq/kL99bDSxXBM35tr6NoPr1/Jt3YLOjN2L/aA2Gnp80EWF1myFxMg52P83Ie
	 +I0Emft9mPi98sXvu9/3n2bqwAZUBWtj7kXwZjACj5NzS52Aa8hIGiwf4UI1FC/61Y
	 0dNmxtR4mJgxZdpraU0Eionu9ocgLYTv50XxFxgGyjJjpEpPj6R/HF2RkeSjfojMHJ
	 wYQvgZagwrQctELg/zCV0Rgr3bGqjo2NKELiph0xLGwSLZB45wwm7yJRS2g1R/cst0
	 Bw5sKw0UekQgQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-doc@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] docs: rust: add "The Rust experiment" section
Date: Wed, 18 Oct 2023 18:09:22 +0200
Message-ID: <20231018160922.1018962-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clarify that the Rust experiment is still going on to avoid
confusion for both kernel maintainers and end users.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Andrew: I did not add a `Suggested-by` just in case, but please let me know
if you want it, of course.

 Documentation/rust/index.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/rust/index.rst b/Documentation/rust/index.rst
index e599be2cec9b..aaed36af15ce 100644
--- a/Documentation/rust/index.rst
+++ b/Documentation/rust/index.rst
@@ -6,6 +6,23 @@ Rust
 Documentation related to Rust within the kernel. To start using Rust
 in the kernel, please read the quick-start.rst guide.

+
+The Rust experiment
+-------------------
+
+The Rust support was merged in v6.1 into mainline in order to help in
+determining whether Rust as a language was suitable for the kernel, i.e. worth
+the tradeoffs.
+
+Currently, the Rust support is primarily intended for kernel developers and
+maintainers interested in the Rust support, so that they can start working on
+abstractions and drivers, as well as helping the development of infrastructure
+and tools.
+
+In particular, if you are an end user, please note that there are no in-tree
+drivers/modules suitable or intended for production use yet.
+
+
 .. only:: rustdoc and html

 	You can also browse `rustdoc documentation <rustdoc/kernel/index.html>`_.

base-commit: 94f6f0550c625fab1f373bb86a6669b45e9748b3
--
2.42.0
