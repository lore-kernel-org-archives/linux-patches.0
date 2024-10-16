Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46740191F83
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 09:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729070567; cv=fail; b=ZEBhgLcoijaYkpAs+vwW7qceByU712refunVvkbex02hWAwcvW6adIKGLLDDQG/t4G9nn2yDFjHvy2d1jk1voXE/DqBftX34uHKSDd19MoxP77jZBxSiKQ1m9z2SHSelu4yhoRCCr1gnufoTBcwmObyN2GtRwumhBNL8RwkSqeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729070567; c=relaxed/simple;
	bh=xDVHluZV1c4NIaqK/sI5+jiUgFEImCuU/xuRu8DvXrk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ayQgS7oqE7Rv6XOamwAcU/swdtjER2SLW4BHP/RonFdUBFGMX56S0uYMDpqrGfyIST5hTG3R1ceq9iuV+hLxjZRtxjyh6THVTVMG3ckLDZ9HUFI9eNCOLhZ5+/5HiU0i0e6bpQnHQkP65g1a0xuMqGmhBemDjQ2k2Sq2OQi49Ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H7SUmPS+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CU1jRla0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H7SUmPS+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CU1jRla0"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G7fdOG008081;
	Wed, 16 Oct 2024 09:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=yF11BPVIvlMqixJlrC757ufXGpPUc45xxC/dw3ABCco=; b=
	H7SUmPS+u7Z4nWuiNueJ8SuCiKoi44NnQ8mEQH/AecvMAwRmJ3lfaoAhbWPVlBmX
	4oHVbGVbtfKNezfIInN6w+TuLo+C8n299oTzS+eGUP4NnjTEh1HJywApKJM0S9qe
	iwg1jjJvzUXaHPTnIKPDyaijvZf4ONL6jckyV5UlkwuZHuSA1a99AyU5+9n1teWO
	M59++3ISkc/w5BLznMAOWVXZBxy/u0BNgE/AMDNEQ/XtMd8CY980tglzudIr8MDg
	HFnOQuLxbduhy2+t8XRhTbbeKXBHe4yzIo/NTMxD/N8bprMvcoxWJ/OHUbJEo+xO
	3AoLkXEAOx45LVFtOVaKJg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gqt39m9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 09:22:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G92mUM013984;
	Wed, 16 Oct 2024 09:22:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj8jrnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 09:22:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y1eT30FvyuKQ5QM80/PxMRYn5WP7gVbDwQmMsrsopAOECCwNcTM2Pk7WeThHlmzlTzHHgkw2+ahSfOHJkA4sgr2MxiTpFIBB7LrnpflS41ElH93rwYco+38D8LcH4NunSq1rwoiSNr1vawAhl10+ZyeTERbvMWi1CX8/jcYhACSGe2nQf4m0JVTT8koeZnT7Lo5zRlbaKmL2yt5kJXtfY8uLH0vyIf6XTl4W2vwStn8NFizrr77kc4hOdFz1VreIShKt+55rQZvaFJNL5D/FA2NLCZ4Kls3AIFsgba1dGUoxdwW5AtabKLuiOom7PcoZYQe1qifuSrCEhrOGHqm14g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yF11BPVIvlMqixJlrC757ufXGpPUc45xxC/dw3ABCco=;
 b=U01RKV9ItuX3C9EBLISwBO6PW1bEkxtGMd/o7IxqHDJ6ggjoLVzZ1LBRtIxFaPH9SuxLw8BKP2HiTbSD4Uob3cw0WWiRrOnRIhi4MQstRGB4MCJBm78KXT994TtGXZlJSbzgJTp/g1r2krsox7cgQgOGwpOKekrX6KJHuffvQbM0VL3KXeoq+ct5QJXIVPaYuhpVH3ND21g6O1YFNmQq+cWGKDJDbTu0vGOzfMX+NnsYKf3d6XEHBFrL/mPEFy/9b+OidGmHPwYlteu0YPztcSNSK+HA1qSFBKwG8KgrT2eTd/RsnB4HpK9umTAnOYhrzktjfy7j3BP5cNptbvzH0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yF11BPVIvlMqixJlrC757ufXGpPUc45xxC/dw3ABCco=;
 b=CU1jRla0X7hOGYXA1DakbeQ9Ct6+53dUiPAYGRdVVjomgP+TTJzn/V6L3nvPoUFTjiDR4iuoUjQyzIxRh1JS1UE/bNLXtp+L8LJQU6xZfF8FE3nXeJcfmfbtTD9RdLwl3le5AJm+hOicp/hpBHBgZFRiRSFk2w0RBPEIT7all3E=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CY8PR10MB6609.namprd10.prod.outlook.com (2603:10b6:930:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 09:22:31 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 09:22:31 +0000
Message-ID: <b993840b-6610-43b2-a6d1-80d0bbd1286d@oracle.com>
Date: Wed, 16 Oct 2024 14:52:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241015112440.309539031@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0049.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::13) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CY8PR10MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c0802ee-669d-4309-8030-08dcedc40f7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmQwQVEwYVFWVnJsSllHazdoUDF0eXhmSkdVUGQ5TnVkT0hSS2JOZW1LQlJ2?=
 =?utf-8?B?c1dIMDNmc0FSMGV6YStiN1gwM01mMU94MlE4SElvQUt2Yi9OU1hOWWxGdkxy?=
 =?utf-8?B?TlVBYzRSeDZCN0FZS2JERUt2SFVvemk1dk5CZVZCK0FNZ3MwUi9BVWsvUC93?=
 =?utf-8?B?UjByUTFzcGlRR2dEcTh1b1lsc0tVcU5Sd3lQYnRUSUtYcTVFRkdsZ0orbmpy?=
 =?utf-8?B?Y3VHenhrVkJ0U29xNno3YXhqVEt5VXZjUERIaFhlUzVCWFRQZ2t5RGIwOENM?=
 =?utf-8?B?TVQ5QTM3MUplUkRWWjVoUS9KZHRPQmRBZmphWXg1U3lJeWc4c2wrTmZuenF0?=
 =?utf-8?B?eHFVeERUblduZVlGSTgrVldNc3RwQnBaOHBFR0dFTnNNOU9xTmk3U2sxbFBn?=
 =?utf-8?B?aWJ1MEQ5TFNCdEJQTjlXSHlKZzBieTJ5V09EZ3VVeHo5eVFCTStiS1hvOTd2?=
 =?utf-8?B?dmNpZ3o1dko3T1l5akhlTVBSbm9uYUlyRlpUb1RBQytCblB1UjZKcGlwTHpu?=
 =?utf-8?B?dytwcUltUjF0RXE3NFdIbzhXbUVxWFBGeWhwSHcxeTFwL1lGN2dIQ2tlOVh0?=
 =?utf-8?B?QXI0YmNCZ3NqWi90YlppS3FYRWdBK0Q5ektiUlBaaFA2S0FtU1YwVEVlYVVm?=
 =?utf-8?B?b0Exc0Y2UlNzQ1FMN1dLRXpsNXBpRGZPck54SVJ2MlVtUzVlSUNCQWtCWk9C?=
 =?utf-8?B?aFc1WmQ3N2I2THoxTXNPYS9OYXdUY0o0VnpXMlczMTUxcmNGVXpDZmQ4TjRC?=
 =?utf-8?B?bTVvMy9UV3oxWklRR3gvMEhiaUNoRHhiR2pYWFBHK0FZMzhUWWJLdTBCcDJD?=
 =?utf-8?B?SHQ3U3hZMzRicCtFbEgzNXgyTnFPN3hKMExpNXdDclBOSTdmL01KTU1rQmRX?=
 =?utf-8?B?TGVpcnlBa1ZBcTJmQS94TUszQkhCMXNOemJ2REdxckRLQXQzTHAweitkc0tF?=
 =?utf-8?B?WE4wOVRoM0VGd3hlYWJEMXVHc2xiUnJmbEZzSjMxNnBCd2pBbkxkVWtUblpy?=
 =?utf-8?B?c3YzYktRWjRPd3IwU3pyS3VUQzlwR2IvK2VEd2sycjZxNHpDYUxKUWVGaTNZ?=
 =?utf-8?B?RDMxVmJvWFZOUjU1OWh3TFpwd0ZaUSt6RE9EZTdyaVFONG9OVVRuRnBaMzJQ?=
 =?utf-8?B?MEZycVNaS1prSkcrRkV2NFhRd3NLNnFnd05yZS9vYkF1aGdXdFlNTG91QzZ2?=
 =?utf-8?B?MFpjSHBZTmw5UjdjeDdjbGNvdDVZVnhkYW05dUNQYWZ5a3lrdzRSWkdLU1p0?=
 =?utf-8?B?S1U0U0lOc1JReXlUc2paQk9HRUdrcEFVS1IyQXRNNG95WXpJbnZCRmV4Wit2?=
 =?utf-8?B?ZnFqNnFiaW5PYkNGL0VsRWRLajdYdnlFZXE5WVVYVUNWQVo4eXR4QjkrbzJS?=
 =?utf-8?B?OGd0MUROSURJdTQvSmdId1Qxc0VhWVhISTVWVk1iMUV6YkE3WUVtVmxrR1Zk?=
 =?utf-8?B?SlJCYXZsZlJmNDRiWnozSFdqdU10N2RLdURXMWtRajhxWnppMkdJRmtINUZq?=
 =?utf-8?B?bFBwKzRzQzE3Q1c4MlJrUk9wb1hCOUJnYU1WOU9HZ2ZFT2FsZW4zRzlrVGxL?=
 =?utf-8?B?RG5zMmJQS0dLZERtc2ZsVUtQOUhYS28zZXpnaHZvWkloN01BTGZDY3gyNUow?=
 =?utf-8?B?Yi83dWpGeWZIZFU3ckRhWk05VG5UdUtwNXRXZ3p1M0dENjVjWmhWTFpYajYy?=
 =?utf-8?B?b0N4K0J6UnY2ZTFuWXV2S21JR1pwM0Ezd2tUNkhlQW5BMEtTR0xVUFhRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUVoOUR6T3lMVStJaFVhS0Z6cnArRWdNdUdzUXFDeUoxVHM5T2dmNFRGTmNU?=
 =?utf-8?B?Y1h5WGYvdzBHM3lWKy80L1d0OGthWWJHVU5KMmtMbnRpNEM3Ym1OU3dpVVpE?=
 =?utf-8?B?SDFOblpPVDAwZFB3SzRka1ozNnhZVTJyVXV6Ukh6b21GOG55OW9ZYm02cTFT?=
 =?utf-8?B?RHRmd0l5cmVGQ0VMOFBEOHdudllLajhCS2FBSjBPcUp4c3VsQzd0VkZNbGpR?=
 =?utf-8?B?QTBtNDhPTzkyd3FmRmtLZXVneEZSdUZ0b3FoQmJHVWhTOHZROXc2OFk4b2dI?=
 =?utf-8?B?Q1pYb2ovK0JwbzNzNlgyT0YwelJ0Q1B2c0tkcmxlRnI0ZTZwWDllaHdnZHc5?=
 =?utf-8?B?Sy9sM0xFRHJJMExtVDgvQkdmUldncVB4S1VrZDgvMDVUcjF5c1AwTjljUC8v?=
 =?utf-8?B?NVlwa3NsTGQzSzMrUFFIemNTZ2huVGZ1bkI3cDlsZFZpb0ExWlN0d0ZIZ1FY?=
 =?utf-8?B?d0VkdlRqWkFkLzhIT05PQjF5a3llU0M3Rk5PdnY5M1F1OTdwVXFsTWpaNk50?=
 =?utf-8?B?UTJ3R054aUorTGZmbEV0bXFiSjk3UERTQkhLSC82czJKUjFrcUhsR2I3Nk1T?=
 =?utf-8?B?ZmR2WHA3dVR3SkN1WGxidG9STEhLOUdlRWVLWWJKWlBuaU5Cc0hoTjUrWkpJ?=
 =?utf-8?B?b3VUU1FGMDFhWkpGVndFRkp6RUVRSXBkM1Z1R041UnY2VnoyQzRId0krYTZI?=
 =?utf-8?B?TFhqNmRKOHZ0T3pRQW5ZU3VhMnNyOXo2eFRkZGZSUjhQdWJtdFVhNFkzRnFs?=
 =?utf-8?B?UXdpN0xBdDlJUVFCY01tNzNpQnJZRVVZM3FtOWZJR1NpdE5MajIrK2wwYXcx?=
 =?utf-8?B?RWRnbVQ3eCs5cVlOWUFzbWI5ZUo5ajVxTkdETkdzUG9ETTNORVFPeVZBbzMw?=
 =?utf-8?B?OVdGUk1pTS9neW1RMTRiQXNxY3JRTVNlL1FSdCtKYUwzY1c3ZktRa1cxY0ow?=
 =?utf-8?B?dUtUd3prUWRtdjc3YVJsQWY3V0piamZQcXJsMTZJTnJlVDd6eVU0ZWlFa1Vn?=
 =?utf-8?B?clZpZjg2c2w3K29zR2pMNFhqMVVnaXBUVFl0UzZyT1QvOFZzYm1GTHg2SDNs?=
 =?utf-8?B?YUUvV1hUdmN6U1Buc1lHaUtIV1dFeXRJUVVLbkZVdHNGWXhvVjhjNFNBWm9p?=
 =?utf-8?B?a2JCQXhoRks4WXZUR0Z2QnZnbzZVbmJ6M1FtNnF6NkRFdmtFbjl5eWxRMDJr?=
 =?utf-8?B?RFROeGZ2U3hPSGUxOWk1eEgrdDNNVmtnU1NRSzlmK1ZoenBRdkZubEl1bmo4?=
 =?utf-8?B?ZHdWZzVvUkgwaFlJMzFMUklwUVhkNVZhVUNzSGN0ci9xeThXaFgyWG5weEhB?=
 =?utf-8?B?TlpUaC8zZFdWcG9RbldTSG5kbFdyLytLeVBNZ0VFbzQ5U1cvVlI1RUYvamtG?=
 =?utf-8?B?RXVLeE1zbW9ySXRQc0ZmZ0hFUC9IdVJocHBFemwveFpKWGdTUk94VUozUTEw?=
 =?utf-8?B?eVVlUTJyOVhXSytzZWxDOVFnZmNPYWRyVDA3SHVtQy84eXhHc01YQnpRMTJr?=
 =?utf-8?B?WmV5LzJENHRmMHpiSVRhc3FVc2llRHQvcjBRcDBaWEo2SUdIMURUc2RtMzVs?=
 =?utf-8?B?NGREQ0xRemlUMGZBaVlZM2xOaGZIK1kyNTRUQmxlbVowS0tNS2RJNU9KQnFZ?=
 =?utf-8?B?cGdZY2NlcTJyRVhiN0IyQTJPaG0xRDJwK2Nxb2NsZVRXakZ0aTNPQ0hOU3Jl?=
 =?utf-8?B?amx0N05VWERpRXE4SWZJSXlPOWt2bXhKcUhZUysyUGRGS1lYQXpuSU82NkdR?=
 =?utf-8?B?c1BvaXNZeUpnUTBTMURhOHhRTzRvcXNTSVBxaXpRRHB6K2VUaTJTUEk1dUQ5?=
 =?utf-8?B?bHhESU9zK0xsVUd5eU0rTGR3MjJrRG9UZkVMdUF1NnBxUmpZdUpyR3MrY1RD?=
 =?utf-8?B?QXFLTG1mQ0ZtYmZzN3JINVc2bysvVThPK2FqczJnWkxONmpwc1JEaFVlcVBB?=
 =?utf-8?B?SHFpQWQxOXpscHNIdjd5UHBpRkI0WUprYW5sQ2NPNzdDSUZWTHc1MkV5ZVBy?=
 =?utf-8?B?bG9tQ1ZKaHIwRVJ3S3pFS3J2OXNFWHJuNlIxZHd2UnBtWVlNQjJVNFk5d2lK?=
 =?utf-8?B?Y2I0VG56UGZvdGhwNWNUL2pQTmVEYkJsSXhuUW1JRDJvVldsK05FSlJMbk5S?=
 =?utf-8?B?amV2NWpqd3p5aTdPS1JwUXpyVkpOUTBiZ093cjErSGtLak01ektUcER5N2hH?=
 =?utf-8?Q?8z8XKkC1F8Ndpd/kpTT/YFM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NEYuy+LB8UMRBSOXgZ8/9J+6INPM4UzrxW9PL84MWxvQqMRd6tgS0mVwXLK5GXq4SdIQkpheLpu5LhHo3kEHtBCnpssGry1iuH41PYFszTaEv2PeHilwP9Z1pxnDwOnBey0e6bw8UWxRBHijSEH8HTf1GiV5GZzHzE+/9x5CJgN9awpKkV/wJbR+vy9sFBMrp/juRv2E0rlCEL6X70HHsYvzAbWZBsqs1XJGbDzLvvpVuMlltZA+fovY+ErxqPDWA3fWoiuGgwgYhaXP/bL55Ry3N3R/8K13g+xa7DXIIa5VzfDu0TEwgeO6a6pAbXzKyU+FS1w/37TOOtd40p09Q5WAJS/1MplS/RCTvJ6Ko6hTxE9XX/Z3f3pxK+BOsPsC35iP/ndiVhoDYU9eKBtkuBTTXJX/SDxHFUfKJz0sGwhWEqpSSaB6JMHbwWN9MiAXatj6CH8NpO9AjVvBhGX1ayrbxZct0t0IHoI/7tj4gI9ruo5wLG04HCB9yBFXlIq0uTFEOERSxkiv5gbw+bSJyvZg9ASX3hDX951P9XeQVqDjW1rdVPelR4CD6fNzro0aqziyI3P3iGvfGi06epovEciOFL7X7h3TaHn+Fq6XW2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0802ee-669d-4309-8030-08dcedc40f7c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 09:22:31.2292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ko5C1Dz6sW9T5GW2HnIZFnAqoqafGjC6Dr51nBLSqjQGTKhj7JvvongLbVtO91u9ZuqL8PGgTyIZj5ycDCgBmo5cgjs04kHVHiDEqKva8d15XFJag/CWg0YIS/y3Evu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6609
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-16_07,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160060
X-Proofpoint-GUID: xqsdMwemgqTl_qm7NvB_Zn064dvp0vMs
X-Proofpoint-ORIG-GUID: xqsdMwemgqTl_qm7NvB_Zn064dvp0vMs

Hi Greg,

On 15/10/24 16:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.168 release.
> There are 691 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Like Florian we also see the build failure in perf/ and this is new from 
in this tag:

BUILDSTDERR: 
/builddir/build/BUILD/kernel-5.15.168/linux-5.15.168-master.20241015.el8.rc1/tools/perf/util/evsel.c: 
In function â€˜evsel__set_countâ€™:
BUILDSTDERR: 
/builddir/build/BUILD/kernel-5.15.168/linux-5.15.168-master.20241015.el8.rc1/tools/perf/util/evsel.c:1505:14: 
error: â€˜struct perf_counts_valuesâ€™ has no member named â€˜lostâ€™
BUILDSTDERR:  1505 |         count->lost   = lost;
BUILDSTDERR:       |              ^~

Thanks for dropping the commits pointed by Florian.


I am guessing we will have an rc2 soon, correct ?


Thanks,
Harshit

