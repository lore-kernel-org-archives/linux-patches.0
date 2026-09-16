Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE604499B0
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544779; cv=fail; b=nx7vuy169/BqGK2KABN1aTiw6iONFiMiF5knfc8d3b/d2udThOKDSW0J1svC6oGnGBK3BccZfr37CSFnsibpRv21GNk37jRdorKQncGn7QRQc+0vOzT6eR1Tv6qJUawQMsn3IXeVYA95P3bk86+s15OK9zWjLdPxkhsqRtVSAZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544779; c=relaxed/simple;
	bh=oSXR0sfadPqZXEZzHh7PproPSSFrqH9SvqCAlthsW8A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h2yMmtpdK6CejswbPH1ItlT8riSU0w8zewrABhIHHtagexZKhJVKJUakCAGBzE68sBhxbFKzCag7o3iqJu9x4YraAbeYM9LKbVZR9PgoFRRHgEA6Cu1aybZxi2CzE8i27UMZW+CLyvpBRNP3hnUMwrjyWyg6BUgP7oa+RC+HYdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YrLELI6E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s6FCF1Fx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YrLELI6E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s6FCF1Fx"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLXsxg1308091;
	Wed, 16 Sep 2026 07:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7idh8V3NBxnChO0YoSlx4cxp0J62S918njnMpeFFeL4=; b=
	YrLELI6EXVTgATzpWPkGonk55gTAOeoDoFDLU0TkGs9Svb6tyw/6DJLoEYsVgRQj
	ru47RoGECZ+9gkxldQGFq0YrJOSvYmoZ/JH0MnaXJqOkLsDhliG0KWCMNLjiqK9T
	Nfc+sPnQkBhjONX67RPHnsuxNKb5c2BB8kyaPpltf2qjU1goT++aAK3HzBwx7JyG
	gdclBFfHAEX/srfj1xKa5Tdp1EG3Y3NiddP4/K1i27PGEl5Ffyfc914l0LD5czK+
	2Ba8Lp4iXPLv9fxyO8H3TBKk6nYpyEH5FFqFpcCtCEcino4IK7TvfOUnvo3wF66g
	3ud2rg5xc0PTvG5866fKRg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn95568-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:46:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7ip0L011683;
	Wed, 16 Sep 2026 07:46:07 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6d1vr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:46:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9OvxW0FJVqKAoxdQAqEKL0lMREK7oNKITyLndADJth5lkg3uh77gE0hMAVH7Ot8hu/WEG4Zgq49WKpmsvEUSnqoDYDo4aKcEVjMWZjtUBIopZxuqz6+Zr4s9J9m+SPCj7mwThBzX4YeneNplZAywv8VFBV5yFJUBd4VOv+orilxiCKfn7Or9x/QAviuV86n1ct2fPC8kYT/6BLeLLQVnG5wQ1rdF0rz7pXSQpSBNpXvMdtCmoW1hYBJFC+shmxV3GAnJRnXPxMN7UzAxWsrYVBEjd/5wJiEIAssxFdl1LUx26RKx9mN2mVf4hl9Em5TjEIC3Fed6su44uBJ5Tz9Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7idh8V3NBxnChO0YoSlx4cxp0J62S918njnMpeFFeL4=;
 b=rh6xn3l4iTJJP7YGgHzsrEcYemEM9Cr43arr/kq7kkCVxzGetCfHKV43xIQs9lHd4MT+RF0LZ8UebRV/AVCuy+0t4E04Jkx9OZyyqmk/d2NdHod7z1JV0TlSYdFP5A/vonCTE5/BXD91puKYiYyspUf4Aeqf5zwlnEILDAul+sFQCF9MGmV1lCWFTZRPu5nx9D+eOuBIWJZt8OdbOhzVJ/FHryGL/yfmWDGfcGHS+MOTM0aidDaPK7R9GeoUfWht4nMSce26+vzPy97TebFBl8PD0mynV2zLM5u+ymen0u4eOIkMJUlOMepi5WsQH29KfQagiA0ETtlTb7cTpmLb4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7idh8V3NBxnChO0YoSlx4cxp0J62S918njnMpeFFeL4=;
 b=s6FCF1FxtEJ8dBqzBpbGlN09OJW7f2anQUryIZxNraDztLXwz8NTqYEBiQMUUMWkZ8eUJCkL9WXRUiN+4tO0GdZwv/uifvrCedPD66Y8vfTVOJGXSFIV7c80Bwq4CHzJ/D0B4yYdBzPFFNV4y7lyyLLbYpLZ+SRhvceSFJVvmJM=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA1PR10MB6148.namprd10.prod.outlook.com (2603:10b6:208:3a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 07:46:04 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:46:04 +0000
Message-ID: <cc43fb43-b6cd-4d60-b077-5fdf7918cf8a@oracle.com>
Date: Wed, 16 Sep 2026 13:15:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0766/1376] arm64: dts: qcom: sc8180x: Fix the PCIe
 iommu-map entries
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065624.612877788@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065624.612877788@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0223.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA1PR10MB6148:EE_
X-MS-Office365-Filtering-Correlation-Id: d230243f-b665-4be1-8490-08df13c68f62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|4143699003|6133799003|3023799007|18002099003|22082099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	NrFO0B9Wc6AlzUeljQ8dPQuAlZMDIBGefR7awWOtdA++8xgBvvkKi80PVmwcX4P3wEXrZWSoEt8N6yE7xiQDb5BlfS2PLGnPpybcpK3nL8ScNS8io4L/QonQeUv/U9h3LicA3DHJ5McxzTPciRe250bauW5qrl4SqoDuPpPydCldD8QrK5Qarmcse4MQSTZefvuosKvWrIzxy72DJ3KgwSDyuBkUJRfDBRcCxZJ6cREwwGspa2UNHG2ITCGJsXzHotI7oGginv9zOtmpLV52lNf96RfVPOhVQs/jNW29t69xWvVpAaLbp0z5O/aHjxczZstgJgMpFyEbMdozjXrg+VHeDL7MU65TtKD0ebWNEytyC8Z1lu5o7PNLQ8ZSNE1lrP7aipe99pb3dvl/0G2jAfg7p235HXh6tt3YSVVtTsQXIs72oPTt5lAomsndDFfAvyZUSzw96sh9X0MBUT61yBpfystQV1Jv8ZelaGL2Oyz0diSV/nSpwJug8L2cVjVGN2Izg3RZ1drr4NUcKhL9ZnlQSN5CH7Cc3n3xHWI7PZsVJmVndmja0qCMyxOinjfezRZY0iDrCvxBQSV/u8cbJfrZFEx45ubs9nGFP6z/qpdjJv7Dw3ArtDF2S533nVS2Nd36gGBEERBmeuKwAIIK6MCT2ImQ6iEjm2fmn1qTv0U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(4143699003)(6133799003)(3023799007)(18002099003)(22082099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFpmdVhrSVQzbXR3SDlSd3ZOaEMxd3A0MFNIdkdJUnZhR0ZzMThyQzM1ZFR6?=
 =?utf-8?B?K3BEbGJ2TFp3QlltdUJheTMxNi9zdEFKdTBzKzRxYXZYTlV3YXpEVFMzTUMv?=
 =?utf-8?B?YzRwY1ZIdjUzRVFLOUhDU3lOcGtHY05RSHVaMlNxSUtVQlZVYTQ0bWNGV3VV?=
 =?utf-8?B?cTUxa3ozTkdCYmhFOVNSYkxoelR6clh5WlJ1cHBuNFJHTlNRWjhrK1pZSk5s?=
 =?utf-8?B?cllrb2xtTWxUTWZwUWloN3AwUGFCMlAxU2RBYjdsZUxFdHZYRXNMSjhCbkJJ?=
 =?utf-8?B?QnZQWWo0YW90ekhNdU1kVWZ2SDNHaXRlMlZjQUtteG1NSXgwc1VKQVJ6bjN4?=
 =?utf-8?B?ekh2cnhvRjVJVkM4T1VnTVdhY01Yc1VlbjNNZzJhM0N0OU8ySFJkNDRZMWtM?=
 =?utf-8?B?ZmNQaTN2UkRvSnp5VFNqd280c3pHbTg3VlhUemxyMk1aZW9RY1k0OVQ3SXZH?=
 =?utf-8?B?WEwwRjZFY05scnFHNm54eHIvZVNYZ0VVa0pjdWpXY3JldFl6b2hLK1Q3UEQ2?=
 =?utf-8?B?ZzJPR0g3SGNvRnN1dDd0eWRjd0JDS28rYVNMNXhxTTdjZE5oczQxSzNTUC9j?=
 =?utf-8?B?VkJaSkVSNzZXeXFsZ1duMkJyYldLYk1VUUtjdlk4aG5MUHN3a2taa200ZG9v?=
 =?utf-8?B?bHVJZmNKcFRwVUpUTjBzaHZkSWdqNjhRNHFsbUhzR0grY3oxZTA5OEpWaVVY?=
 =?utf-8?B?ek5jYkhlamdOblBvRU1jVmVOSEhOWGVGdlVqUnloajV5V0dLbHFvUVFUVktv?=
 =?utf-8?B?RGs4eDBScndMSSs2S1NxNmdpUmJJbkRuZCtqSE1yMmNVQ0pPNWtVNEE5UVo5?=
 =?utf-8?B?MFZpUUhuMUd6RVBpQ1I3OW1MSnVsTjZ1NjZQRWxmeDRWR3hHNjlyM2ZRdm9F?=
 =?utf-8?B?NEF6ZEl4OEF3UnZCa2xCbnUveFVVWjRoRFh5UjA4TTVDS080YWgrNWdFVGZ2?=
 =?utf-8?B?NWtLeHljUzZvUkUyTmhsalhGWS9aWXhxbzREenBsNDBBMXpuWldwcmg2eDJZ?=
 =?utf-8?B?blIwOUgxamRENGZZNThRMmtWcHdDZVRTdXd3OUwyTXVST1JSc1FIdVByRWwz?=
 =?utf-8?B?T3kvUXU1bFB2ZmtKYy9GbVpnc3BoSHlwb3RqUU5pQXdWcktPTmYvcHVLakxC?=
 =?utf-8?B?Q1l5cFpHRmFVL2I0OFBTRGdISlpZay9tLzAvYmhEa2ZUNDVrelZlRnRTQzNY?=
 =?utf-8?B?OGxoMERUdEhscXIzcHl1ZjN0NjZ1OWNjZzFzdkd4c2hGUnRiNzVTbXdTNDZT?=
 =?utf-8?B?RmVNQzRDYkw5RDMyMTZQVEhFZGdjNnFJTzlJVHNJSTBVa2lUNGNZZW94Wmlu?=
 =?utf-8?B?NHVPdUpubGRmR1dRZVpUaGRTa3p0ZXpCa3NjTWFLMGhlMlVpcURLQ0IyazRO?=
 =?utf-8?B?eXF6ZkwyYnpOaUNNbzFKRDl4amNyS2hWUXorb0c5YS8vZERpVWFWV1R6dkZm?=
 =?utf-8?B?cnVUTEFQK1RjMGx4Qk1teXRlREc0NjhWZzZ1SS9YRHc2cExMQWZhZXJzZG1j?=
 =?utf-8?B?NjZPRDEzMjMrSHNTV1dBR3pjR2NPK01KWmlJa203NGYvaS9XMHoxMjU2cUx2?=
 =?utf-8?B?N1pQOTduaGRJUUtydEZvYUZPRnBYNlR5ckd6Z2xaK1c0UHJBVVBvTlBBcits?=
 =?utf-8?B?Vkg3cWJmcDdvQWp5THVEUEkvZzhRdzVUNSt2U29hMFp3V2NMUTNRdlo2SExo?=
 =?utf-8?B?ZDVCbGVldUFzUmEwa1ZSbzB4dHhpY3o0TUdRVnBLcllaNXNiOFRkNmJuWER5?=
 =?utf-8?B?Q09mWFAwZUM4MnNSVkRlTGtobDhPT1BERllkbTZBdXEzU254OGRGLzJITnJk?=
 =?utf-8?B?WFZIZWlNWFJZMDZGZEJtSnNYemlwSWRQVkd6anFjTi94d3RWUUg1RkFJVWla?=
 =?utf-8?B?UzdEd3hDeGkySVlZRDlKRTJmWFVRVzk3a1BHZkZzZFE5aDV1RzRyVzIvWFNl?=
 =?utf-8?B?V1pxZVNNZlRZMkRhTGhNOFJyOVpGYitBNm8vN2VTSm9kUHUySUlVaVBMZ2h4?=
 =?utf-8?B?c2IweDBsVCttQXZlSkpiM0ViZW0zRG9TV2pTdzJuWk9FVTdpSTh2dS9xK1J3?=
 =?utf-8?B?UlBKVDBqUWtmNzJxVTg1WUhabmk1VnVVQXdNK2U2elBkRVN3R0ZZQ2NoS1c3?=
 =?utf-8?B?bUk0blRRSzJ6WDM5Uk01WG5DTlFKSDgwem1yTjVTU3Zpbzg5RTVZMVJQM01o?=
 =?utf-8?B?MVNSdVFlNVlXUTFMUXhDTUxsL3NjOHZzSHFpRW8vbHlib3o4Vm1vVXdjT3V6?=
 =?utf-8?B?Ui8rL2MxMUhWRkdDUkF0azlVYTlBVlgzdGU1akpBQ29mVTQzZmxSU3FBc3A2?=
 =?utf-8?B?Y1h4T2g2YnVwTWpqa0o2YTFnRld1djJGcTZZd2NBY3F5djVYYXQ2KzN0UTJU?=
 =?utf-8?Q?YmPtJQfeKJWJ9hb9zwwZvIfjqB+efdFCHHx7I?=
X-Exchange-RoutingPolicyChecked:
	NLetLH7a0b2X2FIBSHfdajLAUfFy7l3iCCZWMBrDUkkZxN210mcgPCJoDNlyn1r/MWxMZ3HR+8OQQJqFRe+kQyQGImilnXnNvRfbw6r1pPqnBvrlOUQyL+eQGjB3ZYzsWhGdamcd5qWkEyH6P+3oZ4UP3fij8ZNKBQvLW29rOiatnWmVWFUBlGWL2Nt67n31+GW0IR+5rgkg6l2LTZVYVEz+6UNFogBmr7oAkDMUuMbbiifT00L6uZ/UDoF67KmYddYOxPELkzaNwAwOK6w8CEJPHd2c0+ukZfy01UVFGac670gDBlX1NLyFu2LY6QTNr0rDglJGUJ1fVgMxsReF1Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KXD4Rx4/3hOcjzISim1VjYalZNlV5rYyLBXZbI7OkqJUMgXA33w35vuoHZKKW1Bh1IRSv02DUGQinwecbwyK45Fi1t1YHQ45rZGjF3XVOeawn6Ta44epBh/Xl7Pbx6KtXeinN4JFBLy2v901OHAp12fMbzBndfYl0VQEcEsx2yVViD8NcXDPd+WwWXfVLzLv0X1qLFhd4ClsXV1PLksCRTehUPtaL0mFdohpXR9hP9P15CVEK0szx9vJ6z4EvVkG3lAh7JRoC9ANB03AewsDWwu/fzC6faxcq8dcU0Atq4ncrKdRC5aa9HQbm1PZeyaM3XoGJaGb68E15/D0FGALteZyXj4IVny9sqh2aOZwK6+t9vWyZ3l5m+gJLbucmMUcW9L4VacapPbAQZEB244n/84c9tF1X4WHpkwO7Wm92PeFeYczNSBTXMkF+m8aG8R3DY/ZsIT4OowdUwY81eCspqcc/rfNWZE3LQysKMbnBMnJBq0MQBz7kr21/4RPhQ+5XgTSMayM1LLz4p56KiJjlBkUCwC9yPrJGyt9a/Y4EkmQBZInv1RCQ2uOgZWi/gkJ07WnrWWq6+uwdkDUuFm8FtUTe6J2X52gzPN5XE0v4MU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d230243f-b665-4be1-8490-08df13c68f62
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:46:04.1290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOMcgq9jIQlMSSAWabdLjqSnAKvo4hecrKXPknT8L4WGpFzCSAYEu+LkYhK2pjdVaxScAr3VEtjxEudT9XMoJuHTAEZJZ2EX5CfJ16n33Muz9MnkOWp4VRqJbrxdKEV+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160100
X-Proofpoint-GUID: EVPR2lLkC_laBujPMdm4rP5yF1B1ar8H
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA5OSBTYWx0ZWRfX9HzCwGIwxODH
 OCmH01GEKJWu8/aevTsrNQVG2jRglYRigHyK0IAXai1afGnxndA8VS2eIAKZdoqCNYCKMLW4DS5
 ISUQ068f4oPGWAdYS1Yta1tYN7MarIBzj4UtZqAcsz0Pk2KdOhAM
X-Proofpoint-ORIG-GUID: EVPR2lLkC_laBujPMdm4rP5yF1B1ar8H
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaa493f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=qAMQX31tJun4B5yFMF0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA5OSBTYWx0ZWRfX5SsWI6+wLki1
 OeUGJz6yh/58H6cbMcMn5/HPwPBp6IsWpFlIX212sOeUWr8bFSnfjDSw+6BuwC6HIsJ+91nuAl1
 MEphSYnbhd9ol2errGD8MHQdKDOZ5o4SA03bXxK1E/Ut18y3Cm1DfGtcu3Hy/ouBkKJNe/Hz4eA
 sdS7OtIzVqHGmK/4eJ3X8waEiyZnLm6+5R1HaUDlKMiNbpgsM/prgDh3j+FP7gPmB7GdTBfl+dM
 GEDxQzWpzOeY3VMpAOXJD/rGqTzf9Vf+0rbhCWiagIYtI4hGU/blLP3o/Q51XPdRfUgZ+3eVssi
 9dZR5wDKQijy/d5PCrEhqsQgjUORprwfljFwYLzqY4yby0NYKVlLQTmMZ6UcApn9vjJ9cDGmDtO
 QpQKIObbhbSinJOANWDgq8pkkh93uj6rtB6umgq/vvAIM2luXfGvexEacV9zDlJ4xrg8BZ5kzD6
 Dt/la1Gp0Ib7xVpSxvA==



On 12/09/26 12:23 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> [ Upstream commit a4548204821a56c23cd711cfad2a637ca055ff47 ]
> 
> The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
> iommu-map entries specify only one cell for the SID, omitting the SID
> mask. This went unnoticed until the OF core started warning with commit
> ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):
> 
>    iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output
> 
> So fix the entries to match the provider's '#iommu-cells' property.
> 
> Fixes: d20b6c84f56a ("arm64: dts: qcom: sc8180x: Add PCIe instances")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-4-83405d37ba41@oss.qualcomm.com
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>


Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The corrected SC8180x properties contain two five-cell iommu-map
entries, but 6.12's of_map_id() accepts only fixed four-cell entries.
Each 40-byte property fails the 16-byte divisibility check and returns
EINVAL before any requester-ID mapping. The PCI setup path can continue
without the intended IOMMU configuration.

Upstream has the variable-cell parser and its API preparation series,
including ccb2fd725d411265df8f7ce12a66c226b16014e6. That broad series is
absent here.

Maybe we should this isolated DTS patch. Thoughts?


thanks,
Harshit> ---
>   arch/arm64/boot/dts/qcom/sc8180x.dtsi | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
> index 4715e26fc2647..d3aed296e32cc 100644
> --- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
> @@ -1761,8 +1761,8 @@ pcie0: pcie@1c00000 {
>   			assigned-clocks = <&gcc GCC_PCIE_0_AUX_CLK>;
>   			assigned-clock-rates = <19200000>;
>   
> -			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
> -				    <0x100 &apps_smmu 0x1d81 0x1>;
> +			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
>   
>   			resets = <&gcc GCC_PCIE_0_BCR>;
>   			reset-names = "pci";
> @@ -1882,8 +1882,8 @@ pcie3: pcie@1c08000 {
>   			assigned-clocks = <&gcc GCC_PCIE_3_AUX_CLK>;
>   			assigned-clock-rates = <19200000>;
>   
> -			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
> -				    <0x100 &apps_smmu 0x1e01 0x1>;
> +			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
>   
>   			resets = <&gcc GCC_PCIE_3_BCR>;
>   			reset-names = "pci";
> @@ -2004,8 +2004,8 @@ pcie1: pcie@1c10000 {
>   			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
>   			assigned-clock-rates = <19200000>;
>   
> -			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
> -				    <0x100 &apps_smmu 0x1c81 0x1>;
> +			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
>   
>   			resets = <&gcc GCC_PCIE_1_BCR>;
>   			reset-names = "pci";
> @@ -2126,8 +2126,8 @@ pcie2: pcie@1c18000 {
>   			assigned-clocks = <&gcc GCC_PCIE_2_AUX_CLK>;
>   			assigned-clock-rates = <19200000>;
>   
> -			iommu-map = <0x0   &apps_smmu 0x1d00 0x1>,
> -				    <0x100 &apps_smmu 0x1d01 0x1>;
> +			iommu-map = <0x0   &apps_smmu 0x1d00 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1d01 0x0 0x1>;
>   
>   			resets = <&gcc GCC_PCIE_2_BCR>;
>   			reset-names = "pci";

