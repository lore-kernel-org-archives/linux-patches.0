Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A36A03E
	for <patches@lists.linux.dev>; Tue, 20 Feb 2024 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708434594; cv=none; b=AZLxreulvW16bsqCuzGpUvy1toVZbtNsZ/ugAyAeqAGA8TiO3kwls8Es5kmXqElDQy4bhGAstkbtWByaDLSujOP25kvwEcBr+CbpSf+e/SNV69GHFw0+7wz8uflU2izCYUy6eZnBnJbNjVayGPrAJLbu9qLsIGHAv8vY87vOaSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708434594; c=relaxed/simple;
	bh=vIYAzgxpCjNJ/zsS7gS+rBWc13ZC5ekBoxGCkpMOO7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmIG2Q2UiB4Oecoy3jVV8OV0hMvAx4FCcWTu1E5+KSUO6LACL4ObHHzICf0tqHI2n8iEUCdz9uCqPTsNFAZhNc26wOmbBPLpTGDHoZA0kBKtgLwJEazzMlqzSfVrOggRv9j5oOu6uBdZ7Am8Zr3V7lEfOHVrjT+Y7NgwHcVFAQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gC/9fbnv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gC/9fbnv"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41KCusRX000408;
	Tue, 20 Feb 2024 13:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=HTsuwbtUsQllbajDaIbFmVbISpBh86eeM+2M+LRQqFw=;
 b=gC/9fbnvGZbcDTr+2kHc9tBZ2Q14BOhG0XaX68qYZRNLrmGLkYEoSL0u/IRhq2pL6Z2z
 4PsstmZgdP8+CVFlZrLAVMcWkDPE9rqLUdgCDqTQMwYhN2cd+hDd2mnw4+XQt9zCEE6H
 XsV12g8hQcs/tvx+nFs5333oLRscLzw9pzbb9tljL96k5bkMXsXsOx3zToGtA+0l+ZOQ
 nV0/KsHJRbxYrjWaNK2EnGhWoEXpCwsHsO8w4LBwpPCZQ0aOY8XZy/Od4+9Q5zTxLGf/
 hehLT2l6CDh9ik56ekB6no7cyrxa+oGw7mvBueTuVppm6XQC3QLYCgR+QTHWKH4nhT1L AA== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wctjxud5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 13:09:50 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41KBUpni009507;
	Tue, 20 Feb 2024 13:09:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wb84p888h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 13:09:49 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41KD9fHj3801762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 13:09:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B4DA2004B;
	Tue, 20 Feb 2024 13:09:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B46DA20040;
	Tue, 20 Feb 2024 13:09:40 +0000 (GMT)
Received: from osiris (unknown [9.179.1.191])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Feb 2024 13:09:40 +0000 (GMT)
Date: Tue, 20 Feb 2024 14:09:39 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>, patches@lists.linux.dev,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH rc] s390: Use the correct count for __iowrite64_copy()
Message-ID: <20240220130939.8115-B-hca@linux.ibm.com>
References: <0-v1-9223d11a7662+1d7785-s390_iowrite64_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-9223d11a7662+1d7785-s390_iowrite64_jgg@nvidia.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vL5v_NzygwpalC5ThgJpzCmr8bYwRTWc
X-Proofpoint-ORIG-GUID: vL5v_NzygwpalC5ThgJpzCmr8bYwRTWc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=547 malwarescore=0 priorityscore=1501 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402200094

On Fri, Feb 16, 2024 at 08:48:14PM -0400, Jason Gunthorpe wrote:
> The signature for __iowrite64_copy() requires the number of 64 bit
> quantities, not bytes. Multiple by 8 to get to a byte length before
> invoking zpci_memcpy_toio()
> 
> Fixes: 87bc359b9822 ("s390/pci: speed up __iowrite64_copy by using pci store block insn")
> Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  arch/s390/pci/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!
