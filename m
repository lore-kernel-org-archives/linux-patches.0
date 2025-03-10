Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5062309A6;
	Mon, 10 Mar 2025 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627254; cv=none; b=l4BjYcEqxAKdz0H226NnuW56xbn7odLdxTRHK+/H6kiy/qJ94EhCzOWIpNx3DvnA8FSMQeERga/9J277eOoU9LU3P2GFlEPalezkov2evq8LkcVdoibuasIBRiJlF8OynFYb9fDcI3k1PxRsj7zbo5fjCfmoUXpwDY4Js71o7TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627254; c=relaxed/simple;
	bh=98KLdbtqEGHh4X/Tub5oYjSICi+9Fu46SWiosWdg1fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAoiOKOW/u5Ydfd7Mdo9DkijdRyFruHQaRIHPTIMOuzIMU0M2chZcdFc33I6lWFJa1LXtiZHglrrocKBDFgpaTOPahINSsj5EAg6gTSsDsnrtv403yU7CSVUIJMs3k9h8fnw7YiFN1eWeRad0OIe79kBVqwy9sN4WS9Tujii+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grlXzNPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grlXzNPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADCAC4CEE5;
	Mon, 10 Mar 2025 17:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627254;
	bh=98KLdbtqEGHh4X/Tub5oYjSICi+9Fu46SWiosWdg1fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grlXzNPmz99zKRzvxhK2zl0RE3dqhyfU4ahf8TjgXVDc+TlOe40lh8Ivly+NSkDcu
	 8oa1m6I/P0fkEUOIMtSNQv+J8M4W6HeknG3YoQOz64J/eBSG1mGkqCKjnxYaMm+PQ9
	 XbLZIEUTya0m0EZgaMuLHEkCIrFvQFJIiWCLZ6vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.12 066/269] drm/panic: allow verbose version check
Date: Mon, 10 Mar 2025 18:03:39 +0100
Message-ID: <20250310170500.360739484@linuxfoundation.org>
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

commit 06b919e3fedf4798a1f0f60e0b67caa192f724a7 upstream.

Clippy warns about a reimplementation of `RangeInclusive::contains`:

    error: manual `!RangeInclusive::contains` implementation
       --> drivers/gpu/drm/drm_panic_qr.rs:986:8
        |
    986 |     if version < 1 || version > 40 {
        |        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: use: `!(1..=40).contains(&version)`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_range_contains
        = note: `-D clippy::manual-range-contains` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::manual_range_contains)]`

Ignore this and keep the current implementation as that makes it easier
to read.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-8-witcher@wiredspace.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -982,6 +982,7 @@ pub unsafe extern "C" fn drm_panic_qr_ge
 /// * If `url_len` = 0, only removes 3 bytes for 1 binary segment.
 #[no_mangle]
 pub extern "C" fn drm_panic_qr_max_data_size(version: u8, url_len: usize) -> usize {
+    #[expect(clippy::manual_range_contains)]
     if version < 1 || version > 40 {
         return 0;
     }


