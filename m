Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5B52ED87D;
	Tue, 17 Jun 2025 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176147; cv=none; b=cmEErSIfRaGFQGNyEf2izUdkgXuMtCp9yzOY0JS6pIVkdSe353ozPvXMlKIs1ZlwOh3TWLMKC2AURmwqCgPW1MIANntMGFIZNPghx9KfhrQVlINeYCfH3Ym8OHhgoyaMFDmEAPwdyFGrhMwGpPorXt62B0MjfNyd5CmKkZ+JKEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176147; c=relaxed/simple;
	bh=nI+fMBXKc10Vdbv/Fs0COT488y7fUH0K3Av+/I1YUbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEWpoPaKZd080y0q+60e2tHd5IHId5thWIa60Pv+nCqmbg+tfjASgLt/SpAAMa56kgmfRYUw6PYr0xVDYqh5dC9ZVqitNwnrZddp7Ko/idmouVdWChWajtqxProilxK5Cx9UqYOKCmxgNxuq6WUtLtLDrKMa3u1hgFrRUQoBMKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhCEcZdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhCEcZdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EF6C4CEE3;
	Tue, 17 Jun 2025 16:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176147;
	bh=nI+fMBXKc10Vdbv/Fs0COT488y7fUH0K3Av+/I1YUbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhCEcZdL2M5oFCTjUVeD/XASsG8JdiRGLpciAmK8E6BlOnodeiCSziBNdzd9zzlJp
	 con43V/hS/oRPIk//cB9uKfPjZGbI51vqrH7XuEzQNoKCo5zcRWVkmBS7VacZax1nR
	 rJfTn3U7l9jl3IpnGLetezybfLtZn2aAK9u5Fv0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 159/780] drm/panic: clean Clippy warning
Date: Tue, 17 Jun 2025 17:17:47 +0200
Message-ID: <20250617152457.968072734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 57145afa3326947154c3a890b1118774b55212a0 ]

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
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250303093242.1011790-1-ojeda@kernel.org
Stable-dep-of: 675008f196ca ("drm/panic: Use a decimal fifo to avoid u64 by u64 divide")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index f2a99681b9985..ba6724aed51c9 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -415,7 +415,7 @@ impl Iterator for SegmentIterator<'_> {
                         self.carry_len -= out_len;
                         let pow = u64::pow(10, self.carry_len as u32);
                         let out = (self.carry / pow) as u16;
-                        self.carry = self.carry % pow;
+                        self.carry %= pow;
                         Some((out, NUM_CHARS_BITS[out_len]))
                     }
                 }
-- 
2.39.5



