Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBAC37E304;
	Sun, 26 Jul 2026 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785079724; cv=fail; b=TR0prd+XrOt7UJkDBfyTohH/oDAGmKhkWkwd5fFT2zuJ/wWafuGgeU7sxMGTeGQQ2ADMuDKZG47OB3o/LaPv4yeWc1tHyGpcWqciiPB7I++GEO5ZXmP+6ACMVMXhJ9j8DldWRxl+X2ZGHL1cMLKX7vPZ8dsnumPcY/HZg5y9WbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785079724; c=relaxed/simple;
	bh=oWKcYK+CYTlh6k8sIut60VQgwfbzhk6eN/hkY0CIaXw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eDodJIckkv0o3FxxSZufDBazonPVUmMVcajpZcCAWlL94Fga9bQxyW/HAGA3kM7HtgvG1woUQ1E4Rgmh98fuG5n6TZ48h+viaWjUzRscFG33rsBXZ/q+TttUaVBYOXlLFx2y5Clu94LyoQwMMKCsRB11iYDIKDqgnxpazCNMTV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FxK07TQ7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mYMiItXe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FxK07TQ7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mYMiItXe"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QFGQuB4129586;
	Sun, 26 Jul 2026 15:28:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yl0v5JdzqpptEUAAQNgt0fMtKbbwvaUqOjKxQs/HxC0=; b=
	FxK07TQ7yXOatYBh90dGUy1Ferds5UZbfnTE1joEjkhKEOQTrG8Gr1Gp+xjGNTxc
	N40kLq6xxhZZdEPdpml24mUp/pL5Y180TiMDQNMNQtIdmz3MrGcnz8+aeTvFa71e
	Fn+wmCta+DOXg/7uJZ+sNA4DvWnsC2nZ2zwP/pStXMnHujBeCCYFSZ3NXrAVtP9D
	aDr/+2aKOuyU2Y/42+aR7QLdY7G7HXx2TYktugZNfhIQSX7A0l/zuNkzyxDpj3iE
	/udXm835C/3QNut7eTBLl4RcwLKUSwA06nulD6XxU+moJ4h2feMq3DtL2hjYkL6U
	BPIkQxnjpWt/sfpj1jV50A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq0tmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 15:28:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QFA514005060;
	Sun, 26 Jul 2026 15:28:31 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010004.outbound.protection.outlook.com [52.101.46.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh84u04t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 15:28:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bkUOBRvp+YGKnZgw+en2ii2HPcbPxLefYEsSGYM2PeXbOZadNn9Xj0G7Mya3CqdMxmwSvIkTZnSAPacPfa5FXbanA4cAjYmVr5GHZJPvVw8N6abSlIghcjoDS5ekfJWCo6Cs0HG9h3Zxl6OpXxtYTv7xh4FWmB1G85sK3hlWFG0UGaCqU70F6jg15mq8aDDBlB+dtWf6Dju+7WSXzWUAd4pWVW9CVx7K3pbwik8oEF86iPHBVOKFS+3yuMcrf2PxvbmLctPJ06cOE5iIVfoiLjUv3JwH/y/DFyLYiHxnmpzvIB8i7OOooCZof0cnppT4cuvbZyFi3vEGjJeY3eeP3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yl0v5JdzqpptEUAAQNgt0fMtKbbwvaUqOjKxQs/HxC0=;
 b=Boqjgm+Jg6GCTpltWL+WoadknPLmo2UOIKB9olsGIAFjlBFKMeqzWXiKcPVhLX+n3GdJvg/rir05achyO9Tdqae+QmEpaknxzSyFpTqSZIkvrVgNwsoeSXYBqsw6R3l9pv4MruFY3/6kbIfmXp6LW3Ib4bAtXMoeweQOiyuuodKOfUDG8fzB5gMmezrHVYjqRD10fBaQhlLZdrjAAtX1MAN0uOk5AUf/1RNF1S8BpGcUc3gCSdnHwCMo+NjCgy8WljMXfMSCuQFogdSeRVHGJGIkmPi2EQVMra90cdI/F4Fz4bJxzykq/C2y1WYFl5QdcpXRFJPY22DVLqZXc42oJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yl0v5JdzqpptEUAAQNgt0fMtKbbwvaUqOjKxQs/HxC0=;
 b=mYMiItXe3E+k8lnT+RwU0s9D9UmZw7Q4hWFN+E+AtonnXa1yg3J42NwPIYp/dlWnmhTURnIPAwUHmZQnYng70lZyGSkYmsj2OQJZQetyAH3RYhoJpot4hgMTbO0OrTg0arKtPGVfJjmyQDPL4qyh8NiUOpnd+mDLnEi2ytX+dX0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CH2PR10MB4360.namprd10.prod.outlook.com (2603:10b6:610:ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 15:28:28 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Sun, 26 Jul 2026
 15:28:28 +0000
Message-ID: <8305f603-a614-44e6-b696-a7c844a07e6f@oracle.com>
Date: Sun, 26 Jul 2026 20:58:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1155/1276] PCI: Fix restoring BARs on BAR resize
 rollback path
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Simon Richter <Simon.Richter@hogyros.de>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        vegard.nossum@oracle.com
References: <51bde2e9-0989-4145-9fb8-cdfb08c50e29@oracle.com>
 <20260725192000.stable-0013@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260725192000.stable-0013@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0080.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::12) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CH2PR10MB4360:EE_
X-MS-Office365-Filtering-Correlation-Id: 725f1283-c5d2-4a33-cb7f-08deeb2a8af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bltoZsL9xyw01fEgpgDWtDZ8tStm487mjalkI5JSZ0FI9KttHzH0OSheBeRrsTkwLFc3d/2cpIwO/RAlxAvoUaa2h0vWYbVTWEtLDoHf/5acQe/kWpuLS3A0gNVkfC6WRf2sa3K8FkC/igIJttLKP0NU81HqI8O0Ij0foNPptMZzMNZDB4QUcSMuDH5PHj5CNBNH2kYpg8r2mL2MZlApVS1iXtj6AQ71irJ+Bqd2EAZfXkz+7VsF35Igh9BnpyUIDfuNL7qQ+T81WewxmwS4KG/Quc0LjMyQDmSY380lHAfOYKlRNYV9u5fr2OAfJFYyzSo8CteoRkIfvjan1qCWmJgm5+nJglte/vedSqVjMXl3ilHtj3jQaXz5YTEOO4H2yo3f5N2Gn1yOD1u6G6rsbO5K/0/k2huMqEQPpEZ3PjfVwbsIzTB0X3y08f37k84zNkvtYOy91ifujs0o3mCybgYq8ri/UnM3a86TPWEZhWKHT6Xo1kSL2cDBw4ad2TrjI93O9ns1lbB3lsDVTVkPBsQVFbUVGQo6865hIUwShjNs928XoRO/oM3L+sTOngXEwNLsJHog9B7csyT2sQmLIasc5oazm12c3tKUcV9HVW9FnQ6Xcdgnar1pgBV+Hq3+UeSaiTkA0LAVHdGT3DKMMwyDXF2fZI39DUBCRigVo7w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VE5lZUV6YXI3SHNYdy9URmVXQ0h3aXJ0dXRlaGVXY1dYdmVLd2R0N05DWlcw?=
 =?utf-8?B?QitPVGc2a0lKUHVneFhEYWFwbmFnVUdIQUI3Wi9rZUxNc2JFMWhHRTR6OVIw?=
 =?utf-8?B?M2JGY1FIN2NHSG1mYkU1QkluN2xTdEE5OEpFcGtoM2V5dW1zWEFIbXZ2dzBJ?=
 =?utf-8?B?SmtZTmwwa0ZERnpWclJWSHRZUnB5eHJxS1pUVVZYYTJuUXpqbW05SG4yZS9N?=
 =?utf-8?B?andsMVEwRnJKNmc0QlVSbGJ6NWQwVk9LL1hMeVhqZVJ1dmVha0sxOTY4dktH?=
 =?utf-8?B?WlFwclJjNGMyQ0NpWjBHc0oxR0EzcTRNL0ppZHNNS0JzSDRPTi80L3oyTW5q?=
 =?utf-8?B?bjliVjZZSUxQZUlpZGdwQmdWeWg3aHVpWUlCdXlHdElrcVRIVXN3KzZUVjJn?=
 =?utf-8?B?TlN6NWtFUjllMXJQdmx4NzVoZVl3dEhUaUp2V1hNMjNXY2l1ZGY4QUg3andn?=
 =?utf-8?B?UFpPU2pYd3dtaHh6R0J3Rm81c1FPcFRHK010cFBQb2QwcmZoTjF1aGNCeTd5?=
 =?utf-8?B?dVlSVS8yRkpZV3IzdCtzQnVIeFJ6VHJabkw4M2xveHdEQmE3OGNlSGczcnli?=
 =?utf-8?B?MUJLdVR4dFlzaytKZ1VoL2ZoNm1KVkl4VkxHWWMzeTJNMWhpa3FMSG5NKzNB?=
 =?utf-8?B?cTIreW41VlNRbTF2TDhqMDdWSEJGM2NaMlZ0OE54Sm9MVlp4ZkNwdldmR1o2?=
 =?utf-8?B?dXpzVDdKdEp4dHNnYXRibUZzVUZ3MExYUkxONmR3aUMwS01lOEJZam5WWlNH?=
 =?utf-8?B?QkpGSUI2MEsyVjk2bXdlSS9lTFBSRkVLblcvR0p3YTBPSm94VVdOR0pVR3VF?=
 =?utf-8?B?SzI4M2xBMHRMc0tOWXpPMmtqdDVoVll1VmYwWW9JSVBxVUgrcE1yNWR4NUJt?=
 =?utf-8?B?WmtPYkRQTTAwVlIxangwTkVUK1VuU3J3S0JwZGVFZUErMlNadnNvSWIvWFEw?=
 =?utf-8?B?VHQwaHlZcStyeDNHMmVrT2g2dGJ5eU9QUEQ5QzUvbGloVEVTQXVHMnc4OVUy?=
 =?utf-8?B?WDFNZStqRG10c2JVZW4yb2lhMW9zTjhQWnVRMEZ5MnVrcXd3K1IvUUN4aG9T?=
 =?utf-8?B?V25tUU5sTit6dHgzd0NmNFk4L082QVRUMUVBcUpHckMzcTZSaStCZVNndXN3?=
 =?utf-8?B?bnlqdFd5aUlSUVc2Z2xybGw5M2FMSjgzZDR5UDhKR25ESVBIaFhTWTI3MWFl?=
 =?utf-8?B?a0Yvdk1TQzJXNlFlU1paYnU5bi9nRWx0bjBNSngzSzcxZEtiMWFGaE1tV2th?=
 =?utf-8?B?RUtyRkN0eDhNakhNRlFHVVo3OXlGZndGQTYxQnpvWUZKQWFOQThDZlZZVUo3?=
 =?utf-8?B?VlNHN3JrZWtvdjBRYWRrdnBDOEZyclVSWXZBMFpnN2NnRDZacVZpeWQwaWg2?=
 =?utf-8?B?ekR4bm5aSkF5Y1IrY0l6VVpYeHlobGw2UlJxd1J5QzNhZldaaVdMMjlpaE15?=
 =?utf-8?B?SzV2Wmg2cnJLUGZTWGpTLzQxTXo2TStKaEgrbDJXd0pmeEdMUHJMalE0V0p0?=
 =?utf-8?B?aFgzV1BySkhBcGtOMWVPT29IcTlQTmNwSTNGNjNZcmhlWXRKWklsTWhhdDFZ?=
 =?utf-8?B?RjBWSFJlSWFaeE9zaDNXNEZzeFo5VmcvOVVIUjJYdUJJU25Hb0NiNHltOVh1?=
 =?utf-8?B?dHpiSE81TUpId1UvL0ZPckUzeGcwcnlzb0dqakovdFpIWm43N2d0dlhpSC9V?=
 =?utf-8?B?SWNWdEthTG95eThmUkJBKy9tUkdJRXdwUmtISlRPUzl6Nllic1JjbmZvYTlZ?=
 =?utf-8?B?N25PTlBWQnhNanJDaVlaaUtYL0x5QXhRblR1dTZBV0FITHVPNnVuTitsNm1Y?=
 =?utf-8?B?V3ViU2h3ZUtRQ0kyUG5PV09KcDFCWS8xK21yWitTbEhtSk5xZ2dWMXhUcEQ2?=
 =?utf-8?B?UDhvczJraUtQOFdHTW9pWHFQNjVoaE1oTUFtSDBVUXNHdUZ0d1FPdkpKeG8w?=
 =?utf-8?B?V0ZpekpEZWFwUnhGQlcrbWhzWlBudDFmcSt6Y2hyVVlPelhDbjB0NkZpSWR0?=
 =?utf-8?B?OC9RV0dIN2Q2THdGSE0rdzcrM1ZxSGJrMzRrU2h2OW1lMWpVUWNzMHJ3NG9R?=
 =?utf-8?B?VVFlakNZR3RHQUNzNnp0alZzenNGU3k0NlNkaWx1WVViRUpoamtrYy9nbkhk?=
 =?utf-8?B?OHZOYlM3ZWludkhxb3k3ZmlUcFppQWVudGF2Q2ZQdmUvU0lCWk5FMXVSSm5n?=
 =?utf-8?B?V1FnbFRETFQ0aTQ0WGY2WFZ1YkhkYzUxZktBMXdOMXJYN3dwWDFuZUZWNWZ6?=
 =?utf-8?B?Sk1TWXVYZno4SEFObkVScUsrNk5VdE12Z2FpYTZSU0hpaXNyQ0lCZ1NpOWFj?=
 =?utf-8?B?R2JwY0g4R0hQMHk3dGdPNCtNTDk0bVBrNzlrUFJqMHZCSVRiaElCeFJNRXBs?=
 =?utf-8?Q?+0ZKuRst6GZC9gksUI1P1EcHZuNxTaR/bossG?=
X-Exchange-RoutingPolicyChecked:
	Go2y3WTFF4ZPz0Lh/PxNooBTU5AL6y2nf3CW5k+WrqhWhRxlfwkxbITBnYMGpe7e0IW0itS6HRc4+Qz23/BIp6am+Aje0SlC+xAbRenn/vFCna9cUKXmFOahDu2fNB3Rsu5YcdKbFCSP5m605pEVF6IUs4DjrhwyGqrfu29fJuNrA2Ybv1f/B4SD5kJcCuHBjiFjsweF2EAY4DeXAmZpeO/VpV1sYcvPZnPlMjEdYBVEEf5M0cb8+OBZbrYtvm+o5UKJh2sJhS75ojY2eGgslqz+RmupMwd8tRnHGR3tLwIUuM/5JHsXHr/i4jtv1YyjBQ4OFfr12KBXRXbjHNBtVQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RBnSjOsb6SpNtiMLunvrDydWf76J4ShT2Lm0DwEjbZRQ084+ebeCfDpXt0/EkSoxa5YAEF1UdhAEQRGsxW46blzCPbBU6BXHy2pvoBpGoUhkeyiIDfeAi6nOYHrZSSZ8b8iI4X2WvUsc9ljGmkccbzZ0gtrt2hvMS2T4a7Tgq7RexgDN/6ODvA0+e/iCNRBIud99cg2xlEJ5ILxrODFG6nSG1DQACxLogMo1OAYBVxpD5nJuJQqlAu+0w0WYQHqhzU09x2oJMTOB9bGGbDY6XXUCXVj+WFqGySO7V7yaMtlQNU3tjo8RID7Ptj/g/bqAFE0q+8ggmnaBMAnl2SlcRjASr0ZWC1WmBoXVY2RF8j6su/dgvmpJXkr4CY/YBvOZJSlhC/xe6V5sij6RSAbYpCU00iiU2pao6umGuWAcgfeASmERPuLa4fEcwLa+9TAeCI2TY0tBBdeBHXJUnBl3X61+WKz4puwSiyOIix8BDyj/Wgo7HkOEyzym17rtunrrV0Qtq3ArN7VXMalSje9O9m6axQx6kr1YjOm0QfFCOBKBbSF4e0P+IGR1NcXL7+f4RdBDHfck0FfAPI+NLmlTiNR5HE8lR9YSmwmQF3+n0fY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 725f1283-c5d2-4a33-cb7f-08deeb2a8af7
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 15:28:28.6826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSTn3ycIUnE8lrpXODibzlp+Zl4g/5mXOaHkzCXC3P3RJHBip8siV/BWim97FnckpJICmlC6qpEqCMXUO/vtrV/dT338oR3+lhNAKcvWRVaA0gCKaor6+yFlqKvmm/J7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4360
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607260154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE1NyBTYWx0ZWRfX1vS3jf8Aiual
 6+VX/xf/0UJ/y5r6H8rgLbFOKZ28NrRDOqSzRawKXie4nkkrfYEJYToYH3tS8M5sTXNKJ59K7jZ
 DV/luEjddDRlyeh/B8nlGq22/zWzg5NPxwKvTggYzVoby/NiZwnCYxI4AOwXdMidSd6CRHhU9S9
 IV0aXWCCiPKjg8Z4eiNSUT7jVqhVkKUZPZx/njeWtoraNys0waWOTPgIjgWdcCjLNYnRv3M/fQp
 QPiwFjmRN5yCJ9q0P82B1dH71MmHtZVPOKBLDTdpAY/Cdl4RtFyUK6eP6VvIvkxlV7Vagv73tET
 RCagOHrlbEPurXhH5xdyd4dWG+Xkg73I9fCrRAlTxBOMuGfh6kXtBfI/J49Mc7dbY4+s6gDxcGz
 fsFq7HhjqJoXPQVatE0MNJkywmawyCkd8784uaN0c5w+u0WMiwtKQc3AgOTH44VF3qMaL32sN+l
 pCpWahWRDv4LaS2Qh3w==
X-Proofpoint-GUID: -1qTDRyDruha6KeJSflzCySWDlQC2spt
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE1NyBTYWx0ZWRfX1Y2jrIYRFqji
 n0poplo2Tc+oUSARfbBWO0zlpYt2/bu+viXY2Fz4vj4uHH4awAqmTNIgX/C2O4ITdRlJoFN5aXb
 xP/5U1TiGrYxBGq5jE8fYY5QNfp1xpt3gI28CQ+bQObxWWyv3rQi
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a6627a0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=2vlI7rbKY5C-V6cRn-UA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: -1qTDRyDruha6KeJSflzCySWDlQC2spt

Hi Sasha,

On 26/07/26 5:34 pm, Sasha Levin wrote:
>> Those are not equivalent. I think this backport is incomplete without
>> pbus_select_window() semantics, or an equivalent branch-specific
>> adaptation. [...]
>> Without an equivalent fix, I think this backport should be dropped.
> 
> You're correct that pbus_select_window() (74afce3dfcba) isn't in 6.12
> and older, so the backport uses an "r->flags != flags" sibling check
> instead of the window comparison. But that adaptation is strictly more
> conservative: identical-flag BARs always map to the same bridge window,
> so it never over-releases and can't corrupt state. The only shortfall
> versus upstream is that in a rare mixed-window fallback config a resize
> may fail (return an error) instead of succeeding - exactly the corner
> case the commit message calls out - and the common amdgpu ReBAR path is
> equivalent either way. Given that, I'd rather keep the backport than
> drop the whole rebar refactor chain it sits under. Thanks for the review.
> 

Alright, lets see if we run into this corner case then :)


thanks,
Harshit

