Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2992FD665
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 03:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789614021; cv=none; b=vAApmClDWaElizwPsyL6fA7P9hofMuUbfzRKcSsY3jQUIBWPvKTJfTB/iuxLvm4mhK6+GAReM+6Sil+PtV6/Xk/R4B9RpY8qDCkVQhTjmSZ5kALyfhQu4CYknly6KHPZ9S+wIvS7jsJTXVIY68qXTJFfwRANL2TJkvAoCprSJjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789614021; c=relaxed/simple;
	bh=EE9Q/DQ9Jc/gy+TpekiPq9A2LDQrH3wC1TExR2j0MrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eCGXN6XoZKeb1ENLKehy6RliS4rwr/uvjobVFZG0sSJnuXuPu4SMGo+JA4fiOJcOhgXQXPriP8l/bnLMzLztgfzAr2d/O57mpu0NADE/+N8hSQb8K7ld7sramNl4O+w2siUACk8Xn+q/sBLigutSoiAs7a1aTjp28jxl4fItAAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qx3F2wDb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qx3F2wDb"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1TxX017814;
	Thu, 17 Sep 2026 02:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=a+LSV9
	DbeGupxydzgJvv7/a6MBSgbxPz8Lsd9bWtYcs=; b=qx3F2wDb7b4A75LvbOoKrB
	GPlJosrgr90bSZOHXH0Jg7DiWFogVYrrIRXDpxN5pnmXN5cHTz9JmmHmo+avZLvP
	YHKlikAVVe8ppHofsHW2DkQ3F1GtFF+OlBSJFyYiJGzAlzIRfshV9uJM4KnqcmhZ
	ESDwX+1raVqDC/IahgPwhBRkvQpeYi2fnzIDSd98d7hMeVH2MEc4djBUesqIw4JW
	K1oYTchAeEJTdP8pSKYsNZfr3igZLcQEtgDVU4IYQdjXavVVgfdgbdAmo0PK2dTG
	NniYm03B0oZbDfKm+EN8+qibG/7TKeURn0djGmG171u/46Jt/F66DNX+E+t2KwkQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf582j0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 02:59:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN4U1I1625860;
	Thu, 17 Sep 2026 02:59:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gpyxshj5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 02:59:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68H2xt6p37552484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Sep 2026 02:59:55 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFB892004B;
	Thu, 17 Sep 2026 02:59:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC82D20040;
	Thu, 17 Sep 2026 02:59:52 +0000 (GMT)
Received: from [9.39.21.238] (unknown [9.39.21.238])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 17 Sep 2026 02:59:52 +0000 (GMT)
Message-ID: <5dbf3584-23f6-4ed4-8a62-c7d8bf9e554b@linux.ibm.com>
Date: Thu, 17 Sep 2026 08:29:51 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1269/1376] powerpc: Add preempt lazy support
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
References: <0de39bd3-3575-4955-963c-b528f81b7fa6@oracle.com>
 <daily-reply-20260916-0019-re-powerpc-preempt-lazy@kernel.org>
Content-Language: en-US
From: Shrikanth Hegde <sshegde@linux.ibm.com>
In-Reply-To: <daily-reply-20260916-0019-re-powerpc-preempt-lazy@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eesL8nT7rJymXIPcaG7_TeVuTFu9TrLv
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDAzMiBTYWx0ZWRfX9+9IxHg2/Fhy
 hDWZkaY3UOSQb06bCF6o0RJhTkwTcaQfvJ9nK/jTnAjqn8z9psiftpLLTqKiUosnFMIvJ6Z7FPT
 fNXn1eo+w8DNpgQjwpLekRWf+7hKNN4=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aab57ae cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VO6RQ-b--HlpZmmj9EwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: eesL8nT7rJymXIPcaG7_TeVuTFu9TrLv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDAzMiBTYWx0ZWRfX6nrtap4lVjhw
 na7ZSm/Xqx29E3ZEJS670xElRl6CMQx22k8Ts12dTXZyHVB4yIG3SBcECRH+rZ2mhu98uj2yzSc
 ukE7LV4syepYm75gJHmmAm/0SCHK32l1LiVabLKSJFE6a+6ZZxj1vkvrbkBns/wif57rmPlH0gj
 BcNgUtdBYXLbbowUeRiCcbXy35zsoQGGt6Hv2/Kr/L+l30nMVCp8/tBR8E621PkSqdpkXIHJ4AR
 /6cmv6q7fTfaQqpJHYOy1xT7HE0JhgBOcPQrV87jqSRn8QUmaZy8RnPvprAWF41hr1pdEpWio2W
 zOOQMWD0gEptia9CWtXXWBt3iAkmJr0zqFZLYNtyaEpu4AgGJYbuPqZXgXxV1RD+zfwLhS8ZfYV
 O56CO6S7qJWxMKyhwTgPvGIWRxLkaDZ0MAK+/b1MWjAWLG2JWazykS8rxG6mZq1WTMnvnp65huI
 n06JQtuZ7RULHolQHXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1011 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170032

Hi Sasha,

On 9/17/26 12:58 AM, Sasha Levin wrote:
>> This is a broad scheduler feature rather than an isolated stable fix.
>> Mayeb we should revert this. Thoughts?
> 
> The pieces you name are indeed absent, and that is what makes the commit inert
> on 6.12 rather than incomplete. ARCH_HAS_PREEMPT_LAZY is not defined there,
> kconfig silently ignores a select of an undefined symbol, and nothing on the
> tree ever sets TIF_NEED_RESCHED_LAZY, so none of the guarded code compiles.
> 
> It arrived as a dependency walker false positive, a Kconfig context line next
> to "select ARCH_HAS_PTDUMP" in the hunk taken for 902caade3cfd ("arm64: ptdump:
> Make note_page_flush() range aware"), not as a real prerequisite.
> 
> Since it is released and does nothing observable, I am keeping it rather than
> adding a revert.
> 

As it has been discussed it is really necessary in 6.12?
Seeing some LAZY related code while main mechanism is missing can be confusing. No?

If main mechanism is not there in 6.12, I think we can drop this patch from 6.12.

