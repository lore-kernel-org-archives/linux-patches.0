Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010047.outbound.protection.outlook.com [52.101.46.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01453332907;
	Tue, 25 Aug 2026 17:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787678420; cv=fail; b=HQYyNK4Ul5lAt7Zl5V7BK00v16JMscu/rADReQfOtZKrR6K66izvoXuJxHZ2MCIHiv6sCuAc2mOI5ps4VHJdcMvrz9obl0TE14G42JtrZ9ZcHBgR8O9Bem6Q9CpkegNVK3CPqlx93Vg0qSB6tj5d8EXmYDMm71ykGIPOc1Qmm4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787678420; c=relaxed/simple;
	bh=V2/jMGeMxSmf1JYYlX6sgajhRQP7KtGUe2A1YtVXajg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MUVRylRshGWb/6DIDQPYqp/a5665f7WxuU+7sFA7qtBLdPncO6BHXGX/fAmPsWj849rpcWJCKxdu1vwpDUu6Q/OXvSVmgejo5XYT60koin+SrGS1fiKRIzyqnO5hq62wPMwjWzp0DEwIjp2wsDdNCZpx/vUuzbztVWrpofpZYgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q9nlLerm; arc=fail smtp.client-ip=52.101.46.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q9nlLerm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHZbFL1ZVQh1vK7AobK76IH3BsyRgQd3Wri+BNNMWjgY0LwcQlDrLYqAlwdjT077yrtQm5OOLODD83pV9oVcuRsi0PJ4r01ft3sozvz66Rv3db8hRIW8CJykZUnXmIwg3SprUHVwvPzi3zo3T08UuVIaqU5vUG1LYvUq9m31cXArdUBaSo4jKDuQEWb5Sq+8ogbnXlhrdOoDFF7921H3cOSAV4/2F0FcStVozTNeigSUza+iJtBFME84HxmR7pjgWjR1JbTC6xGScS02q1lfKimg3EkrNM6TaOsSiIlS9IoJK1Z9IXpaFWyAwAucSDk28XV2FdJODUUHooguwrpbtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y8WbuWOxoUI23uVPsJ5MOpoiaFDfUDAUu5MlX5lc2s=;
 b=CHAFdAbVwKNTfJNROUIBfMbHVfHI5/G92B8CnLrZ+PS7+Q3Cj4/GosfHcMgeM8seYbWBnrRXJEd8jNZnW2HUawurtiwaJVnr9oIfUck/f9SXuOtdqoQNd4oHNVpTMJ9lYYTZDdu9kFe1X68NQfvcRpTWWE0LNZwhbzEoHuIi0VNP6z/MEtzOcu56TfPC8kD7u0CfIHlgZtbT5JSFA8Nngj30VK9GnT0nFWxvbTyDfkR57CYixsslvYQwT6t/Y//YMIIdURDJfZesK3ZOW/dUQR08aNoiLShTi2Lc3X4G+5U3CEBXh7Vk+NFq+S5Gcfq+D7D/9DXW6HPYPBURzqDv1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y8WbuWOxoUI23uVPsJ5MOpoiaFDfUDAUu5MlX5lc2s=;
 b=Q9nlLermdL/6qo/7ZbwSMQgm4uwfE8eO4U+vh6uvGZFov6HloP65y1jRak6XODP32/FYoKyoAcZmkc8lW4cTEWjVZD4ey80oskGT1sgBobmHQxLiUX7wF6ZfGBAhWxMI13SkFD/UlHyNav72avi1datEVDUALdX0Ik/moulm7p5m0di/oMM3Top5gAd8L1K5UOquwjX6wJtnXbWXnT3ZrCbVzCk9ngJ/kDI7NAByvznmD9D3OEgr18tROxseNBcaHT5TZJrudEaxuxi6CM6c4d1dgLgmv8dl36MHH9Sc1WGXLVoVWyeg4uwzzC1BZTKfiSpAOzHpeMNLx4puZSGH2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB5771.namprd12.prod.outlook.com (2603:10b6:8:62::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Tue, 25 Aug
 2026 17:20:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0339.012; Tue, 25 Aug 2026
 17:20:10 +0000
Date: Tue, 25 Aug 2026 14:20:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260825172009.GC3325090@nvidia.com>
References: <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
 <20260813141320.GF730363@nvidia.com>
 <an3ew9xbnLe1dr5g@google.com>
 <1791d7da-ecd9-4475-8f27-c8857477b442@arm.com>
 <20260813180102.GH730363@nvidia.com>
 <an7UNAA1WlEXG23-@willie-the-truck>
 <20260814123417.GB510472@nvidia.com>
 <20260818184338.GF5432@nvidia.com>
 <ao3LpdSgK7ZBrLza@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3LpdSgK7ZBrLza@willie-the-truck>
X-ClientProxiedBy: YT4PR01CA0345.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB5771:EE_
X-MS-Office365-Filtering-Correlation-Id: ffd22cab-c030-444f-7110-08df02cd1dee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|4143699003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oLaUYEqDu6U0i9YC0MtL57t2mj5i89AFqBPy8s0E6SLGvLsDMGrzxib1OS2gLnE9if7ibPceRSEpr0hDIaH5VDBkhqEBzWQww3EEt0EilPsOj+EDc1h6HQwI7BdpaXqH5UfkE5XVCfqnnZoYvqkkIdwFhwoWNaExYrYYDk0B0D2G0rlJAbeKtS9bceuLt96nJJ9W89ZP4ENL1XXV/IuFiYH18EXzTzLEu3O5B76zJ4THbuFkh0yqMCfloFNIIGUyXyd5K8mGmrFkGDu/pZYfEF9AiZf+Zx/06t8NBFF9dJhuQ3wXN48QS7LsZ7nJP/PY8BOGUhzbeERm9MRJ7cyDkqOrYcEQgllRpn2qdcMM7lPj3OnxpxWczCwq0W4JNxtiTdsOW/1SAL5eC990oDlYCDWuVsboIJRdRB6wV7yvmJQsVynAGJ9SF9VAxdANe5C/I1+CANU4VXCnzhUBg6QmqZ9Afn8BQs8TQWaDXNyM+4qdbsWJ+fZe928Y4D6BHJRGLRw5kO7HB0LBMSnTHQktDcP7ld8GncwwloPFX+eb7PWKCQRDqlwFILaD318FBYAJyjDsuaOD0ZR8RSrisnk7XU+SkLEwMDWCkUmplynVh+G+fkRqUs44w51TDmFEXk6jUspTR1Qw5Kx4VyqrbaC0f1NSydBLRm8N81Q5DvnJdYY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(4143699003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cCc0S0n8TQ1M4hIMDMYcxAi8/udfHpVNibJewqw9zanzMFg/mhe40dYmGgIV?=
 =?us-ascii?Q?D+c5ESnLXizYy3FxOr3AshUqs9113Dy9qIGdFcG0Q7xUIvixViBhhftwMtXL?=
 =?us-ascii?Q?9hLNb55E3yjGfK107fDa/3amaYJjejw8FW5VjwfRJTiCkvrMADhjDELDjiP3?=
 =?us-ascii?Q?PLZP6HboSr51EpKaIFLpgATcQZmbazXZonVRKlpv49ogYkYvsr9pLttK/iaI?=
 =?us-ascii?Q?TD4Ijs7ScFixkF/nR6qZQmc/wnY/oAHjdGREln9qTDXwfVn8VidZrJfKX+HX?=
 =?us-ascii?Q?BO2twnh88861ZChB6LEWMgkJGkiEXlCeulh743Yr/9gF33KXGq/N2T8vAGBu?=
 =?us-ascii?Q?vuzIdiDuKWIHArwEM8HezVi7f0+nE/zRu9+eWjKLDi6kRxJVOISdRTMgZDkR?=
 =?us-ascii?Q?3mgrp0QwPod6AheUZKynmAKm3sSBxzqrjR8oFoI4oxwHkOP917h6DU1ZgtkG?=
 =?us-ascii?Q?VQj90DeDt7A4aKdB4vNLPo7bEdzfC0jIrgHvPYGNtUlLutoZgN/hF9WwEG6X?=
 =?us-ascii?Q?fTTSTby+JGw8TefiLpogeRSWckA1vK9fL9/gzBcsNSMyycb+cTF6qiSnv0ux?=
 =?us-ascii?Q?t4gSjnZ+DVprdaix/fPN2Ng+MGcAUGMlLiE6ladsrYHK8oknupZeg5asdtDm?=
 =?us-ascii?Q?EuujvSkJaXigSrTW3EfcJGdg3iDoK95OWXbTosOHKBki39pVNqPO4PZRj5xY?=
 =?us-ascii?Q?W+agcErPpx5f6tNLcxrFI+FasB5E2sWpO+WQgEXXDwYlCVzMNUfe+bbA8EZ7?=
 =?us-ascii?Q?JfAZZ8BdH6e8+YmUBapfx4L5YvQVIqLtzU8AYCxS/6zbV+jNMOuYrT97dFGS?=
 =?us-ascii?Q?sLl8GzbzmeSJR2TP1b0z8Bn4sw5rjhkGN8+aUuixz9f/C9MZMwxr6fODwu94?=
 =?us-ascii?Q?B4MOaaGRZNfYtf1LdHJpj6wbzG7s6GspIVkfnXdMdoPX5v2/tKWRCDHzxZTG?=
 =?us-ascii?Q?Ajrl1g1s79Qg+iujGCZr+6J637Xle+1IMy3AHSWweaNg1GEcOKhJye3+8EMb?=
 =?us-ascii?Q?+2QgZy5AB9vv4P+xF3bmXVT9f5P73nXyOne4xpKpwOqlgN+wGaPZgXQvi6GF?=
 =?us-ascii?Q?a8boonuStxPn/+SHGoDXOabImIZ1P2TtSvw74yNW9YPN302ksKZSwbHHNzu0?=
 =?us-ascii?Q?3KZOjNcfURry8G8M9ooNCaOxC8nsxI4diAPwjNh/7z0jcqzz5fHCy8bihXIA?=
 =?us-ascii?Q?R5y2iC+/0yZK9VZ2ZsxqS9/7XTW8t4zCU6Fde7NKrLi1GUIQ5h5EhHCKNNND?=
 =?us-ascii?Q?pzqJFlD30CgGzrqhtPagetWf+zxDHng/ec71DuDU686PnKWqcirxsmeJK6el?=
 =?us-ascii?Q?+iAmUbWqQqT4FLX/cpK1BP8EHkZcmOYmMlursp+4YLa8MkH2zoPQRSdyZU65?=
 =?us-ascii?Q?4xGwX1kk5PQI1zoUBUNNzXpEPFKea8sxNDB+fGyw9brV6NF5chqVZm9bKsZG?=
 =?us-ascii?Q?DBp2D09qizOSTaqNzGiYm8ZagctFWmCWbtkbPAkZIUUao6YpcDya70UMlAKo?=
 =?us-ascii?Q?7C24EQ2ax6KfIQpNycQmYmdOc1eRQeAKC0dbY08Vk+b/pSaYDWhuw/f8YlAo?=
 =?us-ascii?Q?YnM35t5SoWeXT5Zh5SrK3XT/n4dzXkD8wdwnOEqAnTAlL38TNed/wxzpGuVx?=
 =?us-ascii?Q?9+veUWCUFrkRUck26EOHqPkt2ziEH1C3eXr4kJJW9vivpDujgVAmJP2aZPpW?=
 =?us-ascii?Q?vVCzrlZr/Dm+dRgSlNDhbK1cREyfADSrQh0Zps7PgeYcVemn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd22cab-c030-444f-7110-08df02cd1dee
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 17:20:10.5062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lt13N1SS/KIfuDztY3WLPaYqvwcxzKx1LiN3qkcuAcJKHY8eDnxzSEhr8Bexr2hC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5771

On Tue, Aug 25, 2026 at 06:06:45PM +0100, Will Deacon wrote:
> The documentation for 3673557 gives a possible workaround of:
> 
>   - When invalidating a contiguous set of page tables, perform the
>     invalidation sequence twice. Only the invalidation sequence needs to
>     be performed twice, not the SYNC.
> 
> and we just merged something very similar from Ashish. Could we use that
> for domains that want to use contiguous ptes?

I figured out a way to bound it to at most 3 RILs (and that is rare,
mostly it is two RILs), so double invalidation would be at least 4
RILs using Robin's trick and way more using the existing algorithm.

So it would work but I'm happy enough with the 3 RIL path + SVA over
invalidation. I was just waiting for one testing result before posting
the series but it is on my github..

https://github.com/jgunthorpe/linux/tree/iommu_pt_arm64 

Jason
