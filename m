Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043156;
	b=5Kw/rjPkrP1Kvb87b3O8VQiIujqqhvlNgQpgzovQOWZ1spKnhs5zPkfmicKZttYEGfYD
	 r8RIHnDlm+p8RSzoirJyVr/8x2oJK2OOScM4jrmOy1D29ydcHqXO46ZarcQACnIs5kT1P
	 AeVyP/6NZ+4t+uwtDvRclQLWaAoNcmVv1SaNiRClA2wve5Z+ZyhJWKVrcfAivbE8oInDn
	 upCYS3+/AwmbIiBTARYHrt2smpcJw/WT/i24DRuVuMftRS22qja/FVAQkguFw4AxgfaP7
	 09OySjWdfkBJFDOGZrnIC4EfAUpO/u629bO0Fe8bE5UmIJpVbgz9eVZAdz4i9YK44yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y3wmmcjg/1EAvl6uwN96YqwEnnIgnKUeQHenRTfA7ys=;
	b=LKKKkK7WoA6Mvr45MMLfGrxaLOLFTxUBoIhDY3xgVIcubxgN1bVTu75mxD1Ww9T4zGky
	 r4EA8ArYWYfHdDjMxGEXKr6lpRO2PlKQN94f4IBWSyTmMgd8GxAqAFK+MUO97ULEmJ3Wi
	 9+fSnS9TtEEfmXkbcYa8JZe0QAHpnCxFjHfFVS7Kme0uK3Klfwkxdsz4sVO5bUfIB9RWW
	 LP+NvfaOgBLNavlY6I4CljAXGIUoNHGT5Xh0LKMigKd4WtQlmLIGuzDAzchOqngVdRcQA
	 fD9KmkQD1ABusEKPn0bmxp0J5+FIkyvcSDZ2KmKvka3efiq+/uD6knu8hhFzytLK+nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOX+sI5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598C4606A32A;
	Wed, 18 Nov 2026 23:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOX+sI5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C1C1F000C6;
	Wed, 18 Nov 2026 23:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043155;
	bh=Y3wmmcjg/1EAvl6uwN96YqwEnnIgnKUeQHenRTfA7ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOX+sI5rlbhik33/gnXt8UwZKLGuHvBaKP4KanM4iZ3Dt+7aKDrJO0iTDyykuHNjB
	 mG5aNMFIMEue8LTmVcCm8Vpe011ng0jQ9AdMwByPeXMHnlyBNqEzE8U9WQQN+pFKqD
	 Nwg7CAuydbV1au+NHpi/S24mLPfeEH5bcANzuesE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0058/2857] mmc: cqhci: fix to missed endian conversions
Date: Wed, 18 Nov 2026 15:18:12 +0100
Message-ID: <20261118150203.395907939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/mmc/host/cqhci-core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/cqhci-core.c b/drivers/mmc/host/cqhci-core.c
index fe7a4eac9595c..d942f3fe95abe 100644
--- a/drivers/mmc/host/cqhci-core.c
+++ b/drivers/mmc/host/cqhci-core.c
@@ -479,11 +479,11 @@ static void cqhci_set_tran_desc(u8 *desc, dma_addr_t addr, int len, bool end,
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
@@ -532,7 +532,7 @@ static int cqhci_prep_tran_desc(struct mmc_request *mrq,
 static void cqhci_prep_dcmd_desc(struct mmc_host *mmc,
 				   struct mmc_request *mrq)
 {
-	u64 *task_desc = NULL;
+	__le64 *task_desc = NULL;
 	u64 data = 0;
 	u8 resp_type;
 	u8 *desc;
@@ -564,7 +564,7 @@ static void cqhci_prep_dcmd_desc(struct mmc_host *mmc,
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



