Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0081D88C1
	for <patches@lists.linux.dev>; Sun,  2 Feb 2025 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738503045; cv=fail; b=eTks6NwpardmocZ/FBSJMnE/QJMTL99SezI+97LsLlem3SQStcNWyXg1398zlbKB0+bm1k18EznRIZD4KR2uegi1/jhgoBxcfKithCa6uB4R98Ee8o86bpgMSqSAc6I7MhPYATAx9XfDem9Bbn8HcqxTiIek+W6Z1+Nmp21pcuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738503045; c=relaxed/simple;
	bh=SXbdLcbsBlsbW8Bp/tZ9HlCoWdzs4qL/IUlDbaxYQCQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QsdlwaAwx9aL8b5JUFEtTLqHxKwfYPNFwmfkbtkVEQ2q+qUWOIb/wiy5J/VK1G3RM3CR/1pYThXy6E7Lr1pNfa49tqIR4FGPG6YtMr1letq3YIYzftc6h95hYgYn/qST+Ep9jj2uLWUQOfJZgniJpmi9wOSaLJIjS8SAPXQS6O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cJeOBVIC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LKHzrmwq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cJeOBVIC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LKHzrmwq"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512Cuwc9007922;
	Sun, 2 Feb 2025 13:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=rFiJ6NDLuAG57D0W2pEFw3qT1r4Ihy02BrHnqUoy8wU=; b=
	cJeOBVICWZUKVi0Fx8xLspeb2DZz1SfaFSXTivlLJjR9+krnr9gg/v72d+4ICm9g
	rhvDZ0o1ngStKHAPRLTYYoKHKXJHI8hJvjXky8m9aA/cOarv+5v0mL36C4zoY87V
	1M+FE0zfCqVgHwj8ETV2FPgD9LrR5odGv9tSoT1wtfdGMgnSVYfne+9vuVICTkPN
	CF+mK6i85u+yLnvRgSEsmhd1Rd2nU45/VtJHd3Xjj6NH+JKnaWVai6lPQ+lvL0rz
	8bSdluGPN4AFzek9Rx3zDghLTQs5ka+/rkbtuA90/DSr/CWnxbushFSp2z0ZAYxn
	xPeCVffMO0t/uxY384aj1g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhjts1ga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Feb 2025 13:30:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 512C6UPv031271;
	Sun, 2 Feb 2025 13:30:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8dj13xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Feb 2025 13:30:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E4HJS89sGFlc/MlJa6PWwQJMgwPypXIOvwRVz8IeeUfk96TUsKiUNi3oz4D2rYTWAce/Xfma+H2vo4aHihQn/rG6SY6BEmbp04srcmzpHN1wTNqorLgKhYQuMnMy3piEow88S1OtgGiJ3Pi8exevl7BEIQKp27mB/piA73NitIAt/cQsztIbEQho+fw/092PKkWnLA6CYuzvtRC9kQ32kamhXj3c5+ZZz4NkaXXz5wXEGBGJDHs5DECMnwvcxr+AIeL09NHUbfka8XReRAAx8RHYlrCtcfcQx4yzzckSjxm6Lae9rOcgX0Hki1GTJN1NC31v9V0MukNb1GF1rRoHZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFiJ6NDLuAG57D0W2pEFw3qT1r4Ihy02BrHnqUoy8wU=;
 b=g7OZ4XhUHi/3SZdvXb+GVl+9cjPuLOjYqYiuqz7SASNOblZC9V7r/oiTVDBbosOS4+l9JOv/dc4MFMve6H/WOuhmzfFPtlpZusc+wN07gfTivcRNjpc39/BMaLFCVeXXtsuxYX4KIFicT06WeGWTZ9T3oc7No82dXKd1BmNtH/ngCSvG/Ab5tcoXHJRuW5HycsVkhmvRyEEHID/snIpqxwdl1BAGH3hpzbc7Udn2BUluWIHkh/IyVFg+BnJYjX4rdV6OOCD8ajItQ+ZJ/oEtW4HiI3seIokBnrYX3zPovTd+Ntae/eQdyaLHlImMOHp/aLeLaLYV3tU/rkn2wLdPEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFiJ6NDLuAG57D0W2pEFw3qT1r4Ihy02BrHnqUoy8wU=;
 b=LKHzrmwq2aPfeXIJO1OqUdjs0Lz66ISPi0UPWmel7tMJE2KUS4AP0cHLAnczdsizBlfe2POLoQV5cqcrxd5V714x9PTlaVelXITv18Lvc9++qiP+loPqvjNy+O3BzQlzuVqz3PTO49cMdGCeXhSL4tVtI1PeA+yRu7bMtZOPPus=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by IA0PR10MB7381.namprd10.prod.outlook.com (2603:10b6:208:442::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Sun, 2 Feb
 2025 13:30:23 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8398.021; Sun, 2 Feb 2025
 13:30:23 +0000
Message-ID: <201c21d9-d917-4d3f-8d11-7b9d04f8723f@oracle.com>
Date: Sun, 2 Feb 2025 19:00:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/43] 6.6.75-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250130133458.903274626@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::16) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|IA0PR10MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: 13251844-ecd2-4914-f370-08dd438dbf48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0pMMTQ0NG1VVEZ4dFBjWW8yY25TOXVqZUtpNXlGeHlKMWU4UjhsbUZJMCtm?=
 =?utf-8?B?cFBvamY2MmlQZ0FyQnFnUlBCTUhRQlZJMVR0cDVzdGY3dWhoNkl6WWdiQ25B?=
 =?utf-8?B?S1MzNnlUdHNmeVRSZnhyUHJxVmtiTkdIUncrbkJPYlUzSEw2T3RBaUtBMjhh?=
 =?utf-8?B?NXZkRlRiRitldVd6QzRLdHpjS2NhMytWRFpqVWhuTEJVZkVIOG8vZC9nYW5Z?=
 =?utf-8?B?eVg5c0Q4VjZHZlZ0blltcEhUUkJ5TnNESHJuUUlhTTdTUmpCbStSOTBDelh5?=
 =?utf-8?B?N2RXYUlpa1hhN284blFzQXo1K2Rtd1ArUTJLVjk3M0c1L2FENThRODkvVmxG?=
 =?utf-8?B?RkNLb0IwS0NzQUtZeEkrSVpYL2gyTzNVVmpGeVVsRnJUQkttWlNzN1htUlh4?=
 =?utf-8?B?NjgydVNNNWVXbGNYV1pqRzhTUEYzYVJyR01pUDQxSzVnSWN3clV1b0IyZ0lt?=
 =?utf-8?B?VndNMFJHUnZIakFheWRjS3pmdTQxemZ4QjY3ck9NcWFmNHNJOGphU2FZSjA2?=
 =?utf-8?B?UUZ5L2ZUMEwvaDNnUHBtOEN3Qm05cG1WNDQxdWRUVXZsSlV4cmg1SU52U1Za?=
 =?utf-8?B?aVgyR0VyRkxTZjhMSC9xSjhSRU9lL0Z3cmwyb0ovSVNsT0ptVEFQcnNDOHlN?=
 =?utf-8?B?MVpCMGRuYUdscllrTzF0WFFnS2FsR2RSbEdBMTlRYk1UbDZuc1JHd3RZbDlX?=
 =?utf-8?B?NEhrTXFVUXFPNWo2SVFGS29Pc01xNDY1eWpKNzRWaWpkNytXc0ZRODhDa3VI?=
 =?utf-8?B?amJuRE5Od2NFMWVzUnA4T2pYR1N0SE1jcXhSV0NuU2ZIb0dSNis4YWhqN3FQ?=
 =?utf-8?B?WmhHeEpSQjB1UzNqWG5JTlhpdERHa0pyTkxscU45bzRkZ2w0OUg5ZzVrY1FL?=
 =?utf-8?B?Y3pyWXVXSUY3WTI4LzF4YUFFS0d2akdsK0svZWlHSDZ6d0hycmVlZkQ3eER6?=
 =?utf-8?B?WjZVL2NMVVBpTGZZVmt3clFIcUE0NkxVTEt2TzBuKzcyS20wQysrc1JFcnFQ?=
 =?utf-8?B?SWdEU0dHZEFJVHI2Q2RNazZ0VmozakZITUJNUk94aDc5VHZaby9IUWhiekhK?=
 =?utf-8?B?cnFwT041RVRuUGtlMmdlR2VvK1Z2L3gvTFhOZUtnaDRXTGp0bllGMVU0UzJO?=
 =?utf-8?B?V3h0OXRQeC9kYk0xcllvYWxzUk93NnE4RkVRTHR2OHFpVlJYeDc1bklDSE00?=
 =?utf-8?B?VSs1Q2xvM1MwczArVzk0dGUycWZUR1loRWg2UHQ2RmpSRldOYkU0dHRwYTFX?=
 =?utf-8?B?TUtwY0hKVzlhU1NtYW1qUU9vTGZGSVYyVG85NlNjcmx5U1N1d2szbjJtREND?=
 =?utf-8?B?eTFRT3BMQ0QzRmV6WnhjSGMrQkVaVXdtTUk1UXFDMVRGQWhSV1hLWDdNOW02?=
 =?utf-8?B?U3ZNYUxFOExwY1ZDSUozQ1Vldkwza0hxMDBRd20yTlFMeEhKVzh3aEhCRHp1?=
 =?utf-8?B?cWw3UXhXTWpOZk91dzRyRDMxUFJXWUVSWER4YzgvajVPaWg3OUVSS1ZwZnNp?=
 =?utf-8?B?VE5Md1FMZ0FuU1dIcWhaaHlwR1RoejRRVzdqWXdSLzJmMlVLM2hsVS94MXFW?=
 =?utf-8?B?eVVIWGl0eE5aMmJCcjV1ZWd6L0xXb210NzlSSXIxWVBQa0RueGRHMVhiQTlx?=
 =?utf-8?B?ZDA4TjVyOGxGdXlkY1R5clV6U09POStEZk9scCtFeWZORkR6NXJQcGtoaG04?=
 =?utf-8?B?U2FqQU9Jd3BaZ053ZXd6VDBhVXR6RW8rUFhhTUh6S1ROcVhVV0hyT0h3Nnk3?=
 =?utf-8?B?OUMrdE92QUduakgzd3BGOEpOTlQwVTV5RVRoQ1F1b0E2Rmd2WDh6bThCTmsv?=
 =?utf-8?B?WWlJajRKUzNhMXFyam5tVm5oQ3lqb2FOaStjNnBvdDJUTWVkZkdOK1BOWW5D?=
 =?utf-8?Q?/LcbETnL9Kb/h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHltRXppcVN1UlVBTTRKRWl1dURQd3Qrdjl1dEFIQjBrQXI4MnhJeXJsdjFF?=
 =?utf-8?B?STNneTdBbTlIM1g2S2NpNXhPbHZmTjkycVIxMjQvZUU5Sm5rNHVzVzIxRk0z?=
 =?utf-8?B?R3pRempRZk1KU25vS29IR2Z1OHp1WEMxRWJmT3l5MGZOWm1GZ1lhSTBEQ3dM?=
 =?utf-8?B?YTJIMEx6ZllKZUl3SFlMTDcwRTV6WmkvcUdjZmVYUnI4L2RwdmlxTDFTR25x?=
 =?utf-8?B?cDZtRUdHS0hpRngydk1jYUFsWmFxR2RBcTB1eHJ0ZGlWZHdnaXNPaUpQM1FO?=
 =?utf-8?B?emlKRFIyMFJETzlXSkNNTkNVTms1Yzc1bGpjWk5PQWxXNkxSSkxIRmc3V3Ru?=
 =?utf-8?B?dTlmR3o2R0xtV0xzT1lGUzQ5NXdvd2Fsd3BUQUNlSXJ6WHZzdnBXUTZBYmtQ?=
 =?utf-8?B?YU52dithMWVrUVNyMzJUbHJFTDdPdWJwQ0hWRGFMbWlyK3ZpWFlCNDFCK2Ji?=
 =?utf-8?B?b0pYTE9uYUp4bWdmbmhaRUllZWs1VXdta1dsV3QvaDhoWHFvMDM4aDdrSk1W?=
 =?utf-8?B?RVVxYzVmbC9ZOEhNNEg4anQvMWZXRU1DQ3U0a2NJbmY2anBjTDJPWDR5R0Rh?=
 =?utf-8?B?em1CcmJZQkZGT2hJKzd5S0NRSEZYc282dzNpbkhzMUFuRWwrZzBFMWtjdXps?=
 =?utf-8?B?RC8rN1ZVMUE5QktlQmMxaUJUNUVlcHBvM0EraFpQWE9lUEVzVUs5NUxqaHpm?=
 =?utf-8?B?M21tZGpIK3N4OVpJaUxKOEQ2eGpua2ZDZzNteHdlNHpvOERWeVJQODJYcWx3?=
 =?utf-8?B?Q3k1YUdITEZ5dStKVVRWaUphTG1QWUdkeWxlaHc3bmN0cXJMVFdtaFZzMHEx?=
 =?utf-8?B?UExoRS9wUU9TRGZqMXB0NnBZQzd0U2dHRFhHbll5aWhQMFZWSENCVm5WNlFK?=
 =?utf-8?B?SWh1eVowcldkYWo5N0o0cytVL3BoL1hKMkdlV1VJSnpXUW43T0x4Zjg5RlV5?=
 =?utf-8?B?Qk9pRUFsR2N1aUpVY1Q0RGdXT3BCWjhobThVR1JmVWM0RWZVcHBUcXoxYmhW?=
 =?utf-8?B?S0I0b3kwSTdvcmhVK0UxUTBiSXBTZ2VDS2RJVFpRZStBZVVqTTlrUmdpdVkr?=
 =?utf-8?B?MW9TbUdldmpxdG9hSkhIRStTR0pMa2tMRlNlLy9ZYW1CRUMzN3V2NmVhNXN1?=
 =?utf-8?B?N1IxcVkweFFBMnAwWlVIYTU1T3hhem5kUmVYWmlvRzgxcmNNdmk0c200L0RS?=
 =?utf-8?B?N2Z6VllRTngzcERqeDFjNUFSaFozQ1lMeENLT0oxK25QbnpQUlJzcGJMNXV2?=
 =?utf-8?B?QklLOVBXUUZXeUl5OHZBM1hDK2E0V3RFNDhKLzA1ZXJBOFBid05LL2FnVXBG?=
 =?utf-8?B?QldhV095Z2FOeG0zT3VRSXdJRnJKNVlLSno5U0UwanZxL3VDWjhHMWRnZWNy?=
 =?utf-8?B?K1pSRm1BdTZTbGI2MUhLOUZkZTYreEQxeVRJOGFNNWhzZ0c1M0oyUG1jVkE2?=
 =?utf-8?B?NUxCank2MW8xQTg2WUZDbzVWN3lBS2t1dldmc1p1NDE0NG1RT3Rhb2JaRUJp?=
 =?utf-8?B?M09la2taWHRPb25RTEhGNWc2TnBlODhKWi9hV0h1c2tBL0RqMEZRLzRJTjdO?=
 =?utf-8?B?ZlpjaDNJQnFJL2ljTVNVWUxFdm5KUVp5OGpIWCtoaVd4VWlGd2tHNldBa3lG?=
 =?utf-8?B?TWM3MjBtNnh4TnZLRjc2ekhNNlNTZFpvcHZNaURKSjVwN0QvWDNKcndIMzM5?=
 =?utf-8?B?VXRjTEZrY0tMcDZqeGw2a296RU9xbmJTVVJTcHQ4TmZsNGlhS2xqQlBYancy?=
 =?utf-8?B?VGcwOW02clF5UU9qUlVNUG8vNitNQlFKbjU2Q2gyZWt4NVE5TG5JYUxHTklP?=
 =?utf-8?B?SUp2WkxLdVM0ZVdDOFpyQ21CME1YQTFNYklTZ3MrVzE2UVNxOFVKc3R4N0E0?=
 =?utf-8?B?ZjFXVmduZ0JEUkNGSFJWR2xjMnBaWC8vS3VuMEt5SGZzdWRseXI4N0VTQjVT?=
 =?utf-8?B?dXdTMGU4azdCVEtIWjh2V2Q1NWpqVU9HQkZHakVncDkrVTZVanNYeC9JSk5t?=
 =?utf-8?B?RlV3S0pIcmFlaVJLY3JDMHExWkd2eWd1aGU3ZDB5bmlmZ2tGR3lRUjg3V3o2?=
 =?utf-8?B?NEpTaGxvNEFiVXBjaHBXVXZkVGVIaWtsVTZqa2RjTHFEd1FLQzRtL1FOeC82?=
 =?utf-8?B?T1NnWEh1SGY5dXhhN3VzMUhLK3BiVzFFMWZ1OWQ5MFc0a3V6aHFhcGZFTmdv?=
 =?utf-8?Q?JbCAwWNB6WS6QWSct1EyF6E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lMB0TDh1+tON0d6p5IoDGwo1bFUCqAtq0XDkfxFhDGIG8d7nXSN8YhXvpmH9lgD8/k6RKbL+mKRw7f12nTOhhwvqBck7SUjr97ga9fEI2Zf6jAqHPrpkig2fwPIQxjnx99WJoq3BffNYf6Dol9ImYdU9j4C3BoJi9Y5VecuWPEP9cBFgjaxlgwMgjsb0JG1GKcUZcQkxseYxMcJs5rff3pK8DhyKl6HQYUItZ+AOVZSo6NnhQMtADOaio/VhnD6bt/907To1uVLdErDwAWpk1G53QSZKth1IyIcLh0n0TJkkSmfcdRhYKjLyeyYWZ5ZPFtVgc2H32RTEdAIc4KcOLsrrmd30xOVfxnsCFw+p6e1XFKvp5q0e7Y+smC7srFT9khZFC+nLNYBfZQgQcj2Dg4ukYQ2ORLTTz3SdnS6OE6TEfK+pN4cGoezGysSPZA2dF25FvkvRBnm5KFS9FgQVwi7LNGSgEb3ZDvpqdenQRkPVOcl4bJsH9pPWBByF1aggP5hVqplcUlFNd9D10VldTHTcmT5xcnhOsM6BU34DrzuvgdFERhiSpRNhdMyhCzn+Og0/Ah5l4E1Py/vjSd+MPwcQfTh/zA7JQu6P0Nwvpps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13251844-ecd2-4914-f370-08dd438dbf48
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2025 13:30:23.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BlJ1LwuSq7VW1Unw4zOqGUpFCGQImaKXeQP0rfZ9AObLBtQwUtQg0uDoJqdSZIU2+XLSWPoT4w/TDO8FE45CBMLQlG9gCcvC1cAkWbUcP8yW5zRK4H4z83HvNAn/cLS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-02_05,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502020120
X-Proofpoint-GUID: fzFrZX1RAZG6VfAGz4FonUR99Lnb8fh3
X-Proofpoint-ORIG-GUID: fzFrZX1RAZG6VfAGz4FonUR99Lnb8fh3

Hi Greg,

On 30/01/25 19:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.75 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
