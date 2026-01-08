Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187F3E8C53;
	Thu,  8 Jan 2026 14:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767883065; cv=fail; b=tmQZZB0IKYhbPauHyedi5wl6GxyJRAoHpl2Chsa3ylGLJgTHKL+w13xDpMuazbNzMgFsEjNGAOwcgtw6QHrlIuXzNeALslLKzppKWnpFQoqUhTQUXYyJgp7OPHN1sKYu2WXNaYKMPibGQwFRkVlojBcQiif9kuar2uY+fUUDUtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767883065; c=relaxed/simple;
	bh=0f6QQ7VXgTzi6hJrovT2LPXIwz+OzalOwropI85ccvs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QmIJyVDxh5sRObesEwT0F/oINt+aoRvT0dRHZ1NAWYCm7wPVe/uL8dZmEzWfJAMc/02uzvMt5PoYc0VIRx35JnGeAkmbRYQ4QS+5PSG8rLJfeaoVa99EPPK1hHB3WjI56Hv0QZ13Zkn17Fy/y+Vw8cvYHAlulDwENamLHJBeVFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TvDYJWVm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vrt1o3NQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TvDYJWVm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vrt1o3NQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608E9tQ6284751;
	Thu, 8 Jan 2026 14:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=W/afcL5ZEszmfCzt3+EXlBE8kpWZPtFqhV6LUQVNzv8=; b=
	TvDYJWVmssbVj1RekjJL2QmP8upVnXUjfI2bCZYJLknzUJbqbBZkNFIVJSamq6M9
	tPGAJMiRAYhnnreC95P1fMn2Dth7jzww/DGY1HmXu7M338xJOSspiK28CwHpz7KN
	EB4muHh60FXVWAjeadc6ywtY1g6+vrsxtqwcvLOKF72iValKZQhsLUm1c2tR7wv2
	97l5pn64YuYpJ/760IduL9mE7WLnelBwOm1te4qeoCeEfZWkCFNB2DF+9e1acXVi
	KGAVhoUjBqlXaIkV+/miXwehxLDmT/XmzYj7/uyDasRMVBHgGEK+RuS6+jHRKyqM
	PA/Nht99o4RbWM26e0N12g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bje3vg1ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 14:37:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608Cijrx027379;
	Thu, 8 Jan 2026 14:37:26 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010000.outbound.protection.outlook.com [52.101.193.0])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjaw7pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 14:37:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oIWXE7V6xqzMRKVE5+8YqsLkoG53Y2NM4dTxSOAgV9vn27+WQGth1w3MPwW50dXsL88gvPLScr/bfqlcBcN1NF1wql/tMMk4eV4Eq6bAgBxE/arcrCPSLyS4zcqoHqot/Ze6VrQyC9utfHV5LfoO/Oxe8fjbzrnPwvNqMS/wIaVnzPx7RvMEhtzk6kQ+LKCoo8wDdiTj4g7m5LkOIgV/Dp5g2/1EQFDtlkj4AD5T2kaWowLc64bKMZrmTYc5WIjHh0EWhUK54GuB97yY9/T8h1uLa8CYCCnLFixfOGZoFuToaX0+i+97bOUXegQq5tkVGEGfn1fVz3loCP7bKhyZsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/afcL5ZEszmfCzt3+EXlBE8kpWZPtFqhV6LUQVNzv8=;
 b=VLcoOi3fNdF9u1A9LxOkjqTBB6kMNLuG1ZKUUX0K2EeJtQbv5MOQNcg1mk/ztLGvcuNCYjAhnnK2QtrX1XlEh+OQHrEW+WnQLeFPz96neLiUe+o1Kqzxw4JfRMMYScVmtKImghQvbGjfBXKEHIpbjg/yELG12I18qzk/i43vNyLIvPM6/8x5GjrivAegOhS3CIfZDfkTN9+hM0SRcMDc3d7cwuuco6g3HYwW7t+DkGU+dLkaz/NfPphP8zXrwsB6UXS0dWl3WBK9umaRsYSXWCOP56fMo50ecsslZUNeX0K1BvZs89qFOmsD1uvyIIHsAOVXdKEdrC0iMLnviD9JdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/afcL5ZEszmfCzt3+EXlBE8kpWZPtFqhV6LUQVNzv8=;
 b=Vrt1o3NQE7c4tKHqTABJFCqUkHa3qBWEdCv77g44X8bW0Wwz6JekWZVY0MVW+V+HuKqmhp342RwbjcF67CSu7V23dMLeC1dImYapVDir1y5WXom/A0XHmtkX6iwd5mGUbLdovjxmHwn4tJAnCols9VDsQBy13hsnoCIe2cS7Z6U=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by PH3PPF0C5C46881.namprd10.prod.outlook.com (2603:10b6:518:1::789) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 14:37:22 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 14:37:22 +0000
Message-ID: <81de8774-535e-407e-8b01-5676c2cfd204@oracle.com>
Date: Thu, 8 Jan 2026 09:37:17 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 1/3] iommupt: Fix the kunit building
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
        kernel test robot <lkp@intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
        Samiullah Khawaja <skhawaja@google.com>
References: <1-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <1-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::12) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|PH3PPF0C5C46881:EE_
X-MS-Office365-Filtering-Correlation-Id: a64ce2a6-8059-4ccf-bf11-08de4ec36f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VDBMbEV1RVpuSDR4eFIwdm5FSE9tK2MyMXEwdk42KzBxbWhrUzRaRDBlejkv?=
 =?utf-8?B?UHNFRnpMOHBGbkxHYWg4cUhXeDQvUkY2R1I2MTc5MjI4SnBvSER3UUJuSHpO?=
 =?utf-8?B?dTlTM3QxNmpaMG80OEpKbHA4MFVVeDNsQWVvK014SFpURmFMSS9UN3Bmclli?=
 =?utf-8?B?bm96c084Mi9JSDB0TnROQ3ZrblpmOEo2d1hFQmFZK0JqMG1qNHJ5Vm9peWJx?=
 =?utf-8?B?ejNKZ2kwS1dMZ2lxZjZlM2RwWHVXb01aU0xuSVdYcGIzcDFUcE0yaG1jR1dJ?=
 =?utf-8?B?L1pkYTgxOVZ3ekI5a0RVQmkwK1d0SWNFdVdtNHNIQjRydmRCWGRQcWV1WlFv?=
 =?utf-8?B?a2RBaVZjQ1pWUXhVRnBoeExPWWVjRGlodU4ySGg1cUZKdGJmdkVKNU5NbHNE?=
 =?utf-8?B?VEJmR2Nra2JtYUNvaHEvbDZWaXIzRVBIN0lJV1NKMlIvUTVxaDJqWG0wc1Jn?=
 =?utf-8?B?bVNZRXRlLysyTEJYSGVzS3doK2tZWnFHMzRMV2Rva0hJWG52VG5VMXRUNjZl?=
 =?utf-8?B?S2xHV0FCTEp5T0VROTI2dW9wU2VRZnVSMFNlMlZaTXZFdnVnSVlVWnMxdk9x?=
 =?utf-8?B?NVByclMrRGRBdzlZaDJ5b0l5L2p6ejhYL1VqVDI2WHVtbkVqeDYybUwrR2Ev?=
 =?utf-8?B?bE9kNktJUElMWGI3YlpWMjYvYVFLL1czbzc0YlUrOEdCaVhzeWlhVU1qS3FI?=
 =?utf-8?B?bHI5RkVmSGxzLy9mdVpNcXZrSHprZ0o2ZzUyM0RrWXJub04vbm9nMFgzNUZn?=
 =?utf-8?B?em5lYXgrUGhDMnlvOUhOalBLT013N1JUNnJLcVRBaWJHdmk4a2NWN3VsNXIv?=
 =?utf-8?B?b3ZTKzdReERpQS9JeGZVd0VmNXZHazhNYmhjOHhOZ0lPTlJLMlBUR0N2SXY1?=
 =?utf-8?B?cEVpMXl5TTdOZVlNSTlHOFl4clk2SUxGWC83MC9pQTl5dW83L05TOU1reHFF?=
 =?utf-8?B?akg2UmFaRGRXZE16VnBUQk5IYTRxYWZDY0ZOaU0wNVgzUFpzK25hYW1sVmdS?=
 =?utf-8?B?T2tkNjVXcUxrdFY5ZWxNcURxMkRnenF4MjhpUmJEczVhdFp2WnZ0SW4rQXd6?=
 =?utf-8?B?RUxVc0NZdG50SThmRi9VaS9PWUR2NWc1U1ltSHoxNngydjlVa1B1SnF3RmxG?=
 =?utf-8?B?b2s5eERDajcrcGlOZEhXSUVnV2Jic0JrOUdodVFra2F1YUt0dE5vK0pmQlNw?=
 =?utf-8?B?WHMwQlphbXdWaTdacVhlYzNZUHVkdStGaWdzdXlnMjNYVmUwRDVkWCs3US9D?=
 =?utf-8?B?TnplSVcvS2tKeE5WQ0hWMWlJekxRQ0VnamltQjltdlM4cGgxUDY4eTl3ZHN6?=
 =?utf-8?B?enVVYU82aE0wRzZWNzhrVWo5aURuOGE1TEQrTy9hL1FGVVpXN3Fqd056MkdF?=
 =?utf-8?B?QXJkdmVTVFVKaGp0VW8zRW96SFZtQ0JXRUpsYW0wL0FVMHJNQnRzUGhZQXNY?=
 =?utf-8?B?V0tLQ3pLQVljMlB3aWZpZG1rbHV0eGV3U0haV0NhdjVVWDdPWnFFeTJFQ2U5?=
 =?utf-8?B?VVlmT0dlUXo3Y2IyU0FGSklXV09hazVSbzE0YmhtTGlEaEkyVHVyNzRxb3Zt?=
 =?utf-8?B?dE82OTdoUU5RN3U4eUIraHlhYjE3T2ErRUY4Zjl1emFpUm9rUTZIRVhDVy9z?=
 =?utf-8?B?OGtFeStBNUpLRkJ0Z3dKWG0rN0NVbXl1UG5CZVE2UGhLb3AwblB1TzdMelVn?=
 =?utf-8?B?b0UyN3Yyc2pVRHJoN3pnS09sa2VoTkNBbkViak03YXJPTWtyZ09RQUJaK0dv?=
 =?utf-8?B?Z3QvK2dhcW5GdDB3SGc5dXBjTnNybkVyM1Q0bW9PQW9wSlRrTnJCYUNZeWhJ?=
 =?utf-8?B?SHUxL0UwNFpjZWplZ2Y3R0IwMDFvQ3dPZUJkM1RnNVRkQ0ZXM2FwMWg3aXZs?=
 =?utf-8?B?RkJ0SmJuSXZGaU1YM1lyYUhHTDcybmZuSHpRZFZQK3RLRWsyVXo5NUZ3MzJj?=
 =?utf-8?B?amt5L0d0YnBWb09XcG9rTXV0bnV4VFRNVVhicnd1aTIvbGNBSDFWOXFyN3d1?=
 =?utf-8?B?NDJLc25OUS9nPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzRuUVZpSGZxRDJabkpMN1VtYmxrc0NLQWk2N2pHQUtxV1I5Vk14eUl6NEtO?=
 =?utf-8?B?TXlaZjRYVmZ6dFpKeXpDSE9tNjUrNXJmUFk1STFiOUNMTzhGVEt4R0g1TVVG?=
 =?utf-8?B?RCthbUpibE9nRW1RbGNGaGd0Q2s0YUtHeVEyenIyc0ZsM29iODg1U3E0MXQz?=
 =?utf-8?B?ejhmekRqYUFTNXpPS3RpWWVNNko0SUpiUSt5TjM4aTdmWW9SbDVOcHowVDgz?=
 =?utf-8?B?a1FsSFgwbUZSVlIxU1FXRjE5TUR6Yzd4aWtwd2ZSeUI2c05xZldyVEpqK3BV?=
 =?utf-8?B?c1I2L0tsSTFaMGp1b01qZTJFM2RiOU1pZVJ3b0I2VFE0UHduZGI4UTF5cUJZ?=
 =?utf-8?B?UkRSaDk4RWZ5TDNaeFJ4MWdYd1VYU3NHczhMaXNTUlNTT21zNDdEV2tXNGJl?=
 =?utf-8?B?OHkwbDd5VzI2anZIcEd0T1Rqb0R3T3FteWZuUkhXM1dpY09PSDV3NE5Sdkpl?=
 =?utf-8?B?bVBsVERjNTREUmpaK3dDWmJGelJIM2d4dEI2RzNINGM0QjlEdUhBZHdUTlJX?=
 =?utf-8?B?R3RGZER5L3VURTJCYmpVUnR2S1lGSzAwbWo2cDRXalhKNFFFUVBpMGszenZj?=
 =?utf-8?B?bXZFb05hSTdNbE5vaVhaQ3BaeUoxblJEK0VmNis1dzVWalppRFdxck0rUi9L?=
 =?utf-8?B?WFhqZ2Y2WXRUd0RtMkQxYjBWMUJjU0E4dktEZk92WkJ0VDYwN3FkNm9KSkdO?=
 =?utf-8?B?VDlrSy95U3kyK09XM2VGUzJ2SS8zT0thRGhmcnpOOGpKd2pxOUE2b2pmaFg5?=
 =?utf-8?B?eHNhY1RqVnF4TXNIdFJaQ3M4NDRWMlpsYXhUbVBwUHBYaFpWalNrYWtQSEFN?=
 =?utf-8?B?K3RuajdWUHQ3SWFobS85VkxCdzM0WjlEVXpSdmVhNGo0cWNjL1Boa2VHQzlT?=
 =?utf-8?B?Zm1UWDRIYVcrM3Y0U0VFbks4M0x6SFBCbGJKaHBMVnNtbWFIMjJ3Z0g5TUJu?=
 =?utf-8?B?emkrT2dHMlI4WFBlcGJkSERUbnJLT3A3WGdzeHdSNk1saVJnSGJtVUI3QWJu?=
 =?utf-8?B?L2FPazltbEk2M3FnZEc1NmtkYU1GR25YZXk3dFBVQ0N6OGFYNE5jMk5FRFE3?=
 =?utf-8?B?YkQzUnZZbGh4SnA1T2J3WGJaN09RZzBXRWJobUZwUDhlZ1lrOGNrMkdDcDIr?=
 =?utf-8?B?Z2l4OENBN3N2U3NjUDE2ZnNCbmhEa2hrR2dnclBQSHc4cXdXTjBHTk1jZjht?=
 =?utf-8?B?NUg1TmN4QjlkWVZNQW5KU1lVMGg5Q3A3UjJvNFJteUdGdFNBUWNDdkxNdG5M?=
 =?utf-8?B?M3RHMzNaYXBNa1M4dE1yOWM2VzVHbjd5Tkk1Z1NNak1VbEtiWFNyQjdIeStq?=
 =?utf-8?B?clJCZlF2QnVMczB6QmJnc1JJTkdhdlhRN1JVbm9vWW5xV21udlJXRFRUK3RD?=
 =?utf-8?B?V0pCQ2hkbW0xc1k3dXJkc2ovN3h5SUFjV3RNK1BibHczN1NvQVdkSU5WMlMr?=
 =?utf-8?B?cUVlVmJacSt0ckR2cHZMNm5BYjBNRzRzU1JMS05YZnN2aitHazQyUWJwWXUx?=
 =?utf-8?B?and1ZlJBNitqNlJ0ZVFjUjkvQ1JXeGtBdFgxamtvOFl5Uk5KdFE3QXNBc1l6?=
 =?utf-8?B?NFp0Q2w3dkJGaHVoaHRwcmpoZUgyWElJcElYSXBmTVZkaFRzQmxXY3RnM2lZ?=
 =?utf-8?B?ZmhUU0xZY214ell5VWZpdHhSQjFjNmNId2tUbnY0UGw1Myt0aVl0TjJ2S1ZL?=
 =?utf-8?B?eE4vcnBtL3M3czVIbUU2aVhERWhjcHNyS3FWcUU3Mk5zOW1yQWp2eDgzcWlR?=
 =?utf-8?B?N0c5RTVaRHB0Y0ZFcThTYTZ3YUZkd09scEtSc0doWXQ0RHhqSlMzYUkrb3Yw?=
 =?utf-8?B?OERyTEdGaklXMnlGTVM5SUtLSFFLeVBZYmFQQmpJdmZVQ0JqMkFSVW5OT3hh?=
 =?utf-8?B?R3N5Q3NyOWlRWXBaSHF6Y1gwdXdVRVN0OG01R0xxWXB3L1EraEt5NXRiZTZN?=
 =?utf-8?B?QVJOMStEWkdQam1ibU1hdWlQSlJqVkdpU240WmV4c0ljWVJjSUY4VGkxTEpl?=
 =?utf-8?B?eGpNSkdvWnJLNmxhZysyWXg5YUxpbXRkSGcyM3E2VWJqeXl5TjNHZnlCUDBB?=
 =?utf-8?B?MTNGclBwTnJMREZXQWRBUFZ0bHE1ZEJvL0MyUGI3OXduWTYwMGpWNGtVSW01?=
 =?utf-8?B?YVNwejIySWs1ek05SkdibXZ2L2ZtS25rNVAramxDWFYrQi9Md2tzZ09WT3Nw?=
 =?utf-8?B?cTZBU0U5d0RQa24xQUJUbk94TldHVXZFazBsbUdPdVRnUm1PRVhucVRkRjNO?=
 =?utf-8?B?RTRVODh4WjVvWlNFODVBSzVhWW8zZ21vajlaTVBkNWwycVMrWmlhV0JxUmtT?=
 =?utf-8?B?enY3K212UFA3alVzcmkzTDdXZTljY3FnNDRxaWVtTkl0K2lpdDNZSWtFS3pm?=
 =?utf-8?Q?zFqU+0Da+GtkCdAU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lNMp7b9a+mOsXzUNrj8GDdEAy7JL+LzxvUfyVlqDaHhyrTGPn8UPp/5/1UbS4cJ12rwusOXvWbgljXxOgzQJSFk2Yfn0eIELmhDv95LRcKcrRfShEHm4y5h1Wne9rCQitLu7229JMAn6VGO32sz3pvWkxausc04WFajn9dOrZ4///5U2cXNR9Hzli++7HmDw2WxeuEZT5cdafddAK2KNbiwd67CspAImhDalO7n0j+DRcEEGfYZ2b3LX+w3jUpDao5v1Xq8F5eBwV/GFSDQ6gjCHfWpNewQnfTUsLQJr6pxNzOEOJyTupUneoXLaFXns2udh0BVyt+33PfCAUHXZW3RRRU7jybvaF0j9UJuxsBjIZOjf9Is+bXGp8f4l/NzLMhFJwUuA6/I/55OkxsApRyPLSQl99hzXIQm0vYiI868ObJqfwqYmuKL52JpgG9Uft+BHxsG9wVK//10RFt4F+SCs07IUnzduA6JrOc/+zi2sccEuqmY6nh2BK0Gc4qkYsTD0en/zPqweL5YKyiqwzFzWAoet9bYnLQavv6vmpYEU8g50wXATjLchi/QB7YkWTHfaBhd49zkhHHJFSef73Ng07s2faX1xcgj0cQCQHSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a64ce2a6-8059-4ccf-bf11-08de4ec36f0f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 14:37:22.3872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+D1nO8vFoFM8GNrl8QDIOYK1/k6JJNCoCaUrArwLTfIK4hZDs/kAdHIJk+uAyaf8m5QiHUYp+padQyZzZekAppaxolv2510CKgt3ELjswU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF0C5C46881
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080105
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEwNSBTYWx0ZWRfXy2vcmYRXJQHm
 5v2m1piyg+q27S3zdCp8UaUKWmGbEq39v09VOj+7d//efc2ArrnBP6PAslobushjNA8/n8HTcm6
 FXF+gEcUk20bXRhSygG0vEXT5443d+KOGc3epTkFAhQxri58mxh4bfo0T9UDv2Ye9I9e4AUu/YP
 b2B8zB2uRPerM5Ch5k/a9bfCH8ds4tTuxfliXf2gp57FtfaUeXZ7wvqcVXQVvJDd4m4hT/qoz32
 P7WyBvBXKYpLiERiRSut99dznYFVuCfpoY8cbJqL8qg9aQ0po8sxkjVIyYZtZ4zIHKc9dxI15Ua
 JfpsjXI0+dY206jOBhelJLftXmvCqZKS6edQo60wVhTzAmd2L3ZbWe2+3o9TNfF0FwAvC4G9rNd
 bXLR+jrOP2PExjT/WKxvlYsFfh/D0x0y1YcxJ1r2gGZmTxytAYuYzkaxWAcwlZQMqGEQxP3tdgk
 z42CztgzxxWuysOUwAg==
X-Authority-Analysis: v=2.4 cv=fe+gCkQF c=1 sm=1 tr=0 ts=695fc127 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=9jRdOu3wAAAA:8 a=Ikd4Dj_1AAAA:8 a=mAl92JaEnpJHcpIGmXYA:9
 a=QEXdDO2ut3YA:10 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-ORIG-GUID: 9JCxsNqa1UL16JMRexJIUZSc1b6QeamC
X-Proofpoint-GUID: 9JCxsNqa1UL16JMRexJIUZSc1b6QeamC



On 1/6/26 2:22 PM, Jason Gunthorpe wrote:
> The kunit doesn't work since the below commit made GENERIC_PT
> unselectable:
> 
>   $ make ARCH=x86_64 O=build_kunit_x86_64 olddefconfig
>   ERROR:root:Not all Kconfig options selected in kunitconfig were in the generated .config.
>   This is probably due to unsatisfied dependencies.
>   Missing: CONFIG_DEBUG_GENERIC_PT=y, CONFIG_IOMMUFD_TEST=y,
>   CONFIG_IOMMU_PT_X86_64=y, CONFIG_GENERIC_PT=y, CONFIG_IOMMU_PT_AMDV1=y,
>   CONFIG_IOMMU_PT_VTDSS=y, CONFIG_IOMMU_PT=y, CONFIG_IOMMU_PT_KUNIT_TEST=y
> 
> Also remove the unneeded CONFIG_IOMMUFD_TEST reference as the iommupt kunit
> doesn't interact with iommufd, and it doesn't currently build for the
> kunit due problems with DMA_SHARED buffer either.
> 
> Fixes: 01569c216dde ("genpt: Make GENERIC_PT invisible")
> Fixes: 1dd4187f53c3 ("iommupt: Add a kunit test for Generic Page Table")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Verified on AMD Zen4 host that kunit now builds and runs as expected 
with this patch applied. One question below..

> ---
>   drivers/iommu/generic_pt/.kunitconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
> index 52ac9e661ffd2b..a78b295f264d23 100644
> --- a/drivers/iommu/generic_pt/.kunitconfig
> +++ b/drivers/iommu/generic_pt/.kunitconfig
> @@ -1,4 +1,5 @@
>   CONFIG_KUNIT=y
> +CONFIG_COMPILE_TEST=y

I was wondering if there are any side effects from enabling 
COMPILE_TEST. I see that Geert had the same question on:

https://lore.kernel.org/all/20251120193326.GB233636@ziepe.ca/

and that you agreed with his proposed approach to do:

  menuconfig GENERIC_PT
-       bool "Generic Radix Page Table" if COMPILE_TEST
+       bool "Generic Radix Page Table" if COMPILE_TEST || KUNIT

(which also works as long as CONFIG_IOMMUFD_TEST=y is removed).
Is there a problem with making GENERIC_PT visible on KUNIT=y?

Thank you,
Alejandro

>   CONFIG_GENERIC_PT=y
>   CONFIG_DEBUG_GENERIC_PT=y
>   CONFIG_IOMMU_PT=y
> @@ -11,4 +12,3 @@ CONFIG_IOMMUFD=y
>   CONFIG_DEBUG_KERNEL=y
>   CONFIG_FAULT_INJECTION=y
>   CONFIG_RUNTIME_TESTING_MENU=y
> -CONFIG_IOMMUFD_TEST=y



