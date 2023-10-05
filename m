Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D9134B6;
	Thu,  5 Oct 2023 21:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ss+OX7Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291AAC433C9;
	Thu,  5 Oct 2023 21:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696539986;
	bh=qOUKIAiTh0O8Uv4d8SH+C2EBhe15SUCFuHgeJkj8nGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ss+OX7ShDShHRvKvbDoKbBv/UKoDuGOabQmFEhc/WAfNzMKrUpyNgS/LDvY+b09EU
	 KW0Z4EiStk/ehgmYwEmMg+UEYP6ZkMdZoz7KQ1JUd7ppKyooRLt43dmOnm+sOLlAj4
	 sgvL1a8hNEa/+pK0cRwinEzC2pCb4UfEuWtSQX66f6Wnimv9yBijvpG8PH/EF4zIcY
	 QwnfixNMVLViZVk3fOnu1ipkzndYZhNriCNI0hgjuTYJca2Wwvl/NHSS0TSLqweOIq
	 IRHLDR/2v+2RZLm00kg81qulD/gZltGyNvUBbiS4dpAXKbILQtuEeMFLIN3rgMXlXz
	 69WgsBYgdspXw==
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
	patches@lists.linux.dev
Subject: [PATCH 1/3] rust: task: remove redundant explicit link
Date: Thu,  5 Oct 2023 23:05:53 +0200
Message-ID: <20231005210556.466856-2-ojeda@kernel.org>
In-Reply-To: <20231005210556.466856-1-ojeda@kernel.org>
References: <20231005210556.466856-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.73.0, `rustdoc` detects redundant explicit
links with its new lint `redundant_explicit_links` [1]:

    error: redundant explicit link target
      --> rust/kernel/task.rs:85:21
       |
    85 |     /// [`current`](crate::current) macro because it is safe.
       |          ---------  ^^^^^^^^^^^^^^ explicit target is redundant
       |          |
       |          because label contains path that resolves to same destination
       |
       = note: when a link's destination is not specified,
               the label is used to resolve intra-doc links
       = note: `-D rustdoc::redundant-explicit-links` implied by `-D warnings`
    help: remove explicit link target
       |
    85 |     /// [`current`] macro because it is safe.

In order to avoid the warning in the compiler upgrade commit,
make it an intra-doc link as the tool suggests.

Link: https://github.com/rust-lang/rust/pull/113167 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/task.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 7eda15e5f1b3..b2299bc7ac1f 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -82,7 +82,7 @@ impl Task {
     /// Returns a task reference for the currently executing task/thread.
     ///
     /// The recommended way to get the current task/thread is to use the
-    /// [`current`](crate::current) macro because it is safe.
+    /// [`current`] macro because it is safe.
     ///
     /// # Safety
     ///
-- 
2.42.0

