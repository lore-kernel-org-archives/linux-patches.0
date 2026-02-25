Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6EA18DB2A;
	Wed, 25 Feb 2026 01:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983184; cv=none; b=EJhWk9PnwmfgmV1eFlJFpuHr5pnan1CeG95VDyFwx0Ndwgc2Wky1anFcM2VdtbZYT7Atdhd2sNmUtBFaF6Mzvmv+m0fLYUb8bPn8SC1F1irO5+bqzj8I3gY6XlcCNZuNcAEQyx/wIYmblvY4J4rin+96Im87LAuMNX/DvfvjKbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983184; c=relaxed/simple;
	bh=Gner84l3i3lZv9hARPkP8cZE5EWBKcrKM1bP1N7ODRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5upKyvYt4Ilwwkf3rgILQqQ9DKYNZM/vy+GWaM1HDIiniImlppzEl2RBUv/fh+noQmWFm3TPxKnAv8IcOTbxceQxBDUy5qoI8F6VVLjaagQC+pI3Ig+qA08TYyIMkAig5z7p8oiFA2u2y2yF6ivUWDyNNx17uR1Dw/7ucb5XIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkMNIWJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkMNIWJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D41C116D0;
	Wed, 25 Feb 2026 01:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983184;
	bh=Gner84l3i3lZv9hARPkP8cZE5EWBKcrKM1bP1N7ODRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkMNIWJeeS1aYaXCUY/opoiXQ3GhIjyN6R5uKkq5t1S+hyJRJHTX7WivZ2T6m1hT3
	 Qiw0qjr58nnBluysA/WMf4OBBq+iMZzVY8IQf+BTsJoWk03dfTOPnQm/pRpxb2Htu1
	 T2JwRO2GF+sZGSrWt6SshuClhezlpqMIUv48+Y94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 334/781] wifi: ath9k: debug.h: fix kernel-doc bad lines and struct ath_tx_stats
Date: Tue, 24 Feb 2026 17:17:23 -0800
Message-ID: <20260225012407.890756269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c6131765a2c0052b2c5a2310ff92191ff33aec8b ]

Repair "bad line" warnings by starting each line with " *".
Add or correct kernel-doc entries for missing struct members in
struct ath_tx_stats.

Warning: ../drivers/net/wireless/ath/ath9k/debug.h:144 bad line:
  may have had errors.
Warning: ../drivers/net/wireless/ath/ath9k/debug.h:146 bad line:
  may have had errors.
Warning: ../drivers/net/wireless/ath/ath9k/debug.h:156 bad line:
  Valid only for:
Warning: ../drivers/net/wireless/ath/ath9k/debug.h:157 bad line:
  - non-aggregate condition.
Warning: ../drivers/net/wireless/ath/ath9k/debug.h:158 bad line:
  - first packet of aggregate.
Warning: drivers/net/wireless/ath/ath9k/debug.h:191 struct member
 'xretries' not described in 'ath_tx_stats'
Warning: drivers/net/wireless/ath/ath9k/debug.h:191 struct member
 'data_underrun' not described in 'ath_tx_stats'
Warning: drivers/net/wireless/ath/ath9k/debug.h:191 struct member
 'delim_underrun' not described in 'ath_tx_stats'

Fixes: 99c15bf575b1 ("ath9k: Report total tx/rx bytes and packets in debugfs.")
Fixes: fec247c0d5bf ("ath9k: Add debug counters for TX")
Fixes: 5a6f78afdabe ("ath9k: show excessive-retry MPDUs in debugfs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20251117020304.448687-1-rdunlap@infradead.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/debug.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index cb3e75969875a..804e2a0a0c20f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -142,11 +142,12 @@ struct ath_interrupt_stats {
 /**
  * struct ath_tx_stats - Statistics about TX
  * @tx_pkts_all:  No. of total frames transmitted, including ones that
-	may have had errors.
+ *	may have had errors.
  * @tx_bytes_all:  No. of total bytes transmitted, including ones that
-	may have had errors.
+ *	may have had errors.
  * @queued: Total MPDUs (non-aggr) queued
  * @completed: Total MPDUs (non-aggr) completed
+ * @xretries: Total MPDUs with xretries
  * @a_aggr: Total no. of aggregates queued
  * @a_queued_hw: Total AMPDUs queued to hardware
  * @a_completed: Total AMPDUs completed
@@ -154,14 +155,14 @@ struct ath_interrupt_stats {
  * @a_xretries: No. of AMPDUs dropped due to xretries
  * @txerr_filtered: No. of frames with TXERR_FILT flag set.
  * @fifo_underrun: FIFO underrun occurrences
-	Valid only for:
-		- non-aggregate condition.
-		- first packet of aggregate.
+ *	Valid only for:
+ *		- non-aggregate condition.
+ *		- first packet of aggregate.
  * @xtxop: No. of frames filtered because of TXOP limit
  * @timer_exp: Transmit timer expiry
  * @desc_cfg_err: Descriptor configuration errors
- * @data_urn: TX data underrun errors
- * @delim_urn: TX delimiter underrun errors
+ * @data_underrun: TX data underrun errors
+ * @delim_underrun: TX delimiter underrun errors
  * @puttxbuf: Number of times hardware was given txbuf to write.
  * @txstart:  Number of times hardware was told to start tx.
  * @txprocdesc:  Number of times tx descriptor was processed
-- 
2.51.0



