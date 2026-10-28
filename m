Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208360;
	b=BnCmmLGv2S8hTkIp9C0wGVjKQvaWHbr+JcvBgYRjzkl063qK3GU6qmunmqj0o46rzGWG
	 CEDNCiwcuNaqqxl7z1R8aG5A3X+3Whu20bsUTXdUrBZjo7MZrOOKyHCahVTNDs8vE7DRR
	 jUJhXrGU2kv+BRCEr6afwhgEV5+TkRWzugcbkOWJBjm7tN2/atkJ6V015Rf02fyC11xSN
	 UeHW6y0JGV3rDV1PEfijBLbB39mR7sCnvkKilF0l+XhmuOoIdJha/J6AKIAtfooeDIbh6
	 xWQNZ2RF60QI5O6XmdMKYOWgMYTDcgcWhMar61AC1lYjPU0QGTJA9G5eK/jL3foyvGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nVr48rxq+GqWgeu8tCyeqAOGURAOMC57QlvLeQUpQ5k=;
	b=B3fuU/TkWJxyqyR/vY4TVwLkqIhVGxawZQZ9X14P7h9TIXUkqqiEyBXKKrLJKrz73oE0
	 c/sD8i2LdNDvQWlqr5dLEIEJvnq231DMkyzb0duIP4pDmqJQiHJMPm7diUg9bHSziGCG9
	 7K+XOjp+kTu8v7WhUasfc9yCvc2A9AH8lAU8MkgJ5WX7hMsiP13Lz8AD9gs07Gzlx1EaT
	 AVQXotIKGlYUcN71fmSICs1tqMTE/lyyVd+Rxf2WGvj481WfWlgzVyMNhjLLgc/n6p3FH
	 v4veeeK6fTQNx7WDoW14CggM5G9bktDX4ENfvWgywWLzd+d0fxcjZmQFe5ZlT2jYlsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnIjOMPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69293606A320;
	Wed, 28 Oct 2026 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnIjOMPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B661D1F01828;
	Wed, 28 Oct 2026 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208360;
	bh=nVr48rxq+GqWgeu8tCyeqAOGURAOMC57QlvLeQUpQ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnIjOMPi7P3goXF92pOK2Ioz0Klgcak+ajZD4ZVV1WarFEaWdhlivVbhNhN4I8/Eq
	 kASP5x8SEzVuIkp1LemMk1myDQ2ZQgzWJEhWnf1i4H7OdPa6pVd5fKf1ZisYiAR2hQ
	 B6bO74faHqo18YF0de8z7QXB8YKqG8wBwqmzbdWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/516] scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
Date: Wed, 28 Oct 2026 17:54:02 +0100
Message-ID: <20261028170005.653515025@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 52fba32317ee631faa878725b2f7cd5c08acacd3 ]

qla2x00_get_data_rate() skips updating ha->link_data_rate when the
firmware returns mcp->mb[1] == 0x7.  That value was a legacy sentinel
from before 64G hardware existed, but PORT_SPEED_64GB is now defined as
0x07 and ha->link_data_rate is decoded with the PORT_SPEED_* encoding.
On a 64G-capable adapter a genuine 64G link is therefore dropped, and
the port speed is misreported (port_speed sysfs, fc_host speed, FDMI).

Only 28xx and 29xx support 64G, so accept 0x07 on those adapters while
keeping the legacy filter for older ones.  Also drop the duplicate copy
of the check at the end of the success branch; it repeated the first
assignment with no intervening change.

Fixes: ecc89f25e225 ("scsi: qla2xxx: Add Device ID for ISP28XX")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-46-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ Omitted IS_QLA29XX() checks because this branch lacks 29xx adapter support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c55f3ddd890c8..0e8ab14451e77 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5573,7 +5573,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_mbx, vha, 0x1107,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		if (mcp->mb[1] != 0x7)
+		if (mcp->mb[1] != 0x7 || IS_QLA28XX(ha))
 			ha->link_data_rate = mcp->mb[1];
 
 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
@@ -5584,8 +5584,6 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
 		    "Done %s.\n", __func__);
-		if (mcp->mb[1] != 0x7)
-			ha->link_data_rate = mcp->mb[1];
 	}
 
 	return rval;
-- 
2.53.0



