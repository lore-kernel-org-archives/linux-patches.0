Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021989;
	b=O7Z7eqgCoFe10OM1psuCV/0x69uLjbaHs596sd1CuXUWR+eCzcf3LhhZ0099gB9GRQ+B
	 xdbsgBz3O/ZD9NazCpoS2+b5mS2H2j9OLlGFZ81TJTGs3gmAnlwscHPIzmB6xAWPnb68j
	 jNQ0p8lGskFz5YU84mABF2Lk0rbjgwny6tGWoZdn3taogW42pYRr+gelmblXIeejKD+Cf
	 AeE60eSMDXtHg89IRinSyt5xqzAXAGo57tH28i8OXnDLVMoUbXN/Frn0o6wafPyOPHdr2
	 XumfqkFSpsi6HhFBUsjoFwlaOB43PmzarIQ0ufYxbnhVltUDY0m35Nk1Qe8SqptyIjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KKWla56vDVS3gLGCmAdBTNeZvqEmCt+VNV08Zj4pxvE=;
	b=kQY31hDNp+dafcWGlr8hnzyVl3C07ygHomYAfJSmMXBmju1cFD4eGuMpyVRqGuo3HD7U
	 f1KFly2T7Fg/3vLXvLswu4aYkPkj5dU5kfqGLaCDs3zjDGNOBZI74g4Ponvi2WWHXxluF
	 gtuF6VDD0Y8wYK2xS/7xuEOopjV1n1GnCS/EdcVtrEvn5afOxiQq2hlOPSkG1LVSD8YBt
	 1Gl+dtbwvxDeiOXnzs7CKoJuONvO5TbdTrIaSNwDbKkBtvnKu//LqWMzM338Wai+ymuJi
	 LYRFg9lEUyJNrVwzL9QeOakiG0IBE78lBOXhpCS6+PFl2QD6cFcsWZQgjcWF4y2JpTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjtjLAzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E41606A31C;
	Wed, 18 Nov 2026 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjtjLAzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36D21F000C4;
	Wed, 18 Nov 2026 17:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021989;
	bh=KKWla56vDVS3gLGCmAdBTNeZvqEmCt+VNV08Zj4pxvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjtjLAzPtTdhdOdmQhkRTe3ORJzdQg/tQlZ8X4KHwfYmOmnn3j+3lizNEUv5uGbVS
	 v/yN0n3j3sviqWy+YxouNphWeH6AMAY2+Z9aDjn7DrxfE8gOimwNyQVgyzbGFBTueH
	 UH2RLy3WVmkcnxWa370gPBZQ9ymbA0Y6nOnd4daE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2504/2651] net-sysfs: reject a one-entry RPS flow table
Date: Wed, 18 Nov 2026 16:02:24 +0100
Message-ID: <20261118150414.926810942@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 352173df75785..2b3dab9611c07 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1088,6 +1088,13 @@ static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
 		while ((mask | (mask >> 1)) != mask)
 			mask |= (mask >> 1);
 
+		/* Require at least two entries. A one-entry table rounds up
+		 * to mask == 0, which encodes log == 0 in the tag.
+		 * get_rps_cpu() then computes hash_32(hash, 0), a shift by 32.
+		 */
+		if (!mask)
+			return -EINVAL;
+
 		/* Do not accept too large tables. */
 		if (mask > (INT_MAX / sizeof(*table) - 1))
 			return -EINVAL;
-- 
2.53.0



