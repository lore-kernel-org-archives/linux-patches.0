Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6DD18BC36;
	Fri,  7 Mar 2025 22:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387861; cv=none; b=pNveKNDmbCY8afVeWI9+YehVKV+wi0nURX76ymiv4By0WsOa7pGzjrxXwtpqLIyz0Wl3wzVviaER55mxfnxlzpU4pczH1+5w8IxiTUgZPyekigFX19Z0Ch892plrrUm/Xg9U8F9TlXTWDwRYUFSqEb2I2TAi4jw+6WsL0beVWH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387861; c=relaxed/simple;
	bh=uM/AQtnQLO11+gfTUmLZyaB7QZKpF7K/LSHNgVHhiqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocDstBJUzyJJx0UO+spSzoxEm23GKj0aWz4hcyHVj8X7Mjky6su5xngfc6uvlUM9q48w0xximkae1wqjTLJzO3gIjthnotsSleESnVrqTseaj6t0yMuqgXy1Yjdv4P4QBArycokeWueWRwsohpgEX5EovEcyVxjzg7r1w+I/0wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gvqvf2wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gvqvf2wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7D8C4CED1;
	Fri,  7 Mar 2025 22:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387860;
	bh=uM/AQtnQLO11+gfTUmLZyaB7QZKpF7K/LSHNgVHhiqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gvqvf2wbc20XrUOmkAid/I3nrN0IVYztDudmDpaXL+M6kgBqHZaQwigItvdKjlNvU
	 tEWh1iqJ0Xl5uw166FVs0Z3bEfnKkg08e/LHQpMilQawFOkHlI8hCzY+K1Tdh/Uan0
	 9RFYFbOXtI0DrBx99Jl4eEEnWtkzXNSFHd2zNPBudGA/ar+4GJ5NHMt4FI0Q53s1vV
	 OBhMI4FEvSI9+X7wqqSxIyWpoSaCecwAPyKUYcROTh5Kd68sPwBSxuPVyEuh45BTmQ
	 yAQRBEVGw1wpAQ9TeFxiIHmAxnaCA3/g1SxgRdjudvltIp9Lj1U4iUYj8+yHv0zCOJ
	 xFOWqoRIS0XFw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 09/60] rust: init: remove unneeded `#[allow(clippy::disallowed_names)]`
Date: Fri,  7 Mar 2025 23:49:16 +0100
Message-ID: <20250307225008.779961-10-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit d5cc7ab0a0a99496de1bd933dac242699a417809 upstream.

These few cases, unlike others in the same file, did not need the `allow`.

Thus clean them up.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-10-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/init.rs | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index a5857883e044..0330a8756fa5 100644
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
2.48.1

