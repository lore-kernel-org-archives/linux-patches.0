Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0D721105
	for <patches@lists.linux.dev>; Mon, 30 Sep 2024 07:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727681423; cv=none; b=TWLws7p8sRAmLtb8kZK9LXtBXq9r8eVG7l66IuycFyEShsVJ2DWjArYO69bqWXx9tFfkVCUmyTgJrzcUJY+kRPE49+2HgWK4/6VbAVCog4WXOiAUl7oUsJGhfZUqPbc8LcNsACqY6Q3fqR8PdFpW3TCROXgFX2/BHlBCy6ySt9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727681423; c=relaxed/simple;
	bh=rP+Su456oKoi+eSL4Q3S2uxRd9c2eaCCMFzD0JPjceM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lMmS1S7JiL9qDOqA0tMYWzVgxlR1gJKxLzLNHM97c2hFF9oc0p/IGsW/9RzI9iAjClVdVpT6csoQQNFvZrmKr0wqWZFBDRBvJ6PQzOHKnpDtjBt2Mi+kFaHaR70e15Ny3tYZHkxMaPv04aUxSiTXAAij4DVZlnGc5kdJtBcI2X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-swift.com; spf=pass smtp.mailfrom=net-swift.com; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-swift.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=net-swift.com
X-QQ-mid: bizesmtp83t1727681380thiorh3y
X-QQ-Originating-IP: HgM72dOxP7VcC+Y5VmNGWMUpT8C6Zbzd9icOBootQzw=
Received: from 173-12-12-1-panjde.hfc.comcastb ( [122.233.174.97])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 30 Sep 2024 15:29:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7099544262465932789
From: Duanqiang Wen <duanqiangwen@net-swift.com>
To: stable@vger.kernel.org,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	davem@davemloft.net,
	ashal@kernel.org
Cc: Duanqiang Wen <duanqiangwen@net-swift.com>
Subject: [PATCH net] Revert "net: libwx: fix alloc msix vectors failed"
Date: Mon, 30 Sep 2024 15:33:27 +0800
Message-Id: <20240930073327.130343-1-duanqiangwen@net-swift.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: M3vv73qU6a4uPinrzsQrLoKMariUq6/miO3ocekKBO8BM4aOTsxoRjX6
	NWn0hsiNKPE/rM2UBHw+DyeMEVhQhMCeOTuk6yxAXEqMR3cSDtmZQR2N4f+l/0NfFsNv+xX
	xrmT9xbu+Kllh9wZDCEZg7NPjpkrWhoq5+hNr86lSZ8gtQ3kSeeOxwPeyfCSBaRo5MKcY14
	dVaU2CSwM+gx4fSeLRMXKb9bOAL1ImLNiUcgpEaE2BRiTMkK2+aL87cR8pzU4c8Tj5E+/pG
	n+cpd2GPsHTmO0z380TXaiqo0WPZi04I5wXXK1TZGkDHzQUh1ot5/icqhiV3JgSKA9S3PGk
	B0pXz0wiFN0ecDy6shJ4yJ/pRqQZLUto8wstTiqjp5yLTvw8q5IBE9oW8U/dgCS97GnaUEW
	ADwhI9TWVjLA71ynXuQUadQD44r3Q8oDkVpclh3ATIeVR2prijS8sZA+TXmoKELYC/9HEc3
	bIrqL5AjzE56NLhgklA83UaaxD4i/Q++QtFbw1Dq/O8cSg2o9vIdMlNWsN1j51kQaJe1rmJ
	NzRoHjCOyXlnUTDAI1sJ+NxYuqvGehLSPtGf35Wn0RBWHbVua1PBxWoAVxci/tApcT9uRKq
	Ekn695IBus95pnhC1sAwt4nKsm8l8y6l46k1DThVXEZ3QKz+fS+u55d25cZ+aiuzBIowzR/
	LMMxr9FvlXAFDVk2K3wKQl3OB6rwMQDCfa3Xmk4Wq1N2LkpaSmR5QHCfepCaJY8XTYze8pR
	M5rq7jsp8iePPGMv+p7a/4dMjjCkIIfqd5tbiVUNXupygizwb08q9kMApc7b8ZnoPzRaUXL
	FuCRQrgSZYBXQr7U5VYTOe361XpbMJ4/jIUFJhl3GRlmFZSXiVEcsaH8ZZ6x3r5sQz97/Ju
	cHBEmWP1OPhyCTJbkGhn2Yg5X91KFXfeY66HHrnMBptxACO3kk1kOJ6z3rzz4sqr9KUY0bE
	iIIk=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

This reverts commit 69197dfc64007b5292cc960581548f41ccd44828.
commit 937d46ecc5f9 ("net: wangxun: add ethtool_ops for
channel number") changed NIC misc irq from most significant
bit to least significant bit, the former condition is not
required to apply this patch, because we only need to set
irq affinity for NIC queue irq vectors.
this patch is required after commit 937d46ecc5f9 ("net: wangxun:
add ethtool_ops for channel number") was applied, so this is only
relevant to 6.6.y branch.

Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 2b3d6586f44a..fb1caa40da6b 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1620,7 +1620,7 @@ static void wx_set_num_queues(struct wx *wx)
  */
 static int wx_acquire_msix_vectors(struct wx *wx)
 {
-	struct irq_affinity affd = { .pre_vectors = 1 };
+	struct irq_affinity affd = {0, };
 	int nvecs, i;
 
 	/* We start by asking for one vector per queue pair */
-- 
2.27.0

