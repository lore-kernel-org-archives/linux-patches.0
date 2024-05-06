Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A2F159206;
	Mon,  6 May 2024 19:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715023578; cv=none; b=Oryp5AI+maTGP1FaBtGQiH51zbhrAZPe3lCimmrfofaf0G9L7qGrRyTFSkJgEncujEh/69/Xn4PaJnebqSHiylwRu5db2dHHSxlAfkzOHN2Wh86z2G2hpPp//LeolvLF5hOqqoHCuDU7FiJRGsSsSWCSHOGgtvh39Ypa9IXb7qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715023578; c=relaxed/simple;
	bh=/u+GoYEfl3oAzcOWe339uDLEzkSMb58puSYCsrtlF0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRYXHk9CB7RT3e4vscYcYuDP5MHL4/crTnGVNnYS6j2jOxrrm1UYtYqbBEhuIky/FuoR/e/NaMyeaPFuIRYYXGD1XoJMuF4/N5ZX3bc0E1WK+/VG1Fo6uCjUnGQCAiUnZFJUyP1YHTNHjqKTqOzvIY77apHkzyKqgVWxi3/Hk4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ByinUVpJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ByinUVpJ"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446JKsTZ008656;
	Mon, 6 May 2024 19:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=bB46RHGDnOMmQZY9xqokAuR/+Q5KRpnC639K+Gmnn94=;
 b=ByinUVpJBkYkH5N5/M+v5fpFofyWHQCcxuoXvBCNCLRgkm7ebYy+3aaSCQcnx4QZRzab
 LeqY5upzT4Cx8yKv52mqo1kMGUyFoMlhJsGG1i6KVuNy83HZYvAdvAUG7Nsbe0BzzGG5
 TMdjpk4mrks2E2lMxlMR4daeWXSZpfW6kZxyLM5FMAcGhmNZOgQL40q68V46Dzl4o4pR
 AvjFFV7R3gAz3L2YsseVxUtvotaIBHXz0gS7sg+S98vz7wTGJLR/esYT7/aLTzIagQQR
 J/wrHXTiihrCAnGIVpu+fDGBr8dSHmAlqCQAF1A91LDiJ+MhPnxM16dYTtqwKF5qxFnN NA== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xy3hy0bhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:26:11 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 446ImEWc028545;
	Mon, 6 May 2024 19:26:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xwyr01y42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 May 2024 19:26:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 446JQ4xG52494602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 May 2024 19:26:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 522BC2004E;
	Mon,  6 May 2024 19:26:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D27120040;
	Mon,  6 May 2024 19:26:03 +0000 (GMT)
Received: from osiris (unknown [9.171.40.108])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  6 May 2024 19:26:03 +0000 (GMT)
Date: Mon, 6 May 2024 21:26:02 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, gor@linux.ibm.com,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, wintera@linux.ibm.com,
        twinkler@linux.ibm.com, linux-s390@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, llvm@lists.linux.dev,
        patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240506192602.19333-A-hca@linux.ibm.com>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
 <798df2d7-b13f-482a-8d4a-106c6492af01@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <798df2d7-b13f-482a-8d4a-106c6492af01@app.fastmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SUPGp7TKlVrASP8IbG9g8Z_heMudVa5u
X-Proofpoint-GUID: SUPGp7TKlVrASP8IbG9g8Z_heMudVa5u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_13,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=524 spamscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405060140

On Thu, Apr 18, 2024 at 09:46:18PM +0200, Arnd Bergmann wrote:
> On Thu, Apr 18, 2024, at 17:15, Heiko Carstens wrote:
> > That doesn't answer my question what prevents the release function
> > from being called after the module has been unloaded.
> >
> > At least back then when the code was added it was a real bug.
> 
> I think the way this should work is to have the allocation and
> the release function in the iucv bus driver, with a function
> roughly like
> 
> struct device *iucv_alloc_device(char *name,
>                const struct attribute_group *attrs,
>                void *priv)
> {
>       dev = kzalloc(sizeof(struct device), GFP_KERNEL);
>       if (!dev)
>            return NULL;
> 
>       dev_set_name(dev, "%s", name);
>       dev->bus = &iucv_bus;
>       dev->parent = iucv_root;
>       dev->groups = attrs;
>       dev_set_drvdata(dev, priv);
>       dev->release = iucv_free_dev;
>   
>       return dev;
> }
> 
> Now the release function cannot go away as long as any module
> is loaded that links against it, and those modules cannot
> go away as long as the devices are in use.
> 
> I don't remember how iucv works, but if there is a way to
> detect which system services exist, then the actual device
> creation should also be separate from the driver using those
> services, with another driver responsible for enumerating
> the existing services and creating those devices.

So, I finally had a deeper look at this, and it looks like the comment
that says that the release function can be called after the module is
unloaded is not correct (anymore?).

I couldn't find any put_device() calls where not also the module reference
count is increased. So I guess Nathan's patches are just fine.

However given your above suggestion, I implemented an iucv_alloc_device()
function to get rid of quite some code duplication, and the casts as well.

I'll send the series for review.
