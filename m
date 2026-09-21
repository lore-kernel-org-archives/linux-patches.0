Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55934F55B8
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790012765; cv=fail; b=Hwz9fxFwGJQoQcLmAuwNm+VCsSq45leV9Nj8HyGs0CDIW7oj5Zhxi0c9ZXCZLdT7u46qYQYEzpbTsDYHP7Y9t+yTcNQfXSIelGmJuziwOUEzNxQEAKfTG2w/0fXJNl+Jxs4v0TafRkySp2flOVXf5cqRgHxKe6IEDoXwHuEAUhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790012765; c=relaxed/simple;
	bh=dtgPEMYnfnJMjzFzbfoiW1vHpbD/zGgeNjCKAVA/PEY=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CUQCrDXhL0TF+JyjaL1fmoxj6PL9aqFVd3kPgzUV0YaI5kVXtiXLY4jrVwTb52kLRAN6LAoi0wLrT5I4ieu2cZxwMt3gyr9cIiWA2kfHI3XxoMAcaA3LC2a2tIS/h08zbGlVX20hGGYUt1PAoGhXn4608vvrQKZAaGsEGYw+BNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cDjpWAut; arc=fail smtp.client-ip=52.101.52.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cDjpWAut"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUKHG3ItgVanba7E+3XNd8w7kTif+2jc2OCqRLhr89NlobddyMSn9qMGUO54HcEJAz7JYmRCukhGs/9h7aiXhHNxliSdOVShlCNU9EK/fn4PC3YE31pVLelqmAiWzKHb9SMmE8wXwQ6T7wOFU1pWI0jNCkVTHL6BmFA+SKllnYJfvwqRutXDk+/lkf4jCZJa21jNZvGS3nPzwmHaD8PcKgcjX+b/Au3K/uv9Z7D8nIiwFRMAQfKgQZm5uksDmp4HRJl3m4UGlv7/BHiGKBDqHBbTpFI+tHiRlzHXxFJNC37b5hhGtvZqPMHZtUiDK05el9QP5Sqo077OwIv3wwuHfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ak/3ZaNWetveZqyf4A/j5CsTqC1NRVUPpb9TyeH6Ic=;
 b=fH27GwUDOvDZwp7PsFvyn/dToSXBPpc+e5x2Z7her5t44AnNDvKQpG9ErfhtsWiltH4v091juZFw0e3VGHYlsliB1EvPK8Z6KOwy7FnlUOAQmQ9jLvANKgWckqLJb+FiItErh78ThZMC7nXQE6/1KmnJ+7LiZBecbTAcKcERMuQnlza8TQTQvltn6v/+i6mQ7dBNeeV3N/icFYW1wos/l6WDzDXjbU4uW37ACsAYnMakfufThez0xCpUrVojUHv+r67x2DpEQy7EdapG8HozKdajX+/deJMYZ1XuNB5sDewBrKwebQtJoDhEvGPdhcXXOLcZ2Jgwq4og+q67nVTV8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ak/3ZaNWetveZqyf4A/j5CsTqC1NRVUPpb9TyeH6Ic=;
 b=cDjpWAutHMlwZvTYat9Qol6CMlF4kqjHwxpx35ooDYrwn621+GxtRDyGO4/wY4N6u2sxq5SuNtcIWBBnM+KrsVBBL6iY7NJBT6UT9JvjgPh3PdaSYZ6aysrUYXW4z3e228sdfaFZvUmp4vscPI9D2ypgdOkOvFgLzdURfx9TjIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 17:45:58 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 17:45:58 +0000
Message-ID: <8bd7c456-c11f-4c8e-9b95-6825a00194ad@amd.com>
Date: Mon, 21 Sep 2026 12:45:56 -0500
User-Agent: Mozilla Thunderbird Beta
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v12 14/25] fs/resctrl: Rebuild free RMID list on each
 mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>,
 x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-15-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-15-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0257.namprd03.prod.outlook.com
 (2603:10b6:610:e5::22) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 3307319b-89ba-41a5-7223-08df180831df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|4143699003|5023799004|11063799006|921020|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dgC4yF6khsr49zHDU0uxua0ujDdsd36cMY/9b3vQNF8NUKqlfgUU5dkvViaOuWrNyaW9zB5UdIkeykls/9cxDYNlxQVBp+BqMfrJOe8UO7WYLmEk/oXHAw9BA6vdKe0Dnf+GaAiu/cIOOU+WV1VRSDQebkUapf10phDrI7JW3nVdGmTp/9Sp1HBEpodW8L6CT6g1DzqFjFXFINkl1uW0HOB543/3yJVjuJGEOp35PTClOyn7GPRkZh2FZ0oLYWpIhwgDoiSF4SqWyOAi8cKJVH5s9K2Os4hfGeGvrlOa76hR7TG/YNICTjPhijRrxfltQq4OjDJ2Fr1IuPD5uyrpj4LE57TdxzDjfNd4rc3bJOZro8x8w1Z1YZ6bkwZj1PIlqK2yFke2yvMZTB17fyssvIgauL6/Vo1614905bHpDFJyTyIsRY7LpnBDPteCIazAblEyBOgLJq0f8gl/Cf1wyXSSvObjB8XLpgpbt1UN3zan/rTU4o5DahxKdzhB4PSsrNkgmyPxTS5FAtyUH7q6q/AORSmespFWEoxXbGmmMSqmBPmNelPiVTvhsVUV9GYyKYPw/2mejN9zWgEKdgG0nijyHJvVxQgI49zX7khzWh1PbmS9gE2TjvBRTA+g2uoeTWogagi7H4PQRqKMNxR7qUSIOYR5KEt84HI+SfZLCARTwjhtnkbaS26eDUbqKAtn+sgTwSTHoJ4IybWQ/1ejNQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(4143699003)(5023799004)(11063799006)(921020)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFlGcWErblVxYm50RU5SeHhyUE1MZWF2R2xYTUdGZk5aM014em1zNy9WQTI2?=
 =?utf-8?B?WmtBUEtnNUdKUis5WW0wejJhbkQ4SGJKeWxrUXJyUCtKbGpheFhXYndmaWdU?=
 =?utf-8?B?RUVTRERMM1pDVkxWRzNrT2hZc3RVSVhSV0kwUVQ1cU5rWUtNUHhNbzN6WjVm?=
 =?utf-8?B?a2o3bXJuYWRxT3Fpbjl4NTNaSG12ai9UNFNXYVhoM0V6c2NyS1JJRzNiSWRI?=
 =?utf-8?B?TEkyZHBYNW9BMWV5RTlBK1E0SUpyVklPZEo4YXc5T3FvVVFoRzZkZDY2Yi9k?=
 =?utf-8?B?eG1SUU1veXo4Uks1R3MzNUg4RU5ObENlMWdxRTB2NXVtbEdDckFaSGw3M2lv?=
 =?utf-8?B?Sm9aT0x1VHJkalRheVAzcjFnWFIwMmdWaW1MODA3ajVES3FsL1FkN3g2WHNQ?=
 =?utf-8?B?SGxnWGMxckZJdkdZemJ2dlhWT0MxL21UQ0ZIdmhRYVVacXpSZHRTR0FRbjBZ?=
 =?utf-8?B?Z05TblBOK3lEbjhXaitONU5zQXNlbG5GdlBucEpsL2NQdTdyN1NGdkxvVDY1?=
 =?utf-8?B?eFZ5djVqVUtEcVNWWlRycTA4OURrZkVnd2pXUEZKU21IV1FoTUdVdzQ3c0lT?=
 =?utf-8?B?dTd2RHJTbk9PVEJmU0hGQy9FaEYvaEZmRms4Y2JPZHRYcmZBYTBTWHdBY2NT?=
 =?utf-8?B?N3l4VDFwVkpOV3lyQmJGZ0k5M0E0NmFNZ3hPU2VUaE00RlcrSCtBbm4wZlZa?=
 =?utf-8?B?QnhTRXVXcUtwZ0VCNzg2clJNd2ZCRnR1WlBJU0ZVL1pyUmQydG1GUXpTOGNZ?=
 =?utf-8?B?bENXR28rY0VpYmU4SklsOXA4M1RCakRrUEJCRERGd1llTk5KVWx0VzJFRWJi?=
 =?utf-8?B?RlNLdFYrNXFEb1BSNVZ1cEIwNlNObVdMNkwzQ2QyN1Jnb3VvZ092d2JlUWd3?=
 =?utf-8?B?cEM4VXczaVpLdXVJNFhMSDY1dDF2cHY3elhLbkZzMEl1Z1JLNG16bGsxZGd3?=
 =?utf-8?B?NHcrNGJlVmRQMnBhZ0xuOTV3d0gwMnIrV0ZsdUdNU29jMjE1VXBBRTQrSzZB?=
 =?utf-8?B?M2lEWUJNd09GV3doZS9QVnRLZjZvUmtYakFDOVc3SGVDcmVSU0lvVTM2b2U3?=
 =?utf-8?B?Y0xqR3ZSOWxxd2VTdE4xQVQyRnc0ZDlLYkpkSXMrbUNQS2xkeGRJSGdrSG1s?=
 =?utf-8?B?TWlReVBLY2lVWUxMYlQ1Q3JVa1NvTEY5Nk5DWWp6Yis5YXJDYnhkNlVXQ05T?=
 =?utf-8?B?ekNRdFVwcHlodmNZTU00UzhYZlcrbDY3Y2xScitYdkQ2aVVTSlNmWTF6dWox?=
 =?utf-8?B?NHVIUFVEZ25MUGN2VGNpMGdKL1YyY1I0ZG1DalJaU3hudFVOeUduR25HNnBH?=
 =?utf-8?B?OTA4S0l3eU9XeEFvNEJrd1hKdVZuVitwNGZFWGdmb09ZUlZMSytCTGpLTXNS?=
 =?utf-8?B?ZFF5clpCbjhGcnBkbFdXQ242Z3dPN09pTEUzQkZ6VEZ0VFlVY05yekR1SHU2?=
 =?utf-8?B?ZzBSYXU4eUpkaEhGVVlrZ3YrclRSbkl3SlVzNzlRMFVFNlcrcndHcFJVNjk1?=
 =?utf-8?B?aUIrK21aaHQyU3FFY1NYSWhiNDlva29iNGJCVTBmUUlGeXlEMkY1dkxlaVN5?=
 =?utf-8?B?Nkd4YjVmZlhjN1k2WlJzalVUbW12am96d29BbzQwNERoOGNYd1p6ZmNHSVRy?=
 =?utf-8?B?aTBkOVQ3bXRLNHJCQ2lVVTdHbEFZWkt5OWp6aWxUcitQTlZRWGY1ZG9JTnRx?=
 =?utf-8?B?dkdWeFdyMzRDeWtOMjI1MVl4eTErajFkazR6U21LcFlnS3FhdGdvcnM0OVN6?=
 =?utf-8?B?UG5yaG5mWmlnZjdjaUNUOUlFQWxzSEQrYVp5b203MFdFY0p2bE5TK2haVXZq?=
 =?utf-8?B?STJUT000R2dJL2dmVFQ0S1YraWZNVjNOK1EyQktmbTNMZmNuNi8zYjJldzhD?=
 =?utf-8?B?T1hqQlhMSmdQL2hnK3ZtcFJQVmlEV2gwVkh1dlcya21wdXNYNi8yazJ6QXJz?=
 =?utf-8?B?NTdGWDJzRlJSYmdXSk5kWWdRVjZlL3NMbzZTc0ZrcWUyRkFZOEY2dTFqRzYz?=
 =?utf-8?B?K3BKWWNkaFl4VzRpM084TzdCK2VwMWQ3SGZ4WHFaNDkxYlRpMDREeDhvRXdH?=
 =?utf-8?B?SU1hZXJVaXhPWTBxOTFMU0RJbFdtZVVFaDRkZy9udzB0TTNveXlkNTduMHln?=
 =?utf-8?B?dzZlVGV5dXJYbkhHWmdNbnZrT2o5Q0VwUFlmWS95TVJPN2lDaUQwUnNKamRQ?=
 =?utf-8?B?bjNRN2NKSG5UZzJURWFEaUNNUTZORG9nbVlFRmZrVGRTVHFGNklWdi9DNjZo?=
 =?utf-8?B?a29mZUxpVHFudVFCTmJlMlp1eCtubzdWaWhHc05GSEtyTWZYaWE0NXYvVWwv?=
 =?utf-8?Q?K8pM/Q/Lj5oMCIkWwo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3307319b-89ba-41a5-7223-08df180831df
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 17:45:58.6329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9hI/bDpCW6u3dZT7EbGqoTDsz7XD0IFHxX3q4CHtRnpkBHohV5Vf4D0Klafxwjs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651

Hi Tony,

On 9/16/26 18:13, Tony Luck wrote:
> Application Energy Telemetry (AET) event enumeration takes place
> asynchronously. Linux builds the pmt_telemetry module into the kernel to
> kick off enumeration early enough that it completes before first mount of
> the resctrl file system.
> 
> Allowing pmt_telemetry to be a loadable module means that it is possible
> for different numbers of RMIDs to be supported on each mount, depending
> on whether pmt_telemetry module is loaded.
> 
> Initialize rmid_free_lru based on the number of RMIDs available for the
> current mount cycle.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v12:
> 	New patch. Split from patch 12.
> ---
>   fs/resctrl/monitor.c | 64 +++++++++++++++++++++++++++++---------------
>   1 file changed, 42 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index b8bd59c52c62..8dde2b81b72f 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -75,6 +75,11 @@ static unsigned int rmid_limbo_count;
>    */
>   static struct rmid_entry	*rmid_ptrs;
>   
> +/*
> + * @num_rmid_ptrs - The number of elements in rmid_ptrs[].
> + */
> +static u32 num_rmid_ptrs;
> +
>   /*
>    * This is the threshold cache occupancy in bytes at which we will consider an
>    * RMID available for re-allocation.
> @@ -975,45 +980,60 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>   
>   int setup_rmid_lru_list(void)
>   {
> -	struct rmid_entry *entry = NULL;
> -	u32 idx_limit;
> -	u32 idx;
> +	struct rmid_entry *entry;
> +	u32 cur_idx_limit;
> +	u32 rsvd_idx;
>   	int i;
>   
>   	if (!resctrl_mon_capable())
>   		return 0;
>   
>   	/*
> -	 * Called on every mount, but the number of RMIDs cannot change
> -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> -	 * until resctrl_exit(). Note that the limbo handler continues to
> -	 * access rmid_ptrs[] after resctrl is unmounted.
> +	 * Allocate the largest number of RMIDs that this system will ever
> +	 * need. These cannot be freed until resctrl_exit() because the limbo
> +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
>   	 */
> -	if (rmid_ptrs)
> -		return 0;
> +	if (!rmid_ptrs) {
> +		num_rmid_ptrs = resctrl_arch_system_max_rmid_idx();
> +		rmid_ptrs = kzalloc_objs(struct rmid_entry, num_rmid_ptrs);
> +		if (!rmid_ptrs) {
> +			num_rmid_ptrs = 0;
> +			return -ENOMEM;
> +		}
>   
> -	idx_limit = resctrl_arch_system_max_rmid_idx();
> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> -	if (!rmid_ptrs)
> -		return -ENOMEM;
> +		for (i = 0; i < num_rmid_ptrs; i++) {
> +			entry = &rmid_ptrs[i];
> +			INIT_LIST_HEAD(&entry->list);
>   
> -	for (i = 0; i < idx_limit; i++) {
> -		entry = &rmid_ptrs[i];
> -		INIT_LIST_HEAD(&entry->list);
> +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> +		}
> +	}
>   
> -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> -		list_add_tail(&entry->list, &rmid_free_lru);
> +	/* Find how many RMIDs are available for this mount */
> +	cur_idx_limit = resctrl_arch_system_num_rmid_idx();
> +	if (cur_idx_limit > num_rmid_ptrs) {
> +		pr_warn_once("RMID count %u exceeds allocated %u; capping\n",
> +			     cur_idx_limit, num_rmid_ptrs);
> +		cur_idx_limit = num_rmid_ptrs;
>   	}
>   
> +	INIT_LIST_HEAD(&rmid_free_lru);

It is possible the list is not empty at this point with difference in 
numbers from one mount to another?  Should you check if the list is 
empty and clean it up?

Thanks
Babu
