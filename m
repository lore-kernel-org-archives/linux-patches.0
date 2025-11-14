Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891DB2DAFCC
	for <patches@lists.linux.dev>; Fri, 14 Nov 2025 18:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763145558; cv=fail; b=mo9lwo5s1GIbuLf7AngCXC44sCOhnlnOlCrsGTq0xUQDs8EHHTQXlJgL1csooLil38IgeuTianVyJYBwIHo6qLAJ97hyA/dcYBbjFLJe6t+VNKlDNHy+SxPh27xlODu4MneCv9Dnta4wfEQOgQY5kf4AYUZPfum6lujcSIsKl8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763145558; c=relaxed/simple;
	bh=g3QcDYm0i5Ge9nfSgSlVhVj+7EOs2TUfoGsNnLcTRnM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s0mQRd35iaURHT4rYIO6aU5GeaSM+/nm7Vv06+zKSoVpwZGUk+t2+upJehY+sQtQHt4X9GXI8AynQnHLe8YW8ma3fAJ/7N9l03VZYE8Zak+Dvq93zQYv5SLOvgJ7zf+fJPKcC0V1nkrZJsKihAf5eFMpIUmpgw7XwjbDrfbIX2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QYtusNFx; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QYtusNFx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763145556; x=1794681556;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=g3QcDYm0i5Ge9nfSgSlVhVj+7EOs2TUfoGsNnLcTRnM=;
  b=QYtusNFx6oaNLQUu3GvzJl1sWmu/F2RlMqg4z7ioNR0l6p1+bcRGYi2T
   HpfYo6hEwA5iWO8Zct+tD9a5/68Mz029uREEp4agNZcziD0R+SEgyID+M
   KCHoqsicq6EdMtyQiGTOZsyf9iBjaVXkx2ADGgtI2GyRkzDeQdTdKeeO7
   Yn43nfr+Njl74J3PeBuGL+YW35mdi5/dljMSmXb/ejnWLrPCXB7F0XseG
   kw5xh9YTHZxXzHq76NiydedQX0JTnmiC1fOAXrH/Mv9rg54yCFx2HzeAq
   N6h+l+eaqazDYh52HWpkjEv7aauUm8cdbVd6pI3W67YZEU6OdY5vDxnaN
   w==;
X-CSE-ConnectionGUID: tN28u6oDT0Wldjf31VFX3A==
X-CSE-MsgGUID: NNYs1KI2QTSuQfsE+REfKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="82638215"
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="82638215"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 10:39:16 -0800
X-CSE-ConnectionGUID: LPBBEKCuRPGdKYlNYNA9QA==
X-CSE-MsgGUID: 9Olrf6o5RpyUP2degeWVdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="194834820"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 10:39:16 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 10:39:15 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 10:39:15 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.44) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 10:39:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d+WvVN80OpBJtGQIVsrgPSNuTpbDHuzwjHD5vXHLCg+TG9pd5GaFkcmLQJ4whkMAT4DtZEIREUFxZ3SG8unAN1wy+5hF784CU9T7sue32MpfzVVShy4iJu0zLsrijuN15U8xZlM/pH7oaZrD6gBJNP9p3CheUFkxldjbzApKRkldwQxGzgMBpbtfUpE7pqTNL/0GEELGuYx670+kTGNi8GrfvRzplDeQTDnStBGpAuqSy4NTSnKyjZ8020tDzcRtugmognS1khdK+5ThcZHkIEnjITQeNxZ5DavJ08bDBJO+aExgUl5VhffK85bdMA2GnQeBZWd558tZVSO2p31QsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wceoQaS6YbhIYMoc/YDhq3u1LJOAh35em3Iiay1cb8c=;
 b=uyVs61krlC2WlGXrDvcZHk/L+Gkun0eLot3LTViu3XwlfTjFsdxNHl3HGdsJBvHamDZzP3OTI0dFcaDXUnaLyaJwKvJcnkYZYYyqBUHmyX2CBC+iVwzx6aQi8/3i8adzScfP2J3XNApFcmhvRiROqxD9zig9lRWwyjRh7js9dtlclxeE03j+mdOyiGsEj8ZVRJVzed7dlPoL1MpLY9tjznNI99IWvnYTpMmVYGP4imqAIKzBZP0f8dzairGELwAA1J2mI7xmCZFD5JcNFAv9l4iGCffIH32RYwEug2DONmTYRUq8EYKr69KIhEMLKMQDed0bPi7RTbs3rGqrQDMRDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM3PPFF28037229.namprd11.prod.outlook.com (2603:10b6:f:fc00::f5f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 18:39:13 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 18:39:12 +0000
Date: Fri, 14 Nov 2025 10:39:10 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Dave Martin <Dave.Martin@arm.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aRd3Ts9tZnbwAYeV@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
 <aQveOz66Pd3R0FfI@agluck-desk3>
 <aQwHpFEfHGpoaVW9@agluck-desk3>
 <aRNy4G0XoREMNs4X@e133380.arm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aRNy4G0XoREMNs4X@e133380.arm.com>
X-ClientProxiedBy: BY5PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:180::22) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DM3PPFF28037229:EE_
X-MS-Office365-Filtering-Correlation-Id: fe23a6aa-57f2-4b89-05c0-08de23ad1b3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YZ+1esVM7ISqPifuUAMaC8JNpKa1UF2kWbZL6xzhQ8DtGdHGVaMPNOGdWbqa?=
 =?us-ascii?Q?rVmOBDNi5HEuW3TLXmAvIIWdjBykPE9hHPH3O/76iNursJdZW7wALduIvt5O?=
 =?us-ascii?Q?PjLU8T6039APReyF0+nD3AatX+cgyoimp9na9U4oryGb+HYtHTYXVz89vZ7J?=
 =?us-ascii?Q?LvP9oXK2TI8KTeyDE9o4x1zR17SmFMj+ewsHvg+uTcXvbANz62cNh7ewLm+s?=
 =?us-ascii?Q?NNFyDFNAcWWIPIl5kj9AvlxL1WO8ZawkexqB8OskfZ1ZUDJhj/e8YofdA1O8?=
 =?us-ascii?Q?8a+36M2nFzr2z0Jy0qtZlnqJyPKepYzKOTIzfbBP0TdXACg8HYA/UTC/EhVK?=
 =?us-ascii?Q?QfJiHvWf5wLmKA41wKm0lZgveCea91zZo4pCeWWgzJ3rzj2iHZnLUDUwbEgT?=
 =?us-ascii?Q?ZdMJJdjUp83ZepXycDzjxkn7cTLLTu3ffuVz/CBW4f/xEcV56YdUNrYlauC6?=
 =?us-ascii?Q?+ajLpy78MUYZl9ceDficLvcjJAJM6u7xcoLfQZ/KM4x2NUIjeA6NfVhAOsHf?=
 =?us-ascii?Q?d9MtaS1L+MpWd9fuU5gmBSxJpPlq3k5cI8qVIWEJgqRSH/5oP4o8vFD9oRSN?=
 =?us-ascii?Q?KtyeTZQ1xn1hvwbB7rhmuwuOYocKyg89nEM40Rodhx85FH9+ra8+oAL/Qrmy?=
 =?us-ascii?Q?WhVD8H5+vY98qjRhf8Sk2cXjn1eX3AXBZ/jtXgfDlEQEUULwSlLCsenSAglj?=
 =?us-ascii?Q?+HQSCD/v+6CIADX+W8B1G7CKR8DflzsgzJR4obQfpKdztSuLyCI6pY5xFF1w?=
 =?us-ascii?Q?YxtxNHGryC4RlquU+FeVfgfnpYYjLJWiiagz2DzFy7gSWkqHnvqvd4UdvSRD?=
 =?us-ascii?Q?NCd2QAGAS9OFf6t5Eu87p3fhp+azg3g8eERi+CvpmnBx2V4qHJntfdwilxAG?=
 =?us-ascii?Q?esALdAAJV5mMfHTChnZwBkjy7qyNSjc7syDOPwo278gql4Jj7ApD0i83A75c?=
 =?us-ascii?Q?ioHMKS2mxYe5HVu7w5ea727Hm+eJM/2pTZaeMV8sqPl/vBRCHkYAGD//XlPH?=
 =?us-ascii?Q?zEMiBvoW7d8hH3cggXfOppqkWFH0o8RBTHF8GjwVodXYQqFxSp+NQTeH3VK0?=
 =?us-ascii?Q?wmvZiyb4VQ9KJp3ChyYJz5BPMwe0beUg7Xrtd2yANMwqki8/Rs5yjZHHD+00?=
 =?us-ascii?Q?l17VNQheyNfGEdQSQOUgMIbgaQaxwu85rt6FtIi4AXu0qi0DyikrfgWGQf2K?=
 =?us-ascii?Q?av80XY6D45/D23iIWlGhG1UpqEYKQXZZaIWvxZDWxpAaD6rO9ZuRzDpqMhpe?=
 =?us-ascii?Q?M7Nt0UTbSLGwX1rWBnHhdsn1EfUBwyg4e/WfIGgCaIgITqwyeZlTJTDy3Vmw?=
 =?us-ascii?Q?+sqp4AyWmJ7JklNJsRJ8d5+BdBHMfwVSF8BOVO8wfMSrALgFu7YmhTUijqct?=
 =?us-ascii?Q?6wE8odoXUgaTTR2QpB0oLJnYy6nYh7CMGz7xgjG3qI2/x0lH+xR25QQRH0Sf?=
 =?us-ascii?Q?dUUFKGl8J4msrzZfbvzuZ6Hnx8zac5W2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wF5W/Gga2Jprj4BejXO5cfKoiIulLpQXszZPY0Ka6dn2RrNCX1DlJbl6vYUx?=
 =?us-ascii?Q?7ZvwlkudyMNNbhLXvcWjYgbUe8cWSpvdkbZZmuWcC/O94MgiM3JeeP6bLZ1U?=
 =?us-ascii?Q?YI28bAG2X66RUgIZJXrKtSYW+Zc/g4feNNqWc73evEM126sFT3O1H5b/ZPwu?=
 =?us-ascii?Q?Sw3eF9o27zP6ns7KwbVxYx50Wu9p1Q2RlOEV6ZLBAPyoyHWW/ClShwQAjW3d?=
 =?us-ascii?Q?+qdLlWND9F4IyWqYW9V/kJsY/zVd5B6SR5lmglkwiJX8aGBXdkrwtkEh/eUv?=
 =?us-ascii?Q?2rXyx+ZD//iQLrYCtkE+LJL0lA6b1Oa32AjqOB67cexRLpH6AWNqK3Illdss?=
 =?us-ascii?Q?7e65KPG0A9s6bJU8nYnMaNdYhDKf95gITlTN3Z5uL7rSp/SGoFuxmVBtYxdb?=
 =?us-ascii?Q?XnYNxJBV0/KnZj+gXN/ynuGJsnmGdl8xMh5t7G2fRCzqIzwWwU3I4SapNDnH?=
 =?us-ascii?Q?DRBI38aXo1raIXe2sdq20W26rBaWEGGRLZ4LK9Cj3giiAzcJ4uVOxux5MCgo?=
 =?us-ascii?Q?xHH7DpvkjiLU04W+gVrQNn5AvfKtehfDe1q/eIURBN4mzt7EJvNIR/idkI+f?=
 =?us-ascii?Q?SnnjpBWQCjIVO9iVJggPzNkAGnuAFk4PmBtWyQZ5F0+4fBw5R3ayO4ZssfIc?=
 =?us-ascii?Q?TkT2cHXMjgN12OwBU4cF37m1S6KywRFfEcS9ZGNYhy63Mem9QSA2xAzPPqt2?=
 =?us-ascii?Q?jO7SkCYK/ENj0hc43/7imae+dz/wQoZUtL2V+uRl+DyYq1ClUJ5SQKd+hc48?=
 =?us-ascii?Q?L0kCvcLP7aI7MCXAEJFSduS+jGbKiEqfKiPzq0+EzsxgBOeSdL68V83W1rwb?=
 =?us-ascii?Q?jj/x4/Db2UjR9StmjxNKlpu1QxpY9vsZHSv4ol+bbHlSOyodGwE2jxqvwuWs?=
 =?us-ascii?Q?UQBML/NoeeKcoW2xWpD6KN518a86Y0FPwvmREE43JRXCNn5TvBfsyPhmwW4x?=
 =?us-ascii?Q?1gluc/l5xkjssQPRudMsveeoB4gLn4Avwyr/1maJtOIOlmmAwGve5+92Fhnb?=
 =?us-ascii?Q?MlOWrsZVf9TuyqroSf9BblHW9Wxo0kVlzJUs92JAOEjH+XTIT+hOP3BsnSla?=
 =?us-ascii?Q?sunh157YrwpJckW7hBHzJFK/VlmmfbirpJDSXiDG/VahswdgF11TlPL9TuSO?=
 =?us-ascii?Q?XsmRIx5a5r/9w8tem4k5g0C35uyi8iW5lupkqAZzGlsmOtI04v9OQhTzYPxs?=
 =?us-ascii?Q?ZzUAoMEgpbPGqr61xrO5HwJNQ01Bk5p3AGC0bnL/y4vi4ny6kbMaUkBZ+LoT?=
 =?us-ascii?Q?Xl4Uixgl9yGthMIomxtijowIe9Ht/6DcAQ21OEJXMXpZy8N9dvQ/w/O6+I80?=
 =?us-ascii?Q?35K9o/ZiLUUPI3JUy4D2S1pvcrN/yvZDLjWAyRGtxQ7tVajNYEI0k9kFvxT2?=
 =?us-ascii?Q?Z8DsfkDSgHGbNB/ilR7uuAFYAi6Q3a4ZTndq3nlQUfJTYZorm3b3QCK99NIF?=
 =?us-ascii?Q?f7w4uu0kQM4ie6ZSKMkzP8rkw+M3jyjgRlOsM1fGOjuMHkLgBH8hhJIPcq3U?=
 =?us-ascii?Q?QyHqpAtwEmAqM26YryBdZa+o5OBvgoIJ27TgB/Zv70ZdCvwPZhZb5ts/0KeZ?=
 =?us-ascii?Q?hbLpFV9pcPg523C3fP6CKr8ZRw/6F761w9D5zeo2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe23a6aa-57f2-4b89-05c0-08de23ad1b3f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 18:39:12.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9EYr6QW+45It3qcXypTz5rSKaInRhVmsrEo18IVxrzBfFLlPzv/HErW+ER7OiXE29/Nw3vXE89frXn9Axae/kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFF28037229
X-OriginatorOrg: intel.com

Hi Dave,

On Tue, Nov 11, 2025 at 05:31:12PM +0000, Dave Martin wrote:
> Hi,
> 
> On Wed, Nov 05, 2025 at 06:27:48PM -0800, Luck, Tony wrote:
> > On Wed, Nov 05, 2025 at 03:31:07PM -0800, Luck, Tony wrote:
> > > > > +
> > > > > +	if (!binary_bits) {
> > > > > +		seq_printf(m, "%llu.0\n", val);
> > > > > +		return;
> > > > > +	}
> > 
> > I can't completely escape a test for !binary_bits. Most of the
> > flow works ok (doing nothing, working towards frac == 0 when
> > it comes time for the snprintf()).
> > 
> > But the round-up code:
> > 
> > 	frac += 1ull << (binary_bits - 1);
> > 
> > goes badly wrong if binary_bits == 0.
> > 
> > I could write it like this:
> > 
> > 
> > static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
> > {
> > 	char buf[decplaces[MAX_BINARY_BITS] + 1];
> > 	unsigned long long frac = 0;
> > 
> > 	if (binary_bits) {
> > 		/* Mask off the integer part of the fixed-point value. */
> > 		frac = val & GENMASK_ULL(binary_bits - 1, 0);
> > 
> > 		/*
> > 		 * Multiply by 10^{desired decimal places}. The integer part of
> > 		 * the fixed point value is now almost what is needed.
> > 		 */
> > 		frac *= int_pow(10ull, decplaces[binary_bits]);
> 
> I guess there was already a discussion on whether it is worth
> precomputing this multiplier.
> 
> int_pow() is not free, but if implemented in the standard way, it
> should be pretty fast on 64-bit arches (which is all we care about).

Earlier versions of the patch had the precomputed value. Reinette
pointed me to int_pow(). It is in lib/math/int_pow.c and does seem
to be pretty efficient.

> 
> (I've not checked.)
> 
> > 		/*
> > 		 * Round to nearest by adding a value that would be a "1" in the
> > 		 * binary_bits + 1 place.  Integer part of fixed point value is
> > 		 * now the needed value.
> > 		 */
> > 		frac += 1ull << (binary_bits - 1);
> > 
> > 		/*
> > 		 * Extract the integer part of the value. This is the decimal
> > 		 * representation of the original fixed-point fractional value.
> > 		 */
> > 		frac >>= binary_bits;
> 
> Looks reasonable.  It's your call whether this is simpler, I guess.
> 
> > 	}
> > 
> > 	/*
> > 	 * "frac" is now in the range [0 .. 10^decplaces).  I.e. string
> > 	 * representation will fit into chosen number of decimal places.
> > 	 */
> > 	snprintf(buf, sizeof(buf), "%0*llu", decplaces[binary_bits], frac);
> > 
> > 	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
> 
> Can we get rid of buf, actually?
> 
> I don't see why we can't just do
> 
> 	seq_printf(m, "%llu.%0*llu",
> 		   val >> binary_bits, decplaces[binary_bits], frac);

The buf[] was only there for trimming the trailing zeroes. Now that is
gone the result can be sent directly to seq_printf() as you suggest.
> 
> ...?
> 
> This avoids having to care about the size of buf.
> 
> seq_file's crystal ball knows how to make its buffer large enough.
> 
> Cheers
> ---Dave

-Tony
