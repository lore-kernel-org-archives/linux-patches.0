Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7617185955
	for <patches@lists.linux.dev>; Thu, 30 Oct 2025 18:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761849077; cv=fail; b=GC39kQlq7PH8y456VYIvBRaaSvEc4adNiKpC1PwcMBaFfU0vmAJV8XyPfYrXX53GOTgrF39Rt0t4NAk94pkjCd7BsZQgSxSqnbLISBlKDpwmBDt7r6HB1m6YygghWAyTfh5ipqXdVTZoy1+T9nfZrQHAxpEvS4ikfa6i40S3vCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761849077; c=relaxed/simple;
	bh=UTIvmOPMx8kFhFa2T6+ZOewnBJInCEUMRGftyn0Pdys=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kF1inbQckomsQ0UPZflp4x0Phtn4qy4B8L2OQaQBKvcX0Y78/qrv3/sXUQVrVHOwOYdRaZw2eHBz+JIIZsaWpLVLrUSjtM00EKj+Vz3RU/ndqd/jFLH12uNkrTSGIDV4JOt6yUdshxkW+4RkHpu0Ys429tVPH/6eJhmssOmRZjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gOq8Uq9a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RcYPE/tM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gOq8Uq9a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RcYPE/tM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UIJnMq024403;
	Thu, 30 Oct 2025 18:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gdTEK3cdE5XQcGDNsprcHHXCuAXOQvd3YBfXqVgnFg4=; b=
	gOq8Uq9aikPUxrRISt64nFKwFHYxVkQKOLu2Eg22IMfiSKDCrWcb0pidde/rXyl4
	E6N8fmUpOmb5Rq3ODTBm1dJaoSEN8jo3vYWdxSLMv9rP46AUlWv5CBKA3V+GNMku
	0MShAU4fI4bveLGEk0B1GwDEJnsrEnAkqK5QZtVKSziAHpT8zg993u6WkKZlZ73W
	+Sxk7jqq6J7jIf6nztiAKU2zbXxw48BfMDCyb0qmX7ic56a8SkdRE8sVKCQXG3eF
	sk1wOvZ0sykFJMLCMC7pteXs1Avy76BdfzU6mVuIhSRLIdFNbcqS2NMVGed34p9K
	N2uR7ZnArwbLJ48MbegPxA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a4d6q00tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 18:30:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59UI64Q9004146;
	Thu, 30 Oct 2025 18:30:52 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010064.outbound.protection.outlook.com [40.93.198.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33wn1a8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 18:30:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rFZdeHJWFhrRc5r/XAX/MWXchYiV3H+xRgHZrRgppSwCXBHIco39UkVrg2+vRDuO9aPo5ySV1iI1GBvYJb53kjdHe6Gn6atFDRX64bO5UEO5GidxM+yptQRgR6fmN8qZ3XxSofSrhTc1bjVvcEvS4T+yj98q0IvhvKnJ3Kif6oBocoCM139LAS6Wop+b0PPPZSg2lXMobHF5VYc1W7Dta7XIce2SkRgGt4p5lwdgPK1VOwRVCv68fnN1TCtbj0BEazM7PQmO612LYbUprWSAPhuGGUlyaxkRnY9wJyYxQwqyo1baeANoxSA0SQRHv5RN3uBfemAQloXSGFdSBjfZ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdTEK3cdE5XQcGDNsprcHHXCuAXOQvd3YBfXqVgnFg4=;
 b=oprIH1l5TB8UEEXIofiFEjDvsG4c7P48hmA/C6L69e3P0iQTPDcJCbCkLz9g9EExk4uQDjI35ajj7ZHClewth8CeV7XAPub9XHt9KoioE0IsBEv8dsmCNZfMm0XW5F67Cpt4b9DDXLaVuv94kpn+8BWBLWKXAIBhGOKhqn9V54SFcwHQfya84u4UKMcKSpyFEsZFZyOkVl8M2x9ugIr5jSt1AbXKDoi3J4TttT+aAuaK4dvmr3nP39zmctNMxeB9Xj3EchdVn6HMADDoU6AbPg006GPQJjMt/ZDWcBlu9Yta3mSTc0oyckgVSqVBKteYbjtdBrdC4v+0ikcH4VoGDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdTEK3cdE5XQcGDNsprcHHXCuAXOQvd3YBfXqVgnFg4=;
 b=RcYPE/tMoiyZQmbS/BMaMK+KwJdCU6wNXjW56/15D4Ibg4mK20Y4Qioq+SkrSpnQZVWVsRrzSsyk5xaqKoF2xF4WaPUgI8INVfalDkbwJhC4cm34I+TbuV2a0DYdkl89rO35puyoJDFvJ1OujIZ+8BLx1IQJ88z0T9KXnDkf+sY=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 18:30:48 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 18:30:48 +0000
Message-ID: <db391b96-131e-4daa-906b-c7be43f27ccf@oracle.com>
Date: Fri, 31 Oct 2025 00:00:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
References: <20251027183446.381986645@linuxfoundation.org>
 <86abc1a6-6bed-460c-80fd-a74570c98ac8@oracle.com>
 <2025102912-cosmetics-reflector-ab4f@gregkh>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <2025102912-cosmetics-reflector-ab4f@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0372.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::18) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 607a0d78-548e-47de-52ba-08de17e27216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1BCU0FIc0pEa2VsUW5ocVpJRlBkWlBmMVM3R0MzNno1bit4cFZoN1ZZbUFw?=
 =?utf-8?B?R1J0aVVQSFhxazYvWEQ3dWpBVGIydDUrOHZQQ0hkK2FyMkUxTHRWaVJiTmd2?=
 =?utf-8?B?UFdLUldWMWNpclR1Q2oxMlA4SDc2Mm1wQ1BwOVRvZmY4ZUY5N3lYWE9GU0lV?=
 =?utf-8?B?SmVCM3FWSmVJTmRMK3g2NTNSQjNxd1gxbisxTzdySytNQVZSMDExMUpRdEZY?=
 =?utf-8?B?dEl6UnU5S3Exb29GRERGOXlPVzZWVWVQQzZwV0VYbUN5bkVLaUlUS2l1eHNr?=
 =?utf-8?B?MEVkK3lzcXdVVzIxL2FJVGl3REhUZVV3RnRKNFZnOGk5ZnVuUEgrODEvQlIr?=
 =?utf-8?B?TTk1S2k1Mkt1NzJvVmdCdCtjNHJucTJ1czVhL0NtTnlBd3FFN3I4SWthOTEy?=
 =?utf-8?B?NjA5cGxRR1NWM1B2U211OWxHYldrTVp6WEJyUlBIZWNjNTBkc2ZiSDBCS1Aw?=
 =?utf-8?B?TEphVUV5Z1B6NWNqbDlWUjVKdlVoS0ZwaWZlTThDS3ZHSkJCYmJiUjVyT3Bs?=
 =?utf-8?B?Y0I4SlB4QkNtN3cvdU56TTdyL0RyazdxVmo3Z1NlYTh5MGV1TmR3ZnpBUk9r?=
 =?utf-8?B?czVibVlaaUp4VFVKWWVSR2NJaHowOEQ1ZWkwVkFKbTVTVTEzN1dsSzdSYVVM?=
 =?utf-8?B?MmJGVmRnSjVsTlVLVHZ4a0JjeHdVdllNT2I3S1RZZ2pBbHVEdmk1QmIrMEw4?=
 =?utf-8?B?bnpra3ZmeXBIb2lYTkxlMGU3UHF4aFZQL0lHME9uajFBaitYVEJISGl3S0dz?=
 =?utf-8?B?TDdVV2NSZTZIQ2dWVW0wOG9EN25IWnBjU0ovajhoVEZMOXZqdzB3VHdUb2lz?=
 =?utf-8?B?TDdQQnlNSnFOT0MvTVFwL0toRy9hdU9QV0VaV3FLdDBGNG9TMnhzVC9yUzU0?=
 =?utf-8?B?NGpzbGRzamNXNCtIQkp1UXo5T2JsQzBPTkNFTExzL01SUk9aTXBuQWhxSjZ5?=
 =?utf-8?B?RldyeHZiaWN5bEFKdTJ0K2hHTkZPY1dudmU4aUgwc1BtZUNFOXZMNXBER0I4?=
 =?utf-8?B?WVU5ak5rQlI5VDVGSUIrMVc1YVBramlJSHV0NVliMnVtYnI5M3Q3RlJBdU5p?=
 =?utf-8?B?SXFUbHRsUnBpYUJybHFBdncxSWx0U29XMmN3cFNKM0xoeVQzaC9DUisyZzNx?=
 =?utf-8?B?TVV1MW5qTHZMZHVqRlR6VFh1VHU4dDZudUNKeE5SZTUvblFydEEzNXYydk53?=
 =?utf-8?B?Mld0ZFVwSkEram9UR1pNZG9GVVltVTZCMStVbUpxZ1BBWnpvVGFsVlllYi9S?=
 =?utf-8?B?Znh5bGNhSFhVK2VaZ1h1N2g5cHhyckxWSm9EOWtqdkVBOStWZkRrdDFDNnBi?=
 =?utf-8?B?Tk5LYnp3ZlBhclE0c1c3OXFjMUgzdkpiSHNwVk1VTW54aGdkbVZDU2NiQzd1?=
 =?utf-8?B?ekxGQkp1UUx1YzJKVHYyVnVONWZCWU40R0ovVDl1N3d6RkpMTkJocGhMMjlv?=
 =?utf-8?B?UE9Sem1JdHF4dHByZGhIamlOZm9OQS9aRExOdGlYMFp1bzJkY2lDa2hUUG5y?=
 =?utf-8?B?UGE3eEZPYll3Ym1OZXhOdmNMS0VCNWh4Sk1oNS80V0o1Q00rYVFFL05oeHJ5?=
 =?utf-8?B?SytVaGpLcGl5cHV4WUE0MlZZQ1JSRDI1ZmtRc241K1dsUFB3Umwvdy9nZGRS?=
 =?utf-8?B?UkpYSEp4T2VFTmxkcUVPN2EvUHhIT2lKbi9XekRGNkd1VHZOeXlrTzVYUytH?=
 =?utf-8?B?RHFRUkhNZGpVTTBMeW5waFdQRnBtSXZGZDhLczMyUms4UUwvMWszaGJBSm9G?=
 =?utf-8?B?MWNWSjZraGg1Umtlbzk1SXMvWXZ3OVBIVy90UENVdS93TDdrMHZGOC9IYVRK?=
 =?utf-8?B?M3pSWkZWcXg3Y0lVOEVKeElNUTBTQXR0eGZTeGUxM3V3blRwWlpWUzhyYXBu?=
 =?utf-8?B?TEFrVlhkU2FINDBUdmFHZjVhWkw3cjNUOXdVQ3lsMkJuQk9Lb2RxSTMzdGpx?=
 =?utf-8?B?MUVGM2RZVjdEaWlDTGtiYmQzUllwbXREQ1RCQjBhYzZTM3BmRkd4TGp3VnlL?=
 =?utf-8?B?eFRSQkxzWExnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWVhMEsrc01pN3lvUkRuWVl5OUhlODF3WEFIb2pLTzFjV0QwMEhkUDB1VkxS?=
 =?utf-8?B?dEwrZFlQK3liUHFId3dQOUZ3aS9Zdm03bEtONENSUk4zb0s5RUM2Nk1oaE9n?=
 =?utf-8?B?Ny93Qko2ZzZPcUEveE13SVdTckZFYXBERjZsQmlYUm5aVHNoQ3g4M3ZIbCtX?=
 =?utf-8?B?cWgrSzQ5ODcycm1NQkVwTE4vM1Ura0Q2QkIxbUtqTUpiRDRDa2tKaXFnblBE?=
 =?utf-8?B?V0FRSXJ3Mlk3VDBzaFIyem55T3hNS1lpVG1VMmU1TW1nZjRvTDk1N0dBckM0?=
 =?utf-8?B?ZnI3eVhFejVKOGo0NkRtRzhNOW5TN1dzWitaN0prNis4NTB6aGFRVzdSa3hC?=
 =?utf-8?B?eGp3dkxmSUp4NDJoZHgraE8yQzFVRnJRcVdXWkN2WTdzMGRVT0lON2pFMndL?=
 =?utf-8?B?a2E3R3FVVHV1RlY1NDRJVDZzak5MZWZwRk5NeDRZNURaR1FCU2ovbE1vNTNP?=
 =?utf-8?B?Z1E1NE5TTTIyVmcrYnBic0p5d0Zlem9WMFN2OWp4bFNYYTJpTEIwejlueEJt?=
 =?utf-8?B?MmYySThBNWpxeGd4WDZjTkZwQU00dFhjOFRadnRYYjVTMmpNeG1WbjFTVjYx?=
 =?utf-8?B?ajltbURWRlo1R280TlRFY091UGF5SUh4SEQyaC9pa3lmZXAvcG8wREVvOXJk?=
 =?utf-8?B?Q3d5SDdub1lCcDZEQlFJbjBkbTZ3azNVOHY3dzMwdkdaV0g0NGVXWVArQ0dq?=
 =?utf-8?B?VHU2ZzdyZ09BVUh0bW1nLzRkZGh6SDJvOG5lVWtpN3hLMFBTQ2FwOG0wWjdO?=
 =?utf-8?B?RVZyZVB1ZkpVcFdtU0xxTG9WdHM0S090a1FkRkpVamNXeitjMk42K1B4azFS?=
 =?utf-8?B?L05ONVhnUDFtRXlyRkdjaERDeXYwZkFJRkZONktXUGxQNFd6eWJIQzVvSXNp?=
 =?utf-8?B?TzBsSnZ1cXBrVDlrbHVwOUhhVmVNci9tTzhZNENZeXh1N2luR1ZpNFp5L2hK?=
 =?utf-8?B?YjRJY2QxQm0yTWZUL1QybUVxalBIbmxxV2FBcVA2bnpicWNTd2J5V0JYRnlu?=
 =?utf-8?B?OHF0NWFIS2hsNHhpcDBqVHc4TlVyVFBmcDJDbFRQczl0TjMxdXZLL0JmdVIx?=
 =?utf-8?B?UGpKQStjTEhqVWRJSGJoZjdaOC82WlJzdnNYMmtRdmdPZ2RWMVdaY2dsZXNi?=
 =?utf-8?B?RXJaL1VnSkRVZElCWTNQWTVTOERTcCtJYU51dUlrVFp5dDc3Skg2d0lWUWhM?=
 =?utf-8?B?aFRuQjIvQ2JpTS8xZEswR1FZbmJWL0JIUzBqYkFCWHZYZmViU1NSVTFTM3V2?=
 =?utf-8?B?aEN2cVduZmRldlhsclJ3OE8ybENqY25GbnAvZEpnSnNKbEEwTWhXNVc4ZHpv?=
 =?utf-8?B?RzJ2TWV1Ui9tRU42QUZGaEZaUnM0NlVHUkUzdTB2c3FxbittdFUwSlM5ekRW?=
 =?utf-8?B?SXNZSUY0N2RLTmx4TnZFdGxzRG1LWjlmMmszWEJzMGNLQ1RyUjVIOExKRjJt?=
 =?utf-8?B?ekxWTEdPSlBQOGFnWDJOUk9TMk1QRnVqK0daNDFBZTZPam40MEtZcjllRHB4?=
 =?utf-8?B?Wm1odVlRV2RJSThFYk5BNmN0Q1hkYlRQMG96bC9ZNDF5emxDRjVGY1ZEUzlD?=
 =?utf-8?B?ZjZuVXJ5bVNWLzRLSVFUYnNFcjJEajFJOXJaZmZrUzdRVi9hYVJncW1NSHlX?=
 =?utf-8?B?Wk4wQTA2UUxTNW5jOURLS1BBUzl4Z20rdDg1UFQ5RC9MTUIxWU1nenNQeTdi?=
 =?utf-8?B?SHpjaUY4Nkd1ZDJsZXlUWHl6TXIrWlZGN0p6K005SjQycW96V2JVTU8xMExZ?=
 =?utf-8?B?eDNZSjBiNm5oSDVPWWgrNC9IOUpDREZ6Y3h3SFFhQWlJQUlVYjdKRC9zRGVm?=
 =?utf-8?B?a0lDNUlBakE5RXJ6NCtabU5nb2ZwMnU4YVBmSzJPUGs1YkxyMjVTdzFTTTdy?=
 =?utf-8?B?NS82a3JtK0VnVCsvQzhhaG1MTTNrYWpzMUtKMzVKY0VycnVPakUzb21vM2Jy?=
 =?utf-8?B?RmJUS1NyVmc0V2lqa3FPOEJNUHZQRXE3S0xiTkRFZURGaDBDbm9PZXNNWnBk?=
 =?utf-8?B?Z3hsQmNaSnpDK3M0Z0UrRElQdkVoK1JzZ0E5eXdLd1h6cDBGc0VXeXh0MDBY?=
 =?utf-8?B?YVI0THdaTUs3MHdDTjlKWHFjbVhyN1liVWRYWlJEZTVnaDlpcXNrZ05PbU1L?=
 =?utf-8?B?KzlKVFdML1l5RDhOdnFhYXA1Rk5vMXY2MjlvTjQ5MXFvUy9CbmZaZHdTcENJ?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BLu+orI+3KspC/FzDXsA5BlWd/zR7b2SEiA3A6/nUhs3eMJrTFPhoazi1Xguvbyxlcpv+ZRifUh4IsCgwQNSqduQ6dKuOwpJ7mBetMK/dciNTMdL/V0bewxZNl02B8IiH4IbqSxrnB76a7QWbZQTgErCnygtEEmu4GF/IyCyKLNcA6NDA3UMGvlCNLGcaOfWhQL2SUKu8tmei/lvE6Tg2xWlq6a73UWrJPUDMjLk0ck1YkVcOIgOymtMyYWWAQ/nzGoMK1/Zv0m5Rh1WSR1fpKVi/1t2o2OJVxme8EuvVmAk1P2q5UHcNHfPo15RiLWBul0+12KsdLC3SfIZ9dhqiZ+XPgT3qaPVYMzHb1dDF/FByc9yeepDJ+KFXORnv3nfIG3wVB/MTjOgQvnP9NC8OnxmTj8s4vAg242oetFNGO3DXbhGc4/vqkgM/EZD8iBgy7QOZ5Z2dl+aEEy73q3dnHMm5OQ8WPToxuJb1ajAy66RfQjgpvV6O/FtZ+s5fpMyD9vUD9DzQ8soiTx2X1o9vhA1XDzT6uasvLD7YL4YFV8UaXO8gTK8GQ2lJd3LTnBXAsw0KgYLnxPiJP+QRCRnngGpK4F299BLKAhX2Q33kx0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607a0d78-548e-47de-52ba-08de17e27216
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 18:30:48.0648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OgI3KXoPjx1X7glTrLiuILMkt7zNnxmtz8zSazTEaZacK2KUihtxPeh9oBfdhldIO5Tsp3g++kBXUbS+tPVTgOh53nISJEebdqybLku0OHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=986 adultscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDE1MiBTYWx0ZWRfXxdMoQSQofBNj
 kGTFHbDT0zDbdXS9Axf3Bb19xhq7N8blwHHSVZRntRxnwJcQGSOG/9gS3LInewkKxiwKd85hYA3
 xoNQqVnwYEPSf4B/mmkNyocaEBv5soonsdouYLo4R5RjqVQ7o/ou55Gpivz6rkxVGaxdLsv6ftd
 Bq1acVEVkZZjYIGpPkMvrt6D3agXYzk+bvneJ3zPu23Oa1tNh8lK0x9ys8bpNNGG7uhY4l02qgC
 i6oICL2x4Rt/kD2cnD6j49Gx39J2F3N39BzaLk9kMeFkc/2pPgqJO6xL2dNDjEEgaF/AxLEhwjc
 7Cf2dP6j+JI40MdMwGnDyWDQOw4L4T2Fml2jwINvCcUqL+3/zjYbTRyLefjfxQFkQBGFAQ+001z
 hcMahJxMV481ZilemVL4YwoVjW+Cdw==
X-Proofpoint-GUID: xKAuzsSsCMY38elF18DKqVu0Wklipdx_
X-Authority-Analysis: v=2.4 cv=bLob4f+Z c=1 sm=1 tr=0 ts=6903aedd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=9LX5Rj1XQI-Ifp8o5MQA:9 a=QEXdDO2ut3YA:10
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: xKAuzsSsCMY38elF18DKqVu0Wklipdx_

Hi Greg,

On 29/10/25 3:50 pm, Greg Kroah-Hartman wrote:
> On Tue, Oct 28, 2025 at 09:11:58PM +0530, Vijayendra Suman wrote:
>>
>>
>> On 28/10/25 12:04 am, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.196 release.
>>> There are 123 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/__;!!ACWV5N9M2RV99hQ!IVHnCNGPANSvr6y0A-odHf0UE4PdtiY7sjGz2BlRApDAo-XoZrirsziXr5syGOL9x2-s6GjtEsk_yVSVuFc7OkW3YM4C$
>>> patch-5.15.196-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> perf failed to compile with following errors at compilation.
>>
>> BUILDSTDERR: tests/perf-record.c: In function 'test__PERF_RECORD':
>> BUILDSTDERR: tests/perf-record.c:118:17: error: implicit declaration of
>> function 'evlist__cancel_workload'; did you mean 'evlist__start_workload'?
>> [-Werror=implicit-function-declaration]
>> BUILDSTDERR:   118 |                 evlist__cancel_workload(evlist);
>> BUILDSTDERR:       |                 ^~~~~~~~~~~~~~~~~~~~~~~
>> BUILDSTDERR:       |                 evlist__start_workload
>>
>>
>> There is no definition for evlist__cancel_workload
>>
>> Following are references of 'evlist__cancel_workload'
>> tools/perf/tests/perf-record.c:118:	evlist__cancel_workload(evlist);
>> tools/perf/tests/perf-record.c:130:	evlist__cancel_workload(evlist);
>> tools/perf/tests/perf-record.c:142:	evlist__cancel_workload(evlist);
>> tools/perf/tests/perf-record.c:155:	evlist__cancel_workload(evlist);
>>
>>
>> Commit which need to be reverted.
>> b7e5c59f3b09 perf test: Don't leak workload gopipe in PERF_RECORD_*
> 
> This is already being reverted in the latest -rc release, does that not
> work here for you?

I think saw, this error on v5.15.196-rc1, When I rechecked on 
v5.15.196-rc2, It was fixed as "perf test: Don't leak workload gopipe in 
PERF_RECORD_*" was reverted, had confirmed same on revert of rc2 release.

> 
> thanks,
> 
> greg k-h

thanks,

Vijay

