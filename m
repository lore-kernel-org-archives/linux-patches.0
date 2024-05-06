Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E8C15B12B;
	Mon,  6 May 2024 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715024713; cv=none; b=PvN4Kl/vMvH29mFAnxV6MLxRhyC9SjyU6Q9EhwsJ8WwDlWToiauHuF3YidBkYx8yms/YEZkLtDoCw/YuCu3Y4mbKlrXS+xaYw4o7lKZAqI115tp9inwQVEtdiVtxbihVboxXacy+MTl76VyIE/bJotdXpos2fly8c30+83r26xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715024713; c=relaxed/simple;
	bh=hobxgUa9md8vhEMYysjs2d0rh4MHe2RJutk0e+kK8io=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hk5J72qlch2xAisFDDQ23DyBGaJIYmnfQ0tYbhaWCRRdFZ/zGyLbDK9m5DyGr+ZjzJ314LbIIWSOb0WjTjwp3pgbGiCcyyqaVi5Xxi2AoiKYhZMS81B1jgdyKvaZxdL40BGSSP32G5jcsGYL0UW+RasWuzHutGduzKDrA+pk2Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gr5qyrjU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gr5qyrjU"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446JbPe2030879;
	Mon, 6 May 2024 19:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2PvoPCDO8nol9n2uO9aGwkRni06cXrRjL/lIHpG13do=;
 b=Gr5qyrjUrZju2ZUW3sEd4M/ZjZ/EBeVpqTwoEUOgynbIHjGckZtr+TuZwMxe3oeqV4Cj
 LL2jNYyHjFR55MHZ8FvwfcTiORsdMITGVQYrwNe++/lUyxn3i96y+AUtdB1pEfWrB9uj
 xEdLyR9Nl2ageRbHJ8f/WCRo87S2ox/nOsiySLn7SLvSrkPPLryB0rQkQvGnqOwtWzKl
 kOq1kEFYPZ2/gK8uU2e/WfJbbys+M4bZ1AhDYj6WEAcNbjOThICkK2t5K4Z2WgVqXFK+
 bEZQmGRpbmw7SP6sPZC4CyfHvIEmuSb+BKwkD7IV7MwktQNgoXWOc6cjrNNlBmHPL7UZ yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5h5g0jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:03 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Jj2CI011624;
	Mon, 6 May 2024 19:45:02 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5h5g0jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:02 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446I8lp0030881;
	Mon, 6 May 2024 19:45:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xwybtt4mt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446JiuMH44630448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 19:44:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BCAB20063;
	Mon,  6 May 2024 19:44:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECBE820065;
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
Subject: [PATCH 5/6] tty: hvc-iucv: Make use of iucv_alloc_device()
Date: Mon,  6 May 2024 21:44:53 +0200
Message-Id: <20240506194454.1160315-6-hca@linux.ibm.com>
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
X-Proofpoint-GUID: fhGfvkRjpd2GrMBCIBWnVL5W7MqX9c8H
X-Proofpoint-ORIG-GUID: GmAuUpDS5E85UqLlW5dJPlfD_P6SJ_aC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_14,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060142

Make use of iucv_alloc_device() to get rid of quite some code.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/tty/hvc/hvc_iucv.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index b1149bc62ca1..ed4bf40278a7 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -1035,11 +1035,6 @@ static const struct attribute_group *hvc_iucv_dev_attr_groups[] = {
 	NULL,
 };
 
-static void hvc_iucv_free(struct device *data)
-{
-	kfree(data);
-}
-
 /**
  * hvc_iucv_alloc() - Allocates a new struct hvc_iucv_private instance
  * @id:			hvc_iucv_table index
@@ -1090,18 +1085,12 @@ static int __init hvc_iucv_alloc(int id, unsigned int is_console)
 	memcpy(priv->srv_name, name, 8);
 	ASCEBC(priv->srv_name, 8);
 
-	/* create and setup device */
-	priv->dev = kzalloc(sizeof(*priv->dev), GFP_KERNEL);
+	priv->dev = iucv_alloc_device(hvc_iucv_dev_attr_groups, NULL,
+				      priv, "hvc_iucv%d", id);
 	if (!priv->dev) {
 		rc = -ENOMEM;
 		goto out_error_dev;
 	}
-	dev_set_name(priv->dev, "hvc_iucv%d", id);
-	dev_set_drvdata(priv->dev, priv);
-	priv->dev->bus = &iucv_bus;
-	priv->dev->parent = iucv_root;
-	priv->dev->groups = hvc_iucv_dev_attr_groups;
-	priv->dev->release = hvc_iucv_free;
 	rc = device_register(priv->dev);
 	if (rc) {
 		put_device(priv->dev);
-- 
2.40.1

