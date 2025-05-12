Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61C12AD25;
	Mon, 12 May 2025 01:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013549; cv=none; b=OGkHBDQUib2fKYiB4MPlCTQi+zk9BQE24QSsu6K4T/hITrCf3pnZkVqB1rAuZQ8w8pY/jDy+px88hADBk7sMDkjyUw4V0G4EoNBGGMru5Rn5I2sW3Kg8vS+ECFE41ZlNjHwqUK0G47wWAEhQrZMAR8/0yHt2466TRabCRv2fSNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013549; c=relaxed/simple;
	bh=KXwudXl2GRjgfq7+csGSIVLBWY8DUYsn0tFUMeG9X4k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aC46Oy7PUZF+Ex7CVsaxlsaeGUK7AOSnvgSMidZuD8y59LYKiNEqggLzaH0gHwzQxQMFhBkJhRBd1OSi4jfPiDTh/67umzRRIzlflkbxOW+0AXPGE2fwHwyvVNVqglrF2cf+geT/6RjfuCOmlHkOebo8ty2Mt42vRAgL2NKBNsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54C1GleS026999;
	Sun, 11 May 2025 18:32:17 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46j6ajrxrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 11 May 2025 18:32:17 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 11 May 2025 18:32:16 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Sun, 11 May 2025 18:32:14 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <heikki.krogerus@linux.intel.com>, <rdbabiera@google.com>,
        <linux-usb@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>
Subject: [PATCH 5.15.y] usb: typec: altmodes/displayport: create sysfs nodes as driver's default device attribute group
Date: Mon, 12 May 2025 09:32:13 +0800
Message-ID: <20250512013213.3325252-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PsgdgElPXi8RQ7wbK0dL9BWZnc5O5Vjw
X-Authority-Analysis: v=2.4 cv=c8irQQ9l c=1 sm=1 tr=0 ts=68214fa1 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=ag1SF4gXAAAA:8 a=t7CeM3EgAAAA:8 a=8qJ9y54MyL8qpMpceN8A:9
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDAxNCBTYWx0ZWRfX0SZqMBTzImvy zQYY+bH9H+Vl06Ijk3SCgdUuV5u6caUwWUJ2sY5jmc2dK+Lvg7He99ME1YtVqieex/cFJVtN88c 4t60y2xjbB5YYBkO7orjTnzcjh744wZmjcO1LsL8r3qRIeHgDEB4uxPAhQaFSK9jom5js0HECDP
 wyQW9Q6V8EPzu3Y6wfzAUcZY6Ylc70w+hSeWkZkgY1ZSxJXLC9n+PmtwkkEINZlacxhkYrGECOc rS8SKFsfRtcWlGaG+1uK1YYgV+YqM4AChmuF9fV1x4KNsHA1+lb9Sn9qUsy0DDpJzRtJHBm8ASy oWRzOXB+gDnicpXuMrdEJrCSuzHkqXilzgeSuWqZOZs3iszN2Xy+ovCOIDsSYNCOOH0ehG7UqrA
 8y6Jsbu+snRWlYFmusv/yYcZrUz8nxZHg4FWDrHB0CXvNvZ2yCiCF3DLvn7vAFMX2MJF8zVF
X-Proofpoint-GUID: PsgdgElPXi8RQ7wbK0dL9BWZnc5O5Vjw
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-11_10,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 bulkscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505120014

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
index 8f0c6da27dd1..97a912f0c4ee 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -521,22 +521,26 @@ static ssize_t pin_assignment_show(struct device *dev,
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
 {
 	const struct typec_altmode *port = typec_altmode_get_partner(alt);
 	struct dp_altmode *dp;
-	int ret;
 
 	/* FIXME: Port can only be DFP_U. */
 
@@ -547,10 +551,6 @@ int dp_altmode_probe(struct typec_altmode *alt)
 	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
 		return -ENODEV;
 
-	ret = sysfs_create_group(&alt->dev.kobj, &dp_altmode_group);
-	if (ret)
-		return ret;
-
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp)
 		return -ENOMEM;
@@ -576,7 +576,6 @@ void dp_altmode_remove(struct typec_altmode *alt)
 {
 	struct dp_altmode *dp = typec_altmode_get_drvdata(alt);
 
-	sysfs_remove_group(&alt->dev.kobj, &dp_altmode_group);
 	cancel_work_sync(&dp->work);
 }
 EXPORT_SYMBOL_GPL(dp_altmode_remove);
@@ -594,6 +593,7 @@ static struct typec_altmode_driver dp_altmode_driver = {
 	.driver = {
 		.name = "typec_displayport",
 		.owner = THIS_MODULE,
+		.dev_groups = displayport_groups,
 	},
 };
 module_typec_altmode_driver(dp_altmode_driver);
-- 
2.34.1

