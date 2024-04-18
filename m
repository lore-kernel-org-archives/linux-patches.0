Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613CE6FC3;
	Thu, 18 Apr 2024 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713453318; cv=none; b=CFsN0d/QAHVSSc/cuipIH7YnyfNzFwefXLK3aX2Iby4ylr6O4jdpQdyQrEKgFHSvGCpuJoGSyaXkpzvYejjKPs9we9pAxlZTmZ5Hqvxw8eUrOPo8JT8N48JPQyXeirNLBz0/Ij90L4FDyhffW13xm27JAdp0O4zudtUKPrvRtjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713453318; c=relaxed/simple;
	bh=MqV2rBxMgLuJe+VPlLPa1DPQKM5xkGlhpgau/ML3Eh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CGrJsz/iUl7e1O7kAJicHQ72Nc3nn1Jcv+H/bSp9lUXNESc+rQTGW3UjU4SalSqcyq8TA/unrxeFnFetk8CAGqxyE1n1h/YG8jdDsWcHqohoYaL6fjQw5EIu7jRXGdWpZx2TZ9ch2V+NkN234UQ8I+HqS0+FGpqRRm6gzf5mfJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AEqykXqX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AEqykXqX"
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43IFBU5q001060;
	Thu, 18 Apr 2024 15:15:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=yvJB7n3zcg0lP7jYTfc+29ixZY/rHTOtVz0igNMWcjY=;
 b=AEqykXqXYh+bhRmx643unlJZxPkzEgQ/dhvx7UGCm3dHgSWUmxdPOjbAtcJl776ABwr3
 s6lFyC6ZJpSA4iHoMJcaJumf1AyLMKTIbd7p+Ev/a0UFeC0VhOzvyW0kT+OXxEYdYd69
 03ThFm0e3BfoLVTQwYly7ZkAZj8lcwUHUmMX6Kcf8WA/LPVhATidZAwgDgJfRMHkj3l7
 TSi6c9tFUWI8lkSUujIxZTo66RyaeqO0CjZZnXqeoPuV1/lR8+9hDWSS0yx3OD1XPL6a
 rZerizTHuHyaD0/4nIVB3NO5vQpVoMzZpQTrmTdIyvKG3TmtcBCtJUwgu4LCVmvivMcs Ww== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xk5xb009w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 15:15:09 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43IDXLS8011137;
	Thu, 18 Apr 2024 15:15:09 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xg732twcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 15:15:09 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43IFF3nv47513972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 15:15:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FFDF2004D;
	Thu, 18 Apr 2024 15:15:03 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49C8C20043;
	Thu, 18 Apr 2024 15:15:03 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 18 Apr 2024 15:15:03 +0000 (GMT)
Date: Thu, 18 Apr 2024 17:15:01 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, arnd@arndb.de, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        wintera@linux.ibm.com, twinkler@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240418151501.6056-C-hca@linux.ibm.com>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418145121.GA1435416@dev-arch.thelio-3990X>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tdDPeclmPDKm_VNRKQNLV_YRxDgk2lU6
X-Proofpoint-GUID: tdDPeclmPDKm_VNRKQNLV_YRxDgk2lU6
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_13,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=541 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2404180108

Hi Nathan,

> > > > -		/*
> > > > -		 * The release function could be called after the
> > > > -		 * module has been unloaded. It's _only_ task is to
> > > > -		 * free the struct. Therefore, we specify kfree()
> > > > -		 * directly here. (Probably a little bit obfuscating
> > > > -		 * but legitime ...).
> > > > -		 */
> > > 
> > > Why is the comment not relevant after this change? Or better: why is it not
> > > valid before this change, which is why the code was introduced a very long
> > > time ago? Any reference?
> > > 
> > > I've seen the warning since quite some time, but didn't change the code
> > > before sure that this doesn't introduce the bug described in the comment.
> > 
> > From only 20 years ago:
> > 
> > https://lore.kernel.org/all/20040316170812.GA14971@kroah.com/
> > 
> > The particular code (zfcp) was changed, so it doesn't have this code
> > (or never did?)  anymore, but for the rest this may or may not still
> > be valid.
> 
> I guess relevant may not have been the correct word. Maybe obvious? I
> can keep the comment but I do not really see what it adds, although
> reading the above thread, I suppose it was added as justification for
> calling kfree() as ->release() for a 'struct device'? Kind of seems like
> that ship has sailed since I see this all over the place as a
> ->release() function. I do not see how this patch could have a function
> change beyond that but I may be misreading or misinterpreting your full
> comment.

That doesn't answer my question what prevents the release function
from being called after the module has been unloaded.

At least back then when the code was added it was a real bug.
