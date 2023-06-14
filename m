Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D7C7F
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 18:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D662C433C9;
	Wed, 14 Jun 2023 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686766178;
	bh=ehcluNxu9TSlphXGqNkHOa/SpBNYxUq22Vm5jtRhQQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oT2G6znf/4h74wnGmSfriDkF2nvXPdzTqMI4UMOv+vWu3KFM9VaVXeGXH0g5Vjy7Z
	 SORLaZWOttT/1lVnc56iIxYDSGEfBO2/dwxvZLgyKUDvn9wS0NJRNaoKliVqZKPruh
	 FC30wTiLC7Tp5k0qFdl8brvltePdc0M3OOlTgOxfrGRizWVOgmldXKqq7mTuV+3ykb
	 3QpJjdx+pyFADdUWuF989LJjFAPWyTNjfCS1yvN6TPdSfITrg81O41ACS5aEbIDsrM
	 TR7hBTRSuNiDqYDj2va8BL3InVnvLJyTdUmE6QddoICDQFNSI5Rj7bDkBLkB2LZAEu
	 fa3Bs9ZYFGmZQ==
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
Subject: [PATCH 4/6] rust: types: make doctests compilable/testable
Date: Wed, 14 Jun 2023 20:08:28 +0200
Message-ID: <20230614180837.630180-5-ojeda@kernel.org>
In-Reply-To: <20230614180837.630180-1-ojeda@kernel.org>
References: <20230614180837.630180-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rust documentation tests are going to be build/run-tested
with the KUnit integration added in a future patch, thus
update them to make them compilable/testable so that we
may start enforcing it.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/types.rs | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 1e5380b16ed5..696d6c5a3b9d 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -109,7 +109,7 @@ unsafe fn from_foreign(_: *const core::ffi::c_void) -> Self {}
 /// In the example below, we have multiple exit paths and we want to log regardless of which one is
 /// taken:
 /// ```
-/// # use kernel::ScopeGuard;
+/// # use kernel::types::ScopeGuard;
 /// fn example1(arg: bool) {
 ///     let _log = ScopeGuard::new(|| pr_info!("example1 completed\n"));
 ///
@@ -127,7 +127,7 @@ unsafe fn from_foreign(_: *const core::ffi::c_void) -> Self {}
 /// In the example below, we want to log the same message on all early exits but a different one on
 /// the main exit path:
 /// ```
-/// # use kernel::ScopeGuard;
+/// # use kernel::types::ScopeGuard;
 /// fn example2(arg: bool) {
 ///     let log = ScopeGuard::new(|| pr_info!("example2 returned early\n"));
 ///
@@ -148,7 +148,7 @@ unsafe fn from_foreign(_: *const core::ffi::c_void) -> Self {}
 /// In the example below, we need a mutable object (the vector) to be accessible within the log
 /// function, so we wrap it in the [`ScopeGuard`]:
 /// ```
-/// # use kernel::ScopeGuard;
+/// # use kernel::types::ScopeGuard;
 /// fn example3(arg: bool) -> Result {
 ///     let mut vec =
 ///         ScopeGuard::new_with_data(Vec::new(), |v| pr_info!("vec had {} elements\n", v.len()));
-- 
2.41.0

