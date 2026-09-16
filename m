Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021092.outbound.protection.outlook.com [52.101.100.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD47E448BAD
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544296; cv=fail; b=WzMc6TrYTMGGXsIlViB6+RordZ2qRXqK2z8QxCSMZ9t7hDpINmbGpRYu1DmLx+N/XL7zoZLhrCLaHed35c67QKmg1zHAYSLaT6XqTO908H1pF13tfLmkHB1lnaFmffKziZ38r9EOnb0m2MOmNOTJERvSHJFZAepOCU3WbNEFKgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544296; c=relaxed/simple;
	bh=HkYuYKgPvt7MRyTpstOnkEz+R7Y5H+FqLBHJtmndCgM=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=CLDHW1H9mLZFigjpcTJm8qLCjxf8RCmjhgPtPuY7WZ9J0ayK1RFm+M5LrdE8DjKaf58ioJQCArfuxf6jQKHpc9dumRjMs4kIE472TfAVdfyn3c7uI6kY/qcOGMqS/l22iUE60ryvlTfBHblEKMTMVEFMqejI8Q2CXv9NhZMU8eQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=My2TuaZF; arc=fail smtp.client-ip=52.101.100.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="My2TuaZF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kGmhcLPLCB4Rt81Q6nAZF5ov/dnpABqIKXOpGzueTbO0IcBw0cFahk7CygufNY29IuIUt+HItWZ6OTfX7QOK3znYhHzPYsnfpAkaYWX6eswr43ZPu/GtMhJx1S3180tUyLaAHcOCOMt+U5ZbNc3Kg+4Edyg2EHOtSwn1WlBPCeCy0EHI5ZKxbliBF5tt6eDri8uuOGmo9N0G2cojQD+zH1iLsAp/weNptchCyMjtkMuylubh7raYmmRMdCowLmhfMnR7I/+IkuD+FEiVcZ7pF7xpvTIw2kAfl6eSd33niqMfgsG2SBx1i6ATeQaN1rkFTweNSDsOKH6KfrKXTKmgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtkJ0e9Gnnehj5tcfKAB5vr9FT9C94hB05w750Y5IqQ=;
 b=Fsefh2wdpK3B+0chMhoEAMMevfWHXagIdFn0aew6sDOsXC05eNUFYx2nbbHhEdoTSASKXhjNgXmQ0fUT9G2DIHG5Aa3g4Rgr5e3XS4V2NshpmWiKUB6Omb7KMhQs3HJGY4dilRw8isBSDJMy6juLIhyRC3WNy7K6yyQrE4HXRvwBRNC9D22l2QU0xlcwSOjLuBG0LKsK9/gCjhfjk6dL5Fz2oXQUZhHmP6lfPc1OEdAMesAsly++Kx1YH1NT7ak1vlU+Z6HVxiGamG1EPAJ/sMm/9ZMxtYwQQ8Dbx0Ij4Fv2+hlum/XfqmtTAaff1KqW9OX2D/KXMpqcej2225f5OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtkJ0e9Gnnehj5tcfKAB5vr9FT9C94hB05w750Y5IqQ=;
 b=My2TuaZFTmG0sTHIhGrdZ3rE3phV0F1n9Je+7exmr3G+w1e7PdO1LEg+aB1NIPA5j32SgQ/IaQOm+7siJmnsGRbNgV9XqldB7tjG5UtT4OP3hR0Gf++NDv85UvBBdaH2FkRihYEIBHonsxWaU1ecUxtDfdfwbioEmifJlmGpEtU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4ab::19)
 by LO7P265MB8684.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 07:36:34 +0000
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1]) by LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1%4]) with mapi id 15.21.0406.012; Wed, 16 Sep 2026
 07:36:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 Sep 2026 08:36:31 +0100
Message-Id: <DLGKH0BATEY5.OS1S70FJCB7A@garyguo.net>
Cc: <patches@lists.linux.dev>, "Gary Guo" <gary@garyguo.net>, "Danilo
 Krummrich" <dakr@kernel.org>, "Sasha Levin" <sashal@kernel.org>, "Vegard
 Nossum" <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 0490/1376] usb: fix UAF when probe runs concurrent
 to dyn ID removal
From: "Gary Guo" <gary@garyguo.net>
To: "Harshit Mogalapalli" <harshit.m.mogalapalli@oracle.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065618.458576452@linuxfoundation.org>
 <fbdd8514-3a55-4cd9-a999-0b0537c6aa46@oracle.com>
In-Reply-To: <fbdd8514-3a55-4cd9-a999-0b0537c6aa46@oracle.com>
X-ClientProxiedBy: LO4P123CA0353.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::16) To LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:4ab::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOAP265MB8560:EE_|LO7P265MB8684:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e39b8fa-e924-431f-af6d-08df13c53bce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|4143699003|22082099003|18002099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	hoqD8ixCm3N86r9EcSK/k89/AkdRmfLDrjVNQiV0s5+r87nT+zLhvi3AkfqveWXg1OFwwBzvCo7Kw5WSyauu+dWoejq2pjLNaK0Sh5BWh1Xs3medzaXblODq/qDK4OTBcD+It1CSXREdPabmWN2syZWhxiVipU4HJYaML1AKbirGpxTymSY/kLVxGxKrI3A+19x5VcEahBgvZ0+JJHG8GlKoiULU/ch4r/TarhUVflWxSe1+l6ERw0YtEpEvbMBnO+DOh9mlT5c5Bn5zsDAVHVt5nEndPI7wlrDH3VVdqJPjzP+mI0JxhlDp0UbbkNru/KvHKsir03M/xR1wEIRSvc+k8mjQiZci7+yxYHRCIHRcKWJxeuRADenTtj3BWx1OZVmL+LVvTUG3gWwsrmCONczGPHWDLZxObaB7aVq7EU/Dr6y5zhz5TTD2cTQ1Hk1Z2klhxO06nj2xEuXl6Ab2JScGWzNdZclAYKRBVyA41B9JZSVbrLZPmIY2+3Zgm/QobIbswF7LFHMzJd6XPwprPiT2+xLi8VTE9hOgYCK5ogK1Z3zSHI0UzbVWLzdWNDV0EXH+pVYkJJzvU67215gFPrr0DZ2Gj3sMBv2Ym/Jj91h4yTi+gP9cBvmu3YPXj4cn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(5023799004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1Z5cHh4MXIrbWFWWXdRd2p0R0RJTGRBRU9xSVVIbGs1U2RvVmtuc0hVa2pt?=
 =?utf-8?B?Y0s3SHBMdHBGZXVVZmM5emkxd0RZekxyMUI3Ky9UWGxzeWtnUWt0eE1DcitY?=
 =?utf-8?B?bE9keUxJR0NmR05kSmZ0cnFCTldOOGd6eVRwTVRUOFJJZTlwcWc1Z2wxNUI3?=
 =?utf-8?B?Rml6UmVNT09UcGRFOGJPanJQQWNIT3FjcVRFejY0MVlSUThKNzUxUWk0ZzUx?=
 =?utf-8?B?aG95aU1tbDVuanZ5UVF1d1lLZTY5NzFLUDB2M2pVNlZEKzRINUFtZnRYRFFh?=
 =?utf-8?B?d2Mwd3FtYXBRQy84bXdPOGZ6Q2NhV1lvU2QvV0pVaE1kcHJySUR5NkVFbVVo?=
 =?utf-8?B?VXljMmtmRnY1d1VQc0JudFFKa1U4RUkzM0VrTHRyMGdDL2cwWDJYY2lKSTlS?=
 =?utf-8?B?eUg2ekZJY1d3K0JTM0dHbktOVFhJeXkyNHcwYXcwS3d2dlNDKzNuK05tVFVx?=
 =?utf-8?B?bHdodzFxVnMxN2laK2M5V0I0WnlFTE9IeGlkTVlKZUdQOXkzRVV2dGZYRk92?=
 =?utf-8?B?RTZWQ1JpWmVzTWpUVmV5S1QvY29qaFg4aFJnazFGZTVNTDJ4YkJ5K1BmVjBU?=
 =?utf-8?B?M2swZm1zb1J0ZWhBQzFBeEs5ak12Tlg3SFFQdmtUSmEvRWMzZjI5QSs2ZndU?=
 =?utf-8?B?Z2hBU2dGK3U1ZGxvS1VlemFWT1Jid2pvQjFPTGlqWi9ZcmJRTHMxTisxNzlv?=
 =?utf-8?B?eFdLb3VxQmVBdElPOFNwcE9vUWZjZ0RCc1RzN0grb0Z2em9tc0ZxOGQ5MzRH?=
 =?utf-8?B?VFlhaGR1a0t1RzhpbmF2YTFZai8rOWQ0WjRpaHlSelRnNWZpaG4yL2dSUjg3?=
 =?utf-8?B?QUdYZmp5dDRxMzAxOS9KUnhqQmRvdEYyYVlxOUdkM0tES1Z2TXJsMXNsajJI?=
 =?utf-8?B?cFhzdXZoVVk1ZmNkdlhvZWdXVzFmYjJsTHVka1lETXpWdW8wekF5bjczK0hW?=
 =?utf-8?B?bVhhWnFUNmhicUt1eDN2aVZldG5YbHFTVWhJL244VzdmTHRya25tZ0pqc3NK?=
 =?utf-8?B?Zlp2THd2aEd6NFZsMHBBN0NOZFkxaSs5MTdXaVRQMUNNTng3RWRadXR3bkxv?=
 =?utf-8?B?RUVnWG5mUlJPN0wwZm1aM2llSVFQejZhS29PcFNkWk52TUl2T29mNHNFZnhE?=
 =?utf-8?B?bkVZQ2tVNFRsQ1d6YlloZmR5Z3A1Q1dycXB2MUwvb3lPQUdXMlRKU2hUQkpW?=
 =?utf-8?B?Y3hhaEVIOFFsMElRQzdvUDVzYjVHWE9jVGx2OE1RcUVsUDZrVVhlNkRhRFps?=
 =?utf-8?B?YTY0T3dhNWM4QkZ1VkljbGVCL1hxS0J3V0pTQnYvaVhwdEhKREJqTTNoamQ4?=
 =?utf-8?B?TjVkMjZINm1ZWWVtVHEvZXlIT3pkZXp5ZlluWHBFNVl4Szg3RVRqV1BTYWFw?=
 =?utf-8?B?Q1JDTnhZZmlkMk41bE8rTlJXcnVWbXpyM3JVQk9LSXdJb2ZrYk1LakdUdkZp?=
 =?utf-8?B?QThhOGhLdFFiZm9IeWthSUo5TXU5T2lUQlp4RWdhdnh0REJOMWhNZTdtYlZM?=
 =?utf-8?B?VlJUd3NadjR6emZrby94OGVxamp6NUNZRm41UU9PcFVpOEh5WUEyNklvcDRy?=
 =?utf-8?B?aDBCNDJ1anJhQzdCcUxEQ1JXSWtqOUdVSXdtU1U4ZW40YkZvOXkxV0tIQUNX?=
 =?utf-8?B?MUR5N1luenVGWSt4NytzSDJoRnMvRy83UGtjWVdSU3hCUHN0aXN2b3UrYkx3?=
 =?utf-8?B?eFVGZmo3Wno4cHUwcENaWCt6Sk91YkpxMU42RXhESkUxMWlBZUZhNkNtYnlR?=
 =?utf-8?B?bmpJM3Y3WFlZNXZTdWVyTkxPeTBsTTFySE9sSFF4cGdRdFRDOXNjUCs4NkxK?=
 =?utf-8?B?L0NZTkVqTmlDcGdlZkxWcHdsOC8vWXNLcXJQenVwNnpzWTdPMlNvaXFzTmI3?=
 =?utf-8?B?NmdraDJyTk41ZmdBSHlwTCtGUEQ4UE0xbDRWWXplaUltUkJLSkZadjFUMVph?=
 =?utf-8?B?SDAwck01NzZ6bHpBWmE3ZHBETFVCUi9sY0FFZWFrQWFYU1VYSjcvRWpoQUZz?=
 =?utf-8?B?dUJFYmhCcTNZenNmZ1N6ejBZOUFCZnJWTkZNK2lJazloL0lSRnhCVmxHTmg0?=
 =?utf-8?B?dEdZajJDcFFrY1FvNlllajBDSGRCSFd0K0FzRTJUOVZRY2xhb3VBaVY4TDdG?=
 =?utf-8?B?VU1qZWZUWHhBcmNtVmpkWkttdWFBMlQ3cHNFRVVFdmxkcS9tWlFxZ1JZV2wx?=
 =?utf-8?B?QmMxaGk0clI4cU5LRDB4bHJYbDljM1JoVHBnZGl0Y2UvNVVhRkJnZURyKytP?=
 =?utf-8?B?dE1hdEUvM0w3U1lJM25FSFk5Vi82aG1neVlpYithV2huQ0FhYi9Vb3Q0Y0w2?=
 =?utf-8?Q?/OXkeM4QBAisiykFKa?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e39b8fa-e924-431f-af6d-08df13c53bce
X-MS-Exchange-CrossTenant-AuthSource: LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:36:34.4126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: th1NwfKgDu9zdRjjxAAPe0061+S2w8TTEEOh49gHgg8n7o25UFt5UvbepRQY+b+RFxmVgADPNEILOp6h9ktR4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO7P265MB8684

On Wed Sep 16, 2026 at 8:20 AM BST, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
>
> On 12/09/26 12:18 pm, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me k=
now.
>>=20
>> ------------------
>>=20
>> From: Gary Guo <gary@garyguo.net>
>>=20
>> [ Upstream commit ef8154d8b52d60338c1fd8d793cd8e891c604c14 ]
>>=20
>> Dynamic IDs are only guaranteed to be valid when usb_dynids_lock is held=
,
>> as remove_id_store can free the node. Thus, make a copy in
>> usb_probe_interface. Clarify the documentation that the id parameter is
>> only valid during the probe.
>>=20
>> USB serial has the same pattern, but it does not need fixing as the IDs
>> cannot be removed via sysfs.
>>=20
>> Fixes: 0c7a2b72746a ("USB: add remove_id sysfs attr for usb drivers")
>> Signed-off-by: Gary Guo <gary@garyguo.net>
>> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
>> Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-7-632dcf3adfba=
@garyguo.net
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/usb/core/driver.c | 12 ++++++++----
>>   include/linux/usb.h       |  3 ++-
>>   2 files changed, 10 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
>> index f0f13554709e0..528274e3cd7ad 100644
>> --- a/drivers/usb/core/driver.c
>> +++ b/drivers/usb/core/driver.c
>> @@ -227,14 +227,16 @@ static void usb_free_dynids(struct usb_driver *usb=
_drv)
>>   }
>>  =20
>>   static const struct usb_device_id *usb_match_dynamic_id(struct usb_int=
erface *intf,
>> -							const struct usb_driver *drv)
>> +							const struct usb_driver *drv,
>> +							struct usb_device_id *id_copy)
>>   {
>>   	struct usb_dynid *dynid;
>>  =20
>>   	guard(mutex)(&usb_dynids_lock);
>>   	list_for_each_entry(dynid, &drv->dynids.list, node) {
>>   		if (usb_match_one_id(intf, &dynid->id)) {
>> -			return &dynid->id;
>> +			*id_copy =3D dynid->id;
>> +			return id_copy;
>>   		}
>
>
> I ran an AI-assisted backport review, and I have verified the report. It
> looks valid to me.
>
> The core UAF fix is present, but it deliberately passes a local copy of
> a dynamic USB ID to probe. The 6.12 xusbatm driver still computes id -
> xusbatm_usb_ids and uses that as an array index. A copied dynamic ID is
> not an element of that static array, so this driver violates the new
> contract.

I fixed all the drivers first before the core fix, but they're no real
dependency between them.

Those code that do arithmetic or otherwise use the ID pointer assuming they=
're
static are already broken when the ID pointer is actually from dynamic ID.
The stack copy doesn't change it. Correct code stays correct, broken code s=
tays
broken.

I think it'd be good if the other patches in that series are backported too=
 --
but that shouldn't be dependency of the core fix.

Best,
Gary

>
> Upstream prerequisite code:
>
>      int drv_ix =3D id->driver_info;
>      .no_dynamic_id =3D 1,
>
> Downstream 6.12.y code:
>
>      int drv_ix =3D id - xusbatm_usb_ids;
>      xusbatm_drivers + (id - xusbatm_usb_ids)
>
> Upstream first applied eb6cd6d3d8ab, "usb: xusbatm: don't rely on id=20
> table pointer arithmetic".
>
> Maybe we should queue that prerequisite as well. Thoughts?
>
> thanks,
> Harshit>   	}
>>   	return NULL;
>> @@ -320,6 +322,7 @@ static int usb_probe_interface(struct device *dev)
>>   	struct usb_interface *intf =3D to_usb_interface(dev);
>>   	struct usb_device *udev =3D interface_to_usbdev(intf);
>>   	const struct usb_device_id *id;
>> +	struct usb_device_id id_copy;
>>   	int error =3D -ENODEV;
>>   	int lpm_disable_error =3D -ENODEV;
>>  =20
>> @@ -339,7 +342,7 @@ static int usb_probe_interface(struct device *dev)
>>   		return error;
>>   	}
>>  =20
>> -	id =3D usb_match_dynamic_id(intf, driver);
>> +	id =3D usb_match_dynamic_id(intf, driver, &id_copy);
>>   	if (!id)
>>   		id =3D usb_match_id(intf, driver->id_table);
>>   	if (!id)
>> @@ -891,6 +894,7 @@ static int usb_device_match(struct device *dev, cons=
t struct device_driver *drv)
>>   		struct usb_interface *intf;
>>   		const struct usb_driver *usb_drv;
>>   		const struct usb_device_id *id;
>> +		struct usb_device_id id_copy;
>>  =20
>>   		/* device drivers never match interfaces */
>>   		if (is_usb_device_driver(drv))
>> @@ -903,7 +907,7 @@ static int usb_device_match(struct device *dev, cons=
t struct device_driver *drv)
>>   		if (id)
>>   			return 1;
>>  =20
>> -		id =3D usb_match_dynamic_id(intf, usb_drv);
>> +		id =3D usb_match_dynamic_id(intf, usb_drv, &id_copy);
>>   		if (id)
>>   			return 1;
>>   	}
>> diff --git a/include/linux/usb.h b/include/linux/usb.h
>> index 2004a2db81ced..0012259ac910c 100644
>> --- a/include/linux/usb.h
>> +++ b/include/linux/usb.h
>> @@ -1159,7 +1159,8 @@ extern ssize_t usb_show_dynids(struct usb_dynids *=
dynids, char *buf);
>>    *	interface.  It may also use usb_set_interface() to specify the
>>    *	appropriate altsetting.  If unwilling to manage the interface,
>>    *	return -ENODEV, if genuine IO errors occurred, an appropriate
>> - *	negative errno value.
>> + *	negative errno value.  The usb_device_id parameter is only valid dur=
ing
>> + *	probe.
>>    * @disconnect: Called when the interface is no longer accessible, usu=
ally
>>    *	because its device has been (or is being) disconnected or the
>>    *	driver module is being unloaded.


