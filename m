Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BC3230BD5;
	Mon, 10 Mar 2025 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627269; cv=none; b=PjxRMVV2MY3KU4CYt7VNOJeYBXx9nD+PWlCXRcw6rdZaVVrTi5Ze8hTmpZ8Eg9ovM0NtAjARwuLoP57Z9VglIUxM6gQmARCXiNsbgo1O+NPgXfRtY3nN4AkWroOwxpWBuZOQW9NCxUROPynROP2gXvy7Da1dWM7Kj16kqtA3XrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627269; c=relaxed/simple;
	bh=wU34VqXVSoarVmIkaPsPi5Razvjzu6zdHfByTKeWnF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/O0kuYqt46u5QjSA+WVibUPZz4nO5kreEvw7wW6HysBtRnGxUh0e3AGgRUZBdnYu++Pvbzt00BJghjPPUyPTmuzLKNtVv4xAg10L7PiUWRhCcdH075P5FF6Bdr7M1kaCOA33wJmy7En9jO8kzkWV+5xXj+XRHtQF2PK85FTXY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gclCOwE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gclCOwE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB933C4CEE5;
	Mon, 10 Mar 2025 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627269;
	bh=wU34VqXVSoarVmIkaPsPi5Razvjzu6zdHfByTKeWnF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gclCOwE7VZo+IDgB8NdaoEHJoiWxvpMk8fr65gpa7hCepeSbFm48faiDERFWF4px7
	 TJPZwqPtQ79pgWlTxW3DNECidVEjgzF6v+m0poySCVmRI1CivDWc7s9KjqjzoAzXsr
	 MfQqY4GpVcybmE+KfL+LEmUkPL+L4W9uxt++IIdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 044/269] rust: alloc: add `Box` to prelude
Date: Mon, 10 Mar 2025 18:03:17 +0100
Message-ID: <20250310170459.479412731@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/prelude.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -14,7 +14,7 @@
 #[doc(no_inline)]
 pub use core::pin::Pin;
 
-pub use crate::alloc::{flags::*, vec_ext::VecExt, KBox, KVBox, VBox};
+pub use crate::alloc::{flags::*, vec_ext::VecExt, Box, KBox, KVBox, VBox};
 
 #[doc(no_inline)]
 pub use alloc::vec::Vec;


