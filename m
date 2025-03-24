Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA88A1DED76;
	Mon, 24 Mar 2025 21:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850251; cv=none; b=Klbl46Gr8GrfLrpQeQMi5GJd48Vn8kyAfOC1hpuE0ZuMbEDW39Kefe2gjVhgsiv514tzy1Hq1Ngl7odTkypc7DazteWXodPc1AVdGlsvbkz50IsLtxxldtTp57HZScAaMyfivsClG78y5wslMRz5mSHhZyA2aC4hKGXDh0wjfsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850251; c=relaxed/simple;
	bh=o72TB1NTQ+rLH2wrbrpTZbwQ6E6S4RZ1mc9yiTyQiI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kbm3jBZ3oO9iBAxRtUOGgkRVsMFud5u7TKNCvrsgj+DG0rfXLgpEsd9tcUW43tUlq5/+gG/KQDVg/36suPaoj7BDsp+l83LAB/xS3dg0sMmM2tQO646PrSfg0hdIo4runQAX7LdMk792kBAt3nAyL+Z89tyzL147hepAOIfRrC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rmh7hgSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rmh7hgSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E57C4CEDD;
	Mon, 24 Mar 2025 21:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850250;
	bh=o72TB1NTQ+rLH2wrbrpTZbwQ6E6S4RZ1mc9yiTyQiI8=;
	h=From:To:Cc:Subject:Date:From;
	b=rmh7hgShasVbB4t238GyVkm5FFPWr5JdPrbJoUvATk6TCrWuYz81+UU86sS90/q6z
	 3J5reJs6pkbuS5wyGvRKGcF5Aehi0ifT7QmU0TR6JjbvAUdhUy8vGK73VrZTKkU5Bh
	 hLwVjyFREE4acfl/W3n2GvQWKWOVqYBXRp4rlEyNoa181fl6AuBPsWyKSrqJF0E/7Z
	 7XG3vMwj8f4MkhxcfEumTaeX/GoJ7XxYsebubSU4ou7yhc/nVFt+lFGpdT899TvIkE
	 oQkyJzpsO62O3F0LM31COnN+8erv5TngDZwZG3QAAqkJgCTs7sWP7P+Ag3BsqAx6uU
	 vjY8Bu6GraElQ==
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
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 00/10] rust: clean and enable Clippy `doc_markdown` lint
Date: Mon, 24 Mar 2025 22:03:47 +0100
Message-ID: <20250324210359.1199574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is how it would look like -- I am not sure how many false positives
we will get, so I marked the last commit as RFC and perhaps we just want
this lint as an opt-in in e.g. `W=2`.

However, so far, we only got one ("KUnit"), plus a couple others that
are in C side comments that were copied, and thus someone may want to
keep them exactly in sync. So it seems pretty OK so far.

Another question is whether we want to commit to something like the
global list in `.clippy.toml`.

Anyway, please take a look -- the other commits should probably be
picked even if we do not enable the lint.

Thanks!

Miguel Ojeda (10):
  drm/panic: add missing space
  drm/panic: add missing Markdown code span
  rust: alloc: add missing Markdown code spans
  rust: alloc: add missing Markdown code span
  rust: dma: add missing Markdown code span
  rust: of: add missing Markdown code span
  rust: pci: fix docs related to missing Markdown code spans
  rust: platform: fix docs related to missing Markdown code spans
  rust: task: add missing Markdown code spans and intra-doc links
  rust: kbuild: enable `doc_markdown` Clippy lint

 .clippy.toml                        |  4 ++++
 Makefile                            |  1 +
 drivers/gpu/drm/drm_panic_qr.rs     |  4 ++--
 rust/kernel/alloc.rs                |  4 ++--
 rust/kernel/alloc/allocator_test.rs |  2 +-
 rust/kernel/dma.rs                  |  2 +-
 rust/kernel/of.rs                   |  2 +-
 rust/kernel/pci.rs                  | 15 +++++++++------
 rust/kernel/platform.rs             |  9 +++++----
 rust/kernel/task.rs                 |  4 ++--
 10 files changed, 28 insertions(+), 19 deletions(-)

--
2.49.0
