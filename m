Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD6241F379;
	Sat, 12 Sep 2026 10:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209429; cv=none; b=iC1oEZ1KOJMhFOa6+RwhU64q/STYBsEPQS4dZWjH8fW5WfHRfem5Gw/Y0Pook5xf21XcB1LzmatRguowz63cKN7LcPGe4Ede7pDuSAUQiCupQZ25eUva3/Wp0Pm6Dna2e1QsdJ1axP4gXnM3t1X32ktim/6/HAIDf1BqNWKkEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209429; c=relaxed/simple;
	bh=MhaDQL3JEZzoFp3sXVwCi2qTcFHXrbtTANC/RtyLOfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnKQwpwbZB8DgH6ULrp4gaw0AseKlh5MitIrK6Zc/ppR95mDS77gU/Glfe3icqtzy1ssj+69oryQGLS0le2DlsfCZ6Gx9YqagTOR3xrhni/5w0UbovfZlGDvX5V8/Cl7094HlByOiNNKT/zpWXqVAEhxEnRfdOzfkAXD44MUrNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzQaxbeb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzQaxbeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AD61F000FF;
	Sat, 12 Sep 2026 10:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209428;
	bh=SDqtr5qgD7TLmtZxBI8YkgIruwGA9F38vBFiAo9wFEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzQaxbebgTqlgr+9dYEW3IVxCcUJsTj8wSgpLf3qRi/6+RjD61GDZfuFfMyo2J8Nc
	 dSqqYyibLik7sO4BqNnI19KoMP8+hbUf14mI5prqJiiWNZC/tU6BO2cKdX0nhIgftj
	 bGmJkLLiqGI08wCT71l73Sau2Jp8WJA6zUdyT3GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan Dutta <quic_drohan@quicinc.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0818/1518] wifi: nl80211: Add support for EPP peer indication
Date: Sat, 12 Sep 2026 08:49:47 +0200
Message-ID: <20260912065641.940502197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>

[ Upstream commit 6ee3a22c61cdf57d71592ec9f3b9439cd5d0c75f ]

Introduce a new netlink attribute NL80211_ATTR_EPP_PEER
to be used with NL80211_CMD_NEW_STA and
NL80211_CMD_ADD_LINK_STA for the userspace to indicate
that a non-AP STA is an Enhanced Privacy Protection (EPP)
peer.

Co-developed-by: Rohan Dutta <quic_drohan@quicinc.com>
Signed-off-by: Rohan Dutta <quic_drohan@quicinc.com>
Signed-off-by: Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Link: https://patch.msgid.link/20260114111900.2196941-5-kavita.kavita@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 6c5fc504d0d6 ("wifi: cfg80211: stop PMSR before P2P and NAN teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h       | 2 ++
 include/uapi/linux/nl80211.h | 5 +++++
 net/wireless/nl80211.c       | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1509be85139ec..99d6508a36ba8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1784,6 +1784,7 @@ struct cfg80211_ttlm_params {
  *	present/updated
  * @eml_cap: EML capabilities of this station
  * @link_sta_params: link related params.
+ * @epp_peer: EPP peer indication
  */
 struct station_parameters {
 	struct net_device *vlan;
@@ -1810,6 +1811,7 @@ struct station_parameters {
 	bool eml_cap_present;
 	u16 eml_cap;
 	struct link_station_parameters link_sta_params;
+	bool epp_peer;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 964e1c779cdd3..19e32a1b9a7fd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2973,6 +2973,9 @@ enum nl80211_commands {
  *	primary channel is 2 MHz wide, and the control channel designates
  *	the 1 MHz primary subchannel within that 2 MHz primary.
  *
+ * @NL80211_ATTR_EPP_PEER: A flag attribute to indicate if the peer is an EPP
+ *	STA. Used with %NL80211_CMD_NEW_STA and %NL80211_CMD_ADD_LINK_STA
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3541,6 +3544,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_S1G_PRIMARY_2MHZ,
 
+	NL80211_ATTR_EPP_PEER,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 541d86cc6018a..fa877abe6de50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -934,6 +934,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		NLA_POLICY_NESTED(nl80211_s1g_short_beacon),
 	[NL80211_ATTR_BSS_PARAM] = { .type = NLA_FLAG },
 	[NL80211_ATTR_S1G_PRIMARY_2MHZ] = { .type = NLA_FLAG },
+	[NL80211_ATTR_EPP_PEER] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -8791,6 +8792,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			goto out;
 		}
 	}
+
+	params.epp_peer =
+		nla_get_flag(info->attrs[NL80211_ATTR_EPP_PEER]);
+
 	err = rdev_add_station(rdev, dev, mac_addr, &params);
 out:
 	dev_put(params.vlan);
-- 
2.53.0



