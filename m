Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D171E491B;
	Mon, 12 May 2025 01:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013815; cv=none; b=Th0BzpEx9RRLhWRfs387V2KE/G7K+xnRNXv5vv0GCKet6BZ0+Ggw7rVKNBlFmu9trfRZ2TTJnb51Q7vj1pcN3VCsZKZdrjB7QvtlU0q72vJANRo9KGnSEEo2OwKHcGkPQRLSRCtuojNM5/l5m8kk/Lkf8kmmg7sMX66uY1xL7SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013815; c=relaxed/simple;
	bh=bZaWDtX3IJ8t+7cxlKqMond9bVF1AvoncEJ/JHF/1Uk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mPUGwLklWlbjXznA5/ikLiAkL3JHI5MpxlSQx60Cffz3Hf71VTp72sj6OrBNmw8MCjyHm6Yvu/YPN4OdKQ4DxUp65jS5+XRlN5rT6dYD2bzZ4yrLIreNhA2tW69I4xDbLstktSM2QLnV1VB27NMgGkecc+x8Z1wV+13S6Eb5BwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54C0uJk1032016;
	Sun, 11 May 2025 18:36:48 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46j233h3bj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 11 May 2025 18:36:48 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 11 May 2025 18:36:47 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Sun, 11 May 2025 18:36:45 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <heikki.krogerus@linux.intel.com>, <rdbabiera@google.com>,
        <linux-usb@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>
Subject: [PATCH 5.10.y] usb: typec: altmodes/displayport: create sysfs nodes as driver's default device attribute group
Date: Mon, 12 May 2025 09:36:44 +0800
Message-ID: <20250512013644.3325607-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=EojSrTcA c=1 sm=1 tr=0 ts=682150b0 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=ag1SF4gXAAAA:8 a=t7CeM3EgAAAA:8 a=8qJ9y54MyL8qpMpceN8A:9
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDAxNSBTYWx0ZWRfX+xfmVuJXfHWS 4Y0FTc3uQZt99G6PwA8EYc5HfagEqLzARWVh0DXZEKUT+SliumJVXkyZU9tFfSeXV75GCBgAfm8 g5jcq1PdSN7iRan7DtdTi9SUwTTPowhSjsyiCHLl0UurGvUCAYBUsO2sZbghlv28V9Jw/I6lgVG
 CMesMx8nY3Q9OINyE9JSkEO0EEmVvffcblhyVmLxYr5+H83U9qrYWBKzy31ibqrQxL7L1rRVVyC suPrtRP+9hCOm4UZ+GO123IEL7X5bB2ZRdPE2uA6Pi7fJbTWuU2KCdEPkkK4/y9ge7dU/auu9bf cXxnfo0HR5wnKx746SR1jtxkU6O9JSXKplgHxkOqvj/MTpJyWXDIwjQ+dqWfmM0Jgop9PIkekt/
 mFrls91eHKIqoulsgDGWuY/XQ6vjwwm0QutQw9Eop29igfT/HHc9ZzPScL3gAEXoKpUv8eUu
X-Proofpoint-GUID: Xwz4hDXIczuyOA3ZR1CWJoBSTKMdB7W6
X-Proofpoint-ORIG-GUID: Xwz4hDXIczuyOA3ZR1CWJoBSTKMdB7W6
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-11_10,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505120015

From: RD Babiera <rdbabiera@google.com>

commit 165376f6b23e9a779850e750fb2eb06622e5a531 upstream.

The DisplayPort driver's sysfs nodes may be present to the userspace before
typec_altmode_set_drvdata() completes in dp_altmode_probe. This means that
a sysfs read can trigger a NULL pointer error by deferencing dp->hpd in
hpd_show or dp->lock in pin_assignment_show, as dev_get_drvdata() returns
NULL in those cases.

Remove manual sysfs node creation in favor of adding attribute group as
default for devices bound to the driver. The ATTRIBUTE_GROUPS() macro is
not used here otherwise the path to the sysfs nodes is no longer compliant
with the ABI.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Link: https://lore.kernel.org/r/20240229001101.3889432-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 drivers/usb/typec/altmodes/displayport.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index def903e9d2ab..e0456e5e10b6 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -527,15 +527,20 @@ static ssize_t pin_assignment_show(struct device *dev,
 }
 static DEVICE_ATTR_RW(pin_assignment);
 
-static struct attribute *dp_altmode_attrs[] = {
+static struct attribute *displayport_attrs[] = {
 	&dev_attr_configuration.attr,
 	&dev_attr_pin_assignment.attr,
 	NULL
 };
 
-static const struct attribute_group dp_altmode_group = {
+static const struct attribute_group displayport_group = {
 	.name = "displayport",
-	.attrs = dp_altmode_attrs,
+	.attrs = displayport_attrs,
+};
+
+static const struct attribute_group *displayport_groups[] = {
+	&displayport_group,
+	NULL,
 };
 
 int dp_altmode_probe(struct typec_altmode *alt)
@@ -543,7 +548,6 @@ int dp_altmode_probe(struct typec_altmode *alt)
 	const struct typec_altmode *port = typec_altmode_get_partner(alt);
 	struct fwnode_handle *fwnode;
 	struct dp_altmode *dp;
-	int ret;
 
 	/* FIXME: Port can only be DFP_U. */
 
@@ -554,10 +558,6 @@ int dp_altmode_probe(struct typec_altmode *alt)
 	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
 		return -ENODEV;
 
-	ret = sysfs_create_group(&alt->dev.kobj, &dp_altmode_group);
-	if (ret)
-		return ret;
-
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp)
 		return -ENOMEM;
@@ -588,7 +588,6 @@ void dp_altmode_remove(struct typec_altmode *alt)
 {
 	struct dp_altmode *dp = typec_altmode_get_drvdata(alt);
 
-	sysfs_remove_group(&alt->dev.kobj, &dp_altmode_group);
 	cancel_work_sync(&dp->work);
 
 	if (dp->connector_fwnode) {
@@ -613,6 +612,7 @@ static struct typec_altmode_driver dp_altmode_driver = {
 	.driver = {
 		.name = "typec_displayport",
 		.owner = THIS_MODULE,
+		.dev_groups = displayport_groups,
 	},
 };
 module_typec_altmode_driver(dp_altmode_driver);
-- 
2.34.1

