Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29D1EC4;
	Mon,  3 Mar 2025 09:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740994391; cv=none; b=NiPv1PwMB8LpO+QkLoMMgUM1clrRNYC677k2+6Ru9ESBDOZFIJ67FX2LJveO/m64vGhc15hXltOhFT/gzXoqDwcC4tTgFNUf3k+rBxEFQzAmVxcbDNGOKFiwRJuLyhRQwry/BBFBJebHbLro99Fey6JagYHRtQEfdO+YM+BAGK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740994391; c=relaxed/simple;
	bh=uxWb5weZnx4w75c+cNd9geof+3mOOtF83ztdgamkHZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bw8nVXWp3rynnNr5wgMScj+rpi0MXrSNlRY6bK6POlCnqDt0iwMlosR4r0uF9O8o3pISRLaP0zNU8wjjVLAlhvV1nnZQ6Qla7gGvpS8Juy0fQeY4lKZWzEErtXZfp5wdlx8lE6U8bUf5EkzWffj8GLaKseVMlNWSFofb2xktZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zot24OU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zot24OU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E6CC4CED6;
	Mon,  3 Mar 2025 09:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740994391;
	bh=uxWb5weZnx4w75c+cNd9geof+3mOOtF83ztdgamkHZc=;
	h=From:To:Cc:Subject:Date:From;
	b=Zot24OU+Kr3IVKlNxS8Ms3Pi6PvMwu9DHSIsqRFgjxP7aaO6HBF+zxguPxwkhaO2a
	 xrdRh9uBrtzK+Ykgl393iwGLK8grS93jXMrw/M0Jj0oWxBTRY58YtHO+mmTaRseX2I
	 bwx01tB5PVV+suC6VLbWhT09Tqr1VNPpdd3/9dK4QlGfahn05Hh3Kp5xbqtzv3xwhm
	 O65rL/CJBPtzWDzv1AOWI5Q5YPz+w3dHiYps7UNc3zVcLGycvh5U026fbDNLbGuWdj
	 Bnj8SfZx8IFw+vKyH2xq2DVorZGK5IOZDXsua4NUVPxKkq4g9T8Y1Rw4H+/nn9pxqK
	 tcLnUaY4LNqEQ==
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
Subject: [PATCH] drm/panic: clean Clippy warning
Date: Mon,  3 Mar 2025 10:32:42 +0100
Message-ID: <20250303093242.1011790-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clippy warns:

    error: manual implementation of an assign operation
       --> drivers/gpu/drm/drm_panic_qr.rs:418:25
        |
    418 |                         self.carry = self.carry % pow;
        |                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: replace it with: `self.carry %= pow`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#assign_op_pattern

Thus clean it up.

Fixes: dbed4a797e00 ("drm/panic: Better binary encoding in QR code")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 62cb8a162483..3b0dd59781d4 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -415,7 +415,7 @@ fn next(&mut self) -> Option<Self::Item> {
                         self.carry_len -= out_len;
                         let pow = u64::pow(10, self.carry_len as u32);
                         let out = (self.carry / pow) as u16;
-                        self.carry = self.carry % pow;
+                        self.carry %= pow;
                         Some((out, NUM_CHARS_BITS[out_len]))
                     }
                 }

base-commit: c0eb65494e59d9834af7cbad983629e9017b25a1
-- 
2.48.1

