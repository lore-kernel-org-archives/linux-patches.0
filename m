Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82E518E
	for <patches@lists.linux.dev>; Wed, 15 May 2024 00:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715731579; cv=none; b=GbvIx7fxKR5CGLxX1msrtCnTovzWBsXdk2ErpUNIkWihc/7MTwMY6+86sTKJrHOBVFnYBg1+n+38QejxQ6jEwSJ2v95g0M/bNcjYFM1+W/ncmk9zrihArsJ+tm0dHuMSEdj/n4Fe8a0A6fhKaH1zIh+SHYt5SMZMGYujJB3BoYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715731579; c=relaxed/simple;
	bh=V6CTpVgYXrlq/4ejWbGGBKIUn4vs+g7U6kisWyra9sc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MnhxbTrEVCkDdp0V2MLTl8kSjd0Sn2ZRxF1cUBZpvgQH4vkQVNwG2iUyhea5W/KhuRijfu+3mhC3hIxkG4ziK6TnsG6bOMg3nG9ojpftpqr4f/AeDnQWFgsx71ukEEVE55nEk78LooWeUcPCoNtqJsCnyFOgRpYoW8ejsf9V4Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lrEgG9ir; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lrEgG9ir"
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44F066HF031304;
	Wed, 15 May 2024 00:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=aVx3hmhcBtdUIGMwUj1UALl4sV/Fm3fZMc01j6MWcEo=;
 b=lrEgG9irqWNdcuzIZzFtMAqktdenBHvG6eOioK1Ls3BBAhsj23wSWd0mLseGxDMw0HFi
 MdQhDiGVE5hPW7pjSApFRlUKLn8TjX5gE6qvCTqo2R6EwW+cgv6+OmaPo6eDR5vJd3lI
 OD3eJ3g6KUOHLkV0dSZvFYQiRTsJguHlgQBjC3yM8ele2rqtJ5fXAutG9KcvsEWRHgNc
 o8k2SI5zv+26QaEm+Ym15LNymUgK4qFkXCYozs8yW78tuBgC902wyPJH9u9TH9xcj67B
 42eFxfHD5S85WZCNPGPg1fnU0ujHaPgL83Q0jfLKRYCE0X60oCUABlb5mfOw7EMyaLuz 0Q== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y4h7c83xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 00:06:05 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44EMHSrQ006200;
	Wed, 15 May 2024 00:01:40 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y2mgmg9sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 00:01:39 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44F01ag755837144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 00:01:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EE7F2005A;
	Wed, 15 May 2024 00:01:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9703E20043;
	Wed, 15 May 2024 00:01:35 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 May 2024 00:01:35 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.150.21.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 57DAA60426;
	Wed, 15 May 2024 10:01:26 +1000 (AEST)
Message-ID: <9d093600382fb412381827365a5a342d632d1269.camel@linux.ibm.com>
Subject: Re: [PATCH 6.1 088/236] powerpc/pseries: Implement signed update
 for PLPKS objects
From: Andrew Donnellan <ajd@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Nayna Jain <nayna@linux.ibm.com>,
        Russell
 Currey <ruscur@russell.cc>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Michael
 Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Date: Wed, 15 May 2024 10:01:06 +1000
In-Reply-To: <20240514101023.710898376@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
	 <20240514101023.710898376@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Df7gaqDmJjGybBExg4QYx_ACJzAG4_pm
X-Proofpoint-ORIG-GUID: Df7gaqDmJjGybBExg4QYx_ACJzAG4_pm
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_14,2024-05-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=581
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405140174

On Tue, 2024-05-14 at 12:17 +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.=C2=A0 If anyone has any objections, please let me
> know.
>=20
> ------------------
>=20
> From: Nayna Jain <nayna@linux.ibm.com>
>=20
> [ Upstream commit 899d9b8fee66da820eadc60b2a70090eb83db761 ]
>=20
> The Platform Keystore provides a signed update interface which can be
> used
> to create, replace or append to certain variables in the PKS in a
> secure
> fashion, with the hypervisor requiring that the update be signed
> using the
> Platform Key.
>=20
> Implement an interface to the H_PKS_SIGNED_UPDATE hcall in the plpks
> driver to allow signed updates to PKS objects.
>=20
> (The plpks driver doesn't need to do any cryptography or otherwise
> handle
> the actual signed variable contents - that will be handled by
> userspace
> tooling.)
>=20
> Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
> [ajd: split patch, add timeout handling and misc cleanups]
> Co-developed-by: Andrew Donnellan <ajd@linux.ibm.com>
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link:
> https://lore.kernel.org/r/20230210080401.345462-18-ajd@linux.ibm.com
> Stable-dep-of: 784354349d2c ("powerpc/pseries: make max polling
> consistent for longer H_CALLs")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is a new feature and I don't think it should be backported.
784354349d2c can be backported by dropping the
plpks_signed_update_var() hunk.

--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited
