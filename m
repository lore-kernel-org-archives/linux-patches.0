Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE09927605F
	for <patches@lists.linux.dev>; Thu,  8 May 2025 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746721674; cv=fail; b=LYzNwJoZGd4n6E80uNMo1nVATz1YBOhwBoLqgQWnOOdhN1W6vqLxmDnswc+jHA9MPYDeJXTLVWJp384jYzcaeZpV1ZIpVYKnS88QeGHusjeEjmNoktQjQSI1ONpEJAujsIcIrZfktlj2TxMiAxo3xYFbL152FrRbCkleeBXxazM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746721674; c=relaxed/simple;
	bh=i+XuQubG0vSlFca8qWnJoaeivKr1qz9e5H/2dsgNG4I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fIG5vyCNEcJ5X14lYXC6WGldNVrlXhcAvWWKNFN4mpXi+y99OBgF1o8v3uEvj5wlRI2clgkNeeTg76Ccy80jDbR9wlf5/3lE/TF9f54OnxQpPyMDcKULEnii7WjUFaArTQ24e4oHaX0IMit9M56s+GUwslgRy2bCxw25gDdFnHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dTVGn1fj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hX834wJq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dTVGn1fj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hX834wJq"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 548G0jbb006357;
	Thu, 8 May 2025 16:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HxYEe7cE5uIulZeXC2YF+SOI4w3UUPKKWNVXgWcsoEw=; b=
	dTVGn1fjoEJZqcRz6t+GNGEZVMzs1grQOZuGBo8hvPbHMOWqowGtRjYCYCsXiHRD
	IfzlAzrRR5GoY18v8RKagK+47j2ta1L3R2hYLSulki9tIF8hxeM2bWwKlx7v3bah
	R9DDRlZwpiBfwNRN6UOIT+RFev0lVBfVYSBU1bvq9UIeNElf1Ve2ibIiRCyE/XMb
	vGmBJjtRRDXAwKrAIpb+oyo/FzI9XfhxccATnovoSN0acXsKuOghMuxLXM7EtvFJ
	e42V7XgFHh8fgiqBubR+wd1CGB7o2r/c+vvR21wufG3dPVjXdnXovIV2/rMsU12T
	LLqWntjxh+rciSRjE6Sm3w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46gxwa87k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 May 2025 16:27:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 548G6olt037610;
	Thu, 8 May 2025 16:27:34 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013060.outbound.protection.outlook.com [40.93.20.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kbngce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 May 2025 16:27:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lbkPqiT5oq5UUpH5We4o92tx459IQQrX7tiuS53Sj+jnrtvqfO3QyPRgqeT+U7CAExXPZqvbX6Z/yEpfAvIW5ukPUeqar3Yxpj9J+VKfBisN0qbdja7bsByXkgXewdP0YHjEpKv3PAJHHIeDessfsPNHbj5VCrpOG4c1kJ975R3tCaJ+/ga4oC9BwyC4jiQhXgLKdoExyTYthI9EmP6/VB5BYGPN16clCZ9PgFbKz9JxewEyymPxLjWPu35cxt0DmgkCG5fJNlx+LhOW80zZKAPVjwKoqijD1JvNGNsqpn25fiFSxAS6rXdk0latoSKgWXuRwQQQHthgy0nQYkLc5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxYEe7cE5uIulZeXC2YF+SOI4w3UUPKKWNVXgWcsoEw=;
 b=KrvMGigdf0upH3EjLr7SDFG0gF+4XvFYERkiiBuQ+dx8KrZYA4xC0vkzExXK3CaFMXYB33AXKvALqh4ypaOSKNAXHFUtad8O5pJX+K7DK1N5vItMyrx8b4AKPeXfzgrMXcXAxu7x/VOi4bm9iRSj6wV0bxun1mLNe9vWws3dgjFWOCMsAi5aw8z5JdVW7oKdmalHK/c3U5sLZBCwignmOaD0N6wI7asESF/ynkU8Q9J91Ne76WFluldRqw4o+vLw2AM6GOQ/oo8lwNRGYDOp/xpxWqLClsaIdUmIBFh7xq0Ef+Mirl/Y0pnaLr5e0Bo6XkZ2+/NB0M5NYB/FjBU1Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxYEe7cE5uIulZeXC2YF+SOI4w3UUPKKWNVXgWcsoEw=;
 b=hX834wJqmQn5zyM79JyUxvbAuubqK8KGYTipoHOBJC+MwJA1jdjj5FMRvaf4lp4ExbLgr9RybqAAakDKtA269GHNx85KkHFa1NvSgHLtQLMJFF3rnfHNncav2dp8bFIGeNPYqBxf30rb14EinssWY/u7EkRA/5ZmG/9TZHWHWaY=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by SA0PR10MB6426.namprd10.prod.outlook.com (2603:10b6:806:2c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 16:27:27 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%2]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 16:27:27 +0000
Message-ID: <4209f54b-f85c-430d-84ea-3798642561f4@oracle.com>
Date: Thu, 8 May 2025 21:57:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250508112559.173535641@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250508112559.173535641@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0192.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::36) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|SA0PR10MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df38d98-f68d-4c85-5d05-08dd8e4d388b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ym0wbWlGTXk0Qkc1b25xRTFyMEZ6eTB2MWk1S1NTUGJUVFV4dFFMMWs0TzB0?=
 =?utf-8?B?NEVZQ3RjbFB0ZWJpRXY2ZHhNUlVvK2k4UktYOStRN2pGMTYxTnZHWnhMczVG?=
 =?utf-8?B?TFdwVllxeFFNV29YYmt5SlNjRFFia0MyaHdqTGZ4YjV1VTFVeEJHQ3crc21V?=
 =?utf-8?B?UUlnRU9mWGd4VWhtVnNxZ3NVbkI1QVlGalQzS2c2UmJWREVvRFhFZ1FKSDJL?=
 =?utf-8?B?VVhRR01TeHJOcWNUSUsydUlHS2hkeTFtMzBIZjNOZ0dBQlRQT3I5Tk9wTTEy?=
 =?utf-8?B?M0tmdUZkd2p0MUVnTFBsdnUycFQvWW4vNVFxOWN0TjRUdXgzbDliVzBIU0VO?=
 =?utf-8?B?bWF5bnpUR2dYYnVzbVFFOXJKWXllZ1BGY0ZoUGFpOTZoSEdpb1UwekFwUVZN?=
 =?utf-8?B?QzI0aC9rbmgrTDdSTytQY2J0bnlXMUx6OFE2QXg1VUNyRThPSmFKcE14MTZL?=
 =?utf-8?B?aFQ4T0h5YkRiVE1sOWxRK1h3UGJkRGQxVHFmUE5YWEZZam9CQkx1emM2ZnB5?=
 =?utf-8?B?QTZpUWtyZ1JkalhVL1VpOUNlTlg4RTcrT21kakNHRXVEMHZJQThQc0dDRng1?=
 =?utf-8?B?eE1QK3lFQWptVlppcm1MbHFuQm5EM0RsMlB4NUF4R1Vra2MwLzQvTldBZDlX?=
 =?utf-8?B?V1lpdWZoeDUvWUJjVUIrbEV6SG1McDhsNTkvWVRyL2dTc00zekgrMCtZcXh3?=
 =?utf-8?B?U2xscWJiUzBCbE1aRnVkMVN1eisvZStoMUw2cmR0RFU2clhIdmJxZWFXamt4?=
 =?utf-8?B?RjU5NDhLRzZWQjBTczlJaVJQQkt4QWlya25ZQlhrTGJoc1h0SEszQWQ4VVkw?=
 =?utf-8?B?MWtINmJIZ0VUeGFHOGNoN3d5ZDFxQk92SzJWVTZhaGRaZFdzbnNQQUMvME12?=
 =?utf-8?B?UEpQanJick5YY09GQ0p1MG0wYXNvZkFURGhIR042dHU1aTVSdE9uL3hLS3dt?=
 =?utf-8?B?TGxxbjJLSlppVDA4QWxOY0lwN2F6Y0o2QU1SUUNPaVVhamtYbS82NHlFL0JW?=
 =?utf-8?B?WUQvV0RhMTB0VDE2TW9qZ1dmbGdZUjNwMDFBUEluaXA4RURjNXpxcE82ZEV4?=
 =?utf-8?B?Mk9GMDBJQ21FcUI5V2wzdTRhZ1cxc2VLNHFUUTBab0hYczN2NnIySWJZQllX?=
 =?utf-8?B?UU9wejFpT0NsaTM3SHY0OTIrT3hUb0hpSWFsRmNQTmx2MlpNdDI1eHNnNlJr?=
 =?utf-8?B?Sm9Ld05YZTYycnd5dkN2Qis3NC9LYlcxYlptUXJkTDkrN3pmNUVvMlAvNWdl?=
 =?utf-8?B?dEMwallyTTl5SlVXUktvY1dQSFpHaGRQOSs3MVJtK2d4V0x6Q3VydXpISlhX?=
 =?utf-8?B?UEZsZ29wWU1wc0RhNEpzNUpQQ0RlNkNScXd4RDFSNDBxcEZuc0ZRcDNqbDlJ?=
 =?utf-8?B?S2tpeTl5VzR2NW5MVjhuQURpSWdOdGZSNUVIWHJ4ZkZHWlNGUXMxQ1luL1ZI?=
 =?utf-8?B?eUFVd3hXTjZrZjVDVytXU2ZJT0I5aWMrUkQ2K2s0V2VoaDR2NHNWbk1tbXZn?=
 =?utf-8?B?Wi9qNDQ1dUp3cGJqM09Xd28xVjBLM2crTUJGQkNHMGlXYlB3eHJVZEY3KzYv?=
 =?utf-8?B?SGRtejBHcGZ2SzJtdkdETDBuYUJtdUUzNEtRbTdDZ0IzZFZ0cVFIVk9qRE5Y?=
 =?utf-8?B?R3RaNys2Q3IzSUtub3k3YzMyKytYcUtONkVPdUFad3pSK256S3hyTWV1WG1Q?=
 =?utf-8?B?ang4TkJ2ekRydHc3MkZ2WllNdkg4S1dhMW00ZGFZM1B1Y282Z1U3V3I2enls?=
 =?utf-8?B?ai96RDN1YVgzWVpSMXNrM2xpRzJHQjBoMkVUbkJKT3Y5QzBZU1F1YW5hV1dP?=
 =?utf-8?B?L0NZNUdwYzhTKzdvWjQxTXNRcEJqcFgrcEk0RU0xR2hUNXEyUmp1Qi9JOGVD?=
 =?utf-8?B?NlYzZkdySFFaUEk5TmlRN242MnBIN0dWSEdJME53MFdacUs5aUYzMEUrdy9T?=
 =?utf-8?Q?1Fnv2J4wdIM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlIwU1lqOG9UVEI0SDg4dW93bENkUk5YV3VFTEUyYjJBRDFOblNFSkpHcTVK?=
 =?utf-8?B?aTZTWUc4WkI3SVFmeXRBQ2p1OFFuZmdxcjViUHFRSmZsV0ZUc2l3aUtieEE0?=
 =?utf-8?B?bjE1ODFkcE1aTDRXTmg1eldmMGlzeTJtWVMzeXRXOUVyUjBqeXByb3hwK2l4?=
 =?utf-8?B?bHFGV1RoTXF0akg5cGRockw1NDlmN3dOQnR0bkdRdWRnRjFnSU1uRk5CQnZi?=
 =?utf-8?B?NGIxblZIM2ZaL3VEU1J1MTZVK2NmeGNyVk96V0E2bVNwaVk4ZngzL2ZkVkJI?=
 =?utf-8?B?NHBGNXhVVk95bXJBZzZhZXJSaisyeUJWNkdvQWVKL0ppd0VZb1BJSUZ5aUJJ?=
 =?utf-8?B?QW5JK0ZpNUFMRVRpSmlLUzNZbVVMTmNjdlJUTERqYUdONHM4cUJZZ3RBTVVB?=
 =?utf-8?B?aENCcmliT0g4clZXcEF4U1NOM3ZhbmNzSy8yb0NvenZXMWhxTVR0ZnBGSFVt?=
 =?utf-8?B?RkNvam5LUUI4T3BidDFBSjkyVGk2WCs2bWJYN3NjUExSZkVjVGVwbzVHNjds?=
 =?utf-8?B?UUxJRnJMaSttajAyeGRPUUt6SDRkdmMrMEFWSlIyWGtuVDM4QlpPTEtWT2JL?=
 =?utf-8?B?SFdld04wb0tJN2E4ZEpCRTJ6WHBReWJ2bW4wRWQ0WDcyNDVQd0tSbGc2RkVF?=
 =?utf-8?B?VExaY1A1Qm5oUkVNUEl2UnpyTkZYNnY5OWgzTHNZY2FabzFQUzlCSEsvMFhG?=
 =?utf-8?B?T3B4VUI5bFJsSTBQcXNQZXIxK1I5UGd6eW8rbk9DN3NKWFY5U3dhQzdwRGdx?=
 =?utf-8?B?Q2RFY0Zoa25wbW5VejNsQ3lZWDBNY1dUL2pRN2x0am1pNWR4YlRkbUt2aW5Y?=
 =?utf-8?B?WUVHUEdaaXZ3dVAxWFhsVXFBZGprRmNnWDd4UVJOZG1xOUo4cDVjT2NhS3ZW?=
 =?utf-8?B?d0U2Z2UrSTVFTndhOVF5MjJJbmptYTJpbFhHSUtPYWFIaFVGV0hJWk5kNjNV?=
 =?utf-8?B?VjBoamlHR1IzYmhRTWMrbFYxdWI1UVNBOHNTSDhSdW14dlVmTVQ1bUprZVNr?=
 =?utf-8?B?WVEreTh0VVVxdGFTZXlzM1NkdG1Ea3NYUm5uK0picjZQNjZ1K3RJZFc4N0l4?=
 =?utf-8?B?Sy9sVHoxU0d3Y01CRzJLcnpRZGJ0a2hzOEgrT0tHMG80akphRXVocTF4dGtQ?=
 =?utf-8?B?VTFJdHNEOWQ0TUE5b3JXaWZoOWhhQlQwQ0xyTEo4ZXFaL1FVei8rYUhQdFJT?=
 =?utf-8?B?S0dyWlV0M1MwbEhHR3U4dHpwcVM5bk92TTJDNStocHBySHd4U3A0eXZDSXFE?=
 =?utf-8?B?OU92UFJodVk2aFdUc2liVElKbHFuLytzUk00a2o3WVBXNEhsSEtmdldORVJ2?=
 =?utf-8?B?S1R6WWtvN0NzekxVeWVLeHE3eEErN1BweHpXQkJic1NOOW9sWm0zR2JGYlNh?=
 =?utf-8?B?NENGODg5WHRSOTQrNGNRNE1xc3VNZEY4VU00T3NJNDRaZlhpVkdRcUhmM3NQ?=
 =?utf-8?B?djNpbkxMWUxNNU90czNyWU9NVE1ENXpvN1Q2TzRta2ZveHVIWWxyMGtqeEtv?=
 =?utf-8?B?bXBYL3BkZjA4Y2dtRUdQTmtqaDErQlJOSUd6Vms4R1pZTm5lUUNsUHVkOFRM?=
 =?utf-8?B?cVpJWkozMUpHVzNxcG9lOG5GTC9USnoyTU13NDBncFpaSnV2a3dDS3pPVmdk?=
 =?utf-8?B?dkVUZnlVbzhQSjF0cFgvR3hyZ0Q5R0VuT0xWNXZzMjhYSmttTTI4V3lISTA5?=
 =?utf-8?B?OCtXZjcwL1lSOTJZMW83ZTFtWFpzOVBCYTBQaWZiZlBEV0ljc0x0RHlIeUJ6?=
 =?utf-8?B?WnA5SXVYZ3pERUF1ZTlGcGw3dG4xeEVmajk3MHRXS0Eza0pzbkhYWEt6TFlV?=
 =?utf-8?B?NU1DTEZHaDA3UHpKVFBsQ3Jjamw1Umt5MGhEbE9pbmdNZ3BEM0diMGd6dmhm?=
 =?utf-8?B?U0J0bTZoTWRvOFFlRTRxLzdvY09kN2MwNkxNTzVpWk9ZOWhmQlo0NFBzWUFk?=
 =?utf-8?B?UkF5Rllvd0EreGcySSt5eTE0b1lhb1RBM3BVK01ZWmZEaWxTUURlbmYzT1ly?=
 =?utf-8?B?bW8zOFphcm4yTlJlMFFRaWNFSjMxWUNZditwNmhzSHJTbi8vZ2ZNWDc3SVU5?=
 =?utf-8?B?cUd3UkhLempha2wyRDRkS3JSKzQwaHgrcEgzMG94UkhLS1QvQnlNK2N5WlJh?=
 =?utf-8?B?WkY4bHJocGFRYklJOGd0VW0rSm53bUJVTGRJUmNCb2hKd3kxcG9xclBhS2Vu?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	psuZyztZ490pOLCiE4qNSqthQ5xLYl9O6BmAofWSljd9Cwp9PajrDYBOLoh0CPPysRXk3vMCNsScTEpg+gpyESY2am7haYUKuB6iBEI2MmwkNqxwLf90GogYz67KUag5AE+8a82kVDOpm7jIVfKRKDbxLGs4g3FtP08vPQNlFAUydVxEz5xVmI9g3DsHH2Xiw43Op4L5whFAOVyu2HwNSgf2xxDPJRK2GeqO/VDZ06uQJMY9rOd3Xhr9xxQTl1Jm72ABYg7iSm8u+Y6ASSHZQdeXwqZJ8VqkVH22+bQm8THMqaleBOTrF/aXmXSIWQHxN6q9Txq+zUCgNxvGGIEZxq/J2IVlubKS3I/l8lpdN772YeeLEoljLP2RgcGZjC8AO6bskNelm9O51FI27RJZO/3yzWc4/bTWDvoV0og6PDlTe36PdMawSrf00bKez2Yc8fXTm10MzrJ2+uzfmJBCsnkc43oAf1wsENYJZiXesKIlGDQVtyhZ0WZRLXnqlWNCcanyE5Vm+P3xJLoznD7VNxPNOUmCXIUzHuibrdY70OefauNHRybfCsZI1uQHI/Cb79hplaBFMNQV/IdAvdBxozt18ykbPzV8Cs1iMMLkOQY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df38d98-f68d-4c85-5d05-08dd8e4d388b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 16:27:27.3297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfQ5AfHpXsqQiM6OSlqpIBE3qzufPrssaAoPukt3HGNNIL3PEV/3seUR1PoqJXehe3uQPbQXF0/KwXjXi1Vo3AiwO3QFAHy18JmVICvGEx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-08_05,2025-05-08_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505080143
X-Authority-Analysis: v=2.4 cv=YOWfyQGx c=1 sm=1 tr=0 ts=681cdb76 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=8-vRK6DNSD7UNujOA5sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: v_YDsvGB9yt_knuFNxcCVCcFC25nJ_Kv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDE0NCBTYWx0ZWRfX9+8DRYdKlj2U FISs+pS1N1Qd3RbFPFgQWThtUwNDuoUiHTWJ3y0+x1PRHxYTjda3oR5wYWMeOzg3dqZ551ln/Sx 41iYygZ3qanseAdcDO2xHU0TDRXO1DPKGPXBjIXI4VJrBfcVPUMO3xEPEsVBvSUHnFY9xpN6DPv
 fWSgYUvRSpqviznD+ngY8EFcgWGr6zc5ofAnFUddlJ+tnggBh8eb5tj7yrRhQIYU5YV69ex3iHW KJ//bF/E96GLhHPorabnZPXJ+JNACE++ucl8jeNueGROVZLU6+Z6u3esCqTHu3cYTFphwDFny3F WLe0IVAACp63MRq09d7mq2DyG+8J6anOLuR+P5yKl3XyxGax/a0ntUt0SrmAObnLImWLj6pSX7L
 ihmZ6ueVpb8GHO3+h2NqrF3JQPhli7hoe55ZhjTj90JdQswB++mooY8HaYcKHlRUAoaT3d2F
X-Proofpoint-GUID: v_YDsvGB9yt_knuFNxcCVCcFC25nJ_Kv



On 08/05/25 5:00 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.182 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 May 2025 11:25:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.182-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>


> 
> thanks,
> 
> greg k-h

Thanks
Vijay


