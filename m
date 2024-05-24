Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B66127E12
	for <patches@lists.linux.dev>; Fri, 24 May 2024 06:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716533950; cv=fail; b=Db0P7RiT1VhrbwXQBnN0Axcst65CDkmZ0MfzZAfy39YudE1lzr4iwvLVk6CYLacLgSU56oQMehmM7Hl/Fu/8qhaldNO1l2wLMXJWBrK6K6ovcO5YX6t3IegQzPLl8U+PwXfXrb9+v4ObHjLqMkc33AOFS8CwVndTz3siqWmcchA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716533950; c=relaxed/simple;
	bh=3MXkWx1MzouVZ3WrOPHziCLNJf6Au6eb/9Qb1Ki4LWI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O74lB+kxnRbX5p16/b6dqeafmZRfWOpStW5N0OxNnr/OCuOWqh+lC6wDvjGxYZ7bTfDLg/aqTezPHW/gOddkp8e+DzUwZT/B6e3Kjr6h97aKoZqB0us+FnRfaittMQNGT1flBkkRRwcLWRsT2PNHn7lzTVTR7QOB990ad3l7ij0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FkWFpbw/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h8siX+D9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FkWFpbw/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h8siX+D9"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O11k7i032567;
	Fri, 24 May 2024 06:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=QfKmzPC2AerqXhnlNc6z30hR6Hbr88WaKxrzTDFf0KU=;
 b=FkWFpbw/JfHe5dzLBUnKf5u61bLOdW2LpoRrQRL4VEn2HdpMaFRGGRJ0tM89VZmpKCDL
 8IB0i082JBUjAgpC65c2AeE6ZOs5xkn+EMgmPQQL4WOo/TJiG8lgoAuD1q5EHw/SMd8S
 uUHlA9tuLc5s2DVY8ExNmjvTDgjU/68ntAVqRXQ66nfJLWnRIW9UAsnloJ9L6CB4fT0B
 eJf6OZXgyPMDYLVGKdfelmuwNlzAppoDZUgH42CvX/0LNImhGZeNlg+i0KPYULmUw5Oq
 T6kWtdGint1gxshsof4Jb1u4L5MXRsfVrOHIOV0iWDdCgIqZ9IvAovjbvhSaRSfuBpsG qg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2kq17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 06:58:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O5Rfn3037823;
	Fri, 24 May 2024 06:55:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jshj7da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 06:55:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMKTrCLl0qzgDy4GyGRj+ykQKkT3juAIaPJJCiOdMqZbXaH9Kv2JhnNbAYkwWs9pFvY0kwIzjVEnqfA6g8EQ3o3QIAy/tvmg70m+6C07RH3ansGEojqULQ4J8CV1ZByFPpVqZ55KPN+p2N2AxpOMJNVG5xjn8huKkOm6wSXQ9dezAo0vuPnv82vJYHjVbtqCSMYmJr2P+G1uCllvt/I1aILehTkNTUj9h0F4DW/WLxSX5Ns1RwL1fRw1Ibfp02pD/xkWPdltqiBU9FilcBTo3A9z5rJhJ7IpHx4ngghyq7PYC4UWl7xZOoxURhm38dJrcryHpTgNyY4uNRHGxwrOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfKmzPC2AerqXhnlNc6z30hR6Hbr88WaKxrzTDFf0KU=;
 b=m/RYOaetXLJcC4HPXo+3DZ7f0nryIzRgvUZHYsVczpSx8rrzx1BSGW3b31n/7dLgr7almsIC+OLXv/0hNlZTGcUfZ4gdIpSloMEA907gyCT4rr7bwVl3HBozElb4XWU8Z35ut3I2wIHcb/yIKvSj50RmPskRYRzXxfNI69F0PU3+XYly3c0rRvUiaqYslUXMPmAIRqCpQ/6NzKtP3jAZtdXJYvZ9mbY60yJT/kaSFg/lfE1KydnxYdcoT1hl45AJLML4siyX1ZxA+T5b9QRNVBCraclIZ3M0b7nBlIB2AxVR+D2PIi2GEeKjrE2GynQwTe/Hdigbe4tiI61+LQ5r2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfKmzPC2AerqXhnlNc6z30hR6Hbr88WaKxrzTDFf0KU=;
 b=h8siX+D9JSjR8sccKRO3Gz0eNVqGFMBAf3ETyu1HG2mXmSIqvqD5IyaDhq0lCfX3i/qtBf1sT+KzyskYnF/XWMt3XvLy2JPdLezo9xVe0ZgxfeKX+Y3/G3FzXB00DEciKZhTFaiQjzrjxSbhdZC6O3JQJqG9if7Lul+p0C/DIZc=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH7PR10MB6201.namprd10.prod.outlook.com (2603:10b6:510:1f3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 06:55:41 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7587.035; Fri, 24 May 2024
 06:55:41 +0000
Message-ID: <bf7adba3-fd42-46ec-bb66-0a3f197bd070@oracle.com>
Date: Fri, 24 May 2024 12:25:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/18] 4.19.315-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240523130325.727602650@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH7PR10MB6201:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bb2bcb9-b806-43a4-d762-08dc7bbe865b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?djBBd3p6VW1ZaG1MSDVZWTM5T0JRVlBuckxhcWhkeVI4VG1jV3pJT3ZER1Vj?=
 =?utf-8?B?L0Vxd2czT1cvOVBrNk80b1QxS3p6bjZKT1p5SmYrVmRzNjcreTcwMytQMzh2?=
 =?utf-8?B?M1I3Q0dPa09abnFLVi9HSkpkOUUwMUh5SUZmaTNmRE90cU44aDArY1Nocmwr?=
 =?utf-8?B?SjVIYzRuZ0F1TXcvdUVIZGoyZDRZQSs5aThrczlrQjJ0NDR1NjRzalR3Q3RK?=
 =?utf-8?B?NmpEdm5FUEZsbVVwV1R4c281a0pWTnpUSEtTQncrM0pXd2s1RzUrUUtTWWwz?=
 =?utf-8?B?ZzNRZUl0c0x4TVJXTmNGL3lzaEVicXRrS3hkTkVERjBBcnFoeERoekNBV0tH?=
 =?utf-8?B?Y1lnSUswWjI4b2hITFRYc053ais1YzY0WjFvVTJUeHVhelZ0clJHSWpTRWVv?=
 =?utf-8?B?dGtXZ1l3Wi9rakg5QzVQbTJ2TDNYR0xZSEZLL0grc2lKQXEvUlRLREo0ZzQ0?=
 =?utf-8?B?aVZEVkVEUXRKM3hrdDJGOTJMUU1tR09pSWlwTndDYXdPNXpDdkJYNU00ZHZU?=
 =?utf-8?B?Rm5WVTNjaGFIem9BOUw1MWNMV0ZBWFhRRUNjeEZtaG5HY0ErUjJ4UVQvcXZM?=
 =?utf-8?B?Y0JmRjh3RUR3aWUzT0s5TVhqMHg4Y3NjZ2Z4RC81R21RRlowT0wydlJRc1Ni?=
 =?utf-8?B?RnJzZnBuMEdvbmw2MTFXZ2hNcmg3b0R2SXBrZEl1MGdpbldXeGdIcDhaRXNT?=
 =?utf-8?B?d3FWblV4aEpNcDE5WEpqOXFFSmROYlROK1ZHb2RxTnJ3R3F6VzREZGltcm54?=
 =?utf-8?B?QzVlb3FPbHZIUmJHS0pSNU5JSnBVOHNHRGFwcU1TRjgzZDRhTVVGWTFMZVlr?=
 =?utf-8?B?L3dLaW9MWTJWS25pUXpRSWo0elBicmJDRW02ZHA0MUR6ckh6VDFEYWU3YmNq?=
 =?utf-8?B?aDFTcmVSSzhUYzN6Y3N0RGhyM2ZQODhKeGZzZnhwU1d3TEpXcTRON3RkNFVQ?=
 =?utf-8?B?SWd0dXFHSXJuaENhZjIwSWhtYTk5dTNFR2FmaFA4a0ZPSTBoRjZEWFBROUNT?=
 =?utf-8?B?aUQ3VGpCWmgxWGgrek9XeU1lcS9WZjdKOEpsUi9hSGRzWDRJTE9XQ3Y2T3Iz?=
 =?utf-8?B?aHh4dngrWHVodjNzRFNEWFk4djFEWG5mb0E4Z0djeGozREJCaXAwNk1YbWYx?=
 =?utf-8?B?Q1p5eUxQZjlVR2g5VE9hMUtTWDlEbVdTeWpVM1NNcHM4OW9wN3VwRFFIVFlX?=
 =?utf-8?B?Y2ZhREx4OUdoZmpGdXlBd0VoYmxFSjhsNktNZUFXZFk2NXlybGtBaFlyazVo?=
 =?utf-8?B?QnM1QmZpTWt5Vm41RTM0KzlYcEVXdWdUcTlkbGtLOWFESVdXbDJvR0sxK2FT?=
 =?utf-8?B?Z1QzWXNyaDVNVkNMbjJmWC8yTE1sUHloVzdJN2hZTHdVTW9tWUFwZXRVc0Y3?=
 =?utf-8?B?b0s5ME9GQlJvMG9qUUFFL2xEVE1GNDEvY2FkYTd6S1JGRGtmd1I1bU9kT3Vh?=
 =?utf-8?B?SUNvcXFibnFGTEdKUWRtaTFBc0JxQThzSGZGUUs5YURXUWpBTCsveVdNWTda?=
 =?utf-8?B?NjFOa0xIT0J0cm1vQWdJUE1vZGhaY3NLckFkN20za1A5Rm9nTGdndkRvZC9P?=
 =?utf-8?B?dVpxVnk2bXl6SEoyS2FtZVNPTXZRQWJ2R0xvbElJTk53S2tjS242QlZHelVS?=
 =?utf-8?Q?9TMzYrcfPVgMYJYw2GP++L+AL3sj/pWfHMiPUs4oYy5k=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SVVqUEQzVmZOeXVUVFdsNUtlY1lRNkpZYTF1ZkY3Tm12aldDOCtZZVA2NEk5?=
 =?utf-8?B?eUlES0RNRGRNYnZ0Wm5KY1BqekRLSkNRbzNyUXFUTTRPSzhMcThHVmxVa01S?=
 =?utf-8?B?bTJQZkJzVElPNW1vVVVlR0FwaHNzUGRFWGpQMXJzQlNhWDhxYkNlY0UwT0tv?=
 =?utf-8?B?eDZQYnBFeVBhdU1rKzRMZGxidGxrdHEyaUk2V0JJN01aa2d5anBEV2o0RU9L?=
 =?utf-8?B?RmY2NktJYjdDRGlvK2RRNXkzSldVRmVvMEZsZFhSN2UvVzJWbmNQV25Kekhj?=
 =?utf-8?B?WmhpQ3BybTdoZTJ6MjJTVmR3dkxrd1lXRVk5VzkrVllMU0JaZldRY3JDUCtq?=
 =?utf-8?B?ak9GRklpT2xiWGJkdjRqaithYjZRL24wNnpVZW5yaUlOUXVRZEhYY0ZaVHl5?=
 =?utf-8?B?Q3VYNTNoNnZBKzFYb2I0Y3pwcHdXYi9VaXhyY1d0RWN3TkFXWFM4elhaV3BO?=
 =?utf-8?B?YVFNTlRFVU1PZk43NzVIbHp3ck04SXVQUnlrcG44bTV4Q0F1UVlPYWJEWkdT?=
 =?utf-8?B?ZmpGWFBJWFM1aWplWi8xcTZzVWVtOTUrZ3JMUGxURDE0V0c3YUlsS3JWWGxs?=
 =?utf-8?B?ZjFOV1R4c3RFcXhpaEw0a3p3eDFuNjkvb2VuM1k5TDFkd2hQWG9ISjZUbkdp?=
 =?utf-8?B?VmpYcU9XSzZKS1VCTmp4ZUEwcXJ3MWYxclNUaEEzWGg5UTl0bFdQUEpDckdM?=
 =?utf-8?B?WUwrSzZvSG9yb3JMSU9aQTJTTHlJeUVYOUErNUpqQ1BNU3YzYzJNclpjS3hP?=
 =?utf-8?B?RzRZYTkrVnBHWXdzRFNkSzdHajN2eXU2M3JROVRlZW41TEVWMFUyMmZFc1VH?=
 =?utf-8?B?dnd4NEU0WWIySWFxeHVsaEJEMnByZ0lhVVYvWnY4WWllZndYa1N4QXcvSU0y?=
 =?utf-8?B?SlNVdXlhVktuVHAyVEJNbHluY2EwdkVNTUgrV0FPa3FGY2s2TXpEVXF6WE5p?=
 =?utf-8?B?ajNuNUhoZkg2dUZMbHVLNjNaYlI1bkVldkJxbmowR2wrb2FHVUVIZE1lbGNR?=
 =?utf-8?B?L2VCSHNzUlhFaFg1eUpadlBycFhQNHpGNE9zZEJzYVJmcU5MdjQvL0djV3Ru?=
 =?utf-8?B?UTFhNzdIVjJMZ0FQcEF2Ym1OQklHZEVicTJxaEhtVWhVNkZia3RLeWoxckg3?=
 =?utf-8?B?V1dGM3NwRHRVYVU5SWxNVm00V3Q1S0xhdzhpdEN0VldBbXM1QitoWWRqQXZ6?=
 =?utf-8?B?Ump3UUYvMnAzcSttWmxMdTRDUk9PVjR3U090L2pPV0wwTWdTa1NUaVlsb2Er?=
 =?utf-8?B?TGNnYWlKT0tkajBlMTBOZmZJNnZCU3hWWUc4NXptWnRZeWpWZUk0WjllN1ZS?=
 =?utf-8?B?Z3JUNzYyRjF3bXdIb1ZtY0dFSGIvUFhQVjNCTVJTNjVVdE9pVzdoQ3Zzc1V5?=
 =?utf-8?B?R3NZcm9WWjRPMWphQXBPeTVVUEZZSjJ0am1IcVRjN05XUFVsV3EwOW0rcFZ1?=
 =?utf-8?B?dXU1ampnSVdaaWlXLzlXVThSRkNzZkc1bHc0Y3dNOHRZYVVYNVJYQ3Y4V3Nk?=
 =?utf-8?B?UFRLTWtwdnlrczRSV2dkNGhVRlluano0WUpZUGhJQ1V3N3pxZjVEQVZSSDhP?=
 =?utf-8?B?dDZuVGF5WWdmUk1Fa3h6UGZBRW93ZkxQNEZUUWMxTVJ5NVdDOWRRSGxIOE51?=
 =?utf-8?B?RGxmSkpyZ1lYVm5sL1BsckMzSk9aRFFnc1RJbytQTVZIeWlua0g0SE5nVzds?=
 =?utf-8?B?VCtpbUowSkJCMzh2cHlyZEdFalg0aGk4UDF6OXBHeElJV3NPY0V4cXVES1A5?=
 =?utf-8?B?UHcreWtIVUpkTE1kckl6cThqMHdzS1NOMWQ1dGpoRlpTdWNUYmUxa0t3Wllp?=
 =?utf-8?B?K25SeFdnWTFnRXVWVlN1T0NBT1hDenhZRFBISFZ2UVl2VHBiNmZ6OFBPZUVG?=
 =?utf-8?B?bVJveld5UHVVeUt0SGVkMUhJN1A2eUJ1Mzl2emo1WnNOZDVZaFo2ME5DZXlW?=
 =?utf-8?B?NEJoMXRjR1VZYUJrWkYrdUdDdHBOY2Fkd0VFSDRCVVR3c1YyeWJYMzdZUjhN?=
 =?utf-8?B?SGlWSzAzU0hyUU9EblpsVGVMekY5QzlZaUhqcDdpU0FJWlF4OEp2dzkyb1Rv?=
 =?utf-8?B?bndkRVJJRmR6QzY0RjM5dHNoYitQN0VaM1Y2ZWVJNm1FKzBXK3YvOXhuamxK?=
 =?utf-8?B?bmhlRVpEcEZGZ2dQdmpyTjcwMUllcjVZUDF1SnJoTnhUaENickdwN3RybWpR?=
 =?utf-8?Q?hTfOIynaej51A/EvMQ86JhE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	d3E3hn1+Fp/e0dZn4PIvG2pm1q8U23kB8CLPOfYbsMKMfPRN6COalPNvDEf1EsvdmfHxjeSuEBMX9FI4vh9rE5PVc8pDrosRQVTULMYy5V9qiliT3fqcf9A3mG6fbjtquOWLOKMtXOXnWgEk0qrEmB2quvYGfrnWo7Gc/u4NsMohKRaYLIWphTxD0JXTlolqJgUjUYIdlZlbgooivdFrb1RGIAiCgJhr4HoN436kqa+0zziZABf8PbvpojFGTbVpPAd9eJJNsMvy2+3qjLE/Y+vZiPf9C+C02rSCWELoH+HYHGUe5NeRrLBGiJfreu84stWB0MZcMLSxLv+HHvbr0QGgE3FwZEJdYGocWlmriauB0wxHYvzHdkqQZ5XIZEr8v01cU5qwPTIp6EDwgvuF8xmeuTwEDkHS3GUaf1dszlrQgV7TDTI6+O5lLQpXUQhTReDqQoNfKxhLoMdj2P51/D/zw2VdAavBNYxaAaY99pbYdF5r2zA+nILLa8yRHrb4ki4lJZDSXnDuJnQc4T3ndNANJMrS7+X1FS1+TH7Ds+Khbu6ZVxB2NbLymKeRyQXAL4QNyNoeMG/WUXRcPqIdBOLkLzzSIDOAiLm8esdeWUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb2bcb9-b806-43a4-d762-08dc7bbe865b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 06:55:41.0650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZFlpL1rkWde9UCp3cs10laFybmyYdg3Lu+KHP8N+5gUbwCR4/oyPzKMSOH6z0d7MMPg/56jqHJM0esdifHKp15WeIWWXDeUARW7RtaZRC+Yd6s/+407t0pO+1q26jnv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405240047
X-Proofpoint-GUID: xICT9aXSaUKVnEqhL5IY1hgtHWE2y6Of
X-Proofpoint-ORIG-GUID: xICT9aXSaUKVnEqhL5IY1hgtHWE2y6Of

Hi Greg,

On 23/05/24 18:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.315 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.315-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 4.19.315-rc1
> 
> Akira Yokosawa <akiyks@gmail.com>
>      docs: kernel_include.py: Cope with docutils 0.21
> 
> Daniel Thompson <daniel.thompson@linaro.org>
>      serial: kgdboc: Fix NMI-safety problems from keyboard reset code
> 
> Tom Zanussi <tom.zanussi@linux.intel.com>
>      tracing: Remove unnecessary var_ref destroy in track_data_destroy()
> 
> Tom Zanussi <tom.zanussi@linux.intel.com>
>      tracing: Generalize hist trigger onmax and save action
> 
> Tom Zanussi <tom.zanussi@linux.intel.com>
>      tracing: Split up onmatch action data
> 
> Tom Zanussi <tom.zanussi@linux.intel.com>
>      tracing: Refactor hist trigger action code
> 
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>      tracing: Have the historgram use the result of str_has_prefix() for len of prefix
> 
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>      tracing: Use str_has_prefix() instead of using fixed sizes
> 
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>      tracing: Use str_has_prefix() helper for histogram code
> 
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>      string.h: Add str_has_prefix() helper function
> 
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>      tracing: Consolidate trace_add/remove_event_call back to the nolock functions
> 
> Masami Hiramatsu <mhiramat@kernel.org>
>      tracing: Remove unneeded synth_event_mutex
> 
> Masami Hiramatsu <mhiramat@kernel.org>
>      tracing: Use dyn_event framework for synthetic events
> 
> Masami Hiramatsu <mhiramat@kernel.org>
>      tracing: Add unified dynamic event framework
> 
> Masami Hiramatsu <mhiramat@kernel.org>
>      tracing: Simplify creation and deletion of synthetic events
> 
> Dominique Martinet <dominique.martinet@atmark-techno.com>
>      btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()
> 
> Mikulas Patocka <mpatocka@redhat.com>
>      dm: limit the number of targets and parameter size area
> 
> Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>      Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"
> 
