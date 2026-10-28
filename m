Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209421;
	b=TAntFTuRNpXZzBbMJQv4/MM/Apkf8/qfdxqW6wegDszIr2dOcfKG+hirVvAI83NL5GrI
	 6wUTDeHOaftpkPOJMtIZ34Y9ci5YOyc9uXySeUu+1rSQ8YyXhQIAus4yhCk5ZcSYB93ZR
	 0y5eMVMa3FLDOLIBPneJnTu09hIGl+SH0A8/YPV6v+tMTv6Xx6TJuQU+tkwrtQ942MWqf
	 /Hjpt+Qn3uspvIortZ9vJqiPp/7CrawOwWnvzNfamq9ndYAf2uUTV7101TKNnLqu8bAc/
	 Rd5gzrMVSc1HnsMJoyYACyuKssuFBAV8oHvxKvSEzR6NnYo9sgVZnFEafXRsK0zR7lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dQA+UAetP3vy48JNHbmk076wJs6ke34nEyleUja3z00=;
	b=KwgovMGtbF37Uc4sz9dgtdiwO8wFp3n0hbg/ZJmCJGvVlAEiz42vmedBWnlFxedRxhkN
	 W9gpmgezBcKI9cUTkBjUDUMRwkSk8hpwxbwzBbW21jQTUrJx0MnWLu5V6LIrpuS7hqQOO
	 s41NB9UdtwUNjJg1x6JKiq8lyAw4OLNtlNiXv5b7zXABfHMrr9eZFihP2fFF+eIvU8mgd
	 ml3v3494p9o1LU+a+xWaO6yPA+atUMKttF6omcPZA9zxkAv7v81dWsQ9s+NNmlmK4hnxS
	 YKni3lwjmMbvwpbepbthU6qub+s7t+fYppw62ETa7Pb/U2++0O25KzVGHIBaQJHMtHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPBku9bX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4F2606A31D;
	Wed, 28 Oct 2026 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPBku9bX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF3C1F01825;
	Wed, 28 Oct 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209420;
	bh=dQA+UAetP3vy48JNHbmk076wJs6ke34nEyleUja3z00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPBku9bX1vzlmXMPS0WYZO/WCjkokGLuFVwELykelhuYf/cDooYdwf5UOyfkf5E7m
	 B1sHgbVuJ2hFZNj+qCTmBVUAjrKoSh8JZbgF43zPeAaDlBt0hGFFOS1Hf+NlVlRt2K
	 ku8Zc6/7arsWeXGqTsZGuFEyb3aieOF1tmrqR+pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heyang Tan <thy15333007817@163.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 463/516] wifi: p54: validate firmware record lengths
Date: Wed, 28 Oct 2026 18:00:15 +0100
Message-ID: <20261028170014.447769879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


