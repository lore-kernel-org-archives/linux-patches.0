Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047998;
	b=TS6kwUxSrHUm17kNx3p95IA6hxHrEe7xoW2Q4OqaBLVPWdRM4MpalsieQzrWXIruQnbJ
	 Iw+NHt9mVEQ5AYGu6D0qD/EF/ElHRKiSmfmKIHY1nDNvWnB9g6uyKf16EWx5dTAieM/b7
	 2v6PUnK8gxhe7wL882VV4V8X02h1fmflF4EsiU9e9LniDky6o2TyISZPs8jG4KN81nRTc
	 he8wVk7XG2r5eJmPfkSF2sO8jheTRDE/Cx1oZBcfr05jevI8WWf0HDAfdSj7sGy51fE+s
	 H3eU9w8gal7Aa4Yxef8XmOX49kjuIkSUzoTZKzulvmco4ADKT3LWSfUOn+T5i79XPnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9+t/t3axdVCvglf98xQPjWJVLnJRIzHUeGUGQkCox4=;
	b=cO3sFMFtDpVO4BS2xl5S4SPe0V1FGF1ba7DTZif3XKMIVtamp03Nh0O81Pifkk+/KfAK
	 gTh7F27PYflTEowDYr/teyel0QZ8zOVjOVuVzRvq6wC58ows3wPb1ffVYfEzj85O7hfqE
	 bUm7Ol5WKRUDSr4/6lfiyXOULQbTL3HleCH5N61FsSv8rKtGKjOIS5JHakF5VYIksahbH
	 WfqNp71Ihc0QHPhqTBGfU/zIrv4yBpQ04bTLQWyEP9L0QvOhiO2MtUPxVK0qWY6uiGalL
	 ZYInPP2gyL3+QLjAXCycM/zNs/ZaapVJQr0PrJE904OJFXjgwCtJZ3C8FNmVuu8GMnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbXfSycS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57598606A31C;
	Thu, 19 Nov 2026 00:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbXfSycS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E431F000C4;
	Thu, 19 Nov 2026 00:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047998;
	bh=L9+t/t3axdVCvglf98xQPjWJVLnJRIzHUeGUGQkCox4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbXfSycStcJwwKJSetsCIJr4en1NbWS7c+Xa+nPe0sSpU/C2CNqbFbDPQMR4I5f9y
	 7owLNfq+7PB64ecIe2BFcrHuPrTycgmNt1UW/+yog4xuhHfI35cl/ohvwq0IR+AFCn
	 ROCoh9Q82E4+xyZDm60Gu9REppukQ9B+OdfqE/g8=
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
Subject: [PATCH 6.1 1838/2857] wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()
Date: Wed, 18 Nov 2026 15:47:52 +0100
Message-ID: <20261118150307.427765453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4437889f1593..c6970ef7ef9ad 100644
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



