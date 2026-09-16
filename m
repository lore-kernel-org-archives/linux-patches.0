Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7796C3A382F;
	Wed, 16 Sep 2026 08:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548362; cv=fail; b=asQVu0tx6R2LpMpWNQIuPhf2F+vUNXVhKi7cENDHsFG7WSYSBBK51i5XbKdmiLKMZ1eBJubtoFmTXf0qVMFMZIRELKgJaeo/HzbSJ7BCLTc4TE1ZszPLYH2XHpG66lNPpGJv0zEpXZzpi72aU9GbMN7w0wz6p60XyRDSoQImE28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548362; c=relaxed/simple;
	bh=E+ii5KFpGz8qpqCqJQemI6/2On5/G7Iga4+X762LhM0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d4vPETAjlU0+g/QlBF/Sv3BHcZ1fCx8lL7x05Rx03kcoBBkX//IuSjBCPefWy2kE+6kqtD73/lWdBt3MZzwsY6d10ze68d36htm2l9ployCWv5lxcb+1hsjtXMQgyeUNuY3pTdvG55Jy34PK4vXI6D586qzlEoWmeh9Fiukzfkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZBT6BbRA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H7T5xLbv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZBT6BbRA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H7T5xLbv"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWY7Q2102405;
	Wed, 16 Sep 2026 08:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j+lvVRs1XoQjGp58EL0V7I+JQ+33LcXSEFZP3nS+nWA=; b=
	ZBT6BbRA4S8oF6boIHdMouQyT8sRQJUhGU3Yt6r1xDMb0hYEqe5NHW+YyM05ra1c
	sY5TBTdjjJrBg9zRL3uXLGz8jqPEod/nroJmRDSpbVShbdAjJ/BpnyDH0LpWAyoB
	MW4+9Ac/04Wx5HNj39Lilqa89aFcWFlwgw+N0xjEp7NBzDWq4vJqEzOQCY4soG+2
	b16uKz/+pQsixDOHVAWYg1HfogZLvargp8t1hXoB4PYRDm69l/l4g9fn8UIoabdH
	V3Hp1Snr19aP6bP0E5asPBAoDfBXOEmKlxjyoCxrwsfdRW0sm1jsNyLEuPxhI0aW
	cqlQ6rQHDDI3Yh3/UWtPGQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxsbn8mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:45:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G8jOt4026472;
	Wed, 16 Sep 2026 08:45:39 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012004.outbound.protection.outlook.com [40.107.200.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q3s10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:45:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4rZlgFNiDkrge+wiuQ0uA2R8/Wa2TFIebG01VgClyLs46nqtu/8C2OW0ePyATBz70xZVtk5YBMPiM3EQpm1EGkVPAhZm0DIU4zJVnKz6alBjU3wLPdrpJUEK3urmg1YIbaG7V6iD+pLFVAiN+RtdaA9ica8VcGpqgMftRtGK8XsF8dfLKOaCe6BcPdzwjsfkDBqmiaGaKWJQjfKu9BScy9itUP9T4OLM/eLlhAz6AU3lnDv+W4XXj76vScKSAAPC026cxh4MzO50y/UvA9L93oDOp6w09o5sc6aFBBnuVJxeCLD5Wwub5/1e9JfAV0mp0inJKn1nkEeAxZ3N/JK3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+lvVRs1XoQjGp58EL0V7I+JQ+33LcXSEFZP3nS+nWA=;
 b=yJG3vRFS78L6Jlu4S5Y7HJTU4aPxwmcjXF8xpigqxt0ynMA4vy57KszPaPUx+YTDUQbnrvOxFDS4XYfl2NUKcFybvQUm61VyhQfkiUp7Yz5i09SG2hi3frDJI9qRh64f4yrAfxn6xmRQMC/hWOrJsh1tqaP7Zka2tyh0FY0W04fshm2wsPrTBREnIt6Tn/wOwro+0M4sBAqTxpySH7OjRKyO5ToOTodJp0dlwr+ccJU1HYy2wV91stI68CoFeQLIBJkONGGxhSxByUZETGsQKvUAbq4Zk94mIXzp3MKf1XTQplwjOHWkqChwnoXpjUf14Ek1cGSiffU1jkxKzrY2JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+lvVRs1XoQjGp58EL0V7I+JQ+33LcXSEFZP3nS+nWA=;
 b=H7T5xLbvvz0Yx/fsPHET/x1/T4JaFdrEcvrZQdQntVS8S/KLQniYYgSTq/dVRImWBzwCJCBIDdcWMp9wr5ic652PCzSUDY5i8GWW+BxFpWqFM40RMuzN8HbWyz5rrzKkDQnxOjtITcGhx0t18/6cSUfFPt9mZwHbNaxeDCPDSkA=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CO1PR10MB4675.namprd10.prod.outlook.com (2603:10b6:303:93::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Wed, 16 Sep
 2026 08:45:11 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:45:11 +0000
Message-ID: <0de39bd3-3575-4955-963c-b528f81b7fa6@oracle.com>
Date: Wed, 16 Sep 2026 14:15:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1269/1376] powerpc: Add preempt lazy support
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065635.822174041@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065635.822174041@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO0P289CA0008.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:20::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CO1PR10MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: 79f3d368-ea4f-4fc0-2abb-08df13ced176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|10067099003|4143699003|6133799003|22082099003|56012099006|5023799004|18002099003;
X-Microsoft-Antispam-Message-Info:
	wDmoEw4mIcQ4o68y/j7MTSLHxMp6aJu/JoUzv+8zv/kmaaGEF6UcZb1oHiU/rLtA3Q3OvlZ0nErZRjkml+XWg18MFTbImuErF41omPzoTYBH/uLQfHlkMru5ES2CqkB9eykC3BfR16gQ+2k5NgMwzWOSwmsXMbmYUVQUNfh/BAnzFhvCLRDZgGMm2qI51GFg/78DR0DlugDtfk1mqPdHMbxlZ9kxcuPuB+kG4+M/uHTpxsvqK4ARynMzd5N8nxDqMyulNT798UNEMxw8f/kclRnkokrBHmdQXrA2r6jqmvmz/G1RD/NOQ+rp4T2kpkkZbs4qzzbus+c7RtHqhIxdPsYTuosLfzGJAE4pa36S7uFNvNHK/2larlgBMWzwjaPLMEOslQlxJB0f728mpmrohe10oSx5YHiRbuy4WwhFq1vN1U7gBwnq8ygyP3Q99dlebVY8CiPtZjtOt9/qGCz3vVSkA8ojsuunRs+B2ULdvl//9/76lDEOq+n8i4C9fDFQRnkpoObyugDFIf73im94Z+KAtVlTVHn3ZKU94E9st77BosVIN+cBsMEPzD2ar/PFtQhJX2rOFY1u9FHjrSpbhtiXagjTgcynVrPnPRtr/CIlT4Fv213hxhF4B+sqL2vS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(10067099003)(4143699003)(6133799003)(22082099003)(56012099006)(5023799004)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3JtUDlidGgwSUJXdzNReEIzL0dXcXA4by9ZNHVtVW51aFlyNkZBZ0dqQWw0?=
 =?utf-8?B?aDFuNVBVa3RBc00zWHBkeThJTk91SHd6NU4rSUZBUkp2cU1sK2dMZDRKNTNB?=
 =?utf-8?B?ZGxTRXBhRmRQaGZiM1JhUmpYRWFkNm9UQ3FFc3hKYkd1L1ZKYlNtd0t3MXFC?=
 =?utf-8?B?bEVsRkIyUHhVdjc2NTdnNVdBMHV1K05BbXNkYmp2bHAvSlRNbHdqekxIaCtH?=
 =?utf-8?B?bzRvMWlob2M5RlZqWUVwQ3hKdysrdXpmVDJnUjNScXpGdyswV2IxTHZYOU5J?=
 =?utf-8?B?d1BGbWhTMlJPUTBpNUt2VEZJZjIrQnNXVEJkd2hHVEFMN1VWMTMwYU1raEZR?=
 =?utf-8?B?a2I4QmtDb25NenpuSWJCbVFieFQ2WVR5SlZFOURnZVE5MllRa25ORitvSlh4?=
 =?utf-8?B?aTY0RXJ4cWtlU2ZkaEZyYStzQmExc2cxeHBMeHFFc21MTkRoZ3ladnRidCtk?=
 =?utf-8?B?Z0hpczd3dEJlVGtDOGZUWEhYQU9MQUNaUVlZS1VWbmlNOVQvY3U4UTBncVZ4?=
 =?utf-8?B?MGxGL2JEUFZnbU00MHBidEY4L3kxdDlESGRMb0pmdm5LQm5oSzg5ZVlqUWZJ?=
 =?utf-8?B?T0dKZE5YdEdsREtpelJwQUIwbzcvOVk1dlV1TzJzYzQ5U2FpUG1YZkJSbUVI?=
 =?utf-8?B?aDk2cGN5OE5hZWErWkRrMmg0aEMwc2oxL0oxdVBaSmZYQkdoWlN0d1dZYmxN?=
 =?utf-8?B?OGJRNmNXR0hmT29NYUdpYUUvU0E5ZDByZEVWa0dmbVFrNFA5cXc2eTVraGxW?=
 =?utf-8?B?QUVSU3NybG9QM3lEeWNyUXRzSWIyamdKRTU4Q0JlOXhPNjdaZjFhR0dUT09L?=
 =?utf-8?B?ZmMvZDJ1WG5jdWcyR2IyYU11WjJ3Rkt6eEYvbnBQejNib3ZWUW1BQUtFZmw2?=
 =?utf-8?B?cDhna2pRU25iNm5LT3A4VFFUUHV0YmIxSzlCdkZWVWVPK2RTV0Y3MEtwVTdX?=
 =?utf-8?B?UVFOczRRVGlHZW1VbVBnbFpVK1hWSWJsMlRWY0kybzA4RjFrdTRMQTBFVVZk?=
 =?utf-8?B?dzVSZmN2UGYvT2JUUWhHRXJVdE5qY0ZRWTdIT2RWSm10WjhNUXRtaHJtaDdt?=
 =?utf-8?B?K1U1T3l2bHA3QldGSmlROExnVGRTZ0JyUzhhejFCS3N0NlBjOEJqcXlxZXR4?=
 =?utf-8?B?SC9RdFhsOHNGa20wYUc4TG9Pcmd2NXFJRDd5ZGRSUjR0V0syNEdMNnc3NzlU?=
 =?utf-8?B?ZFh2aU9Hdko5RVFVc3BkQ2NLQ1hXZWdVMHNrd0xIaVMxSHRhYVd2QnArMHkr?=
 =?utf-8?B?dWszS01DM1d1bWZHYzg3R0JJWG5UZVQwRGptSnZOREFiSlRKUkVpWEc4N1l6?=
 =?utf-8?B?NlZjTmowTG16aFlDKzE3eHJqRHdlTXNCV2dlRW1EMWZRVlpWeCtEWXBtWjVz?=
 =?utf-8?B?YWRMRC9mTE9ZMENVdE1jUnBoT200MWYxcm84YkswNGU2bWN2MTIvd0VCcHBR?=
 =?utf-8?B?Yy8veG81YktpL0tRZTRaRWw5bE9RS1NwRkw2elhKSTVSNHJBRmhKZW5VMWFV?=
 =?utf-8?B?Q05YN0tZY3FYejZ3VTc2OTBVbXJGSzFLWkRRMisxeXNyeGlualEwMFozemdG?=
 =?utf-8?B?c2ZWc1hjemkyU2EzMUwxdTVOTE8wSDZDK3dmbUJCWHdXWXhZK050NWV3VHE5?=
 =?utf-8?B?Z1ZoSGVGakRjcjFkbUpuQVM2TUE2MVlPY0FMbllhV09hMkxkREFMR0xPNGxK?=
 =?utf-8?B?WTEzemp3YTBFd3NyVlNyOGxxTmNMTEp6eDBHdHJjN3BaRlFHU0tTSXhKL2pC?=
 =?utf-8?B?SGQwQjB2b1BqQm9aQkNpZVJiSnhwN013eDY2MTRoWjR2anpQVmtyRWk3S0Ji?=
 =?utf-8?B?b0lyenVJNWNsbm12QjRCcnlDZU1tZTdzRW1YVWpQcU8xVy9mV1ZYNWpVU0N1?=
 =?utf-8?B?Nm4wbE8wQm00aEpBR0NKMlN3alRhaXA3RkdybUhRUXlPYU9WUWR2ZFRjcDgv?=
 =?utf-8?B?WStaRWo2RDVxSW5Ra3hud2NUVUM2cVNvZXQxaXRTbVQ2YmJPbHdLUU5IczlV?=
 =?utf-8?B?SGpHQ01DUUVJMStTck93OFVwOXE0bi81U0d4THJTQU1IL0NvZmVJYlg3cG9i?=
 =?utf-8?B?Vko0QWcxQ3RBYjV1K1ZIUnFjd3JoOXM1ZnNXOG13VHhSZ2s0VVorL3hyb1VD?=
 =?utf-8?B?ZEltdkhOK1MvaGJpYTd4MjhESXRMeDBKYjBRYzdVUHExb1BZRFJwRmNqeHV3?=
 =?utf-8?B?a0JSWE91ZWhXSWFTN0xwVmMwL1FaRUdXVHVtOVlMUDF0YmZwTU9DeE9lb1lE?=
 =?utf-8?B?RGVXRkhRS01ZeDY5ZTZ3SGNuSkhmaXI0ZTV1emV0Z2F1cUR6YUJUQ2ZBRWZJ?=
 =?utf-8?B?Y2Vqdmh1VE9BL3FWVUdraXZlN3FFVE4vU0p0MkJFU1NmR2N1bnArVStsZUhK?=
 =?utf-8?Q?LEwUsNdC5fTzGMZ4Y+MxZzOJluUMNSbp/X2N6?=
X-Exchange-RoutingPolicyChecked:
	nf8L6+ZHqr4j4CYCmJCkpWW/ammiBKvcEl6a0mAh3E8riim2wnRnVfBLnr5SD6L+xfN84OnxNlVhaffdL5+UxFbMNRs40c2hfKR7UKZWJBVUGZM8403r+zedyuPlbRW9pDikOxmKhWCGqOGQNwl/TjuXlTtKfy6JjAR5iYkz2AWVDTVWJm1MdAPa7jm6OaRAOVJ/7QvhDsMeZZcdQHb2GiquuBWIeEOhcbe6ykHq6BOTBOt6xegtge4ryBU/raAL4Zam8yesDX5v2CVHXyTDC6siAOsSWPJsFw+ASh6XcemKevIWPgyXqydFAmoRDLgQmcnfVyc10HPAsKkFzDHnjA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f63ci7WKXhKFG1K8vxVDEWRvwFOmP8YAaxBKhyMfiUnqmP2I8eydEtpdWe1LrF0/Wz1MiMC6Ecky6AwW2ZFLypdh4KJX2U90Be4MOdE9R9O+ROrRBpFmeI+uUNOMfSFQYDlKW8KrZG9eMtcLu9zWy9kf96pcFzj/IhzGn+9VJ3j8tS6uKElNYxP5QaFElm1UwsypRTSsQ/3P6YN8mrn0KZooN73+osxwzhcJdJLeeTaxmjS6xE4I+QASLTrWIhaxNZoH81OAKwyLpfY3aiXHSWmBwY6u4OWjheq9S0pjPCjeWxKupEtqaDhDrebjkZRXeYpXEKDz8OPUkPdQZdhY7gZdeNOXxn0iaKvoc3QXsNpDos8f3UsHVO/HLhMGEfeuTXMkHx/6ALEF5M6YlmWT/oJfA8hrDGfoB2ie9oj2c19XU8B0KCBF1eUdxlm9+nQmOqB77imTMUhmy4rqfvH7apBRMzDLfKOA12GJYo0iiATA9UOwmT7QY4Rf3IJrHfiH0c42Q434cqZ54Gn29wV9mQRk0MPPc7hJAsMZdmU/K2EVrnB7pAz8cz+pinnKDhd92BLOHqSnjlb+oHA/zJhfO3g+i9uXbhajwCPpLw3HA3M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f3d368-ea4f-4fc0-2abb-08df13ced176
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:45:10.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeN8T49UhJ4MRHMFm5r5yITC22vREYAIjb1dcSIKBsjoWxXd4xtdzAJVcBPGIrbQrGZCb1RXM+JVOBS1YToUjZ7kmlcdo8fA1CMTesC836mLAEnjNHtUkuhfQ/xHZteE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160113
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMiBTYWx0ZWRfX+3mECCz5uEXn
 4SZOu7UuCuSry0oE2J5EBtBm7GCxcODLVK2H7FFK/k8Ie+Rta9Fm+LMUEJJgo5AZev9RmhAE6LX
 cnD717BIEfmMJFqaMzw3gYNiWVTk8L6596mblng2sLEf7b2wpq8mc2CpefFKQI062IXnVUbUiMD
 hpyIOHU2YSW6EOeZtIMCj0AQx0TIRLkqxNxIDc5yooQEyMJ2aFepjnK4CPcDCBncr6LbMo4Tlh1
 lMfMzzPMoSZ1wItNcKJmcSLIuY9av4CfaRKFK0LX3X2N0Tpgx0Oeoy+5EhkOPP9f6NQpF4tyl0i
 c+8JM0OqkjVEzOoIP6OJG62fBWGa4UD0dOLBIfjtQvofKDJ6a1OI531W4LHKxHWeryiIiXIHCYd
 X4ye/YehMDjZ5RRSfN4C8V+E6T9vq5m/UgRUPhduXFNgNm8tPkff2/Eo7z99+wH3y2u2+kStMmk
 5FfNhgZsZEOo34rgtVLlRf/DJmARdezpNVLADOWM=
X-Proofpoint-GUID: lREyO-rYOS6UpjgnGo670DrJK4XpQRTw
X-Authority-Analysis: v=2.4 cv=dY0VTnXe c=1 sm=1 tr=0 ts=6aaa5733 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=bC-a23v3AAAA:8
 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=ofjCpGiwhsNdUBgaExsA:9
 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-ORIG-GUID: lREyO-rYOS6UpjgnGo670DrJK4XpQRTw
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMiBTYWx0ZWRfX7BIgIBMd4EhY
 ezout6UcavgwHzCZjukfI8alkEqkMPappBxGRBTEofLeZlhb4frHauXno/pL6ZEtru7/A294bV9
 K4QhmyJvycOBYmmZyALx60griOWQryXBOjSWB/4NFA2DfbdW7l+J



On 12/09/26 12:31 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Shrikanth Hegde <sshegde@linux.ibm.com>
> 
> [ Upstream commit 00199ed6f2ca6601b2c5856fac64132303d9437a ]
> 
> Define preempt lazy bit for Powerpc. Use bit 9 which is free and within
> 16 bit range of NEED_RESCHED, so compiler can issue single andi.
> 
> Since Powerpc doesn't use the generic entry/exit, add lazy check at exit
> to user. CONFIG_PREEMPTION is defined for lazy/full/rt so use it for
> return to kernel.
> 
> Ran a few benchmarks and db workload on Power10. Performance is close to
> preempt=none/voluntary.
> 
> Since Powerpc systems can have large core count and large memory,
> preempt lazy is going to be helpful in avoiding soft lockup issues.
> 
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Reviewed-by: Ankur Arora <ankur.a.arora@oracle.com>
> Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
> Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
> Link: https://patch.msgid.link/20241116192306.88217-2-sshegde@linux.ibm.com
> Stable-dep-of: 902caade3cfd ("arm64: ptdump: Make note_page_flush() range aware")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/powerpc/Kconfig                   | 1 +
>   arch/powerpc/include/asm/thread_info.h | 9 ++++++---
>   arch/powerpc/kernel/interrupt.c        | 4 ++--
>   3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index c7b420d6787ca..1bd5a9ff8505d 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -145,6 +145,7 @@ config PPC
>   	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>   	select ARCH_HAS_PHYS_TO_DMA
>   	select ARCH_HAS_PMEM_API
> +	select ARCH_HAS_PREEMPT_LAZY

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The PowerPC flag definitions and return checks are present, but 6.12 has
no PREEMPT_LAZY Kconfig model, resched_curr_lazy() writer,
fair-scheduler use, or tick-time promotion. Those generic pieces come
from 26baa1f1c4bdc34b8d698c1900b407d863ad0e69 and
7c70cb94d29cd325fabe4a818c18613e3b9919a1, both absent here.

This is a broad scheduler feature rather than an isolated stable fix. 
Mayeb we should revert this. Thoughts?

thanks,
Harshit>   	select ARCH_HAS_PTE_DEVMAP		if PPC_BOOK3S_64
>   	select ARCH_HAS_PTE_SPECIAL
>   	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
> diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
> index 6ebca2996f18f..2785c7462ebf7 100644
> --- a/arch/powerpc/include/asm/thread_info.h
> +++ b/arch/powerpc/include/asm/thread_info.h
> @@ -103,6 +103,7 @@ void arch_setup_new_exec(void);
>   #define TIF_PATCH_PENDING	6	/* pending live patching update */
>   #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
>   #define TIF_SINGLESTEP		8	/* singlestepping active */
> +#define TIF_NEED_RESCHED_LAZY	9       /* Scheduler driven lazy preemption */
>   #define TIF_SECCOMP		10	/* secure computing */
>   #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
>   #define TIF_NOERROR		12	/* Force successful syscall return */
> @@ -122,6 +123,7 @@ void arch_setup_new_exec(void);
>   #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>   #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>   #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
> +#define _TIF_NEED_RESCHED_LAZY	(1<<TIF_NEED_RESCHED_LAZY)
>   #define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
>   #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>   #define _TIF_32BIT		(1<<TIF_32BIT)
> @@ -142,9 +144,10 @@ void arch_setup_new_exec(void);
>   				 _TIF_SYSCALL_EMU)
>   
>   #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
> -				 _TIF_NOTIFY_RESUME | _TIF_UPROBE | \
> -				 _TIF_RESTORE_TM | _TIF_PATCH_PENDING | \
> -				 _TIF_NOTIFY_SIGNAL)
> +				 _TIF_NEED_RESCHED_LAZY | _TIF_NOTIFY_RESUME | \
> +				 _TIF_UPROBE | _TIF_RESTORE_TM | \
> +				 _TIF_PATCH_PENDING | _TIF_NOTIFY_SIGNAL)
> +
>   #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
>   
>   /* Bits in local_flags */
> diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
> index af62ec974b970..8f4acc55407b0 100644
> --- a/arch/powerpc/kernel/interrupt.c
> +++ b/arch/powerpc/kernel/interrupt.c
> @@ -185,7 +185,7 @@ interrupt_exit_user_prepare_main(unsigned long ret, struct pt_regs *regs)
>   	ti_flags = read_thread_flags();
>   	while (unlikely(ti_flags & (_TIF_USER_WORK_MASK & ~_TIF_RESTORE_TM))) {
>   		local_irq_enable();
> -		if (ti_flags & _TIF_NEED_RESCHED) {
> +		if (ti_flags & (_TIF_NEED_RESCHED | _TIF_NEED_RESCHED_LAZY)) {
>   			schedule();
>   		} else {
>   			/*
> @@ -396,7 +396,7 @@ notrace unsigned long interrupt_exit_kernel_prepare(struct pt_regs *regs)
>   		/* Returning to a kernel context with local irqs enabled. */
>   		WARN_ON_ONCE(!(regs->msr & MSR_EE));
>   again:
> -		if (IS_ENABLED(CONFIG_PREEMPT)) {
> +		if (IS_ENABLED(CONFIG_PREEMPTION)) {
>   			/* Return to preemptible kernel context */
>   			if (unlikely(read_thread_flags() & _TIF_NEED_RESCHED)) {
>   				if (preempt_count() == 0)

