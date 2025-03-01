Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3D11BFE00;
	Sat,  1 Mar 2025 23:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740871063; cv=none; b=nDDI0GhxTNpQCc/KjT00XTeYTtxrRT4Mye0N3PoxlbAUKnMOno9B8izy9yPWxWco8jt6sZQX9+Ts1hg2iUQbSLdOfMk9ZugKrZ4TC9EuM1q98uBobauP/O/5ASqpSuHKshsXptUB05q353XX4pzMyYoWSa7vKt1nTvj31MqnISs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740871063; c=relaxed/simple;
	bh=7z62IPkiSO6NRrH3JPArIZUmv34+1yiL4Zr/2/1Cx0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkSa/ru/Fy4aQGkKqwyizeJeFHD4jfXRq3ivSRs5X0LpsY46unjwuAPuD+XwhmZ6j0g6qYdjl1f7VdZ6/Mamtw8Q/2a3eyrnFMA+jwZTUiLD8Dbm2FIcq+R8ZaEmji2lq0Qx1bIPLDLCjrYs9XM/HanYDcnT2zjt1Bsq2gU5dNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnHXiQ2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnHXiQ2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B59C4CEE6;
	Sat,  1 Mar 2025 23:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740871063;
	bh=7z62IPkiSO6NRrH3JPArIZUmv34+1yiL4Zr/2/1Cx0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnHXiQ2xEbRr5F3YpSu1XLm5w8OYyZv5x8jnSWDq+LVHj3dJiW00wljMWKbWWTxuF
	 DhniRqvOQwN3MOjANmDN15zTbDyQA9ohuU3FrC957csOl/zsm2XJVhS05Hf0M2C+ub
	 Hy/GGKKvTpxhC8lsToXIFRcAsCAtmp+yW9hGEkIpwKXnHr8MK7+uESyEk9gPHmXg0X
	 DK0hAD6vnWvqMtbUuJQ1skcIIGS5rnPvpTklgUqsr/Zvs4uF8rZ+L8FmvMUKpavPas
	 QrjzeTbFs6gJF54VSbVm3LzzLjOsZ6zSfbj9/ZDObJmVrr4C2AXr7i7CCdGMNgXfhO
	 MncgUNTk7BpFw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Jocelyn Falempe <jfalempe@redhat.com>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/2] drm/panic: fix overindented list items in documentation
Date: Sun,  2 Mar 2025 00:16:02 +0100
Message-ID: <20250301231602.917580-2-ojeda@kernel.org>
In-Reply-To: <20250301231602.917580-1-ojeda@kernel.org>
References: <20250301231602.917580-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
Clippy warns:

    error: doc list item overindented
       --> drivers/gpu/drm/drm_panic_qr.rs:914:5
        |
    914 | ///    will be encoded as binary segment, otherwise it will be encoded
        |     ^^^ help: try using `  ` (2 spaces)
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_overindented_list_items

The overindentation is slightly hard to notice, since all the items
start with a backquote that makes it look OK, but it is there.

Thus fix it.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 8bb5e52d75cc..6903e2010cb9 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -911,16 +911,16 @@ fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
 ///
 /// * `url`: The base URL of the QR code. It will be encoded as Binary segment.
 /// * `data`: A pointer to the binary data, to be encoded. if URL is NULL, it
-///    will be encoded as binary segment, otherwise it will be encoded
-///    efficiently as a numeric segment, and appended to the URL.
+///   will be encoded as binary segment, otherwise it will be encoded
+///   efficiently as a numeric segment, and appended to the URL.
 /// * `data_len`: Length of the data, that needs to be encoded, must be less
-///    than data_size.
+///   than data_size.
 /// * `data_size`: Size of data buffer, it should be at least 4071 bytes to hold
-///    a V40 QR code. It will then be overwritten with the QR code image.
+///   a V40 QR code. It will then be overwritten with the QR code image.
 /// * `tmp`: A temporary buffer that the QR code encoder will use, to write the
-///    segments and ECC.
+///   segments and ECC.
 /// * `tmp_size`: Size of the temporary buffer, it must be at least 3706 bytes
-///    long for V40.
+///   long for V40.
 ///
 /// # Safety
 ///
-- 
2.48.1

