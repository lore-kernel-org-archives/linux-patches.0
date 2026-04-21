Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012060.outbound.protection.outlook.com [52.103.43.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3E233EF;
	Tue, 21 Apr 2026 05:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776747766; cv=fail; b=PJKBPnPZHQnF2mC/vQqbBGHTN8dmXmkCQ+FwnPO+j/9yGh5+/qTMUd572rKX+MeLIqzX1tAhO9NIc0qlskBN+W9A9L3wDVolveK+NcB3RxnjqG1vSb5eYyhXjFyA2Xm92DF7nk3622FZTTcCSe4+je8G7CXAqjwhthJi8aifi04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776747766; c=relaxed/simple;
	bh=cjsLCF5wJgNtIFUoWtVumfZqz7tzBO1hxMs7gvmYhic=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AjR8iq2+3OMv2rLfEY7UO89UQN0d/QlfDxa/mrPXbaWwifMtmK5WocAUGE6ol+X6S6GweFlot+PxLX9EepgT56Pj6vWL+DEyqzuah6DxsWrAxuLMfI+jSltAMZM+JSor7fNchjTT/RKmVPVpfNPApcx6rBYIuQ7ZO0tKTe9zTeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=gWi3rFOo; arc=fail smtp.client-ip=52.103.43.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="gWi3rFOo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eHLpt7OdcBERWoA9Pxd0N+5R4bvbimfDC1itPyXymSkXwgErH575TOD+i7aBwVA9VwtPi7lAJjOQG8o9Hi/3RdQohZrIkKsECU31wkyUmHNRSIKt29elF9BEzXkjExrlSD+JeStvlnKoH5f0wLTLQyXXZ18c8Ey7IfkQz831ZfyR36zfgdy12rXyYwLmx7TEQhFBQ3BsBLW1lOobzckE4+yXpmBhZVJyJ2lE/23Pb/tYVLI9hJsimjDemuTWQ+p+kgQArFufF2v0AJ3tdtLiKGXwlUk49beYaPRcPKG/H/kIkv3OM5Tbad/atuioUmS01CjAR1+AXMXYgVZiagBDRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qrpbf+KzWEPY10LFN9as5Snsfihzp8k4ec8oxV/9tbk=;
 b=EVHPIi4fnuGVYKEnDRK0xtC6FWqIo3tmyz8pxA68FviBvXh361HaXK7WM88Fg2/oIPuF9FqqyN/dmgVyFnNpw+RbW+rUxJgwNAWn1bQ+wtot9t2fPZP9Px7CCXu3cwsAtN1styBrU+q0kZbfmfPne9SNHCCOzeeXsPMZvO5Vrh2Yzds+czbByH9dOCH3Q0SPo+AuCAlHMjDkGr7sq+nuVANNNIkXWAvehncS8Bob653WGJJ7FTRisD/s+mV4qbOqXS+24sWFpCissXc9cQhNMxJIoKwS9raguzBGz5Mf47bftaIuWEAjIM8hners/tTSUQfb6bmd6+YxHgVmsiyxjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qrpbf+KzWEPY10LFN9as5Snsfihzp8k4ec8oxV/9tbk=;
 b=gWi3rFOoGnZnEJdlq57yinXicl/obi9c4+8hER1hrunwS97JFB4Qelz8oQG72RbqLh4ptA/ejQysd2/lgi4xbHQujFrJccpyOicOiNoxjeCjp0l0FhAXHHxpvXNvuKxKqaZf86V9DWv08sVNssnOx8pafmZll2B3XUMB5Jqe4bfQAbwNZPeJY/RJP6vnAg3NVRfIWl2MzB3LI1i0GGS/88YyFbAww7VO3QL/3INNOREnr80JJY/LHuLR3gXJd6XF5TiTpkN+PtH0sKE8BRV2KSrGArXDMQebN28d/Qh1Wg843Aw48uP6paX937UzclMzr5RqxdJHuT/oVByqHJoJPA==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by SI2PR01MB4419.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b2::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Tue, 21 Apr
 2026 05:02:40 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 05:02:40 +0000
Message-ID:
 <SI2PR01MB4393F7664EC3684BC5D3B241DC2C2@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Tue, 21 Apr 2026 13:02:34 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] iommu/amd: Don't split flush for
 amd_iommu_domain_flush_all()
To: Weinan Liu <wnliu@google.com>, jgg@nvidia.com
Cc: iommu@lists.linux.dev, joro@8bytes.org, josef@toxicpanda.com,
 kpsingh@kernel.org, patches@lists.linux.dev, robin.murphy@arm.com,
 suravee.suthikulpanit@amd.com, will@kernel.org
References: <20260414233607.GK2588311@nvidia.com>
 <20260415003046.2275802-1-wnliu@google.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <20260415003046.2275802-1-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0024.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::13) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <7a2bcb3d-5d5d-46b6-9d8b-499f264caa3d@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|SI2PR01MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: 73c67595-b442-44a6-2368-08de9f633608
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|461199028|19110799012|8060799015|51005399006|15080799012|37011999003|5072599009|23021999003|6090799003|7042599007|40105399003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVBtZStRTlVRMHpkeVIyNGp1bTlLUE1QQ3l3YkVER2JsY3BmQnNpa0h5R1FP?=
 =?utf-8?B?WEVTVzlQSXgyR09uM2ZPUHRRY2pya1FqcktjRHF5aFh4Tk8rNkFCcTFVeStj?=
 =?utf-8?B?SHlzcGMrT2hGcXBZK0JxUkN1c1BhMElaanltSHZpVnZkcjBSRFk3c0prazVr?=
 =?utf-8?B?QU9MYU1PUWluaTYwblJJSHhiK0h4QWpkV2JHQThrdHRkZDY5aVZKS01GL2Iw?=
 =?utf-8?B?VnIydFJLYXNLTStBNWdZRmxKdGpnbWs0OEgxYVVmTFZoVEl4d3A3eUFPUWt6?=
 =?utf-8?B?eFl5OUdRVWZHRE5paUVMbWhmbzdBb2ZyT3c3VldvMTI2T2dUdlUvZDg5aWZu?=
 =?utf-8?B?Z3ErS3docEhQdXZETjh2VnE4UEVpd3RKWEV4bWlMVWRDc2xJTC94SiszVjFD?=
 =?utf-8?B?QndYWTNvNEM4aDN1U2VFS3RER05Vb0k2MHoySEkvdU01MEgrUlo2ZFIzdG9p?=
 =?utf-8?B?MmplZWNBc0VEMkRDTlV5ZWhUdjN4ZWdiakZoSkZrOVIxVSt3OXNwZVdLTGY1?=
 =?utf-8?B?RlFKZmlQd3gyZ2tWVU1jc0JNbDM2QnRJbWNjdm5Pditpb1l0R082V1BVTU1J?=
 =?utf-8?B?cVh2RFZxTFpITG1nVGJWUFBLZlhraU5tdTZYMGp6VlpuR1NMUldjT3QxOEFw?=
 =?utf-8?B?UmNvdDlobisrOFdEZEwzcmFTYmxjYkRNMGV6ak9UV2xyZmk5NEY4Vi80SG9j?=
 =?utf-8?B?d3dVa1JmNVNxNWw2dkUzQXJtNktrUEZDcG5nOFFIRDlxblFhZldMYWl4dHg3?=
 =?utf-8?B?UUZ2czJtdGw2REs5bVk4anVPQXhKd3JkQXJkOVI3d0F1aXYyY25qSXBMeS9l?=
 =?utf-8?B?OWZsaTZGQzcwQkZhVDY3OHY5bERSN092OHVkRGRNSTJvelVsTzlCVW8zd2dh?=
 =?utf-8?B?Zk1JVURPQm40OUdrRFRIR0FwRG1QRlFlOTZVaXZzQjl2eXJpbER6UnNLMnJ3?=
 =?utf-8?B?Nml6cUxxQm5pSENxQy9pbUU5WGtySUIyanRrbjR5VC9pOTFoT2xTR3ZwblNY?=
 =?utf-8?B?TUN2V0h5Umk5bTNGU0lKOGRkOG0wNCt5Q2lJSzlDNkVJZGpxWklkQmF3czJT?=
 =?utf-8?B?bXlJZEpaaVZmRTRYVThZUFE2OVcySGhUV2drek04ZitMZkJGWVRJZUpMU1F5?=
 =?utf-8?B?d21XSlplbU9OT3JWZjQ4OW5kVmhPRnNOOHdCeVFJaFJKNEZ5TU5BTXpTUm8y?=
 =?utf-8?B?aDRzaVZzcmFtWTBLQmcva0VtSysyQkZmKzBHYXpxazV5V3NKZ1cxL0t3NDds?=
 =?utf-8?B?bFdwcnRsVERpUkF2UHpQZFZ4VHpxQ0R4VVl2L1pmODBzTkdBV25ETHRubW9m?=
 =?utf-8?B?dXpNVm1pYkFoNG5JWWVYQjdOODIrMjR1ZW9jb2k1djJ6eDZTeGxzbzErVkU5?=
 =?utf-8?B?aEdnMUsvdG15NXc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TE1kUjJlTmo2OWZ1a1FwcDYvOTc5NFhHUXNZQVZIWFJwZ0F2NEVOSkVkM0hK?=
 =?utf-8?B?VjRNWFdWRHZIQ0ZkNXk4WTQ0a09uTkJObWcvbHJCcTFNb3lvaW5pVVVEU2hr?=
 =?utf-8?B?NEdOL0EyOEl0V1BtUWFJK3FhZmZnbjJiSkRwZUg5UTIxYUpWdFNVS2hLdDd5?=
 =?utf-8?B?N3owQ1QyQXdHb2NvcFNHQkhhMFVrN2UwN3hOY0M1MFZyd3JKSWVDZ3NuakpC?=
 =?utf-8?B?L3RxTjdoM2RzeTBnUWhNY2UxWGhGZk4xSGM1aDBOZVptQ2h5SEt5cDZLckNx?=
 =?utf-8?B?QncwRlRPMUVDVXNkMlNSbndDOHg1Yy9PWFBhY0NFNFViK0NPUm9iOEU2ZGxJ?=
 =?utf-8?B?Ull3dGNvWStqbkIxS1ZzRnVjRFRTWWRWRm1mZGhOVnplMmN2WVNPbzBnVkRq?=
 =?utf-8?B?VFVqUm1MT1hhYThtaWpqSElOU3Q1R3YvTXprc1orWXhLVDFXRFo3eE1tY3h0?=
 =?utf-8?B?NCt1aEdTaWhXMnkyS2R3b1Ria1ZqU2xIYW1jeE9ZNS9wdTZyYXFMeS8wOHlx?=
 =?utf-8?B?Y2FtQS9MVEEwSGxtVUZpUmViMlk4dHRZM1hEZkZsV29pNHowZnNMY3pzLzd4?=
 =?utf-8?B?TnVFODVWTE4zSGxtMzc0ZG5LYUpYdFBOdjJxVDFlbHYrQ2phbE9PeFVqSUtr?=
 =?utf-8?B?MEgyRTVpYjlOTTFQTnMwcFgrNVE5TmxyUmtOVXF5aTZhRHA0QktoQlNIZUtx?=
 =?utf-8?B?SlZIdlNudEE2QysxRG43OERlaGlYVXhlM2Q3amMwM1NmWlAxZS8vMDh0Y2JR?=
 =?utf-8?B?SGVxTjFsNUU4V3prZm9aUS9WRVl6djQ4c01NRFFhRi9jZElSTmloMm9JU0xs?=
 =?utf-8?B?YjY4WUdrMGFsR1FhN0dXUk03bkdydEt1dTJEdHU3SGEyczA4Tis2Q25JU3Ay?=
 =?utf-8?B?Z1pGcU8zVERicDl0NWZSVzZXbGlidlFDcnRBSTd4SUlIRW42bHZWTXR5V1BT?=
 =?utf-8?B?ZXBEV29jSWRTaXV5MnczdTF0TEkvcnE1aVA0OG8zNFBWeWlseTNkRlJvSnNO?=
 =?utf-8?B?cU8zNnlyOUZpeFNEMTRYRGdINThDeXdRaml0NlpkMVk1RWpINzVPOC9xMS9S?=
 =?utf-8?B?bUJ1V2FHWmtvNGVIN0FFUzNNUS9YY2twS2c2QzlJbHNOT2RuajFqMHNrVVNI?=
 =?utf-8?B?VEFRbGJCUGNVNTNiczNYT1RXSUx3Qk9iSy9qUWIvdkxGeW9JWUNxenh1THFj?=
 =?utf-8?B?Nm5hWGx0cWNLdi91Tm5abkNOU0Y3MG9xYUFyOVd5aDBabnpKL3U2RGhEcnQ2?=
 =?utf-8?B?eUlSc0loc0tqVCt2MlRiNkNJbkV2VG45cU1nOFFEWTMrQVdLVFpjZVhZRzBi?=
 =?utf-8?B?MUg0dy9yWEsvM0NTWm56ZUdzUXE2S2EwbDVEMUdCK1J1MkRYSDBUcXpxUnZt?=
 =?utf-8?B?S1ZXZzhkNVhiSFhobFFaZTRRUUxpTXdVS1FLdjN6Vy9vN0JGUGswNnF1MTZx?=
 =?utf-8?B?QUNCbWRTNHZEQ1dTejcwY1JCTDRLNjhKODNkaWtEOFNYU3Z4b1JwdDRLWmh1?=
 =?utf-8?B?WTBzTTBPbjVwRGhaY0NiV0pxbXIxRlpRb2FkUjVIUU1DV3NYT2NoOWRxb1lM?=
 =?utf-8?B?QWxDY0NEUis4Qi9MSWp6aUhmQWQ0RlBLQm84TUU4ajN4Sm9ONkdSYUFSM1hm?=
 =?utf-8?B?Ynl5U3pQbWRERmdIZTdKUXRVZTYvc1pFZGpXOVZMMHpETXhTZkF5YjZlTVVT?=
 =?utf-8?B?YWZVYU9qdFhvTUJYdGx3THlEdFdwemdUZCtmKzJlM0FqengrdmhNSk9IaSto?=
 =?utf-8?B?K0NKNjVaTjlmSm1HTmFzTUdhbFppMzNLclJMa1gxT09LU01Vd3dVVkl2YmUv?=
 =?utf-8?B?ckl0RmNmd2dtbVpyZHlXYmNubWE1RU0ybmZ4Qm10VzVNR3duUnlCbDNBL3JJ?=
 =?utf-8?Q?MQJ/mhFwQQU1V?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c67595-b442-44a6-2368-08de9f633608
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 05:02:39.8231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR01MB4419

On 4/15/26 8:30 AM, Weinan Liu wrote:
> We have observed multiple full invalidations occurring during device
> detach when we are done using the vfio-device.
> 
> blocked_domain_attach_device()
>    -> detach_device()
>      -> amd_iommu_domain_flush_all()
>        -> amd_iommu_domain_flush_pages(..., CMD_INV_IOMMU_ALL_PAGES_ADDRESS)
> 
>        	while (size != 0) {
> 
>            -> __domain_flush_pages( flush_size /* power of 2 flush_size */)
>              -> domain_flush_pages_v1()
>                -> build_inv_iommu_pages()
>                  -> build_inv_address()
> 
>           }
> 
> build_inv_address() will trigger a full invalidation  if the chunk
> size > (1 << 51). Consequently, the guest will issue multiple full
> invalidations for a single call to  amd_iommu_domain_flush_all()
> 
> Without this patch, we will see 10 time instead of 1 time full
> invalidations for every amd_iommu_domain_flush_all().
> 
> Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a VM")
> 
> Suggested-by: Josef Bacik <josef@toxicpanda.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>   drivers/iommu/amd/iommu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 760d5f4623b5..59650a44ab50 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1769,7 +1769,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   {
>   	lockdep_assert_held(&domain->lock);
>   
> -	if (likely(!amd_iommu_np_cache)) {
> +	if (likely(!amd_iommu_np_cache) ||
> +		size >= (1ULL<<52)) {
>   		__domain_flush_pages(domain, address, size);
>   
>   		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
