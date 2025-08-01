Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B283D1A0BF3;
	Fri,  1 Aug 2025 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754065091; cv=none; b=UwXqRa9uyM23MRfgCSoDPxrR5KbjXV19jqlS1k9rPt9kzscR2eoByKvrCoY4xSPDPACwsiDYgepYm9EI4QuICy2f1KgITGW509x2kVeKR4tc48Of00OndfJ4Qdw9qY10CLdfKsA1/T+UVg2MkmZH1ZA1iaqynJ68Bn63F7P4bBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754065091; c=relaxed/simple;
	bh=yFaqUizzdoWOiqGVh6MjpjtilluZGlU0Tj1trX0kkmo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JBQ6MfQjN02v1/JxcUSD8KKZIw+u4Gygv8cjz1BiuRnSaEC0rHQFktG4uIOAFFZUtBkWL/DLtkZpP7CbXzomSfqXZpznB9uEFD38tMwfNsExmzBeHGoPCsWCBM/bBeMOWwsKKY6SWk2zecF/U5AU+rvJF5f4T7rwoj5btxy9xvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LU94o7vT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LU94o7vT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E951C4CEE7;
	Fri,  1 Aug 2025 16:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754065091;
	bh=yFaqUizzdoWOiqGVh6MjpjtilluZGlU0Tj1trX0kkmo=;
	h=From:To:Cc:Subject:Date:From;
	b=LU94o7vT1m7ulhc3OmvYbaBqeFADggIKRkJBdwXHTuNt4iG8RQSsFU5bptUV6Rnu6
	 +Yolqh6AVw2mxcmBAIxboDg5RWQUljwRGOSNA5OzIvitHJcjpAfKAaBSmtbthQUW22
	 iLjXGixaEOKOh1857is6vyOsgV1XImr/AfUvZ8DAJ02j6OsRZfbj4/7h79lbUIbgYm
	 J+WFGtgUAkzaUg13PtH5g2d2QVAazx+V3DngwAG3N8dASVykM5ChoadcL5T4qOnzNJ
	 HHSnz5AuUTSXyzsG+SNAn4dXzVLF2GLEvY04o1N/JOYOL53Qxg6VNBbY5gZHqZeCq2
	 YyUk+PArR1CcA==
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
	Alexandre Courbot <acourbot@nvidia.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: prelude: re-export `core::mem::{align,size}_of{,_val}`
Date: Fri,  1 Aug 2025 18:17:52 +0200
Message-ID: <20250801161752.443431-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rust 1.80.0 added:

    align_of
    align_of_val
    size_of
    size_of_val

from `core::mem` to the prelude [1].

For similar reasons, and to minimize potential confusion when code may
work in later versions but not in our current minimum, add it to our
prelude too.

Link: https://github.com/rust-lang/rust/pull/123168 [1]
Link: https://lore.kernel.org/rust-for-linux/CANiq72kOLYR2A95o0ji2mDmEqOKh9e9_60zZKmgF=vZmsW6DRg@mail.gmail.com/ [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/prelude.rs | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 25fe97aafd02..198d09a31449 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -12,7 +12,10 @@
 //! ```
 
 #[doc(no_inline)]
-pub use core::pin::Pin;
+pub use core::{
+    mem::{align_of, align_of_val, size_of, size_of_val},
+    pin::Pin,
+};
 
 pub use ::ffi::{
     c_char, c_int, c_long, c_longlong, c_schar, c_short, c_uchar, c_uint, c_ulong, c_ulonglong,

base-commit: dff64b072708ffef23c117fa1ee1ea59eb417807
-- 
2.50.1

