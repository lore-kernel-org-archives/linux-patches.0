Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116AF2AF09;
	Thu, 26 Sep 2024 12:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727354907; cv=none; b=ib6OcRF3HpPfdDhMUjreCB1J/03LRUuW4id4L55XH5zPjTUFsmQ0nkFbhAH6b76ZBNPjiks+rj5O9g114pd6C2r8uUUwfH1y65dBqw+cg6OkDQnY074MHlg801Cm+u+bu6rOSyW9PicjbvXLS8xDGWGqFWOfksH+bOvSrrKKeJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727354907; c=relaxed/simple;
	bh=Q2WaV/ktXw0NaQlCEEeZFSLduawrmmDUflwBXTLMRgE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hRlfD5TIbjxnuAkk4j7MsJ9AGoY5NLJZb+7RChTZznTa2rdDhAa2+pPdBESP5h+JFWwFY9PHrVT2s8ylh+khk6e3W4MfmsD6FGInkzh3BI2ePxCBcYPC42lKDKKI5AeRUpphuXigsUYgvHrxE1gqHe4pkgVmuAKYdtY+S7MYAjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ur3tT3uT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ur3tT3uT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB324C4CEC5;
	Thu, 26 Sep 2024 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727354905;
	bh=Q2WaV/ktXw0NaQlCEEeZFSLduawrmmDUflwBXTLMRgE=;
	h=From:To:Cc:Subject:Date:From;
	b=Ur3tT3uTVz9w5MYzg3nrIMO0exEzJul60D79yuwieRkNiXthj5t6QwIvkAu6hwHZY
	 W838wDJGeDSLGIoQwTm0P7xzNjghfG/NbjALK7OjDQ/7Ax7cap1Icgcyv0H42kFic8
	 ZHAWsEydDSlAVSPM5RZDYqQrWD5Fcl69JNJKRIsaeF55cLhhmA3TKs2VVtOrymM7jk
	 nNA5yCCTHEqdgv9W58piLSKkEnG87WC2WFgXIN1ekPFodRM8nWAO5/xh+a1ecEZFho
	 hBjIuTikYSqPdjLW6PID8A2ynH3+Ex+xMNY0iBnFoQc9/Eut6ykkF0mGW2V+3Qf8+v
	 pt+uKmtExh4Hg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: kernel: sort Rust modules
Date: Thu, 26 Sep 2024 14:47:51 +0200
Message-ID: <20240926124751.345471-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rust modules are intended to be sorted, thus do so.

This makes `rustfmtcheck` to pass again.

Fixes: 570172569238 ("Merge tag 'rust-6.12' of https://github.com/Rust-for-Linux/linux")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 22a3bfa5a9e9..b5f4b3ce6b48 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -44,8 +44,8 @@
 pub mod page;
 pub mod prelude;
 pub mod print;
-pub mod sizes;
 pub mod rbtree;
+pub mod sizes;
 mod static_assert;
 #[doc(hidden)]
 pub mod std_vendor;

base-commit: 11a299a7933e03c83818b431e6a1c53ad387423d
-- 
2.46.2

