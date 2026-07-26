Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAEE35C1B0
	for <patches@lists.linux.dev>; Sun, 26 Jul 2026 15:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785079323; cv=fail; b=HmEBmsLxXHRbLd8dxerGeT6V+2vxJXwrHJhyOr7cRtZNfJxbIElZPt7GVrdRyrL5xIGqDHWgQabpv3DfmH5xhnRYbifJ8XCkfmeGcLE60sn3JHsemDv+NI8bQuOGvr3jFg7mIPTxKNeMzkaDjk+Qma/CzY0ZBRNJpRdcAH8ITQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785079323; c=relaxed/simple;
	bh=C6HLWGKLJaXMvfwBa8AotnYvDnSPDIgdVO/65+Ug9o0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XnO5LoJJJuBhvP0tzludzAfOO6hmP1AkAD5OTFFuVSB50LJXYuUCISA8e2GL/6K1ZhOeqFrln1TXTqJddUY5fzeVoZ7uTj1TBiVRXiwKfgQs9ofDaxZQ2P1rQMkSNhmUlFW11+892tqye0tSsjl4UIObSVPffYtN+KDyDFOHCdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NaninQ7d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z2R9SunU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NaninQ7d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z2R9SunU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QDt6O94035594;
	Sun, 26 Jul 2026 15:21:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3LPH7K9XgicrNDIKAjhTccsnArY8Mlc8ozNxa8ugXvs=; b=
	NaninQ7d23IoVWRXTk7LAZjBQHfccExmJeiy1/IHrxuczrNAy1pzA+NggThOTYUZ
	WP2Gf0UU1EgG/tjdxRFUPFF5KvM/K7q4TVPyLeh26L8j6ULZz7Xw5gnCyd3RGaKK
	Umk6CDcqN1Ag36+v8qgZ/lYeHzan4axx+tNh72LGzzsUNctqEEtxuEB3SZu0msx0
	JZ7h9EAjbpbJeGf9yfSbJ2De0sU08Bi6IPTeZ4uOvpENGEDAqr0zlRp1EAXU8iAh
	d6yzlS9ABiREfxsh1n+BX2UjFzl3stzKqWjyliVAiFXHChjWLDHCE8MnyB8o2+6b
	XpOCmLhEUbJAilNnKHnwiQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xruak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 15:21:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QFA6O3005154;
	Sun, 26 Jul 2026 15:21:51 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010059.outbound.protection.outlook.com [52.101.85.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh84tx2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 15:21:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h8L0h/ni35vKsaggHElxr26BlQeHKTtmZ7xw57vFAN7uOF3T3qDRJIxQKopR6F8/3elO6u4wdKgR45iXy7C/xmTZRoffSyBv87FHeuVxFtMccqf/IhcJzKR8Xws6Bh/rYPMOmcAJPbTG4XEgEcCv1eonWXZKZG778e13vnacqfbZmeHa80sBh0+6xweBWJYm+NhaBW89TtB8s/OSVBzqizU4tObB2jnH7F/Fo4d5nBIEm9Eka7InMZEssGB1x7LooCOGffRXV6iQwmKECkZL2KoR9eupQT3rULspa233C7hoBjiAqIvwPbM9tbMny8ZnLWq8N++FfUB0oO5rTS/RPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LPH7K9XgicrNDIKAjhTccsnArY8Mlc8ozNxa8ugXvs=;
 b=YdiYpVMi2r/+GR0a5mMLp78Z6LsiEurbilzo8m1HC1gpv7hdZGDJsEPOFohUbfWP8YXEI5EGK3U3Gv4tQ8gf02s4w9kWKNwfSKYYLSzN+hyckuK/sLdolNp3NBjVKvO/3qSnBoJYmgXV+H1TQEyPiToNrqHER9KgQ8T5rPdI7oSHhoCKTpcdV6QEVs9hVPiEMNVRNoudltKOlE419MSHJPUOhaU3pxG0/tLbuPpzdNuIUMD282XAQyHoRV8ZDyBBGGDaAz7qeuU5P+T3MmmA+Jj8gCPdBLx+yX53oeWqO1KkKzgU7083Myv1hfqDjk2QgF1nqH94JR+SlQhU39pNUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LPH7K9XgicrNDIKAjhTccsnArY8Mlc8ozNxa8ugXvs=;
 b=Z2R9SunU1YG9/1PlhVw5VQQP3UG1D6W77QzpiFAXtfYbYFB46D/wb46yuxdvMekwClmgKiuOqr9CLpsP/LXWfLoVuJ02D3hPx3EPyGjg/gsjsWWg/OMSaPG0ry+XzEG/qqYKDQ8mPr6cVMc5HSsLzxQCFBgJV2fgLstNi3FAQew=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA6PR10MB997657.namprd10.prod.outlook.com (2603:10b6:208:5df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 15:21:49 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Sun, 26 Jul 2026
 15:21:48 +0000
Message-ID: <38ffe044-6839-4833-92e4-de64cd946602@oracle.com>
Date: Sun, 26 Jul 2026 20:51:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0178/1276] gpu: host1x: Allow entries in BO caches to
 be freed
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Aaron Kling <webgeek1234@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding
 <treding@nvidia.com>, vegard.nossum@oracle.com
References: <636a3072-c74b-4548-8b4f-c2e07c5bb8b0@oracle.com>
 <20260725192000.stable-0004@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260725192000.stable-0004@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0061.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::21) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA6PR10MB997657:EE_
X-MS-Office365-Filtering-Correlation-Id: fee1144a-27b8-4783-eb4c-08deeb299c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VprXrZoohBsCu6JB372h13/gxhwwFPg4yLYlM/7cajY9SbAdKJrQInESFazqoIQCwWrDfJFHokicb/lalWUUCPW4/14eMdR5JhP5wETMRWbDG3DBCSzAX3GVwQ+XrkxlL7vrrr/HTwUXF5BW3QQUIQH/ueS5A4URxe66iXqHDIvpcjSqDBqkRCxGzSr0MkcVYpnlLNBKBcgKoDvoyPhmdrFLQnHp+koixcoQzFCnBx82yn39QiNJm8NyHf5Kolq67bWDsS1Ocb0YT3/HhtlHd2T39Uf71dLLto3h3FTjp+nESRoou4VHJmMV4AfZXpoXpc3uE3WBvr15rvKyZTGqXKSiRC8d16x7GsOsrC2f5EMTYY9BXjRt0BBEEvsGEsr4K4H77Bpf1S8FDk2MILx6oJElGWSDYsnjC88gs/cfdJjL0WZ/ZmCAIw/boC2p2Y0qsjmdzcexxiVgIqn7/4Cs9EBmjaiWNthGfIW+JKrlKeNfT700x8gaeGSdBSWtoVUsi5yJY3IOYYLY5NPf3qcfSkZMOoyohGMztoTgfP2a7p2Az/OS6t5SUIQmmRnG0nO+OXWi8R7o5NxTZEdSoYq8dTqCV6RRgnHnwXEYqdBUpjvCl9zbmMwb7Ec0GQsrkTgwX9jMSvRUDGSRdPXDiAFnog==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnZ0WUJYdC8vMkVmb3gvSkZYdjViV1FmTTI1RmRqcFU5dEU3QVdCODRldEVs?=
 =?utf-8?B?ajlUMWk0U2x6OHphdkF3djNiczZWaW13Wm5kaEdleXBUL293dWFVNWNvZXJk?=
 =?utf-8?B?dGx0ZWJ4c1I2OTlzRmRzb040STlXcFBVT2wxc29uRmZwOGRCVzFvL2NhdWs4?=
 =?utf-8?B?ZTQ3N1B5bGdiOWh6NkFsVTEwb1RrY1JkRGljcmhlYVZ1ajM2b2hkOWdnMFNt?=
 =?utf-8?B?RVRVcHJmeXBnK2VPYnYzZDhhZU5WSUNEd2RPVkdpdFV5cSttVnhhUXM1MWRi?=
 =?utf-8?B?OStSOFA1SjY0SmVmdmFOQmlKUTBhQ0VmQjJmeHJOTDVVcDRaL01WcXd0dDU2?=
 =?utf-8?B?RlQ4bUhFWk9XSjdtZnd1YjZncWhJcU11YklhTEpwck8wbUtjZ0lPWTYzSklI?=
 =?utf-8?B?TFRIZXcyeXJROHVmQUlmRHhhZC9PZVEwbjJZMjNPVEVKRkxXempvQWh5RXFs?=
 =?utf-8?B?NlFPaWJtY3JGc2hRejdkVlU0czd2ZlEzZk9sM0M2Ni9ZZGJOZ2x2azk1RVJn?=
 =?utf-8?B?dE1xUldYTmJ3SnFraU9WeHRoNFAzR05tSk41QWJUekkrSVJoZVFyM1R5YWNG?=
 =?utf-8?B?WDFpSUlYSVlWVkNLQW5FS2ZDZG95c3FBK2JIcmcvdEF6Qk52bVJuMS8waFpz?=
 =?utf-8?B?RDl3bTltRkFyakMyWUZxZWFrTEJZUXNiRjh6K2Z0eTNRMHByVUFmLzhLdjFM?=
 =?utf-8?B?QXVJOFNuc21HZ2p2SG5KWlBNVm9kMlZhUHVaa0plWlJUSmU2cTkxMU8zRnk5?=
 =?utf-8?B?dW1oUmFBMUZIdllvbnpDbmtrdCtLSklxa0RydmRMcmlqakhlSVdaTExpbERv?=
 =?utf-8?B?SGFaVDRTOVlUdm1oWDEyQU9iRkFVcmt3aVVrVUxJYTlNbHlXOGJtWWcweE1j?=
 =?utf-8?B?THZRWDBCdUZKR3dYaFdRR1FleitndHl1a3VGcEhsZU1kTmk2dVBhYittT3l1?=
 =?utf-8?B?SFpkbnpsUUt3cm1sOHFhdW5Jb3RYc2tnSndiMDR5UGdsMTdwUjYrdmdLK1Bm?=
 =?utf-8?B?WUhzMk5SS1ZQWDFUNkJPV3dDeHloMU9pQkhodVNodDc1bkV0K3J0YTRxOXNK?=
 =?utf-8?B?RWNzVjQxS3N3OE1KWmFYTitXOFYxMmU3akFCYmkwNlA5MFBMdXV6QXhDUXRo?=
 =?utf-8?B?QjcybkJzaFRUbkh4UVM3V3NtTWJ6dVFHdVJtWWJJRnpjaDZTT3F5YzZGNFpI?=
 =?utf-8?B?TjUrUUloMWsvOVhrWXBiRFhYVEdhamxZVXM5VDJ4cHZLckwyQzdNWW56RlZZ?=
 =?utf-8?B?dHBDeTZ0aENmdzMrSXNZdVk5cjRpcElQMEZEd1ovNFRTb3hSUnN0SVU2dkdH?=
 =?utf-8?B?dHdlV01LNjltaitxbjF0V2JVckk5UlFBZER6QytZZDdXcVV1VEJEYzFudTNJ?=
 =?utf-8?B?U2pzNEtnT1ZkVUdMZ2IzdFZORGxOMnZFUG1PN25VVUhyMmhRYmRKb1BtUTZu?=
 =?utf-8?B?NnZLaFRZZHU0dGhUZFozR05Jbzk3RjA3MlBiMCtYQmJZKzhjMlVzVURQV3p0?=
 =?utf-8?B?dzZhekpDSkJUQXczR2VCU3lEelZ5azZueWI5NWtpSHEvT3dQOE5rUmQzc0Nm?=
 =?utf-8?B?WmxMSjRLVmpXZEJSUVk0dHJKOWp3MUtKNnEyNmJrZGE4dU5qM3NnSkIyQ0Zp?=
 =?utf-8?B?Q094TDNUL3QzVHNkMmVlTzhnd0xLNS9YaFQ5VU1ZYzZnU3lYbWh0Slo1YkNQ?=
 =?utf-8?B?OEVCK2ludlNDSDlZOUtQKzZZWkVvYlIzQWJMcWpmQ21JcG4xeVM4Q0hmNEV5?=
 =?utf-8?B?V2FlS3MrSlp4a0s3WXA2RnhERmc5YXZGQmVWZ3R0V2lUcVhYb2xNOGVxbUh3?=
 =?utf-8?B?U2g3c08yUzFKNm41RTdsc1Z1T2EraGFYZWVtbXZmR2ZTOUNpeU9weDlycjdF?=
 =?utf-8?B?SGJGcE9ZRWRQMDN0SG5YZ282ak0rUWs2TWd1QzdmSnhDQmJxbEg0bWg4dmZF?=
 =?utf-8?B?NnVHaWNUVzBsQ0ZHb0E5MmtKU1RocXpZTWNacVhtdkd2K29HdW5rbDNWTVB2?=
 =?utf-8?B?dXRVM25jUUZVdG9rSVorUlg0cTNuRW1nVUpvRHYxM1drZzhPZWdJWXJtWkF1?=
 =?utf-8?B?eUp2c0JCRG8yZXEwZUdRa0loZUl6WXkvSW9PVUtaSlNibVBtajdVcEp3dHdN?=
 =?utf-8?B?Nk9CcWIwVEdFTlJRSEUweCtsRW9mN3dPNHUzeTdnV01YL2haOHpwYlc3K2tE?=
 =?utf-8?B?Z0p1bzVGVXFrd1Z6TWN2ZEo3SExrYUNTeWd5SmFCZGFwWU9EeUF2c1dnUVM4?=
 =?utf-8?B?aXVBREV0WTNBMVNlVFZtZk9ESDJad2JQc1hLSkU2SFlPam1mYUtwRFIxNWwz?=
 =?utf-8?B?NmpveTl5SVVqWU9jT1FIZitzaEpjVnFCR0lMUmRxY1ZVZTVsT21Ja1dickJs?=
 =?utf-8?Q?MBrqVw9xvg+vw3DTtwyTR1lZWZxoc72eVkSQb?=
X-Exchange-RoutingPolicyChecked:
	QO+mjBxEwkAwNPE3g8K9HiTCKtlXMOYBKBByJ3o/jBjTw36Uk+pq+KlmKsr4Y4DeM3w44WD6uWqwFwdW68p3JbhSPI+QD1Vc8QYqt3PpZa5X7PcQDOhbjC21/CKXdM76P++DD2Vae9sWWTqYT5upOH0c0hE+s3jRLQe9woOiRkWhGsFlW8P9KMGKBG5wXpH0rKz0a0Pnmi8qhUmao0Iw1tz0O+Wgi5xdTvxPI+oad92vu0pBH+jyKptd8qq58GfGlxzlpLSML5SHRIKqHNlrFagTeeRFyI/VZ4E2pb8ilA3rqtKefEi0GDCH0il2P8Gg+PgKZQMyPIzoiRhswYB/2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2bno6RYEYb6EwxijSd3HHYq4dSZEGDJML7kx9Y0h3VOi+55DAxKdrTK2EHOTRakumXZHC2ZB3ZBLG8blXkmcTymf/6pYrNUwk9QjG4SSTKr1e72WwADuqrCUoUyQOdKhCEPTNlgZ5lL/IoH10Kk71IcmpPinDN29crCRcvYfp5dArhu5+KBW0sVL8NPdT9vrXeCeiLYDrSXOEXrF5//sYn8SlLsxeceXDe6IG7eZX9PWMX5yjpruYnucEkPEAsxxllSY3Oxt2QHGInyW4/uXY4oNIuSkynEaUFFQIZkj2qJnh5m46pibBCNNp61zSLeue5uy8tuPEbOqb91PZBWkhsXfej/xqevnwiNNH79fKMXN6Lgqun4i9aRGcuRmyIL11SbqJQWgAFG+AmWKT1X9iJ+DBQLvIBCtIFU4ccm/tJEr9EJhsvOmW+CSrDImpJAoo7prqXFAUwG3/dMGJQI8y/kUugbPhJWw86RNj/13zXDIdHc6PuXB9CWyHnGu9bGOIEjlh6Qg/M4jr4pDe8Ps2Gk63NJdcUu+CVq8uCOLq6qj38BdN5/SBLCNQSxQRWkUYbah6O0pt9r52b+8++1tE3p2aQVMlfnYJQBqoFfILzI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee1144a-27b8-4783-eb4c-08deeb299c7b
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 15:21:48.7383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNCJ/rn9RugQB8JdIgZo6GXyVf4sGn9kiwYUI4WmxTVovaXYFaJya4jitsdXBPBFYHE8lSv00EtVErmtpmVkdsoB/xioY2a6tljvQuCUjxdjqUHW+buSyV+8/noQ4Lhv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR10MB997657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607260154
X-Proofpoint-ORIG-GUID: WV354BILQuiQF6DzLFbfEeo-R2qEl8fd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE1NSBTYWx0ZWRfXxrX7vUNZ1gg7
 /zKm5I6g69FEgi8R6B3AFrvIEPzxt/g+QFa5g34gOSmxpa+pkbbQ42iEOiNA4nzRvOFjYIiuQrc
 M+lODNrSKGUHhxZG7/0PB2VqzL0JTdi49yrx2/LVjdJdPtJZ9F8k8fwpVbUVVowgcwnZHNiN8OL
 LzHXmokQ4kICfT96J2F+0GQm3BGPhEFs/ZX6dIt4luF/Va2uC1uNn3iRL9zZoAZ7oREA9d75GB0
 3YFtZxGzPyWBHms1j4u/jX5rq6JXI6LmX1XHZHHPEYoo4gZtpWlSGfm5qBgX+iRfHOYKVLj5Y/1
 NM8fnmA//B4/dkx84aFJ17ZBmi3P8s/1+cOVQfzHnVQyNF3mDyQSppRNIa3hVa8Woy+f8S452lz
 9Ifjlgr+pz42rCwZ+6vV2gx2DHS75x+Ca0ucuQrYGO9HEYY6rWuw7mJl+xBFqg0bkXxN9VxWMlW
 xEwWtR0La3ZBlSv4y3Q==
X-Proofpoint-GUID: WV354BILQuiQF6DzLFbfEeo-R2qEl8fd
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a66260f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=JqS69ESxJ3k8wMqtjRsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE1NSBTYWx0ZWRfX+yIOcT5UQZWC
 H7t557/4sBAEWe3S5lpfAumcJMly02+p4RDFdS6Rmc9IxR1Ihef7rbBGSN7KfhJ6ortN6j1tikC
 W5BQd94bvrQU00I/cXclEcvBomoEOpzIxSt17Pj7ymDuKORxbXyz

Hi Sasha,

On 26/07/26 5:34 pm, Sasha Levin wrote:
>> I think 6.12.y should take both 266cddf7bd0f and f8c9c57d7503 before
>> release, both of them clean cherry-pick and build okay, so should we
>> take them ?
> 
> Good catch. Queued the use-after-free fix 266cddf7bd0f ahead of the
> cache-freeing patch for 7.1, 6.18, 6.12, 6.6, and 6.1; the crypto/tegra
> companion f8c9c57d7503 goes only where the tegra-se driver is present
> (7.1, 6.18, 6.12), thanks.
> 

Agreed, thanks!

Harshit
