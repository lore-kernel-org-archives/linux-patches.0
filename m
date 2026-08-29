Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5F1364052;
	Sat, 29 Aug 2026 21:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788038424; cv=fail; b=MBnLFU7oSx7ojjecwXt+3ePEihm1z1PbLB/vkbl1o16q9inR0k3/WxFFB1o6ZDU+ze+WtevfuyYmSE3nThTvyk40MCUa8z9r/EOOCUcXDXKoTSGVdYrZjuNwECmo71lcIDEfhQOUxWHaPDueT0Bi85EF4K5dWaZEx3zmrbU454k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788038424; c=relaxed/simple;
	bh=9XFVK/Qywzayz8O2Vn+dIosZ+gu93Jfh3LO2mKcgY5I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=scY4t+Xbb7QVngnCjfw0cYSdg3Z8aZTUJADMaMfdQ/GFnaSnsZgD/NlS7uqPCbJOmUjqJHPX4dYQaON793FCnahUJr/ilHK12CuKpcvZqc5K9DqI4knzpKtrx0s1JZHqkXc7L5XVmUVfV46BnRd3gdsGh+45wB/fawU9TFdDvEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QPIjpnAi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IcWzSiaE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QPIjpnAi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IcWzSiaE"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TKP2uY1630987;
	Sat, 29 Aug 2026 21:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=k9PF8D7aEAxQZCLev+O4HwpbOp5ltb6SQjZrm6sPrnU=; b=
	QPIjpnAiaU9kKGdez6l+PiMRkBqwta2J4NGsE0JL7kqHPJgKuwrdjuX9fziaWFQ+
	Cw2Gft0uHObulgFuJsvsLojIGgqmOrcw9XOT2QvbagWJiKtD6h/KQ7hwSaR7hnyZ
	qvXUgkDcWG+AdTYNJeC/VofDGZaBH++2wY1iuCCX7Le0ozYDZyJxHP4HozCIgain
	MDp0TccJZGKxhBgGo9BD5Q0MKawIFcb8vVI8j9nWEMhP3+wVi97gwyPfvFrZVWEX
	6UMIpfsbnZs8/3A8LtRFKk9se+JKN4oZLy83gvDXoelI30clQv/Jl4dcQuI9ULd5
	UKbykrLAKSgECuC6GSQdvw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xrnph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 21:20:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TLKAP7007285;
	Sat, 29 Aug 2026 21:20:12 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvbrdtt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 21:20:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6ipeVQrq3dmko1I3U4V1oKIEYAF+3cetSmIEr4Jm5LMlSO+gk4OGujqfQrS8ogm5pD84CxrLGrwOPhtXmcRS7HUYoPRVaf8/qioZRRT5nGyN+WI6zo7/RjuYKqcV9WdQqxNd7+e50vWxhVxSAdAyXwUkl9ULRN7iETob4DH1iqx5woePYW7ujNxTEGAbQks+QANCS04dfcUY9lTm4+DgQyTUlo3BLOQICoaCReEgCW+c3huVLMPFlEj7qCPEcnHkoKYp+ZwVB7awQzZa2VB+DraFEX43C2C1ESMUfHYodzt+6l3symvDlTT4Bob4ELgEM9G1tktbcrIH0OR7xCgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9PF8D7aEAxQZCLev+O4HwpbOp5ltb6SQjZrm6sPrnU=;
 b=EAec2V7rTpvskNwfp3Eye6t8GzBpg8MJWus0U2O/dh2+qJrjeXwX4fNa07ElJzVF7rl715/AswOK6egvPYNYhw9/HKLY9UHdTpO3zgwkqeRdRnQg0bSTfw0Db8BBXuAlZUa2KEdsP7FbA5UZTO7tbcWIWExBGWsWI/Hv6BRUiqc+BqGIosRdnGmriB01KUOWFTzBRis8Gxmy/bVXWOEZvuhr8r3ye3SaYgf7HiGsJkVQw2h2y9jtVxHm36FjwyWaS2I6XqXpWIc/5lrEQJj1oLtV8xY73N7nLyfhosLVc5XmpV9DPyuW8G2i9f2p7CD+cVAHSjmFkbA9s5OPDvCqQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9PF8D7aEAxQZCLev+O4HwpbOp5ltb6SQjZrm6sPrnU=;
 b=IcWzSiaE5g1bl8ymttCEsjeS4rJco4wfhlRsXAiUYn4ZpeQYNSRTZR6A9vcgHA6M3n2c/vQl0QWqaqqwga/K9TzH4qjocAR3L28VYEEILUYvFpfwRLkkwdI4dlDb8kAZOOdlLhMHAhGEMu4G0ms5HgRSmBHlg+4yK2IrHQrwBwc=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA1PR10MB6447.namprd10.prod.outlook.com (2603:10b6:806:2b0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 21:20:08 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 21:20:07 +0000
Message-ID: <4c29af2c-2a84-4d7a-81da-9b7f97246432@oracle.com>
Date: Sun, 30 Aug 2026 02:50:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 231/456] tipc: fix use-after-free of the discoverer
 in tipc_disc_rcv()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Xiang Mei <xmei5@asu.edu>,
        Weiming Shi <bestswngs@gmail.com>,
        Tung Nguyen <tung.quang.nguyen@est.tech>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Martyniuk
 <alexevgmart@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260817132539.792407575@linuxfoundation.org>
 <20260817132549.157976577@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260817132549.157976577@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0192.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::16) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA1PR10MB6447:EE_
X-MS-Office365-Filtering-Correlation-Id: f450e5db-dbf8-4dbc-875a-08df06134d0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|6133799003|18002099003|22082099003|3023799007|4143699003|5023799004|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	qolbW0fwRdUG/oBn9gBXr1X4llqCmNt9owm6y6HyKfZf+WKcAqoqbSGGcSKO7YDFynj9iSKLueBQjTfeC00zlt1deH7ZL1iwwYUUozn8Pxkp2qdQ++QbV08+LNapRoFfOdLkHhWiTnNDfIm0HHERqu0D5bkk9eGLN7339oeN1erK9fXs023/cL/YDh1cJJFhpFuwbch8yRtnKIHFAbC5A8ZH5wuq8AgC7PuaHI4seCq13S7GAmiqsJ1dN9SZ0yXPn4RgeGt20UqwZaZYmkxib8OIuTb2N7GDeS8g+RDXCDD/qlRu8ElP/A2EaVluqeL6oGo/XB4lOKRJIksQ3T1ZpdGDSKTvBRG/WVNfTZQxIh8K1UGkyc25BU4oTYn/7Zo9ABjFh83PFl102NgmRoxF/hXXy8lD6zM4t9TvigGbxhmQoIcQM7q1YED5LF+XiOuOtK4/ZXoyBYcDO9/i7Cm9cD9NLfYxEx8zTYfJ7/rXVlYkiEhSChBaoZnsDbX60siWzpnWLeFyGJPwv8YuZSCXvxeax1wYHynqD89j4jcodi1WuoxEd+s7AsHr5C1oYErrsBUxRwluH0HKzsZ9hQvJcz3JNgpwWJLU8fW13ZGapxhQwruXp8HWhiroL5lAx7nP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(6133799003)(18002099003)(22082099003)(3023799007)(4143699003)(5023799004)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEtHVU8vb1JJV3FiUDdmYXJuSkI4Zy93aDlsaVhFMlpleGYveExVRnBnVWg1?=
 =?utf-8?B?Q0QxQm8zZkg0SlJlVVF2Y1ZQY0ZuOUV5RzdvdnJiZ0YyQ3YxN1hObkpNZ0hJ?=
 =?utf-8?B?QzVKUW4zRUtuMjNqR2JicU5TOXdOYTNtVUpYNVJQYlBwd3NTU2k2TURjNVhN?=
 =?utf-8?B?YStsdFhCRGtHaDFMYXpuV1BOc282cUh1Ujc3S1JCYXRDTDJVRzNibzV5SWg3?=
 =?utf-8?B?YUhObkhsaUQyT2thV1dzYUcvbks2WkhCNys4M0plV0FmOHNvL3U5QzBmS1ov?=
 =?utf-8?B?cmcwTGRtcmw2VFBJdkR5cVVPdGcwdi9CTFV5Wk56NksrSXo0NlViUzRHVmxw?=
 =?utf-8?B?cXY4aWN1YlBwdFZGSmtqNFFuelR0TjNhWHhmUG9TZFhrMTBpaWJZNnZKeWxX?=
 =?utf-8?B?NjFmVGJoQ2JUNWl4dThwZnY3V21nN1YxNzA1Ty9rRzBzVE5Vem5oclRKN3dV?=
 =?utf-8?B?NEpHTnlVQ1l6WWNhOUVRMXhZQWxndE1yREc0VFBmYmQrL1QwY1p4MEpNb3Zk?=
 =?utf-8?B?RkJLQStkN0QwdVAvU0Jub08rMHFPWHh0QVJDSUtBc3NMU3ZOV0J4eFRLNlRp?=
 =?utf-8?B?ZTFIU0s0UlhwaHpEZHpuaVpFbzVwRWhPYUJqMFZnUTRiU3RGSGFpUzJTa3Bo?=
 =?utf-8?B?TDFLSUxUaVM1Tm9DVHQvOEkvYmtlQXRoazR4N3NMR253emptOGxQYU5xVTlo?=
 =?utf-8?B?K0Z5ZlQxY3NWbDZnSVBuOXl6MGZSTXhJMTg3aG1MVE5QK2pobktDdDhuTVo0?=
 =?utf-8?B?RFFjL2RVSHFpb1pERG1nelBNUGxyRHdodTM0MnAweElSOGRBMmZ3NDNmRnVw?=
 =?utf-8?B?T0gxUzBBcFdrRUlHeDBKcFBiWGIweXY1U2FiQ2ExcDlNU05uS0pYbytuQW9V?=
 =?utf-8?B?eEZpNm1rV1QrKzVPWTNjY1ZKbm1jbjc2cm85Q013UEMvaVk1T2tiM29hdUUx?=
 =?utf-8?B?eXdLeHlSbnBTTzlwMkpUdW9sdnUvZXZVdHJySEFkR2Z1NHFPWW54Ynd6QS9T?=
 =?utf-8?B?TUtKZTFQTzlKQmg4clN2cTdhSWlqVkhIVzVZRWY2YkdITHJNandOcmthMUJa?=
 =?utf-8?B?TWJkRUp5L2g0aTBJNEErR3NSeEg2b0NZZi9EWGhWMVZuN1RSMW4ydGMrR0Jx?=
 =?utf-8?B?bjNDa2dSU3BEWkhDQk45TVRLdEZNeFgzZkVacTFicDRRNVBDYnBMRmhtQ25L?=
 =?utf-8?B?NEc3Rnl4a2pSd3V2SWlLYktHbnZwSGN2a1F1cDVsdXg3eWR1cVkwQWgzZkVT?=
 =?utf-8?B?L1I3ZGdsUGN6N0ZiOVRhSklFZlFidmZSbys0NVpzVzN4cU5xQk9YMDdHblhn?=
 =?utf-8?B?VStyTVZxRzdrWWlsSkFJM0NyWE5lQlFpdkZuOVBDTHdaMTc5N1I1eHVXa25Z?=
 =?utf-8?B?N3pnS3NwVWEwbHhDeHlOeUNwdnRBOEpHOWZnN2dvMkVVU1VUbFNvVGJiYzVJ?=
 =?utf-8?B?U2V6b0dLc1ljclZxMzRhRmxNbHU2NzRMVmRObUdHWXp6RzEzREo5T3FKYnMv?=
 =?utf-8?B?eGJOZHU1QmZ5R2pKdUNOK0tvRTRUamI4dllDQmRBYVZ6eUVtRUhneW0yeGN0?=
 =?utf-8?B?UnZCQ3I1VS9XRE92VUsxMHJVMVhFRXhQRjBEeHpOaUtHSUh3MTFIR2dLbGJW?=
 =?utf-8?B?a3RicmdPdVE4MUhNbmpNV2tZNnVWOWlVZnNUMTFHa3g4TFgvWVhMOE9uR0Zt?=
 =?utf-8?B?QUU5M1F2dVN5dzhueGY2S2VENU9pOWtNNUxUWS9FQ2ZSdS9JWlorTlJSbDFD?=
 =?utf-8?B?L0pLbytBUDkwNHozblhMU281L3FlbzJLWnIzaDhtQ2oweTN4TWZkVkRuYmEy?=
 =?utf-8?B?Zi83dmsxUUl3SjBZQmlpV25rVnhMMGZTN25ldC9ZZVRKRlZQWVp3NFFrSUVJ?=
 =?utf-8?B?VUtjWEVRdGlIV3ppLzIxT1Yrelh6cGlqdEpaakdnREQrT1oydVRyZm9CV2wr?=
 =?utf-8?B?VklCWE1mWkkrRE1BdW1wTE5aZU5sUlE1ZEQ1ZFZrMGc0bmxPVnBlbmJ6ZU9x?=
 =?utf-8?B?N0Zxd1daenhENXlXaHFCaWR2MXdqcGRucVkyRHNMblpVQVZlbXVhdFRFbGxj?=
 =?utf-8?B?S2FkN3VMclY2Z3dWZ3VkTzY0dURDby9oSzcxcE5UWi9OWk1jc3E0THVtUisx?=
 =?utf-8?B?OWRqcVZFTEZJSEdLdnFUbVhBRmxOWE00MzVPSjlLRlhBR3A0dldBNnRrdU9t?=
 =?utf-8?B?Z3REQUVZc1RnOCt4SVRIc3Yvb3M3YkFZaEFnVjZHZExqUGxiUUpwTDhESDhx?=
 =?utf-8?B?VkkwSzJxMThGYkR0Q2FFYWNqVUNsVWVnVGN0OHR4a2V1T3Y3VCtiYWRnSmE4?=
 =?utf-8?B?Qks5d3ZNWTlFNFZFZGZpOHpPZ0xnN3p3QVNzR2xaRUt6Qm5LZ0lTSmpzR1Zk?=
 =?utf-8?Q?3dbLtK7npi4GNJGqKmD4T75rMXd/YnKUDnmMP?=
X-Exchange-RoutingPolicyChecked:
	em6Q7qK+ueBKKExiG9kkSGQzMdKdT0VkmAlozwTz7KmGzqyvjDwp3ovN0Nc/jh51xAMRHV0oF9ISjz3U2cGQXQ3csH0LyO4IOrqQTxV439QGjhhNYxRPesG7ocVVz7fTI3DVcEEYPiC2vxCIzxma7Xioryk4hOAfFdXJwjSN8u4orV6aRLeRYjnP84G5Ut1UiwzLYTt9ep1lO85tZZCy0+KQXWSx3xN0n2xHHvcdYkwhiNyAmRfie0I69MwAB5u8N4KH2reyvzc+B22HNF5a8gbrDcuSmrLiT+yk7LkhfFpsVwxHUk2HLPODy4ZfdNOudTuI12p5tmkGRGarcV63Mg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5X7x3FkjBQ2AF9WcVezCtwRT9rB7/rIPrnjB5vuVdn8wF+IxJHCUFh8UMytW4dcI3qlP64TJ97B0WPvztlkJQSJC1THax13md1l9Aa+6s3Gs1sL34qSEm3zpqL0McTsUqmFPzyoG3PHXPKWWX9Tw70c0rsIl3lzzISDasjEevNXdOAofV9gNLeTPDNk3yXPCC0ePyPgDXSWEAL+MnN4WG44nDari0iHlwDSelJXVGgxNyBL5MTdjrRji/ZUA8ckCIrG5ysSrASDT45f6BM4WEzI9aaWLtpcccaKEBii2plnv/sJ3zVLxfLoOolUczIY0rumy43kfCY4/vbmx6I+dH+SzFhnZXAKQMnZlmDwszUEv7HtAOEz7zx8ucdzEZtl+cSqCK7jZZ3JsrA+Q33njFMIoEZUxls3rnUHoQd0F5WOl/qsdias79gkt3faDryLABO6OSSht5kCu8LOrWcHUIoQxOYtSdpC0J/K5a6KoA6xLCI0Shh9wNGKao6PVrBO9If/idHAXEFrQ/fdssgdxVCSQdn/UQLRimHKKKlUEXhn1erVgpQ5IL7/+NBUeMLxqkHW9KHtw+XLtHzTdPi4i1v6qgeUsXzh4gQ0Q+Ot89v4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f450e5db-dbf8-4dbc-875a-08df06134d0d
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 21:20:07.7465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o3Uz9t4DICgJmTOFacZ6Sa5srltL0zRSkVtWv4EA4Ee0KJpFkim6zZfND3nEu/X6GLR81QmUCN//N8zcnDeSEbPuOvKOCxHeZGYSO5RMes+okv/MsmwP21gyJgcszhRM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6447
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290185
X-Proofpoint-ORIG-GUID: 24yVHJjZcEv8D3OldaVb1XlkZ2oemTEt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE4NSBTYWx0ZWRfX9oiESYE5jl6B
 92FdcCLnrEOOWduALl6tM4heZ6riwU4XPUKyLN3r8qVEDaZUOytEhkfikH/Oy8BODng9pAaRJBM
 HToJx0EnI4wziyHsUlxDZ3KpS+0XzZPY0O8Ynczg3Xz5cC46zykZ/HymNPYU6hFnHO8pW0A/NVC
 kunB5KzRT2mUWRTO1pYsMOph2i036zDxh1rS2JYcTegDMSojs6VclThtkDaAaESQZ7Oyx+A7xev
 OlNtguIXb7E9lPgujfB491OoPNncaV645hs1jJpldplWVEPh+9TZOJzcC0zsSGDeCs5BmeiU1kY
 EmnKBaLBC0+JfTPp7o5D002x8JMRrYDa14SC/SmSWY49ZQvQq5YNAc29NnP7Jzu17HOX8ObdPnT
 4DGzUctNNmSPezw4AJNdfvUgwLzdCI7C+b3pQ9Y0NgQc8oV7PUFOwWI+g9x6z3jZ/6M1ZAI0W+i
 EGWulyju5HUuBHH7avg==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a934d0d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=bC-a23v3AAAA:8
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=8u-ZMrWmr02PLxF4UAIA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: 24yVHJjZcEv8D3OldaVb1XlkZ2oemTEt
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE4NSBTYWx0ZWRfX6742+1ppmmt+
 aMIk3KGfunAFe8QaY+KsHMSOcmCxtjuTzkdYpRqBDi41YWcwx/6xcdSR/huqAb0IumsyszLmA8x
 29DwigQKpB4k0g2VvPaDqNQYytMIpYIu0KkkQBsTdNR2JsqDPlBu

Hi Greg/Sasha,

On 17/08/26 7:00 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Weiming Shi <bestswngs@gmail.com>
> 
> commit 1579342d71133da7f00daa02c75cebec7372097b upstream.
> 
> bearer_disable() frees b->disc with tipc_disc_delete()'s plain kfree(),
> but tipc_disc_rcv() still dereferences b->disc in RX softirq under
> rcu_read_lock() (tipc_udp_recv -> tipc_rcv -> tipc_disc_rcv).
> 
> L2 bearers are safe thanks to the synchronize_net() in
> tipc_disable_l2_media(), but the UDP bearer defers that call to the
> cleanup_bearer() workqueue, so the discoverer is freed with no grace
> period:
> 
>   BUG: KASAN: slab-use-after-free in tipc_disc_rcv (net/tipc/discover.c:149)
>   Read of size 8 at addr ffff88802348b728 by task poc_tipc/184
>   <IRQ>
>    tipc_disc_rcv (net/tipc/discover.c:149)
>    tipc_rcv (net/tipc/node.c:2126)
>    tipc_udp_recv (net/tipc/udp_media.c:391)
>    udp_rcv (net/ipv4/udp.c:2643)
>    ip_local_deliver_finish (net/ipv4/ip_input.c:241)
>   </IRQ>
>   Freed by task 181:
>    kfree (mm/slub.c:6565)
>    bearer_disable (net/tipc/bearer.c:418)
>    tipc_nl_bearer_disable (net/tipc/bearer.c:1001)
> 
> The bearer is freed with kfree_rcu(); free the discoverer the same way.
> Add an rcu_head to struct tipc_discoverer and free it and its skb from an
> RCU callback.
> 
> Because the RCU callback (tipc_disc_free_rcu) lives in module text, a
> call_rcu() that is still pending when the tipc module is unloaded would
> invoke a freed function. Add an rcu_barrier() to tipc_exit() after the
> bearer subsystem has been torn down, so all pending discoverer callbacks
> have run before the module text goes away.
> 
> Reachable from an unprivileged user namespace: the TIPCv2 genl family is
> netnsok and its bearer commands have no GENL_ADMIN_PERM. Needs CONFIG_TIPC
> and CONFIG_TIPC_MEDIA_UDP.
> 
> Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash values")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
> Link: https://patch.msgid.link/20260617135744.3383175-3-bestswngs@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/tipc/core.c     |  5 +++++
>   net/tipc/discover.c | 14 ++++++++++++--
>   2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/net/tipc/core.c b/net/tipc/core.c
> index 434e70eabe0812..1ddecea1df6e91 100644
> --- a/net/tipc/core.c
> +++ b/net/tipc/core.c
> @@ -218,6 +218,11 @@ static void __exit tipc_exit(void)
>   	unregister_pernet_device(&tipc_net_ops);
>   	tipc_unregister_sysctl();
>   
> +	/* TODO: Wait for all timers that called call_rcu() to finish before
> +	 * calling rcu_barrier().
> +	 */
> +	rcu_barrier();
> +
>   	pr_info("Deactivated\n");
>   }
>   
> diff --git a/net/tipc/discover.c b/net/tipc/discover.c
> index e8dcdf267c0c3f..835ff27f8ea88c 100644
> --- a/net/tipc/discover.c
> +++ b/net/tipc/discover.c
> @@ -58,6 +58,7 @@
>    * @skb: request message to be (repeatedly) sent
>    * @timer: timer governing period between requests
>    * @timer_intv: current interval between requests (in ms)
> + * @rcu: RCU head for deferred freeing
>    */
>   struct tipc_discoverer {
>   	u32 bearer_id;
> @@ -69,6 +70,7 @@ struct tipc_discoverer {
>   	struct sk_buff *skb;
>   	struct timer_list timer;
>   	unsigned long timer_intv;
> +	struct rcu_head rcu;
>   };
>   
>   /**
> @@ -382,6 +384,15 @@ int tipc_disc_create(struct net *net, struct tipc_bearer *b,
>   	return 0;
>   }
>   
> +static void tipc_disc_free_rcu(struct rcu_head *rp)
> +{
> +	struct tipc_discoverer *d = container_of(rp, struct tipc_discoverer,
> +						 rcu);
> +
> +	kfree_skb(d->skb);
> +	kfree(d);
> +}
> +
>   /**
>    * tipc_disc_delete - destroy object sending periodic link setup requests
>    * @d: ptr to link dest structure
> @@ -389,8 +400,7 @@ int tipc_disc_create(struct net *net, struct tipc_bearer *b,
>   void tipc_disc_delete(struct tipc_discoverer *d)
>   {
>   	del_timer_sync(&d->timer);
> -	kfree_skb(d->skb);
> -	kfree(d);
> +	call_rcu(&d->rcu, tipc_disc_free_rcu);


^^^
I ran an AI-assisted backport review of f05b3f4c7837 and checked the
finding against 5.15.y. The RCU conversion is present, but the timer
lifetime part of the upstream context is missing.

Upstream commit 1579342d7113 is based on the TIPC conversion in
292a089d78d3e2f7944e60bb897c977785a321e3 and has:

         timer_shutdown_sync(&d->timer);
         call_rcu(&d->rcu, tipc_disc_free_rcu);

The 5.15 backport instead has:

         del_timer_sync(&d->timer);
         call_rcu(&d->rcu, tipc_disc_free_rcu);

tipc_disc_timeout() and tipc_disc_remove_dest() can call mod_timer().
Unlike timer_shutdown_sync(), del_timer_sync() does not reject a rearm
after it returns. A concurrent rearm can therefore leave the timer
queued while the RCU callback frees the enclosing discoverer, allowing
a later timer callback to dereference freed memory.

The timer_shutdown_sync() API is already available in this 5.15 tree. 
Maybe we should fix with a downstream patch only ?

thanks,
harshit

>   }
>   
>   /**

