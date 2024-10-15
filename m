Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33DD18B488
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 09:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728985628; cv=none; b=lMepeuVZoV+KD46F7BJ7e7mTSnZ3/o3kbEE3KQlYAnyLp1fHac9eNb8lY0KCyrx491ishJKC1FSIdN6RsQc/ULtCkfRtUr+87e7D8VUJsXT77gdfeB2awFmW1XsJAqH5dc3INZmcKWDQzUuBGLP296i0Q4asrUG9xMuC+QEQjik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728985628; c=relaxed/simple;
	bh=5T8ObhgxQkBGUuRQW4PDmqdYfE1QHbUI+kJjWHnuKR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLx43UWPWJY2tKuEHVH24UrViB8bT4JeZ+da9Ol+IJVvHgLP4B2HtpZMIgYq789QXvmn/QQd+oN0LgPb7xKa7eSTMx6b0pY9uEUmA+5nA29fnU5EoEAnW51l0nCohfOWte17S4LlUxV22lCSTgzuDy8NlFXYDMDGb1DCX8doAnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B9X19gLz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B9X19gLz"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7o99r030191;
	Tue, 15 Oct 2024 09:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=k9bFiz
	jRuhZcLwgOZeLnzCyme3HKz9tMoCkYWK3pwUE=; b=B9X19gLzEHrCcTtou3x30s
	SHDv4JlUPWMS36G3BQjonVC1+gsZ45w0p1gsGIRspyCqGPBfmz3EE3dEFmDaSQUK
	xWd83Mml5UrxSasVWmnVuUxEDXy0N8OuCNWXZxopNBrErDymDzbajaKFAVZ42sac
	EdhalzX0Gk3MHrczE5mD2qvnJQ75+UU5u2pRmRjcndFg+0m7D8sjHm6SDakJiUtW
	aBqcEC/mC3baxVnP1g1Eabo18XPmT7cRreTJvBXjMLPotsFvHd8dNhIG58qFGBqD
	3cVKKXLO0+t/wtCGEVD9t640qd4ZM21fQbSZwgwEl6VcFfUNrN7dxWx92nYhkS9A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429mbmrk28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:46:53 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F9kqjT014450;
	Tue, 15 Oct 2024 09:46:52 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429mbmrk24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:46:52 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F81dai006401;
	Tue, 15 Oct 2024 09:46:51 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xk2y7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:46:51 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F9kltQ26739020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 09:46:47 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69C5920043;
	Tue, 15 Oct 2024 09:46:47 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C765A20040;
	Tue, 15 Oct 2024 09:46:46 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 09:46:46 +0000 (GMT)
Date: Tue, 15 Oct 2024 11:46:45 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        allen.lkml@gmail.com, broonie@kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
Message-ID: <20241015094645.7641-F-hca@linux.ibm.com>
References: <20241014141044.974962104@linuxfoundation.org>
 <CA+G9fYsPPmEbjNza_Tjyf+ZweuHcjHboOJfHeVSSVnmEV2gzXw@mail.gmail.com>
 <cdb9391d-88ee-430c-8b3b-06b355f4087f@kernel.org>
 <6dd1f93f-2900-41cc-a369-1ce397e1fb52@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6dd1f93f-2900-41cc-a369-1ce397e1fb52@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pZKsdrJkczM9N3yrhs87owQXtEzgB5QJ
X-Proofpoint-ORIG-GUID: qOIE5GXM8Tu82EJeLc0KwmL18OhgQdXy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=389 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1011
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150063

On Tue, Oct 15, 2024 at 10:51:31AM +0200, Jiri Slaby wrote:
> On 15. 10. 24, 9:18, Jiri Slaby wrote:
> > On 15. 10. 24, 9:05, Naresh Kamboju wrote:
> > > On Mon, 14 Oct 2024 at 19:55, Greg Kroah-Hartman
> > Reverting of this makes it work again:
> > commit 51ab63c4cc8fbcfee58b8342a35006b45afbbd0d
> > Refs: v6.11.3-19-g51ab63c4cc8f
> > Author:     Heiko Carstens <hca@linux.ibm.com>
> > AuthorDate: Wed Sep 4 11:39:27 2024 +0200
> > Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > CommitDate: Mon Oct 14 16:10:09 2024 +0200
> > 
> >      s390/boot: Compile all files with the same march flag
> > 
> >      [ Upstream commit fccb175bc89a0d37e3ff513bb6bf1f73b3a48950 ]
> > 
> > 
> > If the above is to be really used in stable (REASONS?), I believe at
> > least these are missing:
> > ebcc369f1891 s390: Use MARCH_HAS_*_FEATURES defines
> > 697b37371f4a s390: Provide MARCH_HAS_*_FEATURES defines
> 
> And this one:
> db545f538747 s390/boot: Increase minimum architecture to z10

All of this is not supposed to be stable material.
