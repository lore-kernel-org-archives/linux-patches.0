Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972DB12FB18
	for <patches@lists.linux.dev>; Fri, 19 Apr 2024 15:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713541145; cv=fail; b=Gmf8A1ULspsUKJqftbMCrRF9Ke4Z1APGM8EHdbtP+Neo3iqXULhDlrRGZpWFxrAwFduMcWJfLsm2YMBlyq8wrQRIwvurH+ITmnL2LwqYPTUF1KapgqV54LTjG8Zj7JIuYZdXfBs3qObg95iJufD/w/IUPBiMNencPIsJiLftcM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713541145; c=relaxed/simple;
	bh=zUvEbheiRIsvibPlAHVsxMplWdFTGWqjC+MOtGL3eio=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q0RzCwQNFEqb7PKzibbhXIEbfsBAYPyxJkba/heLcG2nFsYhF4jr9Rn2jHGnZzG2kNtouT8piktYwADcQISud0RrSO17Lsu7KiN/NYnTfLgGCBs8t/B75YZDSBVargMNM4kOW103s5Ab3sY3n44VDBy+f/NCvid6UpHQDFWUmW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kw3SDyD4; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kw3SDyD4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713541143; x=1745077143;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zUvEbheiRIsvibPlAHVsxMplWdFTGWqjC+MOtGL3eio=;
  b=kw3SDyD4+k+56VrHEtZIB4scOIAPTZcuh/8mRETY/rdAzxgrjoIXT4I3
   7pTEiAdaB1n/kE4B+pufIKLPhjD5epP5r6Btho9o6XpDqjPYwx/grgTUo
   5Xemf7Ra5TH6QGMYM5GyMxa1tDRVXAYj1dWBtA28OhM+QseINRPZcqhF9
   5m7q67WsZt84lRrgGIiX+sOYkiVwYiqbqxpJc9YmAV89+NGsSqM1nXAFj
   POm1M6amrYlKwJj8gkM1c1zq1/0eaavFHpcbRF3wnNOZWs2bzvLadjV3k
   WFx4n0P2te9Gn2nFH5xG7UzFEHQgSjRI4oqoAcq7IFihKcfkkJpJiYbJZ
   Q==;
X-CSE-ConnectionGUID: P3R49wymTN+nc+8hTF6IhQ==
X-CSE-MsgGUID: U3IM3nUUQHyFBsO7XrrWqQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="34545360"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="34545360"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 08:39:02 -0700
X-CSE-ConnectionGUID: J2+EHRAeRm+Ve0XJwvk14A==
X-CSE-MsgGUID: vbM5g4WTTnC9ykdBU+IK6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="23352191"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Apr 2024 08:39:01 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 08:39:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Apr 2024 08:39:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 08:39:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwDZc4oqmXOSrbYjF5TUspu3a9ioM61gfD3CTaRa7dg++6z3BgR6E+HCnxG4oWZVlBLul8eWCbC+ESmU80N0TYXzKgLkFq7JfXu0RSaq9BN2wecD9yNsB1NNWEZeFqaiJVMoi7UU+8tuKW89HpnbQhBSCWv0yDiZvfh/tnh+tA+ixCMKDdjMgVfuIcPc2ZM1G7qzik+S8VDhm7uNdtauVFtI4yt1Vjk2vpfx+TkPlTRrY0lNfs75AFsFssGCe0AGNW8eQm6XMQ0mNEqiVyMkp7NpRJti9So6qCkLM0gXEtC+q7vgGRl/EuTEqnCJRj+1zAz0EVpA3bXoXoNn7DxP1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbGVOkVzyasVIn3hIoluqPJBP6MejVrepofwd1z5dxY=;
 b=dd7OzFL+Djly1fu1csIqeIElFxt+K7zRJB96VhHtCxf/RcVPMUx1WiSfpIO8mSGMpc0zv0H89h+w69j4FTFbauHKENHPSBJJ+3KPdcgEKFAg3IZmMZFzVWP46w5p962C8e8KOH0pMwBOR/65mQLNZKLsMOxDTcLeCCevuoQa9I9CtyWxanaYLyf8seW1CHf3MTBQQDgtbo5fOTH5USelCIo8BAlZeILb42tQJM2gamLe5kZj9hJlCLJTtveEK+iQqOvs7QWfK4mrQe8Jo2CDdK6O+Kih/zEjHZGqU4DZAPUcYE1ZR9KCMPZJ1YhClXqA26Npzyzw/TOD1BaKqujAEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL3PR11MB6435.namprd11.prod.outlook.com (2603:10b6:208:3bb::9)
 by SJ0PR11MB4975.namprd11.prod.outlook.com (2603:10b6:a03:2d0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.12; Fri, 19 Apr
 2024 15:38:52 +0000
Received: from BL3PR11MB6435.namprd11.prod.outlook.com
 ([fe80::9c80:a200:48a2:b308]) by BL3PR11MB6435.namprd11.prod.outlook.com
 ([fe80::9c80:a200:48a2:b308%4]) with mapi id 15.20.7519.010; Fri, 19 Apr 2024
 15:38:51 +0000
Message-ID: <7158eded-ff79-9de2-d918-f4a32e216822@intel.com>
Date: Fri, 19 Apr 2024 08:38:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.8 117/273] e1000e: Workaround for sporadic MDI error on
 Meteor Lake systems
To: Jiri Slaby <jirislaby@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Nikolay Mushayev <nikolay.mushayev@intel.com>,
	Nir Efrati <nir.efrati@intel.com>, Vitaly Lifshits
	<vitaly.lifshits@intel.com>, Naama Meir <naamax.meir@linux.intel.com>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125312.934033981@linuxfoundation.org>
 <809b5785-e65f-47f4-b52b-f9d2af0a3484@kernel.org>
 <1f4367b6-7d56-4a81-a271-9a4e7089f6ef@kernel.org>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <1f4367b6-7d56-4a81-a271-9a4e7089f6ef@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:40::32) To BL3PR11MB6435.namprd11.prod.outlook.com
 (2603:10b6:208:3bb::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6435:EE_|SJ0PR11MB4975:EE_
X-MS-Office365-Filtering-Correlation-Id: e76f36c8-a32a-45be-315f-08dc6086d021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: uyjjKmVzH50AHLoe0qxJCU3a9AJpv3EL7+c7Lgo1LzCWO2QSzSC77bTztSCUbvMe7RWiZfxVGuoMoJ2WmZrT7ZTGe5pF2/dVtKCd1DIxO7AyqndEuWUIfJoNWmEjW954g2NnNwxziLDuz0feodlEY9S5XCVGgqndYl7rq8VKSz7zPwzgsOdq6gDSkTKUYUYtfNxNP2B0KIwGnr0dfB5jAAJSDAf3h10hjiT3kvGMnUpPjLDMYUdLMoMs9dtlwokqviAXF2Gy48HdCZRa9Yc1M8dbustK17JM4Jrp4Y1sNAbyER/nK+uwwLnoclVTcuQ5UJin0x5ozff+wAiNYQAb0e78PDEpcgJ/1UEi0C4koHcZWxm5jObw7fWeJftV1VJJIUCl42g5UmHgpTRC3iJAyOVnlrMuE+TPaYTgXZXBcgADEJg/yjkzE7K38vD4SDDvsXeaBUdFazJKVe1jWW2VssiOdoAya5vNUp5d3aidWjctuoSRCuZ9s8YJyZmBI1ydzIvzWCSP982PXVrch/w5LBlqCKPkL3TaBzjoqiMLQuKqdJE0/+pZMjhwGUg1RmxVn1/4w6Un5nkhPnbzJH4VX3xfKNeHBCdfJV1jLnoh/NQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDNwbFpYQThYVW5ReFMxVWVuSFhFcFpmSXJFWXV4S2ZKRFQrRXovajVvNzNX?=
 =?utf-8?B?bFozRHRzUllFVlBta1gvdzg4ei9KS3ZudlBrOW5aVjhIZHJOUS83UVY0OVFr?=
 =?utf-8?B?aDRXMzA3T01yRnhiWnl1K2QzN1RqaUcxVVhNTTlMVEZMZDVMNXhrclljcDdi?=
 =?utf-8?B?d1gyMi9DOHNtTFBiMnY1ekVzcmFMblhSRVMzYjVBWHJxRXg1T3JiTU9TM29q?=
 =?utf-8?B?YmVWejBxdTREWElFVFJQL0pEdlVudyswUVFjNE1jb2htOUYwYzBnSlBxMlhZ?=
 =?utf-8?B?RmhNeXMvSkppS2p3TTJCRXAxUnB1UlB3cUY2QmRzQmdScGw3elltUUxXQlZJ?=
 =?utf-8?B?WGxOY2x0L2RkSGhmamRtTXR6ZDNCcEcxdi9OZW9KL29QSXNGNnduOVdtbitX?=
 =?utf-8?B?YmVxRWFDdjhYM0RyeDRteXQvRURmb0c3TDd4ckVWYmFXZG11QVZkQXRNMWRq?=
 =?utf-8?B?Mk1WVXZpNE9IZW9vQlFYWXoxT3dmOEJTUnFMa09aTkY3a01FVlAzR2k2UFcr?=
 =?utf-8?B?VHB5Q3hudDQ4SHhtOE9iR01XNnE4Z3RJaDg3L3FaTW5TWm1TSURlbDhycDZW?=
 =?utf-8?B?TjBmZ09oWG1zU2JJTUg2VE5LdVh4cEtOWHVrbkVCbFpndnc0NDdEMmRDcWov?=
 =?utf-8?B?Vnc2eDNxWVlSSzdoWHBDaFFvYkEwY28xQVVlWG5OUkNtSGpQZTVaMDUweldi?=
 =?utf-8?B?aVhXSWwzbUlaM0lhWXRFQTI1bEJUUS9MTG9yV0dOMFhUa2VBbkZmcU9UZDNK?=
 =?utf-8?B?TVh3b21LTU96TTd4SGhheDJvM0VIUnNSYTd3cVoybkJSWXlKa2R5VmxIUTcy?=
 =?utf-8?B?TTZuNDhwUlNoelg0aDM1Ly9lcXVDd2x0RzAweitpTzBXaVQvbVZ0Mllua2lI?=
 =?utf-8?B?SnpVbVhzNWJxN3QxcWR5aHQvbFpURWRwQmpZdHNnbm8yOSt6UnJMUkhvUERm?=
 =?utf-8?B?aURKRHZRUmw3TXJla2M2bGlHNGRDNFdFbkVYUDRtTElMNE5FenByUWh3c2w3?=
 =?utf-8?B?VlRPeHI3a0hEVkkrenRpSW1iWkpGWEpENVBaeis3eDk5OFdRUkhqRG0rU2Rt?=
 =?utf-8?B?OGpkOGZPZWx1RVo2cnFOekJYbkxSemhSRFNsNjA2aVJlUGdxd3VyR3AwN0N4?=
 =?utf-8?B?MGJXUDJzcFNpSlB3RmF6MTdxNTFZUlFVbnRoK3NZWUgvSzZiYU1RaDZ1a0Ji?=
 =?utf-8?B?OEhRbHR6eDJuSTgweTE0ZVRFYmlKZWdFTlF2dWsrQUNLcG5TajU3bmIweVdU?=
 =?utf-8?B?eGpIT3I5S0J4RnFYb2lxTkVPTnhXdFZlTnZlUko0dVI0YTlaQVVHa0h2NVVI?=
 =?utf-8?B?Z1ljTWUyWFkrNFp6dlRpZ2tabG02WGxmYTRlU2tJeUlsQlhrZUhYeXg4VkE4?=
 =?utf-8?B?TEJnTUthYTcyQktWUG1XRnRFSlRUUEpLOHJuTG53RS9EMytua3FsaFFaNS9H?=
 =?utf-8?B?Qm9BclcrTjgwRXQ2Y3lRSmEwMEptc05IVmdDMlZCNWovblIxWTZCdUt4alRW?=
 =?utf-8?B?aDZkZkZvLzA3cjUxRjFKeGFKMXh3SDhqMElLTWZ2R1FCazdkdXEyMktndldG?=
 =?utf-8?B?VjVmYkt1MHdFcmhYNzhDOXZ3RS83VnBSdGcrVGhWV2d0L2tjcCt2dVVRNXU4?=
 =?utf-8?B?d2xXcUJEaHh3aUdsRHlrMDRyNjV2M1Z4Yy9ObkxVYjc1eUhkUU1ZRXBpdVpR?=
 =?utf-8?B?UmZIN2N6OVJ1R2pwTUJ4Y2IxaWlsbExSNW9UYUdISlB6YmlIckQxUnRJYUJu?=
 =?utf-8?B?TnZRUTUrci9DTnJBa2pWR2Z6b0k3ejlvYS9kOStETGp2OEE4VFkwRnJHdGRI?=
 =?utf-8?B?UmdJUm82N3o2YWVhZHpaSVAvRDRPeFBIa0NHYThOZFFnRHVjRG1LYlplNVhC?=
 =?utf-8?B?QUkydE9YMTJhTlBRMERBKzJtRTFVVXR0b0NtdXN3bnZDZUFsMFlSaVBPRFhG?=
 =?utf-8?B?RnIrK1FKd1lzVWQxNWNocHcybVVTbWZRUyt2b0kzbVNrL3l3Mks0cmxSb241?=
 =?utf-8?B?ZDRXejZySzFvWHlaaFJybGY3MjFSU25wMFFYRWwzT21CWlpuM0I3SW1HRGls?=
 =?utf-8?B?TERTeFBiYjYvQXVrT0FIaHZnNC9oTi9pa1NxWko4NTUzMW9BREs0THFPMjZX?=
 =?utf-8?B?K1BicFdTOFhhbXNFY3pDU3BSU28wZy95Y0I0UTFJQ1NWMUZ6K0hpRG1wNFlW?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e76f36c8-a32a-45be-315f-08dc6086d021
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 15:38:51.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvC7IckhPhOM0xckpNVa1Q5jWo8iwSNSsd8k/2llxxKnFvJ2xjgcuvaKfR520UwvYnqniRvollC6Y/EP+bmCvxZLQs98PEAQ9lAIQHT2520=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4975
X-OriginatorOrg: intel.com



On 4/19/2024 2:03 AM, Jiri Slaby wrote:
> On 19. 04. 24, 10:44, Jiri Slaby wrote:
>> On 08. 04. 24, 14:56, Greg Kroah-Hartman wrote:
>>> 6.8-stable review patch.  If anyone has any objections, please let me 
>>> know.
>>>
>>> ------------------
>>>
>>> From: Vitaly Lifshits <vitaly.lifshits@intel.com>
>>>
>>> commit 6dbdd4de0362c37e54e8b049781402e5a409e7d0 upstream.
>>>
>>> On some Meteor Lake systems accessing the PHY via the MDIO interface may
>>> result in an MDI error. This issue happens sporadically and in most 
>>> cases
>>> a second access to the PHY via the MDIO interface results in success.
>>>
>>> As a workaround, introduce a retry counter which is set to 3 on Meteor
>>> Lake systems. The driver will only return an error if 3 consecutive PHY
>>> access attempts fail. The retry mechanism is disabled in specific flows,
>>> where MDI errors are expected.
>> ...
>>> --- a/drivers/net/ethernet/intel/e1000e/phy.c
>>> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
>>> @@ -107,6 +107,16 @@ s32 e1000e_phy_reset_dsp(struct e1000_hw
>>>       return e1e_wphy(hw, M88E1000_PHY_GEN_CONTROL, 0);
>>>   }
>>> +void e1000e_disable_phy_retry(struct e1000_hw *hw)
>>> +{
>>> +    hw->phy.retry_enabled = false;
>>> +}
>>> +
>>> +void e1000e_enable_phy_retry(struct e1000_hw *hw)
>>> +{
>>> +    hw->phy.retry_enabled = true;
>>> +}
>>> +
>>>   /**
>>>    *  e1000e_read_phy_reg_mdic - Read MDI control register
>>>    *  @hw: pointer to the HW structure
>>> @@ -118,55 +128,73 @@ s32 e1000e_phy_reset_dsp(struct e1000_hw
>>>    **/
>>>   s32 e1000e_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 
>>> *data)
>>>   {
>>> +    u32 i, mdic = 0, retry_counter, retry_max;
>>>       struct e1000_phy_info *phy = &hw->phy;
>>> -    u32 i, mdic = 0;
>>> +    bool success;
>>>       if (offset > MAX_PHY_REG_ADDRESS) {
>>>           e_dbg("PHY Address %d is out of range\n", offset);
>>>           return -E1000_ERR_PARAM;
>>>       }
>>> +    retry_max = phy->retry_enabled ? phy->retry_count : 0;
>>> +
>>>       /* Set up Op-code, Phy Address, and register offset in the MDI
>>>        * Control register.  The MAC will take care of interfacing 
>>> with the
>>>        * PHY to retrieve the desired data.
>>>        */
>>> -    mdic = ((offset << E1000_MDIC_REG_SHIFT) |
>>> -        (phy->addr << E1000_MDIC_PHY_SHIFT) |
>>> -        (E1000_MDIC_OP_READ));
>>> -
>>> -    ew32(MDIC, mdic);
>>> -
>>> -    /* Poll the ready bit to see if the MDI read completed
>>> -     * Increasing the time out as testing showed failures with
>>> -     * the lower time out
>>> -     */
>>> -    for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
>>> -        udelay(50);
>>> -        mdic = er32(MDIC);
>>> -        if (mdic & E1000_MDIC_READY)
>>> -            break;
>>> -    }
>>> -    if (!(mdic & E1000_MDIC_READY)) {
>>> -        e_dbg("MDI Read PHY Reg Address %d did not complete\n", 
>>> offset);
>>> -        return -E1000_ERR_PHY;
>>> -    }
>>> -    if (mdic & E1000_MDIC_ERROR) {
>>> -        e_dbg("MDI Read PHY Reg Address %d Error\n", offset);
>>> -        return -E1000_ERR_PHY;
>>> -    }
>>> -    if (FIELD_GET(E1000_MDIC_REG_MASK, mdic) != offset) {
>>> -        e_dbg("MDI Read offset error - requested %d, returned %d\n",
>>> -              offset, FIELD_GET(E1000_MDIC_REG_MASK, mdic));
>>> -        return -E1000_ERR_PHY;
>>> +    for (retry_counter = 0; retry_counter <= retry_max; 
>>> retry_counter++) {
>>> +        success = true;
>>> +
>>> +        mdic = ((offset << E1000_MDIC_REG_SHIFT) |
>>> +            (phy->addr << E1000_MDIC_PHY_SHIFT) |
>>> +            (E1000_MDIC_OP_READ));
>>> +
>>> +        ew32(MDIC, mdic);
>>> +
>>> +        /* Poll the ready bit to see if the MDI read completed
>>> +         * Increasing the time out as testing showed failures with
>>> +         * the lower time out
>>> +         */
>>> +        for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
>>> +            usleep_range(50, 60);
>>
>> This crashes the kernel as a spinlock is held upper in the call stack 
>> in e1000_watchdog_task():
>>    spin_lock(&adapter->stats64_lock);
>>    e1000e_update_stats(adapter);
>>    -> e1000e_update_phy_stats()
>>       -> e1000e_read_phy_reg_mdic()
>>          -> usleep_range() ----> Boom.
>>
>> It was reported to our bugzilla:
>> https://bugzilla.suse.com/show_bug.cgi?id=1223109
>>
>> I believe, the mainline has the same bug.
>>
>> Any ideas?
> 
> Obviously change the usleeps back to udelays? Or maybe only when
> retry_enabled is set?

Hi Jiri,

Should be the former. Could you give this patch a try?
https://lore.kernel.org/intel-wired-lan/20240417190320.3159360-1-vitaly.lifshits@intel.com/T/#u

Thanks,
Tony
