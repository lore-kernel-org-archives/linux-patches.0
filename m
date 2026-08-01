Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EAA42A80;
	Sat,  1 Aug 2026 19:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785610891; cv=fail; b=dQsmmgCQh2KWHnA5MMawl+FzN8zpqtwb13yvYXnMIdzj4qCkMuk2Fqkb9bKoHqw5Zh8p3Iyob59tuTCndbwL4ZpQ/xRjXE/FY2TTe1Kc3LVGcffPzv/3ueoEefNLl4rKMvmWguomCXQjMJCiC03banv21PIrQanbf5w0mfqd7YE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785610891; c=relaxed/simple;
	bh=LIM/6Hhfe0Zkc1XpVMDK6P83AHc0V85jw4CFZtp2D0g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hPgvhpqhIY+o0xiXtLXTBRcwMcye56kZbkIGCG0NQZ3/CdEVANpx/nkh8pNO+ssS7u7RrEDHEaosFdl6op6Cr0sTYx/8xv8SZkLMRzclAgDXhhC0gABP/JYnsyI5QweJwS0TZf4swoLkx355wSfNPBuctjZaW0Mh6IBJw4n6zNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p6lhRT2f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rFB2Y0KU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p6lhRT2f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rFB2Y0KU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 671IbNJA3850799;
	Sat, 1 Aug 2026 19:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HaOOt6CJzkqY2d4thcs8w5abUpSunAqepwT+F+34R1k=; b=
	p6lhRT2fYkniHIzUgC91y701TVnCqhl+ZCBR7BtIvc57q7qla19bA/kvp7T/D75u
	XO5q9/dNrvFY0VSF5sa20RzohD22S149MfvHclVEvpfX+HHweqbuTVbLDjll2Z9H
	2wu3lPpQMask5kQVAXFiXkUBeNyboYacrxMuJXa7lt3QJOxZ4tsYr2BV4C4lWjJG
	FdP/cvdeG1KyA80Kk7feVuAJ6JsXfvF3w0U3dv3yj/Rqq4I5zCFb8paW1DBEJvrp
	xVWRgEh+Z86c8WoVbkOaIVTYIGuLEc7DQHRqEEEe/ID2PXbfny11FOSaU9nrMv2a
	qKTiEAHEA5mz3vbW/1pZMg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8uga1t2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Aug 2026 19:01:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 671J1I0Z012612;
	Sat, 1 Aug 2026 19:01:22 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fs789gmp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 01 Aug 2026 19:01:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDJ7QmgswpBH/l6QZOuAUko9ef60dSUrEGCuyBYlDphi6OjGIKywhw5TwMuy068Fp8H6r/zn12qsJQDCU6ZCRXR8lSxELfkSrvdVgklh3QB5zXOvxIJEL5+d6m9hqYy8MCREjgBH0yEHlCOiY6l0SopY8SR+445vw5tnjYPa9USk6OCRbGoO9htbEVyUJdxyNnGCUpcDcPRt2NtFZOjlRYhVyxaDECdrXrvZn4Fo4pxq5jm6c1vhaWmy/S6PfmFbMDpAtrauHJlmGUA37oeOJSavGive5MMs5FqJx091zI1W2x5dKz/vi+ZRIDtz3s3h2nJj1rAVrrnc77/8Lik1aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaOOt6CJzkqY2d4thcs8w5abUpSunAqepwT+F+34R1k=;
 b=x/VXOZH/kJXTs66HQRAmRZkLi30VD+DuonfGErbtdL2U/PiSH+DyYAk5BK3I/kXeVcP4BWFl1/X2ZM0hXwE6f+OKkVlsJGAjNnHM+3o3jbrqdzfd4vT/2UF2qhKT3YMF+LEJIGGrf4E9TjQZPcqbNFX3/mZM7jxfzFPErvuY9En8dvlmhCsLoftb8plUGlI00dX/PENB3DcX/RPmp0XSa8LFaBBCzsYoNMyLzf6OEq2YzgL1RhO2fP4g6UeETsHGQUjUGdqlSTjmq1iF76P7nzfC4MRihSTGuwHZxp4UamarqWVMyJFk4zDQjgXdw2+ltIeanqt1ARJFjacVHSdulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaOOt6CJzkqY2d4thcs8w5abUpSunAqepwT+F+34R1k=;
 b=rFB2Y0KUFNFu/ShIn9hv7j0JxW0obxJnozd7akOmSa0vZaTzr6aTaBQX2OHHH2/j1tR2anIJthxHp95dad0SShZ9CvUXJcQu1NXAdYwZ/YcM01ElfSPCmW1gA7YpyqyCMX9SnWg5gPjkcFHO/o+xqU0vDyv29cNmvrVNGGOiWZc=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA0PR10MB7372.namprd10.prod.outlook.com (2603:10b6:208:40f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sat, 1 Aug
 2026 19:00:26 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Sat, 1 Aug 2026
 19:00:26 +0000
Message-ID: <f9d925cf-2b24-4ae5-91d7-ca9fd77155a4@oracle.com>
Date: Sun, 2 Aug 2026 00:30:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 597/602] Bluetooth: hci_conn: Fix running bis_cleanup
 for hci_conn->type PA_LINK
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev,
        Luiz Augusto von Dentz
 <luiz.von.dentz@intel.com>,
        vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141448.601341010@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260730141448.601341010@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0124.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::13) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA0PR10MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b53794f-9468-4921-51ec-08deefff25a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|22082099003|18002099003|56012099006|5023799004|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	Qjf81V209PaB4VZpfKsJZxT8M3YyJDOts++OtOS77SPoyMfP5h7uFZj27Nkmn7JkFIONj96UBJrNCLjrI1MS2stn/30zrFoAuxO+L/befVlS7o3B6mTQHB+uVQEDHEt3ZFMobA5ceeZtZBuI4J5t7uRvlz7fCZSecPkpxCBGIK1CxNB0OYmEWvRDU39/BmMguaLIxwL0thKwrc1gMVPU9mlV/ZmQo4YL3yXQP1k2i3MzXMQYZkikLFWjmDV/JbQUWS+Qys0Hn5VpwXWz2CUIdlltpYFuo1WG/oM7pVilwP0OffbRxT7FinJ4npFwBGSQq4nN35zH/7CsvchxRpLtQR9hsIxLTS0zeekYmZ0cKQ0LCYi+DdR7i1cToYrYHy6POdw6wnoDYSQI94sVexGD7kIZLDosO8tyb0yKkOBN5LFmFk3V3Uhh88buMTf/zu3wBubR13erIGVvCDaBeqnK4CUEyhXzBu+TZUDFUegLa+Gixpfg0Qy3cthdIUnLk+vWh/ANoLm2kgLlPYSRTKjOgUvV02gFx9LozdN8xC4jxsupxBABEvEK8yliAJKxWOhg8dVq9acnc941EQL9D/7hqV2gtCnGJZqZyCgVc4x35YjLWu684gp0znPV1Z7c2d041cn+2SgdZeAKNjb8twOP71VYTHpbdobVoDKkJVmrnE8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(22082099003)(18002099003)(56012099006)(5023799004)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzhJSnBEY0VEQ1lQUFl2eTBTT0FZTU9LQ2ZoQzlTb3FaMzRhQ3dNQk5WMjJM?=
 =?utf-8?B?NUFrai9UUjVSMFB4VHVZc0NyN2UzbHlFOXNIZ3MvOGh5OVI2NG5mYnFxRi9N?=
 =?utf-8?B?VTdqcVIvSFhPZWhEenFwR0lSWWdaOUpEMnpxYlJPajJaaW9KbEd3RzlvL3lq?=
 =?utf-8?B?alpxWkZNTjFHRlNreEVTVlFrT0hpbmxTaTBja1Y5RWg3bzJTR2lzR2NRcUtE?=
 =?utf-8?B?YlRxQzZUemQxR1VpWEdCc0hsK09UNHpWRHhRNjA2Z3oxZ3o5S1BCWjF0cWlh?=
 =?utf-8?B?NnlFMGlxUU1qNUo0MmF5aUJOc1lHVnlKNXdrZmxseXZONUpuditWS3Z1V0ZK?=
 =?utf-8?B?elFNeXNyelhkQ0JiWXo4SUFpOXdVTjdsVG1GVS9jdW5GR1dTUVlhQmFGRWRo?=
 =?utf-8?B?UXpHWkJzUzJHUW53YXFNWjlmTWxQcXltcjAxRElOMjBzb0Rvbi9rNVhlZS9X?=
 =?utf-8?B?d2U2MzRHV01WQzkrSkpvTXh3OTgxb0Y2SU1rQVhvN1R3b3c2K21uS3FOQ2Zr?=
 =?utf-8?B?RFRIeEJQM0k5c29Ob3VHMDZlR0hxTlVDYmxFNXZ3ZjlySFNDd3JHL0diMC9a?=
 =?utf-8?B?YXcwNzJIRGRQVTNBZVJQVWxvOGYyc2t6TW1BQy90Q0FzL0RXT0hEcysrb2o5?=
 =?utf-8?B?eE1yb0tFemlxWDN1NjhlL0x5NDBXY0pseXNCZGw0ZnhXSHBaYjhzY0N4bGln?=
 =?utf-8?B?YkdOa0VJSmY2WlhtWTVPOGtCaWVWS1d5VTdGUklTekNIKzVISTRmQmZKelcv?=
 =?utf-8?B?TThUL1hLQ3Yvc2R6YWtaaHJ1VkFXcVhrSERDbE1iYTJ1c0NmaHJWQlZGRVFk?=
 =?utf-8?B?MmFvQmpNeGZYU1pacDY5U1BBeWxzS1hwUlYwWXR6VndqcFFmbk9FakNsNW1p?=
 =?utf-8?B?ZU16UHNNTUdLUno5c291SFg4dUVybk8vWWRaSGRZVjY4bUtldXNLbGVybiti?=
 =?utf-8?B?alhPc05GOUhheUxiWVRnR1Rpc3lGMWxvSTg0WHhMNUhoc0dlS0dPNjVXRHdO?=
 =?utf-8?B?ZzhWR2NxbklZemt4ejNHcTRZTkVuWGIyQkJONU9CSU5XeTgwa0Y5cnk2Y0Js?=
 =?utf-8?B?dHNzTHNVVlRYWVNVZ0M1NkdFNEV3eVMzemdkT3J6RDVJcUJRMUhhL1VNSkNL?=
 =?utf-8?B?UGtiN1BKRnNZT01Jc25Gd2lXazRUc25CUlZNbGFQVDM2enhNeXJybTRWR0w4?=
 =?utf-8?B?TGlubElMMlFFeDRhVlRMU2gyQ3Vub203WnRjbFFXdDBRZGZJNURRUERhMWV5?=
 =?utf-8?B?dzdYRTQySTVGOXlraHlScHBNamI3NDJBQjhxbzViTzQ2ZjdTZVRzTUJZTzgy?=
 =?utf-8?B?bW1mZE9MbTRCem5UTkdCUEYyLzNkZjJSTDRBUml6SHBwc0dJZVA5dlZwb0Mr?=
 =?utf-8?B?NzQybVA1aHdHRDJuUHo5bk5XVjFLbkl3N0wrclIrUTR2NDY4RFMzcGt2MSt6?=
 =?utf-8?B?eTVWc3k1dVhWemFZMGtkanRQS1RhWWJ5bTNOTm5JM3AvV05YNWNzVzE2TytL?=
 =?utf-8?B?cHBGMWpLQkttYnFqVEpFeDlMUzRiUXpZVG9hV3NNWHYxU1Q3OVFiYVQrTWRp?=
 =?utf-8?B?dFFQc2tiWWEzNm5TTGo1Rlh1WGNzSnoxRU83U1NkQVFlaVFpaElPeko5ME9v?=
 =?utf-8?B?QThTRzI4QTZUendyVmROdURyc29YQ0xRTGtSeHA3dE43UFlObnRoRmtLMHZt?=
 =?utf-8?B?Y1RwMXo0Ky90YVhiVUJKaXNQVFNQUkFmdlk4VWUyVmhJWDFGWkhua0JQbTZP?=
 =?utf-8?B?RnRxZ3AzWlkxS21hSXBJNTlwY0twS29WMTgyamR5enpsUnhESzdFVnBCY3Y2?=
 =?utf-8?B?SitBaFg3THk3ak5HTFVtZ2tJZGdXaXA1R0FMaVBsN0h4YUU2N3QyQkVGZGlZ?=
 =?utf-8?B?elVNYVZaS0p3ZmIrRVhFakZtQkM5M0pHK256cnhlc0s3WStoc0JxNFF1dGV2?=
 =?utf-8?B?WTZTeXh2MGkrQTBTeFVQNXNjOHNmeWRvWVN6ZzFUWFZMa3FoSEEwRUREbUVl?=
 =?utf-8?B?RGlvSG9mNm5CczFmQ2pWOEdWRTFPRWx2dkZVMGFRRXljTzJKdjM5Y0NKZzU2?=
 =?utf-8?B?R1BsZDJ0cmlRVUhwNGNYakt4M2V2RU5rbVVpVjR4UDM4WnlDR2JpaTZ2aHRK?=
 =?utf-8?B?TWorckZ2VlAvMjh0SXp5aVhaVjgzSmxYMDlyczhINy95a3VVUkg5clRuOS9G?=
 =?utf-8?B?VlY0NStXQ0FUc3E1RHJlMUdGOFJrdExVM2ZmTVZ6WnZ2MUFiV2o0K2x1NS9U?=
 =?utf-8?B?ZnV2OStFWXJ6QXN6Ym10Y0t6dlgvODFQMTZlc0Q1Nmk4bklENjIrMnFXM3g5?=
 =?utf-8?B?T0lnTnowZDJPVlZMczhwU21qVXR1SkVDeXZZczZFY2hxZE5oOVYzNExFN0x0?=
 =?utf-8?Q?sP7vCNfkHBg/9He5UiLYCaqhOyGKw2dDtpEZy?=
X-Exchange-RoutingPolicyChecked:
	c7v+JrkfM6Ey1+PdYVie8dzLTun8Jb3b6CuQI9YWwisDGU+uxly6AVSpKG/ihkCAfRh54P3kls3DNvg5c9tgf4w0UqM0MSveByLZKP5BalBEMNBWdYKhY6cl0Dzl4LzPlFrbE9blzgAUgauBv3lVK7keU6Z6cyrsV+JfCHqYMSB+WySsDdpuQ8gj76MUpsn/L8Etr27rF2JryJc0l3breG6UUkjWBD2lT07QE1qrBZFhy4xRdAiOTakpv92rzMFrf2vaMxe0P2vrlFg+Aqjv8yQHJ9E89Cf6arJplC6fURLBggNdgLPooUSZzRYx8+ZkDQtcw8vFacCkjLl2uD9SOg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ANe33DYeZPmHimlAp75plRt7Sule7VilHsKyc7+yMljl16uMXqNllu6ceVGpIJHFagH/g45kqw8JbBSYcT64/5jcm8sY2DYtsc53TwWSpdPZvnypzeehJdoGMzRTs/u/tLKbCqwDP32atWP7Ov1M8Z0MBqBDZQKT4Q+0dCGDdeTDg9g67Epk8yMldM3bev2Kf4OwSI6Mjslb8gG81Ghf8hIMinRE/XB4jdzszl+7AOQxtbPy0jZ6Ihjx0VaW9b15Ir851uaNxjaY2ALRWaUijfKcxwZwq5pZTzDwMO3zZ9CIRCVRYFtD/FLbJXXORJwywXZ+hES5mZ651kDcyH+1FmFhTF8Z7MaxVgW85b1+YTH/I0YeiVZ53S/PqTyuVKIL60mq6cp1Nl2ai3dOTX3ZvqvXtCnS6Kp2j2vQ6x6wePHWmMUUnFjmI91uGo8+418o86DH4vDIVS6WHIzAQDFCVVtFS5E+a6rguLQ6GuMaUY19GxvG1RGJReSvHzRx22cXCcLQzUD3/a/sEYJz38axbY9QMB+x2g+HfTqgJ8NbqbmOCSMDGssO74y/65JDoYSYdpVunCqKRzbihtoo7l/3MNt8U+WkxAD07ZrYUC0c5vY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b53794f-9468-4921-51ec-08deefff25a6
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 19:00:26.1547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: suuoscCqh2UFlabZ4ifQHK9SDwaGr/ZsYdaGIFLI56s3TBSc8UXoeuYEJ/DlC0fUlMGKEyxp7q+6obs5ri+j3RgK8F7z64NOIowUUUTuW/y1MW59svLqLWUOeCP+toL0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-01_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608010154
X-Proofpoint-ORIG-GUID: w-3gVdM8qOFheJCJyKYFWwqIXRqJ8d4Z
X-Authority-Analysis: v=2.4 cv=XqnK/1F9 c=1 sm=1 tr=0 ts=6a6e4283 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=QyXUC8HyAAAA:8
 a=ag1SF4gXAAAA:8 a=uIJRfJ1SO2GLptHxrrcA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDE1NCBTYWx0ZWRfX5tFKMeWw/6gI
 iyK9vq8ZHdujUWcMTtEv7EqgyYMgSBGj2agmrdgD05FD7WuU6HrIFY5xYen4a1maPy4FLX+vgmf
 SDIzYn+TKnqk+XT/AngCTORpQJXL9hx3/VZWtK+2DW+VK5AKsvRx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDE1NCBTYWx0ZWRfXxUyIzF/7xcjp
 faqc0+/zEgspua23Yu+0PKEnoE4CicsECvmc6WPIGzkQOYCUQrxngqMp74F98jCaA8jcwQuSFjU
 sA1csi+tJ8ytFVZLBjn2nLvbADvKwTGUqUSL1hUuh/E2A1esZ9d/6LUgrM0C7eruP+Ai7LUpYua
 lidHoHrRIoAQazojFtO6RtA5L5ijHInlOf2lG34zOGZCTdeXj09tbr2H0T3UeuPV0vbIlHzuGGk
 UDbgxCrd3gf7k4oi5WuCcXdDjPlT8SNTxIO36RHmCADKrlnsmmGnN0n8pxp50DGyFIvT7K8AVAY
 m5m9tnFW0n5WUEn5mnrbOfQA5HQ7liiXh6f2Llp2OST/lrt6ADGS0W4wRkTpnkCVqN/4ACm+0ry
 Z2V1KoTZ4v8hYCChrzXdfXeCrEbRi+hx6rDXZi3HsBSpUbqsigXPp3/5w318GEiI45tJkyvlX5S
 kkHYfna7+uaqwZhqEcQ==
X-Proofpoint-GUID: w-3gVdM8qOFheJCJyKYFWwqIXRqJ8d4Z

Hi Greg,

On 30/07/26 7:46 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> 
> commit d36349ea73d805bb72cbc24ab90cb1da4ad5c379 upstream.
> 
> Connections with type of PA_LINK shall be considered temporary just to
> track the lifetime of PA Sync setup, once the BIG Sync is established
> and connection are created with BIS_LINK the existing PA_LINK
> connection shall not longer use bis_cleanup otherwise it terminates the
> PA Sync when that shall be left to BIS_LINK connection to do it.
> 
> Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/bluetooth/hci_conn.c  |   10 +++++++++-
>   net/bluetooth/hci_event.c |    7 ++++++-
>   2 files changed, 15 insertions(+), 2 deletions(-)
> 
> --- a/net/bluetooth/hci_conn.c
> +++ b/net/bluetooth/hci_conn.c
> @@ -830,7 +830,15 @@ static void bis_cleanup(struct hci_conn
>   		/* Check if ISO connection is a BIS and terminate advertising
>   		 * set and BIG if there are no other connections using it.
>   		 */
> -		bis = hci_conn_hash_lookup_big(hdev, conn->iso_qos.bcast.big);
> +		bis = hci_conn_hash_lookup_big_state(hdev,
> +						     conn->iso_qos.bcast.big,
> +						     BT_CONNECTED);
> +		if (bis)
> +			return;
> +
> +		bis = hci_conn_hash_lookup_big_state(hdev,
> +						     conn->iso_qos.bcast.big,
> +						     BT_CONNECT);
>   		if (bis)
>   			return;


I have run an AI assisted backport review and it spotted an issue. I
have taken a look, and the two BIG-state lookups lost an upstream role
restriction.

Upstream d36349ea73d8 has:

     hci_conn_hash_lookup_big_state(hdev, big, BT_CONNECTED,
                                    HCI_ROLE_MASTER);

and the same HCI_ROLE_MASTER restriction for BT_CONNECT.

The 6.12.y backport calls the older three-argument helper:

     hci_conn_hash_lookup_big_state(hdev, big, BT_CONNECTED);

That helper accepts either role. The 6.12 tree also creates slave-role
BIS connections during BIG Sync establishment, so a slave BIS with the
same BIG handle and state can satisfy this lookup and suppress cleanup
of the unrelated master BIG.

I think 6.12.y misses commit b2a5f2e1c127
("Bluetooth: hci_event: Add support for handling LE BIG Sync Lost
event"), which adds the role-aware helper and updates its callers, so we 
might want to apply this as well and then reapply this ?


thanks,
Harshit> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -7026,9 +7026,14 @@ static void hci_le_big_sync_established_
>   				continue;
>   		}
>   
> -		if (ev->status != 0x42)
> +		if (ev->status != 0x42) {
>   			/* Mark PA sync as established */
>   			set_bit(HCI_CONN_PA_SYNC, &bis->flags);
> +			/* Reset cleanup callback of PA Sync so it doesn't
> +			 * terminate the sync when deleting the connection.
> +			 */
> +			conn->cleanup = NULL;
> +		}
>   
>   		bis->sync_handle = conn->sync_handle;
>   		bis->iso_qos.bcast.big = ev->handle;
> 
> 
> 

