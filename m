Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84485374C4;
	Tue,  8 Apr 2025 11:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110841; cv=none; b=lBe4H7Epi/kB5GTL7bDUjuKwcDjh1FRXeEiC3NgK+IcaUxLSP5838FGQrcZSk2W3dIfgYJk4nhFs8O1UcOBzlVm3iaz/dzpzZHrG7WaKlOziO5jyfh94jDh8DxufhhBeoCR7S3AEec361juaSvkrru1Nm0YzLjBXqg9qEhULROQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110841; c=relaxed/simple;
	bh=oo71AWf98U+H/q76nOwaQemh/eYWRQHMZaDKLoINyvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKpZ7g1TxGqgg1ka6FuaIp4NzuPLtmdGOAPumVKnAdiGu36/ZeRUHq1KG0pC/7cH2D3MvTxz7R50Uu02FbKictQW/gFSEDQMQohxMJDcDHEneUZwPQakFScJ4qof+BvFygu0wxXFceH8R59btHasiFt4yVZWqZxIC3Bmu/xtFcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pK+GQTCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pK+GQTCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142BEC4CEE5;
	Tue,  8 Apr 2025 11:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110841;
	bh=oo71AWf98U+H/q76nOwaQemh/eYWRQHMZaDKLoINyvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pK+GQTCquJo8/aScIDTmNFFjsfm3hz29ZkNxWGu2niK5796VRvgPhuip9NFeruUcQ
	 NvYlAJ5JhvTpgCNHkPoWdspeeByLE/MkYdrS3lBNdpFoqnfVYWsYZunTonGdokx2nT
	 AQoj/CE+WHfq8hdvQZjfirCigGY5X5CGJB3T8Doo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 175/731] wifi: mac80211: remove SSID from ML reconf
Date: Tue,  8 Apr 2025 12:41:12 +0200
Message-ID: <20250408104918.347218336@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 899da1830db112e6bd54ed4573ace753eae6ef22 ]

The ML reconfiguration frame shouldn't contain an SSID,
remove it.

Fixes: 36e05b0b8390 ("wifi: mac80211: Support dynamic link addition and removal")
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20250311121004.fdf08f90bc30.I07f88d3a6f592a0df65d48f55d65c46a4d261007@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 36a9be9a66c8e..da2c2e6035be8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -9946,8 +9946,8 @@ ieee80211_build_ml_reconf_req(struct ieee80211_sub_if_data *sdata,
 		size += 2 + sizeof(struct ieee80211_mle_per_sta_profile) +
 			ETH_ALEN;
 
-		/* SSID element + WMM */
-		size += 2 + sdata->vif.cfg.ssid_len + 9;
+		/* WMM */
+		size += 9;
 		size += ieee80211_link_common_elems_size(sdata, iftype, cbss,
 							 elems_len);
 	}
@@ -10053,11 +10053,6 @@ ieee80211_build_ml_reconf_req(struct ieee80211_sub_if_data *sdata,
 
 			capab_pos = skb_put(skb, 2);
 
-			skb_put_u8(skb, WLAN_EID_SSID);
-			skb_put_u8(skb, sdata->vif.cfg.ssid_len);
-			skb_put_data(skb, sdata->vif.cfg.ssid,
-				     sdata->vif.cfg.ssid_len);
-
 			extra_used =
 				ieee80211_add_link_elems(sdata, skb, &capab, NULL,
 							 add_links_data->link[link_id].elems,
-- 
2.39.5



