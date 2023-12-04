Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ECE9469
	for <patches@lists.linux.dev>; Mon,  4 Dec 2023 07:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QR/L91lg"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B46B9j8025641;
	Mon, 4 Dec 2023 07:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Uo21rvt4cQgbZvGhouib08nq7YJwxlmOuS+5+jLckCs=;
 b=QR/L91lgmwCs/dh1lnJ92sCsiIE5pvRYtHqgVrKxdXmxsJup9HikXWopfcZeB2Qvv/uK
 xdaeQGtqpqW3j+wo1diu8xMkQQ+XPkNHorSCndhj53643QVYvgxx9b4FrFqFZ2mbWJng
 EsSebV6HiLsRZeRWRUH2p/pM/G+laynbjrV87EQKT6fWeDTJqtSAonSz02Io+LflEOD4
 mZ2cOHiTXYdQKvn48yZ/m6XxIp4Q0yK/nga6mzQydIPPAVIJcvUDtjPmmdn1aFiv1Fgu
 bDmWUPjggDEkwW47OU5JOrxUNwmbiekSgrReiNbCnnhcK1/f9hOrF8by/wqp3vdAUwyw 1Q== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3urm95g9q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 07:41:18 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B474VAr022531;
	Mon, 4 Dec 2023 07:41:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3urhm1x88g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 07:41:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B47fEPa56099072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 07:41:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55B392006C;
	Mon,  4 Dec 2023 07:41:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B683F2005A;
	Mon,  4 Dec 2023 07:41:13 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.82.153])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  4 Dec 2023 07:41:13 +0000 (GMT)
Date: Mon, 4 Dec 2023 08:41:12 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, patches@lists.linux.dev, sth@linux.ibm.com,
        hoeppner@linux.ibm.com
Subject: Re: [PATCH 1/2] s390/dasd: Remove dasd_stats_generic_show()
Message-ID: <ZW2CmCzTRZjmjwxp@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
 <20231130-s390-missing-prototypes-v1-1-799d3cf07fb7@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130-s390-missing-prototypes-v1-1-799d3cf07fb7@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U6TS2uNeQJp60F_QINHGt7XdGrQBub0f
X-Proofpoint-GUID: U6TS2uNeQJp60F_QINHGt7XdGrQBub0f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_05,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxscore=0 clxscore=1011 phishscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=943 bulkscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312040056

On Thu, Nov 30, 2023 at 05:22:32PM -0700, Nathan Chancellor wrote:
> With CONFIG_DASD_PROFILE=n, there is a warning that
> dasd_stats_generic_show() is missing a prototype:
> 
>   drivers/s390/block/dasd.c:1109:5: warning: no previous prototype for 'dasd_stats_generic_show' [-Wmissing-prototypes]
>    1109 | int dasd_stats_generic_show(struct seq_file *m, void *v)
>         |     ^~~~~~~~~~~~~~~~~~~~~~~
> 
> This function has been unused since its introduction in
> commit 4fa52aa7a82f ("[S390] dasd: add enhanced DASD statistics
> interface"), remove it to clear up the warning.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Cc: sth@linux.ibm.com
> Cc: hoeppner@linux.ibm.com
> ---
>  drivers/s390/block/dasd.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
> index 833cfab7d877..7327e81352e9 100644
> --- a/drivers/s390/block/dasd.c
> +++ b/drivers/s390/block/dasd.c
> @@ -1106,12 +1106,6 @@ static void dasd_statistics_removeroot(void)
>  	return;
>  }
>  
> -int dasd_stats_generic_show(struct seq_file *m, void *v)
> -{
> -	seq_puts(m, "Statistics are not activated in this kernel\n");
> -	return 0;
> -}
> -
>  static void dasd_profile_init(struct dasd_profile *profile,
>  			      struct dentry *base_dentry)
>  {
> 

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
