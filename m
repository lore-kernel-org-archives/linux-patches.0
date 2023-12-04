Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3913124A10
	for <patches@lists.linux.dev>; Mon,  4 Dec 2023 13:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hRy05HzK"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4Bl5VQ004986;
	Mon, 4 Dec 2023 13:13:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bkK+1G8G1SkS4X3O0r0db1EZcdVbk5kpw41WA2zglRE=;
 b=hRy05HzK7gfqgRX7vjZp2KBkClNYkxIiVL+8+MIT7pJ0ZZZjIyBqgiLaLg9qENEHfHUB
 aTCGCPIajQhUctCuRJfBbG8lot/iP/nYaA2YEZZ0XVi71GxsRO1yPZ2S3wzCkRWpaumq
 RhEpjHqcpE6OGqSyYn+u9mJcnMvcNq4AfS3DoyXnh1roic9EE4N8aMpjYCtvIv205/jl
 b6ZW/W+hIQ9SsC707YXp/TNbw0Q3chQT/rw/95dajCbai1QV4NR8FvafSJeDEpfr6IMS
 9JdRKI2IANtI2JkMJ+Lx2Sjg5ueqwZbu/Pgl1jBd+EFnMG0z5IbYAB/5331RYw5rMkBI wQ== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3use6wu3ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 13:13:20 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4AmsbP005011;
	Mon, 4 Dec 2023 13:13:19 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3urhm1ypjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 13:13:19 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B4DDHGQ11207224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 13:13:18 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D104658061;
	Mon,  4 Dec 2023 13:13:17 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B97658058;
	Mon,  4 Dec 2023 13:13:16 +0000 (GMT)
Received: from [9.171.12.252] (unknown [9.171.12.252])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 Dec 2023 13:13:16 +0000 (GMT)
Message-ID: <5e21338a-b55a-4b3d-900f-55c4397baca9@linux.ibm.com>
Date: Mon, 4 Dec 2023 14:13:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] s390/dasd: Remove dasd_stats_generic_show()
To: Nathan Chancellor <nathan@kernel.org>, akpm@linux-foundation.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org,
        patches@lists.linux.dev, hoeppner@linux.ibm.com
References: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
 <20231130-s390-missing-prototypes-v1-1-799d3cf07fb7@kernel.org>
Content-Language: en-US
From: Stefan Haberland <sth@linux.ibm.com>
In-Reply-To: <20231130-s390-missing-prototypes-v1-1-799d3cf07fb7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YkDb6Duhobvfmga-Sa67QPeyANbLTzRE
X-Proofpoint-ORIG-GUID: YkDb6Duhobvfmga-Sa67QPeyANbLTzRE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_11,2023-12-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1011 bulkscore=0 impostorscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=903 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312040099

Am 01.12.23 um 01:22 schrieb Nathan Chancellor:
> With CONFIG_DASD_PROFILE=n, there is a warning that
> dasd_stats_generic_show() is missing a prototype:
>
>    drivers/s390/block/dasd.c:1109:5: warning: no previous prototype for 'dasd_stats_generic_show' [-Wmissing-prototypes]
>     1109 | int dasd_stats_generic_show(struct seq_file *m, void *v)
>          |     ^~~~~~~~~~~~~~~~~~~~~~~
>
> This function has been unused since its introduction in
> commit 4fa52aa7a82f ("[S390] dasd: add enhanced DASD statistics
> interface"), remove it to clear up the warning.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Acked-by: Stefan Haberland<sth@linux.ibm.com>


