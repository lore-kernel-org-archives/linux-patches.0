Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F7C2BF3F3
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760719319; cv=fail; b=HNIrf5Vu5O4xfyKqcBC+e+IIBtJ2ISXpahG9pd9WYHYhRUo0PlwpFKXQJU3wadM93UMbJRFC2kByIq8Eg6aYnFi9rohQOc45ENAdTR2Z4J2OzY6/E4i0wjJsMBGtQBxGET5vHUZ9q4kVgqGcGKWQiWp6W1110FgThdvcwseIBLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760719319; c=relaxed/simple;
	bh=1PbWywLGz56MhUyZszG5B7calkrfbTWLI8NnRTwxtwU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yk5E8Y4zDH0rUYeOSNmF9ntZg/hqrQkKIPu5XbJAz/knXiPDax4rjvrXKewhZghN5PCb5QIDUPggW2FUlbEiKHV5nGjSIzwF4ugXwc/EYKGCSUPoYcmvfAzQogtnN54kS4giuTjJNmiaJsAAo8XY7xdtl0zAh3yhTb7Yf/7coq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OVEbugEw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xg3tLP5a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OVEbugEw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xg3tLP5a"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCda9q014041;
	Fri, 17 Oct 2025 16:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IHxh3Gm3qYErv5Rdlbkv/wK2VEutBNdeOoAp5OPHHOc=; b=
	OVEbugEwENCQ3SZtv+UzYxQpLkrlAT8WazkIooIisl9md1/Oqghc4eyUzkEUCCiR
	i9La4M3cpZY3iO6nwAzfbxCRTLr8NMyG2v31PfpddTIaXp12HAmUlAVLtW9TsVCv
	/ArmvTop1d/EEO6YGFKSMPVnBx8NW24bP3ey9A1plkxGaESnj814IMENaForl/AU
	ruG44pZKGVXM7Ir0tzzzIvLPUDP43G786dOK56tnrsam2IfHbO6s+OhGLtoud1BC
	wqqIE9ahikAVcc1Zl/eb3TQVSxRJ6c8m7BSr/12h4No0657gN8dwAw0X8Meub5HQ
	O4e1IKhi3vxD7btAdwJj6g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qf9c3es7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 16:41:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HGMlfO025867;
	Fri, 17 Oct 2025 16:41:45 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010065.outbound.protection.outlook.com [52.101.85.65])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpkb0sb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 16:41:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dr8Xp9574g/XYHQzGiCQiEQnyLgmbWNMLIK7R0fPaAFfl1t+3hqx8W5Sr8dpNsczWWPcVB3i/MOQiDvyr2NYdAdIRvF45kCHEedy0qvHSonUtsFBL4MnxZd+02pe0/zIgYVL8pPnP+sz1/FFVFTGo30CewQgmJrEHvaK2vZvnEfnIu9tfNtzZhkfUORr5qfZJy0XdLbm9k96XPAvqQB6HRpUPRkJ0fxkBV+s7FnZ6eDOwtFZ46f/bNqIobAZaz3s+xbPbWsi0URax5AJ0pYPmYfr+SCksEdF/K9cFRU9+cyRRt6sUPnxokN40RH2wrvHEMi9VMH8cxmDrTRC563Gnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHxh3Gm3qYErv5Rdlbkv/wK2VEutBNdeOoAp5OPHHOc=;
 b=kLxgW1tLibITg15BuQ9kJuV42MXxhCcC1PD2IDztdYVkoyjUR0h4LPPOKxCTcJ9kbY8j+XUg8CayupiLeVlf+4dlYhif5pOR1tdPqPAaLMC741eQMAnQk1ByjoTVFnakxH9y0VqdueCBIL29BDz3dUa5VTcIeTt8QP+6an5B6aVRTvubOf80kPm29MfUv48o6daVPatvvBGlxCtgj2548BgahxZjkFZPM9/v3roUFju1igpEqTVghtYuS7UaK23n92Kc1G84S4vcdzJboIvRUKRj9fTS+cmnP5i7EzCBhm9zBBRmREG7qD+Z0W2rfuAWol8DpqwA80aIX2qd8mJeJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHxh3Gm3qYErv5Rdlbkv/wK2VEutBNdeOoAp5OPHHOc=;
 b=Xg3tLP5aTEYVxa20oMaIGZTitmJZqxN1OM5sczsanZ6lOmNFTPPzV/wIj3x2WscwVHJK/lN/Y3/0K4Wi+3nEHsW4PkI5Jy79Hp8TYuyqNRg0i/pU8wBqzYEtmDGbmPmemkUY60aheXbKBwnYpvPQ6L1+NGXZ7hVfidytDvXvFj8=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by SJ0PR10MB4718.namprd10.prod.outlook.com (2603:10b6:a03:2dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 16:41:42 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9228.010; Fri, 17 Oct 2025
 16:41:42 +0000
Message-ID: <ba4f2329-8e29-4817-993a-895b8aee4fb8@oracle.com>
Date: Fri, 17 Oct 2025 22:11:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 238/277] KVM: x86: Advertise SRSO_USER_KERNEL_NO to
 userspace
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: patches@lists.linux.dev, Nikolay Borisov <nik.borisov@suse.com>
References: <20251017145147.138822285@linuxfoundation.org>
 <20251017145155.829311022@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251017145155.829311022@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0240.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::19) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|SJ0PR10MB4718:EE_
X-MS-Office365-Filtering-Correlation-Id: 86ae7aec-81d0-4996-049e-08de0d9c0d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1VvSG9VRmM5NDRkbnhra0Y4OU91cXRkc1Y0cm1WT0cvamh3SU1lTEF0RFlk?=
 =?utf-8?B?QkpRRG1qcW1HTW5kMVRxU1RNQloxeS9MajdjWVNUYmpaalM5LzcxWE5EN0wy?=
 =?utf-8?B?UUphbDhGaFJmZFB2UHczNTArTzFaS2ZvRE9ldmVEdFl4UUE0RFJQSDlDbDEv?=
 =?utf-8?B?dFN0T0NQN1Q5dFZxMHNESitiZTBQcWt3bEFaSDErYUJtQmErdytWYncyKzF1?=
 =?utf-8?B?SUtTd292eWMwUFJhanVtVXlSVUNrM2VhK09KYlo4V3ZnK2VzOFg2QjNFYjVO?=
 =?utf-8?B?NjNWSFpqTmR0eGMwVGVGdnAxTnlJUGlhcllNNVQ2Z0JTb3k4WktCUzZ4em52?=
 =?utf-8?B?R05tLzkvSFBjMktrdEE2di9VTjdEdDNUVFJWdTlqU2JkNE9DMW9EMTJYVTlV?=
 =?utf-8?B?MjdkcHNMWm91ZG1qZ2tRZS92MHNaa1hIU0Fob1BrZ01xb3BTU1d6cGdnOEtr?=
 =?utf-8?B?Y21VcGlGbzI2QStuUGx4dnpCem56eVBpS2VvUVM2WFhTR1BCcWRhd0h5bjR1?=
 =?utf-8?B?YytNaEFWL1U5clpjUWpGNlU0cnZ3L3NDU3c1VTRib0M3RFJ0c3VBT0pwYkht?=
 =?utf-8?B?UldCQjF4bHlkazN5dVJ2RmkwWXRvRHJxb005SDNMbmVvSEhIZUIrUnlnRWpG?=
 =?utf-8?B?TWRoM1JTT0RTM0dkT3hQU2trbGM4dWNJajZ3Q1ROaEZZNnJLZDEydmg5TmpR?=
 =?utf-8?B?QVlNOHllSC9LcFNLcTUzUWs5azBtSkdmOUs4ZHJnS1JCbTAraVJHWGswWWpR?=
 =?utf-8?B?NkduZlQvL0I3YnFqRVJaa0IyVE1HL0kzd3hROXJqUFRaSWl4MzM4TGc2OUlC?=
 =?utf-8?B?bVpYb2VyaXV1d0lpUFFXSjEyM0FaQ0RKNmFFaDM5cThkU3B6SlJiMEo2UGFS?=
 =?utf-8?B?Q2ZVYkIwSXJBeVBXRHN5Y0NnY1hVUnB5SitiN1dFcm9WWWMrVGc0c0h3U21t?=
 =?utf-8?B?VVZ3Nk0wTjhjakNJTVowbElneHlNUWl3S2lPT1dBU1prc1FISER2eG9LMUl2?=
 =?utf-8?B?UlljUVVsY1lwbTlHenpDZk1RVmwyWXp6N2hBaVA5ZGNBQVBVbDB5d3VVY3gw?=
 =?utf-8?B?YjlSRExtVCtSN1ZMR3NmRGlBWks4c2ltUmlVS21mQmY4aldLYTNuc0VMNkNT?=
 =?utf-8?B?QlZxNDlVU25QR1dvQXhmNC9ETSt5eE9idmtiU3pYWS9SRU5DYkR6V2JlMXMw?=
 =?utf-8?B?K001L3VRb1dZbGNJaGIyM2VjbXRsMUNLSHFMUms4OWF3MGlpV01mMnZ5d2tN?=
 =?utf-8?B?SHhUUkltaC9FQXY5THVFQTlUOVpFaTN5Y0tYUCtPSVkvandEeER3NExrSEdL?=
 =?utf-8?B?a0gvYllvT2ttYks4MkpwcXhxT29HYjV2cEFsMVRCQ3NWa25Ka2RCOGVmc3Bo?=
 =?utf-8?B?d0gybEhVOXo1SVpWRHo4d2hqTEFNRlJ4dFRVUmVEUE43S1pLK0ZuOGlGcVBm?=
 =?utf-8?B?SWM4aDRoTGtIcFowSVp0Wi82bEhxUGN3d3lpU0NBcmZUcEsxekl0ZUE2RitH?=
 =?utf-8?B?MkJSV1ZBQmlRQ1JsSE5XazNvZ1dTVEI1WDFncHd4UlVSUXNmYWJMNVRFeU9o?=
 =?utf-8?B?RXFqaVUybjFnQVI5TTVKSHBUMWhHbFU0QTI5dFlEMFNHS2Vxc1pRZW5KbSsr?=
 =?utf-8?B?K0hYb0RIQXRKeWpTYnhpdkdrcjVlNGdoU3NEWXNrUDdRdW0yenJ6WXJCWDRC?=
 =?utf-8?B?N3ExcTFkTk9tdXdtMUZtZVJ5ZG9MUE8zQStzd2xrNXlFS1ArL0xvYTJXYVJD?=
 =?utf-8?B?UzdGQjQrZFlmelpyV2NqU0hWalV1blVTaDAvSVlYVnViM3VOZndpVEJUcFZk?=
 =?utf-8?B?SW85Qy9vazhBNHhVZmFDU0pXRmJCNldGbUVSRnhCbXVJQkZGcG9vYTZrL3c2?=
 =?utf-8?B?SUFMQ3dHa3JPRm9RVERhdzQyOGNacUtpempzUS9KYXFxWnN5Yzh5VVNCbGtU?=
 =?utf-8?B?MWRYSTFDWDhFOXczYXdTWWF0a09wTlBKTW1STmp1bHUxRFl4aWVYdms0TXp5?=
 =?utf-8?B?VWpta3VZOW5RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mjk0VGFsRFRKdVdNOWxLWklNSXltaDl1T0FMa1pqQXVWUm1CNjRlbVgyR1Y2?=
 =?utf-8?B?cXFSVXR2M2hwN2dseTBINXdMLytJeFBYUTAyUFUxZG8vam0zYVVzL3pwR2Za?=
 =?utf-8?B?QzRTbmt4Q2dzRWQvZ0lLdXZYYnltSnRkMVIyRjlZY3RpYW5IL05EVHFuZnpi?=
 =?utf-8?B?T0dtVlNUbW54ckx0TEx0NC9CT1BHTTc0bld3c2NYdW5yMWFud3RxUTd1UnBr?=
 =?utf-8?B?ek4xZWo3SUl1UGd4WmVpaEgyZlFJYmNPZndOZ2NMVzFrTi9vVFVObWxIYTNY?=
 =?utf-8?B?NzFEWS9kN25GS0NIeHpvS3RZTVFlb3lPOUFQem9UR3JRT2JzeTVXcjM5bXFt?=
 =?utf-8?B?OGFHeHNzZ1lGK24wc1hUUzc4SjJiYVpQdXhqcDdkUWpHY0o3SzhqcXV0SGNL?=
 =?utf-8?B?LzVsSkFSdlNIZmx0d2xTclkrUkZRVDJDU0pTKzBWQWg5di9Sdk1zOG54QWdC?=
 =?utf-8?B?b3gvOWw4T3MvV3hJQnpNQnNnVjAydDhWbXUwOHk5ajJ4ZEhyZVpJOWhtTlhB?=
 =?utf-8?B?S0RBdkpyUFFqZW9RV21GUlEzOVRCQUFrZHhLVzdQeCtTaTVpQnVuVDhZN08r?=
 =?utf-8?B?OTBPRTMrWjRndHpTWTlGK2hwb21pdnRrbVVlZVh1WFdyMFM4NlpjRE9UQXVh?=
 =?utf-8?B?Zm9HYk1pTURVWjArdldZa2tDT21pZm9wbGJRM1JyR25JQ0V3UkxHL3psejBD?=
 =?utf-8?B?VVRwQWh5b3hIZ3hwM2FyN05ESFhQdG95TE1DdU9MQXlKMGtsczAvbUZmSU9V?=
 =?utf-8?B?SllGSzJkTHNmNitibERHYzBjYytTSHdXR0VTRW5SdWZ3NkFZR3gyMWw0MWdP?=
 =?utf-8?B?ZWJ3V1R4amRBaW1nbFAyOFhRU2pZQWJwdW1aT0JhcUY4eGovQUUyQll4TEha?=
 =?utf-8?B?dWVDbGpHcnBWNWxPMk9FcHBrMlYyajZZWTZ0QVRHSXpiL2pBdkoybjR3MlVT?=
 =?utf-8?B?SWRSU0lBbnYzMzRVU1BIdHQ0ZDB0alZOeTQ1eC8wTjlLZkpWMFlud1h1dC9G?=
 =?utf-8?B?a1p6Wk1Nc3dwNG9GTUQzbC85MWQ1UU4xdnkzb0ZseVpCVzMrY1BsSlAxdlNV?=
 =?utf-8?B?bHJrNThUU1RrMkZnMzRzRUdKNkx0RmlaMmdQMWxyWnlJRUZEZVAwYW9zYzNQ?=
 =?utf-8?B?ZzRWbUljcTJOcnJNNnJzcEZUcFVwRFU2VCtrbUY3MWoyYWdXdTBRZTBkNXN1?=
 =?utf-8?B?NE1Gbk5WWGsxazdZdGtEazNJT2ZoYnVZOHg2cGJ4MnIrMDRuU2JWaVdKaEh5?=
 =?utf-8?B?VU5IZjVHUGl3S1FuZEFkbjdRSU0wemJJQjdoL1Q0VERpOGttY0x1M3ZPb1k5?=
 =?utf-8?B?OXpJcnNyR0xLU292cjdFWDQ2TEJRMlRzTWZVNTZMT1NuZkdTME1MSURMSGYr?=
 =?utf-8?B?MnRKWUNIcnpaanh2SVNVSHhUNDMzZi9lKzB5RU9mbVpqT1diMUJFcWFCN0o2?=
 =?utf-8?B?VnN2NnBRaHluQllaVEVaNndtQXQxV2hOUHFvbVlsVHYwcUJLcENMVVNIdWkz?=
 =?utf-8?B?cFhzMTkvMFVLUUNZSUgzRVBtV3BkRG5uaGNCQ1B6ZDhCYWVEMVdSTUh3aElJ?=
 =?utf-8?B?S3V4bGNCT0ZTdDVhdzUrMlQxcFRXNS9mMHVJUTd1UFdoRm5idHk4cWg2amFm?=
 =?utf-8?B?c0lMK0liV0VEUWxmZVZrWnhuWS93cGNjRWw1TEZEcDNFMlZQZ3dydVlIcE1O?=
 =?utf-8?B?cUliM3ZqWm5OUVg5QzhUdjZqQVFKZGlNMWQ4RkNoZFN5b2VqY2xxNC9PNk56?=
 =?utf-8?B?V3hhVENtMmlYUTlZSTJseTY3emROOEthejFXbWs2NzlpN3hVNUJLbVVUVkl5?=
 =?utf-8?B?cG9mcGRxeTRPSi9BU2hZb3NUVGJ5a3Nnc0d1MWRZZmhhK0I0eW8waHdxeUtn?=
 =?utf-8?B?UVo2WER6c1pSM0pGZlIrZWJ5ZHlLMDhNcXAwVHo4YWc3dU1ndlFkMUdLdjky?=
 =?utf-8?B?M1FzejZ3NlR2WXdlUldWSUx5eDhpeGg5N3lGR0htV0tadEc0Q2VjM2I0WmlG?=
 =?utf-8?B?cEVSSUd6eVdqZGdNMG9sMmM2RVBKd25zcldUaksxa1VHTkdyOUN0ZWFXYkVp?=
 =?utf-8?B?OTdma3ZYNWRMK0ZhS2VubjFIZkNBRXFNL1NkQzgyTWkrdDZVYlNPc21uTmQy?=
 =?utf-8?B?aXRwYm9wMkpjUUY0WkpBbVJ5N2dJN0Fjcy85TS9NeFpFTEZXbkQ3THUxZjhs?=
 =?utf-8?Q?dT96ENzWAqfMiu6cYJh2yuM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tYIUnvCsuC8Y+ST1OV4Sn8TQMWScndP4Ei+7XaaE1UcLMg6fRJLqY/Up2wh1AhOIwcnfLFjC1GKP8emzLwxwOfe/5lG5I29YnFPnQa7uS34vVw16Wr/QNa1+BD/FsnLBKKsdJyYk56jvw1G3fXTij4W64DZwu1Gmw7zYL0iCXr6grERnFUZ/vw4ZPw5sNXWtIHCDlI9Wnhv+F1YNLlWsM3METDfiyhfhl1W2rRwESk1ftcYIYLDIVMaPLHWKjall4E/AcvXJ0+LjRxH1OpwXmyv6aNa3033JZ3E/+Aj9Gq/QTplD0FlCDUgnrZZFRFYWm0XlSznp3gtb/K1AFeZxeiMWTxLgcWHqwedfqvwtUnMO+7ITyHVWXOkML+ZmY7Zy/3Rek+LKFONYInX/ys5EHUkgJG+HUa9H7mesUwqmppDoU8ZJZKmUwwvYLY+cOD91Lp74AhmGQ5PVYf2kKWxWduwams8GZv76dyHuycE32jsuj1KunHbz89kYYzGQUDyWp+23NvduxQxs3hAOkIy3FUiaShm/FHogEUpcKltcv7qDqaxlhpAeSrDPMlyALeN2vvhBCuWOKRwwxTttq3nQXNIolpumLy1MH5HDLyy8SGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ae7aec-81d0-4996-049e-08de0d9c0d2f
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 16:41:42.2699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVMqbucmTk2Ax/TtmWRxrmWOajMqzt3LIprfkGwsm5/PqCVYfkBji2f8GV+QMtdqWlltPY/q7VtO973/k+ZHkxd3Dk+eV19TB4ygrbUIX/6/cVoretMOG+MTzUpACfY6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_06,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170123
X-Proofpoint-GUID: KOYNPd7-nmbqkX88nXcCFNoT0W-ear1E
X-Proofpoint-ORIG-GUID: KOYNPd7-nmbqkX88nXcCFNoT0W-ear1E
X-Authority-Analysis: v=2.4 cv=QfNrf8bv c=1 sm=1 tr=0 ts=68f271ca b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8 a=yPCof4ZbAAAA:8 a=ag1SF4gXAAAA:8
 a=c4Wvi6zCPklzv2hk9rIA:9 a=QEXdDO2ut3YA:10 a=WzC6qhA0u3u7Ye7llzcV:22
 a=Yupwre4RP9_Eg_Bd0iYG:22 cc=ntf awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNyBTYWx0ZWRfX0P9SVq6k48Ss
 YjM9yMsnSemfETvS43v+dy4yxEMFoK6LbvJmOkqU6YZs+Zyi2a1XtkpLGrIN6Mio1z8dQmp9SpK
 XuVTr+IDWl2RUIvYroMQ07IXqeFmnYFWDwRZPI8/ybdjwn6hY2AqoWSqyq1X3oZUVDZB2RmSVcO
 Pcxl30DO1edDvq/okxZ3Qdf2yO+PK9yjgh7etzJYVy3kOyEZIku7ps5lBVOwkIPoI86ja8DYPyG
 +lwbrR5/HkSfFbM1XJjoHezAmaRK5NYfVwIj7ZnSI+fdb85bjQr1bXv7x/jMzA1jHj6Uu0Khoq8
 oXtmdPLeDDXoEYlw1gq5VHGQ68nm6wYSR8sEK3I5DEKKrJMofdTnR4YHLrnpg3S8c8iufYMU9jm
 ibJV9yL2ky9xd9L2kGj+hPpS1h33/RIXnPRBIvmTVATgESRSzPE=

Hi Greg,

On 17/10/25 20:24, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> [ Upstream commit 716f86b523d8ec3c17015ee0b03135c7aa6f2f08 ]
> 
> SRSO_USER_KERNEL_NO denotes whether the CPU is affected by SRSO across
> user/kernel boundaries. Advertise it to guest userspace.
> 
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> Link: https://lore.kernel.org/r/20241202120416.6054-3-bp@kernel.org
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Boris Ostrovsky suggested that we backport this commit to 6.12.y as we
> have commit: 6f0f23ef76be ("KVM: x86: Add IBPB_BRTYPE support") in 6.12.y
> 
> Hi borislav: Can you please ACK before stable maintainers pick this ?
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

^^^ I think we should skip this part after first ---

Also, I haven't yet got ACK from Borislav, so should we defer ?


Thanks,
Harshit

>   arch/x86/kvm/cpuid.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -816,7 +816,7 @@ void kvm_set_cpu_caps(void)
>   		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
>   		F(VERW_CLEAR) |
>   		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
> -		F(WRMSR_XX_BASE_NS)
> +		F(WRMSR_XX_BASE_NS) | F(SRSO_USER_KERNEL_NO)
>   	);
>   
>   	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
> 
> 

