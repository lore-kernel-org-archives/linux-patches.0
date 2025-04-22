Received: from puleglot.ru (puleglot.ru [195.201.32.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF751C6BE;
	Tue, 22 Apr 2025 12:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.201.32.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745323372; cv=none; b=K8uGj14Dzk1Hbadi2cNZ2+Zp88XMHw3Xqi2zRiFXe0l2nUtb6iynCXkCS2oVzpYuGV/jpKNKieYfDPs/qSI+2sRm2RCyu4cOayiTTAd1FRS5YFl48vYWRqvRvh9HjH5gH5rDwZbf4FLbQDLeGADEt/007XgXHENWF9z9rCLTuqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745323372; c=relaxed/simple;
	bh=gyl9KVicNABvf37wO9ZZNR9gMYedHtD3n4y/dS3YyK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NoFnWj3JtKDVp/RUyk1ueGJEIw4RngyF77uyoqKavYz5SLD+BXhQ5x9CZQf8ZksmaQJe4nZO/CAJZTIwr0l5XsqGEEGvXqXc4hCDI9R83qKK1SjbL2Jhf1q7TqIlCN5xM916bTkPSXsXsi7YI/105kD/j7w2uits9cMJ8Ip5ac0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me; spf=pass smtp.mailfrom=puleglot.ru; dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b=pnYJmDas; arc=none smtp.client-ip=195.201.32.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=puleglot.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b="pnYJmDas"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tsoy.me;
	s=mymail; h=Sender:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:
	Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RBNs6g9maJzfpVFuu0S9MLSMgx7H34SspBtD3ju0gcE=; b=pnYJmDas5MlrWahBmreN3NRXhm
	Gup6JzuUglUc1dfbzgjWDHrBLQN9PFWDd5dHp1To2oxUR7lJHp0GzvV1ZtqXCXWTwk7ZZ0UpnstCK
	jYWvw6YHIH6UPOIn7Rv7HyI6uUiQUpl0XM36NkkwtAhyi8F56eBRdo+dCavifpMZXCi0=;
Received: from [62.217.191.235] (helo=home.puleglot.ru)
	by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <puleglot@puleglot.ru>)
	id 1u7CKs-00000000Djl-3p3E;
	Tue, 22 Apr 2025 15:02:47 +0300
From: Alexander Tsoy <alexander@tsoy.me>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14.y v2 1/2] Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"
Date: Tue, 22 Apr 2025 15:02:36 +0300
Message-ID: <20250422120237.228960-1-alexander@tsoy.me>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: puleglot@puleglot.ru

This reverts commit 0c1015493f0e3979bcbd3a12ebc0977578c87f21 as it was
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

