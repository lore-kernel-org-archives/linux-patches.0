Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EFB15B12E;
	Mon,  6 May 2024 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715024712; cv=none; b=kFAjx+U+Zf0BNFNBKGtuc4D8kUq42GDuGP2mSjc5wToIOp4zjQlus/UdJsBtlV3exAD+3UmJkgC0kuG7iWROI733BIcDMjHPpOqZaQl+mNDS9TvJg93c0Xz4cV0nb1/IxhDWsjQD0/nkp6+2y1Tb10td+h1+GFiG3EN1GVHZ78w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715024712; c=relaxed/simple;
	bh=IPEkwIxoEulrJ72TUcnrk2IFwrdAChz+rfxSTwedrfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nF5XEbx1tMLw5rDe8iipNVfH2zSgjKnqVLMNxk4Dj1Ibc9+ZyQzj2UMCM2k5wCEqYfiL7Fa6i4ez+4HE1hSYrPEh83rv//ZFCsvm2UCn91xS3RS8U4jZwOgunu81PSRGbUjV2MFH5+glfEuSDepCQECoCEdla916dEhzhhACkpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m8vOlx5e; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m8vOlx5e"
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446JgUp4019316;
	Mon, 6 May 2024 19:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ss4WavEiatm1ir88BkwsnzQ07rzsa9F6DU8Ne8r2NDw=;
 b=m8vOlx5etgKVTxL0HvFNlx9/5mo7EfXu/NbfSNwZPBYMAffef9887EV/hqxFzAuoe6zQ
 VEb81paUtpekpIHppbvdAXmYxDpBIu81n72qvx9HWQsgr456y9BjfKdUUqETD4aoxQ2K
 WEcnPvvnm6R/+iWkXfEZsx8R6tlKCCZhonOzN801qxnuC+fmd6PWqWe480SrM4tcXNwF
 U+TX0yxuQMWCUAs3Gv+35PVrgh7mNmoOz3uHoyI2ehvbW3gQW7wNd1UYwxyY9Wofa2/j
 UKH9+CCFDDWtxnEO0RauYDbPJscbF41Pa8vZf2rOUIb2opB3fdB9lmF7HWSxiWFLILil OA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5kg805e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:03 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Jj2Pk023400;
	Mon, 6 May 2024 19:45:02 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5kg805a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:02 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446J9SSD010584;
	Mon, 6 May 2024 19:45:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx0bp1vhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446JitEe57475558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 19:44:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4281A20040;
	Mon,  6 May 2024 19:44:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F48C2004E;
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
Subject: [PATCH 1/6] s390/iucv: Provide iucv_alloc_device() / iucv_release_device()
Date: Mon,  6 May 2024 21:44:49 +0200
Message-Id: <20240506194454.1160315-2-hca@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240506194454.1160315-1-hca@linux.ibm.com>
References: <20240506194454.1160315-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NI5UqJqy5yI21YRFMWhlVVdMDHGq3wxT
X-Proofpoint-GUID: 3I0mMeMmdoUrsRpXqKpTJR846LFxVYfN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_14,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=716 impostorscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405060142

Provide iucv_alloc_device() and iucv_release_device() helper functions,
which can be used to deduplicate more or less identical IUCV device
allocation and release code in four different drivers.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 include/net/iucv/iucv.h |  6 ++++++
 net/iucv/iucv.c         | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/net/iucv/iucv.h b/include/net/iucv/iucv.h
index 5cd7871127c9..b3736e66fe1a 100644
--- a/include/net/iucv/iucv.h
+++ b/include/net/iucv/iucv.h
@@ -84,6 +84,12 @@ struct iucv_array {
 extern const struct bus_type iucv_bus;
 extern struct device *iucv_root;
 
+struct device_driver;
+
+struct device *iucv_alloc_device(const struct attribute_group **attrs,
+				 struct device_driver *driver, void *priv,
+				 const char *fmt, ...) __printf(4, 5);
+
 /*
  * struct iucv_path
  * pathid: 16 bit path identification
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index a4ab615ca3e3..9db7c2c0ae72 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -76,6 +76,41 @@ EXPORT_SYMBOL(iucv_bus);
 struct device *iucv_root;
 EXPORT_SYMBOL(iucv_root);
 
+static void iucv_release_device(struct device *device)
+{
+	kfree(device);
+}
+
+struct device *iucv_alloc_device(const struct attribute_group **attrs,
+				 struct device_driver *driver,
+				 void *priv, const char *fmt, ...)
+{
+	struct device *dev;
+	va_list vargs;
+	int rc;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		goto out_error;
+	va_start(vargs, fmt);
+	rc = dev_set_name(dev, fmt, vargs);
+	va_end(vargs);
+	if (rc)
+		goto out_error;
+	dev->bus = &iucv_bus;
+	dev->parent = iucv_root;
+	dev->driver = driver;
+	dev->groups = attrs;
+	dev->release = iucv_release_device;
+	dev_set_drvdata(dev, priv);
+	return dev;
+
+out_error:
+	kfree(dev);
+	return NULL;
+}
+EXPORT_SYMBOL(iucv_alloc_device);
+
 static int iucv_available;
 
 /* General IUCV interrupt structure */
-- 
2.40.1

