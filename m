Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC7422AE7C;
	Mon, 10 Mar 2025 17:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627119; cv=none; b=TcA0ZEBTZw1ru53UoYGfJgfVF41DFqsmyVtqOoLvVKNGrF//lWmd5+bBrP/LW/OPjHOXRV5xFfB4jCDD/lktP3seMJvU4lTYOdfcYyxNzxcjRm57jQdJnk2b4RkFmpKAJyUUc2Vvm5pPq7RsQBdXCGUSBNFA+KbvdFMKSFXpUW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627119; c=relaxed/simple;
	bh=VMilkHu/czIYgT1m5bQhbibReSzJFNxRJQ7nSPzPSF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzOC5CWw6xZzSRhACXzOUd9UpN9ISoF6Lb5drWkBCtaGXpbWVr74GahR0BSvuZJIdKmmQlv6SlNxpc2q+gYVeI+3feEWM4b3FSw/5T4NiIxL1bDKBVJLyDoqGdIcylww/B54DodHBsSbv/Qcosr3iSXbGDTEwajJTqDRIIK6tUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWuxfiSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWuxfiSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B522C4CEE5;
	Mon, 10 Mar 2025 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627119;
	bh=VMilkHu/czIYgT1m5bQhbibReSzJFNxRJQ7nSPzPSF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWuxfiSmgMBoz2AlIVVcbDJoXOA079R0LPwzQfUNeUTiDrQCuXDhAanMzO47BU1Ls
	 ECs68UchtRNAHKJmsvCpcQqUrSZrz5SZeIsAJdjKTErb7rnCkQ3144qb4+mssPbWpO
	 /1nRWok1rVYwBSEa87TKxOO0As5wwf/sKhBigeyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 020/269] rust: init: remove unneeded `#[allow(clippy::disallowed_names)]`
Date: Mon, 10 Mar 2025 18:02:53 +0100
Message-ID: <20250310170458.514890283@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit d5cc7ab0a0a99496de1bd933dac242699a417809 upstream.

These few cases, unlike others in the same file, did not need the `allow`.

Thus clean them up.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-10-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init.rs |    4 ----
 1 file changed, 4 deletions(-)

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


