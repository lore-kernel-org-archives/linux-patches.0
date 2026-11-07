Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060697;
	b=wMCFfOdag2rmBoExAuA9SkEFWzPMNKWWNkkw+RadWXuvkhsUAA6GE5Z+wYXNqAMzBfqF
	 2yJgtLVbyAG7gp/Y9wFtXVTVjLWaZFDfzAxKK+X+N7+sDL7kJcNtpmNMMmkgjY4KXANvH
	 4IudHi8KUSg+VQsbutDcK10UEkUU6PBYp7vSWsx9USsN5jK60Wdgw9BS3Ygbm7vev0e5v
	 1kXexMjSxJKSbrucQZ8RccdU+n5arMfaGkUibNeIo7TxcbG5d+e39RdTmfJlsd1Q52WIF
	 tP42meuW0x6UIhQHzujJiSdaTC7u27OQOIRVEvU+04AO+RmM9LoXFzg7EjS0YgO1BVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NsEn6UDXBo/I+o/mnrFhLlgYAXzsDgEZj4sHC/RbAHk=;
	b=I0HFKxi0hSG7JhwSqVtIDe8M3RYLavFPRjTPURS7prrgwopEuAKwla9Pk3IMFmOTPXmD
	 XInr08bJoeG9tWUnogxfUYB2tS1JIg4naquFRLkO3kM8GmEXSERcQaYv/2hqly6Kt734J
	 Cul0wXBavbLPvKhAxfdTMobxDTvzhd2nvuN71gU9AVSi2qly7/gF5vEVxK2JS/ajMLEkN
	 M8w0vCMgpMBVlaw/B8BHe4ODkattZb96jGVk35UJQsK79RCxbEO3egFCMj7SlI8SoOawH
	 /jPSDHUOVc59UecmIKfnY+GBc8qj5AQKtMIGVpf/z9C0Dm6KBtuhn86JnypanUW1VmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPdTYfF8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D4606A326;
	Sat,  7 Nov 2026 14:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPdTYfF8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DC91F0089F;
	Sat,  7 Nov 2026 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060697;
	bh=NsEn6UDXBo/I+o/mnrFhLlgYAXzsDgEZj4sHC/RbAHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPdTYfF8kfYpFcb7eG0y451iJNXYXU5vbyl6J9YqlxHvhPrphmeBrdHVHzf8GmiS5
	 jVZ1oHCMsCQFWWbdsr8fND1QQ4ODjd6j46G6ZjO+TgjmSXVC3ppV0VEU6ClHwwTzB8
	 w0ImXRlAHX5gHQqVLZpuvtRrTbKSeGezluJUw4sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0086/1536] mmc: cqhci: fix to missed endian conversions
Date: Sat,  7 Nov 2026 08:35:02 -0500
Message-ID: <20261107135000.086863169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 178277d90c31c..00614b500b2bc 100644
--- a/drivers/mmc/host/cqhci-core.c
+++ b/drivers/mmc/host/cqhci-core.c
@@ -484,11 +484,11 @@ void cqhci_set_tran_desc(u8 *desc, dma_addr_t addr, int len, bool end,
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
@@ -542,7 +542,7 @@ static int cqhci_prep_tran_desc(struct mmc_request *mrq,
 static void cqhci_prep_dcmd_desc(struct mmc_host *mmc,
 				   struct mmc_request *mrq)
 {
-	u64 *task_desc = NULL;
+	__le64 *task_desc = NULL;
 	u64 data = 0;
 	u8 resp_type;
 	u8 *desc;
@@ -574,7 +574,7 @@ static void cqhci_prep_dcmd_desc(struct mmc_host *mmc,
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



