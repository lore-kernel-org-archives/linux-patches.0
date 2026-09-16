Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0760242467E;
	Wed, 16 Sep 2026 20:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591290; cv=fail; b=aJzezSIGNLMfjPHOurFaY9C44d4EXxl93lQ/2L3sogCxw7PkvUi0HL9b4CxTMBVMKzFYE4NU6m5j14BEQcWfjIyIH8h7+VxCZU7PkRTYp/poVD8uRVVfZ/a84WF1Kn/PwQKBH2YAS6zJTXfzxAOWd/vXk36wP66bhJ3+XJZfm7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591290; c=relaxed/simple;
	bh=HFWtj+EN05n/f/je+Qh3a5PCpJwVdriQlDP6l2qBwCg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qOmGNj6VeZ9cLmgUL2NIBFStRibLchv5B2nZWlSaOGVRIwCa+v/JTgbz68wgy22L+OT3g+w3tnJe2q5mMzPrElmfFN/qkG1wM1Dj8qulfxhd3KNOoUuglfu4XvwrHElIjsRtMjxz30PnlraTXDYc4U4zsaOrCZhd+MaVcjyMEWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lE9b2ogB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zwqzFpCx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lE9b2ogB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zwqzFpCx"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEBdfq2983581;
	Wed, 16 Sep 2026 20:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HFWtj+EN05n/f/je+Qh3a5PCpJwVdriQlDP6l2qBwCg=; b=
	lE9b2ogB03ZJM7XcoTNanXypEgp4HIIBkiljIWWc9FIvANhV5kMIT4hgPTlr+X49
	VpTHiIrOq8YGsebSnkrWDCxcLNwdo2WAeniEIf6gLXj963SjpggegNcj1x2iori1
	AAthagvWOOog0ZneV4mBsXmO6cq6jA0jVA8o515Nuws5O3MZJgs+w2U2vVLwo6Hf
	qnbMLipzvUeRK1j7xIXr5OpLKMMFzgQ0vyhb09NChgZ7zzioLQtPNfTJUBjK0a4F
	Og9MjPxDmE7UbVWoQDPxqKaJxa3IxBM3yPLZRzllH/31XWohvPLpwMSiuo13Mx2h
	ZxpidClkQ4Gzu7tCqKIGng==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn96euk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 20:40:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68GKZOhT013683;
	Wed, 16 Sep 2026 20:40:44 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013010.outbound.protection.outlook.com [40.107.201.10])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6r8jq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 20:40:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MAtturMbo143JO7mWIHpwHEjZrqPcCjr59p/qItqNcjxNd5r3x8E3Hq7xd8tsBBzsDAT4qIx4RGH0shdQwZELL2oPBo2R74TnH/+fS3YvK1VGiyexenLoJaOnJRup4DhHKsC2WbHoxEPIxDuLfRP8gvcvxiRX1PuO3IfgODuJusiOzyy3jq81QhEVsGWlC8Hg2WAAnuiU8XCftohNpYXBEkcLiDFLqUW5sk9ZLCka+8EJvreZv7KuKPTBo7nYAYprgpK9ZeKXxk4nfWbcNaajZ/9eOnZMXPW5Zsg1YZ7iIBhSckO381Pu2GDin3IBHnJ3ucsIe2ayZfNhsuoCmdWog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFWtj+EN05n/f/je+Qh3a5PCpJwVdriQlDP6l2qBwCg=;
 b=XKB8atBFpwYhyYKAgUjBzTG5Gl6MerGDFDY6NLhA6MeAb/nUqVkv0QAz59NPW1ZZq19cwwfJWY9QMB8+myWsuakLI6jlmGrnKqeS92S7YJUNkocKKkrpW+glIuPTRuQVtXcCVD2OoUrks8EWHax3wDI+VmBB/suV5mpQm+rkLEWlF1X79FkNUJdMkWBvbabbUj8MoI53h6D4RVc98paUpObsZ928vtP92GpVwHxc/tlVb6RWucVhfzDbF1rzmjzE884ZzPHxd88NezI2yvBQKtyyCKYSY487BqrVgVC0PQKHUmd1FLUIV2j6YzFb9jqjtUCF0/UmafsNFZobl4ibig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFWtj+EN05n/f/je+Qh3a5PCpJwVdriQlDP6l2qBwCg=;
 b=zwqzFpCx5mfy9YnSnjMzyEQvFG8lxMGztcdN/dxikHiAQHiz36BavTMTZPW0XKDeGPp0iThMZGwIH5asmZLLtb/flh9nwfAyVOhl3I9NMQeyjWJ3JGJOdvllBpJJBT+36eBcoi5tg6AiS2cacF3QaOE7QLJ+Vw1MDURAMp2bDYs=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA1PR10MB964822.namprd10.prod.outlook.com (2603:10b6:208:5ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 20:40:40 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 20:40:40 +0000
Message-ID: <9837bc88-da11-4082-8e0f-79ce46705335@oracle.com>
Date: Thu, 17 Sep 2026 02:10:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1094/1376] bpf, s390: Clear fetch destination on
 faulting arena atomic
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Eduard Zingerman <eddyz87@gmail.com>
References: <830fb27b-d5d3-4f7b-b074-d1b8762fbfde@oracle.com>
 <daily-reply-20260916-0027-re-bpf-s390-arena-atomic@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <daily-reply-20260916-0027-re-bpf-s390-arena-atomic@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO2P289CA0008.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:6::12) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA1PR10MB964822:EE_
X-MS-Office365-Filtering-Correlation-Id: fbcead4a-df93-4579-49ee-08df1432c4e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZI8u3eJ7M2l5dLyybg2fAUlPQjb5EQsdEvQV+346cmmCbhhh1dAJgEwQwItkOk+oG9cuRU4NBhok1kn2VguiIllWXMbYctiWhBkLIf/8kx7h5UDYBTgb4pjpONZKkvXaL8doJtG6QfZvy4Ml+40aRQxWxG1DQp45yipgyhWnDFmoOYjILCuXmDMCUKXfA3e6uuN8qTlK+HxMQ4upJICvdUyw6uMFdFpXGlZwCFwmVHn4+c74otlDPqnkPDTNBymBaloj7ATz6mbMXVs6vD2Z9dQv9e8keKPxj5dcO4w+2RlEaM7sK2avKTVG8Oo8oTnzUzxq5aGFya7Jv458Dag5a0DuSobrrOF9ejZ1H3Uj2uxddIKhVgqlqQ4PdEfg+8zkSdEKnvgXJbKZRZupBdj8bTvazCDHYq9RD1aKRwo21yDXQ+L18vMNX/K80gSr1d/VICVyhLOdAocvxy7olS8vChMTrZ1jOM1H1X83OXBqLkPuw9jbiZwBLcnMsBPwhHLEtiUDj76lqc1SN9o5oSMfx8jPBTBEwQNNRA44x9Bl3X/eI1oP7dOwZ130KEzj0Bk/btmqvtHiCoyEqWxI2vcLmpmfxm7dzOpSmHAdxBtiomzJJ7l3qgX9KIwf+QFe/jOGtqjOnQ9v3xi44Kusz9Q29aNRg7rmEypanIRL0TuT0iU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUs2V0w5MFhHVVIzUHUvMkw2cjFtdm91NTNFMFl6eFN0VHpoSE9yQjJMckpO?=
 =?utf-8?B?NnlHNWRPUXpUNWJtYmRocktVb2w5aGcvd09hTWF5Mm1OSFpSNWljSUtuY2du?=
 =?utf-8?B?aC9rVERTUnNxdTdlaUpjYnpIRkp0V3NGTFpZOGpxOHdCNy96K1NEaXRRcUY0?=
 =?utf-8?B?bmJPUHp6UTM3cWZYbXJvT1dtMGg0YVZsM2VJMDg3bC9aN1ZhVUNtVHJKbXBI?=
 =?utf-8?B?WUg4aEYxTGtSQUNqSHlZWXp6UTdUVEdISDk3M0F2a3crOG1MdVpSbzVjd2Fx?=
 =?utf-8?B?c084T0xpZ0Fva0Y4SFl0LzNoenN1L2l3RW1zOEw3QWRaT1cyYXpJWFBrVDA5?=
 =?utf-8?B?R3ZVUWJWeFRCZllpY0VTNDV6b2JWNktkb2tPbGZHb0t2eThoME9MTGhyMFVC?=
 =?utf-8?B?aFpweGp2MlNnZExnWjNuUzB1TUhpeUVRM01kWU01a214dXBlTGt5cGFqb0Nt?=
 =?utf-8?B?NmMzVnREOXpOcGRoWk1QNXQ3cUtNUGViZVl6ak8vOTNyeXY5WERyOEFzRXpp?=
 =?utf-8?B?aUx4OFVCM2VjMEJjbndhU1VoUkNrK2F0d090VUVkMzB3aWVYS3JVRmZ1SlVo?=
 =?utf-8?B?dm9uUHljdlRzWjNjYXV1SEcyeWRGVUxTcmxKU1p4QVRLYkUzb2lINTlTY1d1?=
 =?utf-8?B?aEU4SlhKQ0xQbVJ5RnRneWh2Qm5CYmN3S0hvRmdJSDJpcUtyTEtEbmllQjVr?=
 =?utf-8?B?N2NGNFhqamMrQUxQZk4yOEg2SVpPUXNUZEwwWXpFNzh5QUIwQytnTC8yVnUz?=
 =?utf-8?B?akxpODdNTkJudElvaVB6WVpyeU5YQ0s1UmpleThveTZ2dHd2cU1xR0FBZFJM?=
 =?utf-8?B?aTJUclhiMFgwdkR0U25wNE1sRndHbHlFWWFMcElnRitiRm9zT1JkeGNTWWdL?=
 =?utf-8?B?S2xsYnVSLzlaUm50N0tJUGx1MEZvcWx0T0JacFZmZHB2bHM1dkZmNzBrMEs1?=
 =?utf-8?B?RzI5UTFoc1lyUzZkQTVRUGp2TDVKbm1zTGhpSHJRVVdXVHJGWEJLZXJrUDho?=
 =?utf-8?B?TisxTEJUTEQ4R0V4VWpydStBaG9qTGNFeFkrTll2cklwc1d5ZmtEeUkweXRh?=
 =?utf-8?B?SGZjeEdiZ1dQZXpEcUE4Qit3cXBjVlJVQ3MrVkttZkZ0d3MzdzhVYnVybnVo?=
 =?utf-8?B?ckh0WG5XcmhhV2VDY3pMYUt5eEpQRUwvL1MvUnh0UEFzK0NUME8vaFBRcWR1?=
 =?utf-8?B?eU4zZHFNbTJCdXBRRlZBajNReHpRa1l2UUIrYjNxZEl0ay9ZSHh1OGtoY01Q?=
 =?utf-8?B?aUFkUEEzZ3V6UWw4T3NZMXh0aCtZU2dKclVjNDcwQnBEVithSkxyY0RjaGRo?=
 =?utf-8?B?ZjhBaVFFMUJKcWxhOExPaGxiYm1yelpkL09mWlNaOC95Tzk5UWg1c0pTRElI?=
 =?utf-8?B?cGUrR0xrSStxMlIzaHIzYkVRcitKODUvSGJWQStyNUVqVjlidWpjNGRxWFZS?=
 =?utf-8?B?YkVwaDR2Unc2N0M0SjVncUdsTnVJVlhUOU5mbXZPVk84ajMzM2E2N2hFYmNv?=
 =?utf-8?B?QW9mL2ZTaXVnSVZCaE5RVEtkcWd2V3BMTWd1SnJ0S1g1ZEcreEgwS1BoOTFJ?=
 =?utf-8?B?UmhZT1l5cGNpNTM3K05SMTdFcWpTRXRwaEc4YS9XVVNYdGRQRWNUNHBrSDhX?=
 =?utf-8?B?NVRkb3MySzNhdG0zZ0tCM1lGamtQN2czeHdvNmVJRGhvaWFzMldaYXdDbHI3?=
 =?utf-8?B?TTQ1LzcycWZDM3BOOHhzZzEyR0lzRG5VT21VcHdhLzBGelFMYXdUUmg5Mzdv?=
 =?utf-8?B?T1hGakFrWC9QVDFqTjdRK295dGYxQnlPUG5uYk5hQ3BxR2k4ZTJrS3REMzEw?=
 =?utf-8?B?dno0KzB6VGpPYTM3bC9ERW9JWUcxU3l2dXFHMk9GYjliTXppT2FSZzQvamdQ?=
 =?utf-8?B?dzFScVdZbXZxTkJ0TFN0YjMxQkJ0anJTTzFVdDg2U05qQUpHVE5tQ3R1TjUv?=
 =?utf-8?B?SlRZNXJoby9meko5cC9BMTlzSldPVkx0Z0xSSkdmMnErY3pqV1VxMTNzWEpT?=
 =?utf-8?B?YWJIMnBKWXlEaHdiUFZVZjMrb0Z5RGVtenExenU2QnovditPaVNnS1Jwbjhr?=
 =?utf-8?B?UHpydGh1N25GREF1TlJraTZGQ0N6NmxiY2wyOVozMHRSUUlmemkzeTVwWHd6?=
 =?utf-8?B?cDF3YWJ3V3VQVlNnOEtQajlFYks2b2c1QUFoYU1ENEdKdVJzK00zTGRJNXk3?=
 =?utf-8?B?Y043aVBiSmN6N1o5M3hBTElRTk1JTFVSeXA5ajg5NmpSQkJoRittWnVxSnRW?=
 =?utf-8?B?L25ubmtEdmt2dkxZaHduWW1FZ0JueXJJbExzUHdmTEN2R2FoWFlCS1ZyYTJk?=
 =?utf-8?B?bkJscWlPME9JdEU4TVlYblpDYitSSlNjSG9obEE5SjRMNTRZWkxPS1VPRHRE?=
 =?utf-8?Q?OHFj6C4YIrTslMt0BLG0g/zimPjpuXe8I/l+x?=
X-Exchange-RoutingPolicyChecked:
	kgve+p1qRO3wO+FCzj0+xKqhE8GEVex6VHUx15HvPKbWwVX7UTAnsHH4DH1bPs5BRFKIJMIiy96CV7cqsn80K3Jg8ndEc3VmU0MGU1v3QG3l7bXVkx1szttDBo/b6/OSz8VaVrVFuW0UfSQVSEFw8mkOp2e66cbdwGxsArnbmL3aNUOLN4T+hWtav0Boh+TXrWlnvdR39x80SSueZf66UMJ7kiXjKX5AUopBIGlmHLn7F7PeQpK4pQj5b4L/VipwopU9SwUt5RchVWafoby5NyD7S3dP2F2R2lIpQartcqh8DDPzeFSck90wB/HnGky9xjqYZ6HVCwUS8VZcIcuLWA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iFLGq4cDwFAuo/dEtzNteZ73PqTyZcEvSz4M/ZTblwZs6OJIdXEXWUHIccQMuh8QU4+IPAtSCbqiEv8q3FaVf64sSqPxxb5H5Q555+KZbyI36g3fZW9pGi54k9Wz7tTR49NHkd/QzWZ/B0GjTAeQzcNinSHqYV+LNhLtStsAsRXeqzkmAO2sdnClb0dYiLe01JIzdV2NtS72NRljleW4oBkdGrE0FVroeJQ88jjdRZiquW4aiuNl3TscbSanIvbCMPPaFgdtUHrlvWLWRPD0eUJpHf6kL58tAM6fqkXFcl8gYda79qgFq4lFXSsz+SLxTUMpeReF0vr07lACQeGB3RuOZfnjcxd8+G+ypta2baZ4hcZWvkIvsuQVjmMWtKoQr6HUbuUAbcljzXsqOysZZ1AQaSUz9O6AVuFZ1vipAZH5/AC+GQdwD4YDSMySsCqpwmUUOs7mwZrWZdU51/9N9YcnIZONtwL8uhA4s1LlkEVOhvsd4HoEjCOdRO8qAx0V1b+RnxuoeOmYD63Pg7VoPwCrRyFc/5EXDucNTGdZmc9+o0Y/geW84McmOZf0w2gtGWeg3PwPL+yLljyEBc5SAIEHh9Ax0XsYMPHL3hkKavA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbcead4a-df93-4579-49ee-08df1432c4e2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 20:40:39.8616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /W5+iixAibvjdehm8V3J3QryUWIjEXzNbS222ncNJ4xyVe6K6dcm94URk3R7JzKHmttfpl3OH1i83+l6V9QNmvGQHpvEUK9PLu7T+XBPUmHc1dRFcwVblJuCgeFJmcZn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB964822
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160286
X-Proofpoint-GUID: ZG_6FMi6WdhhNUHFft2a-XZ7ShEsijTq
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfX/xKGAk5xowXT
 MNNBDD3asKNS9UM1vZJMa2QkuddSPZ6c6kZhoB3vV8n5nbZBh3OPzHBPCQw97O8mtI5J5V3rcoL
 cnIlLCMOvgRTPSazCBOi7oyyZMwAM/fUTHZq/SG92/QabxD5PQls
X-Proofpoint-ORIG-GUID: ZG_6FMi6WdhhNUHFft2a-XZ7ShEsijTq
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaafecd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=JGHUlJHarIuP98CAF0cA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13532
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfX/sVvuJbbE1b7
 fzzyT4HhIHhHSfoo6Qhu/TDxE2jhBqqWFCJZkSoLkI7lnf5m88rGjH1TVRJ1v58ZBBVvQDvr3lY
 jUAj3iJarXon6ZML00vJQSu6/5qm7CjBxQJIRlq+VIFSNQ0aYR9PTPabd0z/+/vS3sFUmdZk42N
 Nw00RtXZaSn+f5LYM2T0pY5UWvfZI0aMmeO7PsaG1zueJ4Ggln4LpH+A5IGuv0Pk6nj8q2HfJvc
 pXUsD+8/W5N/vcsgJeJABPVP+UScqQn89SVLEhuHuY+kmR/Lezbx/pnD3B6b5i3rUrz0FsCjtRO
 mYAnES7k6F8LGbTpddV/FGgoPo3GaW0UbXAvODL/DTPaJto+M2ZLyW+RKFmk/T2IwqejqnL5i9Q
 4KAnWdBMv+VS/cs1L76yqkIS1yNUzojp5vAdJFe4e4j73tcz3D1TxcZ04uWcsbVVazjILDU8Q2E
 8eBwONmqETjCPtkfN/iMnjYY6BcwPyO6OpS1XrbI=



On 17/09/26 12:58 am, Sasha Levin wrote:
> Already handled: the revert of cc3e12330599 ("bpf, s390: Clear fetch
> destination on faulting arena atomic") is queued for 6.12 and goes out in
> 6.12.111. 6.12.110 did ship with the break.

thanks for that.

regards,
Harshit
