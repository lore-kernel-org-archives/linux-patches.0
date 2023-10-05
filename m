Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A617134B6;
	Thu,  5 Oct 2023 21:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8J9bDmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B725DC433C7;
	Thu,  5 Oct 2023 21:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696539982;
	bh=YfqyS9WxVzb/A7U5Hv72w/JQ1t032hVcAjgCKY/OijA=;
	h=From:To:Cc:Subject:Date:From;
	b=J8J9bDmXq6Qpu3XMq7WeDO2QKIQPlKmVeJwicR9dX8W6S12PoJQLIua4hcsU3a9Ni
	 CcGuc3y+FUO8X1Dbtc2u+EkfDy6QUz17GTzit12/ni+1FdmdV9Wtxi7vvticZHzsWX
	 GKlCTGSKRfwbcWzp8najiDtNjrIaRO+EcrS9Ok0KAHsenaPuNfdCp+ULU18IqWN6GA
	 L+eMRqG9KeuSHGFg06o1R6Q+dV3YYFsQT3DThxT+IPa35CzGhfu5LaVUTLFfEBUOHc
	 g12rZxNGyNsIFNC5oU5Y+VayW8apsnc8CbUB/AtMdr0z1tUoDH01bYTv2lICYqTAEE
	 S5HSUN28p4kyw==
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
Subject: [PATCH 0/3] Rust 1.73.0 upgrade
Date: Thu,  5 Oct 2023 23:05:52 +0200
Message-ID: <20231005210556.466856-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the next upgrade to the Rust toolchain since the initial Rust
merge, from 1.72.1 to 1.73.0 (i.e. the latest, released today).

Please see the main patch message for a long explanation of the upgrade,
the policy for future upgrades and some indications on how to easily
review this.

The series is based on `rust-next`.

Miguel Ojeda (3):
  rust: task: remove redundant explicit link
  rust: print: use explicit link in documentation
  rust: upgrade to Rust 1.73.0

 Documentation/process/changes.rst |  2 +-
 rust/alloc/alloc.rs               | 22 --------------
 rust/alloc/boxed.rs               | 48 ++++++++++++++++++++-----------
 rust/alloc/lib.rs                 |  5 ++--
 rust/alloc/raw_vec.rs             | 30 ++++++++++++-------
 rust/alloc/vec/mod.rs             |  4 +--
 rust/alloc/vec/spec_extend.rs     |  8 +++---
 rust/compiler_builtins.rs         |  1 +
 rust/kernel/print.rs              |  1 +
 rust/kernel/task.rs               |  2 +-
 scripts/min-tool-version.sh       |  2 +-
 11 files changed, 65 insertions(+), 60 deletions(-)


base-commit: b2516f7af9d238ebc391bdbdae01ac9528f1109e
--
2.42.0
