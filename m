Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015834;
	b=R/YgzWSfYy2hplUv5/N2WXULlrr2J/I7dZ8d4bARXbkvx/Qm1hS3XuyX0ziMPcnqGz5t
	 k71sNdrguZLaDOpCRTzw1fOL46BOWaqZNOz+AUvksgrhqiarAGtEFpjT5IMfSZg3WGMQW
	 oqL6HalepL9XCJ5/JZBa/EN9dF2R3rlJOlw76Kd3zkukdiusBrLR1LBhQ27iYG6ZNNEVG
	 WVuJb8PEzIoyqHGPSF/WLZX6Br3Vmha95SHNdmecUTAUbEQ0suTGZmuNbnY5cEXLZ40KY
	 T/Ziae52o+Fypoc8rRpLcqKwlx/IfdtmpzIe0H2voxShwvdTP/mbayg8NArVQEUkM3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zIfaAGqvHmRqw6+/JfP58lSXWq7buYaIQRNDyuvjW6c=;
	b=TfDU+VSnlA4zdAyrVJB9QxyRMKodSqz5/p3VxhF2i2x3s5XgamzM13F6oW94qURDV3Qu
	 rau4JWRwLeCE7xKRC6eXK0EwEw8NxddGGldTFA2V21x2esx+FbHBo5KreudFfUpYBqoWJ
	 96Lm/Rf6Uhih5ZJC5xohSUAFDPuoM7pU/d8lESlvAJhxXj09e7kTiJBjzq1eO+AsasyvU
	 52RRQpFgrJ+uvj+eloy+zhvLyBb4nMgadyZ7TPSGiIoYnOrACQCWgg5MayFciOLNxb4t0
	 tfqDkDV3e8X5pVHWA+zxZwiSIzU+sq23wSUG6VX6lB3S9afsAau1hGhtXqFwVr4elzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fpFxer/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBC6606A32A;
	Wed, 18 Nov 2026 15:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpFxer/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958BC1F000C4;
	Wed, 18 Nov 2026 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015834;
	bh=zIfaAGqvHmRqw6+/JfP58lSXWq7buYaIQRNDyuvjW6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpFxer/gWKU10NgWY0YgUfej4inIMxtYJkRpGSopZov4xUGv3A7zFvhOwNyJMLuSx
	 UejZ2S+mBJ62N7zoUu+KQIF+utywIs+MLcgNT60po4TJ/XKtMu7BOxj/Aj7suIPK+J
	 qO4w9HbQONiSED/eLz4gBtaHpRVYDfRh6wjf6KAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0314/2651] wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()
Date: Wed, 18 Nov 2026 15:25:54 +0100
Message-ID: <20261118150259.188214315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

[ Upstream commit 52953d149ab4da0432d54b09f3c8add42b4d4a82 ]

The previous logic in ath11k_ce_rx_post_pipe() incorrectly required both
dest_ring and status_ring to be NULL in order to exit the function.
This caused the function to continue even if only one of the pointers
was NULL, potentially leading to null pointer dereferences in
ath11k_ce_rx_buf_enqueue_pipe().

Fix the condition by modifying the logic so that the function returns
early if either dest_ring or status_ring is NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20240909150824.28195-1-m.lobanov@rosalinux.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/ce.c b/drivers/net/wireless/ath/ath11k/ce.c
index c56dd8a867606..1e08b0970b148 100644
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -325,7 +325,7 @@ static int ath11k_ce_rx_post_pipe(struct ath11k_ce_pipe *pipe)
 	dma_addr_t paddr;
 	int ret = 0;
 
-	if (!(pipe->dest_ring || pipe->status_ring))
+	if (!pipe->dest_ring || !pipe->status_ring)
 		return 0;
 
 	spin_lock_bh(&ab->ce.ce_lock);
-- 
2.53.0



