Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051081;
	b=ifr43vOOWz4bD0q3qc96fIMFK9OKYnk4n5KqtxQDHGxiTbwhpfXZVoUkJ9y4Z64GjW+3
	 PU2J/W/rkXtcioJDipmkXnyqdo54bs1yEVZtg2WHVYMmqg5tZoYI4LvSAyTEZO8OyTRyL
	 KeiEargyw/ywDWlh9ZT68AX/mTWVJTBz7UdD7p3JRM1a384NhQyzCNaI4bqQCK/IdH4aU
	 PWORO34ufJfvR2JmaG63BpM8zUYvIqxn8ZhL+9hnGKyJEd8c/YLRuEH4hdvbDDvGpGh2K
	 HUxLj0TTBm4ZM8Xbj2h/Y0aXzZl8syYIuRBvnXLmWHf+Vbxa4zc8lzd9yERO1SJMaRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ka0dGFC4RCtiwLRiTy8Ymt8PVIPAwq8lF0qYBm82Nek=;
	b=wqWicb68y9UnTNWkb9D0L+1eMJIFAK7Zh8nE+rj+YDN6d8hrxtWTfxlA8WQesG7FzCfO
	 AJ3bwFHN7594KSQhNewl2Gc+L2t8JUY8MMFWxztUe/uk/A/XWTicg/p4u2fOAsAxVXwE0
	 e9DJlKsttdCwsM4QMbQxro7hZjIxOHv0JDsJdBpBWGJIVlrIhBf1Joxc3kDii3PFdwQ8j
	 0doU9vy3aLVm5VKoKcAEclLax0LYoTRyDbFTu2NtXl1AWnMrWzFgT/3jum7YKiKF/3Ifv
	 xhqf2Ry1KXg8ZmNATgC1CtvzwRS9jd0HcLtwpuaq9/yk/KJ92Tc71s68XvyzsXw3HSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrzacMVK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F11A606A31C;
	Thu, 19 Nov 2026 01:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrzacMVK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B455B1F000C4;
	Thu, 19 Nov 2026 01:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051081;
	bh=Ka0dGFC4RCtiwLRiTy8Ymt8PVIPAwq8lF0qYBm82Nek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrzacMVKGwi0TxZ0dUq+AeKfDz9+2HLnhYZv9rxog0xArt2ekFm3430HyUZhrE0q3
	 llEcvaEABIh+6Y1bMCqSWegqIBSeTDph+LrHygdjFNsHE1jx/YmTTtxnqR3a0hTNzb
	 3ShwiUDu8jHoZ6c2F2Lt8N3EvT13UofEsxyea8Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0080/2214] media: ivtv: stop VBI start-code scan before short tail
Date: Wed, 18 Nov 2026 15:29:16 +0100
Message-ID: <20261118150013.203596974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f373cf17fb8e7a530bc6e1e36fc41cb5dab2cdaa ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtv-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-vbi.c b/drivers/media/pci/ivtv/ivtv-vbi.c
index 80478b026d752..279a4d6bece19 100644
--- a/drivers/media/pci/ivtv/ivtv-vbi.c
+++ b/drivers/media/pci/ivtv/ivtv-vbi.c
@@ -330,7 +330,7 @@ static u32 compress_sliced_buf(struct ivtv *itv, u32 line, u8 *buf, u32 size, u8
 	unsigned lines = 0;
 
 	/* find the first valid line */
-	for (i = 0; i < size; i++, buf++) {
+	for (i = 0; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] && buf[3] == sav)
 			break;
 	}
-- 
2.53.0



