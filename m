Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4092A1F4E54;
	Mon, 24 Mar 2025 21:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850277; cv=none; b=cMfGTldgHeWgHr4offSf1zSpxxDqGnwwC4ri4lBk+CNsRJSx35RdLbctIViwBRd894VugC9VBiubgU3B+bvSac7aA+eM1S9zE5b3Wl1P9i1qAGEyMrCBhjSQuCrhdshD0iz4q63kNsw4datFRbgdhEwVGB0alSOMcA6VglJMi+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850277; c=relaxed/simple;
	bh=K1Xbe+sschQc/Ffbiv9QVBNfgYYwO/d/wVbgAvn8+iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0ZHmAJYPSRPFNzHJBXUu4VTnlPRFDxjZ4fubmJo50Cp5lAWXHrxzC/JccDPflV0mfaF/8AW6xpiV3YUPGCTTPAgIbMA/0jVQFRXysWb4I3AyrOsSyxYDUvGIj1xzw/igktyBueqfS8o15gmrQ7gmH55qnbpkF3+27yFhG0rZXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCdrxbcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCdrxbcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08CFC4CEED;
	Mon, 24 Mar 2025 21:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850276;
	bh=K1Xbe+sschQc/Ffbiv9QVBNfgYYwO/d/wVbgAvn8+iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCdrxbcBP97Zz2LU9u2ySQzxqRicqz3IEJYFju65MU+Po2Od67XKI9kQR8nEcmkU0
	 vQwnoB069r6Ao6r1u7wPHAh6jbZNIP93TR4vj/SP2yZF8brA5FqXZNH+g5ZV3U8nLa
	 4bs/yqjIJnBz5mO1AGmg5cNU9jbyrMu6tI+OcGsIH7Azse8yW4pKzNTvSpw1NjmxVy
	 dwagh7I/O0e9lGb9WHP1x9DnhzOQ+28wcSnKLcmVtl3iM8GQQELqrhp7EzlARDQO9F
	 JrVxSgI0THxncDtoGAQbWRh0jvNz+pIenCsGfrNara9j5pohgCbsu5q7p7WTtitSTf
	 IYVjH1bn+1+Jw==
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
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devicetree@vger.kernel.org
Subject: [PATCH 06/10] rust: of: add missing Markdown code span
Date: Mon, 24 Mar 2025 22:03:53 +0100
Message-ID: <20250324210359.1199574-7-ojeda@kernel.org>
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

Fixes: bbe3b4d1580d ("rust: of: add `of::DeviceId` abstraction")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/of.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/of.rs b/rust/kernel/of.rs
index 04f2d8ef29cb..60ed551b50fb 100644
--- a/rust/kernel/of.rs
+++ b/rust/kernel/of.rs
@@ -4,7 +4,7 @@
 
 use crate::{bindings, device_id::RawDeviceId, prelude::*};
 
-/// IdTable type for OF drivers.
+/// `IdTable` type for OF drivers.
 pub type IdTable<T> = &'static dyn kernel::device_id::IdTable<DeviceId, T>;
 
 /// An open firmware device id.
-- 
2.49.0

