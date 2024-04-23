Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F6F1CAA2;
	Tue, 23 Apr 2024 07:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713857671; cv=none; b=tnYWNSjoG7IACwdvkFlb2VOc5JT/B8+OFzv9Y3M/EBp1IgDK/UCuQumv9zzCSLh3y5eRKAivFI+SOe6Cdd/xwfBWzMeKU904oCkLrOmqGN4RdK7PorTMoUVLhtZq9HKi1FxCYX/squyNWSr4Es3IJJIFoAae+q+dM/Jl88zm/Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713857671; c=relaxed/simple;
	bh=rsjaTFtx8348euuafPffUlSsi6BwUWE6TeBUbrJ6wCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MDhZyHYQDZc9jlYTcYGK4JIoGHeGV6zOn2JUGwnfdsKwSVaID4oPd/2SBJw0nOZl8YKEWGneqXvMQADAPAo5HRvk6om91bShXkZok3bcOEJ1PxbG5OORJ653LSAztHWJ8EiJoBxnZa3KHjbOtyklZpzOgl3dyQDwSuNCy5k3qus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BG24f1lJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BG24f1lJ"
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43N6YHSc017465;
	Tue, 23 Apr 2024 07:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MA6f4FuIjJi9F9IQBzC8zuD52Y6zja9gJ48dXbUrcEw=;
 b=BG24f1lJ0o18OnQs8wGZxCZaOuY645GTXGGm0YfgpBotc8wSafE4v3E0us4mFhsP08Yp
 j/9owU2mbdov29VWp5FVpdLol8jK1JdrxgRdVwupNiWXa8JbaWW43IlXkZQ2u7CxztYH
 tsmrvMZvSRK8VrDolEoBcsWpNv+wUGHZlfqViczEX0otiddu72gzWjTdxg1np0u24fm+
 zhBCvUvtXT5HrEPQxAyKh/yH2R8fOFPUxd7/+17b7EF95CQFVv/nrmjWe9uQIF0So2C8
 D7osYcIQP1BMbgmwN1pxAXH9HBabvB47ZyQcVHl8JrJ0AIPw9ZxSjVSKeiJS8fQqN9Ly aA== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xp7thg3cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 07:34:20 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43N4kF93015302;
	Tue, 23 Apr 2024 07:34:19 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmshm451m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 07:34:19 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43N7YC7d18940368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Apr 2024 07:34:14 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A2DE2004D;
	Tue, 23 Apr 2024 07:34:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B1F220067;
	Tue, 23 Apr 2024 07:34:12 +0000 (GMT)
Received: from [9.152.224.141] (unknown [9.152.224.141])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Apr 2024 07:34:12 +0000 (GMT)
Message-ID: <3b836dbb-98a1-484a-b88c-4beff45f2685@linux.ibm.com>
Date: Tue, 23 Apr 2024 09:34:12 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
To: Heiko Carstens <hca@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Thorsten Winkler <twinkler@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, gor@linux.ibm.com,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, llvm@lists.linux.dev,
        patches@lists.linux.dev
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
 <798df2d7-b13f-482a-8d4a-106c6492af01@app.fastmail.com>
 <20240419121506.23824-A-hca@linux.ibm.com>
 <1509513f-0423-4834-9e77-b0c2392a4260@app.fastmail.com>
 <20240419141244.23824-B-hca@linux.ibm.com>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20240419141244.23824-B-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: h2w07tsfKsJgwyplVoK3Dm8wnf87Tl2Q
X-Proofpoint-GUID: h2w07tsfKsJgwyplVoK3Dm8wnf87Tl2Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-23_04,2024-04-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=539 clxscore=1011
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404230020



On 19.04.24 16:12, Heiko Carstens wrote:
> On Fri, Apr 19, 2024 at 02:19:14PM +0200, Arnd Bergmann wrote:
>> On Fri, Apr 19, 2024, at 14:15, Heiko Carstens wrote:
>>>
>>> Plus we need to fix the potential bug you introduced with commit
>>> 42af6bcbc351 ("tty: hvc-iucv: fix function pointer casts"). But at
>>> least this is also iucv_bus related.
>>>
>>> Alexandra, Thorsten, any objections if CONFIG_IUCV would be changed so
>>> it can only be compiled in or out, but not as a module anymore?
>>
>> You can also just drop the iucv_exit() function, making the
>> module non-removable when it has an init function but no exit.
> 
> Right, that's better, and also what I did back then for the zfcp
> module for the same reason.
> 

Heiko,
as discussed f2f: 'no module' or 'non-removable module'
both options are fine with me. I would prefer non-removable.
Both are better than calling removed functions.

This also applies to patches 2 and 3 of this series:
drivers/s390/net/smsgiucv_app.c
drivers/s390/net/netiucv.c

Thank you
Alexandra
