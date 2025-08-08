Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E320322
	for <patches@lists.linux.dev>; Fri,  8 Aug 2025 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754661718; cv=fail; b=aHPp4OTtG4PxQFiLj+wzQc3amAa9cJ/F66K5cgxwcuczZfljDXet2CAG0wkx76YyiGOeq3a1jl7xl1OPAZfA5IhmilZ3ajoEkALWSwijklkDt06h6JnMBZDAiiBAvW1QTzmLunkIdxsgUH6g39mAamsKpgUHh6o2AbMmW5bgyQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754661718; c=relaxed/simple;
	bh=HfwuFkF3Vgkz/qiTiiwTdl4/TAMMA3ZRr2HsssPKs9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ewI5Bo9/5bln34Z1h80rUkjYPLLF1nupBUv6tSJqGbHQe9H14u9yKW57P4ZJhte5R2zW5r5w3aKStJUUh562IUvUuiK92PmNfE/GZyu2evMj963r4vNz7btZfU2vwCTNr7B+UzfudpYBGzq3cdL/m3clgA4zOEdOthqjc1M3wdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jqS/jtck; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MGHJn5oA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jqS/jtck";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MGHJn5oA"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNUTY000780;
	Fri, 8 Aug 2025 14:01:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CDqHxOTW20woMRUz2MgFHPKGos1slegoMwUlG0jjN1E=; b=
	jqS/jtck1mgwr/ra2v+bJUsUqzk2RtsGX5TPD6uzHOHlo4BPiyGwIXT6euruJvcQ
	cV9vbB3sA2WENxOHOpM4UXqVJsKxr/47ZOR8d+1JgtBduGTCq3UDzYpFPbepL60u
	IQNefVP2Ijy/7SdT/EJDuoqPhP5emYwY4YX4GUlqhQvZwBPC2zuVgcPnZ9cstIXL
	rXx7H3nhVwF637XdiDv7LtF4wlB8PIYPGwqaba7SsT1URc2BNSyK7DWREw+i7mCu
	4qek7xxLLZlqg8dHd7M0wkCC587EtPrgD1SHXTl/pyWxCCdN4gtFtMFnQ3J4aY1F
	pUeXhH11eooi2V/6p/952g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpxy6ghu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:01:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578DwucK032218;
	Fri, 8 Aug 2025 14:01:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwtb23f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZ/+ql2kmO1mdIzS/lkoKK1kTvhbCMKZusZvf3eAKFArDXRAs+9UQ0bvYTZBfwbFTb1g6GtjFr7ZQK/IZ1hFPAEbMDOuP2fwBMsLVjPfPMMEsV8H9Dw1yZe+PFWEtgUu72gXWQqZ4/VqzvPdGX58la3NyxBMwE5Nc9wAHygzUPPZBWbsGVrwF3evzB/Ea4mTnomYr6NX046Pnz6kNLR/aIsn3RPVGcCIyEgHxi66SWGAi2FRgblrOran+re+XARGy/C3axMb6eFG1bhQ+5Yl00XmohB8kjisYykEsDydwBtL+b5rbRGlAvVXMcoJh0gycQ/2fOQhG+irRGDhmKj+8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDqHxOTW20woMRUz2MgFHPKGos1slegoMwUlG0jjN1E=;
 b=CNFTHRGpqfBMzI0Wl1aacBqxhOo17OCBTy4PR8kd/giD8GbFaIXbJgQOI3axen7SkqfCmFkf4i0BaKMAey/qtFV8YLGFiS3lIgODlUzWEr8lGqFnUaIe0+Zkk3WyFWfJY0jJY26KNOyEqoUCGG/4LveyqmyD2PMcYlo5fiT5bALSN/+HzP94n0GMepy7m9oFODGwLXtwqyjuQqJ0KUQvIQ0vY4Q21XWdtEaT9gaAeeXmERrLE9SAJ8NZJgqwMcGMzqD9HTqrOECP7snRPk7e2tIEQFNzdClyHxYkR19L18EVShgadkmQamifOYLcUE1lGEjJw7wi9Ix4exbsP0Hulw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDqHxOTW20woMRUz2MgFHPKGos1slegoMwUlG0jjN1E=;
 b=MGHJn5oA+pQhc9W+2+VjWL17Lr0LMWQi3B9LefaID5mj0qJALeHdKqzx+caJ0qBIzmZ0jpD51FEo5N9nHOUBSLIiKc1kIfu2lrhgPooFq4CC9ZQGFf1U97wiJRaLtAEzFpblTyLpBbJn8Ow8S9wq/kn2Ox0oQrQKo62U5D5aOg4=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS0PR10MB8149.namprd10.prod.outlook.com (2603:10b6:8:1ff::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Fri, 8 Aug 2025 14:01:46 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.016; Fri, 8 Aug 2025
 14:01:46 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH v5.4 0/4] Backport of missing net/sched idempotent patches
Date: Fri,  8 Aug 2025 19:31:33 +0530
Message-ID: <cover.1754661108.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <e9d1d65ce802b4c8190ad4e5944e5be1cab38eac.camel@oracle.com>
References: <e9d1d65ce802b4c8190ad4e5944e5be1cab38eac.camel@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0062.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::20) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS0PR10MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bff47a6-4d56-4f4e-04d2-08ddd6841c88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BgZVtmENiuJGCHpjA68Sy+SsUkZjikskYsf1Tco4OI7/4Xg2I/wIvpRvR6OM?=
 =?us-ascii?Q?HzP/VDvagitwGI4skc/ZyBgUe+2LBnUl38FyTmZadGS5QMhTrYrLwNRMLnCY?=
 =?us-ascii?Q?rm2flpV77/Zq/288IPyQzhqnxI2JMl8nUOPdhq4F2dv6AIX2/vemAemjC1oi?=
 =?us-ascii?Q?4tTkavXPuexPbfJDRX1WVD5d4ZAqthZYVM6BEWq5bKfLVYXaYgTeFHl6cRj1?=
 =?us-ascii?Q?uKAox7U4dMYCMSg/tXwxpmJTbfrwIVfqRgrAyfAeiOgiKbqJ/+7ul/ZsVz8Y?=
 =?us-ascii?Q?6cPjTIl2vzGXkBrgXXbbEKpQzANg7Zhva8ps8KaSnVWYHwz1Ezxfqsr3q69n?=
 =?us-ascii?Q?7DobQtdHfyfP49S1bJaEKLqjJs1z0JXVimVxhxLHL5eCmPKZ6jL0/iljHSq8?=
 =?us-ascii?Q?3Z2FKuifkPjC+zOZU5rK2Pz8iM8uTzku+Co6Xjeff9y/MYFErJKMIhksk0m5?=
 =?us-ascii?Q?hVxtlKG8O74cE8JsoqtzdRKtstAHZphTbx6W45t6KHLZMHpmjEv+z1ojsYdJ?=
 =?us-ascii?Q?/N9ZLYx92RUwKJkAgQ1ExB46npLptq8rpyukP8ymvUpNTbXvTT1aU6zeas84?=
 =?us-ascii?Q?m2GiOoncxTFafvGc2TuNsBdDifcjstevtpCn687rXLf5R4lWyNerIpOWLiX3?=
 =?us-ascii?Q?zALvWO89vV5ozhYwE0GS2Wg8XHMrcRfrwxMhP+8aTQns0ZzcZbe8rlli2oce?=
 =?us-ascii?Q?Wy/dzXgJXDeW+lfz7s1CHfVVc0+zeW9NQu+XqkqCMuMI9Zo6b17jHnVHTKvA?=
 =?us-ascii?Q?v8D8oYbfmxUr2o8ZMDoCZb0u6BZUcXjHbXYQUiOj3LdzYhXo1qvCXMosfNP/?=
 =?us-ascii?Q?B+LmJksuAVa97+gDmqhk4D9mZofcOzXL+LWB3fNyyKHNIeBbfsyutg5iOSMu?=
 =?us-ascii?Q?G6BXnKESSKkEBXEiPFgVr3rHsrJIb5pULgXldqLTHOvwnifA0QMHoenuraNO?=
 =?us-ascii?Q?qSMB8UFYyDuIZ7m+k2A+f//h2ePzL5mfECSRcG1h2FeAWJrtehKeb4QOIu+0?=
 =?us-ascii?Q?nuAxxQNbht9I94/5NfJbRZ6u46O1+pb3RUbgaXnn/WmjDIANfZOeuol+ZDpq?=
 =?us-ascii?Q?rSkpYwJRdpPXRth4cCmGbRcdpQnWCHyGXIrPOIdm3AEahrkpD8jElPTKnxjh?=
 =?us-ascii?Q?H4lKPijx80kJRgS/esxaW88nIShRlU+TnybNHKE3Goyt55lNUp6OZHYL6t0v?=
 =?us-ascii?Q?BinrtY7Da6Y7zrrVxUwBqpx5RrT6l61/fzWMnCDLH7tuGitP9Ilf7A7eBqS0?=
 =?us-ascii?Q?o8GkiBdjpn+tDkQBEap6DQ6MK/96fLVZC1qc6X4VQqFjkX88b5dfjUQwgDYu?=
 =?us-ascii?Q?oNA0B2X7sOp8pomklRZigX0tidWeMH3BgTAm3pdXWC+g4V/Ow9R/YxRAoFyJ?=
 =?us-ascii?Q?59snjYTqF2fpMph6wlQAW4qiP3DhLGSMojLIJdHHGqbolGkeaMrMJ+LU2t4d?=
 =?us-ascii?Q?ZXgzG28cx/4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yLkkd/HSmtBWR1HbdBUCz2RQ9oHyc1X4UEGylWX2LvtB3jhsMnNG10dUPfi7?=
 =?us-ascii?Q?Ql+kjwMXq0i0IIs+B+te+m38Bn/w8h49Is/5ZP6HlBA8+3g4poFwcJHoWzBb?=
 =?us-ascii?Q?wQbgtw/SGdcJibEzK8YpshvNlqQQpVlgF71UVwuERzXUg3kOm4tfuWcPsOoR?=
 =?us-ascii?Q?iVX5UFTl6Y9it/UUpIyhKUT+Q9JlLRfqPooJp5g/Wjwyt4zKBWB28FKQsa3h?=
 =?us-ascii?Q?dCHNdRjx7bPqtto9Ivh/1iYGer7DL5Ma1giBU0GmDgXOmforDrUF12tZfCbW?=
 =?us-ascii?Q?tTh4E/hb0f/Ci3QyvbAMszUSXNi+fugnjyRLMMdxN+Pjh6i1mTy9K5EWOzYy?=
 =?us-ascii?Q?lcIXjGvAuqlbBBHxu3pQ+INZ+TTtavwlHtBGe7FkeF++48kyYZaSXaJcqLP0?=
 =?us-ascii?Q?L6Kt+Rvy+oHASqhBkTF0Sm3iGJ27YvUSQEfuiifWRXcysCwe/W53gndIb/RE?=
 =?us-ascii?Q?WEvgUHEJulyOMDNZpRMu31CZgk3bTAa6B6Yp5DHDQkygSCdv/Nni7QXOKN8e?=
 =?us-ascii?Q?6Iy5Xv0+MqUhmDQA+Brq9/Vs3ZewULowG0zi4EoOMs7bFAdcy8QwW/V6XTqf?=
 =?us-ascii?Q?wV28r7raucgaDljupaEmSrFNGIOkC/HylPO7FOB5dVY6y0hnEZijNgxSJ90r?=
 =?us-ascii?Q?8/eINkBXjfvNWaa7vP7WFvrzrt1IqVSpEAw39cJP6VTJ2TV2b/yyzIJIVtbV?=
 =?us-ascii?Q?UsBJOz96u5QVPgu2EHoEt+XxPCmt1zxMRet46XBX6u17PiLx7SiOcfp4+JGY?=
 =?us-ascii?Q?a+6RX28sqS/nCBvF/f1f0Sey8wLKcyhdw44x5DiJFHn+qOcdZfz7k2LfkS2I?=
 =?us-ascii?Q?CxlePoZ57Snzxhhpo4KlXHzpBgtPCUbsOuuS2J3Gw416UIYtVPSXKvR+t/B/?=
 =?us-ascii?Q?INC20B2ATKhITVfkJZT0Fw9X0+Bup+Otbw/FPWj55efSNcFUJRmlRQvB4BYN?=
 =?us-ascii?Q?3kzH+JRJVFpxuJz48RH1IMt7CMDmSniN1wvqiaWdF6ECcPlW2Ms/izJcRva+?=
 =?us-ascii?Q?mxmVsw9GNnp+4LBxZ3DKjfavns8d1h+L/Z6/0b1fceRzT6yZIAQm/jVkFqsA?=
 =?us-ascii?Q?ou3c2j+PuUvvY6c/D3/6Vk/6McbTJKAxAIl2zusDfO+3v77rz1Ms5x7twBAI?=
 =?us-ascii?Q?I3OapdQ9l0cmnitY7zsTtoi60An9O1g2/ZSqNPLD6yONAH/5tIqw/NWIv4wa?=
 =?us-ascii?Q?1oNTq5C5cHhnk7v+/uvA6R55RcDCwsChkfI2J7NPIrNPdCnjXFRk/qXifNvi?=
 =?us-ascii?Q?G5ToEnPk0MR6r3JthWamSkCP1DouBJRduXVwpJmg+Ad0ZMrcYJ4Ylm8QL4UT?=
 =?us-ascii?Q?0yOUbiCpSoGTG7HxfjMASiafr/15wCNTzGgzxGnhWUPUTWeO9/KdxLD+Xp7W?=
 =?us-ascii?Q?E6JDNb6a0/UU9O4Qf7ulItBZEBTfFZ6WQvZfRQR5CejBYP8hmp65RvgjORuG?=
 =?us-ascii?Q?fZ/T3ayad2fA5PtbVMstIUIeX4NWNcoWkSdKbnXrQ+CopgCCrTUcCyVxEsE4?=
 =?us-ascii?Q?EMhh4lKo49J/CL7RXHzUTE/7dcZiLnf49DyxFXsHk+soNuPdqPXJz2Ix4Quf?=
 =?us-ascii?Q?O1ymEKNx9fqibjdM6wS/wAiwUiWGhRsND8zJdSC8pBd9wWLdKwy/kvp+muRI?=
 =?us-ascii?Q?dyRZkM3uHAlSnCQy6R3iKe4xztxD0iHiH7PAOvkZojGr80CQUi3soPX0tUHl?=
 =?us-ascii?Q?1Rmf/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N3RctMvclYJS58DC7daiL76Z7ZWiFUOpKmHivtdqRdxBRmnBbnBtwSmoUJ+2rNWDwqNHYwrTzXqZh/6aZPK/t9V0yUMPK3QbnNFjazx0ZlwsGYetjBYhNV9nco2fpQqTNm19uhxIEadPwRQUD5G0EGmTj1GOAzlVpPqAhrcWb0sIS76ntbLy43AIojKx43LkTFDFumTKknmTr78vo7D2uaWqXkxLq3W+SuRKaNV18hg8mm5+xRb+i+jCIijtlj4rXWqYVxVnPBLTzYXtfNzmBxlhqNp0+BHM+wGIGhmUeibCqf+txgqjMekF7tta/Ci8BggxemF1MRrl7KQoAiNqrxTtpm8uCrRFkbtMXiC1QO3xBClpXW5TqA1ih/XCe42uXl1tii1tmO8IYaWk+S95tuz0NE+W6HGtQ8JLWe5jxlHkV6QBYUGU7Q1LDCpx2y6SuEWIcuygNTtM4IWoZ+TB0AzMVJawveH3FmUjcBnb6AIk4f4MtSpqvjKXHWJMBM5a7x26VCG1kuPDkMmEPDHiFMcL3UavowEJokB3a9Ys0ytlx8XTd5GEdj5K9M5pfS/rYyxq3cKWyAXiJWNVeH73VVneOo8Ib7mLJ7mJc7sbxRA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bff47a6-4d56-4f4e-04d2-08ddd6841c88
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 14:01:46.1588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrHWKqAHzt4CJ65hB501I8yhzjBGFUXgqp78JGxdw62o2184VkpTQKyWqtER5vztKJmDYzGkJ2vH2kMl+a/YvhgdhPxNZ0EA8ll5w5RyT5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508080113
X-Proofpoint-GUID: 1dwWpkBG3-2ewqkonKl9Wjm6lnMWZwEP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDExNCBTYWx0ZWRfX5QZ8H4TVastK
 ZZPxI1E0oWuHW/SMsTwvQMpcS2PL9a7del8pDIDZ54bDa6ICQSyZuV2xApab5G6hFaOd/naOpYN
 WUvQtz1TaLGXUBSiwpmwrgF8SUiFRU1d5mjPYqt5BPfb+bkwIMTWugMDtSqfB2en2dRI3rcPJAU
 L1WN4hOtHfM8Y9MAWHswdWqHjToEDCp5tznKP1kWMHVS4MxiXWHfFbsSHyv7gdI+3rjaVSObDm/
 EZ+C2EwRz8ElwHHq1AQ96RdhtXwFGGZVh59gAc2B01fkBM3IPcEHbFdVewvsG+NgrS4ygrAY51k
 tSv/6OhAwEfyzfAIrKk2ddAO5stkn1m5eWhz4EgEplHiaSETNdaESH00W3V5BCKJhLrPaBN1lSk
 oHNcE8J8P9eVhs6e3BrK2DuITnGeFFPCq+MKgghNmEI/Sz6ogDfZfYr0ZqoSCi4+EThOUuid
X-Authority-Analysis: v=2.4 cv=Y9/4sgeN c=1 sm=1 tr=0 ts=6896034e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=kMG4DLWtMIzIr7au-XkA:9 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: 1dwWpkBG3-2ewqkonKl9Wjm6lnMWZwEP

Just did a cherry-pick.

There was a trivial conflict which was due to an extra init line added
in sch_drr.c, traced back to 67c9e6270f30.

sch_ets.c doesn't exist so didn't (rather can't) put that commit.

I don't have the vulnerability reproducer so I cannot test, but it
looks okay to me as the original logic applied cleanly.

Thanks,
Siddh

Cong Wang (4):
  sch_drr: make drr_qlen_notify() idempotent
  sch_hfsc: make hfsc_qlen_notify() idempotent
  sch_qfq: make qfq_qlen_notify() idempotent
  codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()

 net/sched/sch_codel.c    | 5 +----
 net/sched/sch_drr.c      | 7 ++++---
 net/sched/sch_fq_codel.c | 6 ++----
 net/sched/sch_hfsc.c     | 8 ++++++--
 net/sched/sch_qfq.c      | 7 +++++--
 5 files changed, 18 insertions(+), 15 deletions(-)

-- 
2.47.2

