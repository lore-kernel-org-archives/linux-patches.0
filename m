Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1601F4281;
	Mon, 24 Mar 2025 21:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850268; cv=none; b=K+iW75Hlnba5Y0vmf7II/in4Z7X+T8QqZYWx4KJnAjf9K/Npw1WBOQFx20Sko8FGyTmQi+WtruLQC2vaGt9t1Q+XQvNAquY9BRv45WPcGbXZUtMhyV1rBNTthxOZo7ntkPZZCN0YWvFMEYgf3DJdtYA7iDklOiRwJEu+LYmK+Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850268; c=relaxed/simple;
	bh=raN/DrVca3eWEseg36QZs2qjbG2u7DBN1E3/rJC0TSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfLSoFbMoUQ+CigpriDMVt23tPG3JTX9Tb4OdpJKFgPQcS+CMU6vPA4ZH4xL/f/GLkVCY3ZBHycM/GylQ+HEn2ilFCbi2u0Diz6YU/euCu4Yt/bdCSG1c1Pw24x29rkVIDH+H2WO0s4RDOt7HneiCegRVMBio+wljqlpsrfb8Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMU4GBld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMU4GBld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E42FC4CEEE;
	Mon, 24 Mar 2025 21:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850268;
	bh=raN/DrVca3eWEseg36QZs2qjbG2u7DBN1E3/rJC0TSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMU4GBld/nQdkpBXYug2C/p9qV9t0uDvSU02BlLHGQO5KM4o84WiR6bt0VWyIo0zb
	 mLHK8lcxDDyaRaGmQusldlQz5qgqWtVEH73KN7A2TP90WHkPDtj7lRD5yQQsWyqIP1
	 vMtr+fkyMhFZ3W/vaYaqX4NtP6flmZ8xZ4GE3LbPPR4Gvzq7xHlZnR1SroK0qdyhb8
	 TzEq/YvaXLNXjMS2ytnaH9nVBdoUF1eOsrlvAMOBEKB/WJrw+j+dv2wHd2x48jAbj0
	 sp7JbE8smYsqm3P8+15td+Gm3ICr4ragNDZOL6071CgWwMPAV/VDvV7mbMLORnFH9R
	 P/57msj55mhMg==
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
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 04/10] rust: alloc: add missing Markdown code span
Date: Mon, 24 Mar 2025 22:03:51 +0100
Message-ID: <20250324210359.1199574-5-ojeda@kernel.org>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing Markdown code span.

This was found using the Clippy `doc_markdown` lint, which we may want
to enable.

Fixes: dd09538fb409 ("rust: alloc: implement `Cmalloc` in module allocator_test")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/allocator_test.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index e3240d16040b..039cd1e36c21 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -4,7 +4,7 @@
 //! of those types (e.g. `CString`) use kernel allocators for instantiation.
 //!
 //! In order to allow userspace test cases to make use of such types as well, implement the
-//! `Cmalloc` allocator within the allocator_test module and type alias all kernel allocators to
+//! `Cmalloc` allocator within the `allocator_test` module and type alias all kernel allocators to
 //! `Cmalloc`. The `Cmalloc` allocator uses libc's `realloc()` function as allocator backend.
 
 #![allow(missing_docs)]
-- 
2.49.0

