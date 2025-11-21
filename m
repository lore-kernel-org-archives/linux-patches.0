Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010003.outbound.protection.outlook.com [52.101.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB30B1CDFCA;
	Fri, 21 Nov 2025 09:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763718125; cv=fail; b=EXH9AMqWgDcYLC79Y8JkRHlHFTwWj2FqsiIJxRakOjBdpOfLIATxjcqfvfffY0ti+jx+fd6MXih87H3XUWQ6OOhueEiH7BKQsjOM16qFSO+EZZf30AHHKYj67dsoUKoh2tkIGB3C03ZAXuA3RZcAaJPb0pVfT/4T17FfDrE3nYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763718125; c=relaxed/simple;
	bh=YA9rtcIo1FMciVKieY2LNNKyYXPbUkiuidoTVh7p1gE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I3ZyQHhn41vwYSBpGEKR+KmBaxcyjzXXe2o9Yvq7EOq6XtkRwgyhV8KxPLKiWUZZVjkJhNzUOSEYeE3L/x+rZXXezcb+LCK4QtmpVogC89ThxqrJP25zJeWrwGmjSEyWKnviQEI91rwy+IhBaCrdUAW+vKVYVmEK4WGk2T7R4UY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z4JBWwYi; arc=fail smtp.client-ip=52.101.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z4JBWwYi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JiLRWI79XRSmyd622crp6JLpA6y7boqQk3WwFIpGMiwufTRet4FA1TpP3FUGHZDeHccaOKKFI8GvoqcIrbvEWA5wDamXEHKnUC21gBEC8KQO6/nZvLXGsuiqU1vTLAbX0tdsL0K8T2DcQ8nCxs7eOpPIixuWf8kgtTUV+wkMne7we9s6O5sN+bJetnaE0sIHlF3jQzll4ONkHDJ1i74YBYRcyul23FQdIdvfdvt9vXpX4LMBrxSErh2IcLHQ9YBLpYLErFX67KCP0H+GKu197rWt4/IcWRpQnhp2qVgVn7d6ruh4nrvqqOCc+2q8Rku5mU09sivHNYDwlkYIJWKjYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4BmiEv7ifXsHiFF/UjvEUg+nuIeBomtzoSNt5UjoyI=;
 b=Xc8VCFo41AJziYIJrTZAzEHDwEax22jyFXTNtLHesKNvkqgUpv6tOP0E2rwH5Ll7U3okJsjVk3zrRpN3F7Nd227p5k06cbZK/EQTV49e8ifHvAlZJfZGD9EeILh2pQnGEWtFcUojW2WCoIiRFqxEK0swRtf5UOoNFje6bQoVrCJ9udGy/cHsVDVQyY3Dgsik9wdzH4QXJR6XiCrt/LEBXXoA8/gkimRaU7AcaCBU/WAfMlVKvclDDXNgvOw5k1FtC9fkctXoD801epLjM46iHWiePnveOyHoK0TCY9P7jMpPwMsYeKKF4FIyJUXzn1pL9nhn0z3aQHSUh5J8iFKMWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4BmiEv7ifXsHiFF/UjvEUg+nuIeBomtzoSNt5UjoyI=;
 b=z4JBWwYikJOFn50GpTUp7eRGS0nKzYBjs7ZJcjhzKl5rVLVEphx4CwWo7MeKW8oev6R5qtG/w8ylI92IPjJ+HyfskXcy9PbqQGYqH2Y4tProXhngK9MY16v+PZ2JrHUUyd01/c0IND6Hawg6tdGYvkX5WUMbeVjVHVBNNNclfmc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 MN0PR12MB6152.namprd12.prod.outlook.com (2603:10b6:208:3c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 09:42:01 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::a5e0:9d7e:d941:c74d]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::a5e0:9d7e:d941:c74d%7]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 09:42:01 +0000
Message-ID: <690aa990-0bee-46ad-aa32-d4a380b56527@amd.com>
Date: Fri, 21 Nov 2025 15:11:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommupt: Fix unlikely flows in increase_top()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Dan Carpenter <dan.carpenter@linaro.org>, Joerg Roedel
 <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>
References: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0P287CA0014.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::16) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|MN0PR12MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f15a9ca-4042-422e-5e0e-08de28e23876
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0ZTRTROKzZUcnhHN0pBdnNwR0pqdFJwRHlPQndFb2NQaUtzZHFlUkVYU3Zy?=
 =?utf-8?B?cEhFUGZ2Mjl2cjZOZDd0a2ZTZEVMVDhSWk52ODNvVDB0d3RRcnYzQmVJd1pu?=
 =?utf-8?B?MkQzRENHSmFjU2kwdjlkMFFmenNkN3RqUEEwVUZVRlkzMHJpWkxLQU0wTUhx?=
 =?utf-8?B?TnMrUXNDM2dMMHlVMDI4NVVJMTQrOXp3bkd4VWt2Q1NNL2ZVdUZVeEhvWHNP?=
 =?utf-8?B?S1ozQyt0ZUFnakE5bjNES2dvY0NBSDFPN0crMS9PQnRySzBXalp6NWk5RmlV?=
 =?utf-8?B?QVVTRXJvWVk4ZzJhb3VMakZFZTRkcGgzZWlUR3FXMkdjcnVWRXVJeFgwM2ho?=
 =?utf-8?B?czcxUjR3MkhOTjFFR0pkSEhEODNibmprQ3dQdTRMUkJ4ZXhVK20zMkZ3Vkdr?=
 =?utf-8?B?bTcrTlM2VlNZbmRFcnBHWnZrcG9hL201bzI3S3VkWmJyWmxLVFdIWTlQY3Bj?=
 =?utf-8?B?K0ttSDAvNndxS0xYOXpTeWMvZnhhOXI3a1g3RzJaeDA3Y1BxdVlxWXpmeVJj?=
 =?utf-8?B?emgybHo3RmlqdHI4V2xMenpzOXl2eWFNMld4alhacEtwR3BpMjRqQTVIcW9Z?=
 =?utf-8?B?RzArRTZCRXdwUjRSZVp4b0FpOXczNnlaclRicStGL2tkMVpObnVTbmhYQkVo?=
 =?utf-8?B?c0xOOUxETCtWZTBJV21GdDNPOHYzRG9XSVEwT1hkTUdYVmI0bkhGc2VWVmlY?=
 =?utf-8?B?N20wd01WSCs5RVdmdUtxVWpsUnJkSDd5NUQwNWFhejZWaEpraUd2OS9FaW15?=
 =?utf-8?B?bU1QL3BpUGJUeDNNWDVBTkhETndZZXR3WGV1d0FUdjRyeUFBREl2VUdKcnJu?=
 =?utf-8?B?dkhGcG9vaEcxQXpya2xSb29TRmJDSUZoeHJ4NlIwN3R0dnhwOXZDZng4dmJB?=
 =?utf-8?B?NEtFVVI4dStRNXRYRmlMMVNsVXU2TjZjQ09RV3dSZFpiZHFGRnExenU1VDc1?=
 =?utf-8?B?eFUwOEZmUnlXZk1ZUzM2ZERtSnJGdFl0SlBLeWp3U2wyUW9iWndERUhZVzd6?=
 =?utf-8?B?SnJJT0M0ME5sR1V4cExtZkhSbmRMa2NJcVNNRXBBby9wMVpsdkdWZFo1Wnpt?=
 =?utf-8?B?ZWhUOGFnK1dDUUVJSjZxbU50T2c2MW9LZUxpaXRxbVZNbFhhcXprY0RLaC85?=
 =?utf-8?B?cFVNZm5TNlgzTU9WMkwwcmVoUkpxTEx3cWtGTUtwUFdqNjVrT3RxNUZxTlVn?=
 =?utf-8?B?R1RuTXNRRFFOSlRFSjNKdktjclJwOUJaOHRUWTRxZXRQTUlpcmQ4cGY4dTZn?=
 =?utf-8?B?K29saWdCZkhPcWl2UFI3NlJPYU1qUDZjNk42ZEhZNUdqb1hmN043KzlBQUZy?=
 =?utf-8?B?S3A3V0NnWFRiMmcyU2dHd1FOTkM3OHdoZ2tpdURFQnpDUFF2N1lyY20rSzYw?=
 =?utf-8?B?RS8rUTV1ZmZTRFJCMC84djBaNzllQll1UUJseXd1QWt1bEttK1hmakc2TzRh?=
 =?utf-8?B?NVZFQmtsbDVoczVha3pNVGc5anRva0NMOE5WTzlYbzR1cGdNRndWZkpsVHZO?=
 =?utf-8?B?R3RETFY3WEFEc3dhR3VBcGpqT3M4OFhUdG44eXF0T0JEbGhzVlV6MXZ3eDV5?=
 =?utf-8?B?UkI4ZE91TWRjdWdueXdpNTM1aTNzOWVMK1lZTkFHMFp1UG9INE9nbkVvKzF2?=
 =?utf-8?B?TndSWDFjb1pWVFU5ZGx1bmdjQmNqVTN3cVlEZVp4d09hZ2g3a1h1SVh0TXlP?=
 =?utf-8?B?MFNySWpWcWRyaU9uTHpaVE1LU0pBR1lFLzk5a2RDVERvckt2WlZxMjNOZStH?=
 =?utf-8?B?L1NzWXVSbnQxVGtqWks4Y3VqTHdwM1NXSUpYTUNHTEJ1NlRNbWp5YW80MzNL?=
 =?utf-8?B?dFU5cW1IR0ZXODZpNDRCQ2wrZ2RMbk9QTCtTVkNjZUdBcWJoTFZBUSt1cU1y?=
 =?utf-8?B?VXJrUytpQWRHU2lESHd2S0duc0VSTHYvOVhWam1HYmhLV2grTG9BM3p1Rk85?=
 =?utf-8?B?UW5jUDhobUNqK0Qyb0Y1QjlYSE1ISGNUeW1FOS9iaHRjOW5lbnBWVFluRjBN?=
 =?utf-8?B?cnZhcTlqR1FnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3JpbzZSWVJWU1d6eWtabnZhMVVPUjhaS3NaZmozQmdtUHRBZTMrbVBha1Vr?=
 =?utf-8?B?TkE1R2psdHFKUGduSE9qaXR4OGUzRUIrSnN2RTkwQ1ozYUJ2QXVtQ3F1K1NM?=
 =?utf-8?B?L0VkNXZPTElsYnlqVmxWY25LSVN1YzJVWWhNU1FwbGlBenJKZCs2MXRTTGp2?=
 =?utf-8?B?QUtTNVg5RTgycVhyRjlnNGtyNmp4dWtKOE50dHpCK1NYNXIrMGF2Ykt3T0dp?=
 =?utf-8?B?Qm5zeWpRamZQa2ZEa0paajc5Sjc5N3JPQ1g2UjMrNjBvQ0tPKzErZVNlSHl3?=
 =?utf-8?B?d1RFdnNZc3kwRWo2SXZTdmMvUmYzTTBMQW13SGJsYUpqSllJWHlVVGV2aEdV?=
 =?utf-8?B?SzlBVXRWekI1cTQ0NHBsYnB1Nnpwa2RlRGxzNVJhT0tKUzZtOUdwbVptNkds?=
 =?utf-8?B?dEMyMjZyT29vbkl2MVZkN0tzc1VFbCtYNy8xNlluSE4rUVNVN1pUeERqYmRK?=
 =?utf-8?B?a1owSTNJWlhwdk9MYk9NSkVta2tLNE9tSGh4ekZwanVxR0hHdUljelRnRnFE?=
 =?utf-8?B?OXFROFh2OWNnWDBXdmI5WkU4L085cnBHVHJuelJrcU10SE03MVlKQ0xleDk5?=
 =?utf-8?B?MVlURGRVMWlObEJzRjVtbDRERDUzbXdLTjBQRTk0aCs4UEhOV2tkU1JMbVJ4?=
 =?utf-8?B?TC9tQyt2K2NNSmlhM0FpQ0FsOElwQ1FVOEx1RXBFK29IMmZSRFRwQ0VEVHJL?=
 =?utf-8?B?YUVyZ2ZQcm5oUk1OaDJzaUkwbEJsQW9tSXQ5Ny94UCtldi9VNWNSa0RSc0Ru?=
 =?utf-8?B?akFiYWNqMWdMWXllVmtMUFZhZktNY3Bab1Z4Z2xvWkxKaXBRWXBsSi95S1dP?=
 =?utf-8?B?QzAxanhMRWR1Qjg4SHcwbUh4Tlg2TEI2RE1qOEpOTHVIb0R1Rnp4Mkl6SnEv?=
 =?utf-8?B?YnVMQVAvMDUzTyszZVNPV3R6WnlFWFI3QTkzZ0gxK2xzWG5ZYzNieHJNOVVP?=
 =?utf-8?B?L0xhVDFEYk5UZXhDTWhLWHJsN3M2QzllUk40N1FlN3J3alptS2tyTCt3dGZJ?=
 =?utf-8?B?dUxlYmZqWnlTa2syQmkwNnQ1bFRhOVZveitQUXlxVERzWUJCcDgzUzgzME1E?=
 =?utf-8?B?elIvZzlLZDhFQ1BLS1JRakFoTkMyN2V5UHhncWNtQTVkb3JuVmQ3R01zYjNR?=
 =?utf-8?B?ckxubXNkU1M3cFRlRm5qWUliVGQ5VUFuS0NzdUk4SGIwMWhIeDFMVUZOL3FP?=
 =?utf-8?B?Z3dZOFZjaG5FckRXcGhSTVQ1TjVzT1poekFOSFpFSG9DcjM5ZWNXbHhKY2FN?=
 =?utf-8?B?MDNlSEFVTktDN2hNalllYXJySC9OUGIyM2FsQjZzLyswNU52czhoTkRMYzQz?=
 =?utf-8?B?RW9yNVpEaUVRTCtQcnVpK2tOY2FOQlArZjg4cWJwNmJ4c1FBbW5qalhRRW5R?=
 =?utf-8?B?KzRvdXdCdjFkd1lCNGtNQ3p5R2V0eFNhY0tEVFc0V2JhelM3N1c0QVVhS2R0?=
 =?utf-8?B?R1huOXZDTzlqV3lFQk5mQmtvZ0M4dEdzRkpDczNRMUpoMWY5T0lXdWhRTm1w?=
 =?utf-8?B?eWxMVWNWc0taVzJNbnFRUDdYMWxmQ2dvcFRNU3l0MnpzQVZvMmVodDhCc0tr?=
 =?utf-8?B?MjlnM1hrdUVkN2YxWU1wSE5WSFpmM2NZMkc2Sndqd25NVEVDRDJjampXMWRj?=
 =?utf-8?B?cm1Ea1NMdFVxUUQ0LzhCY25tOWh0cjJMMjJPMkk0QXQxRSs1Q2xwemVGWlc1?=
 =?utf-8?B?T3lNMlhjL3lXdlFQMXRLajNVcGlUeE1FUkdyeEhBcEU5cVp4RzhIamRQNWlI?=
 =?utf-8?B?cjlRU3ZtNFVBSSt0V3JsNnBiWlprcmVtSlRmZ0wxbTkrV1FDaHZ5bUhHcExt?=
 =?utf-8?B?TlNMcGJiUWloQkYxNzNhczlFODY1RE1xVi9KVmFEblFmaUl1UnNpWU9pYmZJ?=
 =?utf-8?B?Z3IxeStGTGZlZVplU3BLNTgyVTZsQUJvSEZraHlsZG9Fa1VYd25xK1NLQ1VW?=
 =?utf-8?B?dHBDaUJKclhCRVl4UzlWY21reTRYeE5oSldNUnZxOVlqUHJIVmtKV2xWWUdL?=
 =?utf-8?B?Sm5pUm1wYnFBOHcvaXlEVFJBMWp3OGVtUTVBUGlnYjA4Z05ZdWYvQ2xYS050?=
 =?utf-8?B?VGJZQW1vYzdzYXJVNHFGWWNMV3p6ajUyeGQ4RU1BelpkQWJtdTBhS0RJVS9K?=
 =?utf-8?Q?F58ZaXKnsRe/ZUQQJFq5CjXYp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f15a9ca-4042-422e-5e0e-08de28e23876
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 09:42:01.1816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Av4OKAURTRfiDTcwwbTWWlFEljBNY29upE8DsRBxuZY16wZGzh2amWiyLosCBjdQiAnFzj4naMc7FD3fGZZXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6152

On 11/21/2025 12:17 AM, Jason Gunthorpe wrote:
> Since increase_top() does it's own READ_ONCE() on top_of_table, the
> caller's prior READ_ONCE() could be inconsistent and the first time
> through the loop we may actually already have the right level if two
> threads are racing map.
> 
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


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

