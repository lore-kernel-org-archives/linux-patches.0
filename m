Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2848319ADBF
	for <patches@lists.linux.dev>; Mon, 12 May 2025 01:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747014253; cv=none; b=AIYysuK5zWqN5ruGIPd/efNRRkJjlXHySRRWeqWDGKkKUkSC5rjzQ5lVolwxAm6n1onpcg9YxQs5pZTWs6dec3gJZv9eXL9UmOf6gSUlQ+33vSzSi4JAnN+TWM7vK4MrX1RWMXOhMZ1K9YU5AKsbDEtl8lGqFCV1kcyy1tSMb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747014253; c=relaxed/simple;
	bh=0mT8DlaWI12QuYR22vdiS2VrGXGQuHagI8VyzE8UDCA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GyanLDG3r+tq3H590Y7a6PwJiyc0vlN0Iagyf1wWIyD9jSvBepBUPgXfqnhR5FWJekVP/JMwhiWYLBdCnMIcu6a5Tug6BSyXDASayuuF4loJT7IFvo4f795FGrxNp/lwYwBvGiO9VqXFFnQThGa+pRn6qZ5o0y7Ipwby0GlAf1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54C0o2xG020116;
	Sun, 11 May 2025 18:44:05 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46j6ajry0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 11 May 2025 18:44:04 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 11 May 2025 18:44:04 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Sun, 11 May 2025 18:44:01 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <paul@paul-moore.com>, <stephen.smalley.work@gmail.com>,
        <eparis@parisplace.org>, <selinux@vger.kernel.org>,
        <cgzones@googlemail.com>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>
Subject: [PATCH 6.1.y] selinux: avoid dereference of garbage after mount failure
Date: Mon, 12 May 2025 09:44:00 +0800
Message-ID: <20250512014400.3326099-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: bWqgFcOGb7hump8Huo0Qw5MjQvG-2bAP
X-Authority-Analysis: v=2.4 cv=c8irQQ9l c=1 sm=1 tr=0 ts=68215264 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=mK_AVkanAAAA:8 a=VwQbUJbxAAAA:8 a=xVhDTqbCAAAA:8 a=t7CeM3EgAAAA:8
 a=thR52bMICH2RcI1Q_pYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=3gWm3jAn84ENXaBijsEo:22 a=GrmWmAYt4dzCMttCBZOh:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDAxNiBTYWx0ZWRfX7VGszB0ay/nh fOV9Q4hpe4WVC4IJfRAJrGs7qt+grUh2bvnJRFjhqDecgW81bkF1XibOzwRbtQNPRa0RDQpoL+G ClTNQ6L1wp5ILTQyi8pbirijwRIR4R4WUvX69aOvvd3vXjX0RliSIU6l6/MzRrZxgN3aIUDZGvH
 0ilvjEGQBMc8Ypmdj/Eh+1HNw2uIOFWGo2HhabFSci0XBW2HU95GeFoJWcnswROu2YGUfGnH4gz /WB7rvMh3iKw3NrA+jN4Z4Z04Eeb9hri+rrrsyI9drgjbNXzGjfaWCAZxT+MwI4BzFPAvRuZdtf pg1KrPQnLKLcAKX8RafFm/bktPF5YNXbz2cvlk4QhGO3KhVzzqnNihkK0A9OMBhfkI8bbI0d7Pr
 7EpyhZzrhrP+0YRkfYRUkHrlnRLCIro9DcabRbsBsAhRDlZyzCc/Y9ghhfOTNHvENw2Bss48
X-Proofpoint-GUID: bWqgFcOGb7hump8Huo0Qw5MjQvG-2bAP
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-11_10,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1011 bulkscore=0 adultscore=0
 mlxlogscore=859 malwarescore=0 spamscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505120016

From: Christian Göttsche <cgzones@googlemail.com>

commit 37801a36b4d68892ce807264f784d818f8d0d39b upstream.

In case kern_mount() fails and returns an error pointer return in the
error branch instead of continuing and dereferencing the error pointer.

While on it drop the never read static variable selinuxfs_mount.

Cc: stable@vger.kernel.org
Fixes: 0619f0f5e36f ("selinux: wrap selinuxfs state")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 security/selinux/selinuxfs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ab804d4ea911..c236f3cd2dd7 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -2210,7 +2210,6 @@ static struct file_system_type sel_fs_type = {
 	.kill_sb	= sel_kill_sb,
 };
 
-static struct vfsmount *selinuxfs_mount __ro_after_init;
 struct path selinux_null __ro_after_init;
 
 static int __init init_sel_fs(void)
@@ -2232,18 +2231,21 @@ static int __init init_sel_fs(void)
 		return err;
 	}
 
-	selinux_null.mnt = selinuxfs_mount = kern_mount(&sel_fs_type);
-	if (IS_ERR(selinuxfs_mount)) {
+	selinux_null.mnt = kern_mount(&sel_fs_type);
+	if (IS_ERR(selinux_null.mnt)) {
 		pr_err("selinuxfs:  could not mount!\n");
-		err = PTR_ERR(selinuxfs_mount);
-		selinuxfs_mount = NULL;
+		err = PTR_ERR(selinux_null.mnt);
+		selinux_null.mnt = NULL;
+		return err;
 	}
+
 	selinux_null.dentry = d_hash_and_lookup(selinux_null.mnt->mnt_root,
 						&null_name);
 	if (IS_ERR(selinux_null.dentry)) {
 		pr_err("selinuxfs:  could not lookup null!\n");
 		err = PTR_ERR(selinux_null.dentry);
 		selinux_null.dentry = NULL;
+		return err;
 	}
 
 	return err;
-- 
2.34.1

