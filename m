Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A313B52F71;
	Fri, 19 Apr 2024 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713528924; cv=none; b=nrcdSwFYDDG1S7G5BFKbXJMJRMeLylk+ey2xpVtqrbs/a70BFq9DqhSt0kS3Eo+BtGRcWP06/AqzlZ5ntxgePb99CvpXfh0/wvEw9zUrolYG9XWNuiyuaTtvEV32j9UzddCFvH6AC6/pxrYUho0b2A3gOcIdjjk2ZHCo7UfAfiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713528924; c=relaxed/simple;
	bh=uJctjiwok9OAxi8V9EB9j1/O1K4QOMr78QQhPuVBSY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=otbwIC/+nP5ElPX7JYLa8SO9q2Uy7NjwmhqxuetHsIS+XBvIlqHdnbMtUy4bsh/J0hvTuLIC04s/oAQAA8HQUtlftemW3HMSFUXdNZdewF8IvlctDQObFLpbF3j/6p2G64hw9GtwIOM0iRILJ3ANPHZcCHo0rNINQ0xcFdApV+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qtuopD0Y; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qtuopD0Y"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43JBZCLo020693;
	Fri, 19 Apr 2024 12:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=XSwAKK1U4BbAzR0wUXsJ0kRA3eWzLRtYrhex8CN/Lbc=;
 b=qtuopD0YV+mtz024ohiwb+aYk2zP3zUUQi0G0yInoKE8MSAx7C49k9uoz3XNAwRtcGhf
 G/ldqQH8YbKAxEKC6YjCQQGpWp4seHs7ZBCep7ejPPMuNO5RzxSsLA7hc8P4Z5Ixznfv
 Y9+3hMZD9z4saXHOBY1P3XZmJBdSnDe3Bu4OmNvlirVgSE9zknHcYbL6oBYaXQc4MLoj
 5ALKpnbqByWi+JSGlZNN287NM3w9deg+OyRYcooo9r959f2RuI5tTIQ+GtK8SQJZLiWg
 dbavR7PBhaVhYZ9DfoNhSdIiU8DKsSL89wRV6vbX3P+VxxBF7p9ZqKmgmBOsOfh7YMSO Gw== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xkqu2837b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 12:15:15 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43J8uA1Z027929;
	Fri, 19 Apr 2024 12:15:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xkbmpbfgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 12:15:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43JCF8Qg52429204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 12:15:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF4682004D;
	Fri, 19 Apr 2024 12:15:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13BC620040;
	Fri, 19 Apr 2024 12:15:08 +0000 (GMT)
Received: from osiris (unknown [9.171.8.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 19 Apr 2024 12:15:07 +0000 (GMT)
Date: Fri, 19 Apr 2024 14:15:06 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, gor@linux.ibm.com,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, wintera@linux.ibm.com,
        twinkler@linux.ibm.com, linux-s390@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, llvm@lists.linux.dev,
        patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240419121506.23824-A-hca@linux.ibm.com>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
 <798df2d7-b13f-482a-8d4a-106c6492af01@app.fastmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <798df2d7-b13f-482a-8d4a-106c6492af01@app.fastmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jtCq1dlQ4O8G1fc-sPJaSGTvo2WX1l6d
X-Proofpoint-ORIG-GUID: jtCq1dlQ4O8G1fc-sPJaSGTvo2WX1l6d
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-19_08,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=877 impostorscore=0
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404190092

On Thu, Apr 18, 2024 at 09:46:18PM +0200, Arnd Bergmann wrote:
> On Thu, Apr 18, 2024, at 17:15, Heiko Carstens wrote:
> >> > > > -		/*
> >> > > > -		 * The release function could be called after the
> >> > > > -		 * module has been unloaded. It's _only_ task is to
> >> > > > -		 * free the struct. Therefore, we specify kfree()
> >> > > > -		 * directly here. (Probably a little bit obfuscating
> >> > > > -		 * but legitime ...).
> >> > > > -		 */
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

I have the impression we have the same discussion like it happened 20
years ago:
https://lore.kernel.org/all/OF876C2271.59086B92-ONC1256E5A.00409933-C1256E5A.00427853@de.ibm.com/

Adding extra module dependencies won't help, since it just moves the
potential races. However what could easily solve this problem is to
make CONFIG_IUCV a boolean config option instead of tristate. If it
would be compiled in, the release function cannot go away.

We have already "def_tristate y if S390" for IUCV, so it looks like
this wouldn't change anything in real life. In addition with something
like your proposed change, we should be fine.

Plus we need to fix the potential bug you introduced with commit
42af6bcbc351 ("tty: hvc-iucv: fix function pointer casts"). But at
least this is also iucv_bus related.

Alexandra, Thorsten, any objections if CONFIG_IUCV would be changed so
it can only be compiled in or out, but not as a module anymore?
