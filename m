Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA3A1353E2;
	Tue, 20 Feb 2024 19:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708456551; cv=none; b=OHySHkBl4PexhDpMcQheSuUy5rOH3tYJXRgAU11gcuH7QZImDl+UpsWPZDJ+1lAha6lAaBj/u/iHzCOxZS7JJ4kLBENmgXG+L7kqngPVPgGhaZo0qEeEhvmIebMBGwxzZ04YxZGEet+qYFGi4+g6fUfQq62NkB+nOzbXatGM8yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708456551; c=relaxed/simple;
	bh=Z/t+ZsXdV1hYnDG6K/BE0atUmSQOoX6f5wIxvew3KQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=raFuTzG1v4TeMCv+bi5wOw6uMRs101CRSjMFYpOJEBHRtIq6vJUR6Dn2r5TySRTKw+k/u3CIbPpgvqkoHjV3yLNDwDAEKkqTC1+seHsIm2FWr8r0TCcOwmcx6dF2xY30QICUeLogURtKIHd7UdU9MMxanoAfx+0h1uZEVlqeefM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DeXDADMT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DeXDADMT"
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41KJ27Rw022316;
	Tue, 20 Feb 2024 19:15:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=jafodIKVXwEPBS7clsKCI9JQkSkC6D3nXLa87R4o64I=;
 b=DeXDADMTsL+9a4QkbecRHiUaOeKtA8jBYAzRSQj2NoiPfzaPsdjh9kYIp9qVan9BF9Er
 NVLFMwe3qIYIcJN3Lnuv40+qzG5VuY6HKqQ3PXLqBa9nqug7drz4fQZUfQ2/OmeUq2GQ
 X6hk6fgCrRJZr+JAl7WlPQ4cncZfqdGY8iU4sUTQYzJM2XIHutGJWZwWNtpfsJBosxCW
 GLOgXfIOJrNvXMJ5zTT77yhcLEaLu1yvnXUzGzYEvi8+OCY/eFYeaLDVaHSKxQuxpARa
 Y5537UJdf6dEoEO5oHPADuGTJ3UK4yv8XXsbJEGQONl8DXDlTwoZMfn0Hb8KbnHXyDra Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wd1vp0b9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 19:15:47 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41KJ2SxT023229;
	Tue, 20 Feb 2024 19:15:46 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wd1vp0b9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 19:15:46 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41KIOik5014343;
	Tue, 20 Feb 2024 19:15:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wb9u2hs1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 19:15:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41KJFaKr26346198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 19:15:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8230820040;
	Tue, 20 Feb 2024 19:15:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DED482004B;
	Tue, 20 Feb 2024 19:15:35 +0000 (GMT)
Received: from osiris (unknown [9.171.44.168])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Feb 2024 19:15:35 +0000 (GMT)
Date: Tue, 20 Feb 2024 20:15:34 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, morbo@google.com, justinstitt@google.com,
        linux-s390@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev, Ulrich Weigand <ulrich.weigand@de.ibm.com>
Subject: Re: [PATCH] s390/boot: Add 'alloc' to info.bin .vmlinux.info section
 flags
Message-ID: <20240220191534.12893-B-hca@linux.ibm.com>
References: <20240216-s390-fix-boot-with-llvm-objcopy-v1-1-0ac623daf42b@kernel.org>
 <20240219113248.16287-C-hca@linux.ibm.com>
 <20240219231623.GA2565406@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219231623.GA2565406@dev-arch.thelio-3990X>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oOoC5iAugX_i_5PV1_jvv6Zaf7aoHKxq
X-Proofpoint-GUID: wRr0fV0dWr20AjYEV8x51daVnL2aee4v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0
 mlxlogscore=711 clxscore=1015 spamscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2402200139

Hi Nathan,

> > [...]
> > So somehow llvmdump's "-j/--section" option doesn not seem to work.
> 
> However, since I am more of a kernel hacker than I am an LLVM one, I
> came up with a potential solution in arch/s390/boot/Makefile, which is
> basically just filtering the symbol table manually with grep... it
> appears to produce stable results based on a small test Makefile I have
> to make sure the output looks sane before running through sha256sum. I'd
> be happy to send this as a formal patch if you'd accept it for full
> LLVM=1 compatibility with LLVM 19.0.0+ and Linux 6.9+.

Ok, please send a formal patch for this approach.
