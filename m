Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C3619922D;
	Wed, 25 Sep 2024 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727274014; cv=none; b=P5vHe238sbon3Ftu7qBgoLb6Jy4U87nKkN+Qx7QhSEi8jT+yVCn8lylqswMMHT4zvMkvIvHZIia+ps3JzD+irHQ4MEUpIqCz/dYqpdUGg67WGuOf8O/lG/xN/IkhVVXxqS+wGakdBPL8Ct2yLo1XkrX2XdNZCawTv/1feWpXXw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727274014; c=relaxed/simple;
	bh=M9KdoTdlnqS+mkVwasUHP0kB5BHjAyz9IxrCDFf+DxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u2bzcTCqgaZaqM5iRzP0vZmJKoFztyHn2ohr2sAMTaE/Pl1ZAsZoXiCAeqaqhZX9SFkTp8IntTEZB0jxP9rWvaa4r0VhoEbm/3Gd7owz3yD+tLawf/LqUF0wcg/n+6uq1LxUvxkdSrTFrtN8do17P9hYVK+Kr1pUiwj94K3CxfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv54xMFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv54xMFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70C6C4CEC3;
	Wed, 25 Sep 2024 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727274013;
	bh=M9KdoTdlnqS+mkVwasUHP0kB5BHjAyz9IxrCDFf+DxM=;
	h=From:To:Cc:Subject:Date:From;
	b=mv54xMFAMO5ds4Qy7NBd1w+WG3QNwtHhZIYqc4pF+QGqaTB290afYj4Y4liS6g8M/
	 KMgLqah7xSGAIqpmV1MZU3rKVjUbpg1IFhexkxxfuleYbhDov6OtJAnBtDCUiaD8dK
	 rePx1wVL8pXclns5nPIvtCz47GxISUhpkIJhlsIsY8FeplGSxIo72NI0jHbmDW32Sz
	 hNzGGC/93toJ76kY9rRM++hctyCiduOHr77q2BUpgCXrxQZJaUw0RCxqEGuvX//vWk
	 qliAPXuR0++Jm3o1sh9HUwcQ/6XPDQ7brid8KvxNJE66MciBKRzPvqGQJSYx5EctZv
	 RYeLrCYLcIhoQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
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
Subject: [PATCH] rust: cfi: fix `patchable-function-entry` starting version
Date: Wed, 25 Sep 2024 16:19:44 +0200
Message-ID: <20240925141944.277936-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `-Zpatchable-function-entry` flag is available since Rust
1.81.0, not Rust 1.80.0, i.e. commit ac7595fdb1ee ("Support for -Z
patchable-function-entry") in upstream Rust.

Fixes: ca627e636551 ("rust: cfi: add support for CFI_CLANG with Rust")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 4ea2a161d362..89bbd0b8bdb7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1911,7 +1911,7 @@ config RUST
 	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
 	depends on !CFI_CLANG || RUSTC_VERSION >= 107900 && $(cc-option,-fsanitize=kcfi -fsanitize-cfi-icall-experimental-normalize-integers)
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI_CLANG
-	depends on !CALL_PADDING || RUSTC_VERSION >= 108000
+	depends on !CALL_PADDING || RUSTC_VERSION >= 108100
 	depends on !KASAN_SW_TAGS
 	help
 	  Enables Rust support in the kernel.

base-commit: a2f11547052001bd448ccec81dd1e68409078fbb
-- 
2.46.2

