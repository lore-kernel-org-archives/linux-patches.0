Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E715613AD26;
	Tue, 13 May 2025 01:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747101157; cv=none; b=rGOzV85YXnjjcJxHAVCDAtohspp6hYGS3xk1s22M+iW3j7rRbJQzcxavB/cvjynBxz4qYVdMUFJ++/LciN+ZspJwprJTKbJ5Sofwv4rhELdUnZALdSaUlklJUxSvIK1qR6K3odYuQVGm08B+gDnAKl1pZ1UkDS29a/BQA124/4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747101157; c=relaxed/simple;
	bh=M595WY/9RVqODvqTZylWt2B6BMgRbFBdcAnXmJIlofk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mBQKJMtwUAFpnbAD5KpjC+UAuPQGVkxroFrhmMyeYqZVmCzQLIyxrsNrBD+oYYWe6KityU9kNIG6eoyBuGLj2LBR/Hrh1RY0nGLTvAMduOIcrEMWo6o6flRM6+i4xifcxwWgllSHa7IldMY+kt/IOUIFcbg5OIZWwThKuzYtl2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D196Q8028546;
	Tue, 13 May 2025 01:52:21 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46hv11jg9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 13 May 2025 01:52:21 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Mon, 12 May 2025 18:52:19 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Mon, 12 May 2025 18:52:15 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <harry.wentland@amd.com>,
        <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <alexander.deucher@amd.com>, <christian.koenig@amd.com>,
        <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
        <Jerry.Zuo@amd.com>, <wayne.lin@amd.com>,
        <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <zaeem.mohamed@amd.com>, <daniel.wheeler@amd.com>
Subject: [PATCH 6.1.y] drm/amd/display: Don't refer to dc_sink in is_dsc_need_re_compute
Date: Tue, 13 May 2025 09:52:14 +0800
Message-ID: <20250513015214.3360461-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=TZCWtQQh c=1 sm=1 tr=0 ts=6822a5d5 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=dt9VzEwgFbYA:10 a=zd2uoN0lAAAA:8 a=t7CeM3EgAAAA:8 a=r8Kla15me-PCpvyDwbMA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: IfsBuhMvJYAouEqq-Dl30CUPGKGNyJ_c
X-Proofpoint-ORIG-GUID: IfsBuhMvJYAouEqq-Dl30CUPGKGNyJ_c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxNSBTYWx0ZWRfX7nmkn/8mDoje Fu6onx5XJN1H5fJMKinqsKlP5HAFLE1QQasBeElUiF/SbMgJGKkB9hZOr/ew42pm0nDLMWgUI4W V/EsSWVwW61Z51laT7w7InyLPRX3xme8ONHquNW6HgbftrO+Cpq7p8OB4vFkT3Gs7ihGYGYfgvD
 ay3+E9SJ1uYKkZAdyQ9wuT7BypwFVkFzrnoyDV+7sBaruPdXAb+PrclKMYMIxbuNmE//HVlRXrG P7+iIe/m5uiYzbPoViTrBjuNd8z/mLkzk26QhcRtEccGCgdM3HPV/PbZUPTl71Ym6WTE8J6XXn6 gL5BhoBsSGlinnrKV4oA/jiFla8R74Q1RpuTdxU71KEZ074FQXflRKan9K2PFUgzRipgTttlKl2
 +tTBEH55Fo4Ca25TQrfddwm4HOBvBbS4uqe8WzGubnhpN3Z5CVEJV3hQNmQvy/kFRNJqOpE4
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505130015

From: Wayne Lin <wayne.lin@amd.com>

[ Upstream commit fcf6a49d79923a234844b8efe830a61f3f0584e4 ]

[Why]
When unplug one of monitors connected after mst hub, encounter null pointer dereference.

It's due to dc_sink get released immediately in early_unregister() or detect_ctx(). When
commit new state which directly referring to info stored in dc_sink will cause null pointer
dereference.

[how]
Remove redundant checking condition. Relevant condition should already be covered by checking
if dsc_aux is null or not. Also reset dsc_aux to NULL when the connector is disconnected.

Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[The deleted codes in this fix is introduced by commit b9b5a82c5321
("drm/amd/display: Fix DSC-re-computing") after 6.11.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 5eb994ed5471..6bb590bc7c19 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -183,6 +183,8 @@ amdgpu_dm_mst_connector_early_unregister(struct drm_connector *connector)
 		dc_sink_release(dc_sink);
 		aconnector->dc_sink = NULL;
 		aconnector->edid = NULL;
+		aconnector->dsc_aux = NULL;
+		port->passthrough_aux = NULL;
 	}
 
 	aconnector->mst_status = MST_STATUS_DEFAULT;
@@ -487,6 +489,8 @@ dm_dp_mst_detect(struct drm_connector *connector,
 		dc_sink_release(aconnector->dc_sink);
 		aconnector->dc_sink = NULL;
 		aconnector->edid = NULL;
+		aconnector->dsc_aux = NULL;
+		port->passthrough_aux = NULL;
 
 		amdgpu_dm_set_mst_status(&aconnector->mst_status,
 			MST_REMOTE_EDID | MST_ALLOCATE_NEW_PAYLOAD | MST_CLEAR_ALLOCATED_PAYLOAD,
-- 
2.34.1

