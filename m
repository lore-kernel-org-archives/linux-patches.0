Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1832F1D1506
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 20:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729540924; cv=fail; b=K6NjsbxjAx+iRpFto/aSMm5EawwYWgpNlExeMTMzdK+ezGa92JvC3dcpX2JZsnVXDh087xqBrTIKjEAR5XvLPQ0AO5bMqIQl4sGnWKGASbBYw4sjdo9CpvV+1ujNs0Pe4xq3ZW1nZmTO2ap0w0MRdR+wGztUA0tIsPNMYTQajYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729540924; c=relaxed/simple;
	bh=07mfuOqkHXEjTmQe+lSNYFMyfP1b5QWXmaxPRi6LMqE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y06EyYgWLjtpoW1MRr+UmJBQEdvcUUvLqPBiPbMCevMc/qUrLY1U80PzSNnWu2q67scxI7AmmhsiEaqiJpocmnQs14sbYbEVyeLonASvCY+G9FOu5ef1RclLVrU6/fVILfEqgoDfS26ryMobzUX6yNhdLAECabVk/DlQ6+TbXHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NcoX6RQy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fvfLwjrK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NcoX6RQy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fvfLwjrK"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49LJBdSR023217;
	Mon, 21 Oct 2024 20:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kQ3f0uxWraK2xxe7o1l3qDCPKyoLdhzHS0ibV1ru5Gs=; b=
	NcoX6RQy0F7ThsUaZqOucs0SSp++8ugqetH8wTjv9Hk5UmxuaNgPqiAIZoVmjG9t
	LOhPnHCnIOoZP1s51JwwXRHmjLgJApI5fUpSvYVihh/nwODeK5SAMzsUFW1X9mrl
	6C+dth3eFbHEPLm+KuifS5ngvYpgv3TrM3XhvCDWkF3YHhMGMoZbtc9AUAvM7ePo
	3DzyXW8h/5vlWtqPI1y6mKOs2sO8vGEeXsbG0+/kfHQX9fDGF0m1HuqGEZrNYCsv
	2NcLol+TS1JoV+3mCLu+AoU5LJSqMS9Hgkhhbla84AY+2cAVho6Hyp25UpRBGQex
	hoYxUNSoLZWl5R68Gi6IhA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55ec0g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 20:01:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49LIK5EN026212;
	Mon, 21 Oct 2024 20:01:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42c376stxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 20:01:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wLrJWbrd1UIHqoTSukSvSisbuB8QB/WgPSYohnL13qQdY0nSLuOj95OL0BViWcM5chNhxNG2D/aPZeJOeKe126TkePZ978IGMiVuXDBOoE7mrxh6gVGbZGDdE0oTqjMfAC/GV38K/IlJTi/OYFAMp1hFbd0XLuAAhs94FmhYZJtuM5KWppCwgmqR+PFbtMquVcKlHrz6YuY3gwJQHRT83O3J9UIkckx3psnSXVtY/iHNfAJ71qVYvndU+Wa+1mo8fUu2yf1JxF9alyn8DMlys8d1NRZXz7GW/KdNlx9ZJWFonJwen+5rvUvRohUHxLke44jjVvY1/XoO1YbjG22XxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQ3f0uxWraK2xxe7o1l3qDCPKyoLdhzHS0ibV1ru5Gs=;
 b=IbQ8oBEMmsOabtDuOrgnV1YI7x92fbDxpTSZ4NHaB8bvBBQXYK3NQqTtMPfj/ZmEWmpA+g/hmqTfz5p6crpklGN/ANb/BYLEx6ue5fR6z4+OvWZmlVjgk3S19fXUk4XKr79x82KA6mgc5P8ukDZABEWKAhYvuS05/8AY/cnODEGjVeQktXvsVUZsn/ZDyKODN9UN/IPIBQcw/ytH1Q7m40DoVMjxa/3SYbMIpLWnaAUC52SZhIliTiV8VCO2U8Cwrc9l94CX7TeVjt/Bb3hWoKNExxn8GRWATeDmh4m/aLFAz1VZmdXuaigWEtvQvjPYbcJ4cN/qL+W5W5PViGQdJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ3f0uxWraK2xxe7o1l3qDCPKyoLdhzHS0ibV1ru5Gs=;
 b=fvfLwjrKNbzYStEszOyMBX6C5E0JMVkA8MGWWgPSLK82p6vjhoTNm0H/9jQ1KvG0J/1Y8pbS3uWWJk18+DapxVKnQ3GDObIDMZa/GoiZFbjAOLfITc1T36FacdLel0xRudsep1XCWxLdKat59DUPVu05swWEnlWh+tZ4vr19TUw=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SA1PR10MB7553.namprd10.prod.outlook.com (2603:10b6:806:376::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Mon, 21 Oct
 2024 20:01:35 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.8069.016; Mon, 21 Oct 2024
 20:01:35 +0000
Message-ID: <34018e9e-08f6-408b-9e14-b35f1ee580f9@oracle.com>
Date: Tue, 22 Oct 2024 01:31:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/82] 5.15.169-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241021102247.209765070@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0034.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::17) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SA1PR10MB7553:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ef4c629-9c84-410f-f912-08dcf20b2a43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZHdRcjBkbWwrL0JUNmh5TEhQbStLc251YlQwTDZSeG9TNVJwRk9EZnpkZW9N?=
 =?utf-8?B?M3pkb2RhS2cxbjJQektlK0tVTXMrUnNIRlRMYXFManJMZG9LQkxDbmpjb0NR?=
 =?utf-8?B?Q3piRko0Sjh3K3R0ck5XNDY2Ykk2cFNINlFtd0E2Y0Z6MXh2RDBLeVdwdlVI?=
 =?utf-8?B?MmpvOVFoMDJpUG94bWFxVE1wVWRrRm8xbC8xcmtxWlBVazgrUVBhODkzdkt4?=
 =?utf-8?B?em5DaHp2TStXODhDT2ZZb2JESWVUVUZGOWtYVit6OHVIdXBUWXZHdW1pKzAr?=
 =?utf-8?B?dGdZa2U3Nm9kVDltaUZvREJXZ2wyMmRCdXBwUytWNFptczRKRXZ1MGw5Ylpk?=
 =?utf-8?B?L2k2NTRJOU9HemhhRTc2NGo1cHVjcVAvK3BLaG9XWHRQMnBVZVlFamcwekpL?=
 =?utf-8?B?ck9aOGJhanhObEFpbXQxa013QkNrSGlzTUIrazNFcHdBYnpub3dsenVBTVNn?=
 =?utf-8?B?bUl0U0JrdEFqUEFIR1A5VXBUdlo2cHZLb25HRGZoeGJpS3pFb21RRjNocFpZ?=
 =?utf-8?B?YWVkUlJMMjFZQWtTZXZ2TGNKU2RSQTZ4WUpERVFlbVJvY0VmQnNSS0prRFFj?=
 =?utf-8?B?Sk9zQUlzTWV6eVlBby9QZUlQWURHM2VBeXRhSFVONG1YVFJvZk1LOFdNbzMz?=
 =?utf-8?B?VVp2YnBRWWhqcVdGak04VWlDbHFYK0Jvdk1uSmw3ZnhrdmY1WDZTNzFpaUlE?=
 =?utf-8?B?dnpCS0xRTFZLVzJjRDUvOHNYUmIwd1haOWp3VklDamJUZVVLMXRTR3ZtNkw5?=
 =?utf-8?B?ZnMzOUNpUjFWL3VHenVQcUNLQUFYSTROVVUvTUlYS0hXWHFvdEZia0dDZmdn?=
 =?utf-8?B?ZzN2UmQ0V3VoUHRVaDc2cXd3OUZ6SDBRbjd6c0hvRjM5eXhsZmU0aXFoK0Ns?=
 =?utf-8?B?OVY3bUc5MUd1ZFZXcW1VeisyUGg3OW03d0JNVGRGdFA2UVVtaitxalUzV1NS?=
 =?utf-8?B?dGtyWGtNdkdvd1d6Zi9xNkhiL1lZeXRiY1lGMjkzYXQyd29MaW1meitSY2Jq?=
 =?utf-8?B?clpWMWlXMWt5TjFlOFVyNWZNTVFsa3h2aXZqdlZYelI1Nk5xVXBDeUl4bFR3?=
 =?utf-8?B?THRkWGV5MTM1TU9ob05xdlZuRGVQQ0FDQWxHSStpNEFaam5IaWVIUjd6dlo2?=
 =?utf-8?B?bmZZS2huaXlQQUoxRmlqUE5aM2NzNUh0TWlpN21WdTdvZGkxSHVsUUNzUXdC?=
 =?utf-8?B?UFZxeFhhOFdObWExSXhyWUdMYkovay9Gc3BjQWpPSlJTSkVhUDB5TlI1cHh3?=
 =?utf-8?B?U1lISzhXN0tSMXgzbWFnT2xIaGdYazBFRnhqYVBPaGpSdEdMTDJGUEFBbnpT?=
 =?utf-8?B?aEp1K1Njc1VPYmJibHh3eWJ5LytSVnVFRDRlTXo2SnVTekpHWGtBcHFJTXNI?=
 =?utf-8?B?eHU5bkV6S0NLODV4RS83RHRrYi82Q2pPZXNqa1crVmNaUjRMcmNZdWxSNFln?=
 =?utf-8?B?Z3crQlc1SHRGZmJuUnh3VEwybHp5dkptM2ZZTWQ1UnlXa3A0eUdJRndtKzRT?=
 =?utf-8?B?Q3RDTXUxU05xMGpOYzFac2NpMXJ0cStYbXd1UGhlYUhWNmVia2V4ZWZJSm1M?=
 =?utf-8?B?Z3dXMXJlcTlTQ21KRGJGTVFHV0pDYXQwdkRHTXdVbXJ0SUhZQlRLVTNUcXpU?=
 =?utf-8?B?ZWhUaWxVNnBVeFd1dVk5UE1FK0tvdC9paGtLQkVSREpGakdnZkV3SEY0Nklh?=
 =?utf-8?B?SDlUT0NXRWhnZlVRb1pnZTR2b0trZnR0ZUt4MjdkSWExUEZYeHdReTRCWmZV?=
 =?utf-8?Q?3DIx2B76E02Oir7hDGLGEUPw8MbgWHEfKiWwitz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NStMdFRVRjc3RlF0dmVFV1U2WjdSSnlta2hJWHJGU1UwYzY2c2VNdjh5aDFz?=
 =?utf-8?B?emlZanVkK1libk4vVnlFN2tGbE81aHBQZ2swUDdZTEtHM0psZVlydHVMcTBG?=
 =?utf-8?B?Qmx6K2pzUU1DSnBWcFB2aFFqczdPdW1rZHpURHZJUXplU0Y3RWZ0dHZRaGRO?=
 =?utf-8?B?TVBSK25PR054VmpyenQyVDJiVk5NS2dWUENEMWZ5NUJMQlM5L1hNQUZ1b3B4?=
 =?utf-8?B?Y3FzYm5ZQTdCV3plMnRzNWo1aW9PblVQTnpHT1gzbWFNYUV0Um1URDU4QU1W?=
 =?utf-8?B?VEV3azVlSVlJQlhOUUcrbk9NWXVwWTh2Umh2c0hpenFlUmljM3MzYmNVQ3g0?=
 =?utf-8?B?UHEzamJIY3YxQTRTY0lrYUlvMC9wV1ZDUHNWeVlid0x0M0x3WHRDS25VT0F6?=
 =?utf-8?B?K1pDN0M0SDN5eDFKZGdTaHVRRlJNbmMyNEFFNlRBeUMxb0hScWpDN0Vld1Bn?=
 =?utf-8?B?ajB5MjFNYXl5RGZEQS9QSlBEb1lpMU00cVQxQ2ZWdWxhM2JiR1lZTzZDaUsv?=
 =?utf-8?B?bHZoNGZPem00T2ZOS2Z5dEVXbXBmZWpkNkpzVEhiWC9OYnI0S3R2QVZCSHlh?=
 =?utf-8?B?bUd5TWxBb2tnWFdTaGRqb3VNQlRURWc0T0liTTB2cmNlcDhrdStweVVOamsy?=
 =?utf-8?B?T0hRbEViZDdlL0JWOEVOSmZ3aEYxYXhwb2RkSi9rRFkrZVlWWGhBbml0SWdo?=
 =?utf-8?B?cVptS2hzS1dDakVsYTZtN3pZdG9DWjY3SEdzbFZqa2xJc2JjS1dUUlJMMHA2?=
 =?utf-8?B?TXNzR3NYNjNiTi9KNzhCbkZTMGxramJ0UGc1WUFBSUpRRm9QcXNsek9iaDhs?=
 =?utf-8?B?ZFpORHZTdWxnNHZlS0xUbVhveUczTGtIYVdGOThOSHlIR21VUk5rTlZaek8z?=
 =?utf-8?B?a1NKSnhsR0lIOGZNVGdKWWVORHNJTUJaQ1lnd2RzNWxoaTZkemFWL1JvSlZF?=
 =?utf-8?B?M3gwK0FaMzUrZVRZdmpscXBqOGhld2VCQ2VLOVUwZTlPRXB1TGgyZEpKbHJp?=
 =?utf-8?B?SGZ4OUIvSGE4eVZkQVR1OFAwdy9sU09EbUpUV3Nkb3M0MXNrY0p0V0dNeFJL?=
 =?utf-8?B?T2dKdVlRMERzUkVES0JJZ243K2ZoQ2VuVmJocTA1YkNWVWpNYzFUQ204TmxL?=
 =?utf-8?B?T0U5aVhDZlp4YldaWWNPSEV2WVNaVWdjYXBTbDRHL3RjR0gxY1Q5cGlqZVdW?=
 =?utf-8?B?V3BtY04zUlhVdjVYQkUwd2pFN2dZWFM0K1dDaUlqbm1vV2lqYmVaWEkvRXpk?=
 =?utf-8?B?Zno1dFUrdm45cWk0SzJvRjhaR0lQelNPMlIza0JsK0VSaVRwYjR6aTNpSXVT?=
 =?utf-8?B?TzEzTUtZMndxQjN4ZXdzeFZjWDc4ejRUcXBOaGNJZjZ3RWlwdHdwZlB0TDBx?=
 =?utf-8?B?VSt4a3RLK3VYS0VpNStuYUhxdW14dXoyaGFETG9raE4xTmVHN1BUL2w4WHFW?=
 =?utf-8?B?UHczWmZFVVlVNmdQSlh6K3RlMGw5SnBubU10TDZDb2p6aHV5S0ZGMVB4ZUcx?=
 =?utf-8?B?d1ptZmtRRkhjMWNhS1pDWXN0RE9odEtqZlNHSmRmNldWcGkvVG5YZTNlbEhw?=
 =?utf-8?B?M1dzMkZNSzZWRXRnSzFXV2wreGdFSkJUNGNCOXEyUGh5Q1JoZnNTZjFXdGVT?=
 =?utf-8?B?ZU00NmJXQ0RuTVRmUUQ1MFd3YkwwcHFKKzZzSWxLbTVGbVBCTVZscEw1Zktk?=
 =?utf-8?B?anpYdU1RYlVmNDVTVUtSUVpxMWdOT2t3MzNxTVdXN0wxVTVOa2h5YlZzVmNu?=
 =?utf-8?B?dis1alpPb0hCMGNZSHpqb1RTOGptWi9oZ0tuMHhwT09pbmhDRkJ2b0ZzK2Zp?=
 =?utf-8?B?V1UvYkpBODBaRk1CMXBidVVWamd3RmJIODJocWxYMWdSZnNJL0FBVExud3VY?=
 =?utf-8?B?SXM0WGoyL3BaMzFMdStmbVU5ZWsweTJoYU1YbmJPbjljTUk3eDlrM2s1NDZQ?=
 =?utf-8?B?bnpmVklvbVNNaWdxY3ArTS8xWU55WkRWbWY0bGtOOG1SUEZYeDlHUnhHYlpK?=
 =?utf-8?B?bHlBemU1UGxoMHJYemZvQWFGWUVXdFAyMEd6Y1JNZkxqR1BKdzQ5M2s3Zlhq?=
 =?utf-8?B?aWs4U3ZCMzR0YVhkVFh0T05Bb3k4dG15UWhiYWdRa3BqZWErRllnUXpXQXFl?=
 =?utf-8?B?TnZnYnkvN0F1enA2VHljRVk0SklKMU5qUDhhN2huejdZVWZNRThIN1krNHFN?=
 =?utf-8?Q?Ljy0w5VGw77M1c7HFm8vZBA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	osc72+8YpMJMA+yGvHAxQs844w+1+RvDa4gT8FZcLqHCDjCaj7d37X5ueEKNTlmxufSaJZPOf/I0qyAKeeibW7W7Y43m4f10HmYjmIDiYjiHQDsZ3RYzkImYs9ATD2VIDeJL0WDtN0s4HvEHcoWBPPVBG4ndKS2MhQljmYY1lsofTFk3V+MupyGtBiL2480EjIE3PVjEBs5zS4gJioE5OWEVegOLqJ8JejwgauNJE4IelJEIVJlUXNIVJqIxgqfaGX0NanxBao3/nsWERAuQnXVh6jUq063xk6pZ28aflUcZYaMFGAM6PJrWCAAb3NZpR7Ain+x3MOmjlLeMmmMGr72dz8nOL5jI2hf7LPDb6NCZtrQmOhkQ5wtXPN50LJ2PxLBoQeBumhEwQM7tqlujqbHXqH198TD+uT/7E47S/O5/gIzyS/37S7JG4LjdW401/SRKQDfnBcqlF88cY+oNiohsv8P5BMhw55hVCd+dPDuyuYQaWhpjhwgYIWy8FKSslkftudQLa/1sutrZjhVo3nCbuw1sjM3Hz71uavQXR09OiGvro/PbA9tJhxYyWp54EV0nwFPvNxneAHZURklf2MUqOBcV3ZytVTtBk81dOm8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef4c629-9c84-410f-f912-08dcf20b2a43
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 20:01:35.0613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VYRn71cjjQ3NPYuY8ZtoWSsij03rvM2ibMRknETw/OfIK390rJWAtdE6TGjNhjy2/DnJLjjKBW2iL4SK/aU89uwB3wO3x//J6HIhYzS4PRMgamrgoqVt+rKT/qX6ixWk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-21_19,2024-10-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410210144
X-Proofpoint-ORIG-GUID: Tq_lo99i03zgpLofiQv0K3GtS_5jle7m
X-Proofpoint-GUID: Tq_lo99i03zgpLofiQv0K3GtS_5jle7m

Hi Greg,

On 21/10/24 15:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.169 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
