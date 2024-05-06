Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968115B137;
	Mon,  6 May 2024 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715024712; cv=none; b=dq1+1rqjSewcCeGK0TcJkSCAUBWn17OcNzjBTZgN/toTl5QmkKM13+SfIJv22VB2uLLlTH2Wscmcae5A7dvGiGkmXM/FpDNlDzsNqfllrDGKy6ks4k8DXBrU/5wzi+VNZ4xthKt8AMgIIudmh7Hc4O5b1f/cD4XASadutLBPgD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715024712; c=relaxed/simple;
	bh=GGGvSd/bk2c1nZd3O4rhKWpcqJIj6+rSK9+yNZqL49g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MYjwrOdQnNaYIxAQDICpr2Tl+JKYk8BFwqw97nSb7yIllPtzaRxfSvtCAj/vjnby2UERgvAlv4rxiNB1kHn0FOUp2DPEycAPwssmZrHUs8oZhsgPBoIlhu2cNpYMs2uU8L4ybETmHj/AdE7y146/PHMxk5DVwOByEMoZA5ZFv5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NJbe1E0o; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NJbe1E0o"
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446JC92H031617;
	Mon, 6 May 2024 19:45:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=QKZrCAAvMc1pW3iv2yINBLnCh3cQR1y92cucD8EihEE=;
 b=NJbe1E0on7WTuMXk8pU6/1sADYOEFUPioK5XSrsjKA2sXOqkvAgWpv2SLOKamzqq2xdp
 aZkYnbt5hble1mYp3Yc7DgzuuFKULN40dz5pB+7LwoN+bPa7hqk/hv7jhHKVle5bX0BV
 z7wt0R1HnvzAfA8HsxwDem1Hvoon95Q9MRJIaCIVSJwhtCbldttQYedXWnV1JiaoSGxP
 3T99706YMYgFt7GZ9/CwDndTpuJ/FoknyOznnX+7uJXPanERCNOwz5yj1j4HlFNWmbbS
 L8G5LRLdAdqWH55HvQRKRipn0maX9O4XWuSznmxAect7wC7KKO/zDdu0UqE74yZ70nHI vA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy55d82vp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:04 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Jj3Nw024284;
	Mon, 6 May 2024 19:45:03 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy55d82vk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:03 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446J9SSE010584;
	Mon, 6 May 2024 19:45:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx0bp1vht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446Jiu5e37159258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 19:44:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E793D2005A;
	Mon,  6 May 2024 19:44:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5DA720063;
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
Subject: [PATCH 4/6] s390/smsgiucv_app: Make use of iucv_alloc_device()
Date: Mon,  6 May 2024 21:44:52 +0200
Message-Id: <20240506194454.1160315-5-hca@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240506194454.1160315-1-hca@linux.ibm.com>
References: <20240506194454.1160315-1-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7fokcWbVzRcXiejJusS2XczsjhVtdETh
X-Proofpoint-ORIG-GUID: TGjq2ZYE8zba9sUT5OumtT55M-w7nqx7
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
 definitions=2024-05-06_14,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060142

Make use of iucv_alloc_device() to get rid of quite some code. In addition
this also removes a cast to an incompatible function (clang W=1):

  drivers/s390/net/smsgiucv_app.c:176:26: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
    176 |         smsg_app_dev->release = (void (*)(struct device *)) kfree;
        |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-2-fd048c9903b0@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/net/smsgiucv_app.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/net/smsgiucv_app.c b/drivers/s390/net/smsgiucv_app.c
index 0a263999f7ae..cc44cbb0028b 100644
--- a/drivers/s390/net/smsgiucv_app.c
+++ b/drivers/s390/net/smsgiucv_app.c
@@ -156,25 +156,14 @@ static int __init smsgiucv_app_init(void)
 	if (!MACHINE_IS_VM)
 		return -ENODEV;
 
-	smsg_app_dev = kzalloc(sizeof(*smsg_app_dev), GFP_KERNEL);
+	smsgiucv_drv = driver_find(SMSGIUCV_DRV_NAME, &iucv_bus);
+	if (!smsgiucv_drv)
+		return -ENODEV;
+
+	smsg_app_dev = iucv_alloc_device(NULL, smsgiucv_drv, NULL, KMSG_COMPONENT);
 	if (!smsg_app_dev)
 		return -ENOMEM;
 
-	smsgiucv_drv = driver_find(SMSGIUCV_DRV_NAME, &iucv_bus);
-	if (!smsgiucv_drv) {
-		kfree(smsg_app_dev);
-		return -ENODEV;
-	}
-
-	rc = dev_set_name(smsg_app_dev, KMSG_COMPONENT);
-	if (rc) {
-		kfree(smsg_app_dev);
-		goto fail;
-	}
-	smsg_app_dev->bus = &iucv_bus;
-	smsg_app_dev->parent = iucv_root;
-	smsg_app_dev->release = (void (*)(struct device *)) kfree;
-	smsg_app_dev->driver = smsgiucv_drv;
 	rc = device_register(smsg_app_dev);
 	if (rc) {
 		put_device(smsg_app_dev);
-- 
2.40.1

