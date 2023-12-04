Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAE014A82
	for <patches@lists.linux.dev>; Mon,  4 Dec 2023 09:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AvftCEU9"
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B47rpMr014014;
	Mon, 4 Dec 2023 09:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=mNJ02hnnQhLueIIj1+ZdzLr0vmJ7kT8leF2b0xtLeJo=;
 b=AvftCEU9twOsQi/02PTMsUjuw9DGy+UrkVzxre+4rJWswjb2p4501Oba0DlX0VPcM3DC
 Bmny5kQ+glLiWVqPYcbD1gPge30BBYRE3WOptQGuxN3g8OkK+auiUUW8OwSCocOToaVt
 xmuKvSvKWlz+yicilFvxGhuQIQJQdG2sDdzw6OcWxVIqs6aDSniZxiUo8BXOVVyvYsAs
 L0dhyghjKOkrGLGpgQY/SrGTbAXByUKgTBxRiByMDeKwnhE4Gha0FzijT+FCrCNCRjWw
 uZIqTntFCGIci7MksczrwKX+965cGIz4H+peeP5smM5fMcP+eaIXR5tvJ1MnEPpme3YP cg== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usasb2cn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 09:09:08 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B474WbN030397;
	Mon, 4 Dec 2023 09:06:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3urv8dky4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 09:06:48 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B496jRN44434030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 09:06:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 580BD2004F;
	Mon,  4 Dec 2023 09:06:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D7782004B;
	Mon,  4 Dec 2023 09:06:44 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.82.153])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  4 Dec 2023 09:06:44 +0000 (GMT)
Date: Mon, 4 Dec 2023 10:06:43 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] s390/traps: Only define is_valid_bugaddr() under
 CONFIG_GENERIC_BUG
Message-ID: <ZW2Wo6xlXU47HrSF@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
 <20231130-s390-missing-prototypes-v1-2-799d3cf07fb7@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130-s390-missing-prototypes-v1-2-799d3cf07fb7@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CKwM-g7Wig64VA9BpdnA2gpGcx3qsawN
X-Proofpoint-ORIG-GUID: CKwM-g7Wig64VA9BpdnA2gpGcx3qsawN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_06,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0 mlxlogscore=595
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2312040069

On Thu, Nov 30, 2023 at 05:22:33PM -0700, Nathan Chancellor wrote:

Hi Nathan,

> When building with -Wmissing-prototypes without CONFIG_GENERIC_BUG,
> there is a warning about a missing prototype for is_valid_bugaddr():
> 
>   arch/s390/kernel/traps.c:46:5: warning: no previous prototype for 'is_valid_bugaddr' [-Wmissing-prototypes]
>      46 | int is_valid_bugaddr(unsigned long addr)
>         |     ^~~~~~~~~~~~~~~~
> 
> The prototype is only declared with CONFIG_GENERIC_BUG, so only define
> the function under the same condition to clear up the warning, which
> matches other architectures.

Thanks for the fix!
The patch is fine, although I have not been able to reproduce the warning. 
How did you trigger it?

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/s390/kernel/traps.c | 2 ++
>  1 file changed, 2 insertions(+)
...

Thanks!
