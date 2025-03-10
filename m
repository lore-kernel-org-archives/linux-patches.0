Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F8F230BF5;
	Mon, 10 Mar 2025 17:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627211; cv=none; b=efP7ouXhDzyCNvAQDSpTxAb+HruJfCfEDhd2WkzDHkh7FdrUg483PuMQUu0BSbFcfntRmxYPeA9UxwzBB+ttm7g2bPL2YhscAqRM3BJV6TvFMAh8sraKh9hH5rzt1il5q0MLWayBw0mdW2wKQ6iHAeFceCYx1+Srs8ZyRTgb6Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627211; c=relaxed/simple;
	bh=Q92PtQgqW6l/WwO0Ydgzc/7Ix2yEeJk0uwalDNQB5ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pntLNOCh5Er86Ao8KUFdJFFexSvFmCq7jtflyw4MwTgKtXiIAj3oDvAwUSpOVind0fzawkgMlzfaazzzINVPkfRugmDw4/Uji119zCs1U2rH74bKMPaD5lebM828RyPfICeOC9Ile6aFG9aszA41jpySYlStre9sLl6umCsit1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYnTZfpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYnTZfpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9B9C4CEE5;
	Mon, 10 Mar 2025 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627211;
	bh=Q92PtQgqW6l/WwO0Ydgzc/7Ix2yEeJk0uwalDNQB5ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYnTZfpMZQzRTvA+niMgQP3ew2jxxHH6kbj1AN7Xy2pIbBJNlp42EUwxoZK6doYJR
	 8uO9ct0pybRT2S19UKlysoO8oBTlishSe8TkRDNd0xN6t1Wsw2uv+AOC9EL6XPYKXa
	 CzVNFwVgk8jA0wvk0UQfMZrDrk4PzI9VVnBdbr1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 052/269] rust: error: use `core::alloc::LayoutError`
Date: Mon, 10 Mar 2025 18:03:25 +0100
Message-ID: <20250310170459.799148882@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 29a48d25ff53c183482dc88a99133a0fb5aa541a upstream.

Use `core::alloc::LayoutError` instead of `alloc::alloc::LayoutError` in
preparation to get rid of Rust's alloc crate.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-23-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/error.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -6,7 +6,7 @@
 
 use crate::{alloc::AllocError, str::CStr};
 
-use alloc::alloc::LayoutError;
+use core::alloc::LayoutError;
 
 use core::fmt;
 use core::num::NonZeroI32;


