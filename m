Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC5C1DB546
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542742; cv=none; b=WtUh8ssIYn2QvqXpcCLV/eA9AmDIrT3PCXZvbL8VL0UoMvhdiMoBPWdID4OEsPBkgj1IU7el0A/gW6pOrkSttcHIILmB+AeuzuRJkwBSjiy1R32bpl0neXWYQPL6nmjWrfYDpuaf41edfH0vxNRz+BqwVBzg5rQjZBq5ZP8m7Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542742; c=relaxed/simple;
	bh=Vxx6fNUYg64ntQgm7gAVJbZi82Pj1DM/BEXxl09yrZU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=TUA0kDSty6u295P8OfdCuHMlmaMp5lnfOAde/CIrPXvi9x8IdfvNXst/yrYy2fBDe4YbdY1JA3YoE7kI00NH1z0iN1Ew+kVm0Wrd/bwvJo/A5vF67kvuL899bORV4ZYZaN1Up5RvqOOHcVl97UR4ZRHoP+HkeoidiZjW7Oq8O1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WI06Lxqu; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WI06Lxqu"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250807045859epoutp0127b1477ed04a144115bcfb21ca4f0459~ZY1Nee6KC1842118421epoutp010
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250807045859epoutp0127b1477ed04a144115bcfb21ca4f0459~ZY1Nee6KC1842118421epoutp010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542739;
	bh=7Jj0KwuRPtcL9TvobE+gsu7gadsJiiquV1dPw0ObR14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WI06Lxqu5xdM2cTL9eZVR51/Vn9V0VMEIJBrzuzkcTOOjMlIT/cs3zlR3Anm1OR7q
	 Csm//7/Dh2htTQn22n2NssE5e7MYPCqUvh1eVJPmWUD/7b84NXRjUHaAIRdWdi6t93
	 SkJeWoaoQMANvnmDeZViD3J77eDUXyd4M+YuVi6o=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250807045859epcas5p11046df633eb3ca8d3bc80588d0266e98~ZY1NCqCVU0115101151epcas5p1D;
	Thu,  7 Aug 2025 04:58:59 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4byFLT57pRz6B9m7; Thu,  7 Aug
	2025 04:58:57 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045836epcas5p10ad232a71aa5c25c4dd93085bda68617~ZY03_Zwuy0655906559epcas5p16;
	Thu,  7 Aug 2025 04:58:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045835epsmtip1a9c80f107fea1bfd87a4f476bc64e4b2~ZY03VGznM1033010330epsmtip1Y;
	Thu,  7 Aug 2025 04:58:35 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 13/15] writeback: set the num of writeback contexts to
 number of online cpus
Date: Thu,  7 Aug 2025 10:27:04 +0530
Message-Id: <20250807045706.2848-14-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045836epcas5p10ad232a71aa5c25c4dd93085bda68617
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045836epcas5p10ad232a71aa5c25c4dd93085bda68617
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045836epcas5p10ad232a71aa5c25c4dd93085bda68617@epcas5p1.samsung.com>

We create N number of writeback contexts, N = number of online cpus. The
inodes gets distributed across different writeback contexts, enabling
parallel writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0a772d984ecf..d32b13234cdd 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1046,7 +1046,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
-	bdi->nr_wb_ctx = 1;
+	bdi->nr_wb_ctx = num_online_cpus();
 	bdi->wb_ctx = kcalloc(bdi->nr_wb_ctx,
 				  sizeof(struct bdi_writeback_ctx *),
 				  GFP_KERNEL);
-- 
2.25.1

