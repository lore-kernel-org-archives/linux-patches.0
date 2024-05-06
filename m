Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6A615B120;
	Mon,  6 May 2024 19:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715024710; cv=none; b=molphzsnhYqJwhYc7FglYBm6q7w+Gi2S3YUZc8geNgCougMLjnwrk/Wte4RDIC6kVqDEAj4/VJ9d/9XA+sXIOxTJSC0gIkdHhI2JjZ7i5KZwsmSCLH3vqNZUYjM5mVLOaJrINzY+R3Clb4Rd1HVZ+RWFlqYJ8TTMLJUsQFpq970=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715024710; c=relaxed/simple;
	bh=DahALltv0KmFqfhfOUZlpShX7gIUfmZ1n7F4k5Tdv7I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V+fv1lkF1yKX4RZYXg026BNhVEOtvUXeB3rNN12zVa4f3mrhijHUBNytsbzraJJns/DjJmxvM3ovXCEhNVmjYA6ZLXPsUAZi/Iq6vQghum7F+fHrnoE+nXrIBK1KDGhI73jJBKm0wn0La+ghc/Cx9dkPS9ZUpB+fN0XerMYUloU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qCfnqLjI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qCfnqLjI"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446JgeKs005517;
	Mon, 6 May 2024 19:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=7wJXPFd+prjmPydgt6FRx2BxCiMdiW2rEgeYnMYTAzM=;
 b=qCfnqLjI9s5WX3lQ0avK+d24jvGwSEkSAUEAkITfR/NDenathW4rVCjlUez3h4uoJw3t
 e1+ohIqxHIrYfNLtWGb3nGPMAmt0YEUCrewah+O2fG/Mwq4Om9CFG/TVCZB/b6HKV28v
 BUktsGNyFzQs3++vVv93rGLHjiWxBbl8+BJ7pHkR603r0OjqjrnDpVQ348M+SDAP06t8
 1Yz5bbBFiuPkd2EToelc1Lt7YLnptAZ5+h4lhBEhDmAj5on8jXWoCs4hcGPLNK/NoUaw
 licNYhmYdFE8LBZnhm6grfYXwrAK3KbqHP71WGxcpLjkByI4AvNPQg6BQLjdLlNRTIVX 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5kmr04b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:02 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 446Jj2MO009139;
	Mon, 6 May 2024 19:45:02 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy5kmr048-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:02 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446HjgZv005538;
	Mon, 6 May 2024 19:45:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xx5yh0g86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:45:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446Jitkt55116200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 19:44:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A9B320043;
	Mon,  6 May 2024 19:44:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C048F2004B;
	Mon,  6 May 2024 19:44:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 May 2024 19:44:54 +0000 (GMT)
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
Subject: [PATCH 0/6] s390: Unify IUCV device allocation
Date: Mon,  6 May 2024 21:44:48 +0200
Message-Id: <20240506194454.1160315-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z3CFz-wgjO_CqVvpgCSXb86pj_KiX890
X-Proofpoint-GUID: 5FzAB4xZRxGYcsjQDnLCQZpPXB8_V3U2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_14,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=655 priorityscore=1501 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060142

Unify IUCV device allocation as suggested by Arnd Bergmann in order
to get rid of code duplication in various device drivers.

This also removes various warnings caused by
-Wcast-function-type-strict as reported by Nathan Lynch.

Unless there are objections I think this whole series should go via
the s390 tree.

Heiko Carstens (6):
  s390/iucv: Provide iucv_alloc_device() / iucv_release_device()
  s390/vmlogrdr: Make use of iucv_alloc_device()
  s390/netiucv: Make use of iucv_alloc_device()
  s390/smsgiucv_app: Make use of iucv_alloc_device()
  tty: hvc-iucv: Make use of iucv_alloc_device()
  s390/iucv: Unexport iucv_root

 drivers/s390/char/vmlogrdr.c    | 20 +++--------------
 drivers/s390/net/netiucv.c      | 20 ++++-------------
 drivers/s390/net/smsgiucv_app.c | 21 +++++-------------
 drivers/tty/hvc/hvc_iucv.c      | 15 ++-----------
 include/net/iucv/iucv.h         |  7 +++++-
 net/iucv/iucv.c                 | 38 +++++++++++++++++++++++++++++++--
 6 files changed, 56 insertions(+), 65 deletions(-)

-- 
2.40.1

