Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57641DED76;
	Mon, 24 Mar 2025 21:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850255; cv=none; b=f8uvoNxoGmgrXSwuljQzZ9s1MSTw/1ZKdQxJ3yNv3g15QfuTY+zJ+1xVsSnbg8Ne9gl1gxj2sOwl6ItzQwhl2f+nyBWKV38clImIIXCCM+X/v4Yg3RekHqPOAx1Zx9ReijKslsqz3QIybAp+e0hS/GqPjRCEjoyG9qJBgYUi4Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850255; c=relaxed/simple;
	bh=tUz2qusKTvBmkeN4ksXUVEfMZCjH960Ip+LLkF/SukA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJdXiyZYCjyxgw0EqBVuwpHu59ZH14/oRHvM90TUOQcvORzbjTT+VtvVNyT3PwbgYe58yhEtbbNZaupkhbt/5qidoBqu5PNuogFdtEndjdyWgufNdUcjEnGRT05o9JHXDBveGQxQmmvOlHMuyj7r3HFnX6tZvffwlQF/ewFaIDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEBpWuZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEBpWuZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCE8C4CEDD;
	Mon, 24 Mar 2025 21:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850255;
	bh=tUz2qusKTvBmkeN4ksXUVEfMZCjH960Ip+LLkF/SukA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEBpWuZMI5f1ITtXzDBgzx5iItfrlmMCtExT7IrgeGZeKJIZyePfm6qWjI9vODnna
	 UWyFDDhVZabVaJ9bZY8BT0s64Y7rCxpsNWxYcb5A2KejRjp43IsfjO91mSNhdRRaOj
	 xBMmeZG3sohkGZp3h7kYw+qOQh6qnI/S6THpHSGmwjTFU5pIaJ7IbMurNnCqS8Xo9S
	 V/p4gNbFJWjKfbRQcJRH6sKrGBG0fxhdsxNnO0JYkh+O2khYqH8K/KJZTgxBWBec1A
	 hu0HXWHfsJi2jkRxrUDaWw4omFyewPLLz92rqmt0jSFEXaA0FEdL0ZAc61FAxmCWnB
	 FP2PccIYo8EzA==
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
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 01/10] drm/panic: add missing space
Date: Mon, 24 Mar 2025 22:03:48 +0100
Message-ID: <20250324210359.1199574-2-ojeda@kernel.org>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing space in sentence.

This was found using the Clippy `doc_markdown` lint, which we may want
to enable.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index ecd87e8ffe05..9bd4d131f033 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -5,7 +5,7 @@
 //! It is called from a panic handler, so it should't allocate memory and
 //! does all the work on the stack or on the provided buffers. For
 //! simplification, it only supports low error correction, and applies the
-//! first mask (checkerboard). It will draw the smallest QRcode that can
+//! first mask (checkerboard). It will draw the smallest QR code that can
 //! contain the string passed as parameter. To get the most compact
 //! QR code, the start of the URL is encoded as binary, and the
 //! compressed kmsg is encoded as numeric.
-- 
2.49.0

