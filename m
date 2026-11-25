Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622758;
	b=jP2EvUo3Dk5qz7jRcyNca3LjqZPO0ibAm7v81+v8Y3XsWgDpdsjtBQiU+ATSSOY2zwkc
	 hfzT0Gltu827HU+lNJGPI2S0AboWRAUGjeNU7+VtvDB56EO/tgmhxvQxqwJ3bSI/oYXOL
	 IEyAwRzFXMuADLFKV6pJXA1azoeAFFjkaGqFP2it7VaaOPmUQCT0y0P4BwW+AS30RHnrk
	 K9syCpSkTpEk8cOeTylJSR6Dl/KvBpeMODw2/O/Xj2AHhhMAJA6PUkqifnZ1wp2DOxhfX
	 gagbl4/WdFRka/Tg6NO4QQvu3CiJQmGS3u3VBDTNZ2q7qnzr4emhQYYGTv0FJf1iNfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mh9EBSoQb68f83g1fNNMXt7KE2DBZuzoF4MXsQZetIo=;
	b=1Da2uJW3tquAJF6jqRgRAIL14DqDVttV/QYYt7gcWSiLpFny7wr2YYXYJxa0SoIRO7Ji
	 Tv8Jl2VbeFs1aBqmaldQRQrM+me60O1fajXkn5brXg2Qat+Nom/sPqT3Ezxl8MZjEb+N/
	 KacoCub6tmggagfMwbZZk9bAq9o1wP8/Fh8NX9caVQt6QjRor2AaO8I3dtSC4lPe2B5+T
	 AXMd+xWOqoTybZpjCRFPl7hyvoXZPAPb6/R+KOaH5vlS7hoCpEloqZi2pvZBtTMKA9diG
	 l+6LsBrKogAoUrNPShT3GcMuVdUsjl+S3ZlXQbZlmPjltHkZU9Sp6CKxrDeSpMGhQRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tC3KBU60;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F685606A31E;
	Wed, 25 Nov 2026 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tC3KBU60
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE0D1F000C4;
	Wed, 25 Nov 2026 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622758;
	bh=mh9EBSoQb68f83g1fNNMXt7KE2DBZuzoF4MXsQZetIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tC3KBU60+Ug151IbBtA25NxUAaMWnmNla3yPaeShee9fECSCDHC+pKg13u9F4kgtk
	 nnsspKkFm6jmt8tAPk9qzMRydA/u7GtOw+qDW/xXLxptqqeoINrsmg18Kq/jE+J2st
	 gEpQmOJ6tIKX+AXDiGsIV0q6FrqnsgH67+/Lc5UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 636/990] net-sysfs: reject a one-entry RPS flow table
Date: Wed, 25 Nov 2026 15:33:23 +0100
Message-ID: <20261125143836.991983142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 24927bdf0f62f63470a065c21d80fff7e4e9f207 ]

store_rps_dev_flow_table_cnt() accepts rps_flow_cnt == 1.  For count == 1
the round-up loop leaves mask == 0, which is stored as log == 0 in the
tag (tag_ptr |= ilog2(mask) + 1).  get_rps_cpu() then calls
rfs_slot() -> hash_32(hash, rps_tag_to_log(tag_ptr)) with log == 0:

  include/linux/hash.h:68
	return __hash_32(val) >> (32 - bits);   /* bits == 0 -> shift by 32 */

The shift by 32 is undefined and yields the full 32-bit hash, which is
used to index the one-entry rps_dev_flow[] table unchecked:

  UBSAN: shift-out-of-bounds in ./include/linux/hash.h:68:24
  shift exponent 32 is too large for 32-bit type 'unsigned int'
   __ubsan_handle_shift_out_of_bounds+0x11c/0x208
   get_rps_cpu+0x12fc/0x1344
   netif_rx_internal+0x1e0/0x4d4

rps_dev_flow[] is then read (rflow->cpu) and written (last_qtail) out of
bounds on the packet path.  Require at least two entries.

Fixes: f3483c8e1da6 ("net: rfs: hash function change")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Link: https://patch.msgid.link/20261021155522.67521-1-phx0fer@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Context lines adapted to the older overflow checks and vmalloc code; the added if (!mask) return -EINVAL; block is otherwise identical to upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 3a3a92f3a314c..e408f0b6786b7 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1101,6 +1101,14 @@ static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
 		 */
 		while ((mask | (mask >> 1)) != mask)
 			mask |= (mask >> 1);
+
+		/* Require at least two entries. A one-entry table rounds up
+		 * to mask == 0, which encodes log == 0 in the tag.
+		 * get_rps_cpu() then computes hash_32(hash, 0), a shift by 32.
+		 */
+		if (!mask)
+			return -EINVAL;
+
 		/* On 64 bit arches, must check mask fits in table->mask (u32),
 		 * and on 32bit arches, must check
 		 * RPS_DEV_FLOW_TABLE_SIZE(mask + 1) doesn't overflow.
-- 
2.53.0



