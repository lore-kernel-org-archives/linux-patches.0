Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AF93E639C
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 10:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781779521; cv=fail; b=EgtD+eEWFkP6xHTVlaYplkPQmV37tcMbWJ6M3k0gnnPVVzH++46XEPvZuBQz7IT1gm0t5B8pS6D5msKD3LD3gS+2YxYXhfLdGTRzwKTfQBrcA5skCHaN6Hs8UOHgepVz+BTsMnpKwVt8sIDoFEVGSSsVxs3Anfl8RT03znxiW/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781779521; c=relaxed/simple;
	bh=sbIh9fGdKdVjBKKIrZzkfvcziWFVPT8z5xoiXKYs0NA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QNUWtUWXaiFcfHwfitZYpbPLvdbjLRKEkZV8zW5n25fXxmzsDJYddyi5GXWAjeHsaQABlujQuSfaPxA2ChYM6QOw8i+zG6xfX6soiQH+Yq+GZ/TiBiwK7c3WTB44FIwRcO68Qt/zSUVJjCvwntVu8BOE2s+Urr01TKAfdAj7eY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U0+ttBjW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YjgoV39J; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U0+ttBjW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YjgoV39J"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65I7ORlS2354586;
	Thu, 18 Jun 2026 10:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=az3r6NQo1RaO+hB8Y7v/+Y5UoNyU6KCU/k8XbNPc9so=; b=
	U0+ttBjW3em51AgyNpYTaBstqaCwzmdsHrLR9q7bcAKbeW9aMS/mMj3JktZJNNgf
	JGMB/+MsPLU/JycuTxqnM94FtJHOwkclcoxychZn9Pdrfy4vnC0BYAIqW2wkFWGY
	uyrHFPTSfoNXKBcasMMCe4cfVZqeJFXsgK6OVFjsElQM3olfDnZz8d0KaBf8oqOp
	rXo5xgaS8codlWwwC1wj6aYJSCoidbNVedvV7F05jE2mBjvri3EfeiuNDsrJHNtg
	Vx0Ln6WZKb5lmoq7hAeJTirmHPyWa+YsQr7hCU9OZ6pJMVE4Wnp0nT+QJpfxNsmW
	aPn+3aRgbgHL+C1/3cRuxA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euefujapy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 10:45:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65IAcXdT028906;
	Thu, 18 Jun 2026 10:45:07 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010068.outbound.protection.outlook.com [52.101.56.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ev14u0gwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 10:45:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KoRc+Q3NOy1WwW+/oDgLu8FObRUwVje+3T7DIpShBrzvZZM5c/WXk10RXzJtTCLrOEtVDbPTj/Efvn/94VD/2RQmUTFJcLwc356PKEWZaDwjb8Ft57y8tsl8/4f3sGZwhqNkSSTASgsTjM6fjTXUI3rstpPc4XMhzLJmqr9C5uQ0FFyTZEZXP8ZPdrhSXsQnXPffsxhgI5dHlVhtuhj3p8oMOTyYpWksBiCZwVOwZUe1bDwZu7Q/TM3I7RZwXMIgWiMBLthZG8gnfHmHVVRtR1VFu1ydpKfKOJEu/1ljQT/dWjLaEEAjpXTN3yf6vrgGacNVmrhq/OoRWFdtMZlaig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=az3r6NQo1RaO+hB8Y7v/+Y5UoNyU6KCU/k8XbNPc9so=;
 b=PXMFER5fzkLtY7WJKVqJrTPGg9vWQM8a0XiPm/FQoDG+RW4lLWbhQv3DRbpL/X5y6PwIrnFQ/GF25Kytbfcg/qyhOFfrSUw3hP8WD3JJI6+XPo5d5FRLCJbEIZLrQ3rDMRVVx5pL2Yi/bbDlmNGT/gU9udF10XIFhcJJz91Giwy0Z0BLnp9kJgyLkAiPsstKJrgUWmcACeYhlZXOL362hzyPNa8uKyV2opoWlJ6D5Kx2qJAsCVgRL1nG+OUnW8MD2fQwlPwebL+v3l3Y1RKYyhmp83wjDl1o2X6BT7DGUbwehUP78+JqRLeh/NrwNjpGI9E63Dpt5H0cmcX+caXXxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=az3r6NQo1RaO+hB8Y7v/+Y5UoNyU6KCU/k8XbNPc9so=;
 b=YjgoV39JrxlL4RlhxSfXyv+j7FhSE5k7tR6QP/eey2tw7juP4S3R0hHS8i6SB2ZrsE0USehnALobdiobbSqikODUfhLW8U2oIgqnj8DIwbMU6G/9zkS06KpwgLkzlZqoneckIBrodj4mB3yPsnNy1foiQ8dUwzI9KP+bccous6U=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ0PR10MB4591.namprd10.prod.outlook.com (2603:10b6:a03:2af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 10:45:04 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 10:45:04 +0000
Message-ID: <d4e3f997-be25-47fe-abf3-2ac4e417a3a3@oracle.com>
Date: Thu, 18 Jun 2026 16:14:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145044.869532709@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:510:174::16) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ0PR10MB4591:EE_
X-MS-Office365-Filtering-Correlation-Id: 242c259d-cbd9-4a8f-f802-08decd26a797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	apLMjVU+9ieyHojXexHH/01ZvVdm7uPi70s8E8zXpHJ8eabcaYU72B81rFBORdtTX+17bWhf+B55Ce49cXERa5AbygInZ/ntlJsAJG2cvdANeRNlbJVuXCTLBNn3S2CowBv5diswEPUzZPpa1BxlpZtpaJzJ8WO/L7BnIpWISDC06h8VFEH8+ZNd6iOoULoKsJiOq50NqsqYBbRYNY30iDdTq4n+F9mi9it2/3u7dpE/5b50l7FGuh769rKAL+2IugSI09aRCj9VwmIO+7hI0Tb6Hpt+2ZmLcTYiaAytWMc4vrPyRFJpF92iLq3j88J4WUHXhOlxB0Tu9zHtNtC8hh+9UnWSpXDJ86yNe3Yq07nfAuDdLx6mBL+qS7wK1yQyapK/vE1zO34AIQQ5QJw6Y4BsqEjZVmA0geBb+fsEWTLPSOFuV8yvfYIQbGNNeJ8jAAnVlCCF8oDhHqgxqzqbGw6C/Qc5q5Cf+Co4v/zXihfa/TAcD5dD71kWyWkp4EVc/V10AyghnBw4oNI9VYqMoX7PLBuRFXx4iD2MtGWIo789dMoVPOkRWinUyjTgl+VWEE+uoVVomxKP7ImJrnnGtAnWjTly1ElfZoSDvA9Xy6V1IqJ8L8e/VEmEAK+WcNgQFQFrEQxLzn2eTAFZNTmNZ9VSbPbMYvFM18Y+W27h+b4Q+GYWbZB/SKxpJGOF1WyU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlYzMU1oY1d6ajRlaFhXVUZheUoyR0s3NVpzcnJXcE9Yck5ZSTgyZTJQbnVw?=
 =?utf-8?B?elljNDV6aEhGOXJZMG5qYlNSdkNWY1E5MWI5R0FldkwzZytuYzhQaWJNdkdx?=
 =?utf-8?B?M0dYL0FXWkVYU3FMOTlOa2xxeFc4RWZmRVBpOHYyb2FQQkdoZWxySUNvZTk2?=
 =?utf-8?B?WkRQL0ZJdW0xaU9mZ2xnVFpZYldIYUdxME05cWdTa0JuSEpkNlkvNkU0Z0tR?=
 =?utf-8?B?S0M1UDZxaDdYU3BkQjIwTXIyR3Vjb0daUmJibHRaaDB3V1p0Tkl3U3Y5am9s?=
 =?utf-8?B?eVlXMHJVRWZkSHFsbE5KOXBaSDNpby9NYy9xTm1xcnlQTnlwSUNVeUk1eVJS?=
 =?utf-8?B?Q2Q3MEJvVWZ4RFErWGN6VWlMaXBoRXJ5RU5zSStzWXd5Y3Juakhnc0Yyb2sx?=
 =?utf-8?B?bElpWFFCY2JHMFMrY2l5OXZCQWNpMW9sTWwrS212dS9EVStDRDRYYmN1Qll2?=
 =?utf-8?B?S2dodTZ1MW0wS0dqbTZZVjR1dGFKem9ZMHh6WGR5RW0yQTRJMmpsa1BPQ1lr?=
 =?utf-8?B?dGRBR1A4VGl6SzdrejUvVUFFbXlUSWxnNkhYNEVPRHJZaUwrNUFEcXdzb2pL?=
 =?utf-8?B?RG5rYkNnVEdkV0hobmlBK3BJeW1vSHdHSHdoUDdyT3BzT2x0b1VsMFBlZkdN?=
 =?utf-8?B?ZkpJYjdzZ3ZOdHF3aFNOZ1BWWEl1ZTgrb2MyQlJCYlgrQU93NlFaejdUTktM?=
 =?utf-8?B?NUsza1lQZlhqQjFjbUVGTWlER0psYWxXUCsrL2ZUMGZkQWovT0VpVjBVUU8z?=
 =?utf-8?B?U0ZNZFF0N1Rqd3dkSzhDUEp5NGtLTTBxcVBVS21nWEl0ZTlsRFhEMnZvazJt?=
 =?utf-8?B?cmZocndsRU4rUW1WU2V3bDJObHBadWZZVWtURnoxWTZOOURkMFlnSnBmRGE4?=
 =?utf-8?B?U0hmWDI3SWlRNk1XUUtGdmJpWXM0MUx6VGwvZFZaSGxYVnNBZ2VjQmhpOWdD?=
 =?utf-8?B?UjJkRGZCN1V0SmhqU0xqWWZDNnVac3o4NzZJNndHd2l0ZnpINVhDejNXeHRN?=
 =?utf-8?B?YVZVVlJzajdMUEJlb2FzTmFkdjlkN1FGWkhyRnBHMnBEcm8zamZENkxxenlx?=
 =?utf-8?B?SkVHc3diLzZMSW5PNmRhc2RIKzVadFNzNUlFQTZTQWppc2tqbGJqWjh1eXZT?=
 =?utf-8?B?dU5aZTMrdHVkNVp5QjdIRk5wcGswM2hmSWxRQXF1ZFJvaTRTSEpXbDZsWXYx?=
 =?utf-8?B?UUVZWHRvYmtqdFdpTGtncGlOQ3dQL1lrbGVrY2xxOFR0Qmd2b2N3SkpOc3dC?=
 =?utf-8?B?bEdHOXRuKzJJbFdGSmRmb28rczROQk5VQ3pZWkdWd1pFTnF2d2ZxM2ZoRmkx?=
 =?utf-8?B?QjJpNlViRVRLRWNSZHk2NnIvSUZvRVRDemZoL1hCZTgvNU9RME9sSDgvUnky?=
 =?utf-8?B?Ulh3M2tINE02UXFQeFd2aDFHY0xWNC9OQkhIWTdYTmRLS21yalk2SzA5L3pJ?=
 =?utf-8?B?ZXQ4VkxnaTVKRW1oaS9oRGtvSnZlajNmK2J4ZG9oYWkzcnFmMkIzRDc0SFRw?=
 =?utf-8?B?cWhYVGl0WFh2Wnc0QjU3c2xBRXJicXk3b2U4QTdMTU4weHNkNUFwZnVSdEtL?=
 =?utf-8?B?VVg4TEdnZ1ZEKzdXMGJCMnk0VHNJVloxZ2NTN0hCNzlnRWljU3lBaWVPZmZk?=
 =?utf-8?B?NmJiWThWQ3BYekdFeWU2ak1iOW5pdThaSDI2cWxjV0JUdU5VM2k3UG5UNWJT?=
 =?utf-8?B?TjRsQXBEWW1DQXZwZldFYXpPc0F0K0IxNFhiRCtmaEdTN01wc1hZaTNsaUp5?=
 =?utf-8?B?bUJQWGQ4aldYY2hTQmlldWxGcTBBNTZvRUttRlZtSzFaeTBVMjgvaU4vRVVY?=
 =?utf-8?B?WXNnd3ZlYXJoTmlWS3Nta3NmNE9YTGtXL0MvQ3Z2S0dYcEs3V29EdzdMbHQ5?=
 =?utf-8?B?eWVBWCtoZmNTa2laL01nR2ZNSStuZXNTeEV5QkxHMXpFQWhuYldrd1pDaVpC?=
 =?utf-8?B?aUlsVHdkVzVqVnNYTjR3aEN5blM4aWVEQklNOGNvVTBsM3lOc3dtSSswQ2Jp?=
 =?utf-8?B?UU1ZYUJaeTRUeE42QUlhQzF0WW50dGpDNzZ0Q2JvUFVzbGRiMWkrclBoSnkx?=
 =?utf-8?B?alBWYldmNlhINHI2dVJxaXZyaXlGa1psczlaaTFmQzRYYkEvVmdmbGJ6T2ho?=
 =?utf-8?B?TUMvMkxsZmVLK2piY2NKM0NleENGK08zeUpOSENoelpIZTg4OVZKT3VCK08w?=
 =?utf-8?B?YzFUZVNibmlENXBYOWR0SU00OGFGa2lHKzZEY3dLVk1va2ZoYlBaazVDdmVM?=
 =?utf-8?B?eXRmQk1LMkt4cHVOdzFaaDJtUzVXQTN0bm9neXRwb2JoUE13TkxZTy8vUThh?=
 =?utf-8?B?SEh1Q21jaUZNa1FwdHpjWU1UdTZVa2RXSnQ1aUpUZDdGZ0szYlVvbUtrSGNo?=
 =?utf-8?Q?ZAgfxjHpRbjFOzH843psZ+Idb8ulBRigYAReJ?=
X-Exchange-RoutingPolicyChecked:
	pLwDP02jBsGysqD9c9mr6FX4e36humAVmiYWufwCDaEdHIKpzFfTURagjmVZEd2Kr2Svmx/fXycOvJuPeWJ9v6vJ+8BTDZhwpkwvnI4wPJO2FLxWqXbxFgKG5deslLCw4J1iLRUvmt2h1/tUyDlIFRzWBykY9Zdh4rZ8v/qNqkW6zWlJ6CWOR5fYrTAvJcU7bsJqQdrshsLLBO9GRs0asDadDzV620PmasXmmZH/qxK6sgANFftTADT1SWfGmV4fTWjRyG5rIg/cehaiszgFFqSX3d1k6/LC3RNbIJRtKUN2IrcyaVk+oLXv9IS64ZjBH9kxppRVS5fr+OlAbEYjog==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RzNgjoFxdNNqnePcVlHXRtSF3Rpc8g8JbamLVD2dI+pqlBmBxd2ULFtH9JTdXncZ3dC20srcAJothH+V9LG7zx1EsLgACbCPDpPlfmtfmk9hG1rQxikduh7eoks0luJfQ62dRh2MD0jvbatEN7YPQPKvMVuA6q9SF5Pqrgvomf5CHI+0m147ZpUk1+ldb2HweZemMFIxiCwj0FYK2VKRPwHNIH8k5CGhVgkscP622U48YEZdNP5etKLghENmrh8c4jO9l8FnVRw9LzgM8m6+Rx4lYUukNhNVRCT6JXGJRu7g4Qym2jWt7yLo4xf1b5ixVSWk5iGgOxvIqKWjLDuY+i9gj6UyHRA490CnACT9OwWVpZj1tLRVDpNsJN9NXbGRlAonmlQKZhQBAeDabAfKmYxS0ndIQpoPKAbudR0yvWZo7yMKRModz7yK0oJ2Q49NGEIMg3jD88uAyYpVOAYBudK4OGg+D5OfnaMdpk0aMBjiFocmYsEa5u6slTo3kJMU8Q5PeGAwqOHeHYkmCHr+VxDnH5+b4zyYhtBEQ1d6xT4TqkdN9kO+3iLNdB7HephEwhaRqFqf4h2s8+IzsY+DCRVGQNDgGFRc3+XEOp/We84=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242c259d-cbd9-4a8f-f802-08decd26a797
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 10:45:04.0744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaOrLHYS2KoUo6V2nJvYfPg+Qw18ZeALwzwwy2OGhgsdARCUV3bKdqE5IZCJsowqerncfEzJfjYixv1jAKUzgURpapjPiMFmMxeVrwrCXAvLzp+WrjqPSw+yiEC32niO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4591
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-17_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606180099
X-Authority-Analysis: v=2.4 cv=S4XpBosP c=1 sm=1 tr=0 ts=6a33cc33 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8
 a=bNkyIUznMDVvlRvQJiQA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDA5OSBTYWx0ZWRfX9NocGiD3cfU6
 jYdIonN/8zceFyPNYt0uXMQBRUKhqYr3zqXW43CPOE1rCOzCRFQeDj9+ATW6M/gXLE291pwmnF+
 gFgl/W29zQCa832/zo54iuPnB9EtThBi7ls3YcAE25VdJ5LYN2qG
X-Proofpoint-ORIG-GUID: 1Kb6-WD6B47POxmcP7iCLeaZNvo-Uufz
X-Proofpoint-GUID: 1Kb6-WD6B47POxmcP7iCLeaZNvo-Uufz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDA5OSBTYWx0ZWRfX4/uwe6f1KyGS
 4vjxHA8Mx+ndVDIadWGSrphkCmFRo+UXNBM4/6hQ09mDeraEn4KDUs6cu6M19KUw1b8xk0vCDuA
 mj+koGVojwDiToTkE+vf71L/qHB1wAFtHOfeb8Kw4Xs+Y5uL7ISc298K3qJuuwxFPXGNzAww/M3
 MaxrzOJf8lXDhDUr9+a+gb2k41Ij3zoM0d2dOb9ws+5txisH0RFulzgfgjYg9Tj17FqIuN+XQk4
 SpVE26lp8biaJRChFGLAjxmoKcZ/JWwAG0bmu8h6bNWqYJdqqC8MJLnLDdACSLrPwWgf0vXq0PE
 2K36AqbO5XsWIgPUy7Dc5NmyiG0ur3nLf5gIsV5FGtKLGYOR0wKjvsCLu6ooPGOCBpyFr35XiBS
 NrTDBsLScfZcT7fQl1cwGfN85+abITGWCQc8Bvc8dS8LZ0ysG3CqokBFVW/Tr8kAUhw4a1T7Ysv
 /oBqZRtzTE77PsVsGtYOZRVSpbXV9IeYfMCQP+yU=

Hi Greg,


On 16/06/26 20:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Have a few AI spotted problems will respond to corresponding threads now.

Thanks,
Harshit
