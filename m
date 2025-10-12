Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BCF1547E7;
	Sun, 12 Oct 2025 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760309219; cv=none; b=diquc/7OkP4yp0fqU7bfzQDaUwAcKodLf21/jfeOxbRafH1XsSfVzf7xMR85OH8gq2HvvYf5N0zuL7RmYYLCdIvezutHIquF9x0Y00dtsIT57tWCpwwStVVfkr7NoABsTkzpSgIv8t6LXFiX/IyJSVz2Ei2QEaMmYme0WSVQTt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760309219; c=relaxed/simple;
	bh=ObOyoiDDbtj2jx060wHnGYAhzHjfZaoTmQXkMKGc3ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uXctImQwkUKIp52abPT1X1LfpL0t0WD8Bf2QeOpdoLxBN5KD0WkKgV/w1PpGSKuRQBlnJRV0cn9pp3Y8oGPdyYfXN429T3R/77OTSvRAW9qrc2ojBjnUN9+fSTwQZzPr0pxkONNX9IDrIK7P5WuhKJ35n03Ca4UM/oInLoyXZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caOQX94I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caOQX94I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56406C4CEE7;
	Sun, 12 Oct 2025 22:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760309219;
	bh=ObOyoiDDbtj2jx060wHnGYAhzHjfZaoTmQXkMKGc3ZQ=;
	h=From:To:Cc:Subject:Date:From;
	b=caOQX94ItQhFAAMc0+griLkXxNMzoOb4icFMyY1rZekI/7Jq7mJkcnR5PvuPDDMSG
	 V/74+y2wG8M7TUttrT6lRguTKg2O+IBCDqWvE6GcU7TeoR6Ck/k1lMjK9uzHUUH1BA
	 TNqzT9vCg+wi/3Ar/jTazIUxpVTApm3LcJsJ5z4FVN3dzQx8JE/Vw76fwOzWvlV8EE
	 2tOnalESHo+Zk/coN23TgUnqKtSi/mcUcWt933i0G+TU3Kl6/WlrAJcxx6Kg3PyZeO
	 8v0KDYL66eadRXxiABC/4D1yM/H0E26Le4obia3XYy59+glE0OW5hNKlysNVZvJEAr
	 gSsBezHNdeW3g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] docs: rust: quick-start: add Debian 13 (Trixie)
Date: Mon, 13 Oct 2025 00:46:45 +0200
Message-ID: <20251012224645.1148411-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Debian 13 (released 2025-08-09) packages Rust 1.85.0 [1], which is recent
enough to build Linux.

Thus document it.

In fact, we are planning to propose that the minimum supported Rust
version in Linux follows Debian Stable releases, with Debian 13 being
the first one we upgrade to, i.e. Rust 1.85.

Link: https://www.debian.org/News/2025/20250809 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/quick-start.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index 155f7107329a..152289f0bed2 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -39,8 +39,8 @@ of the box, e.g.::
 Debian
 ******
 
-Debian Testing and Debian Unstable (Sid), outside of the freeze period, provide
-recent Rust releases and thus they should generally work out of the box, e.g.::
+Debian 13 (Trixie), as well as Testing and Debian Unstable (Sid) provide recent
+Rust releases and thus they should generally work out of the box, e.g.::
 
 	apt install rustc rust-src bindgen rustfmt rust-clippy
 

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.51.0

