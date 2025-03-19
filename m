Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2202D21C9E3;
	Wed, 19 Mar 2025 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395133; cv=none; b=tTcodLksghak4v/pRPnEL6Qg+xIYpvfchsn4Z3vfl+zF0s3pW3j83KdQoSctbJUeNgptM1oalU2gyUGQM0Ly3hPp7MeTwJFXf3ZqB6T4dF7ERt5Wo2WXnPsd3eNaT/9Pqh+4JNSHqhym8apQ/LCj7usNNn/h3taIUxxIoGVv+Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395133; c=relaxed/simple;
	bh=WqE97WfV/YMA1xkJTJqj0ldvNKl0o8hIcwQ29LcGUGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oV45HHC/a8cpXhW2tpW+HcubG8wJf3rmbLm9UltSVeYLx8Kb99KeB79tU6R1hUwVuA/XvJigQSm1K8yQ5qRsAXtIPMf3MJysNsBBVOpyB0qT+5lxqnxiInyq17M/wHqPeE+aIQUygsnekkOlTW1XxmrlPZTaYbRZZw9HcxG2o2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwOORlWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwOORlWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C98C4CEE4;
	Wed, 19 Mar 2025 14:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395132;
	bh=WqE97WfV/YMA1xkJTJqj0ldvNKl0o8hIcwQ29LcGUGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwOORlWKjxnz4bPGKITADtUXKIHnK2zj1LX5ebn/OiVR4OUx80cTtBms37CKcwX9V
	 eEcroH65JxvLATwDXk6L2GeqijYXVLxJc3bD202V+5HXUIfmpQPhdU/7xIZe/hbuPY
	 0BQd1o24DK/Hg46zw/Qt/XOj39jJ5K4ltW5Q+UuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.12 171/231] drm/panic: fix overindented list items in documentation
Date: Wed, 19 Mar 2025 07:31:04 -0700
Message-ID: <20250319143031.067461343@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
 drivers/gpu/drm/drm_panic_qr.rs | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 56692c6be219..08b31d75c24a 100644
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
-- 
2.48.1



