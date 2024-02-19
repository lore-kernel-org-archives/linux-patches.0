Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9DB25630
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 10:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708337342; cv=none; b=IUi5kvEbkSeyK3ZG3kLMyF250/3vpCbqZa3kweEigzVQosVnmUxm6EYK0nza9I5vBREWVt3iGyeWp1+d3kHtj8C8O+NxlTiffhHJ2LUgSccRKCzQQ52rHH74rilb7BFQKJIAsgW+t3BC6uxNzpeLw6/ewaWqWSPPms1GdeaUZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708337342; c=relaxed/simple;
	bh=NiB/ncoGZzTer9gq4bHdN3m7zjs5PdwjvfeHCQ1tXT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQfZwoeW9VGZovcrMTe1IED2iCm8/lPAxrYo/2qPE4EvCgyzVaygkmsFDqhUEilY9VqEJyiqUp7QaJ8N8xiGZ1xRmiTWZuC9AjBB5qJ35zwY+mLODfJZlr6N7Q3zjmiWmzVSYo0rGOrLywNjiQBxcXySo1EPP+eCBTPkJXaciao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tFyLLMRW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tFyLLMRW"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J9tvw3028978;
	Mon, 19 Feb 2024 10:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=3Pa9xta3U08SaYEZz9sJ8QsEGN/F+Zf0eR96/bWmlY4=;
 b=tFyLLMRW2jIX6LxuFUk3R55vtPNV36H2Reu+aqmMdDpiW8bRHFmKVLnGGjZn9O9NLPOJ
 U1XpoI6NRMwSqJwalNJSezXJkxs0zi97n2zaoK/pWzuO34Dycp4dAwaCiKerU5zJfVZL
 GhDQd9IkpaH3UCI0YvtmsIqBjTJw7/kn4m9J02z73g2OJm4lBmGoiT9jgN/Nutulk/a6
 WMACLuBVsPviG2NCc9XHp0vaR7XXs4W9PO55zA8MVAJJhIqT4uJWf6qj8jisHZh5hGi0
 uSUvjFTCj/L8wqtCj5I8HxBd6DhrkU7uHHbu4EXQoPzwGD7HIrvXuG+MVZhClLuc1zAi og== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wb2p8ddk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Feb 2024 10:08:59 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41J7FpSb013452;
	Mon, 19 Feb 2024 10:08:58 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wb7h00qtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Feb 2024 10:08:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41JA8rsl20185798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 10:08:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D90B2005A;
	Mon, 19 Feb 2024 10:08:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 717EB20065;
	Mon, 19 Feb 2024 10:08:52 +0000 (GMT)
Received: from osiris (unknown [9.171.27.39])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 19 Feb 2024 10:08:52 +0000 (GMT)
Date: Mon, 19 Feb 2024 11:08:50 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, patches@lists.linux.dev,
        Niklas Schnelle <schnelle@linux.ibm.com>
Subject: Re: [PATCH rc] s390: Use the correct count for __iowrite64_copy()
Message-ID: <20240219100850.16287-B-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: -5OX1OsAOt82gjycIQowPQZ1Rsvh5d9f
X-Proofpoint-GUID: -5OX1OsAOt82gjycIQowPQZ1Rsvh5d9f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_07,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=688 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190075

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
> 
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 676ac74026a82b..52a44e353796c0 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -252,7 +252,7 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
>  /* combine single writes by using store-block insn */
>  void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
>  {
> -       zpci_memcpy_toio(to, from, count);
> +	zpci_memcpy_toio(to, from, count * 8);
>  }

Odd, this bug is 11 years old, and there was never any bug report.
Is this never called, or how is this possible?

Niklas, would you happen to have an idea?
