Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E1B7F
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 18:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A76AC433CB;
	Wed, 14 Jun 2023 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686766170;
	bh=5RT+1Ed3wlNsUFIiAUAkZSAQ11PIAvj/hYAZC9K3F20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jp5+Lria9yAWeZ9iJIHusdDPiBgUStgV1fZbEIkuGm0YYbXiN2gdl5764EREsXEzj
	 18FTtiUIgcYWl4Oi1wu1loAaLje/vubVlOBYjTgqvPA3eUTBctLd3cHS8OcRulyh5E
	 K1Z/6A9kX9pacfQa2UCAeVQDnHZm9dJvDviqjtdrWCpex4IzYPToohgXvYwOeCb1hB
	 gD+iCd85RSQKnwREDCJAzRh0OgASYUzVi3Rvk0t+gCje/dyeL5aM27i2ves126vdVu
	 k196MykQcl6X4iLIc06xPHrGbJYp9VIE87x+8Hq6GMXEiQGaRteuzw9INUgXPAMV+e
	 wfis52c4BHgKA==
From: Miguel Ojeda <ojeda@kernel.org>
To: David Gow <davidgow@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>,
	Philip Li <philip.li@intel.com>,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/6] rust: str: make doctests compilable/testable
Date: Wed, 14 Jun 2023 20:08:26 +0200
Message-ID: <20230614180837.630180-3-ojeda@kernel.org>
In-Reply-To: <20230614180837.630180-1-ojeda@kernel.org>
References: <20230614180837.630180-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rust documentation tests are going to be build/run-tested
with the KUnit integration added in a future patch, thus
update them to make them compilable/testable so that we
may start enforcing it.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/str.rs | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index c9dd3bf59e34..c41607b2e4fe 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -213,6 +213,7 @@ impl fmt::Display for CStr {
     ///
     /// ```
     /// # use kernel::c_str;
+    /// # use kernel::fmt;
     /// # use kernel::str::CStr;
     /// # use kernel::str::CString;
     /// let penguin = c_str!("🐧");
@@ -241,6 +242,7 @@ impl fmt::Debug for CStr {
     ///
     /// ```
     /// # use kernel::c_str;
+    /// # use kernel::fmt;
     /// # use kernel::str::CStr;
     /// # use kernel::str::CString;
     /// let penguin = c_str!("🐧");
@@ -529,7 +531,7 @@ fn write_str(&mut self, s: &str) -> fmt::Result {
 /// # Examples
 ///
 /// ```
-/// use kernel::str::CString;
+/// use kernel::{str::CString, fmt};
 ///
 /// let s = CString::try_from_fmt(fmt!("{}{}{}", "abc", 10, 20)).unwrap();
 /// assert_eq!(s.as_bytes_with_nul(), "abc1020\0".as_bytes());
-- 
2.41.0

