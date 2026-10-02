Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5DC2248AF
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 21:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790976910; cv=fail; b=M2IysX5nEkJnXYatwepkkDhiLpAEhcetjZSXS2Cbb4LlB+WvVVlZX688FamCIzxNIb0bfrLfFthh+7BfjySuIAG0aL+DPmvCwbTHUMsJ3ReMdwO8Uh0wL9T2+7AcRoxWf7sGWOm1fRMLZ0IGpx7gdXiIcrMMa4Rhl9lTZ2fNKJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790976910; c=relaxed/simple;
	bh=3dOw99HkBzTCA+EpbvA4EtHy10sycTbH3T3miDNUkgo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nf4O4qn1QN71IBNy+n4Wqsmvypg34v8vMhVDMkCMGtrF621MTW+l5Kbq6i7PpV7cyFAdQPpW7U+FRtEGr6MxkybjIP2WGCQeCf7AAUD9HqjhmNbGwQSaDrqnxPM5hJkgoJI01MtztWWRy5wysG8N0FJzbgcVhkouxDiqwxxtxbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O8aHGixm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dAXzoqlg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O8aHGixm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dAXzoqlg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692EbguV730247;
	Fri, 2 Oct 2026 21:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xKYtgmKNQAVbpidCxDi6ly7Kel1r2kpGXZmb/RX2hbA=; b=
	O8aHGixmvuyMPm+icWIjlJffi5I3nHix8oKiu9MvSYPvMUss8SymI9bcKA+qthvD
	hx/VNSR51RSQX8MmCKH4FiF0fYlyGzcjPQVi2HBz2V7SLZa5IVGDjzaTZ5XMxXbV
	dxtQo0Hd5a5URekRER1vxsyPssFnOSXYuntqKSkbg5D8waCBugFjUAMbAmBZwNP5
	5TWQPWMYRCYgZ14Az/Y+DENATeCIReI3HTfV9i5+yZ3GL80+acDZr6IdDxRB8LzX
	pZWTRyfZj3iLe2Xd9q3VUmQU077E8h/wszkIM1kyZUbHfDRfvFmKZ7qoNN5pkmSj
	RAnTJjzBlJtq/vWl4U0QOA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx63c4s15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:35:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LZ1ZV040912;
	Fri, 2 Oct 2026 21:35:02 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h2f6fsfat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:35:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ak4yTU5BCzn6rkx0pM41Qdp9qdTmDwtOdTizoIYRpfg680hU8MM4RDA4UwBZYaGJuS3YUddl80z4FRvKXYA282IAiZ181CZnuYwbglFnr1ZXqQg1Eg350jsCy130M6DVgrHj/OZlSBwt182l/c1Gc8EbFaxjvWwOOTRYogSLIg+SbtqfZy05ll7KHm2G8jqpSVP8VGXU4Iqa0nK9Lzg6QH9unNYVOZ+gLQeDgQyd2Jflwi4hZsr+RALzfVUaQPkdUsDGVwRW4Flv/RX5FJa+WvT+GLWY8iwbyADfILIxq1kFYftqBB67SB7buoMxYzrAya8yjR67xRZm5MhwEhNjkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKYtgmKNQAVbpidCxDi6ly7Kel1r2kpGXZmb/RX2hbA=;
 b=Hqem5OfC2x+MrWerKeHdOC41u2mvztIt8QN0CdU37TBDIufPUV83x/eyAplAo1C82c4eyW3r4Q0bjNHAyKPw1GAmPkCLjxxLB4gTBO21bpoDU51O4le6wEBM24udaFJ5QVEcaOUWrdbUhCa0dreX9yugRI3/Rtm1imMRE6koSh6OJWxZGtQS1RkuxLHuyp5hHotqDGhnIZQcWvHHj/U7eF2NL+P63EpSzbAPUTVZIneXklpIFZE76w+WIyXAlqXO6L9GDLOBB+owjnf9ZSNMJvssaTEHHfOP5HTvInKOp4ZYdWNixKhM9u5DJSC1BGn0EnzeuJdIef9X4tDy5rTxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKYtgmKNQAVbpidCxDi6ly7Kel1r2kpGXZmb/RX2hbA=;
 b=dAXzoqlgejaGm9xBM3g6xH7Z9+SeXMzUp5PKjqpuqa3YqsAsZa35o8OV/gx7dz+PP07ArhLls1vmUwv3tk6MVrpkktEoiNioGJh2EJTyfOXKL9saqZK+uXAkh8xCKE+vR7nyogcLdDtkkgNL+YYlHcXpMJ6RscSQXaD8a+igra0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA3PR10MB7071.namprd10.prod.outlook.com (2603:10b6:806:319::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 21:34:21 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:34:20 +0000
Message-ID: <93db0eae-f479-4343-a126-59987ae0dc22@oracle.com>
Date: Sat, 3 Oct 2026 03:04:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 223/752] wifi: cfg80211: validate IEs in
 cfg80211_wext_siwgenie()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com,
        Deepanshu Kartikey <kartikey406@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152358.131179731@linuxfoundation.org>
 <20260930152403.080560860@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152403.080560860@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5PR01CA0012.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:261::17) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA3PR10MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 201e7af5-d957-46b9-f682-08df20cceb2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|5023799004|4143699003|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yy8xFf277s/JB38yU1JcKa7JyBgLWZkA6CCknZsxGmYOWhIj8NJ/ZuFOamM7zRRNtk0TtO+xt4CwGyAY03hLXzfAmzJI+PZvAWWCf23nnTtApvZezuZ9036Pr/IxvN0A7yeFqDfZXpn3s/nnEvUXZ2qJYNt1Vz6+9VYcMIVKiJzEUNpaGVg5A4LaBRzuRRMsmyGv4aSGyEeTX5GYcOxC6j2pxYi+ji9aUtZSK4N7qOcMuWe1tyY7IhG5bjUqIgmENyMFsQqkZA95411vKW6vQ+xQZZBiawNSHff6BRyutnfso1vEaR3rRsFP7Y3nIy3Q0hCi0vCn/XlgtiOcb32viJU9nNR7nfYCcxE5B1hs3Zk5/8YqAL4cZy0N3W0BpMyh39jTWzKpedXrbshPsge0AfFwLKflJ4Vcvq3j8ePmC7WcXzEIL4v9t1EMv2o9K0STz/RpkJKJEFMcl1dxu/5wW7L4HKyOT0Tj8A80lX1MxEfw230+J6telGCgG9Vfujvuf1G3KbTsurEeKMDsa01KbsKdWI0W6YCcU0PxGv/INKtkDnTY0+y2S1bQCTWMa3nIQAtdYBgOHsp832u+L34rx7z5K0McO0vLNadAPLxpTR0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(5023799004)(4143699003)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzNQQWRsYUV3eHo5TFh6dXJjZTBjRHoyTERsaDNNUER2dkNVVW9rWGxXMWx5?=
 =?utf-8?B?UUhlUGsyMGJRRmZsd3lXTTBYMzNXV0lXMEN3bXM2ZFVuaUdxZVZqTFhOb21I?=
 =?utf-8?B?UXllcXFmVnRlcDNuOC9NWkcwaGNqTVl0d3VJMXVLSUlmclo4L3RhNUszRXFm?=
 =?utf-8?B?RDRLMWZRL1FLemUwZUpRTG1RamhPeU96b01LMUJ4Mnc4K2pJWEMyYlBPTUVl?=
 =?utf-8?B?eTZ5UUwzbk1uMndJK0k0YVdqMHBSTWdWWUprUm5SYVp1SythR1FvS2FDUVBs?=
 =?utf-8?B?bEV5VWRjaGFudUhOMmlVaGNaM1lvSGFtd0huRnJZclZOUW1NWEgrSmZuSmZi?=
 =?utf-8?B?TndSQVQ1ckR4VTBGKzQ4azNhVDl5OVV0K0V1T0tseVdaSGdHZ0FBMVVLVllk?=
 =?utf-8?B?T0V4Nmo2amRLc0NZMGZwaFJTbmVBTDh6VjIxTHZhbk5WZlRPMmZwc3Z1Y0Za?=
 =?utf-8?B?M0FNTjhlajdPdFFZWGtKWEkzS3Izc3EyWC9VQ1haQklWTVhBcmovUGdqZWdr?=
 =?utf-8?B?Q2hDZFdvZDEySkdZTnR0M2h6bS9qR2JZL3llZUVaRlMyZlcvRVpOSTN6OGY2?=
 =?utf-8?B?MG5DVm5WWW5zOXg5YnphM0Z5QnNhdHBYLzBMNFhLbmRETm90emdGdHN4bGg3?=
 =?utf-8?B?RXdkZ0pLM2FlSWtSWGdaM2p6T1A4eXJGY3p6bkRrNHl1MW44dnNUOFRPY0V3?=
 =?utf-8?B?NVhhOHhYdnZKR0R3UW82dU9qKzM5OWI5T2taZHp6a1RpWThKWDdPRHVyTFRz?=
 =?utf-8?B?VHNxSEtBcm5hTU1zOFZEenh3bVYyeW91VVpnQzVVenJKUGZYcEU5QlNiNFo2?=
 =?utf-8?B?Sno4d0NZVDFONUF2ck13WEpCencwM1lkeEtENnlxZ01vNTV0QzNwMEhKM0dB?=
 =?utf-8?B?VUVWNXFHUEc4emc3YnY0NHF2dXBKQ2lucUVmaGJvUHd6LzhIenovUVpPYmFW?=
 =?utf-8?B?ZitRaGNOWi9pS3BGTmVzT0NDdWZMVmkrNFpOQ1ppdnZRMjJrUWw4Uml0Rkxr?=
 =?utf-8?B?NWtsaHVaWmkvT0ZXU0txbTVkektoa3ZCcDBhSVZIRTE5ZnEvL1pLMXMyNmI0?=
 =?utf-8?B?YkZqWTVpRlUxOXBBb21PT3V5UXpZRG9jUWQ0Y1hFZnZPL1FpeHVEc2svMmoz?=
 =?utf-8?B?NWtsNWVlMXRvcW81OVpKQUpZa0ZXTjViRGVZVkhiaXhNOUlDOUFjYnR0NE1r?=
 =?utf-8?B?R2F5cDdWRWcvdms4Y28vN0xPSFg1dVZlczg2VStRWVJjZVN2MjBPa25ncXRy?=
 =?utf-8?B?eS9wK2pBSHJwcWNEaVZtNkRQYm5CTGloVFA3Ri9VeWtqSUZDM2x5QVhIUlFu?=
 =?utf-8?B?VFJ1NVo3d1ZlKy8zbExIZnYvL3hNbHl1NmxsdHQ4c2NoS1RhclJoTmV2ckY5?=
 =?utf-8?B?YzJwRzRrUGtTcXZ1NzNrVEd6SGhkcmk1d3YyYUd4K2xLSFNxQzZOZTFpWHlT?=
 =?utf-8?B?NDRnb0JVOUxGZmZLNkErZ0lQdXAvM3JvTUtuR3ZzTmxPdkRtTGdMZGVmU2pq?=
 =?utf-8?B?ckZtaEV4ejZRQmhNaHZXSEl0eWpkZHVFOEprVGI0TnVRcVhpczRMOWlMc0VT?=
 =?utf-8?B?eEV5Z0FiRHN2QW5ZbURGWWFrZURJTTl0RzZJT1J0OTR5N0k1WTY5ZC9PQ3p4?=
 =?utf-8?B?dGozaTZMem00OEl3aVVOUm53VVI0K0tBMkNYYXFlLzlya2E0QURMSnpUekV4?=
 =?utf-8?B?aGtIRERKb2MrZDdQRENmMmlEY0FFN0xJdVFwenloaGMzd3lORUVaY3F2R3p5?=
 =?utf-8?B?dEhzTDQrVWhFSWgxZHlneUpLQlZKMnRWN0YyaTdyem43d1lXTHJKRGROTllH?=
 =?utf-8?B?Y2x4RkFzand5SWdEdWNldlFPblk5VHNUZUpqYTlBWHl6WHNNbXFvNXZPUVRM?=
 =?utf-8?B?TTkxenZrU25CR1BUc240ZTh3TSt4ODYyQVFTbWhxU2lRTmpha1BvNDFXMU83?=
 =?utf-8?B?TjdCaTNHY2hqUGlzU1JyM1NPbUo1eC9mMEw4ZmFIbGlTV3k0RzlGODZ5WG1z?=
 =?utf-8?B?QmdHZjVRRjRhUTdmMTN5alBDUmY2OTNpcjdYNGxQd0tUcm1STTZvTUE1ZjNB?=
 =?utf-8?B?Ujd0Nk9BellWQzg3UFJ6bjE3UHQyQ3loQ1BVUlFHaDdiY25rSk1oU3NFaFJw?=
 =?utf-8?B?Zy9XREtMZVpDbzBVNzNVWGxrN3p1eVpwTlgzMkhVMVcySEIrY3ErWW8rSE1T?=
 =?utf-8?B?Rm5kcnRmcHpjcHVtMFBHaXBDU0QyQjJHdFAvZEU4N1BpZlhjMHQ4ZE83UFpo?=
 =?utf-8?B?YmZyQ0VVKzk2dXBRQUVYeEpBaHdhdTRuZEhSZzVGZEtQSjFENEYyaWszR2pZ?=
 =?utf-8?B?a1FSa0w5SVRyNnZWQUFrZllyLzZGNUV5SXovd1ZPMFcxd2crMHlObGpONXhZ?=
 =?utf-8?Q?x5TiXG80CCnYjiS25scS6H/uC4v/ONMGeCnJy?=
X-Exchange-RoutingPolicyChecked:
	hq4lNO/2JL6dntNuFqamJ3cSHBhzex203f55KTpMYWf+/vnbtMjDfDwVteJLRIoIifl1RyssGAxYM7b02fQ6Y29n1Zyz5bL20QSrRdT+h/MOJG/2VhtaIWTtJgTTlqMrCTHcAYitjoLnuTprOeCYxR/iAlhp1iZcEnrXkrxrZlp1tVEm8e5/RrMKzxT2dZM1pKajwHJCVr8xfRVjMgYNhkKqju1jyGrvEI1g2TbJzm1AEscLiYae/Wgt6WO2jn0iJ/LzpJ5TXlqigwVbUFWp4Jsj1SCnaBhk5UyEUmsLTZcG8KSTRME0dlPZ8Ng1oSQ7ElQMG1BpWyABeep651XtRg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IwRQljDHpwGGAMEUGswYtxqapy7Z9v4+AOwBhBMzxQBLOzst9LUGc6kmQXNs0baM5ysTdi2AaYxeDo5QjBz5P7pGYYdKMuvFs58HmkBiow/ghsH7SogJX4e2/pAwxSr/6eSdVny3SkHZgjV78UNMlOwe9atjrAJ7+iFZasj2wu5DHZK1Ixp0z+cPYMiYAIZK2tDLhSAQsF3/fO9aGpH+an06NcdlOL1LMw7JwG4tI/EXT48jbpIGspqajecoI/C2P2oAILmJCBwPrMjF5Ca3wuten3VHM3ZzG+Xnzsr8GdXVPbF/mOZpvnf0etNzBX7Ss0kIuIMj2KSVf3gaGpVrTu1JZ7STiDy+9bvRGWg4ZVbqrUe1epLkNxu2YxcA2cW9K6itrMtBN1oJaj7ZvaOHa4yIfWGlBPtdSzSkftAwTi8MDH/aUIfVZzKzna/Cd2cbr/ZzLE5bm2xeP7NQWgCyTLpO9sG+3wZEKqPI8o4ludF41/3jgeQ8FReHSJ3/ugDXeJbgvSEW9KQLkORE/q86+XxJHaOb4ljgwAoG1rufWmlBNd9rtiwPT1vwiBzQRqBABpXGYazk3jceBTxgikWgOs9ewt6cpa1WA38fMSmaSMc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201e7af5-d957-46b9-f682-08df20cceb2f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:34:20.3342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XI2hiPF//8Fp9yOhqRK/a7MgL7eB4mGTTSDoXEUAZn3Zft5KAP7PoRDBHl3vBsaGHwmUyP/xP5T5Uwkb0np1ienP9AnWjFyruxgkKvopzPWrwZUSHGNpB+tRp0Nm9aIK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7071
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020086
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfX4pBmN0OujwGL
 hySSbi3W08kZAIng9qZ4aRflBpSJQuU+5ey0vf7y8elJukvEOrdadExddL1wgqwFGNpNL0ZdlaJ
 2Lc9i5PWDmUgVBTByu392ECCVsqnQxpGKpzeyUKhNVTQWjn3dNuo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfX17XSwitFUbTv
 hOKBSnaqJiLoPCQnVmcrDKlsYGq9eDisqW4daB6bCgWubIBpnAhybjuCRtKOeNTqeY71B1qHuFq
 lSU9mHczoKqFTgP62D30iRJay/HA4Kfv2CVjkf4a8DzHYopkvBc5aY/Bz+jG3PixdEOCxac3Mc/
 XGqwESSW/UBNOmAMjwmE5O6qGAVo9UwxLPMkD/YJA4fQiHzUox8me7qkzcA5H95XQA5nmCFQOAC
 RezfOGk4rudaBpNDTBXzpTwiPrHa1zHw/4OwS2BgEdgIzL1suJxHkyPNBLlqOXUxEdZxUJqhmZp
 K17GntzkuiLHO8zFL/q2VwQKhJJqzFQ2eJZGYgjjKPIQe/Q7wDkgJD5vOeMYJ/4U5b9vzhzJA3Y
 /tRzk6A4qV5iaOnWtMmYR/OhM86CTrWMGh7WWORzs6OY957t/C0+ZC0Heab9XuaTIqiaIBm+xa6
 DMCVMfk/LJRL7EYwUqg==
X-Proofpoint-ORIG-GUID: Kxa-BUnNyKeXsmD4vmbOl5Ls5-xZwULm
X-Proofpoint-GUID: Kxa-BUnNyKeXsmD4vmbOl5Ls5-xZwULm
X-Authority-Analysis: v=2.4 cv=PPGaavqC c=1 sm=1 tr=0 ts=6ac02387 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=edf1wS77AAAA:8
 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=hSkVLCK3AAAA:8 a=QyXUC8HyAAAA:8
 a=VwQbUJbxAAAA:8 a=k1x6HkE61L8NR3qAFJwA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=FO4_E8m0qiDe52t0p3_H:22
 a=cQPPKAXgyycSBL8etih5:22

Hi Greg/Sasha,

On 30/09/26 8:51 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Deepanshu Kartikey <kartikey406@gmail.com>
> 
> [ Upstream commit a2f5286ca4f304d3fd469f01b96b518608912a5c ]
> 
> The KASAN allocation trace shows that a malformed IE buffer is
> stored via SIOCSIWGENIE (cfg80211_wext_siwgenie()) without any
> validation. The crash trace shows that a subsequent SIOCSIWESSID
> triggers a connection attempt which calls cfg80211_sme_get_conn_ies()
> to process the stored IE buffer, causing:
> 
>   - An out-of-bounds read in skip_ie() which reads ies[pos+1]
>     (the length byte) past the end of the 1-byte buffer.
> 
>   - An integer underflow in the memcpy size argument when offs
>     returned by ieee80211_ie_split() exceeds ies_len, causing
>     unsigned subtraction to wrap to SIZE_MAX and triggering a
>     fortify panic.
> 
> Fix this by validating the IE buffer in cfg80211_wext_siwgenie()
> before storing it.
> 
> Reported-by: syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=cc867e537e4bd36f69bb
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> Link: https://patch.msgid.link/20260725142028.32560-1-kartikey406@gmail.com
> [drop unnecessary ie_len check, update commit message]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/wireless/wext-sme.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
> index 193a18a531423..1919290d1208d 100644
> --- a/net/wireless/wext-sme.c
> +++ b/net/wireless/wext-sme.c
> @@ -333,6 +333,15 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
>   		goto out;
>   
>   	if (ie_len) {
> +		const struct element *elem;
> +
> +		for_each_element(elem, extra, ie_len) {
> +			/* nothing */
> +		}
> +
> +		if (!for_each_element_completed(elem, extra, ie_len))
> +			return -EINVAL;

^^



An AI assisted review flagged a lock-cleanup issue in the WEXT IE
validation backport. I checked 09c42d99d893 against upstream and 5.15.y
at d7aa8488b4a2. The validation is present, but the new return needs an
adaptation to the destination's explicit locking.

Upstream a2f5286ca4f uses a scoped guard before validation and can
safely return directly (net/wireless/wext-sme.c:314 and 328; intervening
code omitted):

     guard(wiphy)(wdev->wiphy);

     if (!for_each_element_completed(elem, extra, ie_len))
         return -EINVAL;

5.15.y takes wdev_lock() and copies that direct return (the same
file:327 and 342; intervening code omitted):

     wdev_lock(wdev);

     if (!for_each_element_completed(elem, extra, ie_len))
         return -EINVAL;

Malformed IE data now returns -EINVAL while still holding wdev->mtx,
blocking later operations that need that mutex. The upstream scoped
guard releases it automatically; 5.15.y's explicit lock requires its
existing out cleanup.

I would suggest keeping the validation and replacing the direct return
with err = -EINVAL; goto out; so rejection reaches wdev_unlock().

thanks,
Harshit

> +
>   		ie = kmemdup(extra, ie_len, GFP_KERNEL);
>   		if (!ie) {
>   			err = -ENOMEM;

