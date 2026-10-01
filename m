Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E003D45F7;
	Thu,  1 Oct 2026 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790885382; cv=fail; b=OIi0pMIqaQlU5wD1hW470o+6hS7c9EfR5MI+6gIh/CSDTs9meY4dNHqg8NS291cUh0OF5fzSpgleo/+Qgv1idPCrXcvNPPazSJmtsG0IfpFD253EpHXVVrpdzHZ0gHxjODzrYpci0ihUqokPCozhnQZulNz9DX0cM209cpRGqyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790885382; c=relaxed/simple;
	bh=qPbl9EAi/jBvA9XzHziNBsTO3mlNEky6bXCxEsm1Kz8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kreImkpVN5lxRQkZefb6fNdfYaqoa2cZ1b1UFzmPjsz0E2N188G0BL3XERMYGIoOZYxBTWxgEoLqOSggve5RCuEjJrmmHnMDAUfCOfTYinjdHemFVANaAl+jgi4OFmbwRkdZDo+UfqiNDnrMXvVAOW2GBVkA0VOdvvXtbRHswS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rMZr82DU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q6mNavL1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rMZr82DU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q6mNavL1"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691FtluB909610;
	Thu, 1 Oct 2026 20:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=awmup36CLdt4Vuy2dkYf4Lfjk/tXREOlbsCHCW/JWPY=; b=
	rMZr82DUyAPWNYt6/GxNh4/us5Jg4qhCGg5xVJjg3bepDHJiYO2bifFKlLTka/kb
	ite8YeaoWWHkSwnSYdzwA5MxobmEbbf/0CPr0gKMir37DEzJM1WmxwZpVhW6G6np
	1UqzinMaLcoMaqXQG/WMyiL0v80TGdZDgeZBJYr56yfGjuftnTpBMvB2DAaNNzBd
	rdGl3VTiOIml2sumyYU7h/7HzwmM02hOc8kbHQR1739lEcG1rxKhav84plMjV7PS
	QhN4v+0Uk8+85Hb58plWnd/hIU4Ha6cRfgDqFVFxTs6wFQ2ZceXUDXJtc0THd9rY
	KRq7zqr8qpiUwbOtcVCDdw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx5ns23r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 20:09:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691K55Hq022225;
	Thu, 1 Oct 2026 20:09:11 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gfahpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 20:09:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jz3EInnL/lg9TAeGwQ0h3KTgfrFtP3LO24OQQ4mmBOV68rM5Dj1ZdI9X68oKto77EBGJZJBFDL5fwyAzAXoOfox0y4OJxilXSlAMhNnOee5l6mfDzsvPS7DmYrgTPY2wPHi8KWK18s9dXGIlaqHoGzBJx8C4/FGxN2jt91stlZKn73pOU5r2n+GQqyE10d1zadbWUUtXoySE4pAM6Vfwsm3QusAfmBzNjFUXMOrg6EqSOaaPsVIWyGy3D/vfP+6HjRzLOIk8jWVcmUQwtgbqPylh/oobIhYVh+YgpHYd9/Hf4ZdJ4XH4eHaTIvEjyZsYN8ahAZjUpXxxvtcQZE/7/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awmup36CLdt4Vuy2dkYf4Lfjk/tXREOlbsCHCW/JWPY=;
 b=MMsLD49F4W9caH420JZH1dp4ke11Tq9GsH+D4s+HvcYgXxQdIO0TPtDeMKAIp+vCeMxbE5qlGHeiK6MeCXBd7Km8AQKvHCitD+HBUDWXMzD4//yVaMv57WP+xzez6pVpYNcuXNF3leWjWREEQNo4LIr8AwKCbGEXfLzxkAw/HmpeN9TrnVBkG+uRN2r3rB7pwsS5i4apuJ5iQf4GZRzWS1o2w7RslmBOr0GIzDyyW5JG9OWGhf+9zZz2q65fud6CD2dfNVkSjH3HyiawaqaTCJlgTPB7kEij03zrYkyS1iEKYhU86THtNtITuizWqX7Mv79DIwUuc72uBCmjTWOLIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awmup36CLdt4Vuy2dkYf4Lfjk/tXREOlbsCHCW/JWPY=;
 b=q6mNavL1OHUhb5w8ShT1+5h3jk325+jRqaY6QFgTKP9GAvrP+U+bBW5ycrm+yyk5bSBVjUUn7oGJmsNOi1MZgSlr3sCbOqftmadW7ev/jmeGXvnvXUAGQ8U7IluvPo3dQbCSZLzNuxdwf6YI+HsmqkWWLKElapxNVi+n99KvmXk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by BN0PR10MB5176.namprd10.prod.outlook.com (2603:10b6:408:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 20:09:08 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 20:09:08 +0000
Message-ID: <b3ccd2a3-a51d-41d9-9374-68a392d23ccb@oracle.com>
Date: Fri, 2 Oct 2026 01:39:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 400/877] bpf: Reject dev-bound-only programs on other
 devices
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, co+ac0a8c41de69121d@bugs.sh,
        Weiming Shi <bestswngs@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152423.316713397@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152423.316713397@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0540.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|BN0PR10MB5176:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e2eb80-75df-4837-34b7-08df1ff7d915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|4143699003|10067099003|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MeCEqoyjL/pGxL4cEb8q8nIiQIqh+qzrLJACKPyXjsdS9VJ04sT+9tLXcORoz3oBE00Z3Sx388Jr2ewskhA/YIFob1GssBVxS7QJElMeuS//BfySQJteXFoAhW5l39vLDWPeltHNPu8+VPj6IRVZZRG22UgZ6v+L7uory8VtkQ3ZFD+esRG9Vh/84Q2/Wx3kyWI+ILYrAA1g3eUmHxdQaCGBMozP/QFcqjz1XqOupMVAR35YMMdVlNNR2qbBXg/aSD/gFACIoo6bsi2U1MIryv3h2th3EIHZl5m96D73h0qE1OPIA1UxoRYSskkGOV26wX1Gt6WCmcYwxUMeh3x7ZG6INuxTX507XdopufFTm+5vnPnxHuwBPAMd4KXibzWqMIkzu5rG78XTa357BvB500oZfkhLu7BKZXsoRR3FIS08TWViRaf5dai459q484F6GGf6GWUZaWv9v1dBb0G8jTj05Aw6Cg1PZQm4mrJ/uTvTc4uUW3QVAd9nRIm/ian/XD2m/vcGloIvyAfNavjwgAb1y7rG4QAEgL0HfAehZZ6k3+Z5v8i53tnPs3FW+uIq+H/QIjQH673ZVrNcTey5S/B8qs0TX+rQ6FUQSoF5jwhUz0+MPxEIKS42XeNuNyco
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(4143699003)(10067099003)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3JiNUFzeTJVUERoL1pBYkRDcmJCcUZBcm9oUlNNQjZDbXprSXZVSEZ2WlVS?=
 =?utf-8?B?MWtOYzhtMzRSbkpxeXRlajhacmpRaGkrNlhGajNnSG83V1plRmpWeW5aeWJ5?=
 =?utf-8?B?cnltV3ZPbzg3QzF4cnNadEZjcHl6cXdDRzJVNFJGK3Bub2FhZ0NJdGtrTEc5?=
 =?utf-8?B?MExMbHZvWTE0by9vUTJoSFdoTGFrZlRsZ1BCUkFXa1FpQzM4QlVtYTB3cVc5?=
 =?utf-8?B?dGwyc0tBdTBoRFhBRmh4TDF3RFBBcTVOM0FOSDQzdGc5Z0hPOTFCUzRwLzk5?=
 =?utf-8?B?MTh4UFhNWWJRSWhpWThtVWZVdVhXcC9YMHJKdTl6OVBPanJvakxPZ3VOOFkx?=
 =?utf-8?B?aUlMVSsxdHJrekZ6eHMwSG5QSkFDVk8xVTh3UC94bHdXcDk0aEVXbVJUSTV6?=
 =?utf-8?B?bjQ5M2FoMjFHSm9GS1NIdjBYNE9IMEhSWTU5R1FzUjJESTVsaUpWMHNGTDJV?=
 =?utf-8?B?YVVZNm9yRGNjMUYxbS9INEppUzlXWlpKdU5jbmV4L2J0eHVuVnVIaUsydGQ4?=
 =?utf-8?B?QThLeDd1ZC9TaThZeW5Jb3I4bVN2VlgyNWY3Uk5WVnFFa1pSYlNhemdOVy9n?=
 =?utf-8?B?M2NKZW9lRnN0Wk5jSHRhMVNuZWdNYU9DTUJWZ0lXR3VTd2lZV2Y2VnF2cE5l?=
 =?utf-8?B?QjQ0SnRhbHlERDgrUlNwbGxlUkNwSk9uaFdKRElybnJpTmpHUFE5dndtUXBG?=
 =?utf-8?B?SWRxUDlNNUlzTTgxb3Q4bi9LVjZ3dktLUFduckVEaWI2djA1cUNwczJBSjVH?=
 =?utf-8?B?STBvKytXaytQdGEzWmRmeVhsTzlET1pRTFUrSFUwZDVOclFVVWFTaHk0cGtZ?=
 =?utf-8?B?aERKRDg5QU95T2FKTUV4cERDWWtyU3hMdThxMWVYUVo5L1M5RjlRZEJmTlZr?=
 =?utf-8?B?SjNBYmMxMGlheVp5RHlvWDlxR0F6dU8wUTFHeWFyRVQ2L2JscGtncnd6enZI?=
 =?utf-8?B?TFpyMXc2cFRJMUlvTkNxR2dTYWFxcDRHR2R2OUdpNWF2RXhhdXNKZStjV0N4?=
 =?utf-8?B?YkhNb1RkN24vWlg1b3NISE8ydFFwaWdwRFlIMlYvdXJQaytnc2pWUG8vTUpx?=
 =?utf-8?B?ZnpSakFHL0UwQkpQc2hqWldXM2E5VEd0TXZrbDBHdFQwcEJObWl2OWdqaEdB?=
 =?utf-8?B?UzdEWjJ5NXk4emhDbzZsZUJwNmJYOWdZY0UzdksvZUVnaExXY3ZoZTFtWGxK?=
 =?utf-8?B?ZktGVkErdDljN04yVXNycFFoV2FjTmx0TTJFZ25tcDVPMHdYUm0wTERwTGVI?=
 =?utf-8?B?Tlc0cWVRcHd2L3E5ekJsU0c5OHAvdzVJbG5wUFJqazdtazgvRWlwclRXMWMy?=
 =?utf-8?B?MUF0Q05IT3F2bzV1TVltdUIzdlJXMXFMeDRMN0hZS0s5UGpWRk9ReEVuTEh4?=
 =?utf-8?B?L1hLbkliaFhCYnFSdmxCTXBxY2tjUkQ2UFd0cU1uNGc5djdhbkErOEFWb0M3?=
 =?utf-8?B?NllxMUVDY0VnaE1UZmJRQTlaaGVKcncwazdINlFRWnZzZURPbFRtM3ArVkdF?=
 =?utf-8?B?MENvTWxSYlhwN0NuN3BFZHRIbWxubEdRZ1ZIeTFXcWNWQ0xmNXl5S2R6ZXZE?=
 =?utf-8?B?ZEkzWDJSRW9KZWZiazVpQmVKcFk1VjdhMHRBRGZVWkJLYkRQUEdOdFhiMUFR?=
 =?utf-8?B?SU0xWjl1eGc3SjFlbnlqNWE2U3o5cjhUcEZiNnhFQ3VvT1lvdEZsU01mWXlm?=
 =?utf-8?B?RUs0cnB4QzY4VEhVd0NzQnhoemVCZVExVUZnVWtwVG4yTVUrOVNFOVpURHND?=
 =?utf-8?B?T1N0Q1prbkk2VXFJaHpQbnRETzBCd3lhU2lFRE5weEFzd2U0YlBFY21vaFVB?=
 =?utf-8?B?eWNTUXl3UUVCa2RwYUFKVHZFcFVJWWpKV3Zhd1I5VkVrQmtPbXZmbVFqbFp5?=
 =?utf-8?B?ZFQ0SWVyNzgrbVFxODhNaXVqTUNETnJPakI5VkhZQWc4TGY5bC9YRlNheG5q?=
 =?utf-8?B?dzF6cE10Ly91M3NDbVV4cTVrd0Q4T2g3NzNUSWtlb00yUjZOdmtRRDhHRVAz?=
 =?utf-8?B?NXJUVGZMcTdrRXBGL21CQ1Z0OHVSV2ZtdEIyZHhRaVNxanhQVEhGTHdzNVA1?=
 =?utf-8?B?M0NBN3QzY0RqblV1MzRYSi80MVBIcFd1NjBpTXQyNkgzSVVHdWltemhNV3lX?=
 =?utf-8?B?VUlVeko1U2RZbEhOeUZqbkhGOXBHOVk3V0xicktQVjlOamlaWGkwWTVRQ0xP?=
 =?utf-8?B?eGREekpYamVubXd4MmJrSlp2YmFHR2t5UDJWVFppREpRcWtvTFFXb1JpSSsr?=
 =?utf-8?B?azB4bzFZaU1EYzN0ZWF2eDFtYTZLQUJLeFRzUkM2K0ptU3Z5ejYzWDhzNXl0?=
 =?utf-8?B?b1ovVUhsWGNXZ1NjS1VrVXF2RUowZjZEZWNOckQ2bVhYRk5uYmhBY2RMa1Ba?=
 =?utf-8?Q?SbiWTtqV6Mstp7vLPtOQH+hN4t3ZMkVLBo2F+?=
X-Exchange-RoutingPolicyChecked:
	yuRwLZ2Hzm4PfEgghM8xkQbWOvDmmkC5HmORb83/qB8NjgLCWMvVhffCfaaufPFJGcwNkeTG113NVvm1H+X9bIqOYd/bK47Pf4gXNibqhHtwnyZh3r/pazQj6U2iGJXEXZjlz0wPyBywXkKudlJuq4GW9XNt4ONUxTgcm2eax7GNZhtMjoSBauZ3YoDci5PeJdM4Xp6uJzjLVz4VOKpX5ieL0+uVjJmIzqhLeKV1jozL5izxtNbJ1d4/XZ3drphkl0FTBdDkyPEv+dP9i2/qlIJ/4iDChZZSX54ZQm7HfnX9cfDtjvhJRslN1feBaI5tsnU+xYIkhCgEaxSezAVd+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v89rjYrGX9nGfchhIB36mL/XmoQZyMP0m3TIft3RHC+bCK3OJHTQA6DAzfWky9KwCOhsvSw8Rzb3jEDrUi7q65TAitcQhjugOd/IKTgXYjT6+fqaFprv/7YDzOmF1Apo+hpa6/9kFJc91+CfhDbMwBtbKRFs6fSZjVrX8k11mcJ/PJHo00TYpWVcBcpy91dT7em3IeXJXsoW9sG6IlW+QYt0cbKZ34+kkd7daSuvlQ/eHXfEU27lDoZNWXRdgz/QVc6/IBfaMQ8++lLAtV1yAEWztu9uxFsHoNtqhZZIeJpao4Nkl6PbcACSRJJtMdmWfXuCoyHR1MmVnMyzjJVlDTEg4HMTRo1YzjMlb7XT7mgx6g+HSCX8GTPDgorI3ROqvYJgfH1t3Gv3CxKIUCh92KBnpR7erKqU2Xc5G9m3F/Vbh7q8cCmfNCh3OjFOitYd+9ERHZ5n4UdqJJv8ayzm+5kYKE6YVUlBykrey9gghhZ/zM/ePViTCEL3EeqYoBjWTurQz5pttzfS5154tfxrjywTEDKj8SYAzI72u9EzYV1RZSD/iKzS8DuogIVzz1ZPNDDSVDvzaX0KNL9Pe5XeHoJcLcWhm0M29tbI4CP09Pk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e2eb80-75df-4837-34b7-08df1ff7d915
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 20:09:07.1958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzycekaXUw97h77xbxh1AN/Kz8dPXdiuOkH3OjQOXtHKsixwYttX4VicsDQEtBOhM1nkh44XtNzDHgM68uW0s9gNgG3TmO0641eXH1zl+GS6J2queUTbj1A4ozXQix6e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5176
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610010080
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA4MCBTYWx0ZWRfX06F33crNY6Vy
 c0b8+Dw5StVaokSnSpnlbQg8k4VZcobOWFwi4iQ8/5qo1wKaG/omzIqdw4qATAAwi15xfzWJPpg
 NvBU1r4iReus6UBLxjViu4Su39ah32NJeExXrHW8FkcflCCNNmz0vObcvUiqhA+RDOwnV+SdijU
 l3Q51HNctQC4T5qcMHVW9Uq/8rSENG9LPhaNN6NOq6PPnlUq9o5GubomuFPy3tMAYq8eAx4a3sy
 mJifdQzrIx+Z8iK21FqjFhFLD7Qknk1RNKdoq0Rxd7DUKbpayjk2ucJQH0NJ1zQc0GyPihYfx1T
 FiA7vTzeF0mOyB67D/z+OHaBKWgvvuHIlwoiHsAaLAEOcAYt8rCwTt6gcCiQIS3vGyVAoUywPKl
 8BDhUxSrTTuQarUurN5t6z8aTdhSuiYT6gVy5cCoiZ54yY1rslBX2j3BI/43fIFc7Q58aOMrtxz
 ucVT+2VjxvgcwxYR90A==
X-Proofpoint-GUID: T-HjJB7sXt_7hlKICiFwnmXp1LLHn4e6
X-Authority-Analysis: v=2.4 cv=T8QZ3PKQ c=1 sm=1 tr=0 ts=6abebde8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=bC-a23v3AAAA:8 a=Cpjz6iqz7S70EilvLu0A:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA4MCBTYWx0ZWRfX+/GO+/Wq1rYp
 GmkxcYRq8ebnurwfr809r2SrAYTUW0ctAOGYHtMHAm5An67S7yKGPT29hgQKRtHe8BGESx7DNSi
 0ue5x8ThFUpPDBvumLTUAj9UmuBzkaCtjqmCUtY2vMvGlxRUaSDD
X-Proofpoint-ORIG-GUID: T-HjJB7sXt_7hlKICiFwnmXp1LLHn4e6



On 30/09/26 8:51 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Weiming Shi <bestswngs@gmail.com>
> 
> [ Upstream commit 6db1ce73e9853f533eb7f413f14ba00f8ec6f80d ]
> 
> __bpf_offload_dev_match() falls back to comparing offdev pointers after an
> exact netdev mismatch. Bound-only programs normally have NULL offdevs, so
> unrelated netdevs compare equal. A bound-only program on an
> offload-registered netdev can instead inherit a real offdev and match a
> sibling port. With CAP_BPF and CAP_NET_ADMIN, a caller can use
> bpf(BPF_LINK_CREATE) with a different target ifindex to run metadata kfuncs
> specialized for the bound driver on the target driver's xdp_buff. Running a
> veth-bound program on tun reads beyond tun's bare stack xdp_buff as a
> veth_xdp_buff.
> 
>    Oops: general protection fault, probably for non-canonical address
>    KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>    RIP: 0010:veth_xdp_rx_timestamp (drivers/net/veth.c:1673)
>    Call Trace:
>     ...
>     tun_build_skb (drivers/net/tun.c:1739)
>     tun_get_user (drivers/net/tun.c:1856)
>     tun_chr_write_iter (drivers/net/tun.c:2091)
>     vfs_write (fs/read_write.c:595 fs/read_write.c:687)
>     ksys_write (fs/read_write.c:739)
>     do_syscall_64 (arch/x86/entry/syscall_64.c:84)
>     entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>    Kernel panic - not syncing: Fatal exception in interrupt
> 
> Restrict non-offloaded programs to exact netdev matches and retain the
> shared-offdev fallback only for genuinely offloaded multi-port programs.
> 
> Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
> Reported-by: <co+ac0a8c41de69121d@bugs.sh>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/20260917161335.1020405-2-bestswngs@gmail.com/
> Link: https://patch.msgid.link/20260920132303.4109240-3-bestswngs@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/bpf/offload.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> index 56115739fcfdd..1b6f9e7175666 100644
> --- a/kernel/bpf/offload.c
> +++ b/kernel/bpf/offload.c
> @@ -703,6 +703,8 @@ static bool __bpf_offload_dev_match(struct bpf_prog *prog,
>   		return false;
>   	if (offload->netdev == netdev)
>   		return true;
> +	if (!bpf_prog_is_offloaded(prog->aux))
> +		return false;


Hi Greg/Sasha,

An AI assisted backport review flagged this, and I checked the upstream
code against the 6.12.y tip f4ffa8dc360b.

Upstream 6db1ce73e985 checks device binding in dev_xdp_install():

         if (bpf_prog_is_dev_bound(prog->aux) &&
             !bpf_offload_dev_match(prog, dev)) {
             NL_SET_ERR_MSG(extack, "Program bound to different device");
             return -EINVAL;
         }

6.12.y bpf_xdp_link_update() goes directly to that installer:

     mode = dev_xdp_mode(xdp_link->dev, xdp_link->flags);
     bpf_op = dev_xdp_bpf_op(xdp_link->dev, mode);
     err = dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
                           xdp_link->flags, new_prog);
     if (err)
         goto out_unlock;

Link update calls dev_xdp_install() directly, bypassing 6.12's binding
check in dev_xdp_attach(). Type checks and tun's callback cannot prevent
wrong-device installation, leaving metadata kfuncs with an incompatible
context. The matcher fix is correct; this bypass predates it. No
destination kernel crash was reproduced.

I think 6.12.y needs ad27ed7d2309419a129078d781504f486b1b469a ("bpf,
xdp: move offload check into dev_xdp_install()"), adapted to the 6.12
installer, alongside this fix, thoughts?

thanks,
Harshit>
>   	ondev1 = bpf_offload_find_netdev(offload->netdev);
>   	ondev2 = bpf_offload_find_netdev(netdev);

