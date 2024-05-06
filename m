Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B18615B11F;
	Mon,  6 May 2024 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715024710; cv=none; b=Tz7tqDVW6szs0BnVg91qtqmoSUjSr73ERIcMSsa9HOGvYzfbXl0cyoI/e5jv+sp7mW597pErwxfD92Y2Y2Iq2CFK0OLIkn50MbEi1u5Hq3Kcx5dvTII5MLiF23pXXBJWX804SS0Cqkm2ks5qTtYFC4wGIfBo0gLtYY+H8l+SKR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715024710; c=relaxed/simple;
	bh=To7nYm2BMcnJH1PM2TepQnUOGwO5zfd2E4co20N0EZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kbxTrRB4xqsxoOSraTNiVp7Js8fChMY3Y4Fv2k/LpX03y/j1oE2zNtmKzj1X3Mp4IhKfvhsxwcipJT9zVCUjU7PZ5e4Ei3+CWaXuwSFgdudyVMW3W3tWyAtN2Adxx9+m0Xfy37M27MTvlqDAqrUpcxTDV17qp4pwX1t7PUMW2X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cx14Tv82; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cx14Tv82"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446JVkA1015673;
	Mon, 6 May 2024 19:45:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=LXAHwdl927IN4K80jPkXY3UGJ+fhJ0QN817ePcUB7pk=;
 b=cx14Tv82XA9evZpaOLkj0tyj96BJ/btliV41HEe85RxYXlfu0wG8eL2w2CSGLJ2pBphU
 MnZ6jny2hnXOsD00PYZCBy5mKqdWzx0waIGOFIHpB+LURhb0avPyLWA8LrtEUooDoNPH
 mBN9zypq58BEvRPjwLRDyCAN6Qhle4fzSHqsR8tZSA3GbA3DaPNffJqj+9JEWT8wrcHs
 SG1M9IIbiHrxhpqLM+Ha26mdrAdzjTrCt5d1pLPOlvTM3zbs+zAuCPEorBGL3WZdXvcu
 rWBf5nhOc46lkg/dwBYZh2swpp+DWWzAkEiFSRWzEJEqxd3E/iYjFP9lvOlGGFAooRyu Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy55n0266-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:02 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Jj1iP003874;
	Mon, 6 May 2024 19:45:01 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy55n0261-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:01 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446HPW8m013942;
	Mon, 6 May 2024 19:45:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xx222sf8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446Jitev57344260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 19:44:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78F442004F;
	Mon,  6 May 2024 19:44:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 474232004B;
	Mon,  6 May 2024 19:44:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 19:44:55 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Huth <thuth@redhat.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, netdev@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 2/6] s390/vmlogrdr: Make use of iucv_alloc_device()
Date: Mon,  6 May 2024 21:44:50 +0200
Message-Id: <20240506194454.1160315-3-hca@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240506194454.1160315-1-hca@linux.ibm.com>
References: <20240506194454.1160315-1-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iN8eGfXipHWlKpcPp9Hiuqp-TqxyRNK8
X-Proofpoint-GUID: LPeq1AJB9u4MlSaAAhRSZiqV2_FrgAXT
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_13,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060141

Make use of iucv_alloc_device() to get rid of quite some code. In addition
this also removes a cast to an incompatible function (clang W=1):

  drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
    746 |                 dev->release = (void (*)(struct device *))kfree;
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/char/vmlogrdr.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index d7e408c8d0b8..c09e1e09fb66 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -728,23 +728,9 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 	struct device *dev;
 	int ret;
 
-	dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (dev) {
-		dev_set_name(dev, "%s", priv->internal_name);
-		dev->bus = &iucv_bus;
-		dev->parent = iucv_root;
-		dev->driver = &vmlogrdr_driver;
-		dev->groups = vmlogrdr_attr_groups;
-		dev_set_drvdata(dev, priv);
-		/*
-		 * The release function could be called after the
-		 * module has been unloaded. It's _only_ task is to
-		 * free the struct. Therefore, we specify kfree()
-		 * directly here. (Probably a little bit obfuscating
-		 * but legitime ...).
-		 */
-		dev->release = (void (*)(struct device *))kfree;
-	} else
+	dev = iucv_alloc_device(vmlogrdr_attr_groups, &vmlogrdr_driver,
+				priv, priv->internal_name);
+	if (!dev)
 		return -ENOMEM;
 	ret = device_register(dev);
 	if (ret) {
-- 
2.40.1

