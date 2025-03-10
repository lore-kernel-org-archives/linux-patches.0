Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5922322154C;
	Mon, 10 Mar 2025 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627208; cv=none; b=eYAPvXVlqXaPqkCVt/w5n7eeH/V5SUYYJxb4V41NrvZwyW/jhKPyjSfP6oQKDbUy8tbkwmlxflk2PduB1SNvqQ1f3oBqL3pmRAv49pNqHwgDbPtNHlkWe7jaUi0RAO0O+ySKIiwwtCyTo/8gscRSE0X6Y+lEwvggOw1vvoGrcaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627208; c=relaxed/simple;
	bh=vN4AKFS+wYiXMqUUkZ6C51bLGJ/yD696zQBFfr6Q5Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMsFArc8i3/FlNqj8B0+yfdO/47p7X19qcyHvleXYQo8moh2Hq23oksNjpSEC1+p16NuwD7wTHUGfiAVPlzIEUCmsFRh8vL5IqMhU+kENma1tsFjr0zFdrp9XFoLBSRNpcCIwlfG7+U34dqyCaf6usSQGvN7z2Ni2IK2Z5MOaaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkVTNow7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkVTNow7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D47C4CEE5;
	Mon, 10 Mar 2025 17:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627208;
	bh=vN4AKFS+wYiXMqUUkZ6C51bLGJ/yD696zQBFfr6Q5Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkVTNow7LUJkQ6HOliRaS21hHJaNnpVInLsjFsQXpGFq9BUexsazQnC69zD435o8R
	 YjrAi1LcBBsvB1aRDeok3qAbg2Q4PhSwhH3KaxEj2xzjXabOmYrv5skA1M9FPSK5wU
	 b6VQIrEX/k+mKuV9Bcu2fyHXHbfGho0hA4W5lgmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 051/269] rust: alloc: add `Vec` to prelude
Date: Mon, 10 Mar 2025 18:03:24 +0100
Message-ID: <20250310170459.759400642@linuxfoundation.org>
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

commit 3145dc91c3c0ad945f06354385a6eb89d22becdb upstream.

Now that we removed `VecExt` and the corresponding includes in
prelude.rs, add the new kernel `Vec` type instead.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-22-dakr@kernel.org
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
 
-pub use crate::alloc::{flags::*, Box, KBox, KVBox, KVVec, KVec, VBox, VVec};
+pub use crate::alloc::{flags::*, Box, KBox, KVBox, KVVec, KVec, VBox, VVec, Vec};
 
 #[doc(no_inline)]
 pub use macros::{module, pin_data, pinned_drop, vtable, Zeroable};


