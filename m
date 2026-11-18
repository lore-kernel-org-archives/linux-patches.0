Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023721;
	b=lEh577LCMhG94wVBiL8ndI6eoxkiMAoEY1irpDRG+4T+P+YCz4Pra9ThMvB/xKzFIro2
	 iiXPw2dlAeuX6XU/PCHblhp7sBBfMGsH1LT7tLipWFXAUAAqdN1TptQypV2jWXpVXPlNJ
	 RBrDhVNApNOwnPZYGWmTAWXtuU5I12Qny3ebjFUVVcrVFl6a7ea7lPutLgC+vV+7xhf20
	 KgmnUP5G/ZN4IUdFszZEKBxOnBjdbPSFh7KkTAqbfo1qEmoZChM67h40o/IwZs9JFeX8w
	 TRX8QsSRYfczQz6PEUTNeoa0oJYnykaRVBC8xc19KVYaVgoOUzak/5vEwq4l26MegIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V12o9OqkcuiLlAJYwdSSDIMUM0CHJLPq8TOScbWIIo4=;
	b=adCq5qCfMLQVjxE/Y7KyesC9WllJs2C5XAeW+hOKwS5IQonuqKNlA/+VQMlbdAkNktwI
	 ZryXFAIeRclx41BRPdzi9jk/7wg9DbkQ36f7ktsCI4JwFyrutqsUW8+RwrHfamkCG6D2z
	 DYVsIibjCo1C5jEW6llDlfEGXEJ0AmxbQa9bxXvbIb1vNmE1tzT83EZ795q5zTu6pKyxK
	 nyrk200CtoGEQ4fGr6BFBu/0bFTaLN4PZ4DXMZv+jmRolAWLqDwqpMQj9ruetvewoOXp4
	 xSJ+fhgJEAf6TFRNGjcKenuhcV/vFby1BSo7EawkPRA34RjgAp/Yl3ut0ehR7HpsLuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3TbSjo8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C068606A320;
	Wed, 18 Nov 2026 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3TbSjo8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86C61F000C4;
	Wed, 18 Nov 2026 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023721;
	bh=V12o9OqkcuiLlAJYwdSSDIMUM0CHJLPq8TOScbWIIo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3TbSjo8/ELJPY0QNxwkGG0dEh55S0f7JX5U65Bx7bkeDnVSL9NI9YnnhoI5RNATq
	 2juOzVyU4fFcBFjNqOEcB6SOqHBc2HxbIxO991J5D0BPIn4vu0fXy9TdjRE6Fkgt4K
	 BjPykKo60u1tMjly0K2/LkfLjgaUVWxsDKudvzFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0468/2151] cxl/hdm: Make switch decoder target parsing endian-safe
Date: Wed, 18 Nov 2026 15:36:43 +0100
Message-ID: <20261118150139.057370355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 3f846646b3d3b5699139e686e1107d231a725860 ]

Switch decoder target IDs are stored one per byte, starting with
target 0 in the least significant byte. The current code accesses
those bytes in memory order, which only matches register order on
little-endian hosts.

On big-endian hosts, the target IDs are reversed and the decoder is
associated with the wrong downstream ports.

Place the register values in a byte array in little-endian order and
index the target IDs from there, so the target mapping is independent
of host endianness.

Fixes: d17d0540a0db ("cxl/core/hdm: Add CXL standard decoder enumeration to the core")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/b0526825b3c3ffdb78837563e178d9aa27b6bbb8.1786143520.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index f49e3139c8281..16cf4f116a97b 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
 #include <linux/seq_file.h>
+#include <linux/unaligned.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 
@@ -972,15 +973,12 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 			    u64 *dpa_base, struct cxl_endpoint_dvsec_info *info)
 {
 	struct cxl_endpoint_decoder *cxled = NULL;
+	u8 target_id[CXL_HDM_DECODER0_TL_TARGETS];
 	u64 size, base, skip, dpa_size, lo, hi;
 	bool committed;
 	u32 remainder;
 	int i, rc;
 	u32 ctrl;
-	union {
-		u64 value;
-		unsigned char target_id[8];
-	} target_list;
 
 	if (should_emulate_decoders(info))
 		return cxl_setup_hdm_decoder_from_dvsec(port, cxld, dpa_base,
@@ -1093,11 +1091,12 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 			return -ENXIO;
 		}
 
-		lo = readl(hdm + CXL_HDM_DECODER0_TL_LOW(which));
-		hi = readl(hdm + CXL_HDM_DECODER0_TL_HIGH(which));
-		target_list.value = (hi << 32) + lo;
+		put_unaligned_le32(readl(hdm + CXL_HDM_DECODER0_TL_LOW(which)),
+				   &target_id[0]);
+		put_unaligned_le32(readl(hdm + CXL_HDM_DECODER0_TL_HIGH(which)),
+				   &target_id[4]);
 		for (i = 0; i < cxld->interleave_ways; i++)
-			cxld->target_map[i] = target_list.target_id[i];
+			cxld->target_map[i] = target_id[i];
 
 		return 0;
 	}
-- 
2.53.0



