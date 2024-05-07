Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303C4152184;
	Tue,  7 May 2024 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074805; cv=none; b=PFwqy3p+LjTUTaClx1lvnDUnEXiPr253vnEtwgiGjyxP86p7Ro2I6QCMCwqDoFOwsCXOwdM0vO/tmX4dFIb3mv/gd/kVGbtrIoadbq8ZpLX9nzcUcunHlevJTmdtHfAueP50WGmwKTyWaXPeaTKvsdYojzq8oHOvuoWwX4eIqtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074805; c=relaxed/simple;
	bh=mHpsgJQH6Dc+37KdBggEY0UJx/gW/+EgPVSh+avscfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U4Uw+Me+SLy/06+lP+3BiJ4Y0WMV+LmMPXK9QaVStNdFbVJNGbQ7/yuHZ5QaSGNWkYiofyXsZiecFqzVIzVOnz19jbOuFxUBsYarYsZ36u4ZHYGBYqa3xgl1qNCYGqVb2GhCERI8rhbJpy6agAqvz8uMbm+4Yqnyma5MY/dnmu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GYUef3ec; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GYUef3ec"
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4477xtwI024295;
	Tue, 7 May 2024 09:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1Hzs6jb+7+nNcGtUV/vlynnIqoPy7wF8kRwARHODZMM=;
 b=GYUef3ecBpfOVAkrajoj7aHiFo4M2kvxNVG5lXWjtQ7cZaVrCHwNLkkDkH6Ah+puVQo9
 X8z8euViOvxiysiz0ov9dwbyGT5TA7Myw97CbB/i8AbIZGZZG/LRwayIWiuRtMrLhBC0
 lfKGIK09LjHJ+AXAPuaHqBdon6CqIk7CSijzWkLE4RSsXCjGvSjG43YsIAZtJHWMV4MK
 ZA37p8VohR7eLZ6Z1V7tD1odoBe7dFCa0EKkIv5cjfUjy3Md1e3kb4o1ogetVejuKrQt
 2BRkbfitqskgAmE0Kw2WjhRytCz284mrbrT1+XrEpore7c6rIb7NPoN9o5NWhxYv/iPy mA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyg2y8a5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 09:39:55 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4479dt5D017163;
	Tue, 7 May 2024 09:39:55 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyg2y8a5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 09:39:55 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4476vGC9022515;
	Tue, 7 May 2024 09:39:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xx1jkw11a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 09:39:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4479dnsB25559694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 09:39:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 042D22004F;
	Tue,  7 May 2024 09:39:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94FE22004B;
	Tue,  7 May 2024 09:39:48 +0000 (GMT)
Received: from [9.152.224.141] (unknown [9.152.224.141])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 09:39:48 +0000 (GMT)
Message-ID: <a478920a-eda3-4667-ab82-383c64db15bf@linux.ibm.com>
Date: Tue, 7 May 2024 11:39:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] s390: Unify IUCV device allocation
Content-Language: en-US
To: Heiko Carstens <hca@linux.ibm.com>, Nathan Chancellor
 <nathan@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Huth <thuth@redhat.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Slaby
 <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>, netdev@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20240506194454.1160315-1-hca@linux.ibm.com>
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20240506194454.1160315-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wAeOck7hNshZ8btYkrbKOKmEFvJMeU2O
X-Proofpoint-ORIG-GUID: PWwwpVme6PbjKWpr5QK3PjGUV4L3bJRh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_04,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=714 priorityscore=1501 clxscore=1011 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070064



On 06.05.24 21:44, Heiko Carstens wrote:
> Unify IUCV device allocation as suggested by Arnd Bergmann in order
> to get rid of code duplication in various device drivers.
> 
> This also removes various warnings caused by
> -Wcast-function-type-strict as reported by Nathan Lynch.
> 
> Unless there are objections I think this whole series should go via
> the s390 tree.
> 
> Heiko Carstens (6):
>   s390/iucv: Provide iucv_alloc_device() / iucv_release_device()
>   s390/vmlogrdr: Make use of iucv_alloc_device()
>   s390/netiucv: Make use of iucv_alloc_device()
>   s390/smsgiucv_app: Make use of iucv_alloc_device()
>   tty: hvc-iucv: Make use of iucv_alloc_device()
>   s390/iucv: Unexport iucv_root
> 
>  drivers/s390/char/vmlogrdr.c    | 20 +++--------------
>  drivers/s390/net/netiucv.c      | 20 ++++-------------
>  drivers/s390/net/smsgiucv_app.c | 21 +++++-------------
>  drivers/tty/hvc/hvc_iucv.c      | 15 ++-----------
>  include/net/iucv/iucv.h         |  7 +++++-
>  net/iucv/iucv.c                 | 38 +++++++++++++++++++++++++++++++--
>  6 files changed, 56 insertions(+), 65 deletions(-)
> 

Thank you, Heiko.
For the series:
Acked-by: Alexandra Winter <wintera@linux.ibm.com>
