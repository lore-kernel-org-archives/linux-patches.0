Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618388;
	b=UO19imvDW6CfU01K3wakDyr0+AhdAeDEZvVf4TsEhMD9ymzEekzsvg/sFQPa5QRSutyk
	 nF/KMzlkxKD39Lr2Wy43uOWETbMfk/UwAeV8jyGwT1Gd8zhMuosRHWc+Sih4XNUU8C642
	 VdY/Y+OrLZ8K1knuCktJpwX56Cu229kUlF3zLk1RyI9atVwtTetnZ3Ftren1xuurAIzH+
	 octo00nb5G1Nmj6n48MP8teekshLq/62jSN1Mx/e+jhpY27ikAh78cp4DdBx6WmaQPGhD
	 inB1EG8LOHDbKlHDMpbw5/QteP/rTn4j8pL/OAGA0ixQnWHJRTu01cRqchVSqKf737Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=noBZ4Rhb64J2MmHMewp2QxsF7k232QjjmUyE1qo9+kc=;
	b=tqyyKLx9nufXl4yh5n2teUypyqKBKHanAaSIye+5Cz4OsEMW48/SOlBzduNgI3kXuizT
	 bJmxFg/3pKEQk0/Alh81G7Q47maKJa6NYGHVZ3xiBNWhA5erfFmJA9d5voOSXsdFanbCP
	 8ihw9AiFKEKv3oVsaUvP0NezqTm2RnDICbhjjhslGeNxqf22o3+NDOVz1mTgmzdK8bQRO
	 ogBJ8bt+b8xSgKImkuj1y/52mpBmowQqw6w+TJjuQnlwXM9F/JLV+dd4SCWxBB/m5jTO/
	 kdDMxi94bQWkMm7leop95n9jq/doVCHSuVfxH0Q7RFGkawFaS+dUvr7lC1PVaNMiYWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvH0ZovF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4199606A687;
	Wed, 25 Nov 2026 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvH0ZovF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BD31F000CF;
	Wed, 25 Nov 2026 14:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618387;
	bh=noBZ4Rhb64J2MmHMewp2QxsF7k232QjjmUyE1qo9+kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvH0ZovFOqAKw6ZzlOu1Bhuo/TCm1Lm7gj2QKNSFfEHgeibbFrTmmN8lGI7CzTk/j
	 rWw9Li4NJUmaN2hDABUeaP9QYojiYpJvIaEZVSZuoh3lU36UysxwwwFsa2lH5ao75x
	 YSudq6X+hiJRa8slkrdXwtP2yFJo0gcRjcnYaoxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0220/1005] wifi: nxpwifi: read the 11AX_CFG extension ID at the right offset
Date: Wed, 25 Nov 2026 15:25:58 +0100
Message-ID: <20261125143826.896659745@linuxfoundation.org>
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

[ Upstream commit 1cb78390d1c6c7908ab9838238a702799e0f7e9f ]

The send side writes the extension ID as the first payload byte of the
TLV in nxpwifi_cmd_11ax_cfg(), but nxpwifi_ret_11ax_cfg() reads it one
byte later and copies the HE capability from the same wrong offset. The
capability test runs on the wrong byte and the copy reads one byte past
the declared payload.

Read the extension ID and copy the capability from the first payload
byte. A zero-length extension TLV has no payload to read an extension ID
out of, so skip it.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Stable-dep-of: f17e2eda1630 ("wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index 7e9127ae2f421..16bda167fa66b 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -219,13 +219,13 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 		tlv_type = le16_to_cpu(header->type);
 		tlv_len = le16_to_cpu(header->len);
 
-		if (tlv_type == TLV_TYPE_EXTENSION_ID) {
-			ext_id = *((u8 *)header + sizeof(*header) + 1);
+		if (tlv_type == TLV_TYPE_EXTENSION_ID && tlv_len >= 1) {
+			ext_id = *((u8 *)header + sizeof(*header));
 			if (ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
 				he_cap->id = tlv_type;
 				he_cap->len = tlv_len;
 				memcpy((u8 *)&he_cap->ext_id,
-				       (u8 *)header + sizeof(*header) + 1,
+				       (u8 *)header + sizeof(*header),
 				       tlv_len);
 				if (he_cfg->band_config & BIT(1)) {
 					memcpy(priv->user_he_cap,
-- 
2.53.0



