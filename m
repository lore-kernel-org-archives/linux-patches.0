Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6911FCCF8;
	Wed, 29 Oct 2025 07:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761723247; cv=none; b=EXqVPKH+Yg//Z+wHMzCfQEPTEe3pHV+6Pf523Z+HT5EGsKr8//ZwhM0x4C836XKcej2WWFA+rcEeD0dbBesO7/eCOYAOlA+ByTTe6s01T52Kdd/urEy/hFDZy0qE1eT0BPJqufqxQ+Ctvi3WneeCkjEw7Bsq4SANpQwy8UX45O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761723247; c=relaxed/simple;
	bh=rPVXNSnHbFEqc+rbhI90PKGIvNDmtiRn79W6euhNbIA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MG7tgTPYDNdPgpGsIhfMobJ/EY3Moqj2kbKVAyCzCOt1ACqZX7Z9NN+gjbKH81rxiWh7DqpGW7/G46AKTnB6M6ECIzt5PU/MrOXSK7sZWcEaaU1+VF1iD7qkpctYZ11GKiRMx48PGJscxcHTonX5LCu9V31e0KbdO+/fqzWB4MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REt+mfPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REt+mfPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D501C4CEF7;
	Wed, 29 Oct 2025 07:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761723246;
	bh=rPVXNSnHbFEqc+rbhI90PKGIvNDmtiRn79W6euhNbIA=;
	h=From:To:Cc:Subject:Date:From;
	b=REt+mfPXw7P1BvgL+O5YeApv4CsjfApJkh5KttQNGyKj7CpPuhZ6511W5fU38S8LM
	 5ukp+mapAg3r07bXqptG5T2Dx7Say3cMBUPMLxb0gInxbSA2wqR1wzOOalP3joZZ9C
	 VIgICwvMiSetVWCtqZWII4/JP38DYc1XCtpIMQDSDqcu1d3GsBXFzw7MDnH5t5a9Sn
	 w+4iKEYCdW5d64wSdolASZzMkOVna898gx4OctbYXY/o7MvTlhy9lpjyjLRKwnCjdG
	 B+mFW5m5nu/juweg754CUqo9y1B1XJTZm6SxQvfbfrm8vI3WtlYCKIxUx5U5Wx+TC7
	 MkT2R8kEa347w==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] rust: condvar: fix broken intra-doc link
Date: Wed, 29 Oct 2025 08:33:44 +0100
Message-ID: <20251029073344.349341-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future move of pin-init to `syn` uncovers the following broken
intra-doc link:

    error: unresolved link to `crate::pin_init`
      --> rust/kernel/sync/condvar.rs:39:40
       |
    39 | /// instances is with the [`pin_init`](crate::pin_init!) and [`new_condvar`] macros.
       |                                        ^^^^^^^^^^^^^^^^ no item named `pin_init` in module `kernel`
       |
       = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`

Currently, when rendered, the link points to a literal `crate::pin_init!`
URL.

Thus fix it.

Cc: stable@vger.kernel.org
Fixes: 129e97be8e28 ("rust: pin-init: fix documentation links")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/sync/condvar.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/sync/condvar.rs b/rust/kernel/sync/condvar.rs
index c6ec64295c9f..aa5b9a7a726d 100644
--- a/rust/kernel/sync/condvar.rs
+++ b/rust/kernel/sync/condvar.rs
@@ -36,7 +36,7 @@ macro_rules! new_condvar {
 /// spuriously.
 ///
 /// Instances of [`CondVar`] need a lock class and to be pinned. The recommended way to create such
-/// instances is with the [`pin_init`](crate::pin_init!) and [`new_condvar`] macros.
+/// instances is with the [`pin_init`](pin_init::pin_init!) and [`new_condvar`] macros.
 ///
 /// # Examples
 ///

base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.51.0

