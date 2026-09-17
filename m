Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A194B4ABBAC;
	Thu, 17 Sep 2026 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661084; cv=none; b=ekIwhb8A5HIXUJfXwzWxEMwWKohGwxeTseSwvdzodsUcJBmASNgdyFuwHGIGVLSm/OBUxjtdpInd4JJHnU74E/on/GgPPqMszsgjXa5q/bFXHInK53xiKd3i1FWrId6myG6kBBnKYhGfdJpmzER/s8mlNOQA3HIFkwnMsgUWG+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661084; c=relaxed/simple;
	bh=BFd+lP5v7/h/qsGB/HRXMURthRNvsJjnGVr+JxgM0NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/WCBpSpcikBvr+yTISYtsk+W3UX+8bHttlXaNO9++9/R9N7cEx+85we8DV475YYiKaftpOHr8LsosTx4iJVpWcEPZkmvWEijU6STxpmva28ng/204w73+f2kCs/q70WxQyZTQXDjKhqdcjH2OGGSExg7RHiS+Z1VNnhlG6b22U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMUgYUlb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMUgYUlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92C21F00898;
	Thu, 17 Sep 2026 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661083;
	bh=LqNA+jmgY6Y2A9Roxx/lKDLP9yrtJup0rPZrg9HNNEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMUgYUlbIJNF9OJsUXsP6MSCWnJ70txHVIoT07+jdgHyWzo6XrCHV+QGUG4BJ77rO
	 OGHX6A7SZf92W6lLzk40cE/eLZtH57NInH32cCN5G+I5U73aNmj8vFyDiwsqufF6UY
	 OUr/GUsrNUgIMMt8Ar9Aq17g7aeQcCPm6Gs40cAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0036/1250] wifi: rtw89: disable HTC field in AP mode
Date: Thu, 17 Sep 2026 15:57:11 +0100
Message-ID: <20260917151552.914330154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit 1e53b826d5f8a3ca6d88fa6ed263acf54503214b ]

Disable HE QoS HTC field when operating in AP mode to resolve
interoperability issues with some stations.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260424072552.59220-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 3842b0e3bcb44..fa277c8e899fd 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -847,6 +847,7 @@ __rtw89_core_tx_check_he_qos_htc(struct rtw89_dev *rtwdev,
 				 enum btc_pkt_type pkt_type)
 {
 	struct rtw89_sta_link *rtwsta_link = tx_req->rtwsta_link;
+	struct ieee80211_vif *vif = tx_req->vif;
 	struct sk_buff *skb = tx_req->skb;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_link_sta *link_sta;
@@ -878,6 +879,9 @@ __rtw89_core_tx_check_he_qos_htc(struct rtw89_dev *rtwdev,
 	if (rtwsta_link && rtwsta_link->ra_report.might_fallback_legacy)
 		return false;
 
+	if (vif->type == NL80211_IFTYPE_AP)
+		return false;
+
 	return true;
 }
 
-- 
2.53.0



