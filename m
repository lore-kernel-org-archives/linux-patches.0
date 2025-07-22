Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8062DAFDB;
	Tue, 22 Jul 2025 08:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753174520; cv=none; b=JZF9JZxzQfZM+o404Hv81BXaSKUnQIkS8TRq5lu4ffXPgc1f1QoeaQ4GYDLQIdZgTMoIDXRif+K5R8NW86uPiH5HMR7gb21Hyaq8AoUF7W3h0GZUT1wZzTHGudCXxFgd0IMBKAoLepUmNsSSbaRffGMAmMzL3d6WjOROLUqDv0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753174520; c=relaxed/simple;
	bh=hcs0SRwtpZlg7CCra0T+s9QPfYSWVS5+CqJeyR/QnM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hivbWp+5oWG8bAyvKGmzkolpiKQX2t7WmPHMbvON63x7Z3LFUlG4COAlKlxUrdN3cCwiw88mWryXZhQZ+I7tjrVjNqmH1+18nKIHCFS/a0FX/jlMM2EVapewtwqWjlpPA1dS8D0hraggRy6BPlaBAYWx/C7XBW0wIekOyadfvBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBc8fFtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBc8fFtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB66C4CEEB;
	Tue, 22 Jul 2025 08:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753174520;
	bh=hcs0SRwtpZlg7CCra0T+s9QPfYSWVS5+CqJeyR/QnM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBc8fFtEePsrwTUOmO0/6MpgABavFX1kIqqGjg+MqcWbPazwaYRGo3qA46abutdZk
	 topzyFv812wrIV8LDDiN72XA+V2wYHMedwtlKG4fO68mUbuth8Kv/ISBUYZYd1BGmP
	 iSiZYT9kQSukK5IGitJQ5GRP3+FNEusf7WCm4oeDAlXRXoL7h+y+/+ZvQFpZFZcC0q
	 5/gF5DoHaNyfnGvgkaoXKYdbzBVo9kTj8rjKPIUgxlEcwLXurdX254nBtd2hCBf4oj
	 LrmxU8JAdGPt8zTPRp3YW/pXRVr+6jwsLmqc5qQfzxo0FPSWhbXtEmdjUX/0BzjIGj
	 2EIj/Jz7NxxPQ==
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
Subject: [PATCH 2/2] rust: io: fix broken intra-doc links to `platform::Device`
Date: Tue, 22 Jul 2025 10:55:00 +0200
Message-ID: <20250722085500.1360401-2-ojeda@kernel.org>
In-Reply-To: <20250722085500.1360401-1-ojeda@kernel.org>
References: <20250722085500.1360401-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`platform` is not accessible from here.

Thus fix the intra-doc links by qualifying the paths a bit more.

Fixes: 1d0d4b28513b ("rust: io: mem: add a generic iomem abstraction")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/io/mem.rs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/io/mem.rs b/rust/kernel/io/mem.rs
index cc9feb2897d8..6f99510bfc3a 100644
--- a/rust/kernel/io/mem.rs
+++ b/rust/kernel/io/mem.rs
@@ -40,8 +40,8 @@ pub(crate) unsafe fn new(device: &'a Device<Bound>, resource: &'a Resource) -> S
     ///
     /// # Examples
     ///
-    /// The following example uses a [`platform::Device`] for illustration
-    /// purposes.
+    /// The following example uses a [`kernel::platform::Device`] for
+    /// illustration purposes.
     ///
     /// ```no_run
     /// use kernel::{bindings, c_str, platform, of, device::Core};
@@ -98,8 +98,8 @@ pub fn iomap_exclusive_sized<const SIZE: usize>(
     ///
     /// # Examples
     ///
-    /// The following example uses a [`platform::Device`] for illustration
-    /// purposes.
+    /// The following example uses a [`kernel::platform::Device`] for
+    /// illustration purposes.
     ///
     /// ```no_run
     /// use kernel::{bindings, c_str, platform, of, device::Core};
-- 
2.50.1

