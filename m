Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FC514F9E2
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 00:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743122310; cv=none; b=LunOmLPLvUm6oPJ4dspzMPnYcz147vBUxSLSuUuhVPJZqVOln1fVaPmLevSPgQJvkBStlr/DGJf8iTGvsXmyfN30MQOfNJoi8bIglYrzxuagtCx3BLOY0T63murHAePvWX+uuVvFlnuObYsC5i5BTsbp5rRi3/sdPHPjyBvtlr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743122310; c=relaxed/simple;
	bh=D+7ReCJLn6d03f6xTdJS0+RJKNpRezru3XPiEXsYjJU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OC57KTR9hJ9PqcLWtkWdLxHXF+G1gVdqOkuAQWGs+8cDrCfmIU5oWkyFWVRAMLEVVDaPUlmTRV3htr09PcJzmAU6zkjfjx1VNgw1jYNDnNWzzS2ctqlEpyPACuai3/00JVkrrPAN4x9LwMsC+VyMGRQuknAvhKnaygYQ9Bc0wws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52S0030p020373;
	Fri, 28 Mar 2025 00:38:23 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45hm68pmcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 28 Mar 2025 00:38:22 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Thu, 27 Mar 2025 17:38:21 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Thu, 27 Mar 2025 17:38:18 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>,
        <changhuang.liang@starfivetech.com>, <kernel@esmil.dk>,
        <hal.feng@starfivetech.com>, <p.zabel@pengutronix.de>,
        <conor.dooley@microchip.com>
Subject: [PATCH 6.6.y] reset: starfive: jh71x0: Fix accessing the empty member on JH7110 SoC
Date: Fri, 28 Mar 2025 08:38:18 +0800
Message-ID: <20250328003818.1525870-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: bNReoe5PplN0fEFNLHCP06ZmD2_bmp0g
X-Authority-Analysis: v=2.4 cv=etjfzppX c=1 sm=1 tr=0 ts=67e5ef7e cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=Vs1iUdzkB0EA:10 a=VwQbUJbxAAAA:8 a=Bq6zwJu1AAAA:8 a=t7CeM3EgAAAA:8 a=ywNUzwTxH0ZiiNjt-R4A:9 a=KQ6X2bKhxX7Fj2iT9C4S:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: bNReoe5PplN0fEFNLHCP06ZmD2_bmp0g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-27_05,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2503280002

From: Changhuang Liang <changhuang.liang@starfivetech.com>

[ Upstream commit 2cf59663660799ce16f4dfbed97cdceac7a7fa11 ]

data->asserted will be NULL on JH7110 SoC since commit 82327b127d41
("reset: starfive: Add StarFive JH7110 reset driver") was added. Add
the judgment condition to avoid errors when calling reset_control_status
on JH7110 SoC.

Fixes: 82327b127d41 ("reset: starfive: Add StarFive JH7110 reset driver")
Signed-off-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Acked-by: Hal Feng <hal.feng@starfivetech.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20240925112442.1732416-1-changhuang.liang@starfivetech.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 drivers/reset/starfive/reset-starfive-jh71x0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/reset/starfive/reset-starfive-jh71x0.c b/drivers/reset/starfive/reset-starfive-jh71x0.c
index 55bbbd2de52c..29ce3486752f 100644
--- a/drivers/reset/starfive/reset-starfive-jh71x0.c
+++ b/drivers/reset/starfive/reset-starfive-jh71x0.c
@@ -94,6 +94,9 @@ static int jh71x0_reset_status(struct reset_controller_dev *rcdev,
 	void __iomem *reg_status = data->status + offset * sizeof(u32);
 	u32 value = readl(reg_status);
 
+	if (!data->asserted)
+		return !(value & mask);
+
 	return !((value ^ data->asserted[offset]) & mask);
 }
 
-- 
2.25.1

