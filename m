Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FFA22579E;
	Sun, 23 Nov 2025 22:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763935372; cv=fail; b=Z9TN509VTvpdbGdPD2xQmZxb3NPu6H4F/tt1nJ7JlUKQq5GacrubAAUydlbI1DUxJeXUHj8AbelyQ2hZ9EBV7nj2/WhdpG7WzJCdmYYug2Il8p79aBlj13VC8SM1VpCdVn6zkpq94R3wLukdQ7rtQ7t933jb+LBAuSMi3wCIE7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763935372; c=relaxed/simple;
	bh=q6EvZIr4U8fQyTxfaO1zgRxMSouNUmQzt9LB0Zqn6FM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=swMvZmCJdac01KZPs5cYqyftll+F2uQ28ZjoQrTg9z+Ul89CSFJdifQ1akh+869F1enhlx6g7fXFKnZngt/3k1YhSPoJPHq353kk1rY+OuIt5X2LNjJm41y3M0OMWr2IyFrNgNFSomENJ2iXfacOD3nX5we7KkHaAjHmpnznY9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T32Pd4nf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kSVLindi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T32Pd4nf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kSVLindi"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ANKm8wa3762953;
	Sun, 23 Nov 2025 22:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zCa3OTes1BhFimYTBB4r8vfF490LeDmXobMDhZ3FK88=; b=
	T32Pd4nfuOjF59an0UYDrpDQVuXZQ3yXNxTElfuYOuTOwDRB5q3wBGXKYucMAuJc
	C5xGO8lm5ed3rTRLEZUV3rirnng19xcEeIv6LPznIFH4b9b/3vkEvNCvYydD/mSz
	Wb8dTmn1qbFEwg99KuTHsiNhvxV0A4Ax2u303sks1TlcC0Yzhr5pPBpr2qaGpDEF
	TXaNVoiS8c5J2m4AVdoZRyg2pe3vPjfrnXtkb0wsdya0xBTybIIjVkEZfCpxux3k
	cPNl3wHkjqBzQxf/16oy0Kv2WZXMB4HRAl/Doy4Z0iIIUDbFZN821upM2KWWpYyZ
	etd3plICQYTMuiOhlhNKXA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yc942p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 23 Nov 2025 22:02:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ANFExj0029886;
	Sun, 23 Nov 2025 22:02:32 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010059.outbound.protection.outlook.com [52.101.46.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3maxm2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 23 Nov 2025 22:02:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HKuik7wBmBEk+Sn9ABEJkp/KN9isAyXJ/YW8zDVRShWX/jukMvmXivCz2YVUX/+ad9t6/mU9yNpfutNjM+0TAXp+YAAB29Ugnt6/YLa/5CP1i2E9k/no/3vH1I65UF5gBNdo8sLjV43osj4GyEeYGL7YHrYRxG4Zn27m1d5RRRlzlW+D0tK70G5XnPq/pDgUjmqYxSIaXd73L+aTVCt/VD3cadeeuiZfqsiRhTdgnY8RRTyCxNKWZhqnuaJszTPFfCr/dJDDFTN7syP2m/wUcN8feXjRq61CgfO5dRyVSkQt03QOii25eYPEc4a4K1asH5IVIjCwLnMMlvWuCWGBlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCa3OTes1BhFimYTBB4r8vfF490LeDmXobMDhZ3FK88=;
 b=CIrNMqJ4+4ZTiF6JOxOAFHrzEsXrwUOdWigY4hvvgvzPtOkl2WWH7IadN/bI5/n6OmjKZzqPK8OVsn1CrRtqOvJBPa3OafqxFUpbTgKHgp5mwr+ZqsP5pZ6JjMymKwJIInbgrpdGIf5M3k9ERohiYdzmpxWUlWSdD23AU0EyBECTavqYXw6P+ul5hgr89C3FZjQxlr2dSI5t2g7JFNQaGbVCkkOdtraBeOv9GIEvLUVEW3iPpAUT2PHmz0tQqzFsLOd1Got1sF3jOYh8+waUTeJ6F3W1Mabu1kp4H6QlUh1rh1JAS+snHSlxaDvsrRpQfY9RBK7AUy+PSR44kiw9Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCa3OTes1BhFimYTBB4r8vfF490LeDmXobMDhZ3FK88=;
 b=kSVLindiCOlbqJYPdAXLxyuhi9rA+NePDa0wvFnPVdJDhQJGYjs/veogx6Vn32Z/+DOwL+e2FJrMfzB8DK0mi4Tk2Rx4AMzcKx/EX7ac5S+VTZm82oS+8EHCx6KiFAVM3H2VKqxukRXWrAQL4f6kcDbem6+zPZFgKsNl7lxmyh0=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by DS7PR10MB6000.namprd10.prod.outlook.com (2603:10b6:8:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Sun, 23 Nov
 2025 22:02:29 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9343.016; Sun, 23 Nov 2025
 22:02:29 +0000
Message-ID: <a8a244f0-c962-4af3-b046-31523a499813@oracle.com>
Date: Sun, 23 Nov 2025 17:02:28 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommupt: Fix unlikely flows in increase_top()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
        Samiullah Khawaja <skhawaja@google.com>
References: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:91::25) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|DS7PR10MB6000:EE_
X-MS-Office365-Filtering-Correlation-Id: 76018456-ca71-41b9-17e6-08de2adbfee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXF4MU5IZ2V6VVd4NUZhTk9CUTYvSUJ2d21ObXR5MktseXBpRTBsVGFNRHQ5?=
 =?utf-8?B?RHFUUUJzV21MeXA0MzNsdnZlZS84WVZLY0VwaTVKcVIvbGRjUGtheGloTFpZ?=
 =?utf-8?B?Z0tHbnc2M2VTSkFKVnJta2w5V3MvdHdORmlWRTNxVStvRVpNMDk3bzRvemcx?=
 =?utf-8?B?eU5GNGc3cjFSZkFmTE1iZGNtdGdDdkZnVTYyV0RiTERUSHhoVEY1M1BkbU12?=
 =?utf-8?B?THVRM1hwazFLNmkyL2FPcTkxd3pmbHBueXZIK1JuMlZqNVFXQTNscnVjdUE0?=
 =?utf-8?B?a2MrZE83M29GK3VzejZ6ZDBUYXp3cG1ONWVhd3pRWDZlWk00NVYzVjZ3U01r?=
 =?utf-8?B?dzZ0d2pxQmdFYnN0T3VFS1RHSDVaM2lZeGw2RXlmM3Z6ZXM2RlB4eVppLy85?=
 =?utf-8?B?SmFhblk2TjZyUmZRdUZ1QnZoeXVxTFM1bHd2NUdtd1ZiQ2N0NU9rM1FMVFRJ?=
 =?utf-8?B?SVlZUU9zRXpVaWlRaGZ5ZnZlRld5M3hpdzJrZCtYSjArVGRiMzMrQTVORkoz?=
 =?utf-8?B?eS9PM2tlVEI3S0NLRmhYbTJ3TjVsUnhIalU2VmNnc3VVYjY0YklsUXJpYlBX?=
 =?utf-8?B?MEljMWVDSWJUS1JudGZYMmJteWtxTmRZalE0VFpCTExmREZHNEt4TGkrU1Nz?=
 =?utf-8?B?NVZXS3pKOFl4eHE2TEZTKzZEaDM2T3ZSaVpyZFoyeXMzU1RvcTlzYXFrb3RG?=
 =?utf-8?B?VXlZYkFwTVNhaThvVkF0Ti9TeWR5YzRwaDM1SG9ac2ZpcG1uWWRJZG40VFBp?=
 =?utf-8?B?ZWVPWVRJZlhwckM5VDUzdTB3QXhhSGJFWU5SYTBtMDRmZjBIMTl2djN2Z3BO?=
 =?utf-8?B?L3JVVUpQdVlxTlNtbHVtUlErbGJsb3JpYWk5UFdyMHFhMnh3Ym93TXlLOVdN?=
 =?utf-8?B?MHVRV2FWamRmdmx4Um1aU2g4am8xazBWUXR5ZUUwZzgyN3A1ZTg0b2Uzd0R6?=
 =?utf-8?B?a0hhWDFhaGVld1lYcWF3Qk5XalZNK0tObEFzaTBHRlZSTzAwNldQa3Zkcmp6?=
 =?utf-8?B?dmFJUUozTld6Vi9uS1Z5M01GeFNYdHNHdk9rVmpaem9zOGxxWDlISDZYdjNJ?=
 =?utf-8?B?dTNTUGV0TGZyOUFDWCt3VlNaK2RpdE1pSXN3T2ZiMWpOUHIrNmpad1FXWGxK?=
 =?utf-8?B?bzVOcExQR0dwR3NaWjNWbW8wZnhjdGNJcGVlMmxDQ2MrUlFVeWc5Q24xMVZL?=
 =?utf-8?B?ZzJ3citRczdUU2Z4MGVPdXM0dlZuVWY4eWFXbGl0L01Md052Zncvb0J1emxa?=
 =?utf-8?B?YklJRC9aY1BUTm9kN1RhNTdtZ0xaSWJLTGRlMzBNQW5zU2dBYlhkdVVUQnZG?=
 =?utf-8?B?L3FYUEtnOXJwUklPVUxSaFFYV2R2Qm4ranZKdVAzL1ZmT2NLN0EwbWlPZmty?=
 =?utf-8?B?ZlgxNi9lcFZydklMWGFoMVlPTkRkMW0yMGtURFZ1Q2hLQ3VibDYrVWtnYVRs?=
 =?utf-8?B?Mnk5SFBxZHNJYTZETnVwL2dyV0NIaG1XWEJwMXdKTng4OTdVUmhnajAzRjNJ?=
 =?utf-8?B?ZHBpOUtabG5FNUVGRFNORTdlcTYvVGFRTStOYnZJRVZmUEdhamY1MXcxQ20x?=
 =?utf-8?B?aEtSY1E1Y05aTFJobDNmYm1TWGc3RVFzMEl2Q2diVU5pUGJWU0lLNHIyTHVn?=
 =?utf-8?B?T0d4UG9SaTM1bFd1ME1yN2piRjNzMnpxSjhXbGo5NGlJMDZjdlpZTEx3UXdM?=
 =?utf-8?B?RzRiVGpEVTJzTDhycXhqS2N5eU5LbHRrYnltOGVsWXp3cUNYQm9NWDB0RnZC?=
 =?utf-8?B?NWJNUWRqSlNYU0R6SHpXWm9sQVBRenRiaHREWnlFMlIwMzZCRHVsN3JZZW96?=
 =?utf-8?B?K2pBaWJrL1pQSzFEa1hiRm9VVGxTVGYyR3ZqQ1Qwcm9oSjJPZFBnRWwzd2dq?=
 =?utf-8?B?Wmg3TWl1WXBkZlZCVllZcFZKZWdTQkFUU2FaVmZ0OE9UamlzbXNXcm1XZ2Jp?=
 =?utf-8?B?a09ObnZxcEF4ZEZ5aTBYNWFkY0tNTkltUWlLa1l1bzNuaElDVW4xbHBIa1pI?=
 =?utf-8?B?UXo2bUlSL0NnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUNvZ1IvMU1EZDhFdTJKc0tJTURocGFOYm1jUm12MEZTVzZEOUxoKzlXNUdl?=
 =?utf-8?B?TVpBNkFpVm4xOEkxMWJMQTd6YWk4bm8xbGYvNkV0OE1neXVXbUFsMlVYeHhT?=
 =?utf-8?B?SzNtV0ZhS2dWR0Nib0kwQWRjcklUVkV1L2R2V24zVHhnaEwvTU5SUGxTVVdV?=
 =?utf-8?B?RGZsZCtubnNMVmhoYTliaGRaQ2xjSFQ1Ym5FY09DbGlES1ZJZlkwdGRPQmhW?=
 =?utf-8?B?U1F6NUJGamNWOTE5cmNvQ3FSdk9JRThhdTNGWERwWFB5M21tYzJxTUFoVTBu?=
 =?utf-8?B?QTBwK2E5Ykl6SFZaV1FyUHRvVnVZTDBsRmtKTFV0N2NqRXQ5YVdiTVJtb2Zy?=
 =?utf-8?B?eDhmS1JMUHdCRGQrZ2NjanJPbFAvY0ZlcmJLOU82Sy9NemRmMURYczBxL1Vi?=
 =?utf-8?B?Rkx1aTJ5M1JsU1B5SVNHRlAzZEFQTmZ2Y0xPa0UvOXA4MVBESnRSMjJsZ0lU?=
 =?utf-8?B?WGlOU0hSSVh3YlNveDhLK3BLQXY5U0w1UklydlpONHg0OFA1L0ZBM0YvMmha?=
 =?utf-8?B?cDZsTDVMMExBTGZ4THU1THV4OGpWcEN1TVlYYWhNbFI4SGJDakkzdytkQmVP?=
 =?utf-8?B?OEN0ZXhIRGFCb0NlODNFRkNDOC9tMnhJWUNpRmk1c082YXpZVEZFMnFWcWhF?=
 =?utf-8?B?SERpdnV2dk55Tk9ubUZIb01GR0svdU5leGZyaHZuWGdKd2VzNXJ1dEkrTXAv?=
 =?utf-8?B?RDJGWU9QczZBS3ZPdlk4Ujd2MEM3WWZnSUQ5RDgzclNaR2lFbXBieHFPU0cv?=
 =?utf-8?B?cVZRb2xHTGx3dEVkVnZwRlRGMlM0OHRZZENOYy9IYzRuVGZWK2NQWEsyTHkw?=
 =?utf-8?B?K01Heko1UjlwM05sSmp6RjlJb2YwWTEzR1Nwb0lLODJ3bXdGWjhnQWNRSldz?=
 =?utf-8?B?aGNMR0kzNnNiOEF1SzNsa292Q3ZmS1pKL204YzJzMlpMbXV0S2pDWWg1RXNr?=
 =?utf-8?B?cGZjZ2o0VEM2RmtJY0FkMzd4b2I4bFU5SE1GVGczWHhIWmtqa2JjWmVVdXVV?=
 =?utf-8?B?aENNTmVNWm9CU0RYWkxGS3NlZlFQdHovTmtOVE1RVWpwd1d5UC9pd3l6Yk81?=
 =?utf-8?B?MFBtN2Q3UUk5aGt6Vnh4eFZuL1RpYmhMNGQ4L2txK2RUb2hYWXMzVDJnZHVX?=
 =?utf-8?B?VFlNMEd2S01GYW5OZ2NWaE8yLzZtN0ExYmRQY2ZIb0F1R0NYRTJPRlZuQkpI?=
 =?utf-8?B?b1FkbVJYbFQ3Wlh2UnJjbzR1ZjE5RVZtQzF1M3k0eXZoTXQ4azhKMHhUMVpv?=
 =?utf-8?B?NDkra3FBV1FnYVczejZOd1dkNUlpOWxiM3VzRG51RUNDSThMRHo1Smo1V0l6?=
 =?utf-8?B?YXVpcEN2MnBJQ2pSVVNRelQzRmE0dmE2citIMGszNG1HK3BwTUJrZFAza09P?=
 =?utf-8?B?Qmx1elFldTRKa2I1TThSNjBsQk9ESk12MEhmM2d0VmN0Q1dYTlNxcnFxOFFS?=
 =?utf-8?B?U1o0dXJ2YzRIVDU0K2xrbGgxS3lvWjNSbnhGWUV3Qk9RRmE5eUE1c2dLL1dl?=
 =?utf-8?B?ZmllZ2JpNWd0RXd6aUc4UnJjU05ST2I0S0ViQXg5RHdxUkozVEtnd1F4dEtO?=
 =?utf-8?B?dkMwaG5xWjRnS3RWbnhJcFFtM21HYzhnYmJtbkNjVHc5MFVXdnlKd1BRUEZV?=
 =?utf-8?B?dFd2WEF2RkE4emJiNGJrZVRVaDVQL2xnTVhTdWJBdXpxSGp5bXpXRGZVWnFS?=
 =?utf-8?B?VWJMelF5SUlHMTJpUlN4aFcrb3VRekc0bElDV1FXNUxQZjBCZ01raG13QlpB?=
 =?utf-8?B?SFRXdElTMDJuTHRUeEJ6Tk40OG1DcDUvRUVQK1F3ZHA5b0F6UmtLNldrYXIx?=
 =?utf-8?B?OWVNaHhvQnRqM0Vkdi83TUdpekFjSTQ1VTlqckcwbjNNazh6cGl3N2hVQU8r?=
 =?utf-8?B?K2ZvV3Q3YmZTWFNUWkhEVjl1SG5CYlRZMy81c1VUYngwbm9nd0VBTHZITXRl?=
 =?utf-8?B?bGM4U1REbDVsMFg0b0kyMW1PNEdwYkEvdHVlelBzOFUyaE1hRXZVc2dtL3RD?=
 =?utf-8?B?cTBNVVlJTU5iUE9EQ1VRUHlqajl6WncxRUlwakt5L1Z6L2dSYjYrdVVNcTBx?=
 =?utf-8?B?R2pNZkErcDZsb29KNGMrK0RVazJiT1F4OTVXOG4ycUNiUTRncENKWHVQODhK?=
 =?utf-8?B?YjJvUDA0cmZFRGFkMlk5VG01cEJNL2U3ZTZCUVpyOWJwUU9QcjlKR1lGWmtx?=
 =?utf-8?Q?5UZ35TOZJbY/s35pAYFSBz8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zpHpmDUyvEW6NOaYNkWcwl9jSwXQpfTovWXVNqA9M7fhQLf74sEFSpTvvSKXFYMit8ZIlnIWrd9Dj8+CpqMHBDFGl2wA6AqgmOLv131gdpxWl0xbGUayv/Bb4Zqam3h1GiRhWWv95uVJlWWry0YrAtZQnTqlJSCTI/7FY6C9W7Nkh53ggt9fEfO1imwbNsM941AzYFlCzgc0UYbTidMH/fILnVSDdgBD0xr0dzMQTY9I1p+HtjTfru8uY0k/7QQgRPKlISwdpZHijCb1NBkGraQ729zJQAHyMv4nL0mAVLX0dMAjjFKYYvYI5gni9YK5dKe63yx2bOPTXx0/btcws+KnwE0+KjQB4zfxTJm6w4rAJPuxUTvGGcccMYEjwue51he4RVGHFZ8nx2Nb8Lnam0Dbne18DbbpOCTO251uX2RXZDA/IwVjkdTmja7yVUTH2J3pIf4sAZDjfdZkQfx8/ag8A9eMg6mieYYOZ9A/GO7hKF7bqOZQ2Fnw6CshN2z70ijesZSAtqAnU1o0rYlB09mHFNJQ3GYq9wmY1BH87yvs9TB9JTjIaqq3RmPCVpJMFngttju+OSI5z0pUbDkmlNqpNJYuIGTpiuqCeh5Pa7g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76018456-ca71-41b9-17e6-08de2adbfee3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2025 22:02:29.6876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gIgtaXWgSf/tyDwgK/zsO4AXeMuHT6aJnHYMd7aGrYklpP7N+oz4kd8bimxtNdjlqTBkDidEQAMB14Jyii0lYrHhC3OXTuw5O2qVTGBm8Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB6000
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-23_08,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511230199
X-Proofpoint-GUID: 8Vyl-vJUN3JPmampYcDxN1ksc8mHPK2x
X-Proofpoint-ORIG-GUID: 8Vyl-vJUN3JPmampYcDxN1ksc8mHPK2x
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=6923847a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=KKAkSRfTAAAA:8 a=Ikd4Dj_1AAAA:8
 a=2AEByFHlyZO77pXZPXwA:9 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22 cc=ntf
 awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIzMDE5OSBTYWx0ZWRfX/9JRq3fvnVxi
 oUTgXCyvc1unGgjaFRvTJ0gGrmcQJk1uTZVPZ5UH3ou44iJgxEg/S+iIDrfmeyh4JuNc0o7bBgn
 nRhLQQhkjAqN3Eo+LaXHzxM3z3gIwrMfPV7iDhoNDhF2LU3g808kgUkdwOLZk76TXNnfE5Gcx3m
 8XFKz5zaMJNeL12u23qhRKmn8LqEi8Hw+Xdnrar4gG3jBGGUSuZxEQzMD6ALnRWmOihVq/IEdrZ
 VhX3hjucjTQ5Evqm3vJgONuJs7TvJyjrip7Qt9xNiNi0TdLFf5WC0oX6qBWi3lXf4hzug831oth
 adSchKUJpJkFrfWjAGVbG84duiBUO6ysEiagtGnC9lShokWVL6S6DH/1Nrtwb8uhT3ggbgQ/l0S
 ePzH5ppnniMjzfQGra9/pEHD+Fcoj12hGwpKfJvPDt3AKvL0g6w=

Hi Jason,

On 11/20/25 1:47 PM, Jason Gunthorpe wrote:
> Since increase_top() does it's own READ_ONCE() on top_of_table, the
> caller's prior READ_ONCE() could be inconsistent and the first time
> through the loop we may actually already have the right level if two
> threads are racing map.
> 

The only suggestion I have is to expand the details on the sentence 
above to describe exactly how the race would take place. i.e. in the 
usual style showing a CPU0/CPU1 timeline e.g.:

Starting at pt_iommu_$PTPFX_map_pages e.g. pt_iommu_amdv1_map_pages

CPU0					CPU1
-----					-----
make_range_no_check()
   pt_make_range()
     OLD_TOP = READ_ONCE()

					make_range_no_check()
					  pt_make_range()
					    OLD_TOP = READ_ONCE()
					check_map_range()
					  # top must be increased
					  increase_top()
					    OLD_TOP = READ_ONCE()
					    # new table allocated
					    # new table installed
					    # NEW_TOP recorded
					    WRITE_ONCE(..., NEW_TOP)

check_map_range() # still using OLD_TOP
   increase_top()
     NEW_TOP = READ_ONCE()
     # NEW_TOP read, early loop exit
     # new_level, table_mem not initialized
     [...]
     driver_ops->change_top(..., new_level)
     # records new top with invalid state

Regardless of whether you decide to include the additional details or 
not, the fix looks good to me.

Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>


> In this case new_level will be left uninitialized.
> 
> Further all the exits from the loop have to either commit to the new top
> or free any memory allocated so the early return must be a goto err_free.
> 
> Make it so the only break from the loop always sets new_level to the right
> value and all other exits go to err_free. Use pts.level (the pts
> represents the top we are stacking) within the loop instead of new_level.
> 
> Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/aRwgNW9PiW2j-Qwo@stanley.mountain
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/generic_pt/iommu_pt.h | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
> index 0e046fe0eea34c..032d04ec7b568d 100644
> --- a/drivers/iommu/generic_pt/iommu_pt.h
> +++ b/drivers/iommu/generic_pt/iommu_pt.h
> @@ -683,8 +683,11 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
>   		top_range.va = range->va;
>   		top_range.last_va = range->last_va;
>   
> -		if (!pt_check_range(&top_range) && map->leaf_level <= pts.level)
> +		if (!pt_check_range(&top_range) &&
> +		    map->leaf_level <= pts.level) {
> +			new_level = pts.level;
>   			break;
> +		}
>   
>   		pts.level++;
>   		if (pts.level > PT_MAX_TOP_LEVEL ||
> @@ -693,17 +696,18 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
>   			goto err_free;
>   		}
>   
> -		new_level = pts.level;
>   		table_mem =
>   			table_alloc_top(common, _pt_top_set(NULL, pts.level),
>   					map->attrs.gfp, ALLOC_DEFER_COHERENT_FLUSH);
> -		if (IS_ERR(table_mem))
> -			return PTR_ERR(table_mem);
> +		if (IS_ERR(table_mem)) {
> +			ret = PTR_ERR(table_mem);
> +			goto err_free;
> +		}
>   		iommu_pages_list_add(&free_list, table_mem);
>   
>   		/* The new table links to the lower table always at index 0 */
>   		top_range.va = 0;
> -		top_range.top_level = new_level;
> +		top_range.top_level = pts.level;
>   		pts.table_lower = pts.table;
>   		pts.table = table_mem;
>   		pt_load_single_entry(&pts);
> @@ -735,7 +739,8 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
>   	 */
>   	domain_lock = iommu_table->driver_ops->get_top_lock(iommu_table);
>   	spin_lock_irqsave(domain_lock, flags);
> -	if (common->top_of_table != top_of_table) {
> +	if (common->top_of_table != top_of_table ||
> +	    top_of_table == new_top_of_table) {
>   		spin_unlock_irqrestore(domain_lock, flags);
>   		ret = -EAGAIN;
>   		goto err_free;
> 
> base-commit: 30dc4423a35507df9378a6eb1a7104f788f4bbb9

