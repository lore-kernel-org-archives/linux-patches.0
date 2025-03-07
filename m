Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDF32580DD;
	Fri,  7 Mar 2025 22:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387926; cv=none; b=QtGbUzCwBYj8uYtPjLKbYfc5Q5CJZWOMg8fDhMaSHaIuXBJMh2KwhDCtQL1yfQ6M4LzTBS2ZskTa4ZxbiXyLgOu0WPq/11ZiHZFuL21b9+Gx2rbGa46XRvr9LU0beL+NOj43ZFqQThjO5ETg0X2d23/LHUUEEw9torW+cwNsRzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387926; c=relaxed/simple;
	bh=tG65ohIx6JknqWf/ZOLBVgmAGg0O6qtEIdCnKoarEMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exf0/6V0Yc7pRycRTNpPUJqRoBQiOHp1t4BN4W64ihtNT8lJ78YxzB28BrOenVHciP1OoIdSoNERshRhnrDVjdiqAVsxYcbmSAYIPkVDWva/u+GitJk7IwkfoE0wFmHNfyrVy9T+D083+UpAnUNvxlChqyo9FCYnoLYjGcWJJMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbaQsh1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbaQsh1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19E5C4CEE8;
	Fri,  7 Mar 2025 22:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387926;
	bh=tG65ohIx6JknqWf/ZOLBVgmAGg0O6qtEIdCnKoarEMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbaQsh1+TfFcJNwGYb6ezKqJ3+kc6d4nv/v+de29idCF07vwYb0/XU/K6FF/eauu3
	 FL2VfT2voJ/4xVgSNqj7RuSeeDPgaqzV2uyVPhBeUkCUheUIKqevX0rtdXBfcUDMpW
	 rUZoHdLpTDMM6Li+UPa6ynz+g+pLfEKs9vk5rmL5rOoyLPiKwKHLJ9KYnjjKSrgw6N
	 Yhxz9JACYwvBRUso/EIP0w9/hBZXgJl4cvVfQid9fsC0BKQZ8Fao7m/uAVRJLdwVM9
	 HhIDYj7MhsxXll5JHeOLGIjLNcx7ixCG60cBBqFc5v7eKpWc3mgZKYj8RLp8tjYqEJ
	 YnDz9DuTmkw3Q==
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
Subject: [PATCH 6.12.y 33/60] rust: alloc: add `Box` to prelude
Date: Fri,  7 Mar 2025 23:49:40 +0100
Message-ID: <20250307225008.779961-34-ojeda@kernel.org>
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

commit e1044c2238f54ae5bd902cac6d12e48835df418b upstream.

Now that we removed `BoxExt` and the corresponding includes in
prelude.rs, add the new kernel `Box` type instead.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-15-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/prelude.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index c1f8e5c832e2..d5f2fe42d093 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -14,7 +14,7 @@
 #[doc(no_inline)]
 pub use core::pin::Pin;
 
-pub use crate::alloc::{flags::*, vec_ext::VecExt, KBox, KVBox, VBox};
+pub use crate::alloc::{flags::*, vec_ext::VecExt, Box, KBox, KVBox, VBox};
 
 #[doc(no_inline)]
 pub use alloc::vec::Vec;
-- 
2.48.1

