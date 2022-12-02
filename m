Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFB34C71
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 16:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A092C433C1;
	Fri,  2 Dec 2022 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669997804;
	bh=g8YHlGQGI5+kOudmGxtQLpBJJ0VXh/b1x75GjPjycds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYWxTLoMH80ob3tE9WkideVGBL6HUpVaeZ5ha7q+gWJ8kjI8kW66x0wMfXqBvNl+s
	 PJQd5K5KQZRPbx0Sf1colbtpMw5EMb5frdHCbG7WXSId49CmBIqnhXOgw/SvWlMLZW
	 /pZ+eLV9PZFDyxqIlZn7RE/zRC50mbZ565dHUtozufFIjPr8JhTyW/GjdODiw5zipj
	 PX+JcqHJ1LzyhAC0rPUsYW4UiIwEtvsY0IeeGfNCYu7LMAw735b5jv3CF0bl//grQn
	 tO5nU021aoxzEyOal7ng3ohpzMfzsMpB4YvPYEu74tLUPOY8AjYGByia8fsEgC3mBx
	 4QsQIkCbNju3g==
From: ojeda@kernel.org
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH v2 27/28] rust: types: add `Either` type
Date: Fri,  2 Dec 2022 17:14:58 +0100
Message-Id: <20221202161502.385525-28-ojeda@kernel.org>
In-Reply-To: <20221202161502.385525-1-ojeda@kernel.org>
References: <20221202161502.385525-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wedson Almeida Filho <wedsonaf@gmail.com>

Introduce the new `types` module of the `kernel` crate with
`Either` as its first type.

`Either<L, R>` is a sum type that always holds either a value
of type `L` (`Left` variant) or `R` (`Right` variant).

For instance:

    struct Executor {
        queue: Either<BoxedQueue, &'static Queue>,
    }

Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/lib.rs   |  1 +
 rust/kernel/types.rs | 12 ++++++++++++
 2 files changed, 13 insertions(+)
 create mode 100644 rust/kernel/types.rs

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index a3abc110ff97..53040fa9e897 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -31,6 +31,7 @@ mod static_assert;
 #[doc(hidden)]
 pub mod std_vendor;
 pub mod str;
+pub mod types;
 
 #[doc(hidden)]
 pub use bindings;
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
new file mode 100644
index 000000000000..3b0c44769708
--- /dev/null
+++ b/rust/kernel/types.rs
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Kernel types.
+
+/// A sum type that always holds either a value of type `L` or `R`.
+pub enum Either<L, R> {
+    /// Constructs an instance of [`Either`] containing a value of type `L`.
+    Left(L),
+
+    /// Constructs an instance of [`Either`] containing a value of type `R`.
+    Right(R),
+}
-- 
2.38.1

