Received: from puleglot.ru (puleglot.ru [195.201.32.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708CE25F96E;
	Tue, 22 Apr 2025 11:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.201.32.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745320121; cv=none; b=e1QhNKQKxUA1eBTmA8jwbgSepxzJrTP1JicZr1QdQe2Y0Z3iZ3wtoF6KexUFnVXZ4y+BHbrENEjcS/qxbeio5H3m//RzRjwZGVJLUGiUbyJtAHTrcXLgdYc3qRhYHtdxb7hMTbY/8d/oGvRPOpTjGtb4EZYiAGlyjNTJwGlZa/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745320121; c=relaxed/simple;
	bh=bTbRjHLW4RYDoXywSjrId9RrYDDstxixJZbnuPkAtxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F25Jw3b0Yswg42A1XBp5+CdhqPrwNwV4fov11Byw7aDr06vowi3ScvvAEl1WObBvnKUA4OY/CHWciOfLooDni77eUKR86qtTeCA8hF3G7bEMmYAZY/Bf3t0J2bmD7iWQFPXHYuIMdz0AvATXYVXYq+xRFLyaeP3EJhjmctWTBXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me; spf=pass smtp.mailfrom=puleglot.ru; dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b=EQ4sid63; arc=none smtp.client-ip=195.201.32.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=puleglot.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b="EQ4sid63"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tsoy.me;
	s=mymail; h=Sender:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:
	Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aqKCm/NDqLH3/BaGR/hjH+ry6Wl191lmviTdQF8JQzs=; b=EQ4sid631Ebypjja9QTseDxdCe
	kIAKivRdn4RermaIbxamCaRgEYnaXl/6ve6h8W/tO69s6YlUc/bN8WFceTFBDV4G2Njxu+JI2669i
	gcqnsvTa4ik+lIX7G5XX96qN0we93aYugaU6Z5tXZ00k5K45UZC7a9A4wLlBqQy33RkY=;
Received: from [62.217.191.235] (helo=home.puleglot.ru)
	by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <puleglot@puleglot.ru>)
	id 1u7BUK-00000000CHf-3Sg4;
	Tue, 22 Apr 2025 14:08:28 +0300
From: Alexander Tsoy <alexander@tsoy.me>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12/6.13/6.14 1/2] Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"
Date: Tue, 22 Apr 2025 14:08:18 +0300
Message-ID: <20250422110819.223583-1-alexander@tsoy.me>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: puleglot@puleglot.ru

This reverts commit 535b666118f6ddeae90a480a146c061796d37022 as it was
backported incorrectly.
A subsequent commit will re-backport the original patch.

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 0b089389087d..8005d30a4dbe 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2473,7 +2473,7 @@ int ath12k_dp_mon_rx_process_stats(struct ath12k *ar, int mac_id,
 		dest_idx = 0;
 move_next:
 		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-		ath12k_hal_srng_dst_get_next_entry(ab, srng);
+		ath12k_hal_srng_src_get_next_entry(ab, srng);
 		num_buffs_reaped++;
 	}
 
-- 
2.49.0

