Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0CF266595
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499276; cv=none; b=bkXQ1oaPOmsJQ5lnNKCrQHe6JdCIGphRoAwrHJqX6CBCtOBnrHt4oTOts2Ma9DJxGnjTYgdUIy2kCZ7aTFs/p11UAOZ7jgJDAjf37/FqADs18wfASKo8AE8DfYLgYeAcUboMM6UqR08RdcuMauWRxqIgm9I/S1D1R/+76NZVxvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499276; c=relaxed/simple;
	bh=Gnd69lNeRUtk4clONE44pOcmcvb7Vwoia8p2hK3Zj+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=G6fJmVFS+nJmX0gUcLpKopc1gsJI2sSEEY/KhIKveqR1LfKj/asBewQu9kMvr5Qw46dsbBCyXER3pfc/UPGtbd64ESrIG0Hf80StYLLj2WdTSVhFUIHPaBqC4NasvFb78ry5Y2t1/kKbz891P39SuWzRsCVUl4ZW12YOFzx1OfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PC/efVIh; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PC/efVIh"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250910101433epoutp0385c514e63ad4416e4be670798480fac4~j5EcNwYNH0945309453epoutp03c
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250910101433epoutp0385c514e63ad4416e4be670798480fac4~j5EcNwYNH0945309453epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499273;
	bh=pL1B/I4XgjW+M52+7hYRno9EJFOu30nJkNjpC3EOg3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC/efVIh1okEBHlBDBTiYxvn7HKIg3jTVqJo93Ub7ZXaCR68C7T/PIj+EAzmoQGDd
	 tP/1P0wfUMLf9Lc/hdPGYXv6JzNjwwguRxDq4B2KQdZIiB2TIZlrH9afriqjjsulfh
	 LYTTKeWgmm8JVoTRb6zsEA3DoqTvOGHmcck0nYWA=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250910101432epcas5p2213550fc1e1c10a6a7368dde4613c4fd~j5EbIDccF2618326183epcas5p2y;
	Wed, 10 Sep 2025 10:14:32 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cMGkv2YGnz6B9m9; Wed, 10 Sep
	2025 10:14:31 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250910101430epcas5p38cc97d42f46bdef1d944e29f7105ac31~j5EZ7q4sN0809008090epcas5p3B;
	Wed, 10 Sep 2025 10:14:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101430epsmtip171f7b00f8296506dc90ba6e86e70ceef~j5EZdaH8U2347023470epsmtip1a;
	Wed, 10 Sep 2025 10:14:30 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH v2 16/16] writeback: make default number of writeback
 threads equal to num cpus
Date: Wed, 10 Sep 2025 15:43:04 +0530
Message-Id: <20250910101304.2588-17-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101430epcas5p38cc97d42f46bdef1d944e29f7105ac31
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101430epcas5p38cc97d42f46bdef1d944e29f7105ac31
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101430epcas5p38cc97d42f46bdef1d944e29f7105ac31@epcas5p3.samsung.com>

This will help test fstests with more number of writeback threads.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
---
 mm/backing-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d746ed0b870b..15404fe29ab6 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1185,7 +1185,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	 * introduced sysfs knob.
 	 * echo N > /sys/class/bdi/<maj>:<min>/nwritebacks
 	 */
-	bdi->nr_wb_ctx = 1;
+	bdi->nr_wb_ctx = num_online_cpus();
 
 	bdi->wb_ctx = wb_ctx_alloc(bdi, bdi->nr_wb_ctx);
 	if (!bdi->wb_ctx)
-- 
2.25.1

