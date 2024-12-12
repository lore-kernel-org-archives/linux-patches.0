Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B9B221D93;
	Thu, 12 Dec 2024 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024805; cv=none; b=UF2v64cmcbnJherNWXkJGHhLJwJ5LNoTdYSwrhVf5WYHal2EXbf49FBMkqN3Q/VSODzwJvifyz0vO3PXwEvxO51q2zA1C19dlMMesRCpNQeBkrtw0D9B43QOH3zbYfPH8riOJio5PpAr/unHyb7UVt694gxL90pM1nV7w/hUvcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024805; c=relaxed/simple;
	bh=vZgYJLUnK6D68nLBhrGX2oU2PVWnTbdNcaxAqQokZdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVh+SxDBjLkEkbcx/yvWWSbMITVNlgY5z4+rF1jsmPZCAVO7hmVHIzMu4Xs9xlmOZF/hYbMbdgF3SkgUBmpa/vIozKejSoA60jgGzvEuaz5puDua+kcjCUjl/GkDCXNqa8skNffgFO4rqJhv6RJRSQaSDdCwrYmAMYGHKN0lAzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dj+7uIpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dj+7uIpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92898C4CECE;
	Thu, 12 Dec 2024 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024805;
	bh=vZgYJLUnK6D68nLBhrGX2oU2PVWnTbdNcaxAqQokZdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dj+7uIpe0LgjqDLYt7oGmiq6YveWRLSzSboFcttXPzY+tn2s2gBqsNcDqgrpspf9L
	 yb9ODKK81LuF9dCF2RCRSEYS2q++5KUsRq6wGap16mmgqv3Z4jrrQqw3EuE9jeyJoX
	 atr1atRmUrMPCzXWNbVDl4FBUUWhpWDncfuoIU7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 410/459] wifi: ipw2x00: libipw_rx_any(): fix bad alignment
Date: Thu, 12 Dec 2024 16:02:28 +0100
Message-ID: <20241212144309.960611648@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 4fa4f049dc0d9741b16c96bcbf0108c85368a2b9 ]

This patch fixes incorrect code alignment.

./drivers/net/wireless/intel/ipw2x00/libipw_rx.c:871:2-3: code aligned with following code on line 882.
./drivers/net/wireless/intel/ipw2x00/libipw_rx.c:886:2-3: code aligned with following code on line 900.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=11381
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241101060725.54640-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 5a2a723e480b0..4c6e742c56958 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -870,8 +870,8 @@ void libipw_rx_any(struct libipw_device *ieee,
 	switch (ieee->iw_mode) {
 	case IW_MODE_ADHOC:
 		/* our BSS and not from/to DS */
-		if (ether_addr_equal(hdr->addr3, ieee->bssid))
-		if ((fc & (IEEE80211_FCTL_TODS+IEEE80211_FCTL_FROMDS)) == 0) {
+		if (ether_addr_equal(hdr->addr3, ieee->bssid) &&
+		    ((fc & (IEEE80211_FCTL_TODS + IEEE80211_FCTL_FROMDS)) == 0)) {
 			/* promisc: get all */
 			if (ieee->dev->flags & IFF_PROMISC)
 				is_packet_for_us = 1;
@@ -885,8 +885,8 @@ void libipw_rx_any(struct libipw_device *ieee,
 		break;
 	case IW_MODE_INFRA:
 		/* our BSS (== from our AP) and from DS */
-		if (ether_addr_equal(hdr->addr2, ieee->bssid))
-		if ((fc & (IEEE80211_FCTL_TODS+IEEE80211_FCTL_FROMDS)) == IEEE80211_FCTL_FROMDS) {
+		if (ether_addr_equal(hdr->addr2, ieee->bssid) &&
+		    ((fc & (IEEE80211_FCTL_TODS + IEEE80211_FCTL_FROMDS)) == IEEE80211_FCTL_FROMDS)) {
 			/* promisc: get all */
 			if (ieee->dev->flags & IFF_PROMISC)
 				is_packet_for_us = 1;
-- 
2.43.0



