Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316AD8F6B;
	Tue,  7 May 2024 12:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715085164; cv=none; b=WUj7rAXFR252tnOhimY+xfVIca/xj17uWwcyrYy+fzgBJFUalwzvO5v40H3ioiCt2tdv4YOqE1pf/enbNqYTZU6BvsKnlTqE58NZd/9WMeF2vyULXPCNhafCGLAkpwPbEfG0G3l1mq44NqcVGlrM7CFM+6KDB86Xu+OLF/Ynn5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715085164; c=relaxed/simple;
	bh=/gUkLjOR4jSCzfgQ8uwQGC9Tyk0qbgfnT/0lr9ZVJOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpWRtjVwtFfBFXCf/LNIqv+1q3ZsbgZaZiY6M7YSNTAEHjdUttXXSRlM5fg5X1XA4RUBfcqHDm5G6eYVcRHodiDqHGNISeXEqEuKEU0965joJjJ5IissKiHTcuT2OiD+Op6pYroLBnXowmOS3SfgvQfiknlxe/ag8LxSwJr144I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VdkNTI4T; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VdkNTI4T"
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447C1UU9015313;
	Tue, 7 May 2024 12:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=VsUJTSdpnWOM0cDbhrM/hZOQ5xrPm9c9WsS553P/z/w=;
 b=VdkNTI4TvNiS/ClQQJlFKwqrM0Cser+ehQ5uLfyBzhB2/c0vQHwJtacd2vLRCKnav+bH
 nnLTsgNt06ySpcwn0AmlqHpm4iWV87OM3NovoDZphhFbIUT6fAGUzS30FemEVKYE8GaJ
 bRGdIqu19dHaH31diGU5+1rK4FYRMh5XA+F2lELm+V0sZcWPWG0mY4p+OgfKIlQNPFaQ
 wZAqxpkb2FTUsvGSlnRpGbYJ7aAVXFnSRcLEtm5x2kL00qkigYQKQnx6cVt1YU/dXZYD
 TchUzAOW2JemvxtVrzH09/loP9a+eD8hMNTFhERWros9j8dBEkKo67fZTrGrC1Csk0Xu Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyknd03f6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:32:30 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447CWTEw004456;
	Tue, 7 May 2024 12:32:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyknd03f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:32:29 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447ANOgQ022508;
	Tue, 7 May 2024 12:32:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xx1jkwre3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:32:28 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447CWNTs54985020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 12:32:25 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 410352004B;
	Tue,  7 May 2024 12:32:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 502632004D;
	Tue,  7 May 2024 12:32:22 +0000 (GMT)
Received: from osiris (unknown [9.171.44.40])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  7 May 2024 12:32:22 +0000 (GMT)
Date: Tue, 7 May 2024 14:32:20 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Huth <thuth@redhat.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, netdev@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH 0/6] s390: Unify IUCV device allocation
Message-ID: <20240507123220.7301-A-hca@linux.ibm.com>
References: <20240506194454.1160315-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506194454.1160315-1-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WKUqx34HX5S2SSp48t5luArWznjCnPse
X-Proofpoint-GUID: 31WKNj7By9EH0_0BmBk-Q_I_6TUFYrCo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_06,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=459 mlxscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070086

On Mon, May 06, 2024 at 09:44:48PM +0200, Heiko Carstens wrote:
> Unify IUCV device allocation as suggested by Arnd Bergmann in order
> to get rid of code duplication in various device drivers.
> 
> This also removes various warnings caused by
> -Wcast-function-type-strict as reported by Nathan Lynch.
                                             ^^^^^^^^^^^^

Ahem :)

This should have been Nathan Chancellor, of course. Sorry for this!
