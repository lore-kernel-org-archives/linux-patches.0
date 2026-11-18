Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060446;
	b=5hbRgLh56rD5Ozw7jyN757ZbsfqhvcaNPbw4yiuCbG0vOBwPuyn+uivajlOvWlIIiN3v
	 06Myfy090hjiXZpbAHCMrG1i6zws0g8JCrTHUlJGGT+z4WlaORd8azbzMcXjbsoR4Gc1Z
	 MpfXB13wvKQDLAo8SmE6skqG9hr6p/iq0hEg0Q/iAqegA4PsswdYoMhSty7h3m9igIW2t
	 +9Lu57jHUpl9lsbhDncQASRudFun+itDTnVLo1lC+jrqGoZdMkG22UzO+66zbiwDxDZ2c
	 F/t2stvKbycMXXToDBZDHFXXFGH4Gp7V7/Q+zjcYUWpvY08b1rFIJ6G4WPQellKt8GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WXC87CyswKd/nahpzrQqkdEkNNvtPG/qcrBkoyutBA0=;
	b=3OztIAclxnuu5GGVj/UxRivkLT+IaN12baSdS+Adypr1MOBpY4yRh7FkYj2PqWVKFA4u
	 MDTPmsiuTVYoD2vlPNbc4+wBkEpiNRJ9mXAIvSwK7552tFC9Rvv62zPVFmuvuqLLgiOQ2
	 B6FlCAGAaAEY/wd13nldSHR7LXutgJN6Io635S+vdYrhILAs9QTFebjflh8j5qQ+e21Zm
	 zj8jgRiDeZzGwA3gtsAXicA9GHVqu2F/hHnjjbAkJmUX0w4wOXjG1Pfa5rOqTEblftyCD
	 m58p8jcy6HB0M/P017pkR4jeWmXeOUDGQ754uy8mr+ZfR3ZNIgkdUpIWItTOlwA1mcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECURsCMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD531606A326;
	Thu, 19 Nov 2026 03:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECURsCMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F141F000C4;
	Thu, 19 Nov 2026 03:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060446;
	bh=WXC87CyswKd/nahpzrQqkdEkNNvtPG/qcrBkoyutBA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECURsCMvMc79KCOpmK0TDyG+LIGeUKfbkxDv0aBxDJQ63FBvTTSspgNv4IdG0BJzq
	 71fR+B6S2+YVe08zpKmoBCRZeZmUC38OLrxBROSlqM8SFlJJq+IIVZnRZaVeXHPWnq
	 OKOQSROzrM0YR8v8Llif5UJ495DuJF3N336sjYNw=
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
Subject: [PATCH 5.10 1195/1848] wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()
Date: Wed, 18 Nov 2026 15:53:53 +0100
Message-ID: <20261118150009.623502089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9d730f8ac8161..d36c3f11a5215 100644
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -263,7 +263,7 @@ static int ath11k_ce_rx_post_pipe(struct ath11k_ce_pipe *pipe)
 	dma_addr_t paddr;
 	int ret = 0;
 
-	if (!(pipe->dest_ring || pipe->status_ring))
+	if (!pipe->dest_ring || !pipe->status_ring)
 		return 0;
 
 	spin_lock_bh(&ab->ce.ce_lock);
-- 
2.53.0



