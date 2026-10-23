Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774957;
	b=c07LJwqKoYmAQn4xdarmckRbeTDxhUgaMX+AIugenb24EMV6uDIGKmSV4IN9m373thci
	 ErWKxEZEHni/qX7XskydBQm2hOFgFPlJTc2Q8cVCjUijyCoVUDxpllgFJimo0wo+A3ogg
	 vKexSyMmAme/IR9VL2blksZce4uhKcFZATLVTqeMuPJqHSnt9mxkdT9C8sno71Hkv96gu
	 kb+2jXm0fpDFrY+iOiqM0ODrS1R/YxNK/eo/dYU2EJo6LhF2mEoMMPJ6aKOLl0IxEmfiH
	 d4iT0kW9TBerlNB713tEmvOt/yNVJQuCbNl34kuC9i7V6YRzD/tGxutyXgJoRk/ueXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rRJZ8/Uxb3S6OSZC6q7Rp21XqymygsT4sHLMbuFCIZA=;
	b=jt1TQy3KBHhGInWQI/rpACEnL9we3mENWD0kLf7yINinDKt6Rc1pEe4p9wKjvYRuBieN
	 WDCp42bFY2IuFMjscxs5o+ck9AKKyhc6LeVrj8H/hRnpDG7Tq4n8RfhjuS0LyeoSIDS1L
	 llHNqQq64+dvaOqqVsO4LEvNhJ34KQFXnFNoCBEKZeXDy4U9MTjjWVQp8963s/NWEeK+5
	 C93s53XUDHCwdYhFSLDhWNBOSq6yOCk2oqrcxnTHASnO8B2Rs2AdhD5nwyKeIlZLO0H1T
	 CkTLu+6jzgdVHCeVlNLjD23nSJm/nS62rzOXlgCsWU9Wq50yVuVccnH/B3Si+4n1UJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bud3hQkl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73092606A31A;
	Fri, 23 Oct 2026 17:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bud3hQkl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68E81F01825;
	Fri, 23 Oct 2026 17:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774957;
	bh=rRJZ8/Uxb3S6OSZC6q7Rp21XqymygsT4sHLMbuFCIZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bud3hQkltLUBb/LoVv5K0QL2DoC87Z/1408kYzesz2oYpTe2rgFBKr5cPJhPTXJaa
	 4kQqKFukbxdo8yOS2MMXJzxKFHOgImZjJ1EtTor6hTdYUd4Ht5TjzNOO74ityYSjIV
	 dacYbX0EAHhv4QA9noduN4vH2RnQDhfRzMndNLgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heyang Tan <thy15333007817@163.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 176/242] wifi: p54: validate firmware record lengths
Date: Fri, 23 Oct 2026 18:40:18 +0200
Message-ID: <20261023163717.946736038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heyang Tan <thy15333007817@163.com>

commit db7b86bd97b380ece8fa39cfdd7502a9fd35e56f upstream.

The p54 firmware parser accesses component ID and component version
records without checking that their lengths cover the fields being read.
A malformed record can therefore make the parser read past the record.

Validate the component ID and component version record lengths before
accessing their data. The descriptor record is also checked against the
shortest descriptor length found in the supported firmware images.

Reject descriptor values that underflow the RX offset or produce an empty
RX range before updating the driver state.

Assisted-by: LLM Codex
Signed-off-by: Heyang Tan <thy15333007817@163.com>
Tested-by: Christian Lamparter <chunkeey@gmail.com>
Link: https://patch.msgid.link/20260918083349.891-1-thy15333007817@163.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intersil/p54/fwio.c |   42 +++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -52,6 +52,13 @@ int p54_parse_firmware(struct ieee80211_
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
+			if (len < sizeof(struct bootrec_comp_id) /
+				sizeof(*bootrec->data)) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component ID is too short\n");
+				return -EINVAL;
+			}
+
 			priv->fw_interface = be32_to_cpup((__be32 *)
 					     bootrec->data);
 			switch (priv->fw_interface) {
@@ -72,16 +79,41 @@ int p54_parse_firmware(struct ieee80211_
 			}
 			break;
 		case BR_CODE_COMPONENT_VERSION:
+			if (len < DIV_ROUND_UP(sizeof(struct bootrec_comp_ver),
+					       sizeof(*bootrec->data))) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component version is too short\n");
+				return -EINVAL;
+			}
+
 			/* 24 bytes should be enough for all firmwares */
-			if (strnlen((unsigned char *) bootrec->data, 24) < 24)
-				fw_version = (unsigned char *) bootrec->data;
+			if (strnlen((unsigned char *)bootrec->data,
+				    sizeof(struct bootrec_comp_ver)) <
+				    sizeof(struct bootrec_comp_ver))
+				fw_version = (unsigned char *)bootrec->data;
 			break;
 		case BR_CODE_DESCR: {
 			struct bootrec_desc *desc =
 				(struct bootrec_desc *)bootrec->data;
-			priv->rx_start = le32_to_cpu(desc->rx_start);
-			/* FIXME add sanity checking */
-			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
+			u32 rx_start, rx_end;
+
+			/* 0xa is the shortest descriptor in supported firmware. */
+			if (len < 0xa) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware descriptor is too short\n");
+				return -EINVAL;
+			}
+
+			rx_start = le32_to_cpu(desc->rx_start);
+			rx_end = le32_to_cpu(desc->rx_end);
+			if (rx_end < 0x3500 || rx_end - 0x3500 <= rx_start) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware descriptor has invalid RX range\n");
+				return -EINVAL;
+			}
+
+			priv->rx_start = rx_start;
+			priv->rx_end = rx_end - 0x3500;
 			priv->headroom = desc->headroom;
 			priv->tailroom = desc->tailroom;
 			priv->privacy_caps = desc->privacy_caps;


