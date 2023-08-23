Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B513AD42;
	Wed, 23 Aug 2023 16:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFB7C433C8;
	Wed, 23 Aug 2023 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692806578;
	bh=0nMVgMfKCQ86W6q1+R6vMRrHNacAhbvlPwG6j1rqB4M=;
	h=From:To:Cc:Subject:Date:From;
	b=tjqh6EsDE3XpVEaxkkjfQsXeaEAxMSK8vGd2BcyuBnFu/NXxy05h4yxVHmik3m8aT
	 4KdCNVz4sGEJ0eIIZR6Ur3A37ZXKBCj4+J0RM4dopcp7hl+BS37MYuT+F2MEzyBLbM
	 oPqD6BAE2+kcPYN69oTRxCpytyuXxVM86Z507avpPk7rX92f67rBGTcC14xFntB6hp
	 FzrTI68dHRg2b+TvhzDfxr4pSkIA4Yy8aRUPn9yI/cQjcZYvpZWBGDjRIjikqWSKGo
	 9vsBMtI/t2DUZ/TaJU19YotCYPOwrJIReAWB+VQKvuC2tObHmQluSiHMGzKt/no4fe
	 kHjyqU5yKwvaw==
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
Subject: [PATCH 0/2] Rust 1.72.0 upgrade
Date: Wed, 23 Aug 2023 18:02:41 +0200
Message-ID: <20230823160244.188033-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the third upgrade to the Rust toolchain since the initial Rust
merge, from 1.71.1 to 1.72.0 (i.e. the latest, to be released tomorrow).

Please see the main patch message for a long explanation of the upgrade,
the policy for future upgrades and some indications on how to easily
review this.

The series is based on `rust-next`.

Miguel Ojeda (2):
  rust: arc: add explicit `drop()` around `Box::from_raw()`
  rust: upgrade to Rust 1.72.0

 Documentation/process/changes.rst |   2 +-
 rust/alloc/alloc.rs               |   9 +-
 rust/alloc/boxed.rs               |  10 +-
 rust/alloc/lib.rs                 |  10 +-
 rust/alloc/vec/drain_filter.rs    | 199 ------------------------------
 rust/alloc/vec/extract_if.rs      | 115 +++++++++++++++++
 rust/alloc/vec/mod.rs             | 106 ++++++++--------
 rust/kernel/sync/arc.rs           |   2 +-
 scripts/min-tool-version.sh       |   2 +-
 9 files changed, 188 insertions(+), 267 deletions(-)
 delete mode 100644 rust/alloc/vec/drain_filter.rs
 create mode 100644 rust/alloc/vec/extract_if.rs


base-commit: 4af84c6a85c63bec24611e46bb3de2c0a6602a51
-- 
2.42.0

