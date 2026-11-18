Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049749;
	b=1zBTafAbZVA3eiXbeRI9/PDTDdesEZAT052455D7VzZlqqw85fFPIE5K/d5wbNMnglgO
	 m4VKJEs2Ppu+j5/C/4L5MuQX6audVuApbW+3+qKG1QZtVScrv5UPkczFKjpXZeKo96tjt
	 vwWAbH+O/V++F/Kb2sNt7gU0kcXyIDvuQVbxvPGBouRnsreRFGoP5Rp0Mx8UF0WnrVoQw
	 PNQIiAdIjaNlOqKxCvXOIeld/pJHF43tTkyM7MXn1bIVDcISrhK3bub5rJGUVGpqzF7Sh
	 xLArQKPj5i1kzMwRUgxR+pqpMxasHkNuKIYdaDmWx5FAnHWE0s/mYzYHMiJ/ABdkSVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eXJLDcHBjj4IPdxduNh3l4bWDQvGpoQMdWYIbcKdx0A=;
	b=FfFSmqlwaIoXrdoEjN4WVzlGcTQWecEfQRy7+AGqHjxMLsj7R4VW7EvP5MlvoZFLASrL
	 ZRrO4AJ9JVOLvzZjrfOTBha1mNFhV/mz7+44hjKCB0urb3wOt/R5Tas8xILPH7KxriK+w
	 HYzZEGqBvbuWS76lZE1mV9UzyDZsOv9qNL8GFwm3cRXEZR9S8zWb+eETm9cxArszFRU5u
	 fFnCIv/AyAIaoqDZQKT2gEZNVx+le5CXPMK7hg/qgvh88gBaMw0WZydfGWcQRxpYyPHaR
	 CmbwY64FeWAWDx5Qg+NZ2LUDA5o+hAXSoPTupvYrdvfz0slrPiUzpr8P6lTbjee65/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igPVRo6f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A930E606A320;
	Thu, 19 Nov 2026 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igPVRo6f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075811F000C5;
	Thu, 19 Nov 2026 00:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049749;
	bh=eXJLDcHBjj4IPdxduNh3l4bWDQvGpoQMdWYIbcKdx0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igPVRo6fioJ7MSBnd3hmBqqpxXD7YVrpU/xcUD37bgB3Vv8oHl/MM54D4LK0aZ6du
	 9hLM5U9LiUqNtzTd+33aZ4Z7BZ77nZqbryFCBO+Hl9ddhFWCrzvNpH+7Wc7L2ce0q6
	 cDYbxr1H1ulocnVl7FRiv93NNPjmlD8Mb+AMTl40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2464/2857] wifi: cfg80211: track SSID regardless of country data
Date: Wed, 18 Nov 2026 15:58:18 +0100
Message-ID: <20261118150330.289052066@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 577f690ce5dc641d9d8646d15bb8e99ff4a8280e ]

If the country data cannot be found, the function exits
and then doesn't track the SSID. Move the SSID tracking
up to fix that.

Fixes: c38c70185101 ("wifi: cfg80211: Set SSID if it is not already set")
Link: https://patch.msgid.link/20261013151258.7fbca481c328.I7beb03fb4309698bdcfade57c6804573f96eeb18@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 09d872835310b..719d29e10347d 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -858,6 +858,25 @@ void __cfg80211_connect_result(struct net_device *dev,
 	if (!(wdev->wiphy->flags & WIPHY_FLAG_HAS_STATIC_WEP))
 		cfg80211_upload_connect_keys(wdev);
 
+	if (!wdev->u.client.ssid_len) {
+		rcu_read_lock();
+		for_each_valid_link(cr, link) {
+			u32 ssid_len;
+
+			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
+						      WLAN_EID_SSID);
+
+			if (!ssid || !ssid->datalen)
+				continue;
+
+			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
+			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
+			wdev->u.client.ssid_len = ssid_len;
+			break;
+		}
+		rcu_read_unlock();
+	}
+
 	rcu_read_lock();
 	for_each_valid_link(cr, link) {
 		country_elem =
@@ -883,25 +902,6 @@ void __cfg80211_connect_result(struct net_device *dev,
 				   country_data, country_datalen);
 	kfree(country_data);
 
-	if (!wdev->u.client.ssid_len) {
-		rcu_read_lock();
-		for_each_valid_link(cr, link) {
-			u32 ssid_len;
-
-			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
-						      WLAN_EID_SSID);
-
-			if (!ssid || !ssid->datalen)
-				continue;
-
-			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
-			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
-			wdev->u.client.ssid_len = ssid_len;
-			break;
-		}
-		rcu_read_unlock();
-	}
-
 	return;
 out:
 	for_each_valid_link(cr, link)
-- 
2.53.0



