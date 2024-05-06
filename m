Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBCA15B122;
	Mon,  6 May 2024 19:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715024711; cv=none; b=PtsP3LwwVn/ewlZz7WwSqMmXVDCmCFWY6qB+CoJVDTquHxIH+JXRGb0nn8el3ua/oZ2odnXNoi7gTSsFyYCIHqMyKbOB8TL2mOEjFG4tk1NFWbvCPXqRFCZFLKu76AsUuBSmx7BeEH8yyxzW7SoZv3jALyYbh5xY+M+r4elYK2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715024711; c=relaxed/simple;
	bh=8we1prCctjwdaXUgYnpclnX4bIKNr83K4LXA485iABY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uG3W1KA8WncP5pzl7VELhNYeGmIN80x0b7o+lqm6mmzHyKl1XTEUvnK3TdmIVpGOJav6Tz6/6wLuYlZ6XXjsyE8N6tQ6+VJZfhM8f0TcdURyDmqdNr2EIFN3LnuMdP3r5scTzHkqemyoRlze5/B3nc2AtVG03LzD9KjQqfPunas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DJA/6M38; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DJA/6M38"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446JhE7S006590;
	Mon, 6 May 2024 19:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w7f3GppcRf21WKGCq9yibtFRa/ZnOdFa39UXqIdtoKU=;
 b=DJA/6M38lZK7qDeQbT5Ssi9788+WxIx8tcDT8UrtMM154PyIfqw+sZlP0VLriPWRNR+R
 WTXRCiQMQKl2g+ZS7Jan/kIt1kiIalLeDTUWcMB7r9fDcor4FwZwuN0Bs6UYwwtli+7T
 S85zHYCy98aHhqWBPUeMaGqo6ar6KDaHaPhLWjElbRvbsFT8qirzve5N3pf8hOVU8tfS
 +TGAgSMgkh47nG4AQLWrk7rdpKUXgVck6otGUC4q+kzj4rRJ2LqPr9nwRhAe+ERjT+AK
 nfIWLabQsVM5zGS+D8sRf6H0G8gT6B8V0dv0F4GcCLoEzpDQRW2yuVmw7R27awRwQVWE iw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5kmr04e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:03 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Jj2Cl009149;
	Mon, 6 May 2024 19:45:02 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5kmr049-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:02 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446H3Nd6022444;
	Mon, 6 May 2024 19:45:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xx1jksj5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446Jiu7Z45547828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 19:44:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DC212004E;
	Mon,  6 May 2024 19:44:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30FD120067;
	Mon,  6 May 2024 19:44:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 19:44:56 +0000 (GMT)
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
Subject: [PATCH 6/6] s390/iucv: Unexport iucv_root
Date: Mon,  6 May 2024 21:44:54 +0200
Message-Id: <20240506194454.1160315-7-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 3f9n6fcI-d5kukff0yptGiX05QuXh7iW
X-Proofpoint-GUID: ieBCS--FXtdlM5wZF388GejDYApfwOg0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_14,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060142

There is no user of iucv_root outside of the core IUCV code left.
Therefore remove the EXPORT_SYMBOL.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 include/net/iucv/iucv.h | 1 -
 net/iucv/iucv.c         | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/iucv/iucv.h b/include/net/iucv/iucv.h
index b3736e66fe1a..4d114e6d6d23 100644
--- a/include/net/iucv/iucv.h
+++ b/include/net/iucv/iucv.h
@@ -82,7 +82,6 @@ struct iucv_array {
 } __attribute__ ((aligned (8)));
 
 extern const struct bus_type iucv_bus;
-extern struct device *iucv_root;
 
 struct device_driver;
 
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 9db7c2c0ae72..2e61f19621ee 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -73,8 +73,7 @@ const struct bus_type iucv_bus = {
 };
 EXPORT_SYMBOL(iucv_bus);
 
-struct device *iucv_root;
-EXPORT_SYMBOL(iucv_root);
+static struct device *iucv_root;
 
 static void iucv_release_device(struct device *device)
 {
-- 
2.40.1

