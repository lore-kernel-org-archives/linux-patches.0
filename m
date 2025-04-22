Received: from puleglot.ru (puleglot.ru [195.201.32.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31301E3774;
	Tue, 22 Apr 2025 12:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.201.32.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745323431; cv=none; b=eIE0Gip8sgF2HocvSxsHikCa4+UczwBPhyJrOG0YYsUHRyM+cZwixGk+rw58Pc4s05KwkWGvWpEsrkgCaSzFgdGbe235QU59h9/CGpw5qkle/IKQVqQ0mgzjp7nVhEBKud6SHjqmDoGaKbhCRFr/TGZ3P8bZ8jxu5PYDKWBo+MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745323431; c=relaxed/simple;
	bh=ucgWyBEz+VTbf17a28YZqyTJTnkHKpYJv8zAqsv2wDE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I458seHvFGFVaBlivxBEvw/DSx/ul7tCJSuxmlMM6zv1Rz81Gjc0QzJ34bwo7lYP9iXwkFpWNvu3By94H41nxgHcpMVutCKXShpxg73R23eb16tD6nCm5Y89d+uJZlrHpX9CtWkE5bTE9La0O6IhZNK3EwA1LBZzUNpiC5bNQbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me; spf=pass smtp.mailfrom=puleglot.ru; dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b=Wa2ekC7U; arc=none smtp.client-ip=195.201.32.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=puleglot.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b="Wa2ekC7U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tsoy.me;
	s=mymail; h=Sender:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:
	Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rJDFoilPCMQyI0+upHJ16GI1G8HcJRKfF722FDf60lI=; b=Wa2ekC7UEor8Ft9ilfFU2nBxK2
	t7qzRS2Jb7x4YI6daiZx6k2P2RuhBZZVzbOsVM5Bg/vb3RJfpIzSoh/M4mPxGEv7URaORFhtK1iMb
	uHPNOFGb/yFoAwIPfx0cBgNCPvAK9gHN/pmM5aupbf4ww9ybDZWEJ+N/JBAyXbfOzvNk=;
Received: from [62.217.191.235] (helo=home.puleglot.ru)
	by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <puleglot@puleglot.ru>)
	id 1u7CLr-00000000DlW-2kVF;
	Tue, 22 Apr 2025 15:03:47 +0300
From: Alexander Tsoy <alexander@tsoy.me>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y v2 1/2] Revert "wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process"
Date: Tue, 22 Apr 2025 15:03:37 +0300
Message-ID: <20250422120338.229099-1-alexander@tsoy.me>
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
index 1706ec27eb9c..5c6749bc4039 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2533,7 +2533,7 @@ int ath12k_dp_mon_rx_process_stats(struct ath12k *ar, int mac_id,
 		dest_idx = 0;
 move_next:
 		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-		ath12k_hal_srng_dst_get_next_entry(ab, srng);
+		ath12k_hal_srng_src_get_next_entry(ab, srng);
 		num_buffs_reaped++;
 	}
 
-- 
2.49.0

