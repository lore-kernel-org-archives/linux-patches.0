Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74031256C93;
	Fri,  7 Mar 2025 22:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387950; cv=none; b=s0gQyIxb1zjNjsXn1Bb01fsdp4RGKXJ8Yczs8lSte1qUXrPoM6i2Pszmb9Pa2UCrQj7IfXqMcEMc25T9VJrYRJN1gqNCIirCbo2Q7sEJqlL7Tl7pOvBuKRIH0JlT9K4SNmGZigEDLGeNG148DDApg62v3ljWF8YhfTWNnWkKAhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387950; c=relaxed/simple;
	bh=ZtdwPMiHtvPElpmPqnXFaCjS20erR3RrGV6u4+eySek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfXQ6D8eJEeLk1We0r/aORGNx3DbIcE9RLcZkDSXEbvX0ByjnkE5ZrTAdLtS2X6xSEagH0jpSK+upuTPLrTiTpZ3qsyXm+20XAHmph9KrV3P/zGm7T5GQ9ifFSkL64tj2uep4MKU3stmKmLr4xMKjZtQQnkM8gl+JWUNArZvXC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WeF3tcyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WeF3tcyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28115C4CED1;
	Fri,  7 Mar 2025 22:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387950;
	bh=ZtdwPMiHtvPElpmPqnXFaCjS20erR3RrGV6u4+eySek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeF3tcynfuVshU6/zFQYDhiV53S3dxUow0Jeyn4jl+Fhm1cGHJavp4fj6c1eYw7JN
	 yBWX+zKcM4S9hGGv6kbCBVwCNr/rAHNyXe+NhirI6zczfpsLk7TYkzGFwPhXjVNuA7
	 XCwmnIdHpmYzKuzZ7TXsXcpzwuLyxg2t5sw2c2cERBdzOQVFpCASE1ic4+o0zr0ZpZ
	 VHu88SKEO3vwMZPMbdQOrsKHQIRiGG1waMKZoU5X8v19kHp3MCe1bjQck3ZxMO3anD
	 QJ/ndUz4sKHW2+rO/mwyA8qXuS3WO8fMujNhlG2V2DDi5j5h26LW/BnKULBXAK9wQJ
	 k2xwMATot73Sw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 42/60] rust: error: check for config `test` in `Error::name`
Date: Fri,  7 Mar 2025 23:49:49 +0100
Message-ID: <20250307225008.779961-43-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit 4a28ab469ff01855eb819dfd94754d1792f03f2a upstream.

Additional to `testlib` also check for `test` in `Error::name`. This is
required by a subsequent patch that (indirectly) uses `Error` in test
cases.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-24-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/error.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index aced2fe68b86..7cd3bbab52f2 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -161,7 +161,7 @@ pub fn to_ptr<T>(self) -> *mut T {
     }
 
     /// Returns a string representing the error, if one exists.
-    #[cfg(not(testlib))]
+    #[cfg(not(any(test, testlib)))]
     pub fn name(&self) -> Option<&'static CStr> {
         // SAFETY: Just an FFI call, there are no extra safety requirements.
         let ptr = unsafe { bindings::errname(-self.0.get()) };
@@ -178,7 +178,7 @@ pub fn name(&self) -> Option<&'static CStr> {
     /// When `testlib` is configured, this always returns `None` to avoid the dependency on a
     /// kernel function so that tests that use this (e.g., by calling [`Result::unwrap`]) can still
     /// run in userspace.
-    #[cfg(testlib)]
+    #[cfg(any(test, testlib))]
     pub fn name(&self) -> Option<&'static CStr> {
         None
     }
-- 
2.48.1

