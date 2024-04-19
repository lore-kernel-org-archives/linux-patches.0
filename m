Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40318063B;
	Fri, 19 Apr 2024 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535980; cv=none; b=GtgW+B2vlDmBwShWwIC2/v1+IxHLns5c94FZkRmmb41uFgNwPUavJu9WTwcxdYuLysjAesd3VQ3TKd6K8tUdeCImMCBnhCLSXQDani6jUBoqM569Jfg5BHbl5auXGZ19idD/4X5TrxJUMmaujkjw/RguXWQDfYrf7GZH7awyRos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535980; c=relaxed/simple;
	bh=W7nz7OkHCmep10jAH1zdX1jJiug2o21YnaZ0mID7HqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liRVJWxD4KiE3G6xPmEubw3wgfDAw4PlB9ZdvqvDx7jCKncfZ1iryHMn+zTdW+Zj9Jov/NEuqg/Ld7byIZoyRQHQM45CpMj7N0TtkH4q09YX9cqfFAvU/PQjRP29XS1KvUHLllNkVPn2HnDjltRwJbt0dbCXu6LUImfE/nnvJQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nY8rVz34; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nY8rVz34"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43JE2fA8019125;
	Fri, 19 Apr 2024 14:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=u9YtZMQy/yMuVHw+gYdBGdrRJW64WCI/XorTOSGTd+I=;
 b=nY8rVz34PbIwW0rxYPqhyi9iZxqdkvC3qXwrp0O5OGTw76KGY39naXkmKroOSrjJ9+Xd
 wjMDt9mT9IegW/sATAIp8Wqqo91pAWqQHPa5hdCUtBRQRDQgSautjCfM0bjXES+z2xxK
 At6ns7WYeOGztFaXDACNPU44QYe4fmJIazrQOVyJLSlbS/tWwLk0LmYrHH2hQhlPfuV5
 HNovFMTqtGHWA0voUOkQJg2+l2p35hBRSCzD03iOGEzMSsAfPH8Vnb2UTajVvR5/1oWo
 xGjpLb/WAbbxc24we1PTXYszBPqIRznu+LRVyNsCHVqY790weEjqwnmHm7C0dOm5AREm jg== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xkt1401a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 14:12:53 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43JCRuK9020837;
	Fri, 19 Apr 2024 14:12:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xkbm9m1ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 14:12:52 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43JECkpP25952790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 14:12:48 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7489120077;
	Fri, 19 Apr 2024 14:12:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2F9F2004E;
	Fri, 19 Apr 2024 14:12:45 +0000 (GMT)
Received: from osiris (unknown [9.171.8.18])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 19 Apr 2024 14:12:45 +0000 (GMT)
Date: Fri, 19 Apr 2024 16:12:44 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, gor@linux.ibm.com,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, llvm@lists.linux.dev,
        patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240419141244.23824-B-hca@linux.ibm.com>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
 <798df2d7-b13f-482a-8d4a-106c6492af01@app.fastmail.com>
 <20240419121506.23824-A-hca@linux.ibm.com>
 <1509513f-0423-4834-9e77-b0c2392a4260@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509513f-0423-4834-9e77-b0c2392a4260@app.fastmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oRqBSk2thqJzykLmaUtobGDXFnArPjuU
X-Proofpoint-GUID: oRqBSk2thqJzykLmaUtobGDXFnArPjuU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-19_09,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxlogscore=352 spamscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404190107

On Fri, Apr 19, 2024 at 02:19:14PM +0200, Arnd Bergmann wrote:
> On Fri, Apr 19, 2024, at 14:15, Heiko Carstens wrote:
> >
> > Plus we need to fix the potential bug you introduced with commit
> > 42af6bcbc351 ("tty: hvc-iucv: fix function pointer casts"). But at
> > least this is also iucv_bus related.
> >
> > Alexandra, Thorsten, any objections if CONFIG_IUCV would be changed so
> > it can only be compiled in or out, but not as a module anymore?
> 
> You can also just drop the iucv_exit() function, making the
> module non-removable when it has an init function but no exit.

Right, that's better, and also what I did back then for the zfcp
module for the same reason.
