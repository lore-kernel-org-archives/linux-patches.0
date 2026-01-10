Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFDE2AE78
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768079520; cv=fail; b=ZIZh5LsAM2sExqUQlhJfZvZtJx10udWcbLwJBta1IzfMs6aCfvI/pgyUtZ3x9JYTafCTtP3XrRoIxdXlAMawtLv3UefSv6rKbno2pLOYh3W4k7gl2SjhfvrO9x9LSbukNjVds/kPFE/hCBQoqTGuYG2s3USwLg3BWO6bLLMbwrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768079520; c=relaxed/simple;
	bh=NL7B+dNn0ikpB+AUgyBUhrh70H0I76RDB3XV1glb5MY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sq1t9ca8e+hsOpLCGGrfJ5g9FRIURWD3x9OIlBOLiMAfX4RXJo47PFcfifKFRw1NisQtDs02aQ+tnGwN5d2GYb2V3AqyMotMsjC8ij8qKejoK3hbfL7jF0CZ+hv7n4c2enHwUnHLtC7cKlwOC25gK+c8fstc9N7fIHo4D0oL7uA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sLtWtYPJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ln9b9dph; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sLtWtYPJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ln9b9dph"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60ALAvGg1839483;
	Sat, 10 Jan 2026 21:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KlRh+hnQge5DapgioDMCd+U/uVd4M2away1KJgEZKl8=; b=
	sLtWtYPJtirZWTyL3puhNa6KIcTTQbAAfEJeMCnY9b7EOmUo6bH2AD8dS+oYNSCC
	IqhgPmNxBGVcezXn4t3B516h4//l26ntkxES5TqBw04OH4WVo43OrinRUuNtFDj5
	Y5Dnofrb+Ju0Y+6FdCxO93/tx62AU26EsniLRR6/xzwc20E1Xuo4nU2V10/JKe0W
	vRs425OraoRejhvPNKEqAVI+CezaA+d4t5mxmfsRZzXRNk/07tC14QtrvRY95ztS
	e3uMHgXw7iZc2YngOUddn9wgNSgJddzSx4T5cNwcwYDGEj58thYDHozmAFn3d0TU
	OJ4KOkqF8uIb4Mg5S1jKww==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrgnr55g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 10 Jan 2026 21:11:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60AKHta1032735;
	Sat, 10 Jan 2026 21:11:29 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013041.outbound.protection.outlook.com [40.93.201.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd767neh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 10 Jan 2026 21:11:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IGwF+lFcrXWOmyTamcli1sToRO+fzU+o9q07dpK2MyeFi12ZhkF7S9B5cGN0Mm1pxHiPQQnPvY4HVaXuRkbqwbVEna8j/VvswCQboi5S+0Ecov3qgPTtXzkFPydLrjuRV+efRaSWozKKwWowobXYapZZ5HU6ijICe0PC1ntHNofOeninSMt8nHtbQWEIwUc7ztvyNT8vFZ2J4RevmQZLnr6sZ/DzC23KSwTk2SgwhAfVP9M0LtilNAybjCngxh3i67Bg0DNlkL0Gp3kf5jUAOVn3yR44M/Gi6ZEPCZqfASTPctDv6q19Qh2KO2+33dpBsk3aD1rK82YLN1XBcM6Dbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlRh+hnQge5DapgioDMCd+U/uVd4M2away1KJgEZKl8=;
 b=oxvvpZ/Apfaj1c5hbr3qxNG/vtK1ViNuRR5jWj1zLCgNDNWgeCY2kJ1BcybJeqEsG9O5w+qBctqKqRspaFj3B0ngw6qFw9goUVGON4SlSP1rZphJh6VixWlhnrEKwzv1fLWwPMXrUYv+qpyiwP6RY5KV5RyC0ZFWriW1uCLCMuNFCXk2hCA6xwX1Uh7YjHsOU/xy7ml80nYvdaVw0A+WSv0jaA95VnX+Jz0LwLULm6WOOZ2pB6Gr+Ekn5u18w3jDL5Lars6d957zHIOlYhrNXlbm76cu12GfCbN8rliVRxlHn+u+t+cKwsw4R/gGlDJz7ApdH+WQMIZZfDd12+4ylQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlRh+hnQge5DapgioDMCd+U/uVd4M2away1KJgEZKl8=;
 b=ln9b9dphnE6u+N+f4GMTGd/PshBQ6MFNl+UxNRsIrA8xapt4tm8vBF7yV/I+1jMywGduQEU46b/+Zp2i7CyxlaNzmD2vGgAKPSOe6Ff+oY9m04I05ll7fuhtV1NPv08YxfBn0fRgR7/o5HlNKyM7dDl174jxt4zprB1rzuawMbQ=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA1PR10MB6519.namprd10.prod.outlook.com (2603:10b6:806:2b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Sat, 10 Jan
 2026 21:11:26 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9499.005; Sat, 10 Jan 2026
 21:11:26 +0000
Message-ID: <986f23eb-abe2-4fe2-99fc-76063270a7c1@oracle.com>
Date: Sun, 11 Jan 2026 02:41:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260109111951.415522519@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::22) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA1PR10MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: b9053e43-8f14-44a1-d229-08de508cd0ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHh3VXlqaFlYZnpESnFyVVE3U245S2NoSkg1aGkycENSMkhXcHJQNkNhSEtD?=
 =?utf-8?B?NXdRSGRWdnlDQlNEVVZSSnBiRVZNMGZ0bU9Gd1JQUFhDejBrOVViL1JZd1Zw?=
 =?utf-8?B?N2RUU3Rjby9idGFZbitvZ29tZzM0WENiT0ZuWDhFNTYwWXJJeFRSYUxmbUQ4?=
 =?utf-8?B?Y2sxWFNFQWRia2dvcEpNYVczbVZPU25tbTRxN2pKKzViTllwM2hNV2tjNHVK?=
 =?utf-8?B?SFR3T05WTGorSFFHblptbzhzREFKZmxwOEx0ZGlBd0VqekNTeC8xVDZBblEx?=
 =?utf-8?B?WGYySWxUUmhiYm1Vb1RJTXpxMkc0azFmRFc1RHljNEhhdXNqS3UrWkY3aVNC?=
 =?utf-8?B?YjdPMklMdkt1V3NWd1Q0NXRCa0luWitYMitrRHpQWVZpTVY1UENVME1UZXp1?=
 =?utf-8?B?L1Z3cUtyVXpaWkh4dmtlSWIvMm9zVU5oYllGRWZ3eDMzZmhwS1l4S3F2UC9E?=
 =?utf-8?B?TTQ1QWU5a0hIUkd0eU9UQk9QTzJHdUlnTWZ6Y09LTnV2NWs5bFRFUkZPN1Yy?=
 =?utf-8?B?bnQvMnpxYWg1SlYxcnlwY241U1JjQzJEY2pIYzhWNXZBVXN5V1ByTFlQTkt6?=
 =?utf-8?B?a1ZSc3NjdkdWdG1ZaFNpY1ZlazdQMVdma0k0M21Dc0p0M1NtU2dIMit0d21y?=
 =?utf-8?B?cktHa21JcDY1ZWhYN1V1WWl6VkY0bjAxd2o2Z0hIaTVuempZOElLMlhQT2JB?=
 =?utf-8?B?cjZZUXpEcU0vamhlUnVWM2xIYk5lT3Nxb3hpd21TQnBuLzExaHFBKzlVTnB2?=
 =?utf-8?B?NEUwd1U3ZW5QUDVxNG5qbkZ3OXNidlYrQzhRckxiYlF4SEV5dm9VWkwvNW9z?=
 =?utf-8?B?eW4zcEhZb2JtbERXdngxWnlZTjRDQWNuVTUzNFZ1U2ZUdHYyeHR5b2hRaHAx?=
 =?utf-8?B?NzRsdXkrbVAxeWtpQjV6WDJDeEk0dFZWMm5KK0QzQ05PWGNQNGRiOWkrcERV?=
 =?utf-8?B?OVBhYWVYMCtQMmRnN3FnNEMzZ2JsQTlQbHB2bnFaTXdWYldWREd4MGNIQUdu?=
 =?utf-8?B?U0ppUGhxSGxPVTNpSVkyc0xFeU8yN0x2ZktDeEZKOGI3Z2JLK2RTQ25vUlhB?=
 =?utf-8?B?UU11WjJ6ck0rV0doNkh0RUgycm1aTVNsYzZtZ2dZdlZVNFR6bDRDbXQvWm5Z?=
 =?utf-8?B?clFjSVA0aFM4U2Frd05hZlBEUmJLemVuNG9Jd3Y4RGxwRFAwOU1OT21LbGhl?=
 =?utf-8?B?OVR4ZW9nK2U2UkwyQ1NUOWNWVUZRanIrZjVkSklxbW45bDhwTzk5dFBCazlR?=
 =?utf-8?B?eS9vMjY0YUNKSENPUjdYSWoyRjdlRkVKbE0vdTdISzlCQkdHMlB2MXFhcFI3?=
 =?utf-8?B?MC9PWDdJbkZWdlpNUHM4OThIcUtTNmVZZVgvTGhmakFDRmY2MitINGttcTkr?=
 =?utf-8?B?RUhxTHJ5NVVhWFY1V0NlVjduUjV6Wm15MTFDSGFkRndpeXRwa0pwVFc5b1lP?=
 =?utf-8?B?WHRrYlNiWk9KR2Q3dXJnUnFQNkNCRUQrbzNpby9PNS9PVFJrSTNDTUxNeU9m?=
 =?utf-8?B?TWVZVGp5bUxxVnJCOCt5bERZOUhVTXpoUVU2cXhsSXJrWEg4eFFseFBoUVE0?=
 =?utf-8?B?QXNVd1N3b1QwaWtYWlpnNEJPbHU0SEx0YlBMRTdyR1FMSmgwQTBYU3NrNmNH?=
 =?utf-8?B?dmo0MGFkVlduUkxXQXplYjVleHZiVXdwVmlzYk03TFFINlRaTzc4VXYrdHBs?=
 =?utf-8?B?WHRTTnRzb2xCUmJ4bFJ0OEtnR0txc2ZlYk5mdTNKblJRUm5xS2tKQzE0a0c4?=
 =?utf-8?B?MUlsbXJWNlZQRHNJaVFENkh4ZzFjdXNuSCtaU1RqZUZaM2t6THVaYWJ2aXI0?=
 =?utf-8?B?U1BDK3hRb1dlaFphZHVlYWNtVFE3SWlnK1dXR3A1WExCM1VveDNOTk5JYjE0?=
 =?utf-8?B?ei95Q0taWTFUd0JLWEJwOURJZ0NybG1VWTNuZ0lXYWkzb2lqTDR4WVRuMlI1?=
 =?utf-8?Q?nxuudE/UTkjt3GGx44ca3TH3RZeWniq5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MiszMUs0bGh5dXFqRUFDWm8yN0F0Qldla2ozeXp0UlRvd1BLdE1TNVVpcklY?=
 =?utf-8?B?aTJQM3daVW9JRG5Yai9iV0FqQ2VzanR6azlvY0cwZW84RGs3NjNiZkFoejUy?=
 =?utf-8?B?MitWTnZ5YkMzaWFCanZSV0ZFdWF0M0c5RUJYRnJhQTFNSDJIN2syUEFEQ1Ri?=
 =?utf-8?B?elhmTXk5eDRmcVk1a1J1d1BpRENTSk9uZjRURW9laG1teFd0emE3VXlYNldz?=
 =?utf-8?B?bGVnQ1AyN0c5REI5cEkwYlpnL1JGeTUwUFdjSjJjQ3BQYTZzRE9yMVRtMEZ4?=
 =?utf-8?B?MUoxNUdFWmp3bVZZbkZPQTU1bTdPemUwb1JQUnlkcFBWa2tKY3JSRXNtY2I5?=
 =?utf-8?B?bStjNnB5V1dNaTZjaGF5L3ZEb29hSlhSMys2U3Z5MGk0WW1paUhUYzN2Nlhn?=
 =?utf-8?B?Umw5WTdtVW45RjErcUZVWTF3dGdQSU13NDZ5RXhvV1NsdjhUbmpQSG8rY0lw?=
 =?utf-8?B?WDA5QnVuaHhwSXRzZHBsVXhiQVZWYkxEc2Z3dlAvMnV5R1RmdUhCSFUrTTA0?=
 =?utf-8?B?K0xFQy8zZzJsTXJSMUdHQlFBQkRmaVFrWlpZaXBPdlFQZFVnVExLeFcwOHdz?=
 =?utf-8?B?MFZ4UjlFTHVWRU9MT2ZNT052RGpyT3NmdU1MYS9DdVEwaTNFSjd0MjcwT1Bh?=
 =?utf-8?B?Y21vZVNPRFNHUUtqV0JuNFRyTHpIOWkxTm9COThLREZjbkpQRjFMOWhTT2dL?=
 =?utf-8?B?NXBDTVBGcWllV1FrZXgydW02RjJOdVorOWpUcTNnSUpMYzdNaGtHU3UraEtj?=
 =?utf-8?B?NmI4SERmdEtpeVl3Ry9HL2M2RGYwOThmdXFBelcyTndRdjI0OGVrRE1MTnVv?=
 =?utf-8?B?OGhmVUdybWJRRVdrSUgyYzAvR3VsUjJVYi9nVTkyWG9pbXNFdTJpUVEvOVNF?=
 =?utf-8?B?OGEzUkFaQzY0OWp0TEw0RC9ZZ1BSVDdmSXpoTDgxWmgzQzRzTVFtTVJ3U2dw?=
 =?utf-8?B?R2w4ZlRleTFNUEppc0xSd1c4VnVxRWpuNXZkK0toejFacWxxbGp3M3FvSHlF?=
 =?utf-8?B?Tzh4QWRueVdheHFzK0psZkRWVmFJaXdFTzZtK0doSTRSQkRQM1QyYlVDSkZ4?=
 =?utf-8?B?dDhxYkNJeXBINUUxY0E5NXM2bXZPcmZlRHY3aUFtT3RMTVRMRUZCSCtFbFl2?=
 =?utf-8?B?RTk3MUZwc2Nqenc2Z2dCNVR1UVJBZTFXYWFSTm5aL1UzSDVIZ1dYdHJQQXVh?=
 =?utf-8?B?STRydGc1ZjZWdVFWNnNhOS8vODd3T0pDRnkya3B4c1JFaWxhcWR1ajV0bm4w?=
 =?utf-8?B?TnEvMzJuREp1OUJ2WlljenM1NllwNWtxWUlVVzNueGo2UUVxaVNWMGpFYnYr?=
 =?utf-8?B?VXJTNHBvMytpcmRRTWs4VGNXUzBDWUpjckRZK2QzRDR1Wm9KNDB0N3VRVUpD?=
 =?utf-8?B?aUJqTFlFRTZybndJckdMdWE1dW95UDlUQWlNcVVRZnh4L2dseVVkQnM2VmFK?=
 =?utf-8?B?SndlQTFYQ0tQTUI5Zkp4VitoYVY3dWxBRTliTUF5NFBhcGl5ZWs1U2ZWczZQ?=
 =?utf-8?B?eDE1dm92aU0yRVJjWlNEbjhCUkR3WUVmWWh5dE5TUWY5bk9nYTZwaXJ3OHpE?=
 =?utf-8?B?NzlsRkVtVW9sUlYwcXdzWXVQR3JyanNicndsUUhnWXdNZGNRZmhxZ3RVMi9N?=
 =?utf-8?B?ZDdyZzZnR21Za3h2RGNQYS90Y0JxT3d6dVRyV1ZXVVlZU2NSNU1RZmtSRDl4?=
 =?utf-8?B?QnNub1U3bGorRlFMUk9WQlFneHgwN2RjQ091OTJydWN0QnJQSkJKUmM2WFp5?=
 =?utf-8?B?VVNkREhiaVhUV1pXRDFnVThNdTlvOHFleEJCa2FMOXFlVzhxdFJmN2gxN1kw?=
 =?utf-8?B?OUR3VFdONlI0Ym5PRjVMOXFYc0M0bnpLYU55TW1wTzlGWmd0bjIvakt2Ynlz?=
 =?utf-8?B?QThaZ2pYNFY5eWR6Z3NsQ1Z3U0F1NjRBdGhwbkw0Z1N0dkM0WUxDRWoydGlT?=
 =?utf-8?B?RjBRTTRpbzdQZ3dVTnVkdmkvdXZNZVl4UjNqMXNRUyt2bjlZN0F5NlFQa3gx?=
 =?utf-8?B?cXZMVm1pVzFhSUE2NXBjM3czOWMwRFNOOUxPejZVZTNobmtwUTM0QkVGRVly?=
 =?utf-8?B?eWp1OHpsNzBjK25DSGErUVVuc0ovSU56NEdtQkNWMEM4S2FFdU9KZTBmcGtw?=
 =?utf-8?B?WnVGYldsQllNRW1KQjd3N1JzbklFdkIrdzZyWE9GTUdZUit3UTY1OGcrVVZh?=
 =?utf-8?B?YktyMGdXTGRUVTI0dUQxcEFlWEY5TGV5cjNmQlhBSjJaODg1aGJYbUxwcW04?=
 =?utf-8?B?OVJjREplUlE4bVVxUThaNXpJSWZRc2U1eXJHY2RObU9wQjZXZVR4WjRvclIx?=
 =?utf-8?B?Z0ZaRUdFSjI4LzFoNzRNS3lXYkRZcUQrT3o2WkxCekFqUy9wTFpFYjNjT0ZN?=
 =?utf-8?Q?LO7k+AYQPsATE3SGTBWGUJL6FPHZi5r9YrVYj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pzK5m/Y19VyMC9TpempgY8Xf/ia72dqU3q074XSU/5TCLOazNX1TvgnIu2AHTvkFqJU9V0fJTznT/kgf1mQAAc0ZgSFNObmxLM6Iy8ZamEtauxVJb1T3qChMjN2PKYI8/sIW6698a0yD1C5RFLY5whqVEsQqvzGDDGFDmdbppgDjlsOEeUxZvCfoTCyyH24M6AsjRjO8IaXh3c6wtMCJHbmegaw8CVQpOFoeqtsmFxRBpu6n1aEf4Ekc1s+l4sDoH7OZusDRMXteDAgoJEAuu+rjL+D8EEdIfH6rRvJqEa1SXsW28FRXwDjToWi+xu2vZpCI/c2l9E2CRfgsCZwK12TR2AaEjEn3MB8nT2G11Vx8QVjWj5c/PPwvzdTUyNNtFDYjUUxOTMJe8kWxvTrMAHe5d+S+qn+69aHE8qatSVngdIxdYUhEgXblNixbi4OrS62Yyw+LmvehleOSrxcMsaAb4djyiCYcwyMNOu+VW1EgVIreMofSAPnLmmmFTeTdV98fTkALp84UdsEailboNPEqNqkiCglrkKna12JMnDSrndb5LkiRt1EuTRrsgJHv7G6cKbRfs4rTA1WIvETqm007C2kXjcZ8Qbxg6in8PM8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9053e43-8f14-44a1-d229-08de508cd0ce
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2026 21:11:26.3849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+P4tGe/Vg5fherR9yEQG4FblmhU+iVYERKtuTrAOaBgIJFT5lw0oLIE6U71zdonnqFA32XVwFjM9N4PQAdq68MKx+ptwliyhmklazZ4a9XF2NhZVAmHpT5DogVR8Ssq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-10_06,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601100188
X-Authority-Analysis: v=2.4 cv=B/G0EetM c=1 sm=1 tr=0 ts=6962c082 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=vbnSbIY1u0PNuuxL_eYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5bhpDnpgk1NpYWlqmUvgsOZmIoui3r4w
X-Proofpoint-ORIG-GUID: 5bhpDnpgk1NpYWlqmUvgsOZmIoui3r4w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEwMDE4NyBTYWx0ZWRfX2ShrWV91n52t
 jfGhs1eyjPIQ36HBzPW6OBTJHlmwI/dSsqW8VrbjaTfPzNjaIxo8TIIbXdsa/Xiy4Y+W3jTL5Y6
 By9Ty25zjCcw9x+5YmMeB0p1kB46JFF0tqNOi+n7Dot6bcw8HDOYMrQoo9wL1e4O6H0LCJa//SZ
 KgN9n5jvmxTFrMWV5sogdDZx1lQe/xRv30/OhLS++ISgF3VXWopGqkzl3+owTBtduxF8gVRLboy
 PfRgHRNrfcpr65ckka/KwhkVfnCg2hAnyNjpBfr8FftK/10yDhr+desAeDttyKW5ZTz1dStDO/V
 AcDiL7z2rwJOtYN5reBQyoZ+D9fZz0hh5Q2dFcCYGWLEUDZuZnW/0YfqDvdIHAwBoPrvcs7BlND
 oJkKgsgxIlsH9MIJira8HlKjTtaJNg345qNf7efwj/MbzbHo5N0LuZMFoIcdlNiiXTODY0wLR1z
 3i5eQTHwQISmxWFCSXA==

Hi Greg,

On 09/01/26 17:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
