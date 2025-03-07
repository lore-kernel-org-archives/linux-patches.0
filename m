Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D00258CF3;
	Fri,  7 Mar 2025 22:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387945; cv=none; b=hCE+gngbrRbl4z11UWOnjikRSrykQIaewfdO1zWheEdSa8giHyMpEFQ3k9Ua+r03RuDccx3dMrfb9ut4gfLIrc7VGJ/Jt96q4wlPOr7JBtrhtEa3JkqrTUKyRHxCzhpXnvmEaVfKjzW9+QKMRyAMAX6FrxdLGNyRWUhNB8/abII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387945; c=relaxed/simple;
	bh=7nZKrP/H1mY18LYZyVle5z00smI71dZRJCODhD8QpBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtuzkRd/PcirE3vEBsUdON54Ulcmnzs0KbLVwyXOkpXxZasAgYh/FXIv7dYfhGtYiOn9wUtun9oGkWVzmj9GnY88yHHL4SuMrLiHd2KiVcl0Gln+HSnVVFNeCs/1jrJRTVtN2mlr1oiN9u5gaCt3BTrvIAA9531QB+2al1Drhw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+gHGWiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+gHGWiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BEBC4CED1;
	Fri,  7 Mar 2025 22:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387945;
	bh=7nZKrP/H1mY18LYZyVle5z00smI71dZRJCODhD8QpBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+gHGWiM3jY3VcTKtKEcUTl1LdakGrbPELhlmA7aBJGr1NSlzBmFPcWyVCYXf1jTh
	 JkMl8WlErUQStXmBSXw72aIf2FuJI42RMK5PdbYTLcTLPh2s/02RHSK/L2cYRxxZBz
	 S+cArlIBtwjnOyWUfxjtYsP5K/rkaBxTCO9lxLUVBZ37xmUbCjuIo9mrQBBR98AOp6
	 yE+9jLTKDK2EABLlxrtx8o6C60ag0sHQF7cwXAA+TT9WRjIqeY2qdLqFzs5FH0hwMf
	 638RJHutQOglrEpLypd+a+uiyMx3dJWAdMETt6SLMvfK/J9OGDxi2z6Nvq8TtGHL7l
	 hX5537tUNoa5w==
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
Subject: [PATCH 6.12.y 40/60] rust: alloc: add `Vec` to prelude
Date: Fri,  7 Mar 2025 23:49:47 +0100
Message-ID: <20250307225008.779961-41-ojeda@kernel.org>
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

commit 3145dc91c3c0ad945f06354385a6eb89d22becdb upstream.

Now that we removed `VecExt` and the corresponding includes in
prelude.rs, add the new kernel `Vec` type instead.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-22-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/prelude.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 07daccf6ca8e..8bdab9aa0d16 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -14,7 +14,7 @@
 #[doc(no_inline)]
 pub use core::pin::Pin;
 
-pub use crate::alloc::{flags::*, Box, KBox, KVBox, KVVec, KVec, VBox, VVec};
+pub use crate::alloc::{flags::*, Box, KBox, KVBox, KVVec, KVec, VBox, VVec, Vec};
 
 #[doc(no_inline)]
 pub use macros::{module, pin_data, pinned_drop, vtable, Zeroable};
-- 
2.48.1

