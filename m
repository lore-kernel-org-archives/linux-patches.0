Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C1A18B488
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 09:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728985806; cv=none; b=ns9Ht35k/BEmNBjFyVUyO1Qkm1nyvTapbumo4XVtuTOZSFQKtw0h45zGkRIxCAnK4KgbQaJlrZPWFosNb9I+EUQOMiOHZerPEfpZg2Qae4KTn41NRC6D9i/J0Jhr1tPnMd3+NQ71FNFegLLmyxU8ZKNUkbaPLweiGcafXTg+dzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728985806; c=relaxed/simple;
	bh=w53a2Y4hTmYZJZlBwbZse6niOg5yWc31HoXpNI/OoKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ENV+3BTZfwch4bO0AOKvEIJ/iWxF6i76YgqyW0w3JOsfsjG/bBBvF96j73yAYBaz1sgED1n/iqeDW3rzpXhXO4y76guGsHrA2SusdCzPfTmcjI0jta9ECF9NUzNQvNZw06jLqpAHZPutXOhfpN74luNlDt3wVE/DoAEJZaj/hH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G9R09VS4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G9R09VS4"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F8oOQR014787;
	Tue, 15 Oct 2024 09:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ShZ9gnbxMsBABhTJB/bowgnpA4wzcV
	7SU360g9dlR7E=; b=G9R09VS4Std4FDnxIQSkY0k+HcR9Mb/lJRgTp6UGxT57HW
	2Z7U4KvrAmcD8d/t1EiouGlfeII4etxmTCCvRz/6sY9y9cOvsGB1I3Y3h/QRWMzY
	T4zkJJbF0xURXJnbR+6CqtlnuE91YzHLKAz3gIzAySCP3h9814vCHh5SWybhXi/Y
	h45HjE6YAAbyURNB4QWAujm9CkSbxA8ud/TOnYl87ONwY523Uimrxzqp+gQ8kEyq
	TqysAMF9TFn6pNLboyubjpuztDlfymMCTUO0Q+wUSvZdy5TIvhrd4UFbdxdHwfpI
	k3O06d49b7S0dRBQvDWBV3ptS1+D4aw333r0exmQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429n7tr85m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:49:56 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F9gZcw020515;
	Tue, 15 Oct 2024 09:49:55 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429n7tr84j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:49:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F81UHU006405;
	Tue, 15 Oct 2024 09:49:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xk2ye4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:49:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F9nR8S16384328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 09:49:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 662DE20043;
	Tue, 15 Oct 2024 09:49:27 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 147EB20040;
	Tue, 15 Oct 2024 09:49:27 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 09:49:27 +0000 (GMT)
Date: Tue, 15 Oct 2024 11:49:25 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 6.6 000/213] 6.6.57-rc1 review
Message-ID: <20241015094925.7641-G-hca@linux.ibm.com>
References: <20241014141042.954319779@linuxfoundation.org>
 <CA+G9fYs-BXW2J-n1R7VO2j-qqpP=3nzYC4a2C7=-fnLTW8OR8w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs-BXW2J-n1R7VO2j-qqpP=3nzYC4a2C7=-fnLTW8OR8w@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kSjWz3iT_JL1KttJPpL9hvGQlB6k_0mb
X-Proofpoint-ORIG-GUID: E9xp6sggOQctNZiWLMRjdWfnh7eIYIrC
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=449 spamscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410150066

On Tue, Oct 15, 2024 at 01:51:21PM +0530, Naresh Kamboju wrote:
> On Mon, 14 Oct 2024 at 20:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.57 release.
> > There are 213 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.57-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The S390 build broke on the stable-rc linux-6.6.y branch due to
> following build warnings / errors.
> 
> First seen on v6.6.56-214-g8a7bf87a1018
>   GOOD: v6.6.56
>   BAD: v6.6.56-214-g8a7bf87a1018
> 
> Bisection points to,
>   d38c79a1f30ba78448cc58d5dee31c636e16112d
>   s390/traps: Handle early warnings gracefully
>     [ Upstream commit 3c4d0ae0671827f4b536cc2d26f8b9c54584ccc5 ]

Thanks for reporting; just drop this patch please.
