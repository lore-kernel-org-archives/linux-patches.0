Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FF937522C;
	Sat, 28 Feb 2026 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301554; cv=none; b=Ak9ImyDwMrQXEaap3Qh3SEJcO74n3nOUp0+Sk+r9CU+S5QoX9SIlaCSGtAuLFGSoyUnAlqh9MrQ7RBW1ioShMNXWqgqzUt5i4i/wm3K8dmqDu6VS11vEopzrrdLJ+d9bko5a71KbS1E0gLrKQG0RLnB5j5c5PCqhVI1DtPwlJdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301554; c=relaxed/simple;
	bh=UpHK7ThSWIhPnYMP/Z92BaU0tpTQc2iiqOjeZogl/gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akeKv5BIt+k/1Pt6UVfsQizlfO4tTXmxSx0TNrzQ8oBrfHnyTXeER+IjeBiWgUvcAHnzJsC3XkDwtxqJxAKQfPLEq9o5FDp8TCm8PB9ZU08409Ryl/7u9JD8QZKfL2x6AtsrHXH6DSg1ttIMsKVhsTOp74kFoXMPPQjVFgFGji8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/Nstkil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/Nstkil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EE1C116D0;
	Sat, 28 Feb 2026 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301554;
	bh=UpHK7ThSWIhPnYMP/Z92BaU0tpTQc2iiqOjeZogl/gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/Nstkil5jZ44l0UIlszSxKxqA8wRrdvcmdiys3NrdWhCjDT0UM4Mk2ubo7F0svgT
	 2rp3NMtgFCTumDfS/8xcRrn4QODbD4ae+sv38sX9Dm/EveWv/Ox66f+BAsCtssDD3U
	 atS5BuieSvNmUgRZoGmbcEJgu80PRdw7kwptdLdVzoaybl7V/azLvvCe8nPKVz90eO
	 C9z3Wbl6Lr0eVIbpEbFUDJhxuISmF0oQw4exn7aprz7c6K0TGt7lE495534Wxr0bN5
	 hH+yebmVYznBG/JufuOvmzgKLAiLLzn3Ehcy2VDC6BYLZH/gz1ZCuG4Q8BrcuJGDKl
	 IsW667qrzOSkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Benno Lossin <lossin@kernel.org>,
	stable@vger.kernel.org,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 738/752] rust: pin-init: replace clippy `expect` with `allow`
Date: Sat, 28 Feb 2026 12:47:29 -0500
Message-ID: <20260228174750.1542406-738-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Benno Lossin <lossin@kernel.org>

[ Upstream commit a58b8764aed9648357b1c5b6368c9943ba33b7f9 ]

`clippy` has changed behavior in [1] (Rust 1.95) where it no longer
warns about the `let_and_return` lint when a comment is placed between
the let binding and the return expression. Nightly thus fails to build,
because the expectation is no longer fulfilled.

Thus replace the expectation with an `allow`.

[ The errors were:

      error: this lint expectation is unfulfilled
          --> rust/pin-init/src/lib.rs:1279:10
           |
      1279 | #[expect(clippy::let_and_return)]
           |          ^^^^^^^^^^^^^^^^^^^^^^
           |
           = note: `-D unfulfilled-lint-expectations` implied by `-D warnings`
           = help: to override `-D warnings` add `#[allow(unfulfilled_lint_expectations)]`

      error: this lint expectation is unfulfilled
          --> rust/pin-init/src/lib.rs:1295:10
           |
      1295 | #[expect(clippy::let_and_return)]
           |          ^^^^^^^^^^^^^^^^^^^^^^

    - Miguel ]

Link: https://github.com/rust-lang/rust-clippy/pull/16461 [1]
Signed-off-by: Benno Lossin <lossin@kernel.org>
Cc: stable@vger.kernel.org # Needed in 6.18.y and later.
Link: https://patch.msgid.link/20260215132232.1549861-1-lossin@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/pin-init/src/lib.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/pin-init/src/lib.rs b/rust/pin-init/src/lib.rs
index dd553212836e0..0128808579973 100644
--- a/rust/pin-init/src/lib.rs
+++ b/rust/pin-init/src/lib.rs
@@ -1276,13 +1276,13 @@ pub const unsafe fn init_from_closure<T: ?Sized, E>(
 ///
 /// - `*mut U` must be castable to `*mut T` and any value of type `T` written through such a
 ///   pointer must result in a valid `U`.
-#[expect(clippy::let_and_return)]
 pub const unsafe fn cast_pin_init<T, U, E>(init: impl PinInit<T, E>) -> impl PinInit<U, E> {
     // SAFETY: initialization delegated to a valid initializer. Cast is valid by function safety
     // requirements.
     let res = unsafe { pin_init_from_closure(|ptr: *mut U| init.__pinned_init(ptr.cast::<T>())) };
     // FIXME: remove the let statement once the nightly-MSRV allows it (1.78 otherwise encounters a
     // cycle when computing the type returned by this function)
+    #[allow(clippy::let_and_return)]
     res
 }
 
@@ -1292,13 +1292,13 @@ pub const unsafe fn cast_pin_init<T, U, E>(init: impl PinInit<T, E>) -> impl Pin
 ///
 /// - `*mut U` must be castable to `*mut T` and any value of type `T` written through such a
 ///   pointer must result in a valid `U`.
-#[expect(clippy::let_and_return)]
 pub const unsafe fn cast_init<T, U, E>(init: impl Init<T, E>) -> impl Init<U, E> {
     // SAFETY: initialization delegated to a valid initializer. Cast is valid by function safety
     // requirements.
     let res = unsafe { init_from_closure(|ptr: *mut U| init.__init(ptr.cast::<T>())) };
     // FIXME: remove the let statement once the nightly-MSRV allows it (1.78 otherwise encounters a
     // cycle when computing the type returned by this function)
+    #[allow(clippy::let_and_return)]
     res
 }
 
-- 
2.51.0

