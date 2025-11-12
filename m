Received: from mx08-007fc201.pphosted.com (mx08-007fc201.pphosted.com [91.207.212.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2663330F95D;
	Wed, 12 Nov 2025 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762950537; cv=none; b=RtjY8wxvdC4L7osD8Xpl664Qxxe+UUgRT0mJqW/ZR41TB9r0wB3ftVcFryAKSxAZu4dLfTbL8LVcB4xR0qcpCRpTD29YdFR7D7K6to32hRtYh3CvjOMKNhejS7rggPlGQG29ife8Ctw+cKOWFxUIB9kTG3jkyNx/hR1WZsUamWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762950537; c=relaxed/simple;
	bh=Edw+6APYDMnYhFeVaKZyqEGcFF4ICrQWAcwS5GRbQJk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QfLhpCCYXCAvpvIZ4gJM2n2FiatXtiq6I5m5F8TE802gCrZiCDJqNo9XIm2v5TbuXwiYwoEXXBd6fmcc2c5YKZCNMZyToBi8rG2HOFrKhdV0BotloJCuWs21H1edrnMvhrrf7MzyBBJY6VWZZbhlY25fsWKUAmJg4unrO2v7D0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cab.de; spf=pass smtp.mailfrom=cab.de; dkim=pass (2048-bit key) header.d=cab.de header.i=@cab.de header.b=2Y/ICDBa; arc=none smtp.client-ip=91.207.212.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cab.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cab.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cab.de header.i=@cab.de header.b="2Y/ICDBa"
Received: from pps.filterd (m0456229.ppops.net [127.0.0.1])
	by mx08-007fc201.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ACCCKZC2637073;
	Wed, 12 Nov 2025 13:20:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cab.de; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp-2025; bh=u/D4zYUlOxmEix5ZdHg9vhFSyiPZvF8mKWB0sb38owo=; b=2Y/I
	CDBaDRfMQb1qo3FEMkJgPvPddzvCIfSSgJWymTjPP3ztl/Cz65bRqXazl1LFppm8
	x02r37OB5GmxHJ9NtUGsAxKMSTtkhQJVu1lGbvfkNzuVZKDJs7Jy/a0H6HrgIL/i
	UfeDKb+tBPlzZxnNFFXutcc1zety+3N3LcqYF4+/i9ap7d+6IQiu9vKPmAaMTnDq
	XmwE5FF1VhjvPC6pMRicdt23uTVdGxPwmsqWdnOcUuuoildCYHH5HYWa6bb0zeBp
	iUkIFvnS4IBBLBYr6BD4/P2HNknHZHz1fUYObKsyuHR5yV3pO/I1J7LLjL5fAkTF
	NY5snstwpQQ0DzCSCw==
Received: from adranos.cab.de (adranos.cab.de [46.232.229.107])
	by mx08-007fc201.pphosted.com (PPS) with ESMTPS id 4aajunhatb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 13:20:41 +0100 (CET)
Received: from Adranos.cab.de (10.10.1.54) by Adranos.cab.de (10.10.1.54) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.29; Wed, 12 Nov
 2025 13:20:59 +0100
Received: from Adranos.cab.de ([fe80::9298:8fc8:395c:3859]) by Adranos.cab.de
 ([fe80::9298:8fc8:395c:3859%7]) with mapi id 15.02.2562.029; Wed, 12 Nov 2025
 13:20:59 +0100
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
Thread-Index: AQHcUqnnjrmIECdJjEuhylw2/U+/brTtLqCAgAGiF4CAABa1AA==
Date: Wed, 12 Nov 2025 12:20:59 +0000
Message-ID: <aRR7mLDt3osRI658@KAN23-025>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004547.745840653@linuxfoundation.org> <aRMJ07J1E0C-gjC7@KAN23-025>
 <2025111252-unmindful-blemish-a2d8@gregkh>
In-Reply-To: <2025111252-unmindful-blemish-a2d8@gregkh>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B07A6879BFA47E42BC2DB57119493394@cab.de>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-GUID: 2fKkyIHerXh6QhtfLpm7SYvwlo7B8BOZ
X-Proofpoint-ORIG-GUID: 2fKkyIHerXh6QhtfLpm7SYvwlo7B8BOZ
X-Authority-Analysis: v=2.4 cv=Zu7g6t7G c=1 sm=1 tr=0 ts=69147b9a cx=c_pps
 a=LmW7qmVeM6tFdl5svFU9Cg==:117 a=LmW7qmVeM6tFdl5svFU9Cg==:17
 a=xqWC_Br6kY4A:10 a=kldc_9v1VKEA:10 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Zu3QUwzr2lBt1hkLNYYA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDA5OSBTYWx0ZWRfX5wjuUOShVwCr
 wbnaUPyROyTp+XQutvjqX9vFi/tSZNLbSOajuTPuYJd9VXu/stMowYZ4Q9EafRJDDVMVI3p8hKK
 xRr709+uDxar/y3mc9x0E2A6fhD1ZR4/6ar85L0VZJ1bqOHz6c7EnfcbZcLhzvmeJTZIrWsw/rk
 SfRAjAPjauugCCDA3ubairxGd02pW5QJiuWtkkkv++8ZalcrknPrx56UAd6Vptj3S250lFS7DIw
 j8ZK5HMcZiftYFtG2ZA7YVkCan0PStAnyJQEG5jS8h1E/rXhKiwiKiMhrHHdwgTk8aOgMMQTHyu
 iW3i3FNppuz1r8KLjc6q2+r3qj8mgcFmz7JhqRMh2pIXCZ8kFe+GDa4nJ/vslKX8K4lf69UTDcn
 SzU4h+3X50sPrNWpowTMYKaSaffeYQ==

On Wed, Nov 12, 2025 at 05:59:23AM -0500, Greg Kroah-Hartman wrote:
> On Tue, Nov 11, 2025 at 10:03:17AM +0000, Markus Heidelberg wrote:
> > On Tue, Nov 11, 2025 at 09:40:38AM +0900, Greg Kroah-Hartman wrote:
> > > 6.17-stable review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> > > ------------------
> > >=20
> > > From: Markus Heidelberg <m.heidelberg@cab.de>
> > >=20
> > > [ Upstream commit 1b434ed000cd474f074e62e8ab876f87449bb4ac ]
> >=20
> > No objections, but the corresponding bindings patch should be included
> > as well then,
> > see upstream commit 534c702c3c234665ca2fe426a9fbb12281e55d55
> > ("dt-bindings: eeprom: at25: use "size" for FRAMs without device ID").
>=20
> Great, now added.
>=20
> > How to handle the third and last patch of the same series?
> > See upstream commit dfb962e214788aa5f6dfe9f2bd4a482294533e3e
> > ("eeprom: at25: make FRAM device ID error message more precise").
>=20
> Not really needed for a kernel tree that will only be alive another
> month or so, right?

Indeed, you are right!
Thanks, Greg.

Markus=
