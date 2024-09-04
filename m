Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBED156871;
	Wed,  4 Sep 2024 20:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482715; cv=none; b=kQXcYbBCfG/v16C9f4bj6QGYF5QvhTKMH02Lai5DqtFQM6bYv1US8atRen9EKsjy9aHXT7rFhNCZGbhp/r+64dDVkTG+8BUcX8/6XwS+VB0dxb+6NErfGy9jQj4+jFR+ZyMa/kCKI1XiyEeudBSt/TtpaOoWXn4/WWIvtIXKl+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482715; c=relaxed/simple;
	bh=+8H8FUXDMNKZ9ZjnDBzrY1hLbGuKfWUHaiLVrZewaZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q61YDlCKclBDmfa+m7tY7BcQPyScql9gEv7QgWz5zb8tp/HIhSX9SWQyZz8igPVo/JT+qlJo065751Cu9kWT8U87WJwqYt6zLPnfUGWQGyuRBHL7XCdWrRb2G/ndclQtTmLFGVgdIWcc61o4RvbaEPb98yk4R9kB7jMuoSWlyh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NNsPMS55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NNsPMS55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F1FC4CEC2;
	Wed,  4 Sep 2024 20:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482714;
	bh=+8H8FUXDMNKZ9ZjnDBzrY1hLbGuKfWUHaiLVrZewaZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNsPMS552RWK+owQPtI2STdb/epZTyYtnaibyWv4qk6s9H+ITD/DPpFPcAL4EAk62
	 oyWyCO1wwNWx+7l3Ox9VYmCzh2Su4d7R7WbM903Sj2UVp8IZeCDbbb5fGBepuuJsau
	 zBp2pkMtYyFdc/M9bPY/8/dbHrwXJOnxqXlBzFoSSH8+UrgBz+oRvhNCrtgSnwhy74
	 RQzCt0jtx4RcWFhedewhjf/z7LnZn81KQ3gwjlCxAT1Yh8eH0GVIPEu5USIWRC48bJ
	 EJeioRht5ayLdag+/XN+q0VyTGwaPJNi9bnQXKb+B+w17dd1gPfzltnJCfPfrPfHsf
	 nEknHpKx1XvJg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 09/19] rust: init: remove unneeded `#[allow(clippy::disallowed_names)]`
Date: Wed,  4 Sep 2024 22:43:37 +0200
Message-ID: <20240904204347.168520-10-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These few cases, unlike others in the same file, did not need the `allow`.

Thus clean them up.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/init.rs | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 08b9d695c285..aec26a4decb1 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -87,7 +87,6 @@
 //! To declare an init macro/function you just return an [`impl PinInit<T, E>`]:
 //!
 //! ```rust
-//! # #![allow(clippy::disallowed_names)]
 //! # use kernel::{sync::Mutex, new_mutex, init::PinInit, try_pin_init};
 //! #[pin_data]
 //! struct DriverData {
@@ -368,7 +367,6 @@ macro_rules! stack_try_pin_init {
 /// The syntax is almost identical to that of a normal `struct` initializer:
 ///
 /// ```rust
-/// # #![allow(clippy::disallowed_names)]
 /// # use kernel::{init, pin_init, macros::pin_data, init::*};
 /// # use core::pin::Pin;
 /// #[pin_data]
@@ -413,7 +411,6 @@ macro_rules! stack_try_pin_init {
 /// To create an initializer function, simply declare it like this:
 ///
 /// ```rust
-/// # #![allow(clippy::disallowed_names)]
 /// # use kernel::{init, pin_init, init::*};
 /// # use core::pin::Pin;
 /// # #[pin_data]
@@ -468,7 +465,6 @@ macro_rules! stack_try_pin_init {
 /// They can also easily embed it into their own `struct`s:
 ///
 /// ```rust
-/// # #![allow(clippy::disallowed_names)]
 /// # use kernel::{init, pin_init, macros::pin_data, init::*};
 /// # use core::pin::Pin;
 /// # #[pin_data]
-- 
2.46.0

