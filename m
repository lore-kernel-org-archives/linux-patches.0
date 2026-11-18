Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018669;
	b=FqFUscRcjEv+CvnC46wB2oeU0Kdgdy+LN32ca88uPaTm2rukQx0TEmCy+XetSPHTctFT
	 LP5ja9x1fEXaVwiL5VPGfSA2kR59LUO0U7RpR6BXZvDk2A6K32jGULjZeHzcMx6gUGQzk
	 tblvcEjDmwNuyj6mSPNxqpmaTEfbEvzaKHJqYhuVyMBIoI099+JYv63d25sPT7RdWG7KQ
	 dXMqiEw9C7q2UcxR/8eWgqjb1gECYXqtz0NK8PKjr5CZ7TIGOlOA+2Y9AriJ8THWWYx/7
	 8NI5zVBZRltj7oJqIkAIMZ3NzU3NzqyEPguHmTDlQDKEE8DDiJ1p4Ec3umtjWGbqadw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tIMzHsiubQGClv8oO6imDcynz8/aPruA9/bzHh/i5io=;
	b=UlqeYNaW0+KN8+cPxLzquHVuuj6U+ruPISfKqrBEhXSoSR9TgKFSCD5JAmG62rAr9+Bc
	 wzWVTsD7XkfPBhx8mT1TehMpmTeGEg329mnLHqpd4JwlSkkQ7rtJGnlAFvfNgNvKudF6S
	 FAMgrWbNy7tsj7JwUnxbf5YyOxKO2u+rhai7Wnsu7A6+UFZnBAwutKiIEdADwX7bxk4hj
	 JTU1+ZD0DinlXUx8aGx/4wASnLR5BTtXTXMFtZ9o+nCy8Ak0KTDQ9Dbtl4xvEUN3aOXg3
	 QepTdDxLANTI94uq12KNyJmr0fRVognWURC+W4scJHNKVait2MQBOJd1zYCC9k0RC4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2I0Vk24;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C62C606A336;
	Wed, 18 Nov 2026 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2I0Vk24
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79351F000CF;
	Wed, 18 Nov 2026 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018669;
	bh=tIMzHsiubQGClv8oO6imDcynz8/aPruA9/bzHh/i5io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2I0Vk24vfc6vRFbpwfA4hLcG3++/VojahgJSxBV+zNdSNqAsBN6UETG56BkYhZDr
	 Qb1bHems+bu4f5VYrfy/pKvPnYX4iz/9HntFwr5NHfpzvfVyffMF6522kJvAtRzgoX
	 kW2vSJnzoWM9YHAeta9A0kI+zWxbrkcKpw0UT6ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1323/2651] wifi: nxpwifi: validate variable IE lengths in beacon parser
Date: Wed, 18 Nov 2026 15:42:43 +0100
Message-ID: <20261118150335.632117968@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit 52c9568fa2eda80d02842961e7ba01e07eb01883 ]

nxpwifi_update_bss_desc_with_ie() stores pointers to the HT, VHT and HE
capability and operation elements, to the operating mode notification
and to the 20/40 BSS coexistence element, taken from a beacon or probe
response, without checking that each element is long enough for the
structure the driver later dereferences it as.

bss_desc->beacon_buf is a tight kmemdup() of the on-air elements, so a
truncated element leaves the stored pointer short of the structure and
the consumers read past the end of that allocation at association time.
Some of those bytes are copied into the association request, so a rogue
access point in range can both trigger the read and receive the result.

Reject the frame with -EINVAL when any of these elements is shorter than
the structure read from it, as the FH, DS and CF parameter set cases in
the same parser already do.

The extended capabilities element has no structure size to check
against, so nxpwifi_is_ap_11ax_twt_supported()'s read of
bcn_ext_cap->data[9] is bounded at that consumer instead.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c |  2 ++
 drivers/net/wireless/nxp/nxpwifi/scan.c | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index 96540914f3cf6..dc1e747383eca 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -402,6 +402,8 @@ static u8 nxpwifi_is_ap_11ax_twt_supported(struct nxpwifi_bssdescriptor *bss_des
 		return false;
 	ext_cap = (struct element *)bss_desc->bcn_ext_cap;
 
+	if (ext_cap->datalen < 10)
+		return false;
 	if (!(ext_cap->data[9] & WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT))
 		return false;
 	return true;
diff --git a/drivers/net/wireless/nxp/nxpwifi/scan.c b/drivers/net/wireless/nxp/nxpwifi/scan.c
index 67d7ff2f10c59..f3becafb9c23c 100644
--- a/drivers/net/wireless/nxp/nxpwifi/scan.c
+++ b/drivers/net/wireless/nxp/nxpwifi/scan.c
@@ -1209,6 +1209,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				(u16)(current_ptr - bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_HT_CAPABILITY:
+			if (element_len < sizeof(*bss_entry->bcn_ht_cap))
+				return -EINVAL;
 			bss_entry->bcn_ht_cap =
 				(struct ieee80211_ht_cap *)(current_ptr +
 							    elem_size);
@@ -1217,6 +1219,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_HT_OPERATION:
+			if (element_len < sizeof(*bss_entry->bcn_ht_oper))
+				return -EINVAL;
 			bss_entry->bcn_ht_oper =
 				(struct ieee80211_ht_operation *)(current_ptr +
 								  elem_size);
@@ -1225,6 +1229,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_VHT_CAPABILITY:
+			if (element_len < sizeof(*bss_entry->bcn_vht_cap))
+				return -EINVAL;
 			bss_entry->disable_11ac = false;
 			bss_entry->bcn_vht_cap = (void *)(current_ptr +
 							  elem_size);
@@ -1233,6 +1239,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_VHT_OPERATION:
+			if (element_len < sizeof(*bss_entry->bcn_vht_oper))
+				return -EINVAL;
 			bss_entry->bcn_vht_oper =
 				(void *)(current_ptr + elem_size);
 			bss_entry->vht_info_offset =
@@ -1240,6 +1248,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_BSS_COEX_2040:
+			if (!element_len)
+				return -EINVAL;
 			bss_entry->bcn_bss_co_2040 = current_ptr;
 			bss_entry->bss_co_2040_offset =
 				(u16)(current_ptr - bss_entry->beacon_buf);
@@ -1250,6 +1260,8 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				(u16)(current_ptr - bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_OPMODE_NOTIF:
+			if (total_ie_len < sizeof(*bss_entry->oper_mode))
+				return -EINVAL;
 			bss_entry->oper_mode = (void *)current_ptr;
 			bss_entry->oper_mode_offset =
 				(u16)(current_ptr - bss_entry->beacon_buf);
@@ -1262,6 +1274,9 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 
 			switch (elem->data[0]) {
 			case WLAN_EID_EXT_HE_CAPABILITY:
+				if (element_len <
+				    1 + sizeof(*bss_entry->bcn_he_cap))
+					return -EINVAL;
 				bss_entry->disable_11ax = false;
 				bss_entry->bcn_he_cap =
 					(void *)(current_ptr + elem_size + 1);
@@ -1270,6 +1285,9 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 					      bss_entry->beacon_buf);
 				break;
 			case WLAN_EID_EXT_HE_OPERATION:
+				if (element_len <
+				    1 + sizeof(*bss_entry->bcn_he_oper))
+					return -EINVAL;
 				bss_entry->bcn_he_oper =
 					(void *)(current_ptr + elem_size + 1);
 				bss_entry->he_info_offset =
-- 
2.53.0



