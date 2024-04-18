Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8015AD88;
	Thu, 18 Apr 2024 10:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713436059; cv=none; b=Nnfvl8J0Opb7rV7Obead2k479ryqxBl8scjOFBrmQ47dE/HkqN/md3F0ugLJ4ZL8fyPLz9dQ7tE7JkAKveKBvypozCYwDfRJSfnZwBcKhnjMnBPqZA+6Jx3cpfrKK4en2EbOXc3wk+05tQ0WzQm62AvD5ngV7M+EITs/RVDEhn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713436059; c=relaxed/simple;
	bh=l0PktlGfNBkP770IX+SQswEFDu9IgkacUZXUZrm+544=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gr4xHWI53f4D3fBnZsoEt33jHFdthW7b/xtIgkP2Ikib/BIVK2S7OPaHJsMb68i5EVJ8p6mWioTiJIndzqr0LcjX/bFzz1oVdEj8nqK/3mTADpe+dHugXQs9zNNgKXgXzIpfDr2IGGoCzjthBJ7Y4MACO7Pi2w1bYJlpNObpvXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QaEsYsP7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QaEsYsP7"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43I9qnTB021464;
	Thu, 18 Apr 2024 10:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=VFEM4yX673OCnQWsK1sjaApOyag8baUFgsw0s/TifqA=;
 b=QaEsYsP7kkhj5ssPZYiAWl2NRwFNMs9grtRaJPs1QkEghQ6ZwrqNhj/nUAYF5jIo6jsk
 xq5ES36M03mW9/+nwB7jOQ7vKAbKbZi37cuVL6eYwXnOgIW9Zlc+/t6L6goQZZVgU60n
 eTVIfGN2REXmIHNZz6OlnKYZ0fZem1F+J1QHFo1SU63f8WE48lPFFLfCWH+ZfvYdDWk4
 9f5c70dfuZMN7xUSdLoN9Q1pLVMu2oAxISdxbb/hNcgNNAfGer2J1ZBbRcFfyA99n/t2
 fbpNGhKX+1XwcCVfBu8NPU/zgK9P9CWXrXSiQiZkrHtzz05zsD7Sm/KRnYsNWdWnr33x KQ== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk18ug2af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 10:27:29 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43I8M5MQ023555;
	Thu, 18 Apr 2024 10:25:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xg5cpa29x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 10:25:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43IAPp9k52429122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 10:25:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CC5620040;
	Thu, 18 Apr 2024 10:25:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 538EC20043;
	Thu, 18 Apr 2024 10:25:51 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 18 Apr 2024 10:25:51 +0000 (GMT)
Date: Thu, 18 Apr 2024 12:25:49 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>, akpm@linux-foundation.org,
        arnd@arndb.de, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com, wintera@linux.ibm.com,
        twinkler@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240418102549.6056-B-hca@linux.ibm.com>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418095438.6056-A-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wCs8fo8EhTRhucgf_a-lZhHdO296ll8B
X-Proofpoint-ORIG-GUID: wCs8fo8EhTRhucgf_a-lZhHdO296ll8B
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_08,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 spamscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180074

On Thu, Apr 18, 2024 at 11:54:38AM +0200, Heiko Carstens wrote:
> On Wed, Apr 17, 2024 at 11:24:35AM -0700, Nathan Chancellor wrote:
> > Clang warns (or errors with CONFIG_WERROR) after enabling
> > -Wcast-function-type-strict by default:
> > 
> >   drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
> >     746 |                 dev->release = (void (*)(struct device *))kfree;
> >         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   1 error generated.
> > 
> > Add a standalone function to fix the warning properly, which addresses
> > the root of the warning that these casts are not safe for kCFI. The
> > comment is not really relevant after this change, so remove it.
> > 
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  drivers/s390/char/vmlogrdr.c | 13 +++++--------
> >  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> > @@ -736,14 +740,7 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
> >  		dev->driver = &vmlogrdr_driver;
> >  		dev->groups = vmlogrdr_attr_groups;
> >  		dev_set_drvdata(dev, priv);
> > -		/*
> > -		 * The release function could be called after the
> > -		 * module has been unloaded. It's _only_ task is to
> > -		 * free the struct. Therefore, we specify kfree()
> > -		 * directly here. (Probably a little bit obfuscating
> > -		 * but legitime ...).
> > -		 */
> 
> Why is the comment not relevant after this change? Or better: why is it not
> valid before this change, which is why the code was introduced a very long
> time ago? Any reference?
> 
> I've seen the warning since quite some time, but didn't change the code
> before sure that this doesn't introduce the bug described in the comment.

From only 20 years ago:

https://lore.kernel.org/all/20040316170812.GA14971@kroah.com/

The particular code (zfcp) was changed, so it doesn't have this code
(or never did?)  anymore, but for the rest this may or may not still
be valid.
