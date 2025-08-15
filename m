Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C187710E3;
	Fri, 15 Aug 2025 05:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755235001; cv=fail; b=UYGtwc1Qe6twFnwehZrm2Z7WeKfXdlEwj3NSz9KghXM3XMxSjI7AhHZK/9bsSNWEFMr3NRj6xCFPisB7iDIfOiAM0xeyGKZbZdHFwAJZQCAdDlnynXR+6UpKvAkpTrX0QVC3O+idGkXftR1YhkGySbhgxEsJYYKWLq0blatJ1J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755235001; c=relaxed/simple;
	bh=xE+SOfL1+Qxcz6zhIbJYScFzm4phG4K1KAaXJxgOBqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FPAXdRpDkmE3D5J4eKd6Hz1/05UsNLssArzt3YQRkpLyXMMAgBvPeC4059cku3uqP3ck7IYT5ovrc+OZ7MKZMYA39fdoZHe8VSiEHmpleDmMkOguR9ZHVTlptf+Y99Lt1WueQIySiq/SfjjS+Yqa8iL9YvwCVzFY7Lj9TvQwya8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ILhtww6H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fDpQxDQf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ILhtww6H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fDpQxDQf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EHfu1R018469;
	Fri, 15 Aug 2025 05:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ghq32/IrN9b6UsAd/k
	ATaMR1ubrAGjGC35YqYyX61Fk=; b=ILhtww6HtussdvlIjZF/sQ4u6J6frOiy1T
	JBPGTebVD3MxVLdvJWEvukRyRVPWOuTePBGldjMXDwqCCUJFd8rHFYHkb6sME5Ei
	hLQw7ewNJNOlzpsmKX90/jM6PD5pO6yKPjJTMPWyW5T20jj6yQdvWO8VROdNUcqF
	CYW9+C5tMSQHDvchSV5zZRhVli8qqCln9gPiCdpgsq+ok6eQwCe6fnvammSPsuMk
	BxRFxzWIN1fdmYaYuc054+RjmcBWyj8lW0kR/TrKEQLzZn+vVpdZQ889BTICG77j
	BofrC/bf1iOHrJ0DEu/9o2BrzeCOUb8/udN28PGaKcvjMRoxPUIg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48guchbvud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 05:16:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F2M5L2006522;
	Fri, 15 Aug 2025 05:16:30 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011063.outbound.protection.outlook.com [40.93.194.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdev8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 05:16:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gqNnaLTDKLTmEv/MFGry32awZ9IN9y8j5s/JxtP9fHTZoYn0WWLZvMPQY6Q5vVvG0dWZcGcMO0U0PUviAKFJyLzITke+tAk22ccrItBZIzfKL4HeqAjkvX+urJz5HSzlz+U17nC8O1fKoZU329VumVGkBb1dCey2FpJNGGGuqRqT8mMQht13it+FuVyjDmq8qEHpz7fcFPB/qoVHI1/JSs5VTF288Ovo1BLF5+XRjQJ7HqsAhwuSvBFxnMpgpcb9uPWxLKMQ6KlXr8lyro3ZTlDKHd6giRriMJR+uqxp0lxVVzyPrWoHyC7cwqQxUaJ1qyIqG190ZI4m8YOGQufOpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghq32/IrN9b6UsAd/kATaMR1ubrAGjGC35YqYyX61Fk=;
 b=ptQUcF13ysB6Py0rnf0TL59TFHErLo2CPZmyItmUrB5LsGlq0gzMcESezCSw76Orxe/D4oa6rd0OJ+no2XwrRW8U1E8f9thBd6qQiePPIzDon7dwCsTMYAlw4CemLh2DEuqQ2nYN/C6HM0VFTgaEuqV7zlT0CyXFejUnHxAnFD7oZfAxBOreUZO3IliuHLvDmSxmyNywG0BoP/4Tos3aTBQYI/dDIDzjtm/eIN/VDlWNgT+G2lgcrk3FCQMSUHo38DjiSK5kuX/TELF9z+YSzJ7hngkk2RzEEm553XqKXHjg7s6snM8NQSYDLv64OyyvG/6pgTCvJPcG22m9Huf8mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghq32/IrN9b6UsAd/kATaMR1ubrAGjGC35YqYyX61Fk=;
 b=fDpQxDQfiVJ5Jylmu4l5M59gQbB008nc9cciHUleXGERQkYeJKkTOGfz+Z9i/eqv0mbezoqEzRfGcggAfxDbBlRKdEExFAHJXeFAu/HayjIM1EtPklxKRxrfUT9DtglbT2+ukeBXRyxk5CHuxULb/xO7SjEg9tvDqW5fOHOi9I0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4328.namprd10.prod.outlook.com (2603:10b6:610:7e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 15 Aug
 2025 05:16:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 05:16:27 +0000
Date: Fri, 15 Aug 2025 06:16:25 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        linux-mm@kvack.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] mm/rmap: Always inline __folio_rmap_sanity_checks()
Message-ID: <9733f669-faab-4c4d-a663-ce0b877ee11a@lucifer.local>
References: <20250814-rmap-fix-build_bug-conversion-v1-1-fb7b10a0b362@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814-rmap-fix-build_bug-conversion-v1-1-fb7b10a0b362@kernel.org>
X-ClientProxiedBy: MM0P280CA0010.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4328:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4af88f-0b46-4c2e-e5d2-08dddbbae31c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u+3UcKgmQJK3Srto6oUpkNEzafZfnumh1pTNMlveLHGFmZddEV0WlY1scRIo?=
 =?us-ascii?Q?dK594PGaReUIAj4RO8AJ3T0BfAK9AmyKGJSzsL5/58+ql3vEhEM6qdokHVgK?=
 =?us-ascii?Q?xhiEVzlIPdgRL7I1GPJh10EF787YimJ1wcw3eJCmf1BKxz6xUO8LcVDN7x5N?=
 =?us-ascii?Q?QnpnhBCwHT4VySoR75zHzto0zOxXOBp42dqEJdpfHnJfYAnW2jkf7I95dswl?=
 =?us-ascii?Q?/rismyUqkmdlpEw777xKUn8LyoBLbaUfKiyFbB8kN7nijBHS4EI3ReFD+6o5?=
 =?us-ascii?Q?YVl3Xjtjxv1Iu8Jk9JAZibDtDhXN0OoigBKeKJxUTz16Z5AFdo4dhkxQDSNu?=
 =?us-ascii?Q?s0k2RK4aYVacRnJkZFjkQvf1ASGd8Ok6PQP0qq+I3AcPVkQlxzoTkMyGRaPg?=
 =?us-ascii?Q?64XfyapUrSejppfA1Idj8RyfGQ7aDo9bfap8QD87zm/gd5U3oC6sC38kW3h0?=
 =?us-ascii?Q?Xpk5v9yFkR+mn/4P7hOWYxF3IbQp+RaAxEKa1g42LV2wzdO9fuPSZQ/bl/sR?=
 =?us-ascii?Q?yZfbIQ+deqWbI/WKKXsw1EXRtDNOaa5M0yiu6kGFH7N5sBFtmIjlziIn3ZI3?=
 =?us-ascii?Q?UHJf9I5rkp+2biEh1s1zVsemGvJ4u5SMWVsnMNQCpYaLqE4Ft0tvhb3KTiXQ?=
 =?us-ascii?Q?tnmHwMlIPmRd4vCf1CSdsjloTRj65aAWEcuxPVvT2Fw5aCEGGsN0B7TX2FdF?=
 =?us-ascii?Q?4UZQkwKA5aNMrV9MYCaTAgs4fdFGsdDUTzSFJdYYhK6hIwxdzJcou3GRS29e?=
 =?us-ascii?Q?auakC74SnxMEsFGwRzRADcJdYUng83ioytFqAAauNmGChTgTw0CuLTXZCKp3?=
 =?us-ascii?Q?vHO5m7Cj3/2KpQOz6a5Gv1woVYsdvnj1lE+0TUmrAU4+22Q9ehygYt7WIHCB?=
 =?us-ascii?Q?DSG+ccdYX49E9a14IDionolBur2bdvNsasA9H7oY+ql2nJaBCL67u+JV93Q9?=
 =?us-ascii?Q?ON5HJdahE0zRgyW6wdCM9uOMkXqWMLdVyZW03Goxdwu11KOGWnoJYnN8Ru6q?=
 =?us-ascii?Q?tdGO0X4sfuHQKLRupkZsunO7n85zH8H9m7V9vDyLaQMxA6oIqb7cG26f7nlO?=
 =?us-ascii?Q?O1UzD9aBepIvxq/Y37oEwMOd69v4/BPAj6lDHlOHzBnlKpFzMIihbxfa7gno?=
 =?us-ascii?Q?LaZTVkR96Ks+KMv3ZZ5hC0Oa5XbQ4VLsrFLkcNf26XR9Jzef/pGCslAcpR8W?=
 =?us-ascii?Q?MhqYIRnAGYSMpvRk/HNccVY9IsDS+jdDi/V1tUhXdDQCsOlEqjSVnvueth7A?=
 =?us-ascii?Q?xdPhYca6d0+axQZztKaUcXYWpBGfNgfSohZFXeTN+efiDJUpuDHAwAlv+JGZ?=
 =?us-ascii?Q?yHACqkDMHX3VYUGkskYevpZ1oRfShwNR1+aPSxtGoDpRT3tWFin0ePTOevbm?=
 =?us-ascii?Q?jraj7UTK38+jgu2fKguyXfnYG4iOnJhpye9HE3nUZyzg/CdDfcbRlSACa1Pc?=
 =?us-ascii?Q?irL+tS+5ZLE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ayQsuC+HYpnf3OqHYuGvA5wtJ7V6iaxBgJMFfHvakOc9pP2LRtssK4gF5+1z?=
 =?us-ascii?Q?r2tdaIib1Xauf3PDNZYMZwN7dFoTOZStq/TGZrUVsW/wiTTAp/b8mfEdsElV?=
 =?us-ascii?Q?NP7j23YvptpJCPbGwWoT7d3x6OcLUlaFCcv58JmgQsmiFdW70fZzQy9QusI1?=
 =?us-ascii?Q?LHYglo/gKJ/ApEN5y3Gj5or2m0uTNWlLAaVUbh69MhMj79RLomCmpCCxWI/B?=
 =?us-ascii?Q?MRMD+oC2dtC9AA4jwL7RPhXqV4M97wK2Il4jhADPpicwAsHL+cEoY3ykmsj5?=
 =?us-ascii?Q?jTQbY2oQ/VhHgUccRsk0fLGe8Wrq0mrs81Yr1XCZW/+gez8GCBIDPaEd4QOA?=
 =?us-ascii?Q?IuoTJlJyGDJHVIn+CZbePu+fsPei04QXAP3v0iBg2FgVksf/PVNl0Yhp3Oaz?=
 =?us-ascii?Q?iAm/6q6rrriZ39o01l2ELNzh1ayPkXq0U3wwbBmRYW8Y4gL9YOBradOfGcJ3?=
 =?us-ascii?Q?tDgDhSjAOw9vZHnBKpKv9XLBavZMiBfD+0eTPF6QZSE2BZ2baxZxNQ4YFZsx?=
 =?us-ascii?Q?8yfjpErsz6Ic7mvq11DGu5hCfgx3Kf5Jus6GXK6xf0QypEyM6Ibt7kpFhnnP?=
 =?us-ascii?Q?LB3qNv8F9PtNjl+EA7VLzEjS7i54YhJZdijwztZ7TN4xoCDKbqfKXNJ3hVCP?=
 =?us-ascii?Q?M/5KFRycb0jbCTWNh0wk7+xY6tbMRe6q6dn+im4JXEtBp8AwKIWA4oCBeK5d?=
 =?us-ascii?Q?YulEL4yDYIUiE7lLoMOO4/FrOl557qhD+wjj+bnwvYu4vrXvI2Bqnh9TZGx3?=
 =?us-ascii?Q?lRlJGzDj9tfzR3xTS+JiBZgUinRu39j1m2hlgmGpjRxcP9kkiIC5sOoaFRie?=
 =?us-ascii?Q?1ngCOwJ7F1xrhdTYcVKDUI/k+a9cr51rl+H18yTvUGE6pZuqgPRKlq/GsVrz?=
 =?us-ascii?Q?zC8YjvlgU+ESAbU5BFGBr7zcs9qJPS1HGrerCGkgri+IDHaLyn0cMhXFIHzZ?=
 =?us-ascii?Q?3qTeGy6fHM09ymCVBIiW0f5U112T4rnpWSX+X+4LC3KGCxX+w1nGMOA7LuLq?=
 =?us-ascii?Q?AOBi/4fyeaRyvRZinVeUwY+MEuZS5d4YFjx6f34jkx2yC+27NYsIzKVhX7k8?=
 =?us-ascii?Q?uoau7rzPsHjUanz6/PhE8yvauRCkd3Qcu14brdYpzySg/gtk18DHFwn86ccS?=
 =?us-ascii?Q?CscrEsRCm77z9joX1g5i6bhFto4IqMaK9F0Bi8MW3O12EsGGv/rh8oBhH2rH?=
 =?us-ascii?Q?pGfChnJqahlTCL0lI6rQrb6OsyoSvb7ja8LmT3J1SZop7xjYMz4OiJs+R/JJ?=
 =?us-ascii?Q?3LGsrppkHh/TIw2xgIINiev6DCyVPLC3uIgtQL613Q+doNDK8yhtitx8VJ8K?=
 =?us-ascii?Q?fIZlxX8jLjJ3WUMEWRoZNv/mlWK+PIsUNsKJfhkZZ6RkUuhUnFhwt8H8XKUZ?=
 =?us-ascii?Q?28K/32ceE0p69wtiz5y1gc/4AGSxEAG3MAJDec20apJ7WJ4uCa5GPAfzaQrU?=
 =?us-ascii?Q?Spn0Y905hMPF+4L1i7w4AgYS4EHKlJpxXVtdYQkbP5M3GUminjsQafIBEvsb?=
 =?us-ascii?Q?VMi6dCiRroyE3cNBL79lRmehd71fry46cAa229Nk3XYKUqvWepJUC8eiTa0L?=
 =?us-ascii?Q?9tQap9HfC3ycx/FC+wVXfKQZvKHyuzkohtGZ/QWebzYojqX0SZXZtE9aWDpo?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TcBX0gUadkJ5PQGeq435xAaGjMgn7VBwqB5YFAtmaL6POJeKbghFPCRVDhBkFhYBkVXzIyYPmpfFmDnLQVl7vFCWt+MK2FEG6o55NjGDeYBZgk9ZPVlPF1hqx2Ni/v9wVlTtI7f7mx9Y4pO0OCvgJfyBb2y5OOLuIzt730Q/1YbO7KPJ3Zw6+11QLZ4n3qYzYI2QRpClhbPW0X7E0kUw8LlhRfOD22vvUGybfZFzMoTKZ/jB/liLG7k36P/8YrAf6EhgZXVn7UIcSq35tfeKaDUoPreTtMWt930Pai31kQbGVhuDK8ADDn5I8xBBf5EPEDxplpjB4+CiHYBYLxkd7THi+3whnoJBpRnRrLs62YSKsRa4McBqFKAwj2bRqjPvTCLz3DlXgybDCQ4KM5mgiL9CFgAPp3zEaPW3Z3Y5gTd6siID7PI7Fe6YiVUSdmPOIWr+Cp6TroewR0GfEc/ta5f3QyeUXgY9EWX1yDYFbcNIPsuPRgQ9H2iz8NmHMlnyOZOPDbLFKTIycFplf5fYFf90nN/P1vHkZLELXKHGmtSJkzE6Hfd+p669qCvzOj4o8kCAyV2UB3WrK4RZ98pvgjPXXaLYvUsR7EoWA6lpZkE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4af88f-0b46-4c2e-e5d2-08dddbbae31c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 05:16:27.7956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5HK6erPXTyAqRimlOvimjzjd7jswNx6IAzWRpvltz0/IrBZoeiapL5ItAcokY2KLQmMomXnsZP4C0zvNe/q8SzLK5uLGF5gUmO2j3Z8EP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4328
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150039
X-Authority-Analysis: v=2.4 cv=Eo/SrTcA c=1 sm=1 tr=0 ts=689ec2af b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=ZxsavcM7DotT0U7DHngA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: 8L1ftQu8VtZwJmksLXzmBfUThoYit8fT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDAzOSBTYWx0ZWRfX+2sB4L75cIpz
 qBhVudPNcOal/9fknr/vW3wAvUwBvulC+RNgvt7tNqrnbRS5Bt4olunRuciQ1K3MY5PHhaWol/O
 Eyv0SU5XoZLcrIN/i+uBtu2OzyFDUsc6Sbm/GyD29IzZ85f3ZHsLzqrZjSRhS0OhOJmB0HV1F7h
 QDv36M+LI4ldOSjuqNsY0leLyxMiC8ISYgLkIVtNZFAApVZu7caTkntliy5YpCVdY5Z1zSflelE
 lpBIRcgEqnFTV8fCFWD4IxGwmjDV6gxyakNCY+nqE6KIPgSgcvsOpzKIesET794HpnhYl8UqBN6
 tLpnFsO2hrU3+sK6q9b3HyX+fzCmDowcWIqxhNYzSHevHwmzCqZZpivOsJvesK55QMuQC7lL7eY
 96aPSIe7cdYB9KOmm6q2WemHZJZDVhyuoboh8GQ/cr+ejwAp8hM+kxrBKcO+UellrnoFoslh
X-Proofpoint-GUID: 8L1ftQu8VtZwJmksLXzmBfUThoYit8fT

On Thu, Aug 14, 2025 at 01:05:22PM -0700, Nathan Chancellor wrote:
> Commit 5e901e249ad1 ("mm/rmap: convert "enum rmap_level" to "enum
> pgtable_level"") changed VM_WARN_ON_ONCE, a run time warning, into
> BUILD_BUG, a compile time error. After this adjustment, certain builds
> with older versions of clang (such as arm64 allmodconfig) started
> failing to build with:
>
>   In file included from mm/rmap.c:63:
>   In file included from include/linux/ksm.h:14:
>   include/linux/rmap.h:440:3: error: call to __compiletime_assert_890 declared with 'error' attribute: BUILD_BUG failed
>                   BUILD_BUG();
>                   ^
>   ...
>   <scratch space>:21:1: note: expanded from here
>   __compiletime_assert_890
>   ^
>
> While __folio_rmap_sanity_checks() is marked 'inline', the compiler may
> not always honor it, such as when sanitizers or other instrumentation is
> enabled.  If __folio_rmap_sanity_checks() is not inlined, there is no
> way the compiler can eliminate the default cause.
>
> Mark __folio_rmap_sanity_checks() as __always_inline to allow the
> BUILD_BUG() to work consistently, which clears up the error.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

David needs to have a look, but afaict this seems reasonable,
__folio_rmap-sanity_check() is only ever doing stuff if CONFIG_DEBUG_VM is
set, and in that situation we don't even care if this would somehow be
inefficient, but in any case modern compilers would inline it anyway.

So LGTM and:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> I assume this will be squashed into
> mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch so no fixes
> tag.
> ---
>  include/linux/rmap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 9d40d127bdb7..e8aff6d2deda 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -394,7 +394,7 @@ typedef int __bitwise rmap_t;
>  /* The anonymous (sub)page is exclusive to a single process. */
>  #define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
>
> -static inline void __folio_rmap_sanity_checks(const struct folio *folio,
> +static __always_inline void __folio_rmap_sanity_checks(const struct folio *folio,
>  		const struct page *page, int nr_pages, enum pgtable_level level)
>  {
>  	/* hugetlb folios are handled separately. */
>
> ---
> base-commit: 6bee0462de1f9f4fa9400f153d3b0792c20d7111
> change-id: 20250814-rmap-fix-build_bug-conversion-90441c036f42
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
