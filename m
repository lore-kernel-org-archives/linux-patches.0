Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012046.outbound.protection.outlook.com [40.107.209.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D9E1F3BA2;
	Mon,  4 May 2026 04:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777870655; cv=fail; b=tpF3NVkJjMo1pJaH+8QpZTZ0W85j0ve0LMO4TwRVNuxdO4S0/rxGVM7NITux/FTMzQhEDZH6zX3G9pJben5rFNZ4OBJt2xSMfskSTQG8Sd6TN4D4rbYwbmypHNsJOnSOJN+k8upQHLpvekEnuppJ31mGK9YNHg5VERVkrg1gGeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777870655; c=relaxed/simple;
	bh=vC8D/W93VXwsIjC/jR7C/Qh5lPXm56Kku9m/PCnEKEY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IQbKDbIH6AdFy5dDSMG3hDCGLUO3gAxCQjc5xnyeDwObt5+y6Q70WmavllLLDsb7seI2kwgdo9pv0Iz+bjvMNVxLxVCM6geOKWvR0DkE1QfnVeenwIn2t+BaN6gRcDwBUMo7q3Gh41Sw/5uNzAN2fzuAtAv6Wp4OMpMvAgOIxjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OGkyfikm; arc=fail smtp.client-ip=40.107.209.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OGkyfikm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LtkMpUsID8twEZE7gxfa/ioitNxoCKgsXIcjFbGrGi3WKcedZDmeYBbhYK/hwz2uMv3gb4B5D5JgAPwp0pPMxs6Zq81quuASgQz5E1FZx9SHWs2cNdSvULmfFQvC2kP7VCMfIGEfPVBix47rXimr1homWjtINJnzTW4OZGHsbZn5oReZJuWOk9R1B3HfeFE0qPn4h+39wfxbiGnHuYrE521xcYyNeIiKoyiG7gRZOCXV2jemp9E+jCcq24C///U1h0RwQEzh32e+dzaNEgvZr82GXd1MVRqGAbzhtgLBJjQElpEKZPuozGK1btbxhgILjorv3R/oO9YctFqlloWO8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITWDBTdIlIQD0uCP/XMjKmtty7uCCpj911cr6Y2QQ1k=;
 b=FpUy4te/fA6yVAZDVuUTOvuodLk0zuTn3DH6yOZTA3ST6jMy+WCExc+k+TqFKxzD7+IxGeidamaihvEHDgxGAMas8aBD97DQdRO3YoH8I9L7IJvkxXb103zntDn6ih/31NCAXIQAp1Gv7XBAhhbL2w0oafzR4tBIvGeLHzJnBMB66AB7W5O8MKcPMhF/o2OnS0L09Txa/SjzS19SOpXYDoA2uql8ZkpEcdC1BPZqqpjYqwaPc6P9vK9uAwbx/tZVlAP3E+dEIEGZMs2MPgJ4gRe721RdZCkQN3lO4/PDg7jzZfG+ZHh3cUZJnwLCxP/guZEdDJ210AnYrFEcXCn4HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITWDBTdIlIQD0uCP/XMjKmtty7uCCpj911cr6Y2QQ1k=;
 b=OGkyfikmWLNnYXoLP1B2ISxskVDK3rvqTMKJly3tTQA72mPyUhiY89Ugiz1BphQR154+xlqYlHryhUwAAo7bD0fLdFNK65blvohnB5ncKbfhWSG1Ps17atWcgmwt6BHruWranJN7TdblYSQ5fJSJlogiyz51Q7QJc3j6smBUQtY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5754.namprd12.prod.outlook.com (2603:10b6:208:391::20)
 by CH3PR12MB8912.namprd12.prod.outlook.com (2603:10b6:610:169::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 04:57:30 +0000
Received: from BL1PR12MB5754.namprd12.prod.outlook.com
 ([fe80::b080:4c1a:f6e5:4564]) by BL1PR12MB5754.namprd12.prod.outlook.com
 ([fe80::b080:4c1a:f6e5:4564%5]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 04:57:30 +0000
Message-ID: <d355484d-d038-4393-ac06-a71ff1c69b50@amd.com>
Date: Mon, 4 May 2026 10:27:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/amd: Fix precedence order in set_dte_passthrough()
To: Weinan Liu <wnliu@google.com>, iommu@lists.linux.dev, jgg@nvidia.com,
 joro@8bytes.org, suravee.suthikulpanit@amd.com
Cc: will@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org,
 robin.murphy@arm.com, santosh.shukla@amd.com, chrisl@kernel.org
References: <20260430232851.236666-1-wnliu@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20260430232851.236666-1-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0039.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::10) To BL1PR12MB5754.namprd12.prod.outlook.com
 (2603:10b6:208:391::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5754:EE_|CH3PR12MB8912:EE_
X-MS-Office365-Filtering-Correlation-Id: d846ed43-56e1-4f81-c747-08dea999a572
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	nS3QYCjcZTgU/7KuHBEIgKfPabpV6DSxSOnGE04aHd9kl7BsrfqoZAKvCnRejXxQjt+1HxLcavQehnDYK3nCfqtFeMGbC53ktkpGaZWbI54p5WAj9VhQeOV8anQKOzlFkt/3DJGU1IealT4iLLhvoKAHrHbwdAocQL9V2gQlxLjiyYhfjzEym6Nq3BxXkwyuTzBlNc5SCJtBezXDwHOS2W4Kqk8iX4Zlkf7csM5PNSo9C3cHyk5ySOBRfa+p2zmUqEzaq+xAqvKsplrOr1pSfoza8JkKRFQe8s0AWK/Low2yWTjkJL+huKK00q+sb/96H0ghykD+24FlZTHmbNShYC6U50cc9GbQGckmSoeWx8FdpOI28YbKdCddgUvWP6HSvJt9n8Uxvk3qn/Boul4w7g+qGZEHaGEXFD4oRY/yYxMTavNgFIJQkdloOsC+9QlWemjoEo/OItSE6vAiP3+9Zme8P8lh5T3ErcS+ZNxV2k57xijA8y8AEJEDClVNHZUBWu5rcg4EVhuaDjPoveQMxKeWWAM0rCa7mh+Lvrxog0XJBdu3U4d2hmSgBn3bFmWo9rkyJ36wjr9KjQUPIoNZkZAgyuIntRLzYMGZdh7biJg2idsU6cJoFsGRZZGizlv9wjfU/0iQ7XvHR6sdoHSF3YLQPvJ+2HEhfKQ43C6L+JRFvZYY5RUTuocOEVPP+6v2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5754.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWw4anFRVzl6Q0VLM25JOGNERzFGMHJFQncvT3NMRGI4QWxsR3NjUHdFcTZs?=
 =?utf-8?B?N3ZzR20xWkNCV3FCS0Yxdjc0TlpycVJCSktNLzZxYU1Za2hpOUt3R09KcnNZ?=
 =?utf-8?B?V3hKclMvOFVBbHBkMjNHTENXWEpHR0NkV1pmcjhmZ0dSUjk0dkZWWG0zaXNW?=
 =?utf-8?B?dTVIRkVrZFkyU0QvK1ZqUm9JdDhxOUxsZWVNNmhoM1RuWXIvazBodTBLWWx4?=
 =?utf-8?B?a1hNUmlnQXFiNXJ2VzRvSnBYSFhoUmVQUWxESS9abVAvK29hc1FBMWV4WW91?=
 =?utf-8?B?MFVpU0dlZWZ4WVp4UVZCcnQ5NXRadDMxK2pYNkV5enhWSnZMancvVVlLaE9M?=
 =?utf-8?B?dUdNZUt2QjllR1NuNkk3dW02eWJ0OTJIWlUvWjl1UStBdU16ZW04dkpWY0w1?=
 =?utf-8?B?STBuQnpXMkREQ2RLMzkvVHQyVWhDVTJqR3NWVkM3V1B4eHVwRi9vaHVrSy9L?=
 =?utf-8?B?SE9UR2FkdmpXZEtjRmpBdDFVTXpHSEdRWEVHb2RLTkM5bC9aMlR0VTR1UGxr?=
 =?utf-8?B?MnhZcTZYMi92Tk5nWWx0TjhLYnlHcGk1d1NmQTcwNWhXaGRqSWY2SlhCRFhv?=
 =?utf-8?B?aUp0Kzd3YTg4ZnptOUdNMDU5Zjl2RFRDNktGdDBDeGh3SDJzQkZ0Z2I4VjZY?=
 =?utf-8?B?RE1oQ0dld29HaU56ZzlXQlc5Mk9FOTNWUlVlS1BjMEY4OUZnQ0xZcFROdXZI?=
 =?utf-8?B?RmFEaVpGcTRwNmp2eEZBRmlPSjUzUmh3dEZIQVdRY1BaYnBvRE05ZkNWeFlY?=
 =?utf-8?B?MFVBNSszaXNoaUNMeks3eHA4U0o0ZFB5WUQ4T0FlREpvYVp2VTArLzlkeS9o?=
 =?utf-8?B?Ti9SYzZaSkNLSjY3Z0xUa3F4NjkwZlZsY2JlUi9iK1hhRVZHQzRoQ2lWNng4?=
 =?utf-8?B?WVl5Qmt1UlJhcG5Kdk9oQXh1dHgxd0R4djJkTEFVMU5QS0lza24vVjJTZ1JF?=
 =?utf-8?B?c1JzUGNXM2ZXOGw3cldxeEpMaFBka3laaFdZMXovcE5OdEZRTjl0MW9vc2dO?=
 =?utf-8?B?THl1UEtpTk0zRktkcDRiY2RGcGNvb3dBWmlZZjhlLzVYYktqRkcrQ2Fzc3g0?=
 =?utf-8?B?Z2NtaUVkUGtvenlLNFNtZDZUdUpBeUFQMFlZUkxsSjVpa3ZkWVpJM0JDOUlo?=
 =?utf-8?B?akFjWi9sUHBtMlFNcUR5YzdlQjV4cWdxOFRYeTRBUmhoNEx1dHB6RUVwKzhT?=
 =?utf-8?B?U29oSVljaXpRMm5BckFzODEyNHV0SzU3bzZCSFZ1aDBQTENwTjJGb1lBdUlS?=
 =?utf-8?B?TmM1dEFaUm4wVFlDUnpxQk5lSFF5alM4TVpEY1ZvTm5GeFFHaTNxdzZFQk1q?=
 =?utf-8?B?WjhGTi92ZHIwdmFGaktoWmdVb1JxNnFXUCtkaWpJTjJXNkFUdjV2anh0VUwz?=
 =?utf-8?B?dTJlZHRQcHBkQjJLNkF0N2E3YVVIU1J4cmpWVjdXWnJWNll6S2FXZjlIUWJI?=
 =?utf-8?B?ZnRrNFpITDB0SnVucXBkUXlpQy9YbzczSmFuSW8rRy9oRElFc3hQVTZocVpF?=
 =?utf-8?B?ZTJrVHpEZ3RSNU1POWxyNXVtZDBvY0tKcWxkZUo4OEZTeWg4M0Y2SDBpQUJ5?=
 =?utf-8?B?SG1KTkpmelZIaGhPWUtFR2JPZDhkaEtlRE13WWJLZ2J0N2ZoMVNjN0FnNWdx?=
 =?utf-8?B?a2x1Y1pRdFBOOXMrV3lVcDlDUzBpZ0dXV0JqV0loMWdZb1lWUjh4NVllMkV3?=
 =?utf-8?B?ZnU4Z2w0R1hhNTBGZ05CcVp3SjE1dWR3ZnVmRi81UEUxKzNrWTlIcENkVUph?=
 =?utf-8?B?ZHVtQzJWVlBkcm9xZFNSVW1rSHk0U1l5TzU5SlVndDUzVGVybmxES296ZS9E?=
 =?utf-8?B?RjQ0QzN6Zy9YMTl0OFJTYmJFK1A0aXpBMjlBRHJzTjhvR1VSamtndjllaEln?=
 =?utf-8?B?c1lFRllHdEx2Yk5yS2tjOFB6T2R6bk1zeTY4TmFLTzdTZ0FuUXQ4U2Ywamwz?=
 =?utf-8?B?R2pIRXNiVTl1VTJoTXRPRVppSmtaa2s2S1R5eDV5SnJnVWtXeG5TMVZTYURh?=
 =?utf-8?B?VUx2Z0VUK3dxOVk2cURIWElSYTBubW5xWDgxTHdwVndkbm8zWmxZZjFYMGE1?=
 =?utf-8?B?Rk1LYzQvejJTRE1KZWJKd1BnRklDb3ZJUlh4K0ZzTXBoY1V4VVJmMXpuRloy?=
 =?utf-8?B?ZCtPYnBKWmdRMDRQRmJWNU5yMndBai94cDY3NXFpQjVMbXRTYVMxV2hSV01j?=
 =?utf-8?B?aFZHYXdkeFp2Um5MZ2ZvWjk2dTlGRjFlQUxiNENyR3hXOGNvdkNFRnY4SXlr?=
 =?utf-8?B?QjJMK2xqbEt5U21yOHU2VE5TeXpQcHZ0eXRBaCtLUTF0bXN6M1JYenIwa3c3?=
 =?utf-8?B?Q1c5K3BlUngySzhMYjZyTlBIbmI3WG91MWJKc2U3S21BNzNmeXVvUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d846ed43-56e1-4f81-c747-08dea999a572
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5754.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 04:57:30.6013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auCcC4U8POBFCSRntXgnUrf0UhBDTbpxvNIBlX8QlTA2JmjSIIU+sbOthw49iX3eCw8E6iCknfdkScO3p6VwbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8912



On 5/1/2026 4:58 AM, Weinan Liu wrote:
> Bitwise OR | operator has a higher precedence than the ternary ?:
> operatior. It will be incorrectly evaluated as:
> 
> new->data[1] |= (FIELD_PREP(...) | dev_data->ats_enabled) ? DTE_FLAG_IOTLB : 0;
> 
> Wrap the conditional operation in parentheses to enforce the
> correct evaluation order.
> 
> Fixes: 93eee2a49c1b ("iommu/amd: Refactor logic to program the host page table in DTE")
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

> ---
>  drivers/iommu/amd/iommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 01171361f9bc..ccffbecb15c2 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2149,7 +2149,8 @@ static void set_dte_passthrough(struct iommu_dev_data *dev_data,
>  	new->data[0] |= DTE_FLAG_TV | DTE_FLAG_IR | DTE_FLAG_IW;
>  
>  	new->data[1] |= FIELD_PREP(DTE_DOMID_MASK, domain->id) |
> -			(dev_data->ats_enabled) ? DTE_FLAG_IOTLB : 0;
> +			(dev_data->ats_enabled ? DTE_FLAG_IOTLB : 0);
> +
>  }
>  
>  static void set_dte_entry(struct amd_iommu *iommu,

