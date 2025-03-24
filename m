Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301931DE8A5;
	Mon, 24 Mar 2025 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850261; cv=none; b=trsLw3N6TfwHu/tZk8c5XZ/lQynMlwTlK4nbyqB2LgJAI9K/JfI/p0SPsvqIv1O7EpFRDFqgIqb4lE9E845CcpIHmbA1BqvRGC6cXZGsK4YDBWA/J4tcDRlw2lGWdyOsmNWd/nW1RCmBCjKgbJ8T3XOZILDMdkbmfsxDmxFLXX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850261; c=relaxed/simple;
	bh=UzO1Is65wUucYlG6zCoHXjenv9hb72i1myTEfKlskho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnT0jae9uBqq+L9sqzXvuS/lybTXz3sIeP/vhMjlrKIXgAJ4JlXREVuJvSIJDOXBhyuY9TYgQ5qBT/EgcadSAuKeqHf3897W1+sVLhth0IGcfDs0raAZMWoXp7DdeZRd4e55pKB18LC2uS0xOLFLnIlnMRYH9MKYYd2AzvnEaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4+igZhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4+igZhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A75EC4CEDD;
	Mon, 24 Mar 2025 21:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850260;
	bh=UzO1Is65wUucYlG6zCoHXjenv9hb72i1myTEfKlskho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4+igZhqO54dAYRBs+zJfRMVWtgbX3T5GhiNbnXs2j0tPYqLG+wQIPB9QEOQscOkY
	 iU75GRTGoSJyxe3cTemmAeZOtKzoMCIVC4aOmjxLWSU04vEtHfSQnXcb/QNiNqjoDm
	 Fkocgl/3sf3EPnzVQXBLCfXlHMPEKCRkQSK7hKlNkN+/3ZdFlOhNWusk+0eoxsE6gD
	 Zif5P5Gl2WADshm8ZKGHe3NA7VECgcRFjzfkjrfLEDlij2jTbPWlCCA0Y0TeiJabnc
	 v2pAe+R+VGMYXGHjq0D/UMsugsk5DfPldgs6BFVSBYZnhKR1Vi1NlAH3M8MkA6T5ki
	 za/U0OzTFmC3A==
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
Subject: [PATCH 02/10] drm/panic: add missing Markdown code span
Date: Mon, 24 Mar 2025 22:03:49 +0100
Message-ID: <20250324210359.1199574-3-ojeda@kernel.org>
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

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 9bd4d131f033..a8f832598c70 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -914,7 +914,7 @@ fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
 ///    will be encoded as binary segment, otherwise it will be encoded
 ///    efficiently as a numeric segment, and appended to the URL.
 /// * `data_len`: Length of the data, that needs to be encoded, must be less
-///    than data_size.
+///    than `data_size`.
 /// * `data_size`: Size of data buffer, it should be at least 4071 bytes to hold
 ///    a V40 QR code. It will then be overwritten with the QR code image.
 /// * `tmp`: A temporary buffer that the QR code encoder will use, to write the
-- 
2.49.0

