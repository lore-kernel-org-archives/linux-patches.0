Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A1F256C93;
	Fri,  7 Mar 2025 22:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387948; cv=none; b=ug8/TRwt9CsrWa4RnGe0Nnq0xTJPE6UgzyI6oT/52If+b7eF3spR7on+uFWqm0HxYGVnMLDmeZssUXGHTqfOP9Jk9jitvNMwIy/HC+cjhQlxxIzuz7lwAinRDjqm2X3W9vHpotMDoFMTeeerXn8US8VjkGn4GoL+LjwA9W6df/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387948; c=relaxed/simple;
	bh=YXiysJ83EIKOhHUDqQmYCdVzTZlrMOioXzVdlqps+tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDVqzzUzZTSGRyvJEUQAb7Rehras36zvUlZtRBkK+dtdLu1nEOb/ghEh5cEp4cRoxqSG5nCwg4HsmTiNGo9TGPsWrOIvsqvzhXuVphOyXPr26GMTMyAFwEkRMioDJPB5EqLWCXQ/gpZMVF/0VgXP5v5olx4gEHA+5uAQEWubtXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lw7YuSZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lw7YuSZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C85BC4CEE5;
	Fri,  7 Mar 2025 22:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387947;
	bh=YXiysJ83EIKOhHUDqQmYCdVzTZlrMOioXzVdlqps+tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lw7YuSZYRLh+36CYsS6xQEfpXASnVHHC+7fm6oe3BWzA4exnq6/nWqi3Hjrvr6jcF
	 pZd6bmizuKZioEBnOLOw7ynE/fYy4qEPf0N75PDHxZWCmbDFU5htDCFuoFft/FKRWh
	 eBUEqP0JWH1umcNIHZ40EBm8WASiKvLKqBw4n/fufDqOmX+C0qUoENRPyW44t44lKi
	 aHKMwyiKx8cAsqPlSyPkiksTy38FLD0VCB4lI3jswmmdANgxB8jNVeYZXnb5kq48pp
	 WeerzugfMKJY3M78S8dt8sUp+F1BE+oIzXV5POD46SzpOlKTk0XolgMr+u+n97gtfU
	 Y/ffzdgtnsHpA==
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
Subject: [PATCH 6.12.y 41/60] rust: error: use `core::alloc::LayoutError`
Date: Fri,  7 Mar 2025 23:49:48 +0100
Message-ID: <20250307225008.779961-42-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit 29a48d25ff53c183482dc88a99133a0fb5aa541a upstream.

Use `core::alloc::LayoutError` instead of `alloc::alloc::LayoutError` in
preparation to get rid of Rust's alloc crate.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-23-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/error.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index be6509d5f4a4..aced2fe68b86 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -6,7 +6,7 @@
 
 use crate::{alloc::AllocError, str::CStr};
 
-use alloc::alloc::LayoutError;
+use core::alloc::LayoutError;
 
 use core::fmt;
 use core::num::NonZeroI32;
-- 
2.48.1

