Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA2F2E7F27
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 18:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106253; cv=fail; b=kS6G7mi3/PWqvDZOu6Th+tH1P69sfluVQP2ZthaW6oZC7jK9z0q9H3sL+kN4RJde8Qzn0JcHme2UA2cBOwwsEr/y0ofNhA3lhEc5EwwbEZS+F6BRt7d+kLvGsQyOeZWaY+nnLloilHo33C4IikWn/9vLN3RjduH2b4p5pcbj8j0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106253; c=relaxed/simple;
	bh=ErZ8oDWwfW2L8M4BTtD0CxjqT5Xxqp+qdpdQMdseLLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R9Zamoxctpra2c+XUGabHluYUrSRGTNHb+UusDN6TeRhmy6+oTGECUcVi8VQf4ontZm3+TPIRhUV+HVdzqwDyurQVudWYAAz2JBaefjJI2WjHLtXsVyEh9PUhB02n5ejtjwbbjPh7FiueI/nMf3TwX/il8KymolIkWHA8iZGrlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Diqcu/Yr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jlGsYm8J; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Diqcu/Yr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jlGsYm8J"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MDgcbr197959;
	Thu, 22 Jan 2026 18:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VWXC+piGnf61mxYaQw
	Qg19Xj24Hj6oyniUfLGylhhIE=; b=Diqcu/YrBa9rlNBt3UPhd447NnhGFRlbA4
	Mlwpc929IdxqaS2nolzjaBhU5cjnzGKA+TFFMnz5CjuLAaP3078Eu1Qd7/8h+bCM
	D0TpkjYYJ/a3OEKNLuKgYBWQcelAMU/as07PacNuCwsKhZRBAk0eNNi/fR+I15RI
	YGem2nbx/vv+I35fQRssPEhNX5hS3jS0Q2OuhJ2f+w5koSLs94COfHPGpubmw1gp
	eJICAez/U9+eFXhabfjVe3Odin+BcrH44bBVUkj2lrHbzA7t/QKr7SUq5z7B6Eu9
	L91jHva7e+5sh9nwRk+csCJ6AMVDetRkKM9f/SZw5F+ucM98dS/Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yq04s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 18:23:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MH7pbo032141;
	Thu, 22 Jan 2026 18:23:26 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011063.outbound.protection.outlook.com [52.101.62.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vh2cfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 18:23:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IhtHklc1T1E6W4cVMUXB6tlB5eTvtPxi6C8CAJ6PDgNjmpN0qBbs1Nf34JomCi4DjPDA0TnsB/NJMNvMJI1k05Dp7UaaJF5SyypDGrmk4MN4LaS2jzPx/bSZKSqLdX/Ja3/ghKa9L1sXlh/YsoUXh2hh9g1dD1nCS3Xa2Fmbe4zQAwEnq0LIWDaafnS5kGMflNvOjE2ntwo8qgqAL7zWUhLqzk1FLpGkksNVk4r4tgEppTaXR8Fs9Yy2Tt9mVyzHI3K5ft2ugZZLLVrZRuPwdoPfMwGIk+RUUhCqi0OwqgyIKxw8kjFHobOH5sfb+eRSiso+b4m+lp6mV7OGIV8uBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWXC+piGnf61mxYaQwQg19Xj24Hj6oyniUfLGylhhIE=;
 b=g43w7ePnPW++ipNb1wtYbbQJK0MYMgz0QqsVd7K4fqNgf+sWorrWTYy0AheJKemQ03Ruxmp5bFK3Q+TY/ghac8Fnz4QJmSPSoVzrMPJRJGkVrh16g0AYtQJTRIOmkdxTfEEjk0UAj1qGTvHoSQRyyvyWJENQlMdgOicGmV/U8/bfu28MbAv7Bqbv4o4saN2QLbp9tc4UreOPotAVC5S5mB+jeNRMJbnpieZRs5QjuN+B09sAusJRlIa7Q0RojQe9JyuFvKzizNp+qHVuggicDcDMO/XzciFZO8GnrtzqJVBI2qUrnDtiXAnE3UN6fr0MpMo/p/It7qQSOAtiDTPfXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWXC+piGnf61mxYaQwQg19Xj24Hj6oyniUfLGylhhIE=;
 b=jlGsYm8JdLlcQLFBo7zaVLReUVhKjYweSif67yhHxCBpOa3emq0pzNsSCO0Wg8mKqzCMcsDgkw71Bun8iqMRg83QJrSrNU5DQsvoDk7LPl419xuolYb2dcAu+RmXjNn8siAF2krNYuTWfAInRHmaZxSCvpsWcUyTUtM2JdSgzj4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 18:23:23 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 18:23:23 +0000
Date: Thu, 22 Jan 2026 18:23:25 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, achill@achill.org,
        sr@sladewatkins.com, Ryan.Roberts@arm.com
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
Message-ID: <930ac4d6-eb13-49d4-80a0-645c4cf19767@lucifer.local>
References: <20260121181418.537774329@linuxfoundation.org>
 <392ccce0-4042-47ac-abdd-d1ed830ea27d@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <392ccce0-4042-47ac-abdd-d1ed830ea27d@sirena.org.uk>
X-ClientProxiedBy: LO4P265CA0206.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::18) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ0PR10MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: cf394022-4707-4180-3bfe-08de59e353b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cpeVEQj6MEbXGTwH3DlftDTW8XAmklh9YhqiuvhVwUPyhr968HPr7/6ulbfz?=
 =?us-ascii?Q?t1Q4ZSB2sfcBN/hMJhkwCb2JQTSI5AjsvdwhMnTLKYrKaPsSCYEhJcUQyuzP?=
 =?us-ascii?Q?BMRZTJU2dFqmN8zA0Tp4mHWtQb16AKviQ51tuKWy+OfivMQ/7oE1v28Iucnx?=
 =?us-ascii?Q?gqOjr+D/Wm7wKx+tZXtvGj/LqmP/VRYqru5eTUGcAStAAaVVG562d8fFHOUJ?=
 =?us-ascii?Q?qjQs/XSmcNyf5q65CfdBrsfGdiYzBqDCfjacbsOYWRVs9XSWML5bfbglfQli?=
 =?us-ascii?Q?jX6gut08r5L5UqvrE0r2KCD61OhK9ZElaUEaMUU8H5IKzAphwQfcfdFJmwiW?=
 =?us-ascii?Q?sPeAebQa0doY/iryDl2ra96T7P/VxBfUdyGeDlCnCv+wARXUiZ0P/4/veNGq?=
 =?us-ascii?Q?r7BygVbkQL9ds63BM9FXoBrqE9jVxORE7vrtXfWg6Xwr0CQTilT2Qw9jef1I?=
 =?us-ascii?Q?c6e8vV62/mJvtRdIl98W8PHwTvSaUE3TOvAaldRxZbc25pKfLdIYz/d3uSVZ?=
 =?us-ascii?Q?2r+Tt9gf+EzPke/OZNubDzapUIU6FTa6tzAR5+5gzFHWl8P+4gbk89gRNgFJ?=
 =?us-ascii?Q?XZFuXguB+ZnKMmTdgD7ZRv+q2xj3/uYoL8H+9pEuDjjAgWh5+X92WtopMspM?=
 =?us-ascii?Q?cV3TsXV+h07/k9B8bMVQ0e7bZ5D18E3/PsM1Qjot8g2VHdmwcIMz5ED4su7G?=
 =?us-ascii?Q?bqD96p6JhsopliE5kjqDD5Xj4qrFURbPHxHicF0dVltT8x6Dra9sQepFqvuz?=
 =?us-ascii?Q?TByXzasc4zZH9txMZc6xAeoJWAH9JEuzg4YrQsVoebd0EolRdBLlCEaqxwQ6?=
 =?us-ascii?Q?5l/iFZfOmwTk7mwOffNyKIDvcHOoxtTnH+QhN1Wefw84XijZef90lIaILpdg?=
 =?us-ascii?Q?5qfeTDGq/9Cbs6sjZJEuGX0aqRExUDMWObnDBt2wghoMqENucTfbYgwDqVVn?=
 =?us-ascii?Q?rCsW5NvWG3IPCR84SW5TG5hJmUG2nAGwlwQWixo3lZwsP9lRjp0Dxyj6VZ//?=
 =?us-ascii?Q?4QvAlzJ4CjrS/5p3eN4jG503t/wvRvN9Q5V2JON80xP5bY2LLpLpA7rtSkud?=
 =?us-ascii?Q?pVNKMqk5QdNko0daNyhPtaXVT4sXJ9vs37rSoYIEJg7V7C759VrM69ipjzge?=
 =?us-ascii?Q?T0nU0whyRfEsYcKqPxDF1s6oOdQv4smSYgdDRKKY2Aw3oaOtPsz0FdQVGDjc?=
 =?us-ascii?Q?sRfPZgbmK6x8wCitaFg7sPKVdEOG4feaV/UJu5iQA110Z6M7FnO6WPM/rK9Q?=
 =?us-ascii?Q?aSM5Kep7uZbwlqKrKv0eW5gp3VOWQsfTfxvvGU/JDcXyZ6cBAr0CWTdu4K5e?=
 =?us-ascii?Q?lY3EmL/9PHD3v0jaXcOLhtjGwfx0n3z87pFurZsgci2VRYUgBYC1K8tpGx/C?=
 =?us-ascii?Q?W6SGmSsZw1oi/crMPxM1vCZc7h7Y24dSO09x7pXtDMpWsE2OaLQQ4W+URzcs?=
 =?us-ascii?Q?/owr8KIXN05BzH9JvY3TfC7qeRxW+m0oPwnblNtvUeZMwatEZlrK1GBlokQX?=
 =?us-ascii?Q?kMVp54MbJ5ooYNcxDHyEW+R8d3aodTukouiYWrz8PIahyT8sK9mCO4hOnlra?=
 =?us-ascii?Q?YwQFLdATvwb2RKZv030=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RwB3vDibdizOlt4o32U5qPWbsXx0KBPU3NYpVgoAMOo1qn8HCWqLoddzcJAP?=
 =?us-ascii?Q?WSqjnDogvTA2DnqgCBMGk65WyWBYreWNBXE9gyYI8QgR4wIlUxV9hK0x69Uu?=
 =?us-ascii?Q?WlJd7IOBp6g+R9qUppC6V39lu8arRZ1ZDbM3Lpc4rYgsJnLYkdmvNV6Qs0mc?=
 =?us-ascii?Q?+QkiS2a7v08QZRTAhq4tp/sOzUphafeAJAcNKygeNCBbgU8rC37Lud2UZtYT?=
 =?us-ascii?Q?MCV3ulmQ9HjU+H/Jb0hBHfoN/8x3WROSQnJe6v1j+CuXu4r4oRxV+WKfYFil?=
 =?us-ascii?Q?qW4ZF3D0wlD64Y4Y0ORrmAb/UEq6/a0hS2df6GM2RddXRMrKR/kpgLULkBAV?=
 =?us-ascii?Q?agpwcRw2a6YCFo/1HNCrr5nio9IR6i4L/0DZUCDLYqCQMzO2CaItL1Apiu2i?=
 =?us-ascii?Q?mxV8FXJW1+Q/yczExQJ/CINEhhmOs3pe6XCtOjBuksDnTFNJEQlbp46JS2Hn?=
 =?us-ascii?Q?Z+ph44dcNwo+Vwi1I4JH7LUCJz4zClpMktDMr90ANh1wO6tM1cNUuInqVUGl?=
 =?us-ascii?Q?LSfF6tr9+ii4daIQPjE+PBkXse0RMCrRhX1POpLR8TCv1XlsbI+zDOTJE8y1?=
 =?us-ascii?Q?1bxCxhHk4ESck+tvyb414NWtTVlzcahdrZDklrl8fAwXqbijxL0tx04Oh9yj?=
 =?us-ascii?Q?2HqjHcZn1Cj1FcYLnanoGgkFbhAuq5ooS6nZ+LoejYH2fxejpyrBQOHZtjS6?=
 =?us-ascii?Q?Idr444HyQN7MMuuW7FVhvuuX55HOlMm68/wkjmD9wxk6aeaOCTnaUp3Y4ugv?=
 =?us-ascii?Q?ZY3NQMSt6MH/sj1HCkl+QMzR5JGWsxdDcZ3NF+M4edTfxUF2rra/pesHigxj?=
 =?us-ascii?Q?2vqViKtLOvwgReSHMpTBxOGj9QNoodifUhlRntU4iEheEszrcAvnOAYQRwFz?=
 =?us-ascii?Q?eiqPpj8dR2wRjoA5+xTeIOWCmkM6IJLPkopqlsvNf7/XqnpagTEUxg2fbSHW?=
 =?us-ascii?Q?DBW53rEKlkxhXO/l0V27hE9/5GTmswme6mx43v6svjs8JM8Yn0JEqA/731Wj?=
 =?us-ascii?Q?z+MdGD0KSmKFDAFnYG+ATADFLJ1ZEzEr6K+yDLyWmffAb22rsS+aCK5PuYNE?=
 =?us-ascii?Q?+zflJiqehLh5t9FzYli8Ide4+YZqoKMHuxsoAVUevmRZ6DbpaA3l5iPCJBmY?=
 =?us-ascii?Q?GrtIWyfm6p+m69h9/6ajQ+nvo0aAxpVl/9jwGRW3ZLCADP0xganz5mtEv9nH?=
 =?us-ascii?Q?lijFmu+MfAzfU/G0o7ix/aTw+uvtIBGvUX/+3LeVGdhOM88MAV7BbLPP1ZKQ?=
 =?us-ascii?Q?1UudRoTcBvdoNzfssmYQIYiKVin0I12JKsQRCFhVws2c4J2bqY58r7yZVvK4?=
 =?us-ascii?Q?rRcbu3M4acuN4jRmhq4Dy14WZcn6ePCVodyRvFGxn0srrEVL2whZ/JcbHxOS?=
 =?us-ascii?Q?DZIY3GibMTddeMgoZiVu67DOyv4C3wl2DWPId5QJ2ou/P0RPy22XmI9lWH4q?=
 =?us-ascii?Q?bzAQRZgHbQIbsry8mpnEaMIiw1jBo41+i3yEFKsyeOzUF7D1uk+XvswvS6S6?=
 =?us-ascii?Q?3fzQH/EmGmTNrQv4h3pfxGAiXgLgOSWyUZmQ6vVi8O+KaitjzkasRPnm3/fU?=
 =?us-ascii?Q?S3z2yibx/0k70EK9bYBfpDI8SCknhtiVBs2gbgGvc4V30taWYtghrA26KMUV?=
 =?us-ascii?Q?cVFcBd5Y31qI0sE/Q5KIGE6G61M4eaT4XabfbPjcju3CSzwlXbu9hajTs0Ze?=
 =?us-ascii?Q?vCZ0T5qqY1dWF7wUqKDWvXJxR73JHBwSmkrnjnw64ibbZx+iwUMLF2K2YgtO?=
 =?us-ascii?Q?T1UEd4e+kTAdcF0I3ztmq4+zkCZgeuA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K3A3R9lRsgrzo1S4hGy0V+QqSakc5HKkNmmU6zc0T9LvZvXYA2kqxHlgSh17o7YLoUF1UkRYS8NYFMtnJDfhr/eEu32EJgkny7XIXH+29l1f2JLvlJcjSsX58w5BVV/XyhXWyCvWVhjmsbuWBzwbrWe3AsRQGC3I+DA1MOmpwBGOqDb+rJ0IPbIbE8JCbX1TKKdc63d2FSMgwtUTalmyFmOXwMfYTvoA7Fc89BZ0JiRO0qXnJmLBDs4PnBLMcVbgEzFx+SnGdh+B8laQ8HxDIj1DAACxw8TSooEXFxdMtwWqFAP30JNOlB1X1AZnnkYPKRI3eIlR5xpLHueWKA08bIxK50sTRBvv5w3xQstOrINIeGGokb8ep7tK6HwgWmxF8MdD+hV1gdIQu0ERcoHbyZYR7akZ32MqWzX7ZDtvj8bGDrjUmSJgVLaDV3CfVIZmNIQkke2/aXyEC+qMdFMPt5FR2fApl3MVOiZSxTQAsccG1/fAKTONjIQgTF9mMrBxFKMCv/8ghnw9R7Lwf/u2bEQt6cPw6w2vZiiBuaAWehCz9oRxm0EE95ytWTpY20FdwW8ep3xnHiJUyAZSperHogadcwGPPFi8OfzZTnwIM7M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf394022-4707-4180-3bfe-08de59e353b8
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 18:23:23.1121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQ1c7VaUfkvd1GMUl+w54bbO8ptSmlTtAQ32NQh/33pN3/+bPHtd0ahskkjIC34vfRYIiGqd9mGQqs48TIrEXixPXhueE62BQvBoUmXgXrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDE0MCBTYWx0ZWRfXytn8Vh3GX58Q
 55jgLAqqSqQAm2r3ru795HmWvgZ/xxEnJkLrY80jfTsDTyMDeQ8XP8igSgRPBdKHQbyMir3EDzZ
 kSBdBhi2C9sigOq4qUeFEzBRQQ+PCD35f6UAyZj3CnCIipEKUDDzwua3fU/6FeErC1QtklXfQAQ
 hfm8r4qqznObVkMxnLkyb8pNOfLeEWC8bcFEfBb6ViLG71vdxhfTHNDECa33RPY/Z2DSBh7xBwR
 STBDLkgrOtTydEdr2y60fZpsp2ARl+y0cjm0wCuOaEix0gV7YK5utmBceMe7dWJBo8caTqnJPNs
 IT7RLuEm8MaEyhex7ANwRUlS4t71sp/FBV+GDBLauZa0WESRymadxshDI+fFRW9TVqhU2OhylYl
 KJUlj6GAG16olCtjwTL0VRBA2eJiMFKZpGoESP7ims0hPckbylYsYRvFiEGl9Bo4OjmKap6zep2
 urXC902agQIcHCI3qigG1BAwXlCJOZlVSmN+Bx50=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69726b1f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=3PQlvNoxh62sSMUEbLsA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: fbRVQk4CXnbopBLj_qwpdaS6Jij1Anqz
X-Proofpoint-GUID: fbRVQk4CXnbopBLj_qwpdaS6Jij1Anqz

On Thu, Jan 22, 2026 at 06:15:12PM +0000, Mark Brown wrote:
> On Wed, Jan 21, 2026 at 07:13:48PM +0100, Greg Kroah-Hartman wrote:
>
> > This is the start of the stable review cycle for the 6.18.7 release.
> > There are 198 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> Tested-by: Mark Brown <broonie@kernel.org>
>
> However:
>
> > Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >     tools/testing/selftests: add forked (un)/faulted VMA merge tests
>
> These are failing for me on arm64 and I think arm (something literally
> exploded in my lab so the arm bisect didn't complete yet due to the
> half of the lab with that board being powered off until I get that
> fixed), that in turn causes a new top level failure of the merge
> selftest program but the actual failure is purely newly added tests not
> working so I don't think the kernel itself is any worse than it was
> before.  The tests are OK in Linus' tree so we are I guess missing a
> backport?

Yeah, I wouldn't recommend running these tests as they repro the the bug that
the backport fixes :)

You may experience instability as a result of that.

I'm fixing the failed backport to 6.18.y literally right now, should have it out
soon.

I guess maybe I should have put a 'please do not take this until previous patch
was taken' note in there, but ther we go.

Cheers, Lorenzo
