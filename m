Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F5617AD96;
	Thu, 18 Apr 2024 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713468079; cv=none; b=q3bs5Yoi6Xi/jHVcwR2TUt24Wc0SnqfxKCoVszQqNcCNbMg1fRGQM5XDT110EKfNlCx4ShDAoXrLfc77vDr2sQuYkRm5GGeFiEpk98cGpNRXMIHzV0+PaBYjP1JMMPssRerm2wdcVR1YAj0Wx89rtZpSMtRiE5kCYIzK1GKRHlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713468079; c=relaxed/simple;
	bh=hJrwwBQ4Vx1GONc5Vq5YhsnllNAU1r7+qHTtosiwSNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LFqn0cHp/YekfKkLKBaSk7It02OV40kTZZdJdTMzHMqJnucdHT2balvoMe9XVFpS/syonDBDw0UGpdbf4PP3VyvBNLlz85pxIz7uj+RMJHsoP4eZzDxxsvpPJWY3/LjsycZr0/FYtRwVyTIiRNRnl/dLbpTbbCddECtJrFPrM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ING9fYPF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ING9fYPF"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43IITnRE028914;
	Thu, 18 Apr 2024 19:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=GXr0LHselm0BbFDNOrdaYHwydELDu9Uc+uNv6Pm+rSo=;
 b=ING9fYPFoohunGhIgnmtf7JEn7GKD98uwD7pDq6/yfzIJhf9JvUC7Qax4XI1j/cZFPmq
 pJ9AtTocK/fL2twjhB49tG4MtM+AouwbDSEJq8uXofDgA0zngH/iU6bpq41U9lQLDvpJ
 gz643sGjXNvKYnAk25MmqzjYv3K8WEo1xezHDF8FW5FMb3URINRGE/uexX8MdksNOxo8
 rz1xjiHubwU2AD+LL6iVap4mXlRLhN3S6rYc0vYCVgAG9jJUPyJX9tfIDa3372xme2Ay
 H46VSEqMgze5X/3KOYJS/p364sGQ8aHgiqg/hPaEBFz8nnkf21OIJy3dO4pqARdu0vMH 5A== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk8ts04m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 19:21:09 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43IGpolm027308;
	Thu, 18 Apr 2024 19:21:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xg4s0cpmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 19:21:08 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43IJL2rw40042880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 19:21:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A186A20040;
	Thu, 18 Apr 2024 19:21:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFE9920043;
	Thu, 18 Apr 2024 19:21:01 +0000 (GMT)
Received: from osiris (unknown [9.171.91.213])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 18 Apr 2024 19:21:01 +0000 (GMT)
Date: Thu, 18 Apr 2024 21:21:00 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, arnd@arndb.de, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        wintera@linux.ibm.com, twinkler@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240418192100.6741-A-hca@linux.ibm.com>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
 <20240418153406.GC1435416@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418153406.GC1435416@dev-arch.thelio-3990X>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GRMe9dYnECViWJSf3KZGA3UiFLVN3bMu
X-Proofpoint-GUID: GRMe9dYnECViWJSf3KZGA3UiFLVN3bMu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_17,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=325 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180139

Hi Nathan,

> > > > > > -		/*
> > > > > > -		 * The release function could be called after the
> > > > > > -		 * module has been unloaded. It's _only_ task is to
> > > > > > -		 * free the struct. Therefore, we specify kfree()
> > > > > > -		 * directly here. (Probably a little bit obfuscating
> > > > > > -		 * but legitime ...).
> > > > > > -		 */
> > 
> > That doesn't answer my question what prevents the release function
> > from being called after the module has been unloaded.
> > 
> > At least back then when the code was added it was a real bug.
> 
> I do not know the answer to that question (and I suspect there is
> nothing preventing ->release() from being called after module unload),
> so I'll just bring back the comment (although I'll need to adjust it
> since kfree() is not being used there directly anymore). Andrew, would
> you prefer a diff from what's in -mm or a v2?

I guess there is some confusion here :) My request was not to keep the
comment. I'm much rather afraid that the comment is still valid; and if
that is the case then your patch series adds three bugs, exactly what is
described in the comment.

Right now the release function is kfree which is always within the kernel
image, and therefore always a valid branch target. If however the code is
changed to what you propose, then the release function would be inside of
the module, which potentially does not exist anymore when the release
function is called, since the module was unloaded.
So the branch target would be invalid.
