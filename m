Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07580268683;
	Tue,  8 Apr 2025 11:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110592; cv=none; b=Zo4KFrv0D/Rup9byVhgsaifC+v+cRcLOOcakI4qCo9RskyTDc8sGyojogguirHYNa6658qyZHaL5V2Hw27Tj15bNcasX0pbxJRxBR6UtUfXYii2/VP3st1796S7NBXAC77+kfNjgtPOJYm0vB+Mbx4AfzMk90ji/Bfh0xZii8vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110592; c=relaxed/simple;
	bh=1cSH32IrmCWzHIhpd76EFJH6QQBvWZMGodAiv72Rqiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5SU+hsUt8lZlyM8NXoErz4lmF90iiyHe5axBBoGGa0HNwtKolqo/Oj866861yGK9+XA0zHlAmkpv/7ysex1E0yvb9cDGBA/fscfzELQB3pkiUr/Mw6pn/Itcf8XIkO9KSCcq0fISixolZH9PPp4vayDj9FObHngVwDyekEUANY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYpxTCYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYpxTCYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C07FC4CEE5;
	Tue,  8 Apr 2025 11:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110591;
	bh=1cSH32IrmCWzHIhpd76EFJH6QQBvWZMGodAiv72Rqiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYpxTCYTUUMmzwrYw8BZxJLE0SlAaO8TMritEChLLKKcS3+ld12js5HoLctBVnDg2
	 iAo7erno2O1etI/8u9R5aNgZqZ5zftOtibWjfFGoC1MR69l0Fm6s8qpWXx+yO+K/6c
	 GthrRENua3VgcJ4D0eGtylbYdKH9xR2nOALpOcg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 120/731] wifi: ath12k: use link specific bss_conf as well in ath12k_mac_vif_cache_flush()
Date: Tue,  8 Apr 2025 12:40:17 +0200
Message-ID: <20250408104917.068639552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 11d963d44c77261d6a948f3745bbd678eef4b83b ]

Commit 3952657848c0 ("wifi: ath12k: Use mac80211 vif's link_conf instead of
bss_conf") aims at, where applicable, replacing all usage of vif's bss_conf
with link specific bss_conff, but missed one instance in
ath12k_mac_vif_cache_flush(). This results in wrong configurations passed
to ath12k_mac_bss_info_changed() when the link in question is not the default
link.

Change to use the link specific bss_conf to fix this issue.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Fixes: 3952657848c0 ("wifi: ath12k: Use mac80211 vif's link_conf instead of bss_conf")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20241209024146.3282-1-quic_bqiang@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 2d062b5904a8e..9c3e66dbe0c3b 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8066,6 +8066,7 @@ static void ath12k_mac_vif_cache_flush(struct ath12k *ar, struct ath12k_link_vif
 	struct ieee80211_vif *vif = ath12k_ahvif_to_vif(ahvif);
 	struct ath12k_vif_cache *cache = ahvif->cache[arvif->link_id];
 	struct ath12k_base *ab = ar->ab;
+	struct ieee80211_bss_conf *link_conf;
 
 	int ret;
 
@@ -8084,7 +8085,13 @@ static void ath12k_mac_vif_cache_flush(struct ath12k *ar, struct ath12k_link_vif
 	}
 
 	if (cache->bss_conf_changed) {
-		ath12k_mac_bss_info_changed(ar, arvif, &vif->bss_conf,
+		link_conf = ath12k_mac_get_link_bss_conf(arvif);
+		if (!link_conf) {
+			ath12k_warn(ar->ab, "unable to access bss link conf in cache flush for vif %pM link %u\n",
+				    vif->addr, arvif->link_id);
+			return;
+		}
+		ath12k_mac_bss_info_changed(ar, arvif, link_conf,
 					    cache->bss_conf_changed);
 	}
 
-- 
2.39.5



