Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65182777E8
	for <patches@lists.linux.dev>; Sat,  9 Aug 2025 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754751895; cv=fail; b=eQn+82LmSu0XkF0P9Q7qrxK67QyQltZCXACeokuqIyYWqclRowwzq+peOHRO3OlgThyjYBNRKsPxQ6uMlpl+wA5Su1+bIhNbqbfuke6v5v09zlcm2NuXYki4QA/aLWLpWtibr/cHrEoQ0Ea4jS7gZapCa/fhxnHQ27gXIge/EzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754751895; c=relaxed/simple;
	bh=ktnTdwwCq8lHrcZ9KUT66DL5RSJKPlLHObct80Z/H54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jgK04M1TnWPD2hGyp485jYII5rLWtqyhuZ49HuelhOLRYXCNBcIDMszVFERxP0+3aPux1i0sULWf0PY/HX5krbH4BOnKA4QC/o3CpczXShSK2u/IZ2KAopOpvCgm7lcAStLmFMFN93g39b9xOh9rk81ttCzuO7CBTqyYyHz9hvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l459fm1c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gkqCETN7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l459fm1c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gkqCETN7"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 579ELLnb027553;
	Sat, 9 Aug 2025 15:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rIZiOTC37L0MJg40Oahe2H4vZPBVlmLK7Svc/epKIek=; b=
	l459fm1c820prQxgVM+ODSZVV73IrIK78ij4SrsMKDCddXkT9tS5RDeQyXAtyHeO
	CQFZkr9Me/Q0729jPTq09fYxPAo8+QUWW13bNPCUKzmp0o7o1SlHEzIWFBED1zdq
	7JASdJGydSSqgJ/ZflPLy6LQGprxMppvF7UKdr9KMtJItJdHTwkp2kXhnBxfqYeb
	XPfPHTVxfGWXqFf+3mYi2zvskl9jZLQskfi39rRZvIFjDJBxNU2hGoIt5bsSkMEj
	A/yPMB/RXiK6rDL83b3kCpMx7Yqq8eWdYVNUZd7wANbWen6P4+LHK5NsOtUVsgPy
	Ts9K4G9xuzaEc+Nj6ZO8Lg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx48c1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 579DtExc009694;
	Sat, 9 Aug 2025 15:04:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdcrxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ecQw7dF5Oa5Y2SUAuGAORQzs9kLNRrtOOb+nbpuEaZ8Q2sIrfP3eBuZK/u6oScnpE5tVPGIBngTQBV0Ox1za3toBbilgkt51JCkIFN2g1zIn/wVaypLkg4TOuar/gUow8H4T2S8y4qRYBKaQZSVfPlBTchwJHzDEM4PyOhNTjkHYTcijM7Gx66tvBHGLM4UTNvcQublObfDitm1j3LKJfg0YdFnl0P6xZwaAghZLohi+JztiZ3Y+VTx6gdseajFYfBww/y61o8R6z/HCNFnOOI6/w4ccgOzoSAr0pDRraxvP5EULIL1i4UDvIkyXFtsU8A+9Kc4HdUBFxpIr28I/BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIZiOTC37L0MJg40Oahe2H4vZPBVlmLK7Svc/epKIek=;
 b=cOeemHIOxOLOkvoLRvGLSnIG9MqyJHey3NvbGfa6LacRh7pL5mI9m/YBD96V9w81CC7TONmMytcr4NpzGGugDL1bWKu3pw0EdHA9Bab88cPGHGs8p7Eh8FYx1hpZgD9TGsE9fKjv1GPe3wVkKs8eM8TP/DsYxdnq9eWvI0q7rIBrTtnryC0mTsk7b7bLh+NVVhhA2u0TaX4ktJbGlQmJsJy/J97WE7gPGYmpvwAbMLBzECsi8885ARlyV/1QagOvPwgeIU/aWUILY09/QRO6eh666SFAWXMxBk5+YpPafcBVdrw9eBdEDllEgtMMQSQJ7khaDonDf+77+X9rukKl8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIZiOTC37L0MJg40Oahe2H4vZPBVlmLK7Svc/epKIek=;
 b=gkqCETN7byLt7akvMCpQoLqgeB8kjwHexsjrGOWI0pnqMT/qRJbpelUeT29jyVpvt9OzJfmdJuQ7OKGvyfDY1qGfHOGCrCZFreBGTWR742My+tkdNA4UV4YPWtSm4Hfp826kzA++C4+d70s+e+UicCSldPxydnB0iJ04Ih0ggbw=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Sat, 9 Aug 2025 15:04:34 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.017; Sat, 9 Aug 2025
 15:04:34 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH 5.15, 5.10 4/6] sch_qfq: make qfq_qlen_notify() idempotent
Date: Sat,  9 Aug 2025 20:33:59 +0530
Message-ID: <b800f55ee493086bf95fe929027f131254f93e1d.1754751592.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754751592.git.siddh.raman.pant@oracle.com>
References: <cover.1754751592.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::12) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d6b71c3-8172-4de9-236d-08ddd7560d23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZOzyqaQm/BtVYHg2p4SxdFy9GUtAoTmBSl4ukN/d0K91wCdubd/M5juaJwgB?=
 =?us-ascii?Q?UvpbiCuY+8AXSLaqty65T4Z37nfdLvBanFAhXEdXcosB8O84H/c2zsz/F5Jp?=
 =?us-ascii?Q?bMrfziN6/GDhjBxhSMboAvq7IjWo+KNFBzrTrcYjytCo+hReL2jHTBpZUafN?=
 =?us-ascii?Q?EDNBUSUtHF3cJoWlqSpr8avWdMoxj9xquhzATaDuhs5wWP7uDXsLRLFL5m7f?=
 =?us-ascii?Q?QadnBjJQGUObhWB3o52oavt/bXfP48IyYF7X4iHzQbQcDCA1Ozbh4iNGxpdo?=
 =?us-ascii?Q?+6UofrhSNDNYV4kE6Ylx7kzQoSSMgyKeSGPFJUVZigwv9XvMeQfgrPNjvrX5?=
 =?us-ascii?Q?SSOAoMblUdaNmLkBnKnaxGhCpd5iJkMTPM9h21sX+pvyh6fpLS/5VjEWwaTZ?=
 =?us-ascii?Q?evhcXRxTuoGbeTzOdG4zqqLn8ODL6QarcV9XTuDziUAZJqJu/EQdKq0HAa/R?=
 =?us-ascii?Q?k18183/pWPKtk4LjEMwuoeCI/hVjBVORRNhJmng82Kh0eaMU8y9UhHlk13pE?=
 =?us-ascii?Q?qiUz7Tqighje5kxM956qDsrMNoAb7Q/0xVRCh4k5l3dzEYAeosynLfD0np0n?=
 =?us-ascii?Q?9MH9eNz2e1Xd9V4wTP3Zo7CtEFBLOZd9KQRGT4txD6UZ7AUglN2CesDiDsxJ?=
 =?us-ascii?Q?G04aIbyoYv3BKWwKq/VQFMhSJ3SipmjO4+0tr+/2fAyMIyYxJQM8ca5G5j5A?=
 =?us-ascii?Q?uSM5tHGqS5YPpJnryv7Xl7k5VkMMgXoDMPU++JNy/6hL9W9FV+Wp3KpufkEl?=
 =?us-ascii?Q?ugA3amnhqzLLOv/ewK2ztwtK18C6p3otFYwhZ71mzVd5Vek94T0ac/ifVv0y?=
 =?us-ascii?Q?23FmYAgsQu8TnFms+pY/V+YvM2l/br9Csy4hPJ2rm0isRX+P9WW6Ped2jeB1?=
 =?us-ascii?Q?IN+6lU/vBFI94elqxEO0Rxzx7OuQo1mmW9eMScNK2ILkEGjNPORRgqGZCQIA?=
 =?us-ascii?Q?Dupwp+IqT9jZ5XAL1tNfVb1UQluupb4qYeSfVgVebW82Jau4i06gOrRJ74I8?=
 =?us-ascii?Q?PCltptW7H2vbrU7gY87yfW1eB78hm/8VJPaPPuvPQxGATH9Ec+0XfZNiTHFD?=
 =?us-ascii?Q?RbzHnS883ASGO92H+I+udRw22RPkrJpzTuEwJ2P+u3Zq+aKb8di+rjSpsk1h?=
 =?us-ascii?Q?misSLTrfj/FbpDDD71jG0IIo5Xpsk5MMLx9FDrCyBDXU6wa4u7cmWBTy8swj?=
 =?us-ascii?Q?nNv3OOSduuqn/9YM9c2wNLXjhAIf8qzBffQBqbyC3XY8Lqdct22nrb/8LXPe?=
 =?us-ascii?Q?xGRPg5YnnRjYg920dLtvbHviSD0PbGHRPXVWW8ay4yz+W0U0o/IRbP1zV7Gc?=
 =?us-ascii?Q?84LTVhARhgGNzHIySgkSVEHql8n/x1ScyZcxaPJvh7BqGkARVC+K0kzJuLIl?=
 =?us-ascii?Q?PmeCtOs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i/GqWO6xEh9hYvC3yahcwG8/0pWU31L3ujgQX5Gz0Ibb7EzHjlI1x6n1D3RC?=
 =?us-ascii?Q?eSDUTmuhGTJgKkW0/3GuJcMP3UljJYhmYkqt2d+jN5tOfS0a6TbThv19DPWw?=
 =?us-ascii?Q?6kIg37jGqHcUUgFI57xMSjP6pg8HMs1zBOtsZnX+UyqbI1F1k/13aKFDh1aS?=
 =?us-ascii?Q?gc258A0RTH299rvS3d3fyEgqaGLa9dXKTm7CRIJkTsw43y8JXTBMIp0k5BVL?=
 =?us-ascii?Q?bGRstWB5v13ofJmCJV58oU9M5U3TYwBv9KWSouhQjZM53Q8WacWG2zsbeNwy?=
 =?us-ascii?Q?mC4fSnjpyjzDKc+h8Aw3beGso1FMllfkaHotVlhYAyqwIWSmOP2Ijih64OJR?=
 =?us-ascii?Q?0i1OljvIz/7kNCVR095YDgqWCjjG0yzJnCif+iG3g8plslFh39p+dBfxXIkT?=
 =?us-ascii?Q?NlMX6pmk2FLsojL3AM7Y5sLECM+PwUNTBFosN+KTM+3/Umne4tDdPzkgXfbH?=
 =?us-ascii?Q?IGQU2h25qrx2Xv4QMVf8w8fA/x+7MLcOteGJonIwPqDjRhiNhCEk6+DxgVGW?=
 =?us-ascii?Q?w8F149X2N2nP84PFTSAXgmEquV5XDBGep2uucRzB3FcDdZWCIu09CMswBgPR?=
 =?us-ascii?Q?19SQ+Yj777/Fx+d6FTIT4SkcensFxAcSGjYfcbxJZbnydJfPCcrzY0W3QjJM?=
 =?us-ascii?Q?uY0C909EWQeIMaJu1MSUvnoNIDmTpHUab1wkNXQmMPf72xR0qeut/2vh25fy?=
 =?us-ascii?Q?j/OD7AAZh85DrZJtrsg97UahvKUvQqTu9ffb4RvWR6KFhI5xJyigqmqXAWsU?=
 =?us-ascii?Q?xp+VuWpwJVqXs1KqI3xTf7GQjqWnEF3XPzu5Hz5VC2i4dngcyuLJ4Pmd5ixw?=
 =?us-ascii?Q?a+tFqEwUP/vec+pYHIeJpHbOi7HsG+433dqgQVmGhT9Op0PNoKDoQUCF4gy+?=
 =?us-ascii?Q?CLzKa9t6SEZm2YEK9uD8X4PC5JgvoOv+oDxKPKPZpaxtPWq2QP5gSHpsE7gk?=
 =?us-ascii?Q?3UCCN86GS4zU3HrqT3wmgKbVR403my7O/WTEZ+h6rNyhA/SLfErMY44l02QX?=
 =?us-ascii?Q?kCggsjMlb0MdLrG+oWY8RcSoF5SV08dnG6SaqjaVQQ/OAhIvbk0iB//wYNrR?=
 =?us-ascii?Q?F3lqEe76KNRYkPhghAS/bluZ2acHsMgTwA4K34ujG9jgGXUz1uGAZit363W2?=
 =?us-ascii?Q?71kS5jYsCmwDkpe33rH4vS4S+jfNq3B5yi1XPCflMnMur+xTNcWUXUOzkIPV?=
 =?us-ascii?Q?fUrXjOMjLQV3fGJBm9+yRLqueRPs6kFkcCHW0UbPxUgrJ+qTYq1BEe5slQP6?=
 =?us-ascii?Q?+ZTCLynGkhb0mm6Aav2k8LiKTzzMiPfAjNuClYuaa1l/X4Ecx8OvCGQX2vk0?=
 =?us-ascii?Q?1ykMUmh5kgSSE4dzvFiLrjjZOI/vbgjkDSr+ieeEuo7oaZpQ74Sp/jerCI+j?=
 =?us-ascii?Q?5+DPw5rKolXFwzeakvbnswKlqzSmZvYXFil3Q+/GZwqQcL2b9/SumiHBOEWZ?=
 =?us-ascii?Q?sH02ASFaDMG0uiM23e99WLgG/qMwvPrsIcB+x1FGZ02Iw5NFpQAkyV5MhFV6?=
 =?us-ascii?Q?8/5itQ23DiWV04lRTOOQaRO8hxmJ2djIIRuiVLkvqeAEoA+8JS8nleU05Pom?=
 =?us-ascii?Q?EebFXXfw+1kTOog8QD0XFmcUJCN+lgUJP5+uwBJJ7TjsChd3OcgMDWF3+f94?=
 =?us-ascii?Q?gD30IhqFWjgAZuTZe9lBXZdPRo81tlelGZErH2F85VvWPeVVdKDRuRytHpq6?=
 =?us-ascii?Q?aP2ooQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MvzutUMdwyFAx7e6G1sojoqKaN+C2hBbTT8LFJpYN1CbostCzD+zuCXs1wE7hGByRb4cLS38mwDldDNa6a9RlLF5LivqX/2AbuoSxRvppicSaXKuguOVfjAkbBOZManmWMj6oHp4XQvfljJ3/SC/eW7jL5VN16t2IgSuimg12Wq8jgQUsRJumIUdxc/DHQQXPjI1mHLjDH+PTHfD+LQ9NPKDhiRqYI4D/pHLMyGrRCZOJCu8cQmGTgmJsM6iii61ft9jfBp0xU4yiJvzD8vl2TeGdJhRr7cNDLqM9kAr210f6mrA1SdBCP4jotR7QTtrIGh73EoIb3LLOmzU4DAALUt2BzmaMSpflLzB2Jpk9HUkL2ldn5Ym5DOjYeogLjZj8pRhN0fSNSP+h9AF8U0e0R32hvhX4S92WApjmnk1fd5zMnxLiSijg0D8Q3qSxCVQL0mf3pCy8ChQPA4Je+efdWLRnaKc2niSfN9ZoYib1d0NK+qyvjGPu77T/V0HpFxaX09E5utQtYBnVVNWdqtzwj+p7rDd+B/EPe4cnEnhsDuCLlA5yx423KEhJG99OFTsAkeMOErQsNThNWjW1kei+DW8kdJjqP/DbVL5UvTSeUo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6b71c3-8172-4de9-236d-08ddd7560d23
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2025 15:04:34.7803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6FO++jbjOqbEiFO/V1n+XlO59ZxIc8/OMnNkSoUMlhs0ZNRE46P9cktUexauh/7H1v/eMmQpcUvTTJ+GvHsdq/q8HOXtHk0JnG9ZETnfUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-09_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508090122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDEyMSBTYWx0ZWRfX2h8Sdf4Zulgk
 mNzUFGR0Ej4EmrdsqMrjzR9KLc+rou+yGXeg4JQlGORjMzLl40EXvPRPEIB0PRcD57gWmw/bIEw
 9yNB1gFuwbXbsZkib+H492TfkZ5HcMSS6CtLEn26vf+fIPZYoFWu8zx8FUncffQjtN2yAq7Ewov
 eWXGr/deROdkIpZ48ZYHhoSaTOV1enUldJG+OgfdhxXAyOAaavORlHEyN/PDySsOQYt+CmYRE9Q
 Ssp1Lao3OhNrvvg9+sONr9NdtSEtmhr6AHqdLBwlc8hQmV0aAqGIPmh6IOW17Fwnpctyi8x9ARM
 ApBDMqVsVU060TBHZTD+an9zGX/Za7QX2K7EgaC4/7GjGV+3cjQyYd3gXX2ZP9Ej3fBpw8JH9Im
 ZotY3Zt6SFfA17+x5tKWm1hzZa3tx6xcrVFQx0+dOHX1aGQLPfsRDI/MgxFaj7XRrIAJddEF
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=6897638c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=ywO0XL3laA8Yjrm7ejMA:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22 cc=ntf awl=host:12069
X-Proofpoint-GUID: Q1ufhKVI0fZ1-0Io7z8jeRGPdo3pcOV9
X-Proofpoint-ORIG-GUID: Q1ufhKVI0fZ1-0Io7z8jeRGPdo3pcOV9

From: Cong Wang <xiyou.wangcong@gmail.com>

qfq_qlen_notify() always deletes its class from its active list
with list_del_init() _and_ calls qfq_deactivate_agg() when the whole list
becomes empty.

To make it idempotent, just skip everything when it is not in the active
list.

Also change other list_del()'s to list_del_init() just to be extra safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-5-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 55f9eca4bfe30a15d8656f915922e8c98b7f0728)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_qfq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index a198145f1251..fb128af2aebe 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -354,7 +354,7 @@ static void qfq_deactivate_class(struct qfq_sched *q, struct qfq_class *cl)
 	struct qfq_aggregate *agg = cl->agg;
 
 
-	list_del(&cl->alist); /* remove from RR queue of the aggregate */
+	list_del_init(&cl->alist); /* remove from RR queue of the aggregate */
 	if (list_empty(&agg->active)) /* agg is now inactive */
 		qfq_deactivate_agg(q, agg);
 }
@@ -482,6 +482,7 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 	cl->common.classid = classid;
 	cl->deficit = lmax;
+	INIT_LIST_HEAD(&cl->alist);
 
 	cl->qdisc = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
 				      classid, NULL);
@@ -996,7 +997,7 @@ static struct sk_buff *agg_dequeue(struct qfq_aggregate *agg,
 	cl->deficit -= (int) len;
 
 	if (cl->qdisc->q.qlen == 0) /* no more packets, remove from list */
-		list_del(&cl->alist);
+		list_del_init(&cl->alist);
 	else if (cl->deficit < qdisc_pkt_len(cl->qdisc->ops->peek(cl->qdisc))) {
 		cl->deficit += agg->lmax;
 		list_move_tail(&cl->alist, &agg->active);
@@ -1428,6 +1429,8 @@ static void qfq_qlen_notify(struct Qdisc *sch, unsigned long arg)
 	struct qfq_sched *q = qdisc_priv(sch);
 	struct qfq_class *cl = (struct qfq_class *)arg;
 
+	if (list_empty(&cl->alist))
+		return;
 	qfq_deactivate_class(q, cl);
 }
 
-- 
2.47.2

