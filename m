Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011018.outbound.protection.outlook.com [52.101.62.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C00E346FAB;
	Fri, 19 Dec 2025 15:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766157375; cv=fail; b=BvIBYDIZIRhDoB+VbMnpF7HZ2AKb5F7f/+ipt2m6+pPr+fwLlq4NNX4sYghOtRKRa5P/gevwwdIdfZrHqEkgai00wKnyBPISxj9N3CUKERpFYQHL7/tO2vvafFGj/R2v2+BcMyTroWTahoXtXWb96xiXla4AIKQO05jBA496PKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766157375; c=relaxed/simple;
	bh=eCyWc2D42uLAKeLMYFDF4OfFNB6rF2ytoq/lmw5jNa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pDMCQnLppWqxVBLRLXoGR/47uLJJKJGvb3It0P65ueofAbCn0VoVpWMTsQ26Ui5couDxTvi8SY+3Tj6vflR9klcTdR9lKYds1Q8WG1AfEQiumFrMsFRRc3KseISYKTF3Uw//dWZMqdWvX0gDSgGJi+7GtvFq5ELCGhffprFrZHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fRUgnQDu; arc=fail smtp.client-ip=52.101.62.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fRUgnQDu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTLZTuJFZUXxmiyHMyUyvFbyWzXvdJRynTgxl8t3f9tXBFOSWbpsOR84PGmeXJJCN74aN6ZiHeaFHvhZDoYzIAyLHEJ7EfTTcCPqGTs0RXa9WZdvKP0HbSO1kwhqaa27/LXDBE/DOrYsTxIUDaFjfTImHLebpDxoieshmIpaCoyjT0j/QRYpwmm93njGkONJPUzfUa2wSM2RcFgwsw7B082UTeABqH6Xh9wU2Vkte2b6zGA9VSdFgZ/IEnGZpDErATUEkZE5JNxO36i7AuAktVQaOVrOD2Nw5AkkI7mCUVdfs5LLz01cD9EAdYAt/Ocmftaj4oCHoG/rUvGgQyiOxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwrkzsDjeKgFWBhYzl7lFNhvPFALYYrr/06dskkeBLc=;
 b=AwxRy7vIWJ15LX4lTQxKsHEk8bmnmnYWXlprjoPofsQdg4nuHHLXGXz46bm1ZgTqT+BbScdcdKPgkWWpHh6bY8M8LNmMoyM2s+KMQJUfMVDmBKEsR6qvSilN0gNuk9xMayPDGf/H4PmKsH8rA/DxFD20Jq98QeFI+6z0lst7r0J/e90r2F5qfLQmoBXqICI60XXz+pIB6Ad8yQ8yegNigtJV/Nqs3ihFlUQ8lQLJesPb8luyAuEJuHjzDJxdA9a7TbCUa7lIj+gvWm1BTNHJh6At76XOEk+uzD/tG1os2JEwTOfQ2mKKqpesqdDt978xFcygzW2LqUdClVHcl3Mw9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwrkzsDjeKgFWBhYzl7lFNhvPFALYYrr/06dskkeBLc=;
 b=fRUgnQDuWZMe0JC731efflrO+GVwah+bAC+a2MWvZUPqPHR7y0m4ynk5tX8lMcpT9XyBzDQcnjRDmdwcr6pO3EYuG0c5QnYeoxLHe7GFfKFMaBmOIIUtSPdb00RDbS74Uoir/usGCPC7vUpmcbb+11qU7k68n/1IfCcAQ7xqkMzlm5TaQ3IyvD2C0w/LtbojsQDV99cht7svB52Z8VwFB/igz3TtN7kg41zG6XJ5wwJoLI6bXDE3JcEEAmLv+w1+lGBPL4bZKtiD0ZpOds6PxVFMW/STxaa7gFmpWDJawqkcCh7lSlghlKJ4/eWbBWci0f6Rc7u4DmLpYPk2PzBbwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB7663.namprd12.prod.outlook.com (2603:10b6:208:424::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:16:10 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 15:16:09 +0000
Date: Fri, 19 Dec 2025 11:16:08 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 3/9] iommu/arm-smmu-v3: Store ASIDs and VMID in
 arm_smmu_master
Message-ID: <20251219151608.GE254720@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <f7fa8725aab1fbd2c2a1d564e7493b16a586e88c.1766088962.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7fa8725aab1fbd2c2a1d564e7493b16a586e88c.1766088962.git.nicolinc@nvidia.com>
X-ClientProxiedBy: IA1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB7663:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a06e43-5ce5-4d57-7de1-08de3f1189a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?85FeYOl3gF8P1YJNWA/R046zsxLgRLPJrW0Ld1wAw+4SrEJO1VvuFoJLdmmH?=
 =?us-ascii?Q?MrPogjF+3UmGzrpo2AjPdaKQ1hyHaXCA36UU/MvpMUI6AnrIv44PbZCtc55O?=
 =?us-ascii?Q?54B8Uitn1YOR0GeZ+jLCXbyeMjP+17XyULJ7w1XERkAlkx6qQqDdEds+GY2V?=
 =?us-ascii?Q?4GELPigSOkscBbSA3F+Sts92PE+D0hsbgeVLZs4xQGmtl2ZJBimq1yrKrwc6?=
 =?us-ascii?Q?vQMpzDpmo4Os6m+7t/CU3+PBlmDfFnvyYZcoMSm6hmHk/2PiFyBaqe6Ys7Zr?=
 =?us-ascii?Q?NfQ2iZ/s31FEUYwzD35Uh0/lcxAQpQG13u8t0doCgthIUUZ3aH7hlrI9CLvA?=
 =?us-ascii?Q?hEBuiETwxRok3LeiWnrsAQ0OK5YQ2NYIdkvNr7PdXDWbgA9gXR95UWSxEmYR?=
 =?us-ascii?Q?emahUv/9jqiQogmF4rQPz9y08s2U6e0L53nSRT/2duS1/8TtgpLedTq4W5w4?=
 =?us-ascii?Q?zGwlHsh9NiHWVXwrhAwFXrRCml/YrsqFl9cPUlLcTR8NRYL8XukRcHAjDohU?=
 =?us-ascii?Q?qeBb0QQqSfkbDrIBpjwMa3lUJ9AyJM5F/ZxtRDz0yuQDeMkMBvOABDz64xm7?=
 =?us-ascii?Q?ntyRCyaV5049QiYecfChK8vPUonGdy5bQ/q2jKEpUah3Tn7ksohFsdjmI9vF?=
 =?us-ascii?Q?eQzz2jaG3iQks+1K661v/7bJS4ypIOCD+7y38FOQL04/y2gjEYcYnZUYx+X+?=
 =?us-ascii?Q?3rKlxMKRNMu6qQWFYLM4BDzQomMoo8NPWnjD4XnlaSoGjLjXEbjoBkiTsJfz?=
 =?us-ascii?Q?5eLHaholn82PD5lzNBi8UDBe135R70ucPrjRS9ZNi/Sd0kQOkI5DBPPPNkCB?=
 =?us-ascii?Q?16nF93IuJXR9gaZ4jJzAJCrWtnRlMqy8+5I86+eHGp5Y1vLvNlRig2tfHN6X?=
 =?us-ascii?Q?LW4Ggf9/4mAa9GAYPbIxp7Q5bgQqQEF1I81KcN+RC4ZBgK3d1KoPWew+AGoK?=
 =?us-ascii?Q?icGrT75mQHF4UWvLBFauZcD+pIkrI8ZDgiC40NlqhwgfLMt6wQZie6AIHR20?=
 =?us-ascii?Q?tNdcYKN4jzNUyNiB41gFuNdQvvYV27W88BHuSVSvUHS4VEyu7FPFKciiYI/c?=
 =?us-ascii?Q?9Txp/+hZk3j+cyNBt+9RIEDh/LyDd+6qMSK+yQnwqxQOaUAjXDJHE/HtAyCI?=
 =?us-ascii?Q?6GSNdJMCOXxxJTR9RQsbvzpYuf1CbFP+vbIZquQ5xrg5oBBFftlwTWPL7iTL?=
 =?us-ascii?Q?hBtrxMolEUv0MbhC4DCozYbgkTny/MO8Ot5f0AMK/es0qxCzyAiRXL/Am0vt?=
 =?us-ascii?Q?BkRIziPs/9XbcQ0nwRGSXv9IdMGQo++FKQBkeiYU5YFsBOkeMNUqw/vkhylG?=
 =?us-ascii?Q?jhFTYxa1DxcH6VtEVbMcKoMgZOAvmKeMVF/kkkP9AzuwMDJl5o9YIegeTmbU?=
 =?us-ascii?Q?CMNHggtnhpl2S0LgKdhrIYR4R8+tAdwD9dr6zywOiDAjEJ2gz+4ECVcPwCYD?=
 =?us-ascii?Q?bUqBi1bdPHBzljGCnTPQdb6GtZvHi/dC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XYQV8Y2g/GHdCf9mo8eYqtUF5ApTOipAOUCz6CFB9E3mJvXmYSCaPot1fV/1?=
 =?us-ascii?Q?8ENfHzBaEgZP9ZhPIapygdtgACeJESL58xBEWnvjXSfoP/CNFIV85jKE0y9C?=
 =?us-ascii?Q?0NVLYFV9EJZv1LQwOYaXGFJ3i+uv+9S5WmJzOl2RGaX5COf0w3HBrkYbs8cX?=
 =?us-ascii?Q?sgUetP8cqW4jJlX0QbF2NA8kA3UTpVNwVi3PG5kr9BWIk3tp/lfTY2XzJuhE?=
 =?us-ascii?Q?ppNfU4i9Xjab8x49PCOCt3OC/Zbu/qGk7emy0yhkzDc0LbhhEy78/TmPo7Wj?=
 =?us-ascii?Q?UJX0EWnKo6XyAnZ88hd29nnwEzalTu7cd6TL84OzyBYEno7eJTfFt0+qj8sx?=
 =?us-ascii?Q?ynmi2/QB5ewH2GWAFnNI2RY0v+XMy1vl6vfWkD7rHRXUWTUhUQdyaY0in0Mq?=
 =?us-ascii?Q?Av9mJ77zQo1DwKPbwye3SSAZYZIDBA+6sKRpjoiQHotg65U6xMt3Vl5Mkyf5?=
 =?us-ascii?Q?mdKhCCxbV5rU+T65A5aqzqO1NplLy9aAS//rHFXoBMND2UXn7qmGKUd3ORLt?=
 =?us-ascii?Q?GHKJW7P5qvAmQI+luG/QegZRrHK6SvsZjR+HpFN23V7SznInHFnusR8BX7IJ?=
 =?us-ascii?Q?S+xulnsDp+w96euniHJa48LhN/xOQ4OBIOTJoxy7SxfVirSfqToJCkmwskjk?=
 =?us-ascii?Q?RgOMovnwnzcE7gXyUU87K1uUFK2yyy7pDo5kE6c/xzlz63TrKJRtzaY5KnsC?=
 =?us-ascii?Q?olTcS5GNpNJyfRaNvK/u5Sd/gct1I8tfTtaObdVznU/6L9/SVrTneQsJB8dK?=
 =?us-ascii?Q?rewW3XRqquk0wHnqk7IilZu7YSBgIfS9Au/vh6zB5ZtpP2x7dXrHEevCdD4c?=
 =?us-ascii?Q?pVd3labMpD4hB7c3bzHqznA2WvBYwwsn2XPHCrfX8l9NCDyiL5C+10WIrt6Z?=
 =?us-ascii?Q?hkQ117oB+oL3yc4bPOMb+I5PLMOGQMNAQNVWeLc8DgAg076nk4uLUKeKxYME?=
 =?us-ascii?Q?LyO66ZopHE4hQSryGfRpY85B6DZ1tFQZzNT6AwEw6RrY7++35GhKuJb87t6o?=
 =?us-ascii?Q?npFyE95cfa9zl0NPrCGXXdu2ydxAJb7t0b1WVUyuL1INsgn6Z+jEWTMZh9nB?=
 =?us-ascii?Q?kMH31Zl/5gZVndrc7zaZM8rMpO0p7D2HoJ+tQFawux8KkJvrMInnYbUKX6dJ?=
 =?us-ascii?Q?fu0JxAoJNXQ1w10DnmZzr06UxFJ8Uph+0NMnxP4HokQxja9gXoOm9J1Zm+1/?=
 =?us-ascii?Q?rcWYSg1CAaIevDPhShdr3EN+Y5q6IsSpMuxu8aS3kYHY+d0FE/eSKglTh1js?=
 =?us-ascii?Q?hnLf/ywpMexg7ymTbGQHDmuJnZhCK7uk1Uv/3Dok8tnC3dycQHO8Z4cykUn/?=
 =?us-ascii?Q?jZm074mgbIPOMWzySYWvMubV4m4aYk6hKQ1jORftqGHt6Zzf39P2nlBRmYfd?=
 =?us-ascii?Q?2ZB5w//4VYrHw9OZPPBBPoCuYP4Fr1Oh1VE+cd+OZxyNLMUOIXdeTCroW0yF?=
 =?us-ascii?Q?v5S6W3WzYroZ4VTeZCMiFG5tLKI5hRoqbMrnKO++HabdqswlAZ/XoszyDJW7?=
 =?us-ascii?Q?TNwLbGwf82X56HvXaKeG0sTxSOwGunUNpkFxDZ9JCGWQgMZmtc61QpOjT34v?=
 =?us-ascii?Q?V3duixuXYjdN9I/esuWect9Xo6Ybn9pFfOUoX0s6sSSN2RTtS7BifTUZzSUs?=
 =?us-ascii?Q?HxnkNUUfG7ylGslsW9xfRx+sJc1NzNCEsqAjbtN99dOD4W7LxCW/QIVtzzJ/?=
 =?us-ascii?Q?E1jn8FIsnrxZBJ+1YE5q7TzVi4Lp+IeCSzFK0o9+nMRLYlv/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a06e43-5ce5-4d57-7de1-08de3f1189a6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:16:09.1525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnyzQp7Rebv7P3UAywzr5rFxqPkbaxTpDpkI1RPThcrVwrHz0Ewq76IilC8Jyk2F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7663

On Thu, Dec 18, 2025 at 12:26:49PM -0800, Nicolin Chen wrote:
> Currently, ASID is allocated per smmu_domain, stored in the domain, and
> freed with the domain.
> 
> Practically, ASID is only used in a CD as an iotlb tag. Therefore, ASID
> doesn't really follow the life cycle of a domain but domain attachment.
> 
> On the other hand, the CD carrying ASID is installed to a device's STE.
> 
> This applies to the VMID as well, which is installed in an STE directly.
> 
> Since a device can only have one ASID per SSID and one VMID per SID, add
> an ASID array and VMID in the arm_smmu_master structure, to decouple the
> ASID/VMID from the domain structure.

I don't think this is entirely right..

When a S1 is attached to a master the master needs to store the VMID
it is using, as the VMID is global to the STE and effectively becomes
global to the master.

But the ASID should be stored in the invalidation list of the domain.

Jus search the list for the (instance, vmid) pair of the master to get
back the right ASID.

We don't need to store it again in another list, that's confusing.

Jason
