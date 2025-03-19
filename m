Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0E81C0DED;
	Wed, 19 Mar 2025 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394952; cv=none; b=Z68/FvMLTRo9+NpLg1moJyh0NAhThY8RvZV/4JgNfmdIDJA6UWHcFghuls7zmCMqkpN9n/0EuIPxhCb5ye7JC5Wue+8RSFnWBhLsZWQr51Oszpk3hyetegSR1Kyj9OvsTBPOsDhQmVDSazdouHXEuW+eDz1ZUAqhDRz5k9YuQjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394952; c=relaxed/simple;
	bh=3AGL/Pp/i9e7iPobJEQOIqLVGJfrR7yGpR3ixzP+UQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewdKM8Of93UWyJBeUWSw60yrf7v0xkMQyXiacfTqfpxhQtMUhvaZEp7CSjtB9HL/le8ksYQ0rhzNvKD6g+f7Hl91tc+kxxKJL2ws/bmZ34NzlK9Q58g2ZwQ0J1434pqeJ6oNz8VjkesGaLX5xOnQ0QdNjzUBuHknQrFNcv2RYyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuffB8Vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuffB8Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8C2C4CEE4;
	Wed, 19 Mar 2025 14:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394951;
	bh=3AGL/Pp/i9e7iPobJEQOIqLVGJfrR7yGpR3ixzP+UQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuffB8VsvNCTKqlY+f1twaUBy1qRV1IscSiIMZFcATrD8MFHWs6XN2C0u6KKbpGEJ
	 z/PjYthZu8V4NiHp5gNgitwBODHJQUc5Kl1QdHJMwyN6PW+/puf33gQjj3VPB+UKTF
	 wEJMr3IgtsDcPIihFc0SI6xA0t/mHjir7j90CwwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.13 176/241] drm/panic: fix overindented list items in documentation
Date: Wed, 19 Mar 2025 07:30:46 -0700
Message-ID: <20250319143032.089678619@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit cba3b86974a3388b12130654809e50cd19294849 upstream.

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
Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Cc: stable@vger.kernel.org # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250301231602.917580-2-ojeda@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -911,16 +911,16 @@ impl QrImage<'_> {
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


