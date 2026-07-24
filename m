Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EEC343899;
	Fri, 24 Jul 2026 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906035; cv=fail; b=edFIbJPSPfXsOxZaqU2H3ERKS4ZHsImRnkkVvT4Omm113Pzwjk1SBS4B8hsvnYk2pALDg/85p7lgtpvmFeRzVpo0Zx4nVgDM44zzjWXieUfjvjXB/zpjqoT0Z+MwZ1tvpxV/nDAMLz7QxZSr/PR9mPcJFnDrzAeyuWt05GZh3ZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906035; c=relaxed/simple;
	bh=KlVaDE3i0w60oysbTEwnWIHwfe5TEotCnm2WLAsDO6Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VLEfZxgbguRZmSFjfTpmTHGsO1sRpYD3wRHQyvOMFQziMHkdIqlt5zsULHGygPHGykdiJM/ZHyXwl51Z2FR9I760nhtRJrmld1VZYEBn3G1grnfU7bJIgU68XHa3xIw5KEW5pjRHTKgoXrC/KBl2GaNSanN+9QMTqTkT/htTubc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mf5nwcjx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z8DnWH8Z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mf5nwcjx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z8DnWH8Z"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OFBfaX3585667;
	Fri, 24 Jul 2026 15:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bKZSM+eMdK9nx5HQrBQIhW7w2w0JEYQ9a671lCqZtHw=; b=
	Mf5nwcjxkpWbDskOzmMTUfOm9kwCnF1CPNYH3LpaEyA8BB9pAUr46h0C60ScmV1F
	eFiGbTaLoNWh4r4zEITbGjaj3jYhTj44AMTkr85cmXRkOBcJ/5res8qh2ptQBH31
	c1TeI9pNrXr5ZGMCqAvBmSK6pYEPg6yDd7g0jsNjyomZ5xMp0qLlKW6nTleKJUgz
	Bem4CDSAAuCHB4pRYHvbRHAWbp36THd8wLrgD7qTBbkbh4O6zIY4ikVN02TvV8a/
	JZDj9Z5+GMzDhrPhIz4G7D60n2lVYWda7gFOBA/dn9wCMei8s9h6mbJnvCSUrR1R
	P1Nlzhw0v8kUR75EeGIggQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv8n82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 15:13:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OFDBX0000948;
	Fri, 24 Jul 2026 15:13:34 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012070.outbound.protection.outlook.com [52.101.48.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxg4u1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 15:13:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MEduTsEwZpxCe0gn9H6+c4Qf5+n8ns/dtVAqjC9SvbhlX+Z1tx+nSvQSY5DeCZKkeKqDFUc4jFAVSMozhN/qVMEQ5g2iGHrXs0ET8OI/0eBE4X9l1g/98dD+g+3UfpURPisOgoFfd8lO2z7uGXmy8Kc9xK6qsbFdOGhvanq1eCbrhbkCGu+13GX02Xdkm+NdLIkKjaSZ8sWtkgGgoPYxVFZJoTxgoWfUW+vqNjO60oKYtfthoPwVK8RGl5W/zgYnYojfFNrnV9GeNb8Z2Kg8ZqpYNNyzXtSRuP+1oIch1nVwv9Xrgqb0jIN3s5mtprcNnusQe49SauxEO8kzca1vVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKZSM+eMdK9nx5HQrBQIhW7w2w0JEYQ9a671lCqZtHw=;
 b=aEXB1YroRqfsgyIvo5c8NIfN/g5zG5o/7oOqsYlnNpQDWlHTIRPyVZB0sq4e6XbvXnuicEwGAkCHWTYWfFu3C41eQgX/hNAt76dIf3vwapOvnxf+N//cPBcowwrGMmWE8XPs57WOD4I9fGNXJucbNs4HQKfDXIw+QJD4HC69G/WmMBfdLkZ3uPc0O0o2iUKGH3OS57sGTxcdPtX5YUeTEjdVNcHELwroaM6/6gzotrcIuHNLuOi0wP46AicI+iOT0/Jlbl5jJWgWE8v1KMD8ZE9zOKtFPEPl4HJU9IbUfu1SHWeMywY0Bqe4wz0U8pt2vJntD3EozfnGRszEEMgkUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKZSM+eMdK9nx5HQrBQIhW7w2w0JEYQ9a671lCqZtHw=;
 b=Z8DnWH8ZzW0vO6mGpZzaXbnOHfbizcdRzBhip2f5nFJOyRReEaTKB2ToiBRYc/hCg4wx2HeQy5FTNgDQZ0gA8ZOoN7eQK4H9awjMPwDsCul66vlbi1qyGpFA3AjDMmwz2zj6S5b5Yq8oTWzezUq83plgtCcb1laFrA6gAtt5BNc=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS4PR10MB997620.namprd10.prod.outlook.com (2603:10b6:8:31a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Fri, 24 Jul
 2026 15:13:30 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 15:13:30 +0000
Message-ID: <51bde2e9-0989-4145-9fb8-cdfb08c50e29@oracle.com>
Date: Fri, 24 Jul 2026 20:43:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1155/1276] PCI: Fix restoring BARs on BAR resize
 rollback path
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Simon Richter <Simon.Richter@hogyros.de>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152511.861098835@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152511.861098835@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0239.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::18) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS4PR10MB997620:EE_
X-MS-Office365-Filtering-Correlation-Id: 77e02022-f623-4e9d-d662-08dee9961ea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|6133799003|56012099006|4143699003|5023799004|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gD7j+yPT0YWS5r+9WUVjie76ho/UmV0UEpStke9jOsrKGgNGlkpKpNP7MsBKmmGVgC9Ivx0sMipcW7+j+oohNTcVSCPlcURo0I7VkStjxrFZ9fY28fDPP03HKWThXKuVXv7gS00pYjqUxJo8kvQzTpJSdRx0PdiAwwF7YPPZL4xjOsyhNYnDHdbdOMrHjv8/Z8EWHpGGTFcsYsJqBht+jd4c1MdLGrHfN14jsm0OV8ieIypjB5lZvexRPVB9Lj6LNZ3ze4VoGNyrHxoN6LSVGSRYoBKaFdyHGwKc+kqaMnuFyZJAQO1oAMxNtOvPbKLifQ5+lLZfzjoeIbfjp9vz/ELq5ybFdvE8yRSzbUHa+lT6OEcLSfRoeZeNnilWDM4xzbaA91FQ+cGdbWIQLiGzBp3hICjMEzZQHEXlZtRa0nQkRsc4eSXBBUDxF9N4fRBxS4GlQGFo5PnlLmY8Ms4wNTYSl0RUwP0CZO75oCGYv5C3UPPYsv4V17t1gQr67OgWeWu5BheLX6K1Gh2zScy0xaY5X+MQP1tZRifFAv665SOHOmaOLgFv9LlBUnIhGtPNzBNC86R88fnjWX3yn0bS4j+nt+erQHi/1YTzgcHGsNvunli+lX+ysGyOZw+yWbuB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(6133799003)(56012099006)(4143699003)(5023799004)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2tBNGpvMitSZzZ3UndKMkJWSEZRQ3pNTzRveS9YcExLSjJJY2tmazdpVE9V?=
 =?utf-8?B?SWs0eldYd1ErRWpTL09CeGE3TGFXNW9oQjU3NFB5dlppZEtUQ1FNTlg5bENJ?=
 =?utf-8?B?UTYvYVNwbGZGMkt2dlF4VFJlZkFRMGtNem93cmhEQm9WZDQ1R1VsMkFOZzF6?=
 =?utf-8?B?Qk9GVWE3ZFcxajhETnJKOThtc1Z0QlhIOVByeXpVeGdPdWU3VklTc3BwdVBC?=
 =?utf-8?B?aHd4NHdKY0prSnhkMFNXVDR4dkZaa1lzRnpsWFZyWVRuWEFDNk5QWVhuQnlT?=
 =?utf-8?B?TnVSVXV4a2M2KzZPSmpQWlQ5ZEg4TG5FSVp2d3R4VzRLUmZKSmpZclBwVjRq?=
 =?utf-8?B?ZEpEdDdPUzBYV3NFc2oyRDYxNHlJampTeVRRZFB0UWFqSHhuYklxYWFxZita?=
 =?utf-8?B?TVhYLzJ5U1FQS0ZpUG1DMFhEQmxWN0VZRnVzMFJjeTUzSUxmOXRMTVJaMDFt?=
 =?utf-8?B?QmlNdVVYczh3SGhoSFlhZkdzcmxpUlUyVkc4MlZxYVhEdnZmemdnRE5vb3Np?=
 =?utf-8?B?cFFQc0ViaE1jYTVmQm1LRFdHc2xZVnN5anBqRWE4aVR0cHAxZEYrR0NpV3RR?=
 =?utf-8?B?TVg2RlJBd3J6K0kxR05zWXFjWHA1dHJmVTRhcVArdUpuV0YzYmZxZUd3dDU0?=
 =?utf-8?B?dDlzV0RKMHRDLzFjOFEwYW5JRzJPTmdOSTdEWmszaHFrNTJBc3BiZmNTM0pt?=
 =?utf-8?B?bVdieW5OdGowMDVsYzZNSk8rem1TRVdpZTNTWXpHWmtQQVp3NiszVVkyYkkz?=
 =?utf-8?B?N2xXK2pQLzI4Y0tzanFvOENFZDQrUEVMQ2tlVUw0Q1pOZ1ZpRXY0cW51ZE5p?=
 =?utf-8?B?bm9jSWNKdTZZK01yWTNReWlJRy93dzM5VzZ2YVBMblZoUTMvVmJ6ckF4TS9z?=
 =?utf-8?B?cURaWklyY0Q4WVdXY1U3NDF5NmFWbXlqd3pJWElLelNER1hzZ3BVRXg4MGFu?=
 =?utf-8?B?SGs1MVpEd2VmMHloczRrNFlkK0JwSXlKZlFWU08zU2Z0SVNwRG11aWlNVWN3?=
 =?utf-8?B?WFIxWitoZkw5K1BpTXRWRDNHUDY2V2Rzb3lhQmZ3VE4zQlVKVmpvUVQ3aVFJ?=
 =?utf-8?B?RUpJZm1tbVdkZzYxQXlMQ3RSUkNTR0ZFSmlnQWt6SmphZ00vMFZXSmtzSk5o?=
 =?utf-8?B?YUVBM1JBWVcxY29vQnFTYzJnOUsyY2NUUVducXZDOFFQd0FHZUdEeEdibFdR?=
 =?utf-8?B?TnAyazBJOVlYcjh0bkVqNjJXekdyUUhCdHRrMUNHMmZIM3NpUUJGOHJaaGI1?=
 =?utf-8?B?TlVyOHpkbEJndi84NDk1d2paTkVTT0YzckVkSGE2MUlheUM3bTNXem04ZDFC?=
 =?utf-8?B?SUxmUzR2WDVuR2hEb3h3b2pDTWVUR0hsNGQvMitmNUhwUFdpc0xsMkNnM2Vm?=
 =?utf-8?B?dGZabW5zVU5xcVJFVjBIZHFmOGRMU1RpMStmNGVUYU5tR3IyRHlXOTd5cmho?=
 =?utf-8?B?R1d4RVNmWkV6RU1MYmpMS1VuamhXb1hLd0FpbnFlbndZOWJUZGtBNmUzT3Jt?=
 =?utf-8?B?OHI3U09lWWRJZ0dGNjhvdjRPcXhMbDVNbnZWbFRLbEwxWCtMbDRPcWZOa2dD?=
 =?utf-8?B?SXROSmZSa1o0V3NpbFpWTWVnSUVxVkRTaVg1Qzk2aGE4WTE5ZnFnM1ozM25s?=
 =?utf-8?B?RWJ6SllUS3BtWlA2NjZsU1piUDdTZ2diL0R0cmpyRE5oNnhQaFN4MTdKNVdD?=
 =?utf-8?B?bFhEVVJsN2t4dEtJV3RsVjU0dkdKYWFnTGRuSUswRFZCMDI0SXZMTFBjclMx?=
 =?utf-8?B?Z0VCaHNiQUVrT21aYlJJSmRXTUNTNS82VWlOQXJsdEFNOGlFajNqVm9xRkhu?=
 =?utf-8?B?aGJzTWJ4SHdMMHNiQkFnTFEwaUZmdkRTRXRkVGd5NXhOUkgxakJCcGFEOURM?=
 =?utf-8?B?c1R2MCtCMGNmT0Jqd2NHTnBNbnBjNHVjUXYyNE5adDEvTEFmcFZDRVllaFRs?=
 =?utf-8?B?ZzJPK3pkQTRaOGxMNEU0TjcvUWdmY2IrZll6Vk01bCtsUUljVCtMTmtUT3dW?=
 =?utf-8?B?Zm9laGFzdXZ4cjlCMFJxRVE1Ny9SMGlDSFFyeVJSNStvZDg2djFxREV6MWhv?=
 =?utf-8?B?NVY3eXZhV1d4NkdFUTh2RmtENGxJblZ6RGd0emdEemVRYk1wRU55UFFHSmhO?=
 =?utf-8?B?QWZsRnVENnRDaTZMSkx3SG1KMEIxNGJoc3UwclRiQ1pUcGVwd0h4RjNMcURQ?=
 =?utf-8?B?SFoxYkl3OXNJNnVHSkw5SzlRQlNqM3NLODZxTHl2QVo5NmdKUWcycERDRlJk?=
 =?utf-8?B?NDdpZUJsUENSTjBqTVczaC9JME1HdjdkclBLTWVCQTlqU2FLeHUxVjR5cUtJ?=
 =?utf-8?B?Y012VklQV2p2UzVqYUhGemxvM2gvMWJwL1QzTEhkUjhiODJNQWxxT1ljRmF1?=
 =?utf-8?Q?FZJl+F2YgvFIXpff8vLX3C3B4HzXmNJ5cBM26?=
X-Exchange-RoutingPolicyChecked:
	ZSLJVtHFhprNfi7H9LGysy8LFcsC4LlFhvS1bEazGiYuw3mJcIriDHxpJNfPhj41LlIwbY3zWuWQ7CkfGtSj8ciCNw0NU5HmTvnG4/pJDiR3KMmyvmHcU0M+uNgFl09qJo4E0fhy6exSXe6ICD/KY1Yika9jJzYqGAdrtFibfRE7SW3MWgDo5NGiukvqGATHBwRr6r7pUDJuqALaeydHolGnkwJEr6jVuZVRvTqv8aY7noI/TZQqHgKY9wt9XA9NPjRi9X4Bo+GBDf7LhDDWpzqY0WIgqXuTGwEx3R4DvCbmrJ9uf31Prvor9Qm0D4oSmDWM9SXfQLyomjyr3KsnEA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dMK7Zh90jpQ9OWHJMsU63WFTY0Hf+rm1t6nQEpUVwp9xI2dufLmCPTRJkRnb5FIa0aYMWheXbH8FzHKi6lk1hdorAMTX3EzI2CsZa5zzwGd0AySeewX4fSF78hcmyCblDeifXOsPBNiQy3IqpnXAcBFuk04V0tX92wwqSA1ORc3b4iKK5+6vt0LyByiFaTV4XkFzXG8TgQhuPYiWB6jMduBFbjYKuazpmru4v83TBUxXDi0OCII3m5LKFHjWewrs69CoIblC50YpRmsyyNemncvmE5CzxprQlpl7vxpi9BpYoKue3dfOoQKC0zNKnX4Yhc0sBNxQjTjm7eaF7pfQw2647trYIb3hzwJwS8kL/FFggSAo/CM55j8Vwf3O1sBL6bR0kKdWnyFyLA5wcXrlruE635nrZrTPf7Q2JE4Km+Ga7XrGB0iOaDYNKd+b5axeTxWnuDxjzycK2ldvXayneLwzep4uO9mPIw3KyZK0Q+AOTfxa2WbGcpVDBpPr1kGeF1mtsEud5m8PP1G32kkN/cHPC/2ddoz7MTNSIVJDFkwR8hfLS6WYcY1qwtarpxZW2ULT6/ewfyNpgeu5qJ2dPpTpOWIqN5KvdTE17maFPGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e02022-f623-4e9d-d662-08dee9961ea6
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 15:13:30.5011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mk9liFzKoYHpmTaaS/0eBj/Xi2GVKA6Qz+miv0e/RkT1w//B9J8VnxhVrqjzCEW5dKPphxOLZiR8w1q4kZULQKTjH8azUx+KvMpQ7AIw1WaPvtz8AtEZ3ediwTmJ109+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997620
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607240137
X-Proofpoint-GUID: D6xZrhjwb7gEGr0NuqdDoo0RC2Mp8NPH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEzNiBTYWx0ZWRfX6C0gGLibPOht
 5G/DyevTPMHhDgLSlLMjOYdYqj1cY9xyVomTnxdvAMHtZwgXAvB2+rF6OYoksGNiMPwapWfjqBE
 o0uyUdWhyWKjmtX8D/X6KlXwNZViluxkw00VC55k3QmaFSSrlmMp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEzNiBTYWx0ZWRfXwcYJGDJV8YAV
 68qRjdBsiYUF4pdiMK30CwXiSt2RSYBxnxLZCPc/OemCEYvhGLrB2tp/glF5BoffRM/rpUSexUJ
 kNqVlnMu/HdFG/MV5hC6nXaZT4e/v80XX2FDA77iGAxM+qRndbgNeEFry5DkOXH53jf7+hve0Zb
 wB/IWGxVJ4krSa6Uhvwd7u5QSxyK8DdhafNGr/ewG8w0Rqfe0Y9v4S1T81vkwOo4VJBKMtyqGyC
 NOrM4XwHPG5f+xZzn81ZKGjWzWJav/dBZpj+29Wa8wwC+N4PWFlVA5POOOnmtKV3hoEksjnH75t
 oQNxEpqMkcGbR/7k8+mTB+34fIzO0gPc02JZvEsfetIIwsZZOhmPBmgJ5Zi7p2b2bZfF0T4elc9
 dt8CAaQiwde72i9N7lRp+mr+GmEad5NJJqx3x+AjgPKR1XdbUWcvHx6vim3hx2HKa8efQ5K652z
 jkLb+7keorjsedTvIzw==
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a63811f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=KKAkSRfTAAAA:8 a=bC-a23v3AAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8
 a=zd2uoN0lAAAA:8 a=ag1SF4gXAAAA:8 a=Y2qx3jW9RG5hHRTA0q8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22 a=FO4_E8m0qiDe52t0p3_H:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: D6xZrhjwb7gEGr0NuqdDoo0RC2Mp8NPH

Hi Greg/Sasha,

On 21/07/26 8:56 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 
> [ Upstream commit 337b1b566db087347194e4543ddfdfa5645275cc ]
> 
> BAR resize operation is implemented in the pci_resize_resource() and
> pbus_reassign_bridge_resources() functions. pci_resize_resource() can be
> called either from __resource_resize_store() from sysfs or directly by the
> driver for the Endpoint Device.
> 
> The pci_resize_resource() requires that caller has released the device
> resources that share the bridge window with the BAR to be resized as
> otherwise the bridge window is pinned in place and cannot be changed.
> 
> pbus_reassign_bridge_resources() rolls back resources if the resize
> operation fails, but rollback is performed only for the bridge windows.
> Because releasing the device resources are done by the caller of the BAR
> resize interface, these functions performing the BAR resize do not have
> access to the device resources as they were before the resize.
> 
> pbus_reassign_bridge_resources() could try __pci_bridge_assign_resources()
> after rolling back the bridge windows as they were, however, it will not
> guarantee the resource are assigned due to differences in how FW and the
> kernel assign the resources (alignment of the start address and tail).
> 
> To perform rollback robustly, the BAR resize interface has to be altered to
> also release the device resources that share the bridge window with the BAR
> to be resized.
> 
> Also, remove restoring from the entries failed list as saved list should
> now contain both the bridge windows and device resources so the extra
> restore is duplicated work.
> 
> Some drivers (currently only amdgpu) want to prevent releasing some
> resources. Add exclude_bars param to pci_resize_resource() and make amdgpu
> pass its register BAR (BAR 2 or 5), which should never be released during
> resize operation. Normally 64-bit prefetchable resources do not share a
> bridge window with the 32-bit only register BAR, but there are various
> fallbacks in the resource assignment logic which may make the resources
> share the bridge window in rare cases.
> 
> This change (together with the driver side changes) is to counter the
> resource releases that had to be done to prevent resource tree corruption
> in the ("PCI: Release assigned resource before restoring them") change. As
> such, it likely restores functionality in cases where device resources were
> released to avoid resource tree conflicts which appeared to be "working"
> when such conflicts were not correctly detected by the kernel.
> 
> Reported-by: Simon Richter <Simon.Richter@hogyros.de>
> Link: https://lore.kernel.org/linux-pci/f9a8c975-f5d3-4dd2-988e-4371a1433a60@hogyros.de/
> Reported-by: Alex Bennée <alex.bennee@linaro.org>
> Link: https://lore.kernel.org/linux-pci/874irqop6b.fsf@draig.linaro.org/
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> [bhelgaas: squash amdgpu BAR selection from
> https: //lore.kernel.org/r/20251114103053.13778-1-ilpo.jarvinen@linux.intel.com]
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Link: https://patch.msgid.link/20251113162628.5946-7-ilpo.jarvinen@linux.intel.com
> Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c  |    4 -
>   drivers/gpu/drm/i915/gt/intel_region_lmem.c |    2
>   drivers/gpu/drm/xe/xe_vram.c                |    2
>   drivers/pci/pci-sysfs.c                     |   17 ----
>   drivers/pci/pci.h                           |    3
>   drivers/pci/setup-bus.c                     |  101 +++++++++++++++++++---------
>   drivers/pci/setup-res.c                     |   19 +----
>   include/linux/pci.h                         |    4 -
>   8 files changed, 87 insertions(+), 65 deletions(-)
> 
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -1611,7 +1611,9 @@ int amdgpu_device_resize_fb_bar(struct a
>   
>   	pci_release_resource(adev->pdev, 0);
>   
> -	r = pci_resize_resource(adev->pdev, 0, rbar_size);
> +	r = pci_resize_resource(adev->pdev, 0, rbar_size,
> +				(adev->asic_type >= CHIP_BONAIRE) ? 1 << 5
> +								  : 1 << 2);
>   	if (r == -ENOSPC)
>   		DRM_INFO("Not enough PCI address space for a large BAR.");
>   	else if (r && r != -ENOTSUPP)
> --- a/drivers/gpu/drm/i915/gt/intel_region_lmem.c
> +++ b/drivers/gpu/drm/i915/gt/intel_region_lmem.c
> @@ -37,7 +37,7 @@ _resize_bar(struct drm_i915_private *i91
>   
>   	_release_bars(pdev);
>   
> -	ret = pci_resize_resource(pdev, resno, bar_size);
> +	ret = pci_resize_resource(pdev, resno, bar_size, 0);
>   	if (ret) {
>   		drm_info(&i915->drm, "Failed to resize BAR%d to %dM (%pe)\n",
>   			 resno, 1 << bar_size, ERR_PTR(ret));
> --- a/drivers/gpu/drm/xe/xe_vram.c
> +++ b/drivers/gpu/drm/xe/xe_vram.c
> @@ -33,7 +33,7 @@ _resize_bar(struct xe_device *xe, int re
>   	if (pci_resource_len(pdev, resno))
>   		pci_release_resource(pdev, resno);
>   
> -	ret = pci_resize_resource(pdev, resno, bar_size);
> +	ret = pci_resize_resource(pdev, resno, bar_size, 0);
>   	if (ret) {
>   		drm_info(&xe->drm, "Failed to resize BAR%d to %dM (%pe). Consider enabling 'Resizable BAR' support in your BIOS\n",
>   			 resno, 1 << bar_size, ERR_PTR(ret));
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1427,18 +1427,13 @@ static ssize_t __resource_resize_store(s
>   {
>   	struct pci_dev *pdev = to_pci_dev(dev);
>   	struct pci_bus *bus = pdev->bus;
> -	struct resource *b_win, *res;
>   	unsigned long size;
> -	int ret, i;
> +	int ret;
>   	u16 cmd;
>   
>   	if (kstrtoul(buf, 0, &size) < 0)
>   		return -EINVAL;
>   
> -	b_win = pbus_select_window(bus, pci_resource_n(pdev, n));
> -	if (!b_win)
> -		return -EINVAL;
> -
>   	device_lock(dev);
>   	if (dev->driver || pci_num_vf(pdev)) {
>   		ret = -EBUSY;
> @@ -1460,15 +1455,7 @@ static ssize_t __resource_resize_store(s
>   
>   	pci_remove_resource_files(pdev);
>   
> -	pci_dev_for_each_resource(pdev, res, i) {
> -		if (i >= PCI_BRIDGE_RESOURCES)
> -			break;
> -
> -		if (b_win == pbus_select_window(bus, res))
> -			pci_release_resource(pdev, i);
> -	}
> -
> -	ret = pci_resize_resource(pdev, n, size);
> +	ret = pci_resize_resource(pdev, n, size, 0);
>   
>   	pci_assign_unassigned_bus_resources(bus);
>   
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -330,6 +330,9 @@ enum pci_bar_type {
>   struct device *pci_get_host_bridge_device(struct pci_dev *dev);
>   void pci_put_host_bridge_device(struct device *dev);
>   
> +int pci_do_resource_release_and_resize(struct pci_dev *dev, int resno, int size,
> +				       int exclude_bars);
> +
>   int pci_configure_extended_tags(struct pci_dev *dev, void *ign);
>   bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
>   				int rrs_timeout);
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -2297,18 +2297,16 @@ enable_all:
>   }
>   EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
>   
> -int pci_reassign_bridge_resources(struct pci_dev *bridge, unsigned long type)
> +static int pci_reassign_bridge_resources(struct pci_dev *bridge, unsigned long type,
> +					 struct list_head *saved)
>   {
>   	struct pci_dev_resource *dev_res;
>   	struct pci_dev *next;
> -	LIST_HEAD(saved);
>   	LIST_HEAD(added);
>   	LIST_HEAD(failed);
>   	unsigned int i;
>   	int ret;
>   
> -	down_read(&pci_bus_sem);
> -
>   	/* Walk to the root hub, releasing bridge BARs when possible */
>   	next = bridge;
>   	do {
> @@ -2325,9 +2323,9 @@ int pci_reassign_bridge_resources(struct
>   			if (res->child)
>   				continue;
>   
> -			ret = add_to_list(&saved, bridge, res, 0, 0);
> +			ret = add_to_list(saved, bridge, res, 0, 0);
>   			if (ret)
> -				goto cleanup;
> +				return ret;
>   
>   			pci_info(bridge, "%s %pR: releasing\n", res_name, res);
>   
> @@ -2343,67 +2341,108 @@ int pci_reassign_bridge_resources(struct
>   		next = bridge->bus ? bridge->bus->self : NULL;
>   	} while (next);
>   
> -	if (list_empty(&saved)) {
> -		up_read(&pci_bus_sem);
> +	if (list_empty(saved))
>   		return -ENOENT;
> -	}
>   
>   	__pci_bus_size_bridges(bridge->subordinate, &added);
>   	__pci_bridge_assign_resources(bridge, &added, &failed);
>   	BUG_ON(!list_empty(&added));
>   
>   	if (!list_empty(&failed)) {
> -		ret = -ENOSPC;
> -		goto cleanup;
> +		free_list(&failed);
> +		return -ENOSPC;
>   	}
>   
> -	list_for_each_entry(dev_res, &saved, list) {
> +	list_for_each_entry(dev_res, saved, list) {
>   		/* Skip the bridge we just assigned resources for */
>   		if (bridge == dev_res->dev)
>   			continue;
>   
> +		if (!dev_res->dev->subordinate)
> +			continue;
> +
>   		bridge = dev_res->dev;
>   		pci_setup_bridge(bridge->subordinate);
>   	}
>   
> -	free_list(&saved);
> -	up_read(&pci_bus_sem);
>   	return 0;
> +}
>   
> -cleanup:
> -	/* Restore size and flags */
> -	list_for_each_entry(dev_res, &failed, list) {
> -		struct resource *res = dev_res->res;
> +int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size,
> +				       int exclude_bars)
> +{
> +	struct resource *res = pdev->resource + resno;
> +	unsigned long flags = res->flags;
> +	struct pci_dev_resource *dev_res;
> +	struct pci_bus *bus = pdev->bus;
> +	struct resource *r;
> +	LIST_HEAD(saved);
> +	unsigned int i;
> +	int ret = 0;
>   
> -		res->start = dev_res->start;
> -		res->end = dev_res->end;
> -		res->flags = dev_res->flags;
> +	down_read(&pci_bus_sem);
> +
> +	pci_dev_for_each_resource(pdev, r, i) {
> +		if (i >= PCI_BRIDGE_RESOURCES)
> +			break;
> +
> +		if (exclude_bars & BIT(i))
> +			continue;
> +
> +		if (!pci_resource_len(pdev, i) || r->flags != flags)
> +			continue;
> +

^^ observe this:

I ran an AI-assisted backport review and verified one issue with
afc90d2fc3b8 ("PCI: Fix restoring BARs on BAR resize rollback path").

In 6.12.y, pci_do_resource_release_and_resize() releases sibling BARs 
only when their resource flags exactly match the resized BAR:

	if (!pci_resource_len(pdev, i) || r->flags != flags)
		continue;

Upstream 337b1b566db0 instead selects resources by the actual bridge window:

	b_win = pbus_select_window(bus, res);
	...
	if (b_win != pbus_select_window(bus, r))
		continue;

Those are not equivalent. I think this backport is incomplete without 
pbus_select_window() semantics, or an equivalent branch-specific 
adaptation. Upstream gets that via 74afce3dfcba ("PCI: Add bridge window 
selection functions").

Without an equivalent fix, I think this backport should be dropped.

Thoughts ?

Thanks,
Harshit


> +		ret = add_to_list(&saved, pdev, r, 0, 0);
> +		if (ret)
> +			goto restore;
> +		pci_release_resource(pdev, i);
>   	}
> -	free_list(&failed);
>   
> +	res->end = res->start + pci_rebar_size_to_bytes(size) - 1;
> +
> +	if (!bus->self)
> +		goto out;
> +
> +	ret = pci_reassign_bridge_resources(bus->self, res->flags, &saved);
> +	if (ret)
> +		goto restore;
> +
> +out:
> +	up_read(&pci_bus_sem);
> +	free_list(&saved);
> +	return ret;
> +
> +restore:
>   	/* Revert to the old configuration */
>   	list_for_each_entry(dev_res, &saved, list) {
>   		struct resource *res = dev_res->res;
> +		struct pci_dev *dev = dev_res->dev;
>   
> -		bridge = dev_res->dev;
> -		i = res - bridge->resource;
> +		i = res - dev->resource;
>   
>   		if (res->parent) {
>   			release_child_resources(res);
> -			pci_release_resource(bridge, i);
> +			pci_release_resource(dev, i);
>   		}
>   
>   		res->start = dev_res->start;
>   		res->end = dev_res->end;
>   		res->flags = dev_res->flags;
>   
> -		pci_claim_resource(bridge, i);
> -		pci_setup_bridge(bridge->subordinate);
> -	}
> -	up_read(&pci_bus_sem);
> -	free_list(&saved);
> +		if (pci_claim_resource(dev, i))
> +			continue;
>   
> -	return ret;
> +		if (i < PCI_BRIDGE_RESOURCES) {
> +			const char *res_name = pci_resource_name(dev, i);
> +
> +			pci_update_resource(dev, i);
> +			pci_info(dev, "%s %pR: old value restored\n",
> +				 res_name, res);
> +		}
> +		if (dev->subordinate)
> +			pci_setup_bridge(dev->subordinate);
> +	}
> +	goto out;
>   }
>   
>   void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -429,9 +429,9 @@ void pci_release_resource(struct pci_dev
>   }
>   EXPORT_SYMBOL(pci_release_resource);
>   
> -int pci_resize_resource(struct pci_dev *dev, int resno, int size)
> +int pci_resize_resource(struct pci_dev *dev, int resno, int size,
> +			int exclude_bars)
>   {
> -	struct resource *res = dev->resource + resno;
>   	struct pci_host_bridge *host;
>   	int old, ret;
>   	u32 sizes;
> @@ -442,10 +442,6 @@ int pci_resize_resource(struct pci_dev *
>   	if (host->preserve_config)
>   		return -ENOTSUPP;
>   
> -	/* Make sure the resource isn't assigned before resizing it. */
> -	if (!(res->flags & IORESOURCE_UNSET))
> -		return -EBUSY;
> -
>   	pci_read_config_word(dev, PCI_COMMAND, &cmd);
>   	if (cmd & PCI_COMMAND_MEMORY)
>   		return -EBUSY;
> @@ -465,19 +461,14 @@ int pci_resize_resource(struct pci_dev *
>   	if (ret)
>   		return ret;
>   
> -	res->end = res->start + pci_rebar_size_to_bytes(size) - 1;
> +	ret = pci_do_resource_release_and_resize(dev, resno, size, exclude_bars);
> +	if (ret)
> +		goto error_resize;
>   
> -	/* Check if the new config works by trying to assign everything. */
> -	if (dev->bus->self) {
> -		ret = pci_reassign_bridge_resources(dev->bus->self, res->flags);
> -		if (ret)
> -			goto error_resize;
> -	}
>   	return 0;
>   
>   error_resize:
>   	pci_rebar_set_size(dev, resno, old);
> -	res->end = res->start + pci_rebar_size_to_bytes(old) - 1;
>   	return ret;
>   }
>   EXPORT_SYMBOL(pci_resize_resource);
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1418,7 +1418,8 @@ static inline int pci_rebar_bytes_to_siz
>   }
>   
>   u32 pci_rebar_get_possible_sizes(struct pci_dev *pdev, int bar);
> -int __must_check pci_resize_resource(struct pci_dev *dev, int i, int size);
> +int __must_check pci_resize_resource(struct pci_dev *dev, int i, int size,
> +				     int exclude_bars);
>   int pci_select_bars(struct pci_dev *dev, unsigned long flags);
>   bool pci_device_is_present(struct pci_dev *pdev);
>   void pci_ignore_hotplug(struct pci_dev *dev);
> @@ -1488,7 +1489,6 @@ void pci_assign_unassigned_resources(voi
>   void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
>   void pci_assign_unassigned_bus_resources(struct pci_bus *bus);
>   void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus);
> -int pci_reassign_bridge_resources(struct pci_dev *bridge, unsigned long type);
>   int pci_enable_resources(struct pci_dev *, int mask);
>   void pci_assign_irq(struct pci_dev *dev);
>   struct resource *pci_find_resource(struct pci_dev *dev, struct resource *res);
> 
> 
> 

