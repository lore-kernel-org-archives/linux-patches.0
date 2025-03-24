Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4CC1F5617;
	Mon, 24 Mar 2025 21:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850290; cv=none; b=NzO83B/PCKMRnyNPEn+quAz3XN0SyHCMD3eNNHeNuachvv6CC+FZ43G56/SgXXvxyke8cVrWJWPlJXAGo6lqYo4Hphg9LAaAKn58Pic2U3+VDLEsudEftCFQz4AAkmg+CRqqlj8cvy6Iemc+mRArKNPh/mgv+Pk7VNCjuwxipKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850290; c=relaxed/simple;
	bh=5AgVBZOVIAXuOhpg55nMBMuordYAujIXO9NsJifEoAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCcCk3AnVK1Z3diiVYQKGxUG7ixn1iMeF5n1puwmosCF7r340X1z4+P8nVV6u5RdNsEz2CwTuQRaUtNUWXbpHHsyFCPVcMEIN55xKUU9UshTkJhmvg+xKKIbtVU6D6PyKn4idbBQfrzHfgbtYr7p9W5HMSnKT7RoVZSQr8JN4Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MnInPrYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnInPrYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36783C4CEED;
	Mon, 24 Mar 2025 21:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850289;
	bh=5AgVBZOVIAXuOhpg55nMBMuordYAujIXO9NsJifEoAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnInPrYpJDKZ7BOPtSNj6iTvROAnr9VVFvD9QdOAxvoFIxbfaZUKXmgKjv/bEslxb
	 7vow96kZIzCdrzRCfwIneyyCkeiPw4gv5OV6tWJeEbFCRD0BZNh3HTqgRvQovznUoS
	 9uQIg6oXASaiMiLNxnIeqrgIVXQhzHDqntwJnaA6lMNcXSoberALszWtH0v3TzDaU/
	 tUKzMgYz/G/OPEJESt/tpdkAsbMarU/y3LRedoCsGHtS9UxS5XY5phtRxBuUfDzAkC
	 RZqiZsGyvb3MlbVHXIRoYxgAMyb34z6KzektcNQq/4NdkwOQUMRrh6R6YH42E1sMbx
	 oczp5F4lTKJBw==
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
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 09/10] rust: task: add missing Markdown code spans and intra-doc links
Date: Mon, 24 Mar 2025 22:03:56 +0100
Message-ID: <20250324210359.1199574-10-ojeda@kernel.org>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing Markdown code spans and also convert them into intra-doc
links.

This was found using the Clippy `doc_markdown` lint, which we may want
to enable.

Fixes: e0020ba6cbcb ("rust: add PidNamespace")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/task.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 49012e711942..ca1209b997c4 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -156,10 +156,10 @@ fn deref(&self) -> &Self::Target {
         }
     }
 
-    /// Returns a PidNamespace reference for the currently executing task's/thread's pid namespace.
+    /// Returns a [`PidNamespace`] reference for the currently executing task's/thread's pid namespace.
     ///
     /// This function can be used to create an unbounded lifetime by e.g., storing the returned
-    /// PidNamespace in a global variable which would be a bug. So the recommended way to get the
+    /// [`PidNamespace`] in a global variable which would be a bug. So the recommended way to get the
     /// current task's/thread's pid namespace is to use the [`current_pid_ns`] macro because it is
     /// safe.
     ///
-- 
2.49.0

