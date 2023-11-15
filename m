Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7023C462
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmsiMX6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604F8C433C8;
	Wed, 15 Nov 2023 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077099;
	bh=rpUqwJ79/YIn6c3fSzfAz2yZYLWkjY/BcxTTcaPR7Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmsiMX6bmdCaco7D1RjJ+cyxZ8olXJexlPmCQ1eWD219N3pkzV+IuykMOykFhK/7Q
	 ljn3tZ0BHTPDzYX7pkPmi1vfy8JhWC7ubdWZolSOuaH4bgGecwU2ZT8AWgE9Mu8EL+
	 NnPpMALAp8oguVpcL8ib2mB++lhVx7E8F09+KpXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 504/550] octeontx2-pf: Fix error codes
Date: Wed, 15 Nov 2023 14:18:08 -0500
Message-ID: <20231115191635.850758436@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 96b9a68d1a6e4f889d453874c9e359aa720b520f ]

Some of error codes were wrong. Fix the same.

Fixes: 51afe9026d0c ("octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://lore.kernel.org/r/20231027021953.1819959-1-rkannoth@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_struct.h       | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index fa37b9f312cae..4e5899d8fa2e6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -318,23 +318,23 @@ enum nix_snd_status_e {
 	NIX_SND_STATUS_EXT_ERR = 0x6,
 	NIX_SND_STATUS_JUMP_FAULT = 0x7,
 	NIX_SND_STATUS_JUMP_POISON = 0x8,
-	NIX_SND_STATUS_CRC_ERR = 0x9,
-	NIX_SND_STATUS_IMM_ERR = 0x10,
-	NIX_SND_STATUS_SG_ERR = 0x11,
-	NIX_SND_STATUS_MEM_ERR = 0x12,
-	NIX_SND_STATUS_INVALID_SUBDC = 0x13,
-	NIX_SND_STATUS_SUBDC_ORDER_ERR = 0x14,
-	NIX_SND_STATUS_DATA_FAULT = 0x15,
-	NIX_SND_STATUS_DATA_POISON = 0x16,
-	NIX_SND_STATUS_NPC_DROP_ACTION = 0x17,
-	NIX_SND_STATUS_LOCK_VIOL = 0x18,
-	NIX_SND_STATUS_NPC_UCAST_CHAN_ERR = 0x19,
-	NIX_SND_STATUS_NPC_MCAST_CHAN_ERR = 0x20,
-	NIX_SND_STATUS_NPC_MCAST_ABORT = 0x21,
-	NIX_SND_STATUS_NPC_VTAG_PTR_ERR = 0x22,
-	NIX_SND_STATUS_NPC_VTAG_SIZE_ERR = 0x23,
-	NIX_SND_STATUS_SEND_MEM_FAULT = 0x24,
-	NIX_SND_STATUS_SEND_STATS_ERR = 0x25,
+	NIX_SND_STATUS_CRC_ERR = 0x10,
+	NIX_SND_STATUS_IMM_ERR = 0x11,
+	NIX_SND_STATUS_SG_ERR = 0x12,
+	NIX_SND_STATUS_MEM_ERR = 0x13,
+	NIX_SND_STATUS_INVALID_SUBDC = 0x14,
+	NIX_SND_STATUS_SUBDC_ORDER_ERR = 0x15,
+	NIX_SND_STATUS_DATA_FAULT = 0x16,
+	NIX_SND_STATUS_DATA_POISON = 0x17,
+	NIX_SND_STATUS_NPC_DROP_ACTION = 0x20,
+	NIX_SND_STATUS_LOCK_VIOL = 0x21,
+	NIX_SND_STATUS_NPC_UCAST_CHAN_ERR = 0x22,
+	NIX_SND_STATUS_NPC_MCAST_CHAN_ERR = 0x23,
+	NIX_SND_STATUS_NPC_MCAST_ABORT = 0x24,
+	NIX_SND_STATUS_NPC_VTAG_PTR_ERR = 0x25,
+	NIX_SND_STATUS_NPC_VTAG_SIZE_ERR = 0x26,
+	NIX_SND_STATUS_SEND_MEM_FAULT = 0x27,
+	NIX_SND_STATUS_SEND_STATS_ERR = 0x28,
 	NIX_SND_STATUS_MAX,
 };
 
-- 
2.42.0



