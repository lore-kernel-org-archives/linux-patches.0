Received: from mx07-007fc201.pphosted.com (mx07-007fc201.pphosted.com [185.132.181.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795782F28EC;
	Tue, 11 Nov 2025 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.181.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762857113; cv=none; b=BYcBjmeF9j3ySnmXc1U3E2mQ+QPGgqi+h1qUJkv8sd8A24Jw+2p7HI8OgkXfwHH4w89KTamNPfecfx1XN/ouw2yPwTBmFxFGb+ZUogzuRhYR0pWFvo9DJFYsn5xXVKE6EXnWuJemc4gIz0pDcnUg9J+I2BOUlEE77ujEpZHoDes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762857113; c=relaxed/simple;
	bh=RlxU5HW3Qoyn81ayMAXF/dGnerSeLGYOT6XPK9V2HY0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EBJ2SF7FbLYGhbWYeiFk2xAK+AhRWpj42lShzRS7VBIL7jzF2ZY71/otnQAl6KxSNjcxaon3KDwre7RqL068M8R9g+xerFcEr4gyeqVhDttdvwKc0f7clS5vMn2U94J3f9FuPWTCI/W4dSOIUR+qVvko6AYkVOjOan8LXAJn2hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cab.de; spf=pass smtp.mailfrom=cab.de; dkim=pass (2048-bit key) header.d=cab.de header.i=@cab.de header.b=WQhcKzQs; arc=none smtp.client-ip=185.132.181.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cab.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cab.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cab.de header.i=@cab.de header.b="WQhcKzQs"
Received: from pps.filterd (m0456228.ppops.net [127.0.0.1])
	by mx07-007fc201.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AB9o0Wg3860489;
	Tue, 11 Nov 2025 11:03:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cab.de; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp-2025; bh=qYmmjPNuKgA8IvUmrnF/phMNwVlW+ziHmWt+M2G0jEc=; b=WQhc
	KzQsPufwzEWxSf9p6TGbUpQi9IOjiQmkgQfzUSj2kccYY/pADzqTva7w65AynHMz
	U4kSRTzNl3/DgGk0n8qFmMUxAAdKPXxjDe9wsr0BZX4c6uNEquotTt4N6K/s6UJQ
	ryI8f2UQReXjzElrBhRAkss2wcEaK+tFSh3YuKNOpNyt7CMpt4UViKdbBk2d/eCp
	F4EV8NAo1oPlf+PPNl7sbSCl7lzX9o2pTDynMI4Niuh/MInBMAl2l91q2jk7W+eO
	gAKuip+fnbnN7DzPGL1hp340cih5hgEtb3V4XqlkdG4uhsKGnRC9RgygidzwDiaz
	H+grsEeHRPSaerkdiA==
Received: from adranos.cab.de (adranos.cab.de [46.232.229.107])
	by mx07-007fc201.pphosted.com (PPS) with ESMTPS id 4aak8rrw4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 11:03:00 +0100 (CET)
Received: from Adranos.cab.de (10.10.1.54) by Adranos.cab.de (10.10.1.54) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.29; Tue, 11 Nov
 2025 11:03:17 +0100
Received: from Adranos.cab.de ([fe80::9298:8fc8:395c:3859]) by Adranos.cab.de
 ([fe80::9298:8fc8:395c:3859%7]) with mapi id 15.02.2562.029; Tue, 11 Nov 2025
 11:03:17 +0100
From: Markus Heidelberg <M.Heidelberg@cab.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Alexander Sverdlin
	<alexander.sverdlin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 468/849] eeprom: at25: support Cypress FRAMs without
 device ID
Thread-Topic: [PATCH 6.17 468/849] eeprom: at25: support Cypress FRAMs without
 device ID
Thread-Index: AQHcUqnnjrmIECdJjEuhylw2/U+/brTtLqCA
Date: Tue, 11 Nov 2025 10:03:17 +0000
Message-ID: <aRMJ07J1E0C-gjC7@KAN23-025>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004547.745840653@linuxfoundation.org>
In-Reply-To: <20251111004547.745840653@linuxfoundation.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16833BE88A2967419FA2C48FD608AB8F@cab.de>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Authority-Analysis: v=2.4 cv=aOD9aL9m c=1 sm=1 tr=0 ts=691309d4 cx=c_pps
 a=LmW7qmVeM6tFdl5svFU9Cg==:117 a=LmW7qmVeM6tFdl5svFU9Cg==:17
 a=xqWC_Br6kY4A:10 a=kldc_9v1VKEA:10 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=AubUXNDC3Xs14RFRTWkA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: PtSk5XP2-aAUQ4j3W-Lb1DLAc7OFI5aM
X-Proofpoint-ORIG-GUID: PtSk5XP2-aAUQ4j3W-Lb1DLAc7OFI5aM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDA3OSBTYWx0ZWRfX1zqBVkU41Frh
 EANwTla5lw12dgH0Yzl7+RZaYcOKAX+WrBcWKlz7x0dKR0PzhqfI3vnULh1Rz4L8TkUYggoy4nU
 2Pe55ztV3RNFFaX4QrFenhFMMs7pokefzt7jD8pr09hpyQdPVMGMSVzU2BVtPlxN1GcWxcj2XbH
 XXykN1ZhaCoKOxaotxb3uc+kYNsue/VgDe5thC6OpkJR4JpTMB7G/9SSv166nuKoKfZYkp8jY5j
 UPYHQseiPtmG65iDL/yddO4CFO/1xKuGLAxBrtaLSRuGeIGVqb/xlT0zW/9b7v3jb7DG2oJTA/k
 84+bItfqxLmkGGUrFZOG1oKspQpOavoGCVfamKUht8PBtRskh82C/UrKZ9LQEteo/4pCUTl6LUt
 xCJXLtVW4QyJPVXogDCsO1mZm/vCvw==

On Tue, Nov 11, 2025 at 09:40:38AM +0900, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Markus Heidelberg <m.heidelberg@cab.de>
>=20
> [ Upstream commit 1b434ed000cd474f074e62e8ab876f87449bb4ac ]

No objections, but the corresponding bindings patch should be included
as well then,
see upstream commit 534c702c3c234665ca2fe426a9fbb12281e55d55
("dt-bindings: eeprom: at25: use "size" for FRAMs without device ID").

How to handle the third and last patch of the same series?
See upstream commit dfb962e214788aa5f6dfe9f2bd4a482294533e3e
("eeprom: at25: make FRAM device ID error message more precise").=
