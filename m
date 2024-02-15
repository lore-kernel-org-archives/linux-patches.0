Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EBF33CF;
	Thu, 15 Feb 2024 08:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707987124; cv=none; b=DCv+eZFcmwFeVypZBk+jYLovKb7c0Cb8oVa4jqnBeGWJYgDkMEz3daAWeLV0TLLU+daKjNMG+k44FQ29iiCrlfnRmMSE+hMjclROT8Y0g4Mh9F8ztuwaow1/F8EN6dymbJ8xAgu587abUgt9bcxmsgqzZ8tGO/1F+dsolBinHh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707987124; c=relaxed/simple;
	bh=sqq80oasncJz61SBDmdVVD/HUcD+r0fcrop9Wek0L4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Py1nrzU1FXuP7HwOmwH1R94CXNQ37rIdn7Zx1lseIysxqKx9G1lZrP5ecHKLjZPw8klgGb1Z8ePWhbPKXQ5zpBdqvTLkb1Hxes2DwxrUNumV/Ed+MnJaRsErth1Ab61MHRaZSxoXTlDgscYcOm5ke4pR7eKlc98Bvq58yzLJWo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tmBbYmMi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tmBbYmMi"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41F8aGrT029154;
	Thu, 15 Feb 2024 08:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=2co+1inaADahS61G21mEIOggndUbhDvwt8F1kGzcLEk=;
 b=tmBbYmMitoJyIPHRqiqqjktlch1I7U9TzrZgpw9waP9t+8JS/TBzBIpy9VDQ70X8QN6I
 UsVipPn1F/t6MIHu4V3LNaVn2htfisAsxwEfNO7HuOdT9rQep1i52dZvROtfki36DP9Q
 +5faCm2rH+WPfUid/amtjs5OFL+QoxGz/yrYLo50fSgPYlEAOmE2YusZ4zUDdc9XAaMB
 D/56qFpwy8Hc/bnjuo7eyyhNO0MZuzBt5FXXTXjU0OMwPY+64m5LnSCflnUa84pgu4ig
 FQCH5L6E/Wf80cP8I1RxqF4xyCEQTcmXVmzXFyChF81LwUN9dSOwVhdt+wJz2WDhYL12 xA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w9ete0x5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Feb 2024 08:51:58 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41F8aNa2030683;
	Thu, 15 Feb 2024 08:51:58 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w9ete0x55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Feb 2024 08:51:58 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41F7aW62004251;
	Thu, 15 Feb 2024 08:51:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w6kv0kt4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Feb 2024 08:51:57 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41F8pqBF48103680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 08:51:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06CA520043;
	Thu, 15 Feb 2024 08:51:52 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB87B20040;
	Thu, 15 Feb 2024 08:51:51 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 15 Feb 2024 08:51:51 +0000 (GMT)
Date: Thu, 15 Feb 2024 09:51:50 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, morbo@google.com, justinstitt@google.com,
        linux-s390@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
Subject: Re: [PATCH] s390: Don't allow CONFIG_COMPAT with LD=ld.lld
Message-ID: <20240215085150.6583-A-hca@linux.ibm.com>
References: <20240214-s390-compat-lld-dep-v1-1-abf1f4b5e514@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214-s390-compat-lld-dep-v1-1-abf1f4b5e514@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KhXJETOcuspk-bhFnI_kjvMItpfgbksq
X-Proofpoint-ORIG-GUID: cVqv_Fzdhg6blSlhm4N0nvNtlx4fdzPO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_08,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 mlxlogscore=656 impostorscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402150069

On Wed, Feb 14, 2024 at 03:53:48PM -0700, Nathan Chancellor wrote:
> When building 'ARCH=s390 defconfig compat.config' with GCC and
> LD=ld.lld, there is an error when attempting to link the compat vDSO:
> 
>   ld.lld: error: unknown emulation: elf_s390
>   make[4]: *** [arch/s390/kernel/vdso32/Makefile:48: arch/s390/kernel/vdso32/vdso32.so.dbg] Error 1
> 
> Much like clang, ld.lld only supports the 64-bit s390 emulation. Add a
> dependency on not using LLD to CONFIG_COMPAT to avoid breaking the build
> with this toolchain combination.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/s390/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!
