Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20A441684B
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 20:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788035130; cv=fail; b=eAWT41ECe+JbNP3bz2teA3iQciyfc4PEkNotmUIGGCBXjUSkF/K7tuPIxhmbymetc+Gsbvejbjh6dVJFAOtF4aZmchXrcKUFfUQa8qjfS2WwlrKrugRvIB0CoFoPTLf+2ssWNTZ0hIvtxZu+YDpzjvJQ5c52CUBcv4e927Syp2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788035130; c=relaxed/simple;
	bh=RMkGlTATtXcVB186f5TVNVK1oENNF+VcCpiacBVMe8M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gPP32k71X8WkCqYAxxistTQFW6Wx8PyJBDEzDdhZsHq/yxMPGyFOeDz5XorytMOGeTNQws2utRdsAe63lPUsQEsM3ycJdYxGQomZdcVqR4IA3NZGw7ARY5IG6rlq1IXtmYITtSAyJ3Osjxy4yNNgZHuff5WKziCIabb0WqvVdHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eQYlb2+i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SxOC2NGT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQYlb2+i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SxOC2NGT"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TJFTK22057325;
	Sat, 29 Aug 2026 20:25:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rTj4L0PLzAodVRTbgkoLyz7P68ZeQHhaac4LrmvJezQ=; b=
	eQYlb2+iqFxtfyZ1/KYApLoMS+OILbj5rKmyTIUJkhW0eWlQMNcqWTvOD8sxKhL1
	TacF0QFTyLymigpfe2RmavzWdQHUrc2Lo6Z8RI+U6thR4CrxbSnz1hC8c1ZN+aTi
	LdkBmNjgKf/S+QgftkQi9gTUKqJPEqWIP16J6MiF0lVVPNqLdp/1SByDhaqN/iK4
	FNcd0ilHG3/VfJCFK+4CDcwMD8IgVELhFvJYwQtd4sMFPMpGuUX7xwrDfZo7y5e/
	gNmisXzXMgDUQgSxe/e4ries9KMuBsDWxtqimM/RHiEKJWkZ3LbCmPTUKoxsU9DM
	KxOv8Ho1FasxIsHDjAeH/g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbarm5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:25:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TKP5BA024397;
	Sat, 29 Aug 2026 20:25:23 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvbqpw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:25:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GgM1foQ7vCe1o72zcrVaNLmBtkcYaZq3ZsqcGumSrPzwkW8MDgS3o3LOoyUADpGBtwxudCdpt83gtxj3XAYzTA/VRSCDdIh3rPt7w9qIfNbWk1hAJIDINPqrhIbAYC8sMIzcw/YrdaC6rZ4pcppM3PoPSIPme5rbo0vTNfecGEcRSHBTOuZ8CW25jq4jmx/Y7/EG+xPY1ZIQsQMNCXeBJFt5hKU2jJiHZoLQIKe7kJLiyW26LrqgByGF5M49KMtyKFr9u0bl2Oz0qDx0FJKC6y53Z28TLIOsyoBKyKlDJYrKiUnva6X8XME/fWXQqPs8InTqTiijaezOPHmzVZ6C1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rTj4L0PLzAodVRTbgkoLyz7P68ZeQHhaac4LrmvJezQ=;
 b=uHWtg0MolAKorCaBwJ3p/ayAnKDBSewFdqa5O57Ed5c6ILIa8j9WEY3sp6ESqRzL/epvqh96FwrXf8Cos4UpMRadj/NiJdgjyMYOs17bNKnNBT1QAbCeiEUNPI+nmfAWWBJQLsFlbdO7PLeaKcy5zXV12GkUJ/7EJMYcbN12PN9MSibpmn5aQpQo2aEVFKJBAE6SCciaUI81yAow8BcD2TqoAWYGJ9e91vCK/NfoC1aKdPgMl5F5QEAPsfr+a+iVDlHxw8ITZpHMNGGMo28Rjr587cgKXXa91/FyCB8FVjKudtXwhZ4hjihLc5kvvOMH3iDRIwskVe7jBRFXnuR+Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTj4L0PLzAodVRTbgkoLyz7P68ZeQHhaac4LrmvJezQ=;
 b=SxOC2NGTfJMQzjk+LKh2F0bxNBI3BJB0Ba33AtCxsphNYNJOj+mJgGExpyQ4iMHLLG4XhFLmyWK2vNvUEgYd+2JuaAxV/Ch7TPIqZ9WLYGpS2uuvT3y7MIhLo6CJeOwZfeDQwoR9qhGId3KZwxtuJ+p7eDIJODhSCy7DTnrYD+w=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ5PPFDE7085185.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 20:25:19 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:25:18 +0000
Message-ID: <59e29236-6d2b-45cf-b6a4-bfaa0cb6b1cd@oracle.com>
Date: Sun, 30 Aug 2026 01:55:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 202/220] veth: fix queue index used to wake the peer
 txq in veth_poll
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        =?UTF-8?Q?Jonas_K=C3=B6ppeler?=
 <j.koeppeler@tu-berlin.de>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260820145223.480031205@linuxfoundation.org>
 <20260820145229.585901230@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145229.585901230@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DO3P289CA0014.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1f::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ5PPFDE7085185:EE_
X-MS-Office365-Filtering-Correlation-Id: 14ca8c06-61c4-459d-1511-08df060ba493
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|4143699003|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	idUoNol09fnGXn3xiJHK6y2IUSYc3ibaiZsFcWnIe/2kH0tBe5F/qU/PdcCAP+EEPDMSH6rf4HkTzvX93Rkw+WHRVR+1N7zNyDYIJbeCFesUgr2PNQtVbDCToim/iopicyK2dKO9iFbl1VRov4OD0T2QZqGzn79wEJUQ1x1t0HJNsN99I296uBsa/RPAiJ5Xy5f00CFRU86HwiFtM++SDTEut8gW1UFt37ZnPXVj6y0Y5kAo+Y+uJPcFan3N0/OMl3dSHRzzTkC9g56UflOAycutcg3NqiQtmRIsWf56zOVOajC1Kcfa7EUoEkCSpOokL0+trr6dVSP/yOmNicTaLw48KWujrIZThcn55vsWbS4CqQpSZyBVoKuxKidKLpDfMO6hXZA5nn2dEUxfB5LAkRjfA8qTcpmk1rMS6+ttjzIi6sTe4V+cXUBMzuqqIi626p7L2KEf7jYFJRZednn9snf3yyydogsfj6PJH0VxVRp3oCtfY7581wY69mC9DZsmgUm0YHWzdL8guGi9EZOSg7AW7/phVeMJ218rOf2p3LHTci25PgvPUYjlyrfjmwOo/BpRNu9yW6PFJdMskike1myQdakxxDV7jffzNKUzEWYP92JXsurxoXp+VrN8aXGD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(4143699003)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amphVjFHNHkvYkNTekEyMTJTUnhYZ2ZHODZIZEU2Sk01Vnl6aDJ1WndpeFBB?=
 =?utf-8?B?aEZGVllIcFN5ZFI2QlBXbHh6VmZGSHcvRmtzRksxOVRpRkRJbU1pVnlvVjhy?=
 =?utf-8?B?eTd0OEhSUjJ5RTIyOG1NVkpiMUV6M0JIMCtCaXBtZlJrQ0JRRzZ1YmlDOGdw?=
 =?utf-8?B?OVVMQ09IVmtVNTFBVzNSR3o0ZVI3MVNrNXVNbkY1RFd0SStUVnY3WFF3MEhF?=
 =?utf-8?B?OFc4b0VJUlpuVmZMRTY1T0VHb1FwUm1VOXBMcXU1a2NXTEpNYzgwMFN2Rkhj?=
 =?utf-8?B?a1lEOWQrdkhORC9Ob08va0dsUzFxUjJ3aS92SkJtdExZQllGYUNSWi9qVTRH?=
 =?utf-8?B?UnhpdUFYOGtkOENUMzZIQ3dqVExMRldBc1RkODhEZ1NIcWszU3RwOFR3OVRI?=
 =?utf-8?B?bU51RGJwaEc2YUdWRGJuZVFMc3o2NjdPWkM1dERlTWF5b0QvTmdzU0dHQSt0?=
 =?utf-8?B?U3VkY29QMFZtM0tSNk4wZ29SR1NKSVkycElxR1NnTTNIZnNsdE5saTJYMjNj?=
 =?utf-8?B?bWdaejFDTzdId1N0RzdDTVpIWnJLT1ErRno2TTBmWkxrV2NHRFVWR0ZwRU5P?=
 =?utf-8?B?dlRmaVVIZFR3NzljNStVNFNIaENpZ1R5bmZuS0h2N01rcEtXSFhjcHZCaG02?=
 =?utf-8?B?d3lGUWRPMXRNN25xVGNFaXlCU05VOU0weDdCR2wyQW9jcGVKOVBIYU96UE11?=
 =?utf-8?B?WUtnQnErYms4ZTBIQlRVRUV0ZGp0MVBuQ1RZVUNvTnBON1ZwWFZrRURRYUds?=
 =?utf-8?B?NUxlVjZSYmUrWTF6czlyYllLcERxOUdqalZrUmdyS3hhTjRLR1Y5Q3BEM3Vq?=
 =?utf-8?B?eEJVaEYvOWFKcG5QMUZFZlNNUXJmazRZVUs2Z21pUDhVOUpERWhZcmFGMGtz?=
 =?utf-8?B?dk54MmVKam9UZm5oU2xWYkFRYkNhODU4N1pId0dUSytzUFBOZ09TdGVTdFdF?=
 =?utf-8?B?SHJiNGlQV0dVd2Q3Mlk5dHRwUTZKQmNKN1VodFRieXFmcVZhS2VoaDA2aHFG?=
 =?utf-8?B?cEJLY2lTR2MwamtqMHA5SGhlREJRL2hpSEtKV3NKbDdlbmc3TlpYT2dEN0tC?=
 =?utf-8?B?aFFtblN5L3hMbEZoUnE4SWhzdWo3TDcxeXkyUVgzUjRQczlvK0ljb1FJL1R3?=
 =?utf-8?B?NlBXVDFUc0dMcEoxR2haMUwrR0EyTmpCSEc2WGZmOFYyd05GcDcwR0dWK2g4?=
 =?utf-8?B?UE9BODg1UTgwSmdRb1JqbDNqZ0NCQTZJc3ROV3ZaQklMNlp3T3BjZFA1UHJM?=
 =?utf-8?B?L1pnNGdGSjhia0EvdlFhQjFxQnhFbjlIWEJjMzhSSlVzczdxVmdsanhJTm1t?=
 =?utf-8?B?bENwWCtZMmc4NlNzb25HTUNKYkswWFIvck45ZEFUSW9NWVFaS0ZmTGI4aUVR?=
 =?utf-8?B?aFJvbVFBbGhrS1c3NVdPYzNROVlhdjJ5emNpZysycXlUbGhEcGM3ZTJGUFRo?=
 =?utf-8?B?SUlwTkdrenR6YlY4L0UzS2hrQkd1NnR1RHUyb0NlQlp1UUpoVVNoVHZPbTRM?=
 =?utf-8?B?K3JyTVh2T0FXcjVzMVF2R1R4ejZ6alBTV3duWG1BRnhtYVNWUzFYZ1MzYlht?=
 =?utf-8?B?VSs3d0N4TlEvSWt3b1JnNThIMlBnblRqTnJET1dEMkVib0Z6UmltZ1REWGxv?=
 =?utf-8?B?cDRTeXBpVkp0V20yVE51clFlVkNiaFBtcGxVOUVtNkhpa2tWTmU2ak5jcnZS?=
 =?utf-8?B?MjQxQzBnd2FDb01oR0pDSURHYnRXZSt4TVlKeHV2NXBuSmp3ZXJaaXg0RVR1?=
 =?utf-8?B?eEVrSEFheDVjM25WbmgrZ3g3eU9JTWwvTWlMU1RJSTc2Z2Y4U2JGcmNFeGts?=
 =?utf-8?B?SUlwTThNbGxNcEtEWVQwbnhoYXlxalNzdVYvbDE0dnFBR0FJTTBaTzQ0S2hU?=
 =?utf-8?B?cXkzSElhbmVsbUFLMFNFVU05dTJhZmF5eGQwVnlIZDFpNk5pV1Ntc3dlNW1O?=
 =?utf-8?B?TGZudmhsTTloTWVxUUY0ampLUGV6bkdkR2JJTFZ0NzlPSXJ1SzlDS09ycy9l?=
 =?utf-8?B?WGd1bWNqSGhXMkZ3ekVmbisrci9OVVh2TVZlU0k4SUYwNHpNd29RRERjcHBM?=
 =?utf-8?B?bUlYRml4TWdicGQ3M21GZ0NLWVNTWU9rbFpLaW4xMFBxdkRxeWlUaG4zY1p3?=
 =?utf-8?B?SnB0TFdhZ0pUT2dOTHRvM2Y3TVVmOXBCWjl0aU5JUWRnQnBEM1AxWm5PM0oy?=
 =?utf-8?B?NTNxVzRoZjFYRDBBT3RNQ1Z3c2h4S3RGRGd5TFgvSEVFMnU0c2pyd09ZR1Y2?=
 =?utf-8?B?WU5aWTlLdmxPZW5EWHhjOGNkMjFsWEo4NGdYTVFyM0E3NloydFJ2NWFsWFhB?=
 =?utf-8?B?TE0yM3lKemc2QnY2ZXk5bS9UZnRac1ZENDN5NS9iUVZLZ0dRUWpzdEJOclVn?=
 =?utf-8?Q?GHDyC3nfCmhs+atqTEJArqIqIWebllP4WaOCV?=
X-Exchange-RoutingPolicyChecked:
	whTdWRHh2jS8NEehntoEgOCS5A4UEMrR1di3pOubZZ/fAHPj6Xvu+0tWbIjfxSEjNWIS3WStLYEvl0D9CPwxC/EVZyKPVXAZrNbZAYs2VWYJlmrgZNcwg3vN0x/ijUrlSZTLm5NUwNduTkDiYNKVl0WfIcfdvBvO4JB5YhXy0SFT2ot65hrHog2kgRMq9CwK+6uaXstcynYBswBCo/WpoLOPai5C//VlmObfRp+1bJmB4eP0DSz9q1Vtr6jQwlbrvJwo+0bGOGNC2dATzEcCAyH8XYcHg3dX+6v4HbZeVnD1clCFV7l1Pc8bJQoWzcIMW+pD7v7vB/pqKx+1f4CCBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	efd5TK+U9Fkv7ZlqP4KMCwNUNoI3/OlvjWGCkhPyVuUkM+rvPMLC5c7qMZWdxSQk8qwjswIL2E6dcE0sP1p2H5a+r3m7aKXNJ50Bri2VzpGwUc/R7EGm/afoGs+iEoQNsdZAJBT6JqDeV7UeKPNPzz6xOfDwxGZkDu02SnsPjHzhqKzOytcqc12H/5Oou8p9hHl4M5Qd7zr5XAAV6J0n6KO5TIA3CmN9+BhBmpTA8CibfRcZGXGKbv+n08trpwd7P7kyrf/oZewNhkTosWKB2dz8hNm8OToNDX47hMGgumGV0nFm9CSIN2TbrLkGeqgmwEjR//5KMNixGXgAHyRK98iaytf06c9jifdb06l4uQJnuB4gBLJ/QLD9wxjiuF/hGrMfI9oS8bzNaPrLFkb/uS8ctDzZRO5/fjxvRnPH0qtReeTH44lucGjIm8HERz09tFatjLLroOC/7epHXJcJHSzfbhAturhjIt2UR8qbP8OzJhmQL4sakzhhwne2dT/fWApN0ue29RkgsRMKu3SArn5StEYOx6GZoDVTuJ3x66rEVBe6ndcrTDF7GeA7bKLWlUkcXnm3yy2mzeZE4irckLem2SiJxImo0JQhY0MaY8Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ca8c06-61c4-459d-1511-08df060ba493
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:25:18.7869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: op7gi/zjfqDXE85DSY1H5HruGkO61zTFcnC2DjPEQu3TjQK+tBTYiaKJuT08auTTbpisgsuEtyWa6/FLNzb6R/qKh3EEI7a4v5eGC0t6EurQql7mDgHKqZKDurcvXZA3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDE7085185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290177
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE3NyBTYWx0ZWRfXzVbdgGezKCE0
 2XZFrIHw7iRgQuz3RV5Id6in3XRHtT0S4I3nGImclmWDCk5rz9QrvdDlZleoQDdj7G1odLDQWwI
 8KHz3Pl3cHmOrtNQ2zDV7B8tp3Yxwo7TTUWCAmLaEnV1cRZu5z5p
X-Proofpoint-ORIG-GUID: SlQhgfLISPuCyZrZLk9ni11Y7b7qNUkd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE3NyBTYWx0ZWRfX/Wae031Z15s0
 cGp/Hc7VW4+tDxr/D6nkl8lJbIEpuRZmLlgFbL7SD/wEBq4epTLDru/0mAA7l5J4o9OnjTYQgXP
 WGmMEL3LXnWWQ6zjE/ykFFW5YftwKWhf9jDMxNQFhzUchuau7ttjDMvJnwNt1r8TR24jZf0zo30
 Hy4+tlrynZmKdjAOE7zdeaDlmYT7/i3/AFYQa//Kp54qKhLegt2UaGGcESiacLy2wI7p8tRljup
 DNYVEK2d558QEhNv7greUp+u/LDbmdStnVHPHuTCinq/saZNR4crtiCZxDnkjtobsDrzYECdFkn
 bZHOFtHtVRFNO8WhENWj09qb8MzWNL69Eq+5qS0yHkn7hbEqy1RGSt/slw5DkWnFVIdutoLdW5r
 r1coFKMtFnq02w4kvSQ9XAF5PzB1qzg7uxr1ABRu7/iBWK55nt8mRgYWNss9sFzLVnLj14V30b7
 M9SPLTchIXq1scR0v5Q==
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a934033 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=NEAV23lmAAAA:8
 a=bC-a23v3AAAA:8 a=VwQbUJbxAAAA:8 a=Ly1BYpf4mVyVcGCG8LsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: SlQhgfLISPuCyZrZLk9ni11Y7b7qNUkd

Hi Greg/Sasha

On 20/08/26 8:26 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jonas Köppeler <j.koeppeler@tu-berlin.de>
> 
> [ Upstream commit 60db47f02bfa2aa688938aa199117ec4f8e31d23 ]
> 
> veth_poll() derives the index of the peer TX queue to wake from
> rq->xdp_rxq.queue_index. That field is only initialized by
> xdp_rxq_info_reg() in veth_enable_xdp_range(), which runs only when an
> XDP program is attached. On the plain GRO/NAPI path
> (veth_napi_enable_range()) xdp_rxq_info_reg() is never called, so
> queue_index stays 0 for every queue, as priv->rq is zero-allocated.
> 
> So in a multi-queue setup with GRO enabled and no XDP program attached,
> every NAPI instance looks at the peer's TX queue 0. If veth_xmit() stops
> peer TX queue 1 because the ptr_ring is full (NETDEV_TX_BUSY), nothing
> ever wakes it again: the poller draining queue 1 wakes queue 0 instead.
> veth implements no ndo_tx_timeout, so the netdev watchdog does not kick
> in either, and the queue stays stopped indefinitely.
> 
> Derive the index from the position of the rq within priv->rq instead,
> which is correct regardless of whether XDP was ever enabled.
> 
> Scripts to reproduce the stall are available at
> https://github.com/netoptimizer/veth-backpressure-performance-testing
> 
> Fixes: dc82a33297fc ("veth: apply qdisc backpressure on full ptr_ring to reduce TX drops")
> Signed-off-by: Jonas Köppeler <j.koeppeler@tu-berlin.de>
> Tested-by: Jesper Dangaard Brouer <hawk@kernel.org>
> Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
> Link: https://patch.msgid.link/20260806-veth-fix-poll-queue-idx-v1-1-c5357fb7573d@tu-berlin.de
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/veth.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 2feb694f58bb9..96e373d65897c 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -967,7 +967,7 @@ static int veth_poll(struct napi_struct *napi, int budget)
>   	struct veth_rq *rq =
>   		container_of(napi, struct veth_rq, xdp_napi);
>   	struct veth_priv *priv = netdev_priv(rq->dev);
> -	int queue_idx = rq->xdp_rxq.queue_index;
> +	int queue_idx = rq - priv->rq;

^^^

I ran an AI-assisted backport review and then checked b662a1fb4f3a 
against upstream commit 60db47f02bfa ("veth: fix queue index used to 
wake the peer txq in veth_poll"). I think it is missing a required 
predecessor.

Upstream has:

         peer_txq = (peer_dev &&
                     queue_idx < peer_dev->real_num_tx_queues) ?
                    netdev_get_tx_queue(peer_dev, queue_idx) : NULL;

6.12.y has:

         peer_txq = peer_dev ?
                    netdev_get_tx_queue(peer_dev, queue_idx) : NULL;

b662a1fb4f3a changes queue_idx to the position of rq in priv->rq. On
upstream that change follows 08f566e8f83b ("veth: fix OOB txq access in
veth_poll() with asymmetric queue counts"), which added the bound above.
6.12.y lacks that commit and permits more RX rings than peer TX queues, 
so an XDP redirect can lead veth_poll() to resolve and inspect an 
out-of-range peer TX queue.

So I think wee need to backport 08f566e8f83b ("veth: fix OOB txq access 
in veth_poll() with asymmetric queue counts"), but I don't think this 
backport is wrong or anything.

thanks,
Harshit
>   	struct netdev_queue *peer_txq;
>   	struct veth_stats stats = {};
>   	struct net_device *peer_dev;

