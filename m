Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9178215B140;
	Mon,  6 May 2024 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715024712; cv=none; b=uK9klFPVfsB2+ePEmwwrh1FLuRAd8rdjAH3QNgo0NciYYQTpSNzSyAbcoVeBcvGlHvcumpeaID0ve+hRhYNAutBxCDUWCyZHTFxpu/auiLl3VSOYBLOH9gSpdG6L1QLt3yEvVXBjVKCjZn3lE8kIiF+fIeK9wmL/N+E0MJoAkS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715024712; c=relaxed/simple;
	bh=kUwVALdxu99SEPBl/ePsq2cQ7vLy7Q2eLMzidY2/w34=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Er1PMAwanGHEdvKlpvzEObXjMda4ptEAbWsuZdxP+CtBVkpj3xahWARn42pU4fnzHkx06q9obEarUp0GR3VDDjq0KGdwm+LQ/7WxCbw50fjXd1Bi3v5LydmHuHBNE3lW7O8WylsrcmhNGiDZ8s0vQj2wVoQd5bYDAnYezavrJmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I3UFXPEx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I3UFXPEx"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446JcOOF029249;
	Mon, 6 May 2024 19:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=aH/CEYtXdCPSJ9Q/mQVEl+JZf6khZ14VjjTJYXXXKvs=;
 b=I3UFXPEx9VOr4BT6/fHk5e056GNCv23l9gqJCeS1asPm+732DivC4/6Y3NAYaMZgvm06
 lNULR8+MZCYp3Bk7vmrujoSsb0wnLhczdYpT4MCY/txf51fnKcdWvCp4uA9Wrj+bLc9T
 6CIMnfslMwZKyKndr1Ehaqm3EWRi0lVeZU4U26T+JDO58wBaVFNK3hmjMMIDiTZ7FCOa
 nuU3KL072PIC1CDOjugdWMjKw7MZNq5H3rOPhsmp68MXJ8t0f0JYh/tf72a6dz/P9b3y
 7s2t00bgsm5gWp7o9CcA9kDdueJRA+T16OarpwnMEEUYR/OBa0z/4pgnI/9+4o0tiNgM Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5hpr0d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:02 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Jj28U006197;
	Mon, 6 May 2024 19:45:02 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5hpr0d1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:02 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446IeNob010569;
	Mon, 6 May 2024 19:45:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx0bp1vhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446Jit8K53150186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 19:44:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0DF42004B;
	Mon,  6 May 2024 19:44:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DE3C2005A;
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
Subject: [PATCH 3/6] s390/netiucv: Make use of iucv_alloc_device()
Date: Mon,  6 May 2024 21:44:51 +0200
Message-Id: <20240506194454.1160315-4-hca@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240506194454.1160315-1-hca@linux.ibm.com>
References: <20240506194454.1160315-1-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kQtvJvvNIoCKbNOIsoI4TtTTEEepSEJy
X-Proofpoint-ORIG-GUID: Rjx8IQLUet9Fqag0Ej5DQWBKoJtB0Ge8
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060141

Make use of iucv_alloc_device() to get rid of quite some code. In addition
this also removes a cast to an incompatible function (clang W=1):

  drivers/s390/net/netiucv.c:1716:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
   1716 |                 dev->release = (void (*)(struct device *))kfree;
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-3-fd048c9903b0@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/net/netiucv.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 8852b03f943b..039e18d46f76 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1696,26 +1696,14 @@ static const struct attribute_group *netiucv_attr_groups[] = {
 static int netiucv_register_device(struct net_device *ndev)
 {
 	struct netiucv_priv *priv = netdev_priv(ndev);
-	struct device *dev = kzalloc(sizeof(struct device), GFP_KERNEL);
+	struct device *dev;
 	int ret;
 
 	IUCV_DBF_TEXT(trace, 3, __func__);
 
-	if (dev) {
-		dev_set_name(dev, "net%s", ndev->name);
-		dev->bus = &iucv_bus;
-		dev->parent = iucv_root;
-		dev->groups = netiucv_attr_groups;
-		/*
-		 * The release function could be called after the
-		 * module has been unloaded. It's _only_ task is to
-		 * free the struct. Therefore, we specify kfree()
-		 * directly here. (Probably a little bit obfuscating
-		 * but legitime ...).
-		 */
-		dev->release = (void (*)(struct device *))kfree;
-		dev->driver = &netiucv_driver;
-	} else
+	dev = iucv_alloc_device(netiucv_attr_groups, &netiucv_driver, NULL,
+				"net%s", ndev->name);
+	if (!dev)
 		return -ENOMEM;
 
 	ret = device_register(dev);
-- 
2.40.1

