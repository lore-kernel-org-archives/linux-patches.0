Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01BF137905
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 22:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718404270; cv=fail; b=UJAcKK2LlDsrv40+zgRIM7vUTsg2Tz96qfBHHJ1k4OpqhirVNy81CxweG+zHFtizyu3SYcT1qhsLoCgt/kPpKafwgbFi8652lBhrCYs2SbCm1dN/WCBFQwShRQLCYm0XVLJBRWpDgn/KqtBTfLhsaqSRxl6T9Xubua0AT8wTWyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718404270; c=relaxed/simple;
	bh=LnZvlmCaotP14aIdNKabgyu3t2pATu/kNb2wfzU/nDM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TPfutwY0Zgy2sq1B4RRJp4Xda3D2FPbctVEBvlGjcDopuBDf9bsKIqpX6P9xDQB38qqr5V3nfeUJYVW4iFuBqJDwUe+oa8fCyHStyXzXOJP+j4CTL8EvSXR+e3edjYPK371ruruGQbpRCc7IE3ZD7iDZ5EMRlemOULJZNmGNS9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q+dJreoC; arc=fail smtp.client-ip=40.107.100.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q+dJreoC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=innJtOtSvnjTKPDe2AcsyrbYujK3skcyykwe6A3CaYCXNIdU7GTZFqFqWRc9HUnuQfs7wsn0KTnPrZcQ9Jlhxh5C3zVoxXcaoOHcSvbU+UmccuCLV+5mkgD7yVofWyfWBWS5Ztaq9u3Xgm82CiuLMjWYM8+V6NFe/bhbaT4dBXgrgc+5+DHFvX15z+UzMctB1n6O3uiImDeT9fDLx3g+Dzk5C3tkEehXHrwq6T9hcALAGxOGWrsLo/kPvq2ZlM2woe1pjnoXCJULjESSFVf/xLF5kfXeFXO1YqF2dU0CzHclksZO/8q7Q69ZryiJWsYayg4o/UCztt54WFDYclGxdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CytFBpYyT2Yyd0Isrh0iEWhqUbF8R90v+UUopIW5CeQ=;
 b=OsnBsV2fOGoP5EMXeOKra9bfY8A79HWMhkDUa8JBD56RmUjftLgRKhJfF6t8yg8Y8ujgdKFMkW5r2exptVzFByfpwdhOpOOLhNh01pqk4N1Y9e9gly5zW40eaWqRlL+sUt5zJg5AwPPqUk0u0Uez0pprROkDYlNR1jYuatkTfL0Pt/3NNpgwjmC2cK1bGQiUQhbJqKmRSgKq/TkXUVgV4MlLaYx9LJ5O7eiukI5SS1AoSNfOeS/aE6HCU+2TTKTqDDdEGvUKFUf8TMOCmhG0LcZ8F07r33lQPNu9pQRZu3CkPGFhuin2ZZRWR+svKSac7XKAoqJqWeJ9hGSpryQtFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CytFBpYyT2Yyd0Isrh0iEWhqUbF8R90v+UUopIW5CeQ=;
 b=Q+dJreoC1dS2V2+lPz+gjgwNjqa9suDmrpW0/LjC3WiWG4Gcf/9iSzuzAceLUIQdkBMq+Vorgcmu/EyoFcImeZj3FyuGywTpoH9tAd/pX3CkJY06ayLPeOMvw8A6CZZcVBqDWxC+uz0L6jMO6DGBwg/T99CiyQ4dLZLhKQppRsg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH7PR12MB7872.namprd12.prod.outlook.com (2603:10b6:510:27c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Fri, 14 Jun
 2024 22:31:03 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7633.037; Fri, 14 Jun 2024
 22:31:03 +0000
Message-ID: <00bc5d85-e5ae-9ddd-7c2f-699785e40289@amd.com>
Date: Fri, 14 Jun 2024 17:31:00 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
Content-Language: en-US
To: "Luck, Tony" <tony.luck@intel.com>,
 "babu.moger@amd.com" <babu.moger@amd.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Yu, Fenghua" <fenghua.yu@intel.com>,
 "Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
 <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
 <e17d3a79-9c07-44cd-b0ea-2d0545680342@amd.com>
 <f57e9cf2-35b6-401d-afc2-8d11b22836c2@intel.com>
 <a65739a4-1c0e-ab36-611d-e2da0bd1d00a@amd.com>
 <SJ1PR11MB6083C6F02ADFC43B5316F71EFCC22@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <SJ1PR11MB6083C6F02ADFC43B5316F71EFCC22@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0202.namprd04.prod.outlook.com
 (2603:10b6:806:126::27) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH7PR12MB7872:EE_
X-MS-Office365-Filtering-Correlation-Id: a18578eb-9af6-4377-ec75-08dc8cc1acc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|366013|7416011|376011|921017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3paTTg2M2pHZEJKU2RQWW5ZeDZ0MFJqQ2hWVThUVUJMbzhIT0xwbjcrRW9X?=
 =?utf-8?B?V2o2eXlWNU5SM2ZqYTV6djdQZDZGZjQ1OTlQNEpCYk5WYkdnbmNTZ0pENnVD?=
 =?utf-8?B?YVNhVTd5OVBlRkY4Sm5YdmxjTmg1SmlMVzJuakgvMXpQbU4xWjd0b0YxcE5a?=
 =?utf-8?B?SU91SDlOQ2Rvazg4ZzdSYi91ZzJmd1g4dHlkQXMvbjNsQmx6ZTRnVlZVK2h5?=
 =?utf-8?B?RXI1QWcyNzR2bkZpTktGNlZFMGl5bVFSZnJSaTBMSTFJUzNDazBEdHF1dE1n?=
 =?utf-8?B?cGdKakNBd2VRVjdlQ292QVRsR00yRHJNVmRiTkVuR0YvVzROQWlwYUkzR3I5?=
 =?utf-8?B?NmhFcFBVaTl1UkNTNDB0NGcvcnJRTUdtcHhwKytXZnVRSHQ2QUM4TkZNRHJz?=
 =?utf-8?B?ZHU0YVo3NzdOdWw2VWRyUGtBMjVxSVNKb29leUZDN2p2KzhiekQ3ZUJ2RmRI?=
 =?utf-8?B?M25oR2pvdzROQzg3azRNM2NwSXl1SjlRYlBremtpQmhueXVnekdDRHBiTlVR?=
 =?utf-8?B?Y0N5ck04TmdvMFF4ckYwTlhIZEZ1dEx1d2tRVFlNT09hanNHeDJMYWwyenRE?=
 =?utf-8?B?ZkNuRWVoMWxhQVZ5eldPcGEvQWNOTCtnWnpadEpVVDZwdDJJemZuaGJaWUdX?=
 =?utf-8?B?bWRyeXlEaE8xWnB2cXozVy9uYkxtNzIyV1hCOVdQZHdmbUFuODlsRzV3VW40?=
 =?utf-8?B?UG5yOHRVZFhIVEF1ZUtzRHlCcXEzbXNFZm5SMGRPdStBU1RRaHRrOEx5b2lo?=
 =?utf-8?B?NWFQYTF6TTJ6b1k0OGpsWFQyRm5yL0JxT01uZmtwUk5TN015NXRHcGVkUDhB?=
 =?utf-8?B?d0dhR1IvZWNpdlNoTk12bDB4Nk5FV3JrL2crQlg1VjRZM0E4c21lNVpwU00x?=
 =?utf-8?B?d3lzYlJSdUhPVTBKY1ZUZEkxZmN3UkJWZnVKYitObFBQdytYd0lZTEhnQ05Q?=
 =?utf-8?B?aGRoQWhIb003b1V6cEE2TWdXTFdRbWRxa1l5Tk8rdVJoYlRpMDgzT2RMK25a?=
 =?utf-8?B?RWF0VlhnTFc3OUVDVjBiRlduVFNHdmNTNGpJUnRoelRReG1Sbm9pV1F1TXZS?=
 =?utf-8?B?bGpkbkNwRVlCdVlYaGZ6cEtEaWFOZ2Y1anpFdXNsZTZFOURtR1YyRTV1WjdD?=
 =?utf-8?B?OFFkclNFNlIwTEUwRUZMS0pWdk5JU216YVM2enB4RDJHMGxBMDdRcDcvSXh6?=
 =?utf-8?B?cWhXclNTUDVBQ0hlR2VLeER1aElVTzNaTnF6Z2h5QWhBUkVIb2NuZHh1ZDVD?=
 =?utf-8?B?eFlwTGVPcWRZTVVtbTVyQ2dpemRoZjZPZUpmdllkQitxZGdqNTIrMTJCajdh?=
 =?utf-8?B?WVFzNmxLc3NCa1BUSGlIR1Z0T1pxNERtNmIxcXp3ODRrMUtSTC9uejh1WXhC?=
 =?utf-8?B?eGZPT2JRT0s2Zm50Q2xmZFRrbEFUMkdvUGJUcjBTZ1RBdGR2NkdBdzFwblBn?=
 =?utf-8?B?aGFkK0RZa2ZkcjRIQUNKSjNpY3dwZnl1c250ZXIybnFyQk5kTVZHMHNtOS9i?=
 =?utf-8?B?TFZIaXRzODNxQjJYUkluWWFVRVJkejRMWGVWenpjNGxSaUpBSEg2K1c2QVB3?=
 =?utf-8?B?VUY2c1BPUnltMDV1UDE5WXZ2S1FZMHp2NVYwMExpQjlQZ0g2blBra0Q0Ykxo?=
 =?utf-8?B?aFl2aXVSYTVSVmpPcVNsWTFQcXJaeFlCQkgwNUsvZTQ5UWpzSkozQzNrOGph?=
 =?utf-8?B?MkdTYWNWRVV1bkpTRnFTZitaajRpU3J2Rm9jRzRUWlA5NHF1aHNObnNZMS9a?=
 =?utf-8?B?S2JzYlA0K1FKNExSd0NPL3NtUXA3MHVYMyt3andXaWFiaW5ENFZlb0lHcWZY?=
 =?utf-8?Q?hdwt7+pQ1snV3zXURpjkJqdgpBO1emGY5HOT8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(7416011)(376011)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2pFUHpxRlRDa2NBYXZ3RER4UEN3KzR1V0FyeHhLZTlwU3VFSFNZR2VkNzBy?=
 =?utf-8?B?eHlvR0pHUG5uNDBSVVhVdFB5RjBya0JyUkRRUEhibDF1UEQvSzVoV084MVVY?=
 =?utf-8?B?Y1ZKaURjWEROVzJYeG9TMXlJRndrakJIRmFoa3QxTnd4Zk83ZHNaOU1CUWdz?=
 =?utf-8?B?bWlTbHhoWjBmQWZ3K3ZUR0tnSjl6QmxwTStYb0tsTU1mRkRrcnFvMkdQbVJi?=
 =?utf-8?B?dTIyRDVUZk1JNmNGNWZGbHh1T3VJRUxTQUtvM1pqdUZ3cVhEUzVHaUVUNmJr?=
 =?utf-8?B?WUZlTVl2VzFvaEUvN3ZmWFlNdG8xQm5QOE5vYkw3NkhzYjEvS0s2ajI2UlBS?=
 =?utf-8?B?MlJyVjFUZUErMlBwV1lGVlhQbnhSdCs1YngyVXVwUnd5eU10Qkp2bjVaMEth?=
 =?utf-8?B?T3lrOExaWk0yMnJ2UFpiWjVZR2txdDM0SDZNdXFyMTIyREF3aFRTRUsvOHdJ?=
 =?utf-8?B?S1d5eUxmdVRubWFlU1pNVmNmeVRjeWM3MWdxR1ZMaEhQNUpzeXRWODhaWWtw?=
 =?utf-8?B?RXVlTnZkVzlMVGozTnQ4NzJJcmRNM3phRWR0VEVxN0hGRGFxM3NCYlJFY21F?=
 =?utf-8?B?U3dzbDlGNEsrZlB2UmpVREZ2UEEyeGNpVW5TTnFMVnZkMlBkTDJ4Tnlrblcx?=
 =?utf-8?B?aEJQK0U5Z3Z5dzczM0J5ak9PRkZMMnExOFRZZnJ2bkpNeFpiMjM1RXNicVpF?=
 =?utf-8?B?Q2NpbUxucWpkS2JCekRUNTZ0d3V4U3U1dkRqcllLRS9QZ0t1N1hBN1RDdFN6?=
 =?utf-8?B?ZUhFOEMwVndieHE4TG1QNXlVRFdRNklRUXJqWEZuQ0FDM0pZZ1FOYS80SlVS?=
 =?utf-8?B?WGtobGJQZVNhMU1Va1I5OWRBd2pYMEtuL213L2ZMUGU2OVgrTlhCdkZUTEJR?=
 =?utf-8?B?ZXZmQ0pxU1p1ekhyanB1a0FrM3JNQXBLVFpWeG03WUVUQjZuQmFieEh4Ui9X?=
 =?utf-8?B?Q3JpNlFyYU5YT0hiTmN2aGVBbmFxVzE2Sm9EdUx1R1VOT2kvOVAwaWF4L3ZG?=
 =?utf-8?B?ODBiMnY2Z2dDdHdnK3ByQ2t2L09OeEdRbkZ3TFVZYVprd3FFUnRDL0xCL2do?=
 =?utf-8?B?OTFyaEFzM2t5cHhrV1Q1amd2aGFSUWl5YkpDNXJYbXBVWXZhQlBvTkhBc3FO?=
 =?utf-8?B?Tk1Fc2VYejdTYjg1VVp1R2VTcnZidXhpdno3L1Q4Tk9ndkJJSit1Uk01cE1M?=
 =?utf-8?B?RXJ1OWhML3FveUtFLzFIRTV1bnFudkloemhUckhRdVcyckpmdDJKakZxUXlG?=
 =?utf-8?B?b2hMNDg4VythOXBmQUNtRTNYalUxeThDZ0lPY0JDMXdJOCs5Z0VTQmd0d0ov?=
 =?utf-8?B?bU41SElJc0xHL1hPSWNEeGtPZkdCL24zQUJWYzErcHlKQ3hITnZBSHQ2alpX?=
 =?utf-8?B?WmpVYnU3cGt5MHl2djhjajhXbDdHTU9LUVFwTkp6ZjdLeVFFdlBkZVdZckRX?=
 =?utf-8?B?dG82UGtqZzNYVzcxb2h0OXVaUGlvZUZLV0ZMYlB3elZDSlpBam9YbXhqcUhr?=
 =?utf-8?B?OU1TQ09paEgvT2lLVmFlU3RIRkJsaUswZk1EVTkvenVYcmxGZ0txb0VEaHRL?=
 =?utf-8?B?RU9Cc0h1UkZBaDVvaitxKzVmaE55VWp3Syt2MmcydWdpWUJMNk1hZ29aUGpQ?=
 =?utf-8?B?VS9zRWJyUi8xL0VZVVNXaFZpREY4NWl6SkF3UlZuSStXRjF5UCtLeUdRSEdX?=
 =?utf-8?B?a3p1Z2l4cXllb0tLYUtSbkt0UktmeXhtbmNCMU11SEFaMGRTRlN6NitJNnVY?=
 =?utf-8?B?REhHY0FueXl3VjNQS2dyY2plaC9YejRyOFZOdGJRTEhMMThGN0RoZUNvb0pa?=
 =?utf-8?B?c1FtNFd5WWdKVzdzNWN2TzNGczEyZkwwR3VsbnRGVmJYaHpFVFRoTjByZTNi?=
 =?utf-8?B?YmE1cW1nVE11dWllWURiUFZTdWRtYXZCc3cvVWlzNFRESEYyR0lsNFZjMCtJ?=
 =?utf-8?B?c3Z1Z25UNzJEVWZQOGczeWpBQUN4UlRVcHNCRFRRS2l6aFlDcmh6TzJDQ3FH?=
 =?utf-8?B?QTlZS0FCQjZpWm4wSTk4S2pUcklJMUFvYndlRFpWeFBhNmJDd2tUMWlralQ1?=
 =?utf-8?B?U2VKVjBqZjdhWmVDeDhBalI3Q2ZSVDFCU3M0eEdiQW10VVVJMWdtVHB1aE16?=
 =?utf-8?Q?6HT3UH5VSuPmuzelX0xs0iqZM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a18578eb-9af6-4377-ec75-08dc8cc1acc4
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 22:31:03.6421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnpdVoDZvBUmeHsi5woMvsvlKBsHcdh6OFxVWR0yeIh4o/Jy/Za3SdqjPwuK9Hon
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7872



On 6/14/2024 4:40 PM, Luck, Tony wrote:
>> We have ctrl_scope, mon_scope, ctrl_domains. mon_domains.  Only one
>> resource, RDT_RESOURCE_L3 is going to use these fields. Rest of the
>> resources don't need these fields. But these fields are part of all the
>> resources.
>>
>> I am not too worried about the size of the patch.  But, I don't foresee
>> these fields will be used anytime soon in these resources(MBA. L3.
>> SMBA). Why add it now? In future we may have to cleanup all these anyways.
> 
> Babu,
> 
> I mentioned yesterday that future patches could split struct rdt_resource. I was noodling
> at doing so back in February. Patches (messy, not finished or fit for consumption) are
> here (just to give you an idea where things might build from here):
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt_split_resource

I see, it is similar to splitting the resource (option a. v15-RFC) and 
little more. I think we should move to that direction eventually.
-- 
Babu Moger
