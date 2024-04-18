Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626A815AAAD;
	Thu, 18 Apr 2024 09:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713434095; cv=none; b=BHw0meIJxoNSTgxeFK5PkBIAzRVre1SUgWh7Z3zKMmddQUQIu9hMPqNqloBnFo7UpJ7W71iQY/kP3pnFtoeDqOE5rNSFNQ93Tg4MaIZp5+TexgmkczVoXdJshpw8OnEFxH4IUsH17dLM2Kg6BRYgse/J4I15+juo91sIaAlagfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713434095; c=relaxed/simple;
	bh=9I8hH459E4/yCH911llo33KhdbxdMW+TcQhVfoAbi38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFggmuGUDH2sQQ8hS6sdWeniu3URvwn4rSeMKjfPZs8VTQof3xmMiaQCx+kV4RA6kS4gIpzlg4tR0NzKiDCGBFKaHzGpjSYlIqM2XNta3MJ1XIxAhADkxtsOYgAYtalvQUvr56T4oEQB7ltd3keRprxkni/0ZUHITS/7RHEMTmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n24fMwNu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n24fMwNu"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43I9dEp3025374;
	Thu, 18 Apr 2024 09:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=ijedH553tLeWMy89yyjaizY100lbOCvInR7Snt27o1k=;
 b=n24fMwNuPSe2T6DqezjKBq80RVACVJAWe4I7pTrlkr0hjnojWwO+Uc4D+vWkVELF+pDK
 601JcpJDye0GbdXH18Jv6rE5oFUYCmQpwP5SkupNRCdqK4SI8yf7BoFb01A8aSoluiXy
 K1455uI8u1ONkfbtdLaWh1uAeCWx4OEONVlo6D6AdrJwNq9C8ys7no0mm1N4fF2SaBdB
 jUPoNmwDlB1eqcNgi0MUc8yTlxKK6lBcvceDep6q9I90QwWCIFe3q70BWaS5h2uKkTqi
 F53Rd9g3K57yBfaMudZOOde/xnSsoKOOTsLTvmPKxpMJTpjOT3UOKGq8wlU+eelClIez gg== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk12cg13k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 09:54:46 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43I7YWqT018152;
	Thu, 18 Apr 2024 09:54:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xg4ctj4xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 09:54:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43I9seCa31326840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 09:54:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 999102004E;
	Thu, 18 Apr 2024 09:54:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50D252004B;
	Thu, 18 Apr 2024 09:54:40 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 18 Apr 2024 09:54:40 +0000 (GMT)
Date: Thu, 18 Apr 2024 11:54:38 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, arnd@arndb.de, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        wintera@linux.ibm.com, twinkler@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240418095438.6056-A-hca@linux.ibm.com>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QjeqBBTYqMOd1_oCSuGV29-ZglmEKbWE
X-Proofpoint-ORIG-GUID: QjeqBBTYqMOd1_oCSuGV29-ZglmEKbWE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_08,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180069

On Wed, Apr 17, 2024 at 11:24:35AM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR) after enabling
> -Wcast-function-type-strict by default:
> 
>   drivers/s390/char/vmlogrdr.c:746:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
>     746 |                 dev->release = (void (*)(struct device *))kfree;
>         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
> 
> Add a standalone function to fix the warning properly, which addresses
> the root of the warning that these casts are not safe for kCFI. The
> comment is not really relevant after this change, so remove it.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/s390/char/vmlogrdr.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)

> @@ -736,14 +740,7 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
>  		dev->driver = &vmlogrdr_driver;
>  		dev->groups = vmlogrdr_attr_groups;
>  		dev_set_drvdata(dev, priv);
> -		/*
> -		 * The release function could be called after the
> -		 * module has been unloaded. It's _only_ task is to
> -		 * free the struct. Therefore, we specify kfree()
> -		 * directly here. (Probably a little bit obfuscating
> -		 * but legitime ...).
> -		 */

Why is the comment not relevant after this change? Or better: why is it not
valid before this change, which is why the code was introduced a very long
time ago? Any reference?

I've seen the warning since quite some time, but didn't change the code
before sure that this doesn't introduce the bug described in the comment.
