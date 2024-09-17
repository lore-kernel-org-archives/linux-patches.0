Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D097E1547F8;
	Tue, 17 Sep 2024 11:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726571228; cv=none; b=gXxlBMpKSRQE+6E7kftFJtuqZEZ+dx2TeAF9/duGjjfshl7Mz0T2GTdfNexQrlX4XsFqRTAe2vE2HDAavNMcW7KOB5Fvjc2QGDpn4Pm+cYAZsk+Cb6jJ7IaKIU9wP9E1DsC3ZoBNZbKGLSQ4W10itcqVLdvhEotRx5AwgWZXfLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726571228; c=relaxed/simple;
	bh=4TzgfNzU4X7Llu0Ur+J1tTSGJc+SZrOy4FB+uAHhS6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmxYncRHy0MulcKSrY0mJyYgVwiBOgw2hvZQIc6bd5N9huuileOYadZKaGMJDdcpcIT6OO+xhgCKGzIZdqpXYzhvwSizVNFVcYrKtZWfcmkMxrT0y7Zj2LdSox44953FAgCQMOZXc+t6IxZIDcBzcC4+9pd3rKPoBhZviXp4tcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X5kSIzfe; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X5kSIzfe"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48H8LQWw031824;
	Tue, 17 Sep 2024 11:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=uFk2CZ9i+fQ2hNEQA/VA4OdDwxn
	NB6sKXFr9zpdKM0w=; b=X5kSIzfeSTP4CxaX2d/mrglrTkrvkqA/IzUfj8kEsHy
	iauq5tnmD/ffB1AZIJI1pS8/1FohiA1qM9f6LRonuh3ppXl+//E9X8mksZ36AE05
	tcprvHQ4/XTwsNbKridJJyoM4VjdjeW5/lRtqG1u1/o2rRzAtubpS+ixe8qua5PV
	54p8HcNqnXKGnwtVlq0VnOJOg8c8PayYazofRAm6vcBN4/yvj9FonWaG/kl2NDvi
	Z0Jy7Mmf56RcmtqYNM2X5RY+nQBQo2NbHD0qbdUHA3Rb2G+vj/Mtqf9elXYfb4J+
	JjnzjRotontn3YESr4H2QOuZCo/BPUKoGzEOXGl6Cdg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3uj7nvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 11:06:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48HALncT024672;
	Tue, 17 Sep 2024 11:06:54 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nq1mvhsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 11:06:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48HB6rfG49742212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Sep 2024 11:06:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0277520043;
	Tue, 17 Sep 2024 11:06:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C84772004B;
	Tue, 17 Sep 2024 11:06:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Sep 2024 11:06:52 +0000 (GMT)
Date: Tue, 17 Sep 2024 13:06:51 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Vasily Gorbik <gor@linux.ibm.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 32/91] s390/mm: Prevent lowcore vs identity mapping
 overlap
Message-ID: <Zuliy6DOi47cD-cZ@tuxmaker.boeblingen.de.ibm.com>
References: <20240916114224.509743970@linuxfoundation.org>
 <20240916114225.569160063@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916114225.569160063@linuxfoundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UMwGydxAuuitSA5cPk3xqlH68mJwCYCi
X-Proofpoint-GUID: UMwGydxAuuitSA5cPk3xqlH68mJwCYCi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-17_02,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=997 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 suspectscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409170079

On Mon, Sep 16, 2024 at 01:44:08PM +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

Hi Greg,

Could you please drop this commit from 6.6-stable?

Thanks!

> ------------------
> 
> From: Alexander Gordeev <agordeev@linux.ibm.com>
> 
> [ Upstream commit a3ca27c405faad584af6e8e38cdafe5be73230a1 ]
> 
> The identity mapping position in virtual memory is randomized
> together with the kernel mapping. That position can never
> overlap with the lowcore even when the lowcore is relocated.
> 
> Prevent overlapping with the lowcore to allow independent
> positioning of the identity mapping. With the current value
> of the alternative lowcore address of 0x70000 the overlap
> could happen in case the identity mapping is placed at zero.
> 
> This is a prerequisite for uncoupling of randomization base
> of kernel image and identity mapping in virtual memory.
> 
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/s390/kernel/setup.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
> index d48c7afe97e6..89fe0764af84 100644
> --- a/arch/s390/kernel/setup.c
> +++ b/arch/s390/kernel/setup.c
> @@ -741,7 +741,23 @@ static void __init memblock_add_physmem_info(void)
>  }
>  
>  /*
> - * Reserve memory used for lowcore/command line/kernel image.
> + * Reserve memory used for lowcore.
> + */
> +static void __init reserve_lowcore(void)
> +{
> +	void *lowcore_start = get_lowcore();
> +	void *lowcore_end = lowcore_start + sizeof(struct lowcore);
> +	void *start, *end;
> +
> +	if ((void *)__identity_base < lowcore_end) {
> +		start = max(lowcore_start, (void *)__identity_base);
> +		end = min(lowcore_end, (void *)(__identity_base + ident_map_size));
> +		memblock_reserve(__pa(start), __pa(end));
> +	}
> +}
> +
> +/*
> + * Reserve memory used for absolute lowcore/command line/kernel image.
>   */
>  static void __init reserve_kernel(void)
>  {
> @@ -939,6 +955,7 @@ void __init setup_arch(char **cmdline_p)
>  
>  	/* Do some memory reservations *before* memory is added to memblock */
>  	reserve_pgtables();
> +	reserve_lowcore();
>  	reserve_kernel();
>  	reserve_initrd();
>  	reserve_certificate_list();
> -- 
> 2.43.0
