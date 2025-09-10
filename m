Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B95266595
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499274; cv=none; b=CcvWG0JlmuWlkiBqX1cc6NqbjYbR/WFTfAfYp2HbzQJPB2oK/oXVsf9JYE/6QyLMj3+Ulj11pzgySjjjTAC703xNF01eePgchZb8chKVlGIh/+QvfwgdLhNWmtaBgrsg0kjTZafuT+tvCdFRfRgYAFckNZTzBHjfNwHpe8E3bG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499274; c=relaxed/simple;
	bh=ju732V0W7RB9wSp2Z6hVrpyfcPSSt9+OXC72cp6/lMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=MIt1oCoeE2QkaGxvPTon+7vZp/kq2Piv+2Ii38IHROwI1/ST6wEKfE/tRoo1Y8pqoizrG5h/T4Hr07DfyOh1cb+PJj7cRekf0B16DyvvS+uDuuZHPC9xcrGrZQ1AH3XiX1NRWgpWbV2OwO8ljmidHnUlZziF/MR1R7THUpYV2eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GVjqfyqx; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GVjqfyqx"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250910101430epoutp01e528d01ea407b6567542d32c0ce7821c~j5EZLBMOn1477714777epoutp01L
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250910101430epoutp01e528d01ea407b6567542d32c0ce7821c~j5EZLBMOn1477714777epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499270;
	bh=r/7O7MeZ/8vgIxSS6HVNB++vSc8HYrbFUGd1SxVa7eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVjqfyqxFbLOjqnRylzD2YMRWsH3gKeEQqDPnZ4H7gdsy9CuuPKw1q5E9uVrS5FVT
	 iDsghrjQ7bN4s7BjGTIqGAsdceg+KgEgZ+WK/JjCj012hULq2+HxNCpYxY/bfJxLvy
	 gfK6Q5PUcjBg+/iQS/v9UTrf12CgNkwUw/v6JGJs=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250910101429epcas5p46212a067ba20b7529498c4c78d9e2906~j5EYuB2CC2170621706epcas5p4-;
	Wed, 10 Sep 2025 10:14:29 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cMGkr5S7Gz6B9mD; Wed, 10 Sep
	2025 10:14:28 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250910101428epcas5p2f99a8b3b4f325d43e34cbd5c63efe33b~j5EXZurt-2617926179epcas5p2w;
	Wed, 10 Sep 2025 10:14:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101427epsmtip171e9371ac50dc392e887deafac406a58~j5EWZPT0z2482124821epsmtip1e;
	Wed, 10 Sep 2025 10:14:27 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 13/16] writeback: configure the num of writeback contexts
 between 0 and number of online cpus
Date: Wed, 10 Sep 2025 15:43:01 +0530
Message-Id: <20250910101304.2588-14-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101428epcas5p2f99a8b3b4f325d43e34cbd5c63efe33b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101428epcas5p2f99a8b3b4f325d43e34cbd5c63efe33b
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101428epcas5p2f99a8b3b4f325d43e34cbd5c63efe33b@epcas5p2.samsung.com>

The number of writeback contexts can be configured, with a valid range
between 0 and the number of online CPUs. Inodes are then distributed
across these contexts, enabling parallel writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0a772d984ecf..bee8da1f872b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1046,6 +1046,12 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
+
+	/*
+	 * User or filesystem can configure nr_wb_ctx using the newly
+	 * introduced sysfs knob.
+	 * echo N > /sys/class/bdi/<maj>:<min>/nwritebacks
+	 */
 	bdi->nr_wb_ctx = 1;
 	bdi->wb_ctx = kcalloc(bdi->nr_wb_ctx,
 				  sizeof(struct bdi_writeback_ctx *),
-- 
2.25.1

