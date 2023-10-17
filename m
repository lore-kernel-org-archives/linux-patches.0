Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9A115CC;
	Tue, 17 Oct 2023 01:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ccZ8tDzU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKOApQ013037;
	Tue, 17 Oct 2023 01:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=Xs+QD230V90/UG6DoR1nbW1dfXhgdVRcogMOWpKkp+E=;
 b=ccZ8tDzU22fJjPK4Tj33ctkm3A+wyHBe7iX0r0h1zIxaNZ9zcSPiMpajeUrI78L7XhbK
 s5ox8sf0HGAuYLOEai3Dks60Jlqvu4S35Q9W//bQZfTls2v/DHmRssWSD8gYk38ODwxu
 ryXkUn/sGkNGacveZavUOfDEx8mD43d3gj7D8GJdQlSkolEQfX0t5/Qo9pHzTIdnVJhm
 1XDUmlpXjJjXvS8dZQ/GVL8pwqTSWApqGbV68DQlyB3mtAKOvSAOB86IwYiVuAyzDQNZ
 Znb3wolZob4aLTfGKNmH7uTX7P7g9muT301yltCWzMhjiMuTgaQ0waNLNb1TPJKXBTvY sA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jm253-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Oct 2023 01:12:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GN0GAp027087;
	Tue, 17 Oct 2023 01:12:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5366rm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Oct 2023 01:12:11 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39H1C3su039761;
	Tue, 17 Oct 2023 01:12:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg5366mf-8;
	Tue, 17 Oct 2023 01:12:10 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: tyreld@linux.ibm.com, Nathan Chancellor <nathan@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jejb@linux.ibm.com,
        ndesaulniers@google.com, trix@redhat.com, brking@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] scsi: ibmvfc: Use 'unsigned int' for single-bit bitfields in 'struct ibmvfc_host'
Date: Mon, 16 Oct 2023 21:11:55 -0400
Message-Id: <169750286917.2183937.1857222190314885925.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231010-ibmvfc-fix-bitfields-type-v1-1-37e95b5a60e5@kernel.org>
References: <20231010-ibmvfc-fix-bitfields-type-v1-1-37e95b5a60e5@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=858 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-GUID: NfheMxzNAJGvnXMTzl5tZqtIkAH1iC5e
X-Proofpoint-ORIG-GUID: NfheMxzNAJGvnXMTzl5tZqtIkAH1iC5e

On Tue, 10 Oct 2023 13:32:37 -0700, Nathan Chancellor wrote:

> Clang warns (or errors with CONFIG_WERROR=y) several times along the
> lines of:
> 
>   drivers/scsi/ibmvscsi/ibmvfc.c:650:17: warning: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Wsingle-bit-bitfield-constant-conversion]
>     650 |                 vhost->reinit = 1;
>         |                               ^ ~
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/1] scsi: ibmvfc: Use 'unsigned int' for single-bit bitfields in 'struct ibmvfc_host'
      https://git.kernel.org/mkp/scsi/c/78882c7657bb

-- 
Martin K. Petersen	Oracle Linux Engineering
