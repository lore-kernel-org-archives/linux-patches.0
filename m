Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025008;
	b=NF9U9pWy3obGyb5E4ThP2dzsjmSQ6kK7vWQ+jvPgAu63qSQOL2sNH3KhpocpCN9G5KDb
	 vjchYkBm1DkiSbZ3uHyvbPBgiDO01Mcyk486LMikCUIqNJ+021ndw7t8jEG5IoCIMGNoT
	 jCsI9prwsv+4pa/6TC1ExhJJ+7brfiM1BzIfQh9y108YsvSRf/Dd6xZhdcmLbjrwcgXu8
	 uTwMaGoVe45aoC+3uFyzsMaQHsjdAcroqPdYApbpH54zpOv6M4aLv7pKkP3wzYyUxGJ94
	 EcbMCbaVRARIXbL4vbT2ShD81bLOUbDjRzEd9RRHMdGPO1Qjt+BAboSjPD1aMuEwChA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eF2XXV3eoaAN9M+IiXoNeJWFWyVkoSMxGraUM0L/UBc=;
	b=xVf3RFCh13yrR+JpDJYxQ4s4C4y1lpNkNxXjZ00AzEV5vLtRl+XDW1Q0KYDWgZ53hqif
	 FXS3+Nj9yQvwtMqx4uOBz7Bkc7Cy3c73/vthMAoD/kOFZEqfL6sFawQHYKaib48u/nk5K
	 kb4+ek5Kay0NALzMh7OAiJHLksJ+qF/W0xtej2liY7ZBEx3NKl588LrQx8SQ3uTFDpwpF
	 N7P/O9XC77bUlT80rDmXiOV6psJPYkKcHUH38k6CUTj6iSM/PlbKAiDXgih/yIIkNiOne
	 P2nFSdHbiBNu3GdsFf/zLVnbbZWGZCDeUYZ69/abRdS3QP6CCBNJtPytAVA4ANPQpJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6gdoyAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0729660A2615;
	Wed, 18 Nov 2026 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6gdoyAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3171F000C4;
	Wed, 18 Nov 2026 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025007;
	bh=eF2XXV3eoaAN9M+IiXoNeJWFWyVkoSMxGraUM0L/UBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6gdoyAjVKnsr6si2lCa7+p6AE7E/rxmX78WD0y0mVuEXN9zd/IqnCTXvCL4R5f88
	 Z7QLVv0Y8G2FjqTkqsmV1QJbHMM+j65qDEgbQ7xo2cCsHgXGgK10VXx/GpaWJcYRNx
	 JndXndAaDXdnleFRmieMAIbQC/MWLSqkQj8jPdiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0912/2151] s390/ism: Zerorize dmb at allocation
Date: Wed, 18 Nov 2026 15:44:07 +0100
Message-ID: <20261118150155.612244991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit a0227fa24e8a2a0397cc4eb669731ff8d9161bbd ]

Sashiko reported [1] that 'Missing __GFP_ZERO in folio_alloc() causes
uninitialized kernel memory to be exposed in the receive message buffer'.
An ism dmb is receive-only, so the data is not leaked to a remote peer.
In general the smc kernel module (dibs client) will only push newly
received data to userspace. We still should not have uninitialized data
in a receive buffer.

Since
commit 750afb08ca71 ("cross-tree: phase out dma_zalloc_coherent()")
dma_alloc_coherent no longer required the __GFP_ZERO flag, but when
commit 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
switched to folio_alloc(), it should have added back the __GFP_ZERO flag.

Add __GFP_ZERO flag and state in dibs.h that register_dbm() provides
a zerorized buffer (dibs_lo already does).

Link: https://lore.kernel.org/linux-s390/20260903143746.A5CC41F00A3A@smtp.kernel.org/ [1]
Fixes: 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
Link: https://patch.msgid.link/20260928151420.383105-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 3 ++-
 include/linux/dibs.h       | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index da1e0baacc067..d1307c8baa2ec 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -257,7 +257,8 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct dibs_dmb *dmb)
 		return -EINVAL;
 
 	folio = folio_alloc(GFP_KERNEL | __GFP_NOWARN | __GFP_NOMEMALLOC |
-			    __GFP_NORETRY, get_order(dmb->dmb_len));
+			    __GFP_NORETRY | __GFP_ZERO,
+			    get_order(dmb->dmb_len));
 
 	if (!folio) {
 		rc = -ENOMEM;
diff --git a/include/linux/dibs.h b/include/linux/dibs.h
index d3e0777f25ae0..0c10c224bccad 100644
--- a/include/linux/dibs.h
+++ b/include/linux/dibs.h
@@ -261,12 +261,12 @@ struct dibs_dev_ops {
 	 *	@vlan_id: deprecated, ignored if device does not support vlan
 	 * Upon return in addition the following fields will be valid:
 	 *	@dmb_tok: for usage by remote and local devices and clients
-	 *	@cpu_addr: allocated buffer
+	 *	@cpu_addr: allocated, zerorized buffer
 	 *	@idx: dmb index, unique per dibs device
 	 *	@dma_addr: to be used by device driver,if applicable
 	 *
-	 * Allocate a dmb buffer and register it with this device and for this
-	 * client.
+	 * Allocate and zerorize a dmb buffer and register it with this device
+	 * and for this client.
 	 * Return: zero on success
 	 */
 	int (*register_dmb)(struct dibs_dev *dev, struct dibs_dmb *dmb,
-- 
2.53.0



