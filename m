Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390E17E9
	for <patches@lists.linux.dev>; Sat,  7 Jun 2025 00:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749257836; cv=fail; b=Y9v6ZR0/zyFVmo+XyLt6fSremz35AQpv66dOABfiMxEchdYP67eWdd/jyf/31ekTNN06eG/58r/NYTkq6arBf+C4oGHBZamC1ukvdH++OcTcrgDuYxM2JEz3uaHLshbqS/frJ9pZE9HXTuCqE2s5tquW0CFlVuXSCf7UNo/Lwk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749257836; c=relaxed/simple;
	bh=FKacsvg2qpfAGmzXbpac4I67O43lA/UBMRutT9vUrEM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qaVjUF9qWQ6cRAoT+U1eExkIc8d+rUl+EvufqshRQoos5GhZJ8SiPdQxvk+5VkiNQy80/tIFSGG0P5ozOUvqLR+Z/x/ANgm+Hh196AvvQTgs1XOM7Bs+C/Zm5r8f9ukXamN2TQwUS6h+jWfO4SnTWSjbspTullr4BvvUyTt93E8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ksYyNNGB; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ksYyNNGB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hz0BaWYYvJ4c80Gd2o5kEMRISzUHDJDVre4CvY8EqXfkC9HzUX66L6B0qBhp01taz3iL5i0A5yk3gHFytTydvAmqoHCN0Z53fjDAlbvtKJ1N9hE0LFvNleVBcAka6xLpoHar014lS8ladSERc6szrdx1xyqvU3dGwuHYEQTvwTDvDCrJ2ARWMUuQeaVzaFqWfv0qxHEg4Wc239lQA9bvQLC016ay+/zu9ctFtPSh+3VRpC7nM3b8gl9CG2Pg0ATsPGKxMB1+7xr0ssi0F58yR0vqXf+T4JFqYdgm3737Y2elEO0tGFaMUhIY9+d94NNLRyPVZOEtLFQTisIMzJ+KtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMFDwW6wP4qfvWPic/ZlbRwLZqskjPoIfT0MGs98GYg=;
 b=APfbJSWs30xNwhvoK7YaLRczDU1h90KUaZdrzGZmTB98oLn1MeEg8wjKjLvXcc4ZBC1uRGD3D/FWgBhU/UYRBPEidSi58hjxxjr6fILjbQ4n+GkoKHZnlyEL3oy4hirG0ZWhN5vx96H3UpUgE1eTNIi+3Hp3RFbIeqAkEHy7LLaOg63rgXTzKDi0WMXDlIISshfY/s1gobkFfFRKanYisi9ih9cjhthhd3+NG4nriIWuPk4ucwk1evcMj9HElVa70sK8CpE06e2bOhgN2/doHnXrnEWOdz3+6WhuHiQe4DxAGRJM6JLH13zGDr2gL8SeIFwIvJf7Wklv3Rc/TuqegQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMFDwW6wP4qfvWPic/ZlbRwLZqskjPoIfT0MGs98GYg=;
 b=ksYyNNGBmalN9Q7ZjirFSpmFxDpyVXzp7KEbLDT6AmQEdNxDbnwtbqy9WjevwzNpnp7wBJEGdmwgagJ/UGE/w0nhFLegVPn7JkOpznCitxt3yViEjE5mLA0GUD3U+e02KF6fDvZ6AtZi7iOF5XFWtTVw4zog3bTL6SYv2PDwcCYPDsb0yA9Yp/uWuPSmhI9/vsMCE16dK8s6BvLtv7eMGZGbT0plCoVlINazzzEFFi3CX5H+wwhBT0mlLjtggSYWrYhmXXKXYxM1bd0rppv6PmdM08YzXHyS/NXCYXp9TeqW9MqIgiVRUFjdm2Uc1P6eJtapsN2Fj5vTA/05RmC0IQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 PH0PR12MB7930.namprd12.prod.outlook.com (2603:10b6:510:283::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.35; Sat, 7 Jun 2025 00:57:11 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8792.034; Sat, 7 Jun 2025
 00:57:11 +0000
Message-ID: <68782596-4e0a-429a-9456-e535faadf465@nvidia.com>
Date: Fri, 6 Jun 2025 17:57:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/29] x86,fs/resctrl: Fill in details of Clearwater
 Forest events
To: Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-21-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250521225049.132551-21-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::17) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|PH0PR12MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: fc03c56e-5caf-4750-2ff5-08dda55e3c3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmRDRTBXNExqc2tDRUlnRnpWQmRRWTQ1R1MxNDVEUHNKWHhLVkU1QnV4MCtt?=
 =?utf-8?B?T21SY1pwYkVOS2dlVHNYMm5JVXpGbkNHejg2VXhXN3YrejQwK2FlUktqWmxM?=
 =?utf-8?B?YnYvc09aOTBZMVJvU3JhT1ZHL1d1b20zNEE0UG53dEpNK0VvMTBRMnRNSEJh?=
 =?utf-8?B?SDdMVXpHcWtZRlR3Mkl6K2c2SEM5VFlZZ3UzUlByUW9MOW9ETFFvZVBFN0M0?=
 =?utf-8?B?VkVxRTBJNlRBczlueWRESlhBRU9FbXpoeVlVSll3aHRMckdjUDhpVVhBZE5R?=
 =?utf-8?B?KzVZNTVQVDU1VDh0Q3Vhcko2OGd2Mjh6U0RZa0h6QVdNSlRxYnBYZktqN1hB?=
 =?utf-8?B?QzQrMG93YkNvYUtaWnFHVTl0QUc4aTdSbWFLQmpkV0dIMEQrTTlnYXRvNWdF?=
 =?utf-8?B?VUxrM0kraXV1STRhUW11d0Z4RGlZOHZ4Y21YL2l4ZXJsaUFXRnNJR0o1bEg3?=
 =?utf-8?B?T1ZzL2JyeDZReXYvRmFhTzNpS0JXT2ZMVzRNR01RdkN2RVV6aVV2OXRKaUZX?=
 =?utf-8?B?WE1sbFNzei83TlUxWldFaTV4MEpLQVEyOVNGci9RRlRqWHlPYWJMQnpmZklG?=
 =?utf-8?B?b1FueWVMRWJkUStZNkxURjRNcXVBQlYzT3FnWCt1dXR2NUhla2FaMDVPTTFk?=
 =?utf-8?B?RnlGSmppOE84RDk4TFpsQW1iazNTSlRrUmtUeGZPYm5DTGpHUHNJV2N5RVdG?=
 =?utf-8?B?SWtxcXRiTk1FeEtJbVJ3SWszaVVpOTVtM21GVEgzWEpOL21TNXZxU09oaFZo?=
 =?utf-8?B?LzFpVzRkU2NGbzNlbVpPcUNGQ2VYTDJFcFBsWG1ITzNNVXFZVE1ld3FCS3pY?=
 =?utf-8?B?czJ0OWRHQ290V3F3RG5nZVdSV0VzdmgrZFgrWXl4YzY2eUt4TnIwajdqTFJz?=
 =?utf-8?B?OER0SVpZWVJWcmJjNWVuMzI4bkdWQkx2SlQ0TndNMXFkZmFqNUlEQ0JhS0V1?=
 =?utf-8?B?SVVuZGpjZ3J4KzQrYVJsQUwrZjdWc1FLZzVXZDVDeGVIUTNYeWVNK01zOVJl?=
 =?utf-8?B?ekUvNDVaOGN4ZDRRK3VBYUxFT0ttNllmVDVLTzJ4RkhPSXBJa0Mwcyt5MGtR?=
 =?utf-8?B?b3p3ajVGd25zNzRIVktyV3F1SUk5QWlpbjRDa1c4MGxLQjV0NVlhbnBjblVH?=
 =?utf-8?B?N1hOc1ROVUFSZjdkb1lTZVVYVHJvaHZRVDhaT3dqZzN3c3czZlpOQzJCNHM3?=
 =?utf-8?B?bXJzNGIyWHc5L3Q0bEgycDNFMllyU2ZqcmU2SytETjNOTnJNSVJCZUtPYmVI?=
 =?utf-8?B?VHNDeHNadk9MbGtuZWdqTkoyc2Fab1phbXB6aVZBQkJLczNUTG83NnFvc0I1?=
 =?utf-8?B?YVdzbjR6aDJUWTN1R00xOEh1TmVKTnpmVHJKSVRnK2V6NnpXcERpL2xSaEdi?=
 =?utf-8?B?c1RhMHZlZkM0emNPcjhqdGFtaTZWVXJLYk9NbDFxS2w5aWJhU1VpMThkWmFl?=
 =?utf-8?B?UDVrQW44eFY4YmNBRzJUMG4wdi9XVEJ3REs2UzVrUjJaOStBRkgvWU1oR1Ay?=
 =?utf-8?B?c3IwaFlvTGRxWitFbjNMOHVIYWZDQ3IvMDVydit1NWcvdXZsY1MxWmdkRVFJ?=
 =?utf-8?B?NG9zbjRaNTBYZTVCNmROd29IM3Y0T1N6ZlY4c3dFajV6MXV4MG9ObEF4R1cr?=
 =?utf-8?B?YWppSkl6cmdRQzloK1NRaWVCZlpGaVBJWHR2N2VZK3gzZndKOU0wbXovQWRB?=
 =?utf-8?B?WXV6ckpsZ0JWUVRUTWptUk93VmMzR3RrZFJaU2ZGWldQRnEyV2VaS2NEVk5N?=
 =?utf-8?B?SmkwTW9lVEdzdDV3akJPUmF4YmJraGxxUGhPUUtJZlFKRmgvL0lCbm9NQU1B?=
 =?utf-8?B?Skc4Z3dWdUFrdVdQT0UwK1d5Y3NHc1lLQkpkKzcrQWp0SVFSaEZqekZXczlw?=
 =?utf-8?B?VVVaV2h2SEU0QlBjNUl0Y2RaTTRpRXNjUUhMZld4YVVUL2tyTVBrZklOUnUx?=
 =?utf-8?B?YWlRYWhxTmV4aXdZQTc1aTRCb2Z4bDNjQVVXQzNKQUFWUGw4WjBVZzNzZ21W?=
 =?utf-8?B?NG5oS2x4bm9BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmpwQXRwcEl3Kyt3Y0NFRVhYS3A0MmVZQk4rS2NQeW1hWXlhVUZqemh6UjQ3?=
 =?utf-8?B?QVA4RktST2FoVWlobUVPK1YzL0ZWMWxBajd5am1SbVA3V2cycXkxbjFPSDZr?=
 =?utf-8?B?YWxBdWlUVW1qMDFCaWlvcWdrQWo3QTI5T3EzMW95cmI2MVZsazVaSnRSMHlR?=
 =?utf-8?B?SjBRZ01pWHRTRjAxQ2xURDQ2QlM3UStvVWZNK3dNa1htN08yaW9WNHFMaTNG?=
 =?utf-8?B?bFp3Q2I4WGV5cHBPOXRpeENUZjZhRmhyTzYwRGZieHVTSmY5VHZjQ2JQcXJq?=
 =?utf-8?B?OWJRM1ZGcDYyVXNacFRkWTUyRVp0d1FLZDJCK1NkOG5WR0N0YXJPRkFSdDRu?=
 =?utf-8?B?VHV5NWUzdUtFYUkvU2hPclBidENQeDdET253eFhxKzk4czhBMU5OQU9XSFIx?=
 =?utf-8?B?MzlSMlpTZjhFNHY5WitTcGdaU0Z6OVhsTUhkRUh2Y2E2YWlpb3VJRy92dGtO?=
 =?utf-8?B?ODJCL21DRk1IUG5SYUIyZGFhOFFYa3REaUFMVEdlRDBHU0cyTWZBSWEyQjBR?=
 =?utf-8?B?K0crNEFmOS9sOW8vcVB3TnN4UUZsSkRWNXNXRWpROHYxMHhvSWk2a3ZzYTdE?=
 =?utf-8?B?SGNWRmUvalZFYkduRTg5aXdYN0pLeXBGWmJuSisxandsdkxraDdPdERWR3Qy?=
 =?utf-8?B?cDdHaWJtelN5QzZERmlaRU5QaGN0WWE0RGlRVVg4SDVaVzZLNnBVcXhsaXYr?=
 =?utf-8?B?UTRxV1Z5cGFsZVZNK2FsSCt1SEEwSWw1dVBXTHp0eDFqVWhDd2oyMW1DZjFS?=
 =?utf-8?B?ZENPN1U4bDczWWtISko3dHdYQkRYNkNGd2F2ZXkyMXlPNU1aRzdqQ2d5LytW?=
 =?utf-8?B?Z1dxTnFBMjI2MjFVbW9rWDduNHFEUGE0bDVyTkdnc25PQWQ1dWVac2hvaWxw?=
 =?utf-8?B?NVpPTXRGSGk1NE1iWk90QWFQUXA5TjgvbHdpZ1QrcUltNVJHdERDNGY4b3kz?=
 =?utf-8?B?N2tCSWhMNlFwTFZGVG9naklONDFvK1hzNWRYVGRaY01GdmNnYlZUcTJRTVpM?=
 =?utf-8?B?eno1MlBRRkU5aG1wZ3dwZVNQSXJydFhiamN4RjZ6RTV3RlA1Y2JubytRUVJq?=
 =?utf-8?B?QzZMVit1Nnc1a2NPVGRYVjdOYmo1UFlMUmxKQVVzVzRJMWhWU2dYUWkwM05k?=
 =?utf-8?B?RDI2UXRtbnRJQUF4cXNuWkNFbTh1WklnUWJzTWRQYVRiOVdwdEkyYk50TG43?=
 =?utf-8?B?QVpGZkttQUtSVkN1bzJWUi82bVpNQjZXcUhMeGF3a0VhYTZZWWNFSytxQTEz?=
 =?utf-8?B?Wm9xVURSU2dSYWxWQ0lITWZHWE84WStxT2pCb0JlVEFleTAzSU5JZXowUkVQ?=
 =?utf-8?B?WmgxdUp4SGdncnYwR1ludTduZDVCN0xuWVloOFJ5WGdReWltVTdGOVQ5cXc3?=
 =?utf-8?B?Vngva2VXZ2hMWW16SU1YN2dRYlpXY2dDU1ZhTFdCbnhhelpJL2lzV0xIRGJN?=
 =?utf-8?B?ZjB0UlBaNS9kUlA4QnNvZUZXVno4TjBqeXp1YWpMdVdGeUtzZCs5SnFocG9p?=
 =?utf-8?B?K0FnRzBpOW5sYWFnQXZURHluaGdjSmVQaE9Jb1NEZHRkN0FML0hneFo2aSto?=
 =?utf-8?B?RDFTTUtMYW5qZDM3dzJYV3Zha2VUaXZMdEZIT3lQRGNOQmR2SHg4a01CU21X?=
 =?utf-8?B?R3NYeW9vQXFGUjk5K3RrNUNKb2dIRmx5aVg1R1R6MldLTGRjRXJCMVczeWky?=
 =?utf-8?B?WmJxL0RHZXRWZzhyWUhUb1dmaEFoeHJlTHpqRXBiaW11Nk16VC8wYmFpekVu?=
 =?utf-8?B?UHhOZXYxVVJtQ1hrNUxLbEUrbVpQUWJZcnRnb3FlMGc3N3h5clRCc2JYMXhx?=
 =?utf-8?B?NWNqRklMaUoyTTJiWmRYTnB5VnJiYVJ2T09aTkF2SWhGV0MzcklmMnU1NHha?=
 =?utf-8?B?QXNYdXMyTnIxTFJsYWVLOVI5a3VLb0NWa2RBVGU2Y3M4Y0hvYUMzN0xCczRh?=
 =?utf-8?B?cUxXU0FDK3dudUtVOVBSSmhMVThSVmU0Z09JNVFYU2VHSFd2ZTF2L1cxQXI2?=
 =?utf-8?B?ajRDTFNObUlobDZJSkFiYkp4aEJESlpPSWVoL0hFVHh2RzdUSDRkbmtoUFFD?=
 =?utf-8?B?ZEg1Q2c0bC9FYlhNQlJSTkxIcllXRXRqK2xVSmZDVW1FZVRTOEc4TmRiaUNq?=
 =?utf-8?Q?pzV/k8Y99JZ24ah1m+/Fx0DXV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc03c56e-5caf-4750-2ff5-08dda55e3c3c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2025 00:57:11.7158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lt9cdD2rLR/+f2CpEgeoXiAlbxLx+XZUn27Y6p2rVfILCIDUEoflLgtpLIHHFEAH/MeugKImayaxzjujEEwOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7930

Hi, Tony,

On 5/21/25 15:50, Tony Luck wrote:
> Clearwater Forest supports two energy related telemetry events
> and seven perf style events. The counters are arranged in per-RMID
> blocks like this:
>
> 	MMIO offset:0x00 Counter for RMID 0 Event 0
> 	MMIO offset:0x08 Counter for RMID 0 Event 1
> 	MMIO offset:0x10 Counter for RMID 0 Event 2
> 	MMIO offset:0x18 Counter for RMID 1 Event 0
> 	MMIO offset:0x20 Counter for RMID 1 Event 1
> 	MMIO offset:0x28 Counter for RMID 1 Event 2
> 	...
>
> Define these events in the file system code and add the events
> to the event_group structures.
>
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl_types.h           | 11 ++++++
>   arch/x86/kernel/cpu/resctrl/intel_aet.c | 33 ++++++++++++++++++
>   fs/resctrl/monitor.c                    | 45 +++++++++++++++++++++++++
>   3 files changed, 89 insertions(+)
>
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index b468bfbab9ea..455b29a0a9b9 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -43,6 +43,17 @@ enum resctrl_event_id {
>   	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
>   	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>   
> +	/* Intel Telemetry Events */
> +	PMT_EVENT_ENERGY,
> +	PMT_EVENT_ACTIVITY,
> +	PMT_EVENT_STALLS_LLC_HIT,
> +	PMT_EVENT_C1_RES,
> +	PMT_EVENT_UNHALTED_CORE_CYCLES,
> +	PMT_EVENT_STALLS_LLC_MISS,
> +	PMT_EVENT_AUTO_C6_RES,
> +	PMT_EVENT_UNHALTED_REF_CYCLES,
> +	PMT_EVENT_UOPS_RETIRED,
> +
>   	/* Must be the last */
>   	QOS_NUM_EVENTS,
>   };
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 2316198eb69e..bf8e2a6126d2 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -34,6 +34,20 @@ struct mmio_info {
>   	void __iomem	*addrs[] __counted_by(count);
>   };
>   
> +/**
> + * struct pmt_event - Telemetry event.
> + * @evtid:	Resctrl event id
> + * @evt_idx:	Counter index within each per-RMID block of counters
> + * @bin_bits:	Zero for integer valued events, else number bits in fixed-point
> + */
> +struct pmt_event {
> +	enum resctrl_event_id	evtid;
> +	int			evt_idx;
> +	int			bin_bits;
> +};
> +
> +#define EVT(id, idx, bits) { .evtid = id, .evt_idx = idx, .bin_bits = bits }
> +
>   /**
>    * struct event_group - All information about a group of telemetry events.
>    * @pfg:		Points to the aggregated telemetry space information
> @@ -42,6 +56,8 @@ struct mmio_info {
>    * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group
>    * @guid:		Unique number per XML description file.
>    * @mmio_size:		Number of bytes of MMIO registers for this group.
> + * @num_events:		Number of events in this group.
> + * @evts:		Array of event descriptors.
>    */
>   struct event_group {
>   	/* Data fields used by this code. */
> @@ -51,6 +67,8 @@ struct event_group {
>   	/* Remaining fields initialized from XML file. */
>   	u32				guid;
>   	size_t				mmio_size;
> +	int				num_events;
> +	struct pmt_event		evts[] __counted_by(num_events);
>   };
>   
>   /*
> @@ -60,6 +78,11 @@ struct event_group {
>   static struct event_group energy_0x26696143 = {
>   	.guid		= 0x26696143,
>   	.mmio_size	= (576 * 2 + 3) * 8,
> +	.num_events	= 2,
> +	.evts				= {
Please align the "=" with the above "=".
> +		EVT(PMT_EVENT_ENERGY, 0, 18),
> +		EVT(PMT_EVENT_ACTIVITY, 1, 18),
> +	}
>   };
>   
>   /*
> @@ -69,6 +92,16 @@ static struct event_group energy_0x26696143 = {
>   static struct event_group perf_0x26557651 = {
>   	.guid		= 0x26557651,
>   	.mmio_size	= (576 * 7 + 3) * 8,
> +	.num_events	= 7,
> +	.evts				= {

Ditto.

[SNIP]

Thanks.

-Fenghua

