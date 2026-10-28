Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210735;
	b=K3X9Dynt9V5XYmDUy16qLLjyVj57WQLQQCeG0qqm2ocygrDPaZIc9TFncW/EchPHH+Bw
	 KhXVKtEsYVlUv+e72toaTvs7Wvrkxo9kymppB2PEU+xA4upTXds5aBiI4GdFbrdBDxJyp
	 rAxzt9aUAyqYbOmJ/+WyhDkULgxcgzIWITy67p0enfzi/NlhJY8hIuI+lsMf1YhOGClrl
	 Ec6xW98tkk7Kuphsxz3bWKPb8d0yPLlxRDK748FdiVUc0Md+/zLFfgXU2KWzSIsi4Qo3s
	 HzdR9s4BWse/LqcmjO9dA1sPOcF8AV2wqgXiJQNtBBWbSFA05UJmQKROLCFUMHw5PVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DwZCqfT/UshiRq0o/QenVYxQt8Bpyaery/a0VvrtCrY=;
	b=PiFN9BybhK9Gfg1Mcy0VPEK/ZsiFW5xxDl3nYYpzk8UJmbF4n91yhO605UKHV9w9Oq9i
	 4/vsxVmsGKJkgwKRj/4U8wAPL80IyL+PuCd3yL8Xc/i66qyPg3toilnZzmQouKjQSJjE4
	 NTkqkMa5S9AeUfw9FFUDX3BMyrFavC6OnnJD4FwhFb+iCu0FhDh+diucuqwoINIE6m6t5
	 AflY9bIYZ5ECc88R9+L9Cnvk1m6/+HN50g6KToBMLpASUQ4LrmJeuU7luRRAxqIaGjHwR
	 LZRUwlWwE8+YT3OTN1OZKwH+tzOmtirxdgxJ1uvraByIt37jKilmHYNhPRRFx6JAJ4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAnnBGFC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D832606A31D;
	Wed, 28 Oct 2026 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dAnnBGFC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1601F01825;
	Wed, 28 Oct 2026 18:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210735;
	bh=DwZCqfT/UshiRq0o/QenVYxQt8Bpyaery/a0VvrtCrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAnnBGFCuhZVr4mJq3tCR5zISKom3m5fcZ+NrXTjjSvuErDjkVBS4UHqOnq4Np30Y
	 bDJy/iytggzcp6xRVjgWxhXalzEbM9ElknDXBaBwpR37D0UUfXJw5nzCEPfVAZ1hYB
	 kIW2AF0xZx53NY6e3OiHtnjhXxHaZZ6aEkJQfx2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/571] scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
Date: Wed, 28 Oct 2026 17:53:53 +0100
Message-ID: <20261028170010.066672681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 991360c138a6c..7b511a5cb70a1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5650,7 +5650,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_mbx, vha, 0x1107,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		if (mcp->mb[1] != 0x7)
+		if (mcp->mb[1] != 0x7 || IS_QLA28XX(ha))
 			ha->link_data_rate = mcp->mb[1];
 
 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
@@ -5661,8 +5661,6 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
 		    "Done %s.\n", __func__);
-		if (mcp->mb[1] != 0x7)
-			ha->link_data_rate = mcp->mb[1];
 	}
 
 	return rval;
-- 
2.53.0



