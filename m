Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057292;
	b=uQNFCfYb91SyJspPLEJYw83dL/caRKYbTWoPR6AY6rBllBktpyS7kJoNNR0IFUjv/C6y
	 TKzYaMvs0solO5LdT5yM2ckDqxr46P60WHPpQ3tZ6vLubWUBClIFWi6uFOtp7wPvzJzxJ
	 pkVHrkSfEFXcQHQIIrhQupYurhCax2uxMLgfjf4eERBLvhZ1h7EPxHqWi6PWyxgY9dK8k
	 r4xBhuXJNZpW0jR+2lEHkR4WKhCNKwiiX6coYwbaIv5uf8ZAtiVIriS1Xx2UiKrLcDZd6
	 v0YN4Ixuit9Np1vFjWydMfpcZrwpHmZk6o5yveDNMNPg6jjdBrGenl33DIg1Z76rmTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pA//OYq0jqyh5/fi9e+MtdXLmei28N+eeG0l+u0tKzs=;
	b=BGcIk/+mYynn/FgfxloZpQvIB4YPg7yHawPMHe5bNUQ1ZNwmkIe1XITFRyS0YfuVV6ga
	 JojmNV9y+OSTMG2ZX6FkJOFJCVVgWGtxernQH6tfHC68/tZ+32MVPJR5aCQALc5e2+tmw
	 m16tssIcDU7sprgLNgU8pA4zAO4n9jl6CDvT/9IR04BqC/hcnbBRtr4UCZpNzft6bswRC
	 46eeJ+6WYbki8/RGhtUeHEQaAoJy/9y2V1Puq5BU4NFOgcE8c1V+kDvFXjaLy61xgkVW1
	 VmCZhwcq12cTYIA5Gzx/b+/CjH8SDRVvVi+7kf8eP1opqdEfyjg3pTIE89nhJVtjQBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QcGjJ6Z0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D962460A5BD2;
	Thu, 19 Nov 2026 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QcGjJ6Z0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BB11F000CA;
	Thu, 19 Nov 2026 03:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057292;
	bh=pA//OYq0jqyh5/fi9e+MtdXLmei28N+eeG0l+u0tKzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QcGjJ6Z0VzMoyff9FT2wBI8qLzrqbNDVQ7cfHx9eh91kJ0ZkC3SKMZPIZfunoAfDy
	 4kA3ilnnWrGbhvyUfiOV8anZl+V4G/llsixEmurlDEz6bT6J9WI+fiw1p6aT5KBlzT
	 F0E4DsWhCDegECWBwWG3k0s2EDRtioH5CrdiRJcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0052/1848] mmc: cqhci: fix to missed endian conversions
Date: Wed, 18 Nov 2026 15:34:50 +0100
Message-ID: <20261118145913.291396763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 0aae2c73175821a71c0e20607f8e333be5b71940 ]

Fix two places where the wrong type or conversion of little-endian
types to fix the following sparse warnings:

drivers/mmc/host/cqhci-core.c:487:15: warning: incorrect type in assignment (different base types)
drivers/mmc/host/cqhci-core.c:487:15:    expected restricted __le32 [usertype]
drivers/mmc/host/cqhci-core.c:487:15:    got int
drivers/mmc/host/cqhci-core.c:566:19: warning: incorrect type in assignment (different base types)
drivers/mmc/host/cqhci-core.c:566:19:    expected unsigned long long [usertype] *task_desc
drivers/mmc/host/cqhci-core.c:566:19:    got restricted __le64 [usertype] *

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/cqhci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/cqhci.c b/drivers/mmc/host/cqhci.c
index 6a350f4953528..03c29ee8f1534 100644
--- a/drivers/mmc/host/cqhci.c
+++ b/drivers/mmc/host/cqhci.c
@@ -457,11 +457,11 @@ static void cqhci_set_tran_desc(u8 *desc, dma_addr_t addr, int len, bool end,
 {
 	__le32 *attr = (__le32 __force *)desc;
 
-	*attr = (CQHCI_VALID(1) |
-		 CQHCI_END(end ? 1 : 0) |
-		 CQHCI_INT(0) |
-		 CQHCI_ACT(0x4) |
-		 CQHCI_DAT_LENGTH(len));
+	*attr = cpu_to_le32((CQHCI_VALID(1) |
+			     CQHCI_END(end ? 1 : 0) |
+			     CQHCI_INT(0) |
+			     CQHCI_ACT(0x4) |
+			     CQHCI_DAT_LENGTH(len)));
 
 	if (dma64) {
 		__le64 *dataddr = (__le64 __force *)(desc + 4);
@@ -510,7 +510,7 @@ static int cqhci_prep_tran_desc(struct mmc_request *mrq,
 static void cqhci_prep_dcmd_desc(struct mmc_host *mmc,
 				   struct mmc_request *mrq)
 {
-	u64 *task_desc = NULL;
+	__le64 *task_desc = NULL;
 	u64 data = 0;
 	u8 resp_type;
 	u8 *desc;
@@ -542,7 +542,7 @@ static void cqhci_prep_dcmd_desc(struct mmc_host *mmc,
 		 CQHCI_CMD_TIMING(timing) | CQHCI_RESP_TYPE(resp_type));
 	if (cq_host->ops->update_dcmd_desc)
 		cq_host->ops->update_dcmd_desc(mmc, mrq, &data);
-	*task_desc |= data;
+	*task_desc |= cpu_to_le64(data);
 	desc = (u8 *)task_desc;
 	pr_debug("%s: cqhci: dcmd: cmd: %d timing: %d resp: %d\n",
 		 mmc_hostname(mmc), mrq->cmd->opcode, timing, resp_type);
-- 
2.53.0



