Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023286;
	b=Ec4J9awdm7e/QBkxsgu5KLeO3QN3W1wpqktb7QIa6tKUAQS9AaQ7lCBz60H0OL5O7UWN
	 jwvZTgdUDchuv1lALbBEezv1BlTJF2tLcOj9GEHI4wRc1TMhKaI5sNgkUqlKC6w9p6HTV
	 WUSYTV4idpXKFdQuiKTVgCgxQF9nPRXJRBw+Q7MhKnW6/23cwld/eguj+1XcJRc4F4rKs
	 Fg/k5WWB3rqmCb0VuIQES307jIlmE0tzH8aAkXB61//NXPMBkQqhxRedPTsjjmND8cAhh
	 ktOW6jy9STYs7QxsvefNEWGmlB8JPzlSTcrwjwBt6VZ6+FUUExk5W1duywt+fmZxxtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tDu7MIJuomlwTAQx0pnSncCLz3e7/UPy80JwOZvPhwc=;
	b=C/qExAzizrYOPPAdjLp85QlqNzlQqmyfrSUWTdZM0VuT9kAYjO+2iFXJQs3vlOm8viQX
	 yrHVOJaBcrL8miIn+O/6Daapf0yjgIKBykJ8vdYcsb2iwx0vbXEqiw9inrjzbEvbiAhLg
	 qf68+M6RQocZSZfZzWRsG6SSAdpkBxdYOdwOUhVv5N3jOi4z8R97KH6A5P5d5nj5L7YOv
	 hKxgnuUiOMX4qFf+/BcCpjeM+jIchCfbGlOhAUNIIUuVT6gOeAouCjvkil27wrgTHOASf
	 vlg7FnomVp55d9rmWLuit2urnsmLOrsGL1GmjJmLMgwxUz9TsKrEIcDIsqDmLX2E7vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HObQkS7O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0C3606A320;
	Wed, 18 Nov 2026 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HObQkS7O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198741F000C4;
	Wed, 18 Nov 2026 17:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023286;
	bh=tDu7MIJuomlwTAQx0pnSncCLz3e7/UPy80JwOZvPhwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HObQkS7Ow19Bmr+HdByx9jTkol9ipbZb/wp+w/0xVDTzZ07jGAk6J11e5xfspbQ2c
	 Ufb/fTpMWgNrThJqER0UGzk9t0+IuufMQD3YjO6hM75h5zeQrkgDyTn4lkT2b98mtZ
	 lOmXOZE0pCyTlwDpDojaVnoSWB8ITQFr93sFcWfE=
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
Subject: [PATCH 6.18 0315/2151] wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()
Date: Wed, 18 Nov 2026 15:34:10 +0100
Message-ID: <20261118150133.428423288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a7a163621b210..dd4f21a0db73e 100644
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -326,7 +326,7 @@ static int ath11k_ce_rx_post_pipe(struct ath11k_ce_pipe *pipe)
 	dma_addr_t paddr;
 	int ret = 0;
 
-	if (!(pipe->dest_ring || pipe->status_ring))
+	if (!pipe->dest_ring || !pipe->status_ring)
 		return 0;
 
 	spin_lock_bh(&ab->ce.ce_lock);
-- 
2.53.0



