Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD81C1FA0
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 05:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD072C433C8;
	Tue, 18 Jul 2023 05:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689658119;
	bh=pDq8zAwwItzO8pDih79tVM9FL2q7j+cY2RORNTyXvJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mg7gawPhf5h44Q4Lw0VZmHcJu2Psn4WiMq6k3UMWA4Ilx/OzR/RGky3KmujN/7FNC
	 b33Qsf9zyf83HOZ6EkiFugr99E16qCDkgwaeZfKr1GYFgHrfFWYvExq411QL5fCNAG
	 WohVVmv+EsMuyCaTkAnG7fqPjF8zck7E6NxCZEGUXD9Gx5UelQfYBW8oADw19m6mPu
	 zXdvohtqknr88s3QWR17HvhJkX8pwezvICB1X+92qfinUi/i90IGehr8v+aQkZbnEc
	 mOb1CM4ck5yPM396PR/EqqqGgZ9Ivbffy3Qh8Xr3ZGwv2a7Rfz3zYCZn3FYx2rBiWL
	 +swgakWgxA4lA==
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
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: [PATCH v2 5/7] rust: types: make doctests compilable/testable
Date: Tue, 18 Jul 2023 07:27:50 +0200
Message-ID: <20230718052752.1045248-6-ojeda@kernel.org>
In-Reply-To: <20230718052752.1045248-1-ojeda@kernel.org>
References: <20230718052752.1045248-1-ojeda@kernel.org>
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

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
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

