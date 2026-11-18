Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051009;
	b=ZwyUyjNTgw2chawaSOKngASnBN0DPpYAbA+1xdczhegC3oo+TO8JfK2vNwgWzdqp997W
	 ZUmYGBc8Ih+kY8cu/OgPVT7gW3pLOcrGS7926H7ok8nv5NPb7z55gohiWS/H6q6cJ7Yow
	 cn+lLmSG9U7yylTQS1rP6Jg643GMk5dsd+vOgAdo4lQmJB4NpnHle4VUJAGsLUN9YLd2w
	 mmpbrennOOzv2Ih5cBw/R6PRbqMbms2RJTvXXJUw1/3N/XRWJACyhDyhE/MtYDWSXZEvN
	 mOSbM6ZY7nFXopsf+VH0eWPe1/+N5l9EvXrTFSDHVwVn7Spyojdns4xpV0L1LPcJ/mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GKBpiF/tFFFwKDIxj++WTieXv9A9AnjJ0pm3if5atro=;
	b=0z8eJ0QBPEGKks76fqeFsWm5jLsiNZK2bqy3lbqIXTEoiJYD4sjDlCz3h4yO8GU72Aob
	 xH0H9sfkAJllhdpJDn/mjem7JVPUd/1tGtuy1gDvLuH9iz9fvc+tXZ75hUHKyxYJ0GCap
	 UjXIMu4U1kAzSoe+slJ1FwO9miapzAkOAtiOXYnF3oasrnK90WcvbsWJ1Jl8FSPHlRWrF
	 XXIygCUu2j/RjIiy/86N6eOKiYkRJ6LhFmieKONy4t7Tk37mAY+PhF2l2K6tV2sXp1UhA
	 DMiULiZpJi2yjysUE9UamWwqe73RwR1eSut1td3b6PJWrSnFByx8KBsCp/9cKqT/H2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EunhYUGa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF504606A32F;
	Thu, 19 Nov 2026 01:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EunhYUGa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F361F000C4;
	Thu, 19 Nov 2026 01:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051008;
	bh=GKBpiF/tFFFwKDIxj++WTieXv9A9AnjJ0pm3if5atro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EunhYUGapdux8tRDg95ZeeNHuVXB2fLOU9v/YlPZarXhA3MJ6KJ0GEiNyO8Rd7a+l
	 EjLebwlYNwUXlSONH4y2iqeXH7v7ZmvzsmqrE5DiBPfEeg59tvCrz8UoNLhOYL879H
	 T1ymH6QINhIFxKOky7EbhqiZwc8+XLUTk6D0gDRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0057/2214] mmc: cqhci: fix to missed endian conversions
Date: Wed, 18 Nov 2026 15:28:53 +0100
Message-ID: <20261118150012.305987648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 9569d56193bcd..80a960f7de2e1 100644
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



