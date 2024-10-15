Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6A57F7FC
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 09:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728986062; cv=none; b=UZWS6QyecH8+7uxFLdD3ZezvAfc3QjrUAM3UtxGmjEa+y+VbZIldF/fyY0DqBs5G8DuLIC79zP3bP7QZN+H57Xpy+ESoaOH4HBaRMtDyJzc2BRM8QeHQRsQa9jcQJr62fFdoY596mRuw60aRwBPf5ZLOm0ckbpFhNybBTVRw/Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728986062; c=relaxed/simple;
	bh=5zCk3Qy6Y5TLnYoUotW/C2u0baK4JuQiR6Bvckd63Mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6TD79qhgpo0MSUvgoM8reI4o7gXj41jxIjbIZdCfBIZhfp7p/9SAquQPPsL6lwKWRciXntLPU6A4Msnq1s9N3FGvmequYnqZxtzuTLrCJ+83I3rv535f38E/B+ypR7EeELLsSJgUs+GiV55UD8s3j0rOhaiY2/ZCOPiTSuYLAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=avFcb2wa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="avFcb2wa"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F8np92013359;
	Tue, 15 Oct 2024 09:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=yvcSEBzEWVNB2Ni84vQ67UK/7Pa3Dk
	SZ4DoAZjmRbo4=; b=avFcb2waQeDHh9zFWB0QhV3w2B5nu+nls41wHFzcr9zUq5
	sJh87O/mMqiezYV23PisJ1poXYs6MeQOxs0SOoWeM+2/KO+fn3BSs98U6NFVaVfZ
	G3pteDgQV+J4EpGAMXGVt079dzoI42bUs4AGbForS6mlwFt1ZpUJRQe89Ann1sbx
	NWL4+E81twm6eiOU68P+wN6xIboJLGaMMOXrEyS8H3U1wVcR0GnN4nhGrFsk/+z9
	Dhqql37p8wfuiW4uY/Nxs+Q+H39Stx62DnSCZa0axl79eOAAPZJnmOgxs34DgQ/Q
	3HwHNdP4t0qWAvHaZuSqzAiUlCBSqp326zdu9Etg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429n7tr8p5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:54:13 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F9sDrN017567;
	Tue, 15 Oct 2024 09:54:13 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429n7tr8nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:54:12 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F94lrv005906;
	Tue, 15 Oct 2024 09:50:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428650tqta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:50:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F9oGmR48627986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 09:50:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE5AD20043;
	Tue, 15 Oct 2024 09:50:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4472320040;
	Tue, 15 Oct 2024 09:50:15 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 09:50:15 +0000 (GMT)
Date: Tue, 15 Oct 2024 11:50:13 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, linux-s390@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
Message-ID: <20241015095013.7641-H-hca@linux.ibm.com>
References: <20241014141217.941104064@linuxfoundation.org>
 <CA+G9fYuaZVQL_h1BYX4LajoMgUzZxJUH5ipdyO_4k36F62Z5DA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuaZVQL_h1BYX4LajoMgUzZxJUH5ipdyO_4k36F62Z5DA@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SVJbmvkKBLlzeEJX2HbsQEdhT4Jm-2w6
X-Proofpoint-ORIG-GUID: Ktw1NQADo0zaaLQHcAZxytGiXPY506v0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=359 spamscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410150066

On Tue, Oct 15, 2024 at 02:23:32PM +0530, Naresh Kamboju wrote:
> On Mon, 14 Oct 2024 at 20:20, Greg Kroah-Hartman
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> The bisection pointing to,
>   73e9443b9ea8d5a1b9b87c4988acc3daae363832
>   s390/traps: Handle early warnings gracefully
>     [ Upstream commit 3c4d0ae0671827f4b536cc2d26f8b9c54584ccc5 ]
> 
> 
> Build log:
> -------
> arch/s390/kernel/early.c: In function '__do_early_pgm_check':
> arch/s390/kernel/early.c:154:30: error: implicit declaration of
> function 'get_lowcore'; did you mean 'S390_lowcore'?
> [-Werror=implicit-function-declaration]
>   154 |         struct lowcore *lc = get_lowcore();
>       |                              ^~~~~~~~~~~
>       |                              S390_lowcore
> arch/s390/kernel/early.c:154:30: warning: initialization of 'struct
> lowcore *' from 'int' makes pointer from integer without a cast
> [-Wint-conversion]
> cc1: some warnings being treated as errors

Same here, please drop this patch.
