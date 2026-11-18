Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039448;
	b=KOj2EfXqCTqEmFvqjfZS3cs6hgumdBUjEfKqToE6y2mbRNlw1aOAFG6zCp36ZbxxMUY6
	 UmBWQ8hYOcDUC2QVzNq6zrONT7SoxgUjxd8V/SP4swJN8k0hlgNWmp1tUp72XBoqEdLEH
	 a8/rywF5ihQBeGsXWy3hhfQ36o56vFAx+rGjm9DdfFuGYJRdrOdSDOVfkiQKvL0Ft2bDi
	 GNmYTDYw9C/eghqy/i/Li0IMLVX3oNhiHpR8JX93ZdVSY/FRPnKC3GF7sI7iIWeOXFTXL
	 /D2TVHbLPZn0TpVIvdQwm2118XqpTl5xucqGpam93I+dSrpEpA+EOLM5ElwYA21uO0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KBy7mRxeryh672nljBEY3NoPlvLqxs6G3RaRTyPF1Io=;
	b=KjpvVnODpHAX1gimsqGBDmDFxBLjzijH/7GQcv4iHk2S2kmHN4bCVw52SAAg1o2XdiDi
	 6gzsKLOpIeJCGkwPkE1BVA2+aawsQRf4Mp8kea0evxRF07wydDdEgeN/a+bhdf3Jf4mIY
	 MwZEV9ztY+363oqxaebseN6MxNHZ7UV1wilAua2rgmmSxgZZB4YOPe+bCKc4mb+Q6oU0D
	 OtNX4hamX1xi6D+ovVLHCq7OFZ3zctYwI/MS0evEUrNSlqdWB2VGcVddVFcpMKNcwQaa/
	 Tek2w2l231JRZwNyE2r8VxzYd9ksSzaW/RdVonH2W5MVzREw9PEYYozLd6enNsBefHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2m7L9cp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528E9606A31C;
	Wed, 18 Nov 2026 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2m7L9cp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE9F1F000C4;
	Wed, 18 Nov 2026 22:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039448;
	bh=KBy7mRxeryh672nljBEY3NoPlvLqxs6G3RaRTyPF1Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2m7L9cp9+UWrqR00Ax6ytaAdhEIJHpmos71v62Z162RX2r9abU/NTnMK2QTU54hO
	 4Wrxu37S5a4IYRAss2rACoMcPdjNIiCplXYDsNX1vBcpdfhU/PwfGwq0SeINujrIee
	 cuZPaD4HF4z+wwYXsunwdaVh8kZUpn9aorPD2ZEw=
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
Subject: [PATCH 6.6 2105/3318] wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()
Date: Wed, 18 Nov 2026 15:45:27 +0100
Message-ID: <20261118150425.230076310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39d9aad33bc69..7f2c91fd7ab3a 100644
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -324,7 +324,7 @@ static int ath11k_ce_rx_post_pipe(struct ath11k_ce_pipe *pipe)
 	dma_addr_t paddr;
 	int ret = 0;
 
-	if (!(pipe->dest_ring || pipe->status_ring))
+	if (!pipe->dest_ring || !pipe->status_ring)
 		return 0;
 
 	spin_lock_bh(&ab->ce.ce_lock);
-- 
2.53.0



