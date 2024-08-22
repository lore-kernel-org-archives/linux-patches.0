Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F5938F9A;
	Thu, 22 Aug 2024 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724345576; cv=fail; b=a0aadQwFTSGWGLAFt5EJOU3GutZ6Pg7/2IK8X5VBZi65FLnlSbarH27+Qb0vOuHYu9t0QRVeuFcxmsKuj/95Odcbf9boi/LIKlp4xWgooQr00QPXeUuadgUQcQ1qHYChevyG68d7b1FxRurB7LYGOsoFxbg6aXXqAOeXfkTa0fM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724345576; c=relaxed/simple;
	bh=gVzTnjYG8xUUyddh5QJ7+mm8TKHiHWEgtw4+EQBLfp0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s+5wZ7zhnLyPfPLwLyWgqa9uC10NrVjLpvl3v/fr+WhOCOMHo3iKdlRcRs35Y4HCsU6aTFnqRLpYRYwSMS1eEu5SMkk+2nv37dZYMMXBfWuyS21+wH5PTOy8PZySWd7uTWvoz5YU9uww1t8qWImopq2L2EhuqckqbieR3l7gzsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oKmuPzEJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OxVFLzVi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oKmuPzEJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OxVFLzVi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47MEQWe1006140;
	Thu, 22 Aug 2024 16:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=zR1m5fI8fnxLJGQ7yM72imqSBxWjK8wY/RC5Jnr+cmk=; b=
	oKmuPzEJmTbIOopYn17N72PXk5V+xmZYHh/VdeYGTxbSCBgdhqQw6PiXcoblyMnk
	nuAj4lSAGxHYmCzcux+77L9sdZWsl/tRK920lQ7H0VFwHwld84U67TFqUjIfuaVp
	/5sU3WaHe0ywFXtQIK6S0deTR0aXgg+1BnGKb8fXo4iu5EEGEwrN4eLrS8mV77v/
	2PBJFTPA9QE2yargmjY6VJ7iq5vfBIR0empBxXMbSPal69mGad4OHMATepC3lzwu
	FMGDWaY2dIu/VH9fbATG+7wX3tZyxzIpiZCMjcL6+hiz0S2fsoblOw6ZqExmIZsh
	x6btn1dBdibpQ3U3LTv62g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 414yrj4sd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Aug 2024 16:52:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47MGiBxL021192;
	Thu, 22 Aug 2024 16:52:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4169450awn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Aug 2024 16:52:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DQGJtlGAtIAmUsKzONZXgSCPC2OidPoW4USBGJmyYFfyP+Jj6CLTkqG9SPYA41WsYCs7Fa3q2AoXoUoackCFD+eVB1n/RVGj4uD1JqXWt+DrQFDVhtpYOgMSZp+iqfyjSAYL0JIi4RU4VrpwYCN3fyduDE3m7Ajc/A//c6xBqxqq2b1nVh9hwMrzKAo28uxxTWdQXyKdnRnbDzYk6wJNs2Q2dB0ofq87q0EIlRSHg5aQ2r430ZbD4zOuiR6uSqlIaFFUl3MBn7yGmC7E7LaLJqt6jOmq/hrMcl3bNMyz378dyPXKSNO4oP1COivSuF2AUVI75dHe4WKzMc4hv/DvcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zR1m5fI8fnxLJGQ7yM72imqSBxWjK8wY/RC5Jnr+cmk=;
 b=ySlwGusfKLD9okqBrhnAq0C3uAKxWAxqNhJZp1bGnELj+IxU85TES1MedvablzXe8Wew6VlcbMxbdnnF7S1QhK0X/1tRPZSn3dlth6OnKQ8LnKj4VYoysLvK4Gq3ABtWfrTunUZ5nZe0aoPQ3Aj1lnNQ9wD62RoobI8F/VE/gRapY4y2INgjOw+3HQQjvQE9D7EZ+Bov+vBhtlSmJGXKrcazxLdg2Cym9mj+7YdYtmSkagYWZBnlcptZRpX4qceIgm/ll9ZDdxoKWnNFLOww4zkUEwulqujjKrfuD+8WzfTXdE3DwGIUxPmw5Ksd7iyTdtjVSsG6swJqnL/45hIVPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zR1m5fI8fnxLJGQ7yM72imqSBxWjK8wY/RC5Jnr+cmk=;
 b=OxVFLzVivq4DDZQgeWgtzfhajZuaABfa/5P9TyVkqaxO/xWqFaNFZdwxVf8EsDdR/VqlJlQXqWaIFwFxXG8ET4qElUjVtK8UypvhmPWCcm7KsCB7hTUx5pF46n7BPA8Wv/Djaa91NWkXshG9SAWGMZ8Ieq61EMSZ0kVEHKsNDtM=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by PH7PR10MB5769.namprd10.prod.outlook.com (2603:10b6:510:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Thu, 22 Aug
 2024 16:52:33 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%3]) with mapi id 15.20.7897.010; Thu, 22 Aug 2024
 16:52:33 +0000
Message-ID: <e978b42b-3077-403f-a5b0-7da6b52f29d8@oracle.com>
Date: Thu, 22 Aug 2024 17:52:26 +0100
Subject: Re: [PATCH] iommufd/selftest: Fix buffer read overrrun in the dirty
 test
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev
Cc: Kevin Tian <kevin.tian@intel.com>, Matt Ochs <mochs@nvidia.com>,
        patches@lists.linux.dev, Will Deacon <will@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
References: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0057.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::8) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|PH7PR10MB5769:EE_
X-MS-Office365-Filtering-Correlation-Id: d632cdd2-68bd-4433-6634-08dcc2cad179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TlNvb0E0ZlJkMmE2dEtsYkRHODdmcW5NZFBhMjdFelJxRWl0Wk1xVVdxQStq?=
 =?utf-8?B?czBDajF2cDA1aEdKd2RUT09rOW91alYxMGJEc2VGbzZDSlhFWUFPUm5lRDZX?=
 =?utf-8?B?UGZGQkl2MVZGL3pVUitSOEppT2VCbm9BKzh6NzBrU1o1WEJQV0R2eEZMTExU?=
 =?utf-8?B?VmhlUkdjaDBYY2d4dWN0TXJwaCtwRHllOUdaZ0tCaWhaWG9wNU14Y0pZSmxN?=
 =?utf-8?B?alo3bTlzY1BKbWhtcmx4ajEwZnREb2xyL0V1YVZXL291MWc4bnRmaUhlUFNa?=
 =?utf-8?B?ZVRBNFhobDh2cGQxV0hKOUxqZEVQTk1SdjJHVVdMOWVXUGZKV1ZtMFlqZlJt?=
 =?utf-8?B?a0FobVo4Q2RTcTYxVUpNamlKK0NUNVk4NXA2VDVKSE5LRlh1UVJ1bmdNY3Bh?=
 =?utf-8?B?VmRSRy9hdXQ5cFIydGJ2YWhqSW1VSUJZZzdNT1FKMS9KNVBuUVZlT3d5V3Iz?=
 =?utf-8?B?K0ViTTg2OUhZWXBtcy9heUlJd1FzeWd6alJQMWRBOStNcSsxNk5kcGlZSEJJ?=
 =?utf-8?B?aUVEZFVsbHVJQlQ5SVZIUHZaQS9CQjZhdHRrRDZmQlhwRm1oSDNnY0NES0lJ?=
 =?utf-8?B?M2JZNCtWd2tCeXV5MDh5cGJWZitkdUxrdG4vN0l5NWU0anNNVFRjM2RSWENl?=
 =?utf-8?B?cTdnQ1NHUlZUQjViWTJWZlhtejNkR0tRVmIyTHc1WkUxVW9LYXVjMi9YcUFz?=
 =?utf-8?B?L0JCeHp2bGswWmthYnNTKzdIb1Q1dTZQRFdFMkg0RFV6YyswTGRMTCtDd0tM?=
 =?utf-8?B?VXZ1UnpjeGkwWEExQy80SHZPd085QzRIeGdwSUlOUkZXZ3F6bkh0eUR3Wlc2?=
 =?utf-8?B?Ni8veFphNEI4QlpTQks3ME1uTTZXb1hpazBrWXdKYlI3YTlYSXhLRVlxSmVl?=
 =?utf-8?B?R1hDemxvVEVsMzRqd2FPa2JmQ1N3NUdIcUhsR3hYRU9jaEtoY1ZkTUtLTnJ4?=
 =?utf-8?B?MXR3aGZsMFRzVitiZTF6Q3RiNVFHWGVtWXltdTZxa29pSXd6RzlHS1pZNUw3?=
 =?utf-8?B?TmFFc0ROQ24zNTFTUUFISENGcVcwTkFZTEQ3S0hYRDB5QmwwczFoWUVhRm1G?=
 =?utf-8?B?RHFzVmE5S3hkREtTQXVlUEdNSUJsU3dGZjhMSnNLZFZ1UUdHOThwVWI5cDJR?=
 =?utf-8?B?eHJyb29EM0pxSmFvMlZPMGtueWg5Y05LK1U5bFR1ajluV20yaE1hUXhkOVlP?=
 =?utf-8?B?MnpVaFo3WlFSOXVoSXpQK1V5MVVpSmVyM09BOEFreU9LbE1VOThEUXYvMlIz?=
 =?utf-8?B?WXhsSXJLb3VnSWdMTzdiR3JrTGRlQnBBcGYwRm9VNEVXVXd4cG9lZllsYjZZ?=
 =?utf-8?B?dENKUytRSGxUd0VCazZLbTVaMERxT0l6NUdIdFVwekE3T2Npb0xvMlFqV2FJ?=
 =?utf-8?B?YUNiU2YyaTNXVUN2ODNpbXY4L2huUVRCTUpRY3BleXFhR2RaQnpVbWFubmE0?=
 =?utf-8?B?VzFKQkk0UnpsVE1BamFaTGxrRTI0ZSsyT24zTXBVeFpUZXUvcytuN05oMkhl?=
 =?utf-8?B?K2ZiMStveWZ0R3NBcjhIRW1pRWJvMXFjZzBYbzExSU9KRnNkVDg0bGRid25q?=
 =?utf-8?B?K1NiRUpsaHhGRllKQlh6SFdnSSs5OWx2cndQQkRaTUFZdEh0Mm8zSVFjdGZz?=
 =?utf-8?B?Q0pBKzUzVTdvMDBLaVZzbndhNW1taUxkUURXR2NPRXp6VW1nVEV4WS9McXJG?=
 =?utf-8?B?d0JJM0VkdEdKWHluTHoyTEtsYkh1VTJQVnZxSG5uT01JdjRiNDNnY3FudzJZ?=
 =?utf-8?B?aEZnaHBjeU96eGgwVXBQdmhDQVkrNEIvNVIrQnRTZi9tazB4aVZTMFl1b2lr?=
 =?utf-8?B?MVlwcXhUM2ZjMFpNbnRwQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2IxcE5IbFVzV2tDTUJBaWFNbTc0QXo3UmZWdjRWN3lDY0NsWFNpQ1pnMHV0?=
 =?utf-8?B?SS8yTnY4L1poOWJITjRiV1FmbEYwN3JNcmhhV01WMFRGbTdRTUUvbjc1UkpI?=
 =?utf-8?B?anpncElJTWFwQmxUWmsxbjlMV3krUUVnMXcvN0tFS3hkQWg5S3I5NDZYU1pG?=
 =?utf-8?B?V0FEWGlEKzdGUW1wU0JwOFY0U0NPbWNkQ3VBUjYxQUZQSk5iTWtUTWR5WnJP?=
 =?utf-8?B?NCtTT2hXSmlWYkZKc0I5Y2ZMeXk1Tm40YXA4SkNvZGdkd2Q3eHlHNUtzNzIv?=
 =?utf-8?B?Q0xqQ1g1ZkdxZ2Y4RTU1TGorcUhrcUhuaDI0eDEyVzhYVVF5S2tDZDRYVWFu?=
 =?utf-8?B?VHJqeE42ZEhtZVJJTjJJWnNYSEhzVDh5S1B1VXVFa3prSWd3Q2VRU2hvVTRK?=
 =?utf-8?B?WmdZMk9vZTJWUnJFZ0ZRN1MzTjlLNWRhRnFiZEdmc2hPSmVTQ1Uvc2dvYmRl?=
 =?utf-8?B?ZElyeVFjTlk1QXZ1aHFPS2JOelFydFJMRGlhK2tmMjk4Y096eUduOGtDakNn?=
 =?utf-8?B?N2wvMzFqYmhXV250UVlTWlVDeTR1MXRQL2lyWlZXdDBxeTFwNE50ZDM5eEF6?=
 =?utf-8?B?ejdJaHZzaDFXMUVCNStoa0wwOUwrei9hUW5EUGdwR0NzTzBHZi9qTmkrMUMw?=
 =?utf-8?B?TkpoYXQzSDJZRGc3UjczOTNIRU56WUV3bnRiUXJmK292L29OSnFPTUJ3S3d6?=
 =?utf-8?B?emV3QnFKVzdaOTZJT1RJaXEwbkhISGZIb3lGYU9TRjdudldLaDYra0FSV3dB?=
 =?utf-8?B?Q0lUZHpSeXNsczZkYjlxajU0bS9BNXdkT0V3SXNLT0w5MEVUR3lVbkpKcVdl?=
 =?utf-8?B?cGMwZUd5WkNIeTQvYkxzVDR1c1NlU0dPLzVvUGtjTkE1WDY3bGdOK2xsNmxp?=
 =?utf-8?B?ci82U3V3YUpLYjJvQnlMOFhxMWxqaHJWZEc4K0VDZ3V0SEVMYk4xRXptREYr?=
 =?utf-8?B?L3dUTUVOUWIveFEydzEwbUp0ekdwUllZU1VPZWQ0ZGNKMG9lMTdFWERhVWlz?=
 =?utf-8?B?SjBjc29nT3hPZWxkb1Q5TmNncmNzUXZLV3gzNmVkVDI2ckY1bGp5WUxMNFFN?=
 =?utf-8?B?TS9FSTVlWVlQeWRqN3RjUEQydWdiMUM2REFpY0RkK2hOU3Y1S1ViSnArMGlT?=
 =?utf-8?B?WmlJaG5URFJHUHlwMDJoVlZvMXRKcndPL2NwVE1WUjk5RVJUb2dvb0lNSnhq?=
 =?utf-8?B?L1gyaWkzT3BXdHBJSE1NWm16QUNpOCt6WkN0Y2oxaGs1ekZXMWdaV1BEYTIx?=
 =?utf-8?B?SFBhd2o4eUt5VHJJM3h0U2FRMlRrTlRXa1FlakRkaUYxSlo4akl2a0dJSUpx?=
 =?utf-8?B?ZHRBOEVLcFF2TWpBUnpPZFJiRnhDeFVyaTNHWlQ4QzNybENxUE9JQmdLNmZW?=
 =?utf-8?B?cGNhbjNlUERZbEpXYzRwODZCaU80K2hWcTVwb1RUSVFrdU9xb08vQzRoRzZp?=
 =?utf-8?B?bWFwcDU0cG94ZTh0cHgvSkVoeXY3R0RGbnVRditDSzFNOEhxUG9VWW5GOWhW?=
 =?utf-8?B?MExqcHNnTDVtUDdTZldNZ3pUb2RzRzNaNzZVSkE0S285a2V0RDZmWFl4M0Rj?=
 =?utf-8?B?UlJ1RGNyUlNmN2NOVm1aQUxsSC9ZTEhIenU1allTZDZVdUZrL1lYRlpGWTNF?=
 =?utf-8?B?ZzdMYUM5WTZ5VmdUWndJY0tHRDBhWkJGeXUyT3poaUJVOXdwakVzYUY0djhx?=
 =?utf-8?B?VW44REpBL0ZaWTVocXpmOTBSUWg2YU83WjM2ZlprcDJxZk1DMUNXMnkzMWtT?=
 =?utf-8?B?dW0wcmJGc2pMUitSUFprbUhWRTNpM0g5K3EySThmUmhWSHltTEt6NE92djJW?=
 =?utf-8?B?ZStNK0QzZHdVV0dzZTV5Yy8rbEtETkg1dXdtcFJqbUpsVFA0TnQ1YXdLTG9V?=
 =?utf-8?B?STZYbXpEdlBzbnRsRVVLZW1DUlFidWticjF6NmYyakM5cUVQZGFrZmJ5STd1?=
 =?utf-8?B?UExKRTRGaHRjUzJFaFMzbGtpU0JkNDM5N0NPalZKODdVY3I0OE5DZGlsZis4?=
 =?utf-8?B?bWhjeVlyWWplclRCYWhTak55ZXB5UjlRR284Tk1xeFhpaFpMSmcxMyswVXhx?=
 =?utf-8?B?aWxuTWtVVGVieThIbDZ6dXlEOEo2MXBzZjRhaU9ZaHY5QjVvTkQwUUYwZTNm?=
 =?utf-8?B?VHVTZGpzelY4bWphcWNVTnhqakFYYXpmWTUxaGs1WWZ2Vjd3eHUvRVVxa2RZ?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UL/zCMFYJU1GH/C/R6qu9DUpUsosGHub1d8NIRXyc5FkL/oMymQ333N35zrW+EC4G7Z6zaeqvYYWn1J6ocHnfh1J4e+EOCFgUvNcX50IgkM8uO2up9pk1YXLYxrKc7HpdNA+sgaJPSstgewVn0k7rvUTmswLpn5W3FTVK6VpebJ2HXz2RevQl4kCr6Iu47M0pt0ql9mlXaL//DTz9SqxoV1odPhLgRkLg6FzCC2huCSYXX5vi8rW3xNl/lL9i66qhiFECFrlAF4vygHQnu7h60vrS/BpFI/kqIt7nqOASSzv7G8S9cglV14Fe+OrWPWVVcRkbgqP+IjuErJop9UqoGT6WOs7rw/i3iLtKtzZPWbePO+wHVyy0GDBtfqwvkTRZpDAFlDB0LtP9Pz4R9+beir4usYJy9rYLA9UAYMLaBb13TgED0TgQyHK6sf+u6eP5i0rJYSHsg80Xi3vp33U7+0UFXiKK//FV75vLU482S8xUO88hsO2PjOGUbJWYzEYGg8jeri+659C/eT74AmJ4yHWrNiSSTDHr5w8uoUZN/k76/8vWna1g5ipq9ot9dtKFLyI22ViIizqUHO2McpcBgyyMUvjVkWhaAAT3H6ycEw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d632cdd2-68bd-4433-6634-08dcc2cad179
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 16:52:33.7616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oNEQpp0/pp+gJKAmPPGqP1xtketCbxrohAgUgwHIZLMO884hyIMewRwYsMOF234vw7UW4EYwgv4f0NKx0gS32Z5m+qQSBsZspuCco3sKpAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_10,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408220126
X-Proofpoint-ORIG-GUID: RjG0UbLMAJGdYJ17W6Rhjc8ZFA_ly7wC
X-Proofpoint-GUID: RjG0UbLMAJGdYJ17W6Rhjc8ZFA_ly7wC

On 22/08/2024 15:47, Jason Gunthorpe wrote:
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index b60687f57bef3b..c360d5a7675921 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -1342,7 +1342,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
>  			      unsigned long page_size, void __user *uptr,
>  			      u32 flags)
>  {
> -	unsigned long bitmap_size, i, max;
> +	unsigned long i, max;
>  	struct iommu_test_cmd *cmd = ucmd->cmd;
>  	struct iommufd_hw_pagetable *hwpt;
>  	struct mock_iommu_domain *mock;
> @@ -1363,15 +1363,14 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
>  	}
>  
>  	max = length / page_size;
> -	bitmap_size = DIV_ROUND_UP(max, BITS_PER_BYTE);
> -
> -	tmp = kvzalloc(bitmap_size, GFP_KERNEL_ACCOUNT);
> +	tmp = kvzalloc(DIV_ROUND_UP(max, BITS_PER_LONG) * sizeof(unsigned long),

If you keep bitmap_size then this gets to be a one-liner patch, but I assume you
want to remove bitmap_size anyways.

> +		       GFP_KERNEL_ACCOUNT);
>  	if (!tmp) {
>  		rc = -ENOMEM;
>  		goto out_put;
>  	}
>  
> -	if (copy_from_user(tmp, uptr, bitmap_size)) {
> +	if (copy_from_user(tmp, uptr,DIV_ROUND_UP(max, BITS_PER_BYTE))) {
                                     ^^ space here after the comma

>  		rc = -EFAULT;
>  		goto out_free;
>  	}
> 
Regardless of the first comment:

	Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
