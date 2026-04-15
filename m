Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EA7335566
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 10:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776247627; cv=fail; b=B66E9StG69NnRg5UbMN0uiQwJ0KSJED2A1QExhgsWHvWcy3o2usyMs4V1oWiVglaXjQOVKAVCTsnn+DyYFT6pyO47FnQ5jHQnGYn+OB5zIZZCEJdezfnzlh6bKtr5M+H0PCct8FJ1exT5sJxa5YI3VpJwaux0e9Z1vAj3FaBQnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776247627; c=relaxed/simple;
	bh=Tv7S1zHzV+M5VGXKteFa5iVIG+oxGF1U2hd834wnWeY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MmzixLLT0FLwt/eUzgnNtt6vCs/sqNu2yQRuM4OkHlbQG1+dHjE4usMuH4tAoSVBepPiqTQBTArGcZPpZ9lGwPLoOATEdHyZGty+lnJqkNTAGuGvjO4UtGrNFdwyhyX4VVSSxpzEo3mEyxttCewNXpiPRXxVOEd2iyraLlFy2ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bOeuKiU2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d6SRgm3H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bOeuKiU2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d6SRgm3H"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F9BTnZ449516;
	Wed, 15 Apr 2026 10:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iH2e5AIXkdxPFauU4XbG6FvRJ1QbqEmfOj6P/yz6OwU=; b=
	bOeuKiU2xKHn5cMDzd1HHUrwCa6tIPn2puoi2m3Tyr0KA29Tw+/knlMvTanGWCBy
	0GDKpbJXScz8xEIbupclD5rUXfPRJ8p4/F5Gb/eTcQPLb2ks22F7GbjFPvqmmyVa
	ZCwZYEUwdDL0njM87KfeDZ7QzlfGCG5gUQTFjOx9V8/PS4TSX/knBiArF9g8Wg3W
	inawy3duWGpzGVECAgb5Bv+qGVqJt0SpdlzgOduhUiK+8fUHa79r9b+FrFYAf0T0
	Hf14QEMtQLDF5P+s1ncqL0Huzc6Vl5uCgWxCepsvuNvqQ5L4ar+YAFOwSchJMGsK
	ErtSD64mxSktcxKt5RmSfQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qmqy2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 10:06:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63FA4O7b009815;
	Wed, 15 Apr 2026 10:06:54 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010050.outbound.protection.outlook.com [52.101.56.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nmy421-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 10:06:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+tV1bNqTcE6FCzSBFA7fph7uGZffbbxbyjx5ODg/+l4m+iRYooLV77JEkPO3sU5zQZYeazghOYpl0V7icC4aKmZROZzFRx8+8wP0R9PwScuTOfIFu/tbEJ4pLTtMbEg2csa59bhFCbz/hFbQvdJMB5W+kNMT2wvSlCovHZypd8wyzQuQG/1gSjBJJOmT1xPAl879HmkHIGuqLa2ycZPIRwj7qFmhuvcoeqbbwNOa6fPn/9o40fn1W+14AXKk6vaGFLZlc1TsRdH50nEmza/axbBH5IKPTIkljjXe17DIEZe6ggJ0pnUAnX7eLqQhOxKoRb1ZLGdw1BcxORdsAA2pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iH2e5AIXkdxPFauU4XbG6FvRJ1QbqEmfOj6P/yz6OwU=;
 b=zHtI7WV2JqUqcCG7rivKz3GgzU0B+3J6WcXuOZIypWs27pPRZn/W03JQCNCF8Y4t2h0qDI0ObgB7xB5BNARHersFGsnNVLCrBMXHLuhjLwl6nHoCWpqtp/f1b2onfJDFfl+p1e0CvPeIaC/4xVCmGjts5f65jGS9iuqDsWPAf7GlzFthm78+X/huU0TgMy7NqQx+fbLX6qlJnaXGVghI5qu029HpDbBjZsxEuBi/ZyfAiJ9o4UwflMrZc+5sY4cIvTco9i8lccc4iAZRRteIO33ZVDV+vGuPCKM4xzecf4vqvyfCK6N5VgJJaDPyzHTFZULgER1nAXvd9KWks0sKBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH2e5AIXkdxPFauU4XbG6FvRJ1QbqEmfOj6P/yz6OwU=;
 b=d6SRgm3HnpEa+gN0y1mC5ihAS3HIE1ESxu6zJ5rpKM4riRHP/PFfZ5xSQbZIMFyo0xzEsJyTOZEqRhnA2DKcV0WwpcwB85iEkPvNI1nLTBmSwdvqthyfcOWOWfZ4YwTUY3XjVPH2c3DoXx6c4ieGohoIm1yWVlymNjboXCUTXo8=
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6) by CY8PR10MB6755.namprd10.prod.outlook.com
 (2603:10b6:930:96::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 10:06:51 +0000
Received: from CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83]) by CH5PR10MB997695.namprd10.prod.outlook.com
 ([fe80::6458:28b8:6509:8b83%4]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 10:06:51 +0000
Message-ID: <fac09f9f-0390-4edc-bf24-80cc829ea249@oracle.com>
Date: Wed, 15 Apr 2026 15:36:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 265/570] net: mana: fix use-after-free in
 mana_hwc_destroy_channel() by reordering teardown
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Haiyang Zhang <haiyangz@microsoft.com>,
        Dipayaan Roy <dipayanroy@linux.microsoft.com>,
        Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155840.408980272@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260413155840.408980272@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0584.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::15) To CH5PR10MB997695.namprd10.prod.outlook.com
 (2603:10b6:610:2ee::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH5PR10MB997695:EE_|CY8PR10MB6755:EE_
X-MS-Office365-Filtering-Correlation-Id: 881be7bc-551f-4473-4385-08de9ad6b696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OCbQhR1zV1H7O+6/7TbKQkUF4a+tI7GyM4e6GpfZz4Db9dW5vsfbHGLHfdkSlw5mj3qYVen19MwBv47NaGD+Mx0FELuCdW0Qitq0m8Ih/m2yArqE9vjRievyHjrd7ulBm8GDMLYfU7XgfJ+HvZZ8WQ7vrhwAsUUiXnj+KlHTeUyW8dn7OeuL4dfBrhJVbjQ3Nn0sxtjsAUu7xprQ5EWt9Nar5+F1bfuuMPx9SBGIzNFDdiZVjUth+QW4dlYb/7Cc/Xuc9NgCl0iUvfUXjpVqu3C2s2eM1IpUxP8sAOCdbU/3hiwPhY/GtGl0Pjuv7RGWU2lZd/d/5bRbFa6gTkFrnG+hCijOOwYSTXn+KCrKpp2zZ7pILXVs4OelnutWiip5FMhSZt5JxF4Wm2MnMACatkI785KixXcKm0+4p7Frs2ULSs3r3K9JIswiSlJQc0o/waDwyMgrj35KoQN2ObvhYTUKJz8GM9BBtVzvtAAuUWs1D0L0rrC645Z/lGp4rHgM9fPNKm2Q5oUvUJEL8eLPt16wjy+PlpcH3k8UaHl3k+ev0JdA3idjAgTtEnkuICmsmcuEXdzV57cXjWHEtgsNt8AK9dJk3NiXp0QeLwSHE5S3Sh13o0QlpLys8EC3/S8lBpyMkKLyPcnRJ40YayNTL7mfYzeZvK0XZqo9WVAqixdmP9frqJjaW7IRUzMuE0HhvCsT5VJ46vhYJT2MhyGojD+kZqLnJM2Yvza0aaFCXps=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH5PR10MB997695.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVgwcTQzaGtuS3pBQXVVcnFDbHNUNzZSRGpGdFp4d01DR3ZKR0Y5N2phK0Mw?=
 =?utf-8?B?SFhGdVZlRHlkZzVoa3NvYXFNSnFyQlhLelYyZmRRdk1SVUUzRTE3Vk01cmNE?=
 =?utf-8?B?TTYvbzJTd3ZmdHB2MFQ3aGpQbHNFVExCTlpJYkM2cVF2a0JzMWplTmlpcGZl?=
 =?utf-8?B?VVlxcnlaUlZjN1pqK0JCUmF5bktrd25mc0VaM3czU2FLTVRqUENtSE1xb2RO?=
 =?utf-8?B?eFZodzZ0a0lEZlZTTGs0YVBkanlOM1VJSDdwSHpWQnBmU0FCNTJqSjRyMmVR?=
 =?utf-8?B?M2pKdkkyODM2VHBvREE5My9obVNDMGhhR3cvdE1Fd1NRbytzRTZEbHVhSXJ4?=
 =?utf-8?B?T2p4U2hpL2czdUVYRVZxU2FGMDV1Y01XbFFOZ1VVZk9JenNoZUl2RVI2bVB3?=
 =?utf-8?B?aVBhaFU2STl4d1p1U1BsRkhSVHJLVXNnRHlNeUI4NU43NzF2TzJLUjY3QlQr?=
 =?utf-8?B?b2VEZGxITGNjR1hSZjNpK2cydDZ0bFVMWnQrZVlKS3daU1ZGUlVVMmRUNkNV?=
 =?utf-8?B?Rkh4d2tlZ2J2R0JldE03M2VZdlNBNHlSU3NCYVEyRDBuRHAzY0ZpV0o4RW1Z?=
 =?utf-8?B?c29kb3psb205cWo0bGxWU1J3UUEwbjk4dW9lRzhycjE0WEJGbXRYajNNSWhO?=
 =?utf-8?B?aWppQ0o2cFJnMUNSWmUrWWlySldTdUU1WmNvb21iMDNUMkZPNmZSeElEWjMx?=
 =?utf-8?B?MGthVWY3TnArcW1GdWs4L2FsNmlKQ2EvVVVhWnduRVVXdkRXK3BOLzR4OWpU?=
 =?utf-8?B?M01WZkYrUmJxZUdrZ3d5S3p3YkNGMjhCL0k5bkR4MjRjLzY4Rk9vTCtLUjVq?=
 =?utf-8?B?a2ZxSnBySy9ieHB3OVlnU1QvYUppVjAyNEZSWG1RTUY3UDNxZXJYRmtCVnVB?=
 =?utf-8?B?SG1XVk5DZm1EUVcvanpzdVZ0WVVkTkJrVnFMNEJFT2xoTmRkdTZUNnQ2WU9V?=
 =?utf-8?B?Mm5ZdThEeEFzbUduM0NYNVZ2RFc4cWJUZkhzeGZXZjlUR0J0ZUpSYWxZcDRS?=
 =?utf-8?B?Umc3WEhVclNkOFpZZmY0Z0M4NmJsbHNwNm1KTmdKQ3dBWWZ3QkdHTzluVFRo?=
 =?utf-8?B?OFlDRFhZWmtnRDJONlVVVFlGTlZPdWxXWXRpS0QvYUpqTkxhdW05RTBuK3FD?=
 =?utf-8?B?RzlrRW1YUGJyQ0NGNjZpZXg0YnhBQUhkVnd4T2J0aEJ0ZUxqZFozN0ZaKzg4?=
 =?utf-8?B?clZ4ZmVLRkZZdW5BUVZSMjBBQURkTTAzNXpNWFJyNkwyV2lZNjVMeG5ZOVVm?=
 =?utf-8?B?ZFh6emVKeWM3cmVUd0hlYmU5MXZ0ZXJHZk12c21rRnJZTzYvUjF4NWFldWJN?=
 =?utf-8?B?VnkyRk85VEc0dkdXekg5NXZXcWZrZUZNQmFqd2tzd3pHdzZLL0ZSWE43RFp4?=
 =?utf-8?B?WDlzaVRNRFFRc05vNkhzbHFQanllbUlISTB1RTd6blY0ZTlXTUFlSmRWenR5?=
 =?utf-8?B?YmFQb1ptcTNNQk80WU5WaG54VFFKUkhvZVh5OUt2M2dTSVdSY21UaG5xQkEz?=
 =?utf-8?B?UEtrNnordmdKd3JNak5PVFdnZHQzUGRMSGdJZTVVZ3dvSTVDeHhOd3FMNm56?=
 =?utf-8?B?RjUvbzcrTU11dXN6REZxS2lhc1BnTHVDNHplSlNxM0JxNlBiSU9vM1d1dkdn?=
 =?utf-8?B?YmFMcHRsYzhOc3FYRlp3eXBlOTd5a3JjdmVDMlFTUnJXdHhJekRtdkhzOGdL?=
 =?utf-8?B?SmhzemcwTmJKNTRmR1Q4VlVMVm1iVHNjdEZPQ094cXlnTzB5U0E0ZUltWGpT?=
 =?utf-8?B?SUFWNCtOemRUQVlPTjdseHgrWWxBYzVORzg3S3JRZUp5aDlZTCtVelh6VFps?=
 =?utf-8?B?cklqalNxQk9rL2NEYTVFQU5UdmR4S1M5NFFEMzMveFBhUDJUby9ScHpvYjBX?=
 =?utf-8?B?eXFMMnhWdjFub3ZJL3RkZC82T0NqWHF0aTZ4MS9LRnRQUkd4NVA4aUFSMGR0?=
 =?utf-8?B?MStXQnBQdm5UbHloTzdZT09TYU5mTkdnY1o3L1Q0b2U2NWxacG1lSGlIcHo4?=
 =?utf-8?B?bHd1K0ZxTzFpV0U0Q2t0ZExubGhFNURteGdSTEVmWWhGT3Q2RFhnN2xHQTEy?=
 =?utf-8?B?eUNXMFdLZmIyNVNBWXNpcEgvZUdnazc2ODhyalNJMTJZTVdOeURJVEtvSFJq?=
 =?utf-8?B?YzFaTnBFTlYwNGZyVklrbVRjRlNxWWM3ZWtsVzJCSjJpVStuY0dSVmwwdVI5?=
 =?utf-8?B?WWJXU3ZXMTNHNHkxNUJDdExMeDdKT285bEgyaThkMkFBNWFVWHBXR05EcmZw?=
 =?utf-8?B?dFR4UHdDRUVxcHFvNXBRVGkvazlzKzI0b0k0UWxxeFNvN3N2VmxkT01qM0o0?=
 =?utf-8?B?V09SZnFaUGRCd0VOTmNiWnNiaElkbWg0MHlWSnF5ZlJZUWFsOFNVVVMzazlm?=
 =?utf-8?Q?lF2VAi1voVDCCK6JkcXv5JU7Y8AeFR3ILj1zV?=
X-Exchange-RoutingPolicyChecked:
	NvbB3oXh1SsojBNqVI93De8DiACDB6ETLl9fZyHQnU1NN1+vGf6aoRFEFxpewiGuH+kzvuvxM0dAS+sLwX+HDap8Wgu/Sz6F42l1wgl9gpGqz2I+GmhVItA1wWXE6j7T17qVbmrEJDdh00vluzEGwJebiJzHKIDnXDwY8rLhd1K71Us/oJiHZsalIg/B7rRKJhTv4prGpi8asYl4bhRYIVS20BBfd59mb+iaPd3dwbzGzIm6F/vS45v5U66G0gc1M0qS0MsRVO37aHHulXF8U3YSmlr9v8lAZl/EJApL3Aje9x2EY+2vgC057k91pszGiFR0RCDYAv23kSmPOhxQ4A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tteknst9DKsAzt2LDyBpV7cudGuFVZm+JIshAuzgDgv5Y6Hj/V/UiPIBTZ2s97juls377Yj1xVyf/7l97/HpAemlBJWm0jdCQGB1u1j1PkuEjT0AG/cONJbSo2A38pmxoyLtJ4PtQvsVodGIoveqHXfbKYrIsOlJgAkNGSmLkyjgqKdrOa8M6Y5UTluxhH7a5C+5HAcXMY6V5Bw5ueB2OgrgW9K84DAGGheI44MdryzzZUi83MtyFJkjaKUhuHGxJfizjyhoG2GoFLavzm2mHV7yQKnqwcmvWm62T+Nte6fbmR0nTv9f2V4Y55T8EYhvZGnO16cP+W6Rv0/WkQGwOxWOsNohbp/OZ8VR8Fpx7iIOo/njZnMnR8BqAcP0+70X6sR+JEm7duB2/vrGDqI5j+egjzWBNH0VdzigS5NTHOy+GZTiSv4Xg22wVVpW9MzDkKEe8QxSkVSYYthuorqgsZpViWFSrkQpkALB0ZVkB2dwH+vG8NwdtNBjW6LxJhw7tteFmR3DmEsAzrMPZt0E6ihVqirvNxxTsNZvQK1CJnIXlUwLNldbouy7JyNMhdRAg2T5gKKMtpPHOfa5L/UHWvMPb8gAAvUM0rq6RkAdQ9g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 881be7bc-551f-4473-4385-08de9ad6b696
X-MS-Exchange-CrossTenant-AuthSource: CH5PR10MB997695.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 10:06:51.1506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gx4g5IMxTDNSCsNhv2m7DJx9qC3VxGuVqQI2+oi/VNF7lsHntrsOpiAo42YQfrh+HLdTq9aVPJALMLIEf7gBv031ItvqGdLoGD5E++8nRh5cvI7+6H5y2I74ZuF3vL/I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6755
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604150092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDA5MiBTYWx0ZWRfX4UqZs18Ktylf
 UjRV09+purRQpr8KfMCcrEPBTrwBL+9Ptbw363PSCyt8EMwi+1TUdi1pM+owtKbKsNaHpkekx/S
 6V8F7tbXCASUFifowKxVf/9FMmZ1gMT0DtFWS2jb+TmQaIto49NOKNC467d3oXJIVZiMvi1/b8K
 GGVRlyirE1PbGQPjalylHwZ4QHdnQv6cFs9g3haG7iV7Fy+52y0JXbSNVoXMxHht9BpdfkBljvc
 898g/yM30WY7x0XrS5pbMehLpdCXRej2VuIi4ZmL2L1HSyqdLeQ01o9hY/1gZELGI1UPZFVf/ss
 fm+ZB4Aie8UpxGeVu7WeZea7ADQdIYhH4Or8V9QKVe3xI6+m3jYYq6Jo4SY4dMyIThD3eqUXr+9
 K/38vSOaMpvxbSix9anCamsETWsBll4IqIuH7DdGbaXy2DoiXA4WZSZQe/+XBR7w4JhKUXnukmC
 1jEbqqyGzS6UqKwaobFXRKQjTTi+qZlYrPolVofI=
X-Authority-Analysis: v=2.4 cv=Lo6iDHdc c=1 sm=1 tr=0 ts=69df633f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yMhMjlubAAAA:8
 a=QWrB-X7hx4et8dWeW34A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12292
X-Proofpoint-GUID: 3L8DqDVKUpkH100iRB9VkUbOY23zH6a3
X-Proofpoint-ORIG-GUID: 3L8DqDVKUpkH100iRB9VkUbOY23zH6a3

Hi,

On 13/04/26 21:26, Greg Kroah-Hartman wrote:
> From: Dipayaan Roy<dipayanroy@linux.microsoft.com>
> 
> [ Upstream commit fa103fc8f56954a60699a29215cb713448a39e87 ]
> 
> A potential race condition exists in mana_hwc_destroy_channel() where
> hwc->caller_ctx is freed before the HWC's Completion Queue (CQ) and
> Event Queue (EQ) are destroyed. This allows an in-flight CQ interrupt
> handler to dereference freed memory, leading to a use-after-free or
> NULL pointer dereference in mana_hwc_handle_resp().
> 
> mana_smc_teardown_hwc() signals the hardware to stop but does not
> synchronize against IRQ handlers already executing on other CPUs. The
> IRQ synchronization only happens in mana_hwc_destroy_cq() via
> mana_gd_destroy_eq() -> mana_gd_deregister_irq(). Since this runs
> after kfree(hwc->caller_ctx), a concurrent mana_hwc_rx_event_handler()
> can dereference freed caller_ctx (and rxq->msg_buf) in
> mana_hwc_handle_resp().
> 

I have run an AI assisted backport review and it spotted a probable 
issue, I checked it and I think is worth checking here from the authors:

I think this fix relies on presence of commit: 02fed6d92bad ("net: mana: 
add msix index sharing between EQs") which is not present in 5.15.y.

This patch mentions:

""
   The IRQ synchronization only happens in mana_hwc_destroy_cq() via
   mana_gd_destroy_eq() -> mana_gd_deregister_irq().
""

and I think that is referring to the synchronization added in 
2fed6d92bad ("net: mana: add msix index sharing between EQs"), and give 
that we don't have this in 5.15.y, the UAF is still possible ?

Thoughts ?

Thanks,
Harshit

> Fix this by reordering teardown to reverse-of-creation order: destroy
> the TX/RX work queues and CQ/EQ before freeing hwc->caller_ctx. This
> ensures all in-flight interrupt handlers complete before the memory they
> access is freed.
> 
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Reviewed-by: Haiyang Zhang<haiyangz@microsoft.com>
> Signed-off-by: Dipayaan Roy<dipayanroy@linux.microsoft.com>

