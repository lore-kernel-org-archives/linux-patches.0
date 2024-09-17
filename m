Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2E11CC8BB;
	Tue, 17 Sep 2024 15:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726586268; cv=none; b=B0fdvtwepIbjjKvCVdgst3i2fUUT/FyQtYn/+VXE+yV6xWM2UY9tnqOkeehGZmUx9UUwhSiaIkqaW12cs88B3kFmpIxIYO3VKf+RPsSZSmk0pyR2/r7DAkgPoEeOZwknFYv5Ivc9QePfs0RU+LvSImh/wiIoBT0eBzq7D0YMDMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726586268; c=relaxed/simple;
	bh=9kDkjz2tpNmps5xIXmiWJKL4DLpW37P3EmDpP8u9hFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZItjDsW7gmZ3M9QI2epS9FjI12mK9L9Jgidy3127C7enB8stkQBKoSUMQfxGzlMMlhkQ3TptvkAMOG1bkZjFKrHkuZLDhHwew6seqVwaULVLh2GDYdCjlnUUZCxz75GTHRrGFHd1NxzX4w7TrFHyo09/IfYzKT9RGV6O04X1yO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=leWEZ4y6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="leWEZ4y6"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48H77OZ1031408;
	Tue, 17 Sep 2024 15:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=dxtiqODPLGIvLkUpVd4JxQOK7U6
	2NEbeDOLTJEJwCVA=; b=leWEZ4y6Hb2rNcQnJPd2Ax00ue8tsUvhhKsArC2zFfo
	N//l0CnqHWgF1zlj6JxJMHKpDkv9WSPr62PEM1dPNUSZHwycRlOcOq42P8YZv4BA
	hYOvg/Lw1TdkiN7WK5r+W2kYLAsJtV37Zn5T7KDt+AlOvXcpBRc7LugXeWwoIrxk
	D5bzBGu8lrgIMK0biBkmv2PDlekVdDI29IsCviYBVnhcDb7N5Nf/367pFQtNbiAV
	WD3invr7u5A0rMjazwNkBlqCjCghhi9+/sts9HjgaX1eQJYHfQMWk6smhREy1nui
	QtYeR5NPXfssyM5F938furCcN4nCf4lfYdZNefMYM2A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vnrcqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:17:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48HDcMSq024699;
	Tue, 17 Sep 2024 15:17:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nq1mwpru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:17:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48HFHYeC48693694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Sep 2024 15:17:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC6A420043;
	Tue, 17 Sep 2024 15:17:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C35B20040;
	Tue, 17 Sep 2024 15:17:34 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.77.106])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Sep 2024 15:17:34 +0000 (GMT)
Date: Tue, 17 Sep 2024 17:17:32 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Vasily Gorbik <gor@linux.ibm.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 32/91] s390/mm: Prevent lowcore vs identity mapping
 overlap
Message-ID: <ZumdjDsZoGlVSMDr@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240916114224.509743970@linuxfoundation.org>
 <20240916114225.569160063@linuxfoundation.org>
 <Zuliy6DOi47cD-cZ@tuxmaker.boeblingen.de.ibm.com>
 <2024091750-upwind-shaking-6fa2@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024091750-upwind-shaking-6fa2@gregkh>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SIepweNifTWguPswfeyLrIMl9Bv6wRUa
X-Proofpoint-GUID: SIepweNifTWguPswfeyLrIMl9Bv6wRUa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-17_07,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=537
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409170108

On Tue, Sep 17, 2024 at 01:15:10PM +0200, Greg Kroah-Hartman wrote:
> > Could you please drop this commit from 6.6-stable?
> Why just this one?  What about 6.10.y?  6.11?

Thanks for pointing out!

Yes, please drop it from 6.10 as well. There is no relocatable lowcore
support in 6.10, which this patch fixes up. And it is already included
in 6.11, starting from v6.11-rc5.

> thanks,

Thank you!

> greg k-h
