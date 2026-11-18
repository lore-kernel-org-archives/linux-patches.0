Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020239;
	b=f7yMfdVD6tEAeK4GzVIV4izr0gIPhzceKOoVKAx+qYVg51MML0g+uJkDLk6F8Z7ghkNa
	 Upgj5LJk3QvL3NhdtzJ2wM960N6vQuPCTYjRNtM3lBokOGT5WyRf/aJbWw34FYmlnA6BA
	 G4u52n+H9tx0pf5+DQLUAzi9pBLi3mrqt8mWjS/oQQL4ajqYd/Es9vmzYEQlR7L6OqH5S
	 Er1FAyJN9tyWt/OGOrMCVGiUjlf8uudrYKlnFG+j1TE1++OeBwn0JKCGi6suor0s+mMAy
	 mWhJFr4mIrQCbiwCUvVjV4dnsS3Gb6un39EXWwpMuecGPfpZ7WyCrVXL69y2i9oIIog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dy/U5au0wNHq615uJdgDeKRY1k4Qb/KoJZo+6vDZ5u4=;
	b=JLg/PNf0lq1Ep6xkhjbxiFXP87a5/moe/ifCxHqfgvoTTIDD5xzniGNwyVLh0z72ZV3L
	 lcKPsGvtaRbcfMYAU2I7Zl6uPXpnREnBdKVH6fFdz6n8J/mqmmsxpjjBFl3UUADB6/WC3
	 cXt/b16nFMUOhP85s54jphz92jeYYd9tSJ3WeRSshBFBcIuzC2a6DFIxak+3Yl1wzMQzH
	 eV+CQZxQPNoRfyxx2M8sPlmGE2XDx8l/YvnWOrWVi/uhSW1ToWqQN/MrPq3AP7FXNldNc
	 p+k1hXXU9bDJT7bwMFIypYIcBYDYppGPuxasCjeiST/3KkFkDAb6WuSM54lfQmfeIxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zVZNNgiB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FA5606A31C;
	Wed, 18 Nov 2026 16:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zVZNNgiB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1725D1F000C4;
	Wed, 18 Nov 2026 16:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020238;
	bh=Dy/U5au0wNHq615uJdgDeKRY1k4Qb/KoJZo+6vDZ5u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zVZNNgiBvJy2psoFV4Fks6eXulLwlzZNSY0nLTB7aWWTVsOTNbSRQ9h00Q+f1RJHu
	 gWhXNmVogy+41flnnAOPYlLtwd2RwzT4CsPMseLlK7VUAI/3G2bTdsPgti8Uoofgn3
	 vLDB4moL/HcQK1h4OErOni1wh5O+DSCNzDYen5HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1838/2651] wifi: cfg80211: track SSID regardless of country data
Date: Wed, 18 Nov 2026 15:51:18 +0100
Message-ID: <20261118150353.265301636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2a719b5c487e3..a74b9aeb0244c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -872,6 +872,25 @@ void __cfg80211_connect_result(struct net_device *dev,
 
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
@@ -897,25 +916,6 @@ void __cfg80211_connect_result(struct net_device *dev,
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



