Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD5A2D3EDD;
	Tue, 22 Jul 2025 08:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753174517; cv=none; b=fRoRkIhSqOe3E5RVStzK4nGwJSD2y573/CtfibN2RLA21rWRuZPuaQzzZk0XpmwRfnZ3fLvxcARvZUNCne0ATydBSr2ntzhRkHx8tEXKDVXChQoUgh37O66zpa/6zV2DzuPK+Zc4TPXpE43/SCsIKzmzMj4R8Mirj3FA6FaEX+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753174517; c=relaxed/simple;
	bh=Rq5GNyaaope0SfIt7slAATJYCCZekSTyEA+C+4d7Aws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QmVqFU+m7z4LCXWD3LsLJMKlzno3t205UcuFgX1G38NchlyCVhSsBc9BXwHeh9BXELeUy8WJUOTE+RM7tBwyJTWO6QQnfUMAfsOxeW5XgPJqj5bM0DlxO+IvnR3qwAaet9nRfRvguBUwbNPMNmTH11q5WI9VW/XOA2WZr/axoa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvNdnbY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvNdnbY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F34C4CEF4;
	Tue, 22 Jul 2025 08:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753174516;
	bh=Rq5GNyaaope0SfIt7slAATJYCCZekSTyEA+C+4d7Aws=;
	h=From:To:Cc:Subject:Date:From;
	b=MvNdnbY8deykr06Uv5PtaQtEi5nkQdNA39CzECVRlA2WCUw8Mw265nbnTYYD3oRK9
	 6yZEfTPanYx+JPHx0EVOl7Pv1q+wkOYQOiy6/IBf/VeuTlNJReutiAbY1O8MGqmmUY
	 qLg/17kcNymRblLGpiefnWGMdE6a4QnA8NVaPPdXyW6zXHX7nciYu+9W/tX7AupG07
	 DGG/vlweq21YC/iajM7z4WEvPckOOqBddAVEkTyzNjRsoI0Hvk95yuoI1M+HrlquzB
	 zOH9fAG6uDKrVmctQ7V/2UoC5WFkGRRuK3fhofKvt/XEM5bbjzvQ6/pg40xsXzqJUF
	 4ddBW/quVa2OA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/2] rust: io: fix broken intra-doc link to missing `flags` module
Date: Tue, 22 Jul 2025 10:54:59 +0200
Message-ID: <20250722085500.1360401-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no `mod flags` in this case, unlike others. Instead, they are
associated constants for the `Flags` type.

Thus reword the sentence to fix the broken intra-doc link, providing
an example of constant and linking to it to clarify which ones we are
referring to.

Fixes: 493fc33ec252 ("rust: io: add resource abstraction")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/io/resource.rs | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/io/resource.rs b/rust/kernel/io/resource.rs
index 1d5f367a6e8a..bea3ee0ed87b 100644
--- a/rust/kernel/io/resource.rs
+++ b/rust/kernel/io/resource.rs
@@ -177,7 +177,8 @@ unsafe impl Sync for Resource {}
 ///
 /// They can be combined with the operators `|`, `&`, and `!`.
 ///
-/// Values can be used from the [`flags`] module.
+/// Values can be used from the associated constants such as
+/// [`Flags::IORESOURCE_IO`].
 #[derive(Clone, Copy, PartialEq)]
 pub struct Flags(c_ulong);
 

base-commit: 696b2a6ce9487ae278fd239658ca2714cd211e8e
-- 
2.50.1

