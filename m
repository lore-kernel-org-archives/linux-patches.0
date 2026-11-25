Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618391;
	b=d2po9kQnD2kEWh5l8Ivj59PKakXxEv9Tl21D7hxOhI6WRouPfqJwtNo5x2BWMzoNvunH
	 Y6z3YcqnpPhAlTIB7fNn395ihggp1FjFtCpYw/kEKFP44t05IX3d8zU/jv34WJplUWrvF
	 sOKMuwP4MOUUFQ9q7Y6YWZuiLtaEmqL/vsfk+NjEFv49Ak37OqVcEPTmS8Pg070D5IFhJ
	 SRMopAIdCUvzqjqhwS9iCzGdzJItBwpuIdSdYDziimtc/nEtLk1YdH5vBSWnjFJXBtszw
	 txi0FU6Q9f+TlNW623TfFpLexvf4rrDuiHAroFnj7+v/GtUqMWQO97SIHyaxpSrDRNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQQua79txt89XAzfIdkY6wxLZygrUsSAAN8YIMWcWpI=;
	b=PW6of0MKGgtED6L0FI8ANAIn84usI16RMzmlECaTUAUgAegvTdm2LzvrI2FQXBky8hTZ
	 XxM6cvAav2fvqKTCwT9sPoJ/Cm6nXCrCRtT85z+ndkWbR/eTx5Cg4nxh2CDQ19Q4Lzt9e
	 TjRfXCBJ+gM1AIDUOWVRE+WriaTokN9OQsslfLWj7HIW7Jiy9PSbZZxH2H5nVy5PWagiH
	 dQFoLw673LPFaK/aeRf5agausFIaXa8HUpVQXhDV67azYWlmAdKh1agTMaQBkzGJkmORr
	 SbJYKUrNEAfeKedRIasU433UBbM2FfIAjxKxbKXJRwkqAGrHEMSUtPH2vN49SqbxCfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HG1Bv6bd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A8C606A326;
	Wed, 25 Nov 2026 14:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HG1Bv6bd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796641F000CF;
	Wed, 25 Nov 2026 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618391;
	bh=AQQua79txt89XAzfIdkY6wxLZygrUsSAAN8YIMWcWpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HG1Bv6bdRAWugd5mevDuYm5GCx7sBYhNHq5OHELbQet5O8n5Bh+8ZyuxKV5dijaZx
	 3OIWthsnqXjT5xIEd0n/jm5a+J51coOmPQvqETRNMbXr+JgJYflVVACX1sEAa613vs
	 /nZQK2GulBwP4KNli+ohtkKU07+bWPd8LBuIGqsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0221/1005] wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response
Date: Wed, 25 Nov 2026 15:25:59 +0100
Message-ID: <20261125143826.920081657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit f17e2eda1630ab375ac71a91252694a485addef7 ]

nxpwifi_ret_11ax_cfg() walks the TLVs the firmware returns and copies an
HE capability into fixed-size buffers without bounding any length. A
response shorter than the fixed part wraps the u16 walk length, and
header->len is used as a memcpy length without being checked against the
destination.

Reject a response too short for the fixed part, reject a TLV longer than
the bytes left, and reject an HE capability that does not fit its
destination. Select the destination buffer first, by band, then validate
and copy that one.

The lengths come from device firmware, so this is not a demonstrated
out-of-bounds write. The driver has not appeared in a released kernel,
so there is no stable tag.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 49 +++++++++++++++++--------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index 16bda167fa66b..be38a034be325 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -204,7 +204,7 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 {
 	struct host_cmd_11ax_cfg *he_cfg = &resp->params.ax_cfg;
 	struct nxpwifi_ie_types_header *header;
-	u16 left_len, tlv_type, tlv_len;
+	u16 resp_size, left_len, tlv_type, tlv_len;
 	struct nxpwifi_11ax_he_cap_cfg *he_cap;
 	u8 ext_id;
 
@@ -212,34 +212,53 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 		return 0;
 
 	he_cap = &ax_cfg->he_cap_cfg;
-	left_len = le16_to_cpu(resp->size) - sizeof(*he_cfg) - S_DS_GEN;
+	resp_size = le16_to_cpu(resp->size);
+	if (resp_size < S_DS_GEN + sizeof(*he_cfg))
+		return -EINVAL;
+
+	left_len = resp_size - S_DS_GEN - sizeof(*he_cfg);
 	header = (struct nxpwifi_ie_types_header *)he_cfg->tlv;
 
 	while (left_len > sizeof(*header)) {
 		tlv_type = le16_to_cpu(header->type);
 		tlv_len = le16_to_cpu(header->len);
 
+		if (sizeof(*header) + tlv_len > left_len)
+			return -EINVAL;
+
 		if (tlv_type == TLV_TYPE_EXTENSION_ID && tlv_len >= 1) {
 			ext_id = *((u8 *)header + sizeof(*header));
 			if (ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
+				u8 *user_cap, *user_cap_len;
+				size_t user_cap_size;
+
+				if (he_cfg->band_config & BIT(1)) {
+					user_cap = priv->user_he_cap;
+					user_cap_len = &priv->user_he_cap_len;
+					user_cap_size =
+						sizeof(priv->user_he_cap);
+				} else {
+					user_cap = priv->user_2g_he_cap;
+					user_cap_len =
+						&priv->user_2g_he_cap_len;
+					user_cap_size =
+						sizeof(priv->user_2g_he_cap);
+				}
+
+				if (tlv_len > sizeof(*he_cap) -
+				    offsetof(struct nxpwifi_11ax_he_cap_cfg,
+					     ext_id) ||
+				    sizeof(*header) + tlv_len > user_cap_size)
+					return -EINVAL;
+
 				he_cap->id = tlv_type;
 				he_cap->len = tlv_len;
 				memcpy((u8 *)&he_cap->ext_id,
 				       (u8 *)header + sizeof(*header),
 				       tlv_len);
-				if (he_cfg->band_config & BIT(1)) {
-					memcpy(priv->user_he_cap,
-					       (u8 *)header,
-					       sizeof(*header) + tlv_len);
-					priv->user_he_cap_len =
-						sizeof(*header) + tlv_len;
-				} else {
-					memcpy(priv->user_2g_he_cap,
-					       (u8 *)header,
-					       sizeof(*header) + tlv_len);
-					priv->user_2g_he_cap_len =
-						sizeof(*header) + tlv_len;
-				}
+				memcpy(user_cap, (u8 *)header,
+				       sizeof(*header) + tlv_len);
+				*user_cap_len = sizeof(*header) + tlv_len;
 			}
 		}
 
-- 
2.53.0



