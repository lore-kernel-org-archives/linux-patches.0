Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617FDD2FB;
	Tue,  8 Apr 2025 00:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744072644; cv=none; b=L8cFtAEa+Lv58/vADN4MODqauPOEajF/fk/JwOU7JOvcigqkwV4ASpIasbKGrdJKHTFOGhOriNf984V7aVmwCXrqw15b4UyM4m+A7xhYnoOLg1+KXVHs0m9Mf3viNymWJLPHX2fwZ+uJvynoX8Z7kqCwF0VJK/+z/q9lQOFD2Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744072644; c=relaxed/simple;
	bh=gEfjmLVnt9ZhdW9OXMofU8oOyt//Y5GH8VwebzD4VvU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YW6nKmQ3201OQDDjcwLShE+iwVTfIK1D//KvTcJZtWgsHcnEtxRXEbb1JXDCav56t89QJqyWFCUbgwKRTbthXgpx35ZavJ5i9bdJkb/XJ2Tphm1+ANPsuQjr2WS2lIt+Jgfh1eCf3OhCIjU0Py3uWhu0Svm/97TjKGGK5S0w0ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 537N94AX020202;
	Tue, 8 Apr 2025 00:36:54 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45tsr1k58r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 08 Apr 2025 00:36:53 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Mon, 7 Apr 2025 17:36:52 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Mon, 7 Apr 2025 17:36:48 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>,
        <harry.wentland@amd.com>, <sunpeng.li@amd.com>,
        <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>,
        <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>,
        <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <chiahsuan.chung@amd.com>,
        <alex.hung@amd.com>, <daniel.wheeler@amd.com>
Subject: [PATCH 6.6.y] drm/amd/display: Check link_index before accessing dc->links[]
Date: Tue, 8 Apr 2025 08:36:47 +0800
Message-ID: <20250408003647.3361342-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=Td6WtQQh c=1 sm=1 tr=0 ts=67f46fa5 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=XR8D0OoHHMoA:10 a=zd2uoN0lAAAA:8 a=t7CeM3EgAAAA:8 a=BwQGkkmVnK98ez6iplQA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: 5r75n8bMt50BzTocoZiDlGTAC4DERPC4
X-Proofpoint-GUID: 5r75n8bMt50BzTocoZiDlGTAC4DERPC4
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_07,2025-04-07_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504080002

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 8aa2864044b9d13e95fe224f32e808afbf79ecdf ]

[WHY & HOW]
dc->links[] has max size of MAX_LINKS and NULL is return when trying to
access with out-of-bound index.

This fixes 3 OVERRUN and 1 RESOURCE_LEAK issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[The macro MAX_LINKS is introduced by Commit 60df5628144b ("drm/amd/display:
 handle invalid connector indices") after 6.10. So here we still use the
 original array length MAX_PIPES * 2]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c
index f365773d5714..e9b3c1c7a931 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c
@@ -37,6 +37,9 @@
 #include "dce/dce_i2c.h"
 struct dc_link *dc_get_link_at_index(struct dc *dc, uint32_t link_index)
 {
+	if (link_index >= (MAX_PIPES * 2))
+		return NULL;
+
 	return dc->links[link_index];
 }
 
-- 
2.34.1

