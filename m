Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECE51F76B1;
	Tue, 17 Dec 2024 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456343; cv=none; b=hkr0Ffz+aA5nufepSslPEGLHnOuJ3VCYOx/hm/IlnIVaezh/qyz8NGXUf5HoWje3X9z+hof0cQ/DGqCim5L4H/Dxvyx+AXoGIhD3lS9LWl8ASzPG2MfHwBIzNmmyB+4lPZX4HnhE58jM4g1uIT5sipW+TyHccTpWYcMsUIPEIhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456343; c=relaxed/simple;
	bh=Sj8fkh/lMRUtgPX5O5gbYQHj6iyWvPrUjFJDi/jSxeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVB2aU0+5BDPAZDIadawjqn19MBUD6EkZYVrxlzaBNHzONU5VEB5+5JoV0eGNpjXB2ILly+ppDAhOYdGL+rdNFA28sflkWTr8sPPePXh/YbwKa3ZnsNpnPVR9X847adM0HswSQfE8jS/PxBSR0h06E2w7wkCHJkUVPFXRV5dtGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wL2Y+T3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wL2Y+T3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD40C4CED3;
	Tue, 17 Dec 2024 17:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456342;
	bh=Sj8fkh/lMRUtgPX5O5gbYQHj6iyWvPrUjFJDi/jSxeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wL2Y+T3eazJvUf08F0t2hfyx9QZj+6s8K4JlKjEnl2gzVs27LJ/3XFmn3dliZQBgF
	 Z+vHC+ww0hODA4s6jHXlfRYbE9BHsaWTDY2t3xV7hEeDHY55oiUp/Kz7/5ZOGjxCP1
	 3kSANa8XajZdeLOe6HDtEg9+JSaqtJFXawliIp3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 029/172] drm/panic: remove spurious empty line to clean warning
Date: Tue, 17 Dec 2024 18:06:25 +0100
Message-ID: <20241217170547.472689754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 4011b351b1b5a953aaa7c6b3915f908b3cc1be96 upstream.

Clippy in the upcoming Rust 1.83.0 spots a spurious empty line since the
`clippy::empty_line_after_doc_comments` warning is now enabled by default
given it is part of the `suspicious` group [1]:

    error: empty line after doc comment
       --> drivers/gpu/drm/drm_panic_qr.rs:931:1
        |
    931 | / /// They must remain valid for the duration of the function call.
    932 | |
        | |_
    933 |   #[no_mangle]
    934 | / pub unsafe extern "C" fn drm_panic_qr_generate(
    935 | |     url: *const i8,
    936 | |     data: *mut u8,
    937 | |     data_len: usize,
    ...   |
    940 | |     tmp_size: usize,
    941 | | ) -> u8 {
        | |_______- the comment documents this function
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#empty_line_after_doc_comments
        = note: `-D clippy::empty-line-after-doc-comments` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::empty_line_after_doc_comments)]`
        = help: if the empty line is unintentional remove it

Thus remove the empty line.

Cc: stable@vger.kernel.org
Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Link: https://github.com/rust-lang/rust-clippy/pull/13091 [1]
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241125233332.697497-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 09500cddc009..ef2d490965ba 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -929,7 +929,6 @@ impl QrImage<'_> {
 /// * `tmp` must be valid for reading and writing for `tmp_size` bytes.
 ///
 /// They must remain valid for the duration of the function call.
-
 #[no_mangle]
 pub unsafe extern "C" fn drm_panic_qr_generate(
     url: *const i8,
-- 
2.47.1



