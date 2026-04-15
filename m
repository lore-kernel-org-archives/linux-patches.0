Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6623793C1
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776251767; cv=fail; b=HP147VlW2AXhf7cbUKEZ48iMnjsjKBK9saaFgv2JzKvgROFgqKjXJojdzd80na2kQr+EA9U38JriO1DJMjYBUbzP2KvzGHwwU4+I5T96+xkZA97jwGM+XRLovRSh5+iLBda1eXLxePXKki1BQ3dYRIiWAsRLDWVeIWpsbUOpuNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776251767; c=relaxed/simple;
	bh=ZGwl3hmGIatZfbLkp76bK6fi2fVj9kIj29rfZ9NL6QU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rBtz+NfvMA6mRFHHlgkzdFPsxtZ1WiUnz8g+yNICTuPNaGDPzFEnhetdXKUArEKfMBTF5XTcm59aSiY0yJM/IlPzCN9+vBFjIpOYUugpuSIzb3ODijiu3A4YTnVny8VCbtWANzVLccT/QAeqFMUKIAjyxQ/qIvpSvNC/D2uVkmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CPrb3p8i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g+CO/UR2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CPrb3p8i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g+CO/UR2"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F9C0j1270823;
	Wed, 15 Apr 2026 11:16:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NcyKGGG4a9oHZz3FxLLrr0j2To0SOrm1d7sUvFsV2sk=; b=
	CPrb3p8irw0Sq3wmWt/3/XG51R1T8awryzuE840ZFKJpsVmoGvEymo7LAzugTLMg
	eyXmYUjJ/dtk5frAveShsQV50+Z+ZInQDJe7gqGHVEw10abfNjucGSfhwt7MbWyg
	ewCF3rkl0M00HnsS7gtXNVnlhhxMYXuwi2fPqyWKuorkzzTQsQJ5MGruS8wHAt56
	2wqYNvom4sRIG+cchPQWQ2NygRlFZZRnIWQVHo4fNNimLE6XPHsZqOdy2FZh9W3z
	J34STEiOYsquOf4or12cnChLQ3vCDwpE3pt9tbRVNdIBN6Eoq/92l7Tvdxd9gQVK
	3rPhqaO0CBHLyqHV4TePCw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87h4tgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 11:16:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63FBEOqa007923;
	Wed, 15 Apr 2026 11:15:59 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012046.outbound.protection.outlook.com [52.101.43.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nmgt7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 11:15:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QStt74/yI2utWAYg+8plx2WNqLPydDjagSoBggH4kK/nDeWgBdWN4ZpkKaGAAKvHTDdwlB7osF+W/kZmTpCH+wD+5A2smlf1UMYDkcaR25fx6oG+w7A7Erc8EcNWchYlA1Pn6UaaQ1YpJr86tE1CeLKkVQ+XsHeJ2XGdPfYL0CH/ivB0zyeYOv3yvFVeQ8DCL8Kniv1FMkBF2ByM8orgrdOoXNlg/ObY0zd/vvzSoaMiJ0nJwfLLI4nymJY04b+OgEQSu5sJE0kEMumyzEBgHz7IkDTC5o2SXBBPEWEvUKP86+FynfF5M0QdjTCCVfAqaBhd70uwp96Ke6YEJQwh1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcyKGGG4a9oHZz3FxLLrr0j2To0SOrm1d7sUvFsV2sk=;
 b=bM3xX5irkRwnfW6k1xWyIbtSHNLJGIe2rRIImMKbvhfTC/AAD3g39QwqYmEkWvu1OWMBUczwJtXTpXC1CDYUQSeRV6EYXZUIbLae4fYAh4vCmln1TPydWQSnfSUUSjYTY7pYC6QS8y9S02Xah7PwWbrWBQFcvb5oe/PBcprYw1ksJHBSBsvw7yfcKj7a75oEOrxJAMkCREHt1K+UWenCFkyVOSsupNhyKnT5Hs8K0BkczV5kt0XIAPLOdfEf9dN8BpJWbBYyX8KTVSHC5KhLpNjkerFimxwz1s+D7vlXGA/6IHCI6Gl9hOj5RHUgk+iq/GCr3fJstyy3s5oo6oInLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcyKGGG4a9oHZz3FxLLrr0j2To0SOrm1d7sUvFsV2sk=;
 b=g+CO/UR2fTVFGxcWrnb/qbwXi983yH1NTD+E9S9wzQ6YK7OW85pswVm/1J0lBR7re6u24+mw7Uzwyssdpb+QRCYRVgEACApybXfxYvd4tytKCT9QKsGeEe36JDgJtzz8fKkiPVwY5Wers6rZdYQrV7t9Lok1uJbw5sFwzZZxZso=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CO1PR10MB4675.namprd10.prod.outlook.com (2603:10b6:303:93::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 11:15:56 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 11:15:55 +0000
Message-ID: <18260c94-4eca-434d-8a54-e556bc2057c9@oracle.com>
Date: Wed, 15 Apr 2026 16:45:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 336/570] netfilter: nf_conntrack_expect: skip
 expectations in other netns via proc
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155843.080326747@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260413155843.080326747@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0574.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::12) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CO1PR10MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b1ce38-e6eb-462c-198d-08de9ae05cc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	l7ukRntqwFa/2kK9iv9EDBY3BWx8aOK/lGigQ/LE0pJuqfbVNo7aN7K/CxR++hGFdczJ5LXvWwNiam4rqFvvYqajfT1jd/juQHycE0BhYnp8Cb3KSprBQZyYKm+b/Vzuye3kLOHr+NLB2LEaqGngl/Z84WHWF7afT/KmlfwvnWE684Nc7RQ1G/PMUqhtUL/B8k14Qz6d6dYPXUOZlsdCPTS9QmV4itPSdHyL0pRRZJqXY33vYJD+S+fKl2Qgc9pPJYC7yo/6j7Wv/jX2I3gSkLxeNz7G78m7MwmyABTnDm9mEsuY/r29tFULhT0Ye/m3/Hc31iJeskdkYNAsXIBk3L1j5LZEluqKdnjxDrjDaebkPMVsKwoXLVsDM+24eUBEi5Qi42CLm2Wgawr8jrKFbf6swWZEIQCaKj8eCe3aUpgdlVzqUk7/FX8xBOEMcz+ktKybG8Kz1SSlqRQeB1t5I67rnsFNaAvAz0V+dUPc5iC9+e7tFoKJYxLbNFERzOEM7qMYZdl0g8X5ZRwCzlXkpeUXgMtrkym1py+SHJFTxzQ2fSs2SGGtaQmLOF2SQjlCaAuCgqck9gMBOyPVMgOf1jpDfRD/ROhAN09zT9lYUT4tSQTGzfRRMCluODfytSvGWnm1BhK/Zm7dIjz4mu+6WMDbNToKefKPhoO1JLkPg8W+MlTUELJK+MxaDIyXqQsUjEwGnmo57U2sFRDytzLyrBEJRQZggo2v3DjkNMgsvO8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFpzakpKYjhZSXhiZjFDNWlyWXR6QUc5OG5XWUxrOVdSc2NWbFVFZjRzNURD?=
 =?utf-8?B?a0JZU2ZEdWFqU1dpQWtOc3pIVzRmLyt0b3VpNEV3Q2V1NHVoZTlTbmg1STRE?=
 =?utf-8?B?Q3NaUHRiYjVxbUpQUXl2RVFUWkJndjFueklxc3QxNW85aW5NZFIrNnlrMVlO?=
 =?utf-8?B?NGM0dGNBNXRwaExXSlhwVFA4RmNXRFRHcUFkTysveFJTcGN5akQ5QnA4M3FI?=
 =?utf-8?B?bWRaS1FBLzlEZFpleDdLb2JzV2diZU1EN2MydlFRTU5NUWp1cGVOdjE4MzJ1?=
 =?utf-8?B?bC84RjFoRTdybm4vYWpidWM4bWlWZnZOY0tEZFpwRXRFY0dTcm96VmtZSWJQ?=
 =?utf-8?B?eEFPWmxUcUFEV3Bjbi9HTmN4aUZtWlFpeTMyM1l5eG5vcnp2S3hZUGEvVXJn?=
 =?utf-8?B?Rkxjb1hzVnNkK3liT2FzQno0ZjM0NjhzamVVTGgzY01UZGtoeVVCV2xYWnlQ?=
 =?utf-8?B?VGd6UjA2QVBMUW1MNVBjdHUxbHlFSjFVMzR2akJ6VWJHMU9LY2Q5NjJnK2cy?=
 =?utf-8?B?MFVGdUFBa05YemtLKzhzdlV6empNVE1Rb2pDcW92NUNFVkRrbEYxZ1NrZXQ1?=
 =?utf-8?B?N0pKU3QwRzd4ZDBsNDNuckk0OVp0K0QzVEZUZ0tKckNhblg5bkhkRGNCMkhO?=
 =?utf-8?B?c3VkcmVxWStVYk85UUl5ZlU2UllQUEJwVGoyQWFiMFJBZFhmOXBrWitKbHlQ?=
 =?utf-8?B?SGZuVkRGd0dqZzd3dUdMUS9RUVV0SEdCVzlPWDRkckk2eDVibWNOekNkTGZV?=
 =?utf-8?B?NDdSMmVjdzJML3V3RWdOUTRJbkQyMzRHV2dBeWpNVGJoejdjbUxnTy96TDZX?=
 =?utf-8?B?UHpaMkwvdzN1NU9uTGd2Wk10OEk1TFVRU1JwN2tNcUdnMWRndUNsWWJ1blpv?=
 =?utf-8?B?alVyeVYrRmZYVWZNQmszaHZTZDhpNUFLdjVVNDAzblBsTy9ZSlpjSFcrUDBE?=
 =?utf-8?B?UU1LbTN1MHVueC9YMko3aXJZUkZLVVl4QUd2U21NMVg0RVA3NUJ5Q3NwOFY4?=
 =?utf-8?B?Tng4NVZkQUJRUUorcXJIS1hNTFU2cmM3MXk5MVQ4N2daUk1WR3FKa2o5TUx5?=
 =?utf-8?B?NVdsTW5GN0o0dXpkSUJsYnN3MVZPbi9sOGZEcy9HTUh6SlJVbXhKMUYrZDRo?=
 =?utf-8?B?NS95MHdLMmlqRnhrVDVjUDFrTmVQQnYrL09BT3grTnNWcUlLREc0M3dXYXBQ?=
 =?utf-8?B?VjgwbEJaMXhRcG1pUXh6TW9tV0IyS21kQ3QzWS9GY2xZZjR5WTlvWGZpaXdK?=
 =?utf-8?B?c1dGVlZZUUxpNnQ5dmZ4bGlESGVTZm0zNXluNDYwWUxqS2pwRE94SkFyQmtC?=
 =?utf-8?B?Z1BpTDlJY2F4NXRUTVNBRW1ONXNtUG5oVnFlc1pYNmsxTk13ZDNjdExEdHl1?=
 =?utf-8?B?ajdYU1VZcFhmYkxNMndNZHgydHVvczEzWi9NN2VCeS9jblJ2RnhJbUNDdkNn?=
 =?utf-8?B?UXpjVHpwODgxcTA5Vzl6OEs1TWR2ZGJEWVVSSXhNMXJuTHBkMlNIOFFSRzF1?=
 =?utf-8?B?R2ZjTDRFNmdzVG1uNkdpbzVnN2VXQmZwVFFCRy9TNFptKzA4NU0zZVllV1Rv?=
 =?utf-8?B?ZUhQOUtyaE9EK2VMOFlKeHdFNWp3WXc5QSs2K251eW1INXdIaVlGSy96akdm?=
 =?utf-8?B?bFBMNFA5YW42bUEydUZSUDJwbUhGcWI2ZjRxVkdqYVIxUUVxdzI3cmRrNUxV?=
 =?utf-8?B?M0JDYkgyejRGNDdxSVNUMU5Fc1R2VnJCb3UvV3VkNGszTjRoNk5rOFJoSEdU?=
 =?utf-8?B?NFFIL1ZpVzV5NG9GL2N4MU1jaDdEYlFlcy9CMjQ0NzlyMlpkNllkaHB2SU1x?=
 =?utf-8?B?Rnd2WVM1Q1lyV2phbEdvMnNrNXZlU2FiQ2xuc0QxbC9UMkIzWFdmQW94R212?=
 =?utf-8?B?dTJMVmJsVUFYY2JlUzh6bkw2RWVZQXl3TUdYblBETHVXaS9JM0RhUm1LcktS?=
 =?utf-8?B?WEVlZ0ZaOEpqME1Xdk80RzRPQ000L3NGZWtEbFRDNGxycURKcjh6WDFVQXR0?=
 =?utf-8?B?Q1Y4eEdKczZLRC9ENTFvaFd5RFYvY3JFbU9qQzVtb0ZRa3gwN2wzaWZDNjYz?=
 =?utf-8?B?VmlSYWd3SytjSGlKYWE2TEJaUy93TUZhK1RBa0FYQlZxOTA3MnR0Zm9UMWli?=
 =?utf-8?B?eXpvb0t0N3RJbnRTWWJxN21kUjZQbXp5ZGFuQnZBY0MxODJmQkpoZnJlRmNV?=
 =?utf-8?B?Y0V2QU94ZE1SRW1ON3czckdtU2xkNktDTkFSc2pYV2FvTEZVZEZ0djBWbHY4?=
 =?utf-8?B?a0ZCMTZBSXg1WmQyeDhTRzNJa0p2dDI0VFJFbDdiU2ZXVHFUaWhOMEZpUkZX?=
 =?utf-8?B?K28vMGNCdGFXWWFWZUhVeTJuOWtsei9xMEFyeXFUdmlNUVI0aHAza0xMMzVy?=
 =?utf-8?Q?X0vQqQE2LSNFYZTQU8USfQyAzVa2LaL5Od2x1?=
X-Exchange-RoutingPolicyChecked:
	cWxoo06bBc1dhHU/7E7FFQsmxdsQ79a2J9XahQKk6G7yq5jHP8jW2HTVCZPUSTk/yvVsMPRihBavcr0BJ0ViEqfhEi53J0D3mjRiSKj72/evFk5HeeyAmXqVrrueOlMUxUSZQO0Q23fnpuiKhBDfUBhjfem2cfW7uqqK82Wj2+/EAbEG+DaYSLdQUJF/SYmH1/IJBAkiXRBlH5H6E5VBab39/DisBbjUWdmHvZWfmBqz7AM+bQHCwBncYyO/DdxVvLvdk9BARwwJgXuxI6gDef/q8zV67sNtozCl/lAYVPDccohpkW3yT/MPUWEfW0BlMujz8Zjig4evYlmWgF99BA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mYU9HBhMt0K4Z2oEcfA3p5FyU5mW8Qpn2R9tLD0s8gdA6bPBoz/x+Dap1CkS6aJvRxeMtLT4WiRbw2w5FcRpgL3K5fO+oMo7lrnCZ1gqX9EkvW+ST2XG0KfQHxgZrSaMTUeSmjVx6asw9YQmWT1Poy01i+jsJclmvdO/JaxSfB9UuG8x6FjtAuZXsCs8g+BDtqe5T3AMbBEoaz0oBxdvilRDYKIGJjsXhmHx7Yt0ZTGHL/jtXrMrJk50d0SGPons11b51DgmZ3nzuKOQZ5MkZnRbwHC2R9ApyFAvW9e8fvdtIe5Hxq+ZP3kjhkEbWSCWTbEJcy6PPPm0O8s70DS1NkDxY6/jEQIbi6JpCkM/z0yyb629bxxND/AXqSZLIe8ySKvc3bdanE6DMlNmRhb8xPbO+05rPj3BNPvidvuFVsfV9M0KRq1DAv4zXQaakM1AUP2nazKPNYH2uaJQU2bJQHtwzd5KXewl7dFZ1EXUdwCDuQjuQ52lQUNlFZjfaKCJP72+d2vLGISQJZhdSbLR2tFi3HCGY8qs9uxY5Tif0Qz1BXfcenYYNaA/Eua6SqimAK86SJLpF6SaDl38oOkaVR/rAkLz4ae6wymdq9YcpVU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b1ce38-e6eb-462c-198d-08de9ae05cc9
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 11:15:55.5173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZtHpBTalm6VHhWgi0KnUF9mf1z1B1X8GjRzyChxTRlFLlUeJPfwHpjQk7jqfKyQUCpXBKOomyNmQiLhpsuzC0RdQJmeNh5sdNrReyW9APjwytPChOxOhY40YcKutsor
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604150104
X-Authority-Analysis: v=2.4 cv=eJUjSnp1 c=1 sm=1 tr=0 ts=69df7370 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=3HDBlxybAAAA:8 a=Idi4wqZkM-yIAAPqshAA:9 a=QEXdDO2ut3YA:10
 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDEwNCBTYWx0ZWRfXyzl0jaUvvDkq
 Vtyqstl9uawmqF520Z7R7x9nlm36PXJwOKX18+fdSFTnaL8bLm0BQ9HDz1HHNFA4bTS8u93J94v
 ohdZpfHzvN+VkP+mq1DY27hz8NJzNkBnA34GGChmzKl/cGBMtxG0D04dE80jZClkdOhtgfVUdOa
 j/AxGq86UmzrkbhBDjcLqQHdlXfk+lxUWEsmPbTwNrSnHiZEZ5p0XucpCeffs/dNxpISv+KT5WT
 zEIxX42pDt2wwOLuh5jbSqn8ZxdzJGUXFhlkB44ZKGap0QmH5L55EsSGXEGT2yEyBwPTjn2hX4P
 4I90uGghTlBiLrVHPdCfNhv2gBzcq8t4QRZxNWRrR+VUmZctoQfe+1HkVWq6vsvezTy2M7YNu0/
 Co5niYjK5MvXAjJZ3OSl0ijI8KIG7KGSqXD0unA/can9mmxEL0HwJ741NYjCIfzR/e2jh9PB9TA
 ghjfeuhMzmFWu292tmQ==
X-Proofpoint-ORIG-GUID: TOQ7GktOa3geA0Q_DnTV-ScK3efKQPxE
X-Proofpoint-GUID: TOQ7GktOa3geA0Q_DnTV-ScK3efKQPxE

Hi,

On 13/04/26 21:27, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit 3db5647984de03d9cae0dcddb509b058351f0ee4 ]
> 
> Skip expectations that do not reside in this netns.
> 
> Similar to e77e6ff502ea ("netfilter: conntrack: do not dump other netns's
> conntrack entries via proc").
> 

AI assisted review spotted a probable issue: I have gone through the 
analysis and the summary is:

I think this fix relies on commit: 02a3231b6d82 ("netfilter: 
nf_conntrack_expect: store netns and zone in expectation")

This references commit explicitly states:
"  This patch is required by the follow up fix not to dump expectations 
that do not belong
   to this netns." which is this patch.


Also part of patch series 4 and 5: 
https://lore.kernel.org/all/20260320125947.305117-5-pablo@netfilter.org/

Given that we haven't taken 02a3231b6d82 ("netfilter: 
nf_conntrack_expect: store netns and zone in expectation") to 5.15.y 
should we drop this ?

Why ? Without it, the 5.15 backport still uses master-conntrack-derived 
context instead of expectation-owned stored netns/zone state

i.e Upstream has:

possible_net_t net;

static inline struct net *nf_ct_exp_net(struct nf_conntrack_expect *exp)
{
       return read_pnet(&exp->net);
}

Downstream has:

static inline struct net *nf_ct_exp_net(struct nf_conntrack_expect *exp)
{
       return nf_ct_net(exp->master);
}


I don't know the internals of this fully, but looks like we might not 
want to take this fix without 02a3231b6d82 ("netfilter: 
nf_conntrack_expect: store netns and zone in expectation")


Thanks,
Harshit






> Fixes: 9b03f38d0487 ("netfilter: netns nf_conntrack: per-netns expectations")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/netfilter/nf_conntrack_expect.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 6d056ebba57c6..10d4dfbdde226 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -627,11 +627,15 @@ static int exp_seq_show(struct seq_file *s, void *v)
>   {
>   	struct nf_conntrack_expect *expect;
>   	struct nf_conntrack_helper *helper;
> +	struct net *net = seq_file_net(s);
>   	struct hlist_node *n = v;
>   	char *delim = "";
>   
>   	expect = hlist_entry(n, struct nf_conntrack_expect, hnode);
>   
> +	if (!net_eq(nf_ct_exp_net(expect), net))
> +		return 0;
> +
>   	if (expect->timeout.function)
>   		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
>   			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);

