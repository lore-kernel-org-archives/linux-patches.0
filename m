Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C98199931;
	Tue,  9 Sep 2025 22:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757457113; cv=fail; b=ievrkRuVhreveuZJinSWTGjVAguUUi+No0tUVAQafOy1NlK2N30/qTktH9rnYOfyuVqZFjcwMrRH/l9EZw6g5P+oxgXS9TKYQ2V8xD+yKT/A9e5T6IalQGoqk4YHjLdOH6D7s0sr0oSSRp0MwzUnrnrfeRsWgHb1/RQDHtr0hD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757457113; c=relaxed/simple;
	bh=Ap+nVAoza58ppdlHR2g4vdQVBDzgNCz70bKyZ1DPPWg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cVcPHpgrZJJBmi+qrYO+bVu7Ahh+sQLWEb76JV4e5hEUThKjWxY+jscBhJFYb5UByHLW4AfnNPsXqgn7B4sb/XD7Q5rTd6qfgCTh+Hl4PEijO8Jv3Pafqt2QegNPHYDIXBPyPFZ+NURb/01hQUfweKqiDjQsci4UCQE95uzPEnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LTt22177; arc=fail smtp.client-ip=40.107.223.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LTt22177"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N+77HXLqw/zUKJaklYLOelKpohlFPEDExv3tALug9C/pCGWuGXEjb14l4Y0Xy/41A+2FWB0rGki2Ht0Gw2EYYZdT0f0HhzQPQvpEQkaJsNmR4RgNEszDLkKofAkSUcohu6cr7BlLw2gtKexD/IwC55lGAfhTAPWBROqREbymOXW3ZddIzJfMPdZgOS6bW0M8jVw7h5BY2oFTRTzTSNAjEQIUtxe2b2jPbd+hyjJv67jvgMBX+2pqjSx5PqcmS8J/nk0UaQCcQisJ5e0COntIdThenicB1HXIOq3ribZqJ+Mm6QNNWRKWbWc4klGqCcxfsbPtio7eUxRn3I/pHiGYog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EloipeYheMKoQzx08vm67IPMIcB7nxNaN3uLuoJsfOU=;
 b=cBSoWZ6GsvM4Ikatq08hoimTOfwHg+VJrw2nMfhNd1xS1xW8yN6LyMz1cC1Zo3tBf/evbpxQttLhcFoWUD+GOjVvM6DBtBCYHxJKzaq50Ix+jVCUWAvA5K8XCxMBQ3hwn+ehnBR2dR0qFB9LlyKxz1C2SQsdfmwGu/bEapTQaxaABiuotvsiEvnnpeW5yay1SqMo8Ps2MQdct7XwBaVpsVoLQhJN2HtTss1zWYCWlJWUZ+uFll2EisaNlfyAQPfYfrEM7jzUi95bt4tivRfvL4kwnn7ozJl+C39QeJ2ar3qZmg/IyoyDsxdlWQqtJPPeBj3TWXXjjA1Rk4OHhcsqgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EloipeYheMKoQzx08vm67IPMIcB7nxNaN3uLuoJsfOU=;
 b=LTt22177Yu8/YTiD+zcIBUdlABf6rZh9FHeuVxKZaqLXqjXLtqki4K24OhbXDV1MlFOiWPlxBuC6h5OVxuR7BGeyhnB8K13FJsym1KCyHzCgEjMZR0pOjfjosUuWsoF2s+lF9sagaRh+3CnHXzwPNztqtbreq33GYL0uH21Cm+Ehu7kVCTQH1rFIHONl3O0dn3ArHN+V15XMKQ7CwuS9V41Ef8F6z8oewqf7jDfn4L386C/mD5VWuegxiDDWvabpeQfv1qPwa6eD/LHLtQcaJu6wO9lC0XuF2/U9ujmI7VydpISvW7+d7lcMVMxlZiR2aFAz454RIxN9+7t4TAzdAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY3PR12MB9653.namprd12.prod.outlook.com (2603:10b6:930:ff::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 22:31:48 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 22:31:48 +0000
Message-ID: <a21aa473-b85c-4c40-a3ca-efc68c264071@nvidia.com>
Date: Wed, 10 Sep 2025 08:31:43 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rfcv2 2/8] iommu/arm-smmu-v3: Explicitly set
 smmu_domain->stage for SVA
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, will@kernel.org,
 robin.murphy@arm.com
Cc: joro@8bytes.org, jean-philippe@linaro.org, miko.lenczewski@arm.com,
 peterz@infradead.org, smostafa@google.com, kevin.tian@intel.com,
 praan@google.com, linux-arm-kernel@lists.infradead.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <390fe709e756a54168fcd43e1323998456f2d8d5.1757373449.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <390fe709e756a54168fcd43e1323998456f2d8d5.1757373449.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:a03:334::11) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY3PR12MB9653:EE_
X-MS-Office365-Filtering-Correlation-Id: ecdf67ca-a261-4ef9-68f3-08ddeff0aa27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qjh0L3grcklWalFBSlhBMktaRXkvUWJCOW9WNVpGUWlXejg5aXc5TkF1Q3I5?=
 =?utf-8?B?WmVZdFR3cTZ5SmxrSEhVL0JFTkxrdjVHeVR1czJFdnduR1dIL1plODM1alUw?=
 =?utf-8?B?MWt0Q1o5bHljdVk2dHJGaFQ3bFRvdjZkT01FcHJpZVA2cnBSNHZGbGxIMmpt?=
 =?utf-8?B?ZUdCSUdKZ0pIUGpzZEQ3dkZ4cVpCblM5Q2ZySXBFRk1CdEtSUGtZazNzWDZI?=
 =?utf-8?B?NXpOcTV1MEFSZDJpbjMxQWhoMmttRklUbGkzTVJ5U20vZFVGMWRBSERMOTNQ?=
 =?utf-8?B?VE1YL2V3UkkrdEd6T0ZvUFZEZHFNdHY3ZWlreWlndUl6U25raDhSTDQ3bmlE?=
 =?utf-8?B?Smt4UE5Wd3lHcWR4OG1MZFVtK0RFMFBtK2xEZTJFOFFwN1ozZU01YnBWUzRT?=
 =?utf-8?B?RHU5dTRBQTI4QkpsTnJhczFZdmNnQ0dwbHpZWXUwcXpXV0FkdU4rVVkwcWgw?=
 =?utf-8?B?THVzeC9LVHBLQkZpS0ZNb3NIUjRObmNXSjdGOVNJWS8vSVhadGJaeTZUNFVQ?=
 =?utf-8?B?S0JpUVMzYkJONk1vVVRmTTJnNjhsa2JoNU1jTEZRNjkzQ2p1Mnl0ak9qejNV?=
 =?utf-8?B?YzB3MUxCSkFnRHJoVkRUNzZhR0pHcjNXNFltdENsaTZ1MWxEU0NNTzN4elVG?=
 =?utf-8?B?SjZYZ1NxN0RNTHZSMlJVa2w0aWcrVlVJRjZsRnB5Z1dwajBBRGNMUVM1WGd3?=
 =?utf-8?B?NDFjSmJLSVcraDF4cHZjakdWTUFZQUJaQmViRVE0K0tNQk81cHBCOS9CUWdM?=
 =?utf-8?B?cnhpMGwwS2x6UENodGhJcGNJYnJMNVVxdDNrR1ZVOHo5bGZkMUtEbXpwOTFJ?=
 =?utf-8?B?RnRCbXh1UkNXTmlXN1kvTkgvN0NYRG9yQ2VxeWtpM3BIbm1tQzJlSmNnQUFy?=
 =?utf-8?B?U3EwbW8vNmsyaml0T25BVVJ5RXRvZXd6dnhITW9JSFBWbGhBMUVTRHJCaTBh?=
 =?utf-8?B?UXVCUmU5ODFRNnM4WU4xdkF2VlZMdXhOM1pxdXhWK0VpenJJUFh3ZTVaOStv?=
 =?utf-8?B?ZXU3UGZ4aTY4cmVINGVxNEJpbndjRUNJR3ozbHB0TXR3VVZ5MmdaOU41VFZG?=
 =?utf-8?B?Z2w5ZzFpb1JBUGkrbXZWQ0phYTk3d2wwOE5GR3Y4eVI3YXFFVkpJMTZSODhq?=
 =?utf-8?B?cHd2RFQyYSthN3JPemFDcE9OdmxrcHJJZHdMUndnZ3VsaDExSE1ERTJjYmhH?=
 =?utf-8?B?ck1BenFLNW8wdE80U0xNZ2VRN0ZWR01xbkN1RDZCeStBRjFSZGJCY1BOT3U2?=
 =?utf-8?B?empUYk1ZSTlTbFJoRXNpN0JNMThyQWxtUVhkQ0dCeWt5dHpQV096R2tqYnR3?=
 =?utf-8?B?WENtaVh5d245UXFiR2hBTEpObFR6SEhSeGhaYXRTKzdRbnB4M1U2K002bGx1?=
 =?utf-8?B?VXltSWkrZm1wQ1MyR3ZDL25FYWhlY3ZMcnlCUlBHVkxXeTZqZTB0d2VJdmtG?=
 =?utf-8?B?NXdwMjVNNGVwb0hTZ2V1L1prUldqaGI0MnB4SzZKUFNxYjdlZzd5Tm1WUEVP?=
 =?utf-8?B?SzExWklxRGNtdDZaWUV2aUNRRXVBcElkSEdOZjNGbXJnaFg4MU5ISVU0NFdV?=
 =?utf-8?B?TVZnck9aTTRwYlJWVk9tbkhUZmpRSlh2cGdYQURvUzJacDFEZ2FTbzhTVStq?=
 =?utf-8?B?VUJIK1FFRHhXSEF5cG9JYnZCdHdLTjFaaVJ5UkpwWWNDSlU4RFpIbUNMMDNZ?=
 =?utf-8?B?QnA3ekF4V1I4b0xDd1VJbjVXMzlMMS9EWU9rN3MxNVRydUh6aDgveGtiT2pn?=
 =?utf-8?B?ckRrVGJYQzFBLzZrV1pQajRCa0pXV1VLZnljSERUWkl3c2xscjZqRkI1dHlj?=
 =?utf-8?B?MlE1a244czZENTN4ZUxhZGh2elFMWWJTRTJmVEhDbWtQUm9SK0VEZm9pdTdK?=
 =?utf-8?B?bkNqdkVKSFM3bkhKZnBKQmFXSll5VWxFL21lcWFJV1o5SXd3K2tQd0RtTi9p?=
 =?utf-8?Q?WGoRRzYCHkI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1FOQjFrZTRPUHVONks0aEkxUlVxZ2gvemFEZXg2WVE2QW5iMGljN00xQVNj?=
 =?utf-8?B?THJqN3FiMEFCbW9lTEM3NGZEZjc3cEtTSmdVS2krbjdHcnBBSEZzRGlpQzVH?=
 =?utf-8?B?ZXVBYllJc0cwZlI2WGZhZUJKRmFsQnRUTFdudzljRnExMGUxUktCeDlIcE0z?=
 =?utf-8?B?RnlqQ0VEWktndklhcVYxMWVES2p1a1dtd01zZmVoUEFYdHVBWjVPdm5hNUhr?=
 =?utf-8?B?Rk1KenBNYmRQWUFaejkxazNzL1lHMmU5TGxvbXdEVTN0ajhWL21Sdlh5TTZ3?=
 =?utf-8?B?eTArek9UMW54RHZ2SGpjV1VQcXRyZzBVTkI0QUVVdFpweGMrc1VtS3dsQUEx?=
 =?utf-8?B?UXN5N3BMTnI3TUpqeHVUaTlHOHhYVWJUaWRmMGJxaUVLQ0orQ3RCN0RIVkpU?=
 =?utf-8?B?cWFEM2Y4WTVSTnNrUGZiTlhnaXluWHM4NFU3bFloc3ZOT0oxcktubmtCS1BR?=
 =?utf-8?B?VUlmZHRrU3kxdUQrZjQ4L1owOWZEL2JRQ01QMjNia1U5ck82TmJzblF0UjBO?=
 =?utf-8?B?eE1MRFVITHhtbTFzVnJ3cC9NTkkrVFBJbTluODVSbURVY1Z0QnNjNlNSSTZE?=
 =?utf-8?B?b3lQL0QyblMyT09meHdzQWl3Nm54TjdZS05lL3pQZ2VhdS9Yak1oYUR0ZTYy?=
 =?utf-8?B?eVlkS0E2UWhlL2o4c2pRSzdVTkxZQ0J0bWFzNjlkbzVhK2xPMDArNHFCTXBG?=
 =?utf-8?B?eFJ0VjhRUXZ6WnFldmw4dXl3bXI3dWlvMjN2RFBJdzkyeGpIVy9BUGp2M1No?=
 =?utf-8?B?RGczWG5GSXZ1b3diWnhJaVFhNWgrRlBKRFREbUVCU1Y3M0pGS2cvNHh3M1d4?=
 =?utf-8?B?UDNCR2JrSkxCNmthWCtsZ2gyb3FNditEbVZyaTA0Z2xLY0lCOEVHWldEK2FO?=
 =?utf-8?B?Z0c1YjhjMEtudFp4RUE3WUhLZkRRWEM3WEFycVpYakowS0VlcWpOSEdSSmND?=
 =?utf-8?B?Y0J3dGVqcERxOWdDRkYwL1JqRnhDQ1dSWXVIQkI5N1Bkd0N4dnhLM1Y4Q1I0?=
 =?utf-8?B?bGp6RFFCZDNqSGZ2eVZwdEdwNXMrNDVnUTloeXdiNWxvT21yc2doK1hIWi96?=
 =?utf-8?B?b1Y0ZnVyMGxEN0VGamVZcjFsQi9RbzRtSWRxOERBek9JcmpEUTFUaUxFYlBK?=
 =?utf-8?B?RyswQzBFWlhnNkNPemRIc1RvV01BV2ZMQ1IycjdhWFRDWkZhTkpQRG5mQUQ5?=
 =?utf-8?B?cW9ReC9Kb1hub01UV3d6Mk5wcldKSW9TYzc5Sk5ucmJqM0ZYOFpzNlh1dGUv?=
 =?utf-8?B?ZDhSZ0ZOanQ0R3N6T3ltY25EWUFFMkhPWFh1S3h5SlcvQmdYOGpOZnVtTnFz?=
 =?utf-8?B?eXNwNDk5dEE2UERwVXc2WUdXaUFyRFdFeVpHUmtCVGZwV2NpRGFhNVBTZmRE?=
 =?utf-8?B?UHdzc0xmcmkwKy9RRGM3Zi9pOXBxc1hQbm1ZVy9DU3RVdWtuc3NqczJja0Vw?=
 =?utf-8?B?Z2cvMVZEeGJLdFVyVEx4RVdicWtNajdXU3VuUGttZ1lNL0RCNS9wZWovcXpq?=
 =?utf-8?B?UjcvVCtOOFBZbjBnTUR3WSsyM05iMjVYcHprUjA2cXc1aWg3MUhqU0t2aVlK?=
 =?utf-8?B?b1ZuaDd5dWprcEd4dDdydUNJeDFIclNWZVpiRUZ5NkRkNGh4Rk5sdW5RVDdu?=
 =?utf-8?B?S2g4OUFDVGVmSkRKT0NacVNWMURteHpqeGJld3FmcWtFYllXanJCa285NWNI?=
 =?utf-8?B?bno5ZkozclQ3NEh3TmZ4WHBBeEcrSnVqYUp4RzBkRGRmWUhHVHlLdkcyWC9j?=
 =?utf-8?B?bnV5blBENE9xTVVXdEFEU1F2VHVyc3JyV3J2NWw5eUVBSTdkMEVyMnhnV1Nr?=
 =?utf-8?B?QmxmZi85ZXY2WWRWTGkxdHdpdjhmNk1iZmdzMVhsaXlnTVh4V0tLbWRkVFhS?=
 =?utf-8?B?WGpzeFJRU3JHNEtrNnF2TlRUQUFEZnVkK2c5WnE3cVNtWkxFM24rSTlnS0xs?=
 =?utf-8?B?aWs5T2RjTGs3M0NFa28rdUsyNWhJei9MTnVKTG1rZUtYVmRWeE1pbVQzTzU5?=
 =?utf-8?B?ZTR1NGRMZ1R2SmpsT3F6eUpXekFrc3dNN0dFdmtOdDJjRkQ4ZjhhZnkzYWZ0?=
 =?utf-8?B?TVdaRWpaaC91eTU5MDBJNlZhN3FBRnlZL0doU1Y0K0VXeGsvVjM1Z0VpZkZJ?=
 =?utf-8?Q?xZSAQUI6idhoEHcubWAlBgPaG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecdf67ca-a261-4ef9-68f3-08ddeff0aa27
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 22:31:48.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +B7WI+nVIrhM3MU32gXSw5l4rXAC+sh41r82+sbjJ6DSoRnCKfQonMXuC3oQjPLB1BwWWojmwKtKtB34g6OJRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9653

On 9/9/25 09:26, Nicolin Chen wrote:
> Both the ARM_SMMU_DOMAIN_S1 case and the SVA case use ASID, requiring ASID
> based invalidation commands to flush the TLB.
> 
> Define an ARM_SMMU_DOMAIN_SVA to make the SVA case clear to share the same
> path with the ARM_SMMU_DOMAIN_S1 case, which will be a part of the routine
> to build a new per-domain invalidation array.
> 
> There is no function change.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 3 +++
>  3 files changed, 5 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index ae23aacc38402..5c0b38595d209 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -858,6 +858,7 @@ struct arm_smmu_master {
>  enum arm_smmu_domain_stage {
>  	ARM_SMMU_DOMAIN_S1 = 0,
>  	ARM_SMMU_DOMAIN_S2,
> +	ARM_SMMU_DOMAIN_SVA,
>  };
>  
>  struct arm_smmu_domain {
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 59a480974d80f..6097f1f540d87 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -346,6 +346,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
>  	 * ARM_SMMU_FEAT_RANGE_INV is present
>  	 */
>  	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
> +	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
>  	smmu_domain->smmu = smmu;
>  
>  	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index cccf8f52ee0d5..0016ec699acfe 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3070,6 +3070,9 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  		arm_smmu_install_ste_for_dev(master, &target);
>  		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
>  		break;
> +	default:
> +		WARN_ON(true);

WARN_ONCE_ONCE() and shoudn't ret be set to -EINVAL?

> +		break;
>  	}
>  
>  	arm_smmu_attach_commit(&state);

Balbir
