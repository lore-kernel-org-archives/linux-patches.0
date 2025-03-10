Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D8C22154C;
	Mon, 10 Mar 2025 17:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627249; cv=none; b=C+dSaL+DoAelkNzKqodhTRj8afrevcd21DwzqRFFKewEv8/aDnUmXQZRUo7dzsYaCvgqCHdBVKmyv3wqY6kZ7hfFClYAb2oLHz0eBAIXh/Ke7QEhj+qixfw2arLe587RvQB9dqA+VZH8Y3EPL50l4Swyjf0mexwOjoz/T6PqoQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627249; c=relaxed/simple;
	bh=FNMe60scxyNNdl+KMpWpy794ZtLZgcxWrSIH8vUw5hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cYY2E3le0HePikhx5k3cWQU+BTH6UxTjcEf2A9Vuhw81ombIwEjnRM9FDxQDVKsJrKbjB27bYDi/776gySbxX47318SlSC3vjWQ+k2gH4sEkJmfE625cr0fM5bWLrs5OD/TgYB4jwKvoeV8uYrph/XO1sctS2eqeQ9ScTrLDZrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXHK6182; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXHK6182"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94247C4CEE5;
	Mon, 10 Mar 2025 17:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627249;
	bh=FNMe60scxyNNdl+KMpWpy794ZtLZgcxWrSIH8vUw5hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXHK6182Nfa65t692idTvW24xd0YqkdSrUvLbXHzsC+NlbrPkq5He71qD8uhUJrXB
	 g27D7GPaWV6135xGvZfpblj28rrsaVtFiQkOwg4afEUTqVR2GdrDPtjsUN6vY8bQui
	 ineu1K5sa8MVlWQntEuEFZTHKSyJwXy242Y2L7oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.12 064/269] drm/panic: correctly indent continuation of line in list item
Date: Mon, 10 Mar 2025 18:03:37 +0100
Message-ID: <20250310170500.281467014@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Böhler <witcher@wiredspace.de>

commit 5bb698e6fc514ddd9e23b6649b29a0934d8d8586 upstream.

It is common practice in Rust to indent the next line the same amount of
space as the previous one if both belong to the same list item. Clippy
checks for this with the lint `doc_lazy_continuation`.

    error: doc list item without indentation
    --> drivers/gpu/drm/drm_panic_qr.rs:979:5
        |
    979 | /// conversion to numeric segments.
        |     ^
        |
        = help: if this is supposed to be its own paragraph, add a blank line
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_lazy_continuation
        = note: `-D clippy::doc-lazy-continuation` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::doc_lazy_continuation)]`
    help: indent this line
        |
    979 | ///   conversion to numeric segments.
        |     ++

Indent the offending line by 2 more spaces to remove this Clippy error.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-6-witcher@wiredspace.de
[ Reworded to indent Clippy's message. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -975,7 +975,7 @@ pub unsafe extern "C" fn drm_panic_qr_ge
 /// * `url_len`: Length of the URL.
 ///
 /// * If `url_len` > 0, remove the 2 segments header/length and also count the
-/// conversion to numeric segments.
+///   conversion to numeric segments.
 /// * If `url_len` = 0, only removes 3 bytes for 1 binary segment.
 #[no_mangle]
 pub extern "C" fn drm_panic_qr_max_data_size(version: u8, url_len: usize) -> usize {


