Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C199F266B6F
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534740; cv=fail; b=OKykJMc8KI1adC8IF72t9FUU4dgk9895cLrjfGPNUWSaExNo7znYxUqZpEywNP487ZlEXluBMdivmOqqQVLu66ixesxvMhc5tMM/BygJHzAFwy3mQPcIWcLoOMS1oYN/x73x/md4ZtutC4FvyeI6OeHtfzK4ZdS3OgRXMsUruYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534740; c=relaxed/simple;
	bh=dyOBXJpbOewdrn7zPJf1Jq6vj5YL6U7cSKZvyzGh0Uk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LsT66k3zrpzC5NaD8qNE381KC0qpeTly4teeZSpkwXmac7IOjBdoNEqn75uLierr6IZ4OvYcJMYAePzcpBkoileQiWlAMPFdW1rliObHqmgIzjStPqXWghD+ymI0kWQD4wLhlLJFTlJmiz72nY+HUNEhHy31p3oK1vLI+t2idqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SoxLWY7v; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SoxLWY7v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759534739; x=1791070739;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dyOBXJpbOewdrn7zPJf1Jq6vj5YL6U7cSKZvyzGh0Uk=;
  b=SoxLWY7vMBoyegLhA/K+12kQ6qxsjR0UvtiYTZO48UMr7rZI7N2ligWj
   NNjOUaYacxRul1mho6USzcgVNiqxyGFL0E3+TzvG+MyLjNRMKpMjZ//At
   3jEcZWAk+lHxeejTomrco+hXK77/1yFIMXVln8Eqq4aLdXK7f/oSjH/5O
   6aC+QkBnQyqkaEn7eWTa6C87NKcd7b82CCbpEkTjCVq9xb7GryvcVHYkR
   MGsfrWqltkz090MAyezS+BJqQ1an2x1hTg2v7w1tUT98/PTt5R1QraeBy
   CTCEdO8YktdQx3blYsOkQ+FbZDrdFX+baJevnhi7AWgISlt8aCalvhVZk
   g==;
X-CSE-ConnectionGUID: OACFZfDuQ4yAedCIyTf/1g==
X-CSE-MsgGUID: V9kbj0EdSuqytBw7bhwfRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="65461544"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="65461544"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:38:59 -0700
X-CSE-ConnectionGUID: cFZkKc/sQsymN4iH9/LC3A==
X-CSE-MsgGUID: ygMRBkr0SHuPQKM3LW+wtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="184683280"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:38:57 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:38:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:38:56 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:38:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIrj4xIdjxAdL5oVpHI0Cbw68pMoaPhYvjX/9D5DEIM6fj67HT60584fejsCNKXcngAZAJrjyizs6PzTTuhNqFNTERiPdQXr9vTi+IEy+ak5pw+QnBpeZCoQ89ynBwkp3rf/U2hHBKGi5sAU7EccFZBVebHADiHwObg0leBb8UgVrjwr7NX8cwkpPoC6is19dg75jFagdZ3kvq1qffpNy7XgHGxf7qh2mTusEvBrqN/vfg9AwqW2O9z5KV84GN4ulgVPOnwE7VdvXhbEASBqUU9cISN6A5Ae3OyZEbD1L/6HUEpo3CvMOKBZvfkBdkczYWP/X3XqshqJh6FyNWZc0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfCwI5HSKw6tCVBUAhWjkVKaaqfaAWXDFgV688NM1mQ=;
 b=BnCdbLiNQMElUq9rlLLBMMfWAxDtSjADmonj3UAd+Gqv6RnGLzxZ2JZvBqotIPiYd/bD5p6jbvPtkbn4u26PynjJYOCPk76EnNfS/cJi4VLdCdkdAVYD+GfdfsDb09vD+9DlolmJbyZZ/0b638u23mON7nNZlBAqIHHLnTlHVTBr5fyg5PeohxZKu7o9Uefb702vvuvz081prY83WcOXOfkiH8AK33qtIncWV74D220QV6YLo2mTkrl+xluguDhq8whGLahKYqsLtYEHuAKJMfi+pUh4vsVNlqk3U4J2FwX/9du3r14+4TcAJjmGuVYSf8tyGE6ruvbRkUO7901K9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7975.namprd11.prod.outlook.com (2603:10b6:806:2eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 23:38:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:38:50 +0000
Message-ID: <2ec8e10d-fffb-403b-bd86-722a6520c1ae@intel.com>
Date: Fri, 3 Oct 2025 16:38:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 16/31] x86,fs/resctrl: Add architectural event pointer
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0251.namprd04.prod.outlook.com
 (2603:10b6:303:88::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7975:EE_
X-MS-Office365-Filtering-Correlation-Id: 29ecb2f3-610b-48d7-acf0-08de02d60194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Wm5ZbURxYk1kLzl0YUVZUzVXSGIyRGQ3ZzBVLzBMT1RLRXF2NzRJSkhGT0Fs?=
 =?utf-8?B?akhITkVERUQzKzU0cnJqZEt3S1ZadUp6bnMyOWNCZlFPK1Y3MFNUOHBrL3V6?=
 =?utf-8?B?UDY3M29HaXZRTWx1Lzd2aFNxV2NlcmlJbjdiQXdpNVNqczdtL0hiZXJ0dlhX?=
 =?utf-8?B?TFlaZ2lvWC9pamNpZjA0YXRKc2Z3YUZPZXlTaC9hZUZ0ckYyaUpyWDBoK2Rq?=
 =?utf-8?B?SlpGdnlNV0N5eThkMFdwTUV2c0tnTjVsbkpncDNTZVFPdVUzVW1WMC9DNVFP?=
 =?utf-8?B?NnlYZFVvSGIyY0FsN2NMbUlOQ3ZXVmk4YzVzK0dZZjdoQmg1eHgvZVRvWWVx?=
 =?utf-8?B?cjNjWjlxYU1vR0FldkVTeW9WY3EyaGFUUUUxdS9RUnVsUlNrK2VjdmpHeEVm?=
 =?utf-8?B?QngzSVJOcTZQcnZHSk45aHNjMlBIZUpZV2RYajZ6OFBud0VpOERXbGpVak9i?=
 =?utf-8?B?eTFSOUh6OGNkWlhUNG5aTXZFVGd5MzdCbHJpOXoyNU8vUWxQQXJOTGJsTjgv?=
 =?utf-8?B?WTI0ZG5wSnNzdHpzTDRqbE83V3E3RDdGOFpIZC9FajhaZWo1V2w4ZC8weVJr?=
 =?utf-8?B?bHIyRldCRmNZV1Q2VzQrMHdwdUtVL29Ja3g1ZnJGT1lCa0p6WUtiM25JYldU?=
 =?utf-8?B?Uno4Ri9RTkhYSGx3akFOanJrNmpaaXhadWdXVC8xWGsvYzViNmdJRW5zZzZs?=
 =?utf-8?B?eFBRZ2xpV0J1ZTZ1ZVlDSXNUQXBFNjlzYVJjRjEzdWI0U0Fsd2x0d0hZM3F5?=
 =?utf-8?B?TlJSdGpxclJxa09qVk16WHdGSTA0LzVpeFVlSmNxQ3VycDdmVUdybjlDMnZT?=
 =?utf-8?B?WkJ2TC80QkJrN2JiTzRqTUxyc290STVUOG9yc3pnakdLME9GWU1Nb3E3cTd0?=
 =?utf-8?B?eDA1RHB4cWFkVlUrYzA0SHhiZnc1S21McVk3bFhLUWVhMWtRVEZLVE82YUVB?=
 =?utf-8?B?S1pjWTJCeUc5VVE2WnFpRVVBUXByY2JMem84TnBmN3pPd2s0Si9YblUzWUd0?=
 =?utf-8?B?eE81ZklsYkNFTlZieHYzSy82Y0lJeDhwaTM1TG5aZFRCNEsxSzVYc2lUMEpK?=
 =?utf-8?B?M2Vpek9uQ2pFd0JwM3UvWjNyWTVUVnVYb0pQNGJJWVBkbmMwWXYzbjZHTGVN?=
 =?utf-8?B?TVdhZmN2emdqODl0ZzUwSXlOM0dGWDZEdE9CekRlQXhSUGxRUktvcEFnRXFE?=
 =?utf-8?B?WFg5L1p3T2RnQkt4UythNUYzR3gvVjFBcHZVUlVrVjB5SU5aRFFpY2pGYVox?=
 =?utf-8?B?R0VLUHFGdG5YS2hpVFlrang0RXIycW5QQkVZS094TEU3ZHdOOURJNTdjRmgx?=
 =?utf-8?B?cWRrbU8wS1JTR1RGQ1R6emhmdlIyMHpkaGZTY3k1MzhqZkRJSm5tY08zbnEr?=
 =?utf-8?B?OFZaaGtyQlY1NjJMM1ppM2svWUx1MTJ6OEJidXNBQkZldDdLUnRDa0EwZ01G?=
 =?utf-8?B?YmoxUnBqSDRjaGZQcUU0QjR5bDZCdmVWeXVqK01NTGt3UXVGRUUrZTNKZk01?=
 =?utf-8?B?eXQ2UEM3QlI1VXRzUnM3TzlEbVlUQnROM3ZROEF0QWd4bXAxSjVGdnp5TDRu?=
 =?utf-8?B?eU9mb2NOTm4rVzZQcExESnpQQUREdDhPcll2NE8wbCtSSmhEWktRekxLMEk2?=
 =?utf-8?B?U1JpZitiQXozaGVwUlR4dStDczlFOU8zeFlRM25IeXRZNng0Qkt2TGxtVElv?=
 =?utf-8?B?c1JuOW9CN0VyNjVCNk1SeVV3bWl6bzErL3NUODNmclFiZXZoaGVhd3RVZWl5?=
 =?utf-8?B?a3hlbFh1SStEbXZGMDZTYUZZNXNiZDE0TFduUVh4Q1RBTTUzOCs1R3RzLzNI?=
 =?utf-8?B?aVdKZ1MvZndQUUhoMUJBWjY4SjJVeDIwcHB2ejhkWW53TUt6K0VxSGJRa1po?=
 =?utf-8?B?YXpJTzg2dUlBUmNhTjFub2VSUFN2U250c2dQRk9hWDNBQzBNeW9LaGNPQkIz?=
 =?utf-8?Q?Gco4hvN1q0cVlACQmBZ7s32dGJ5E8r/R?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a09Dem04dkR1NDZBckFJTGFBTlc2QVpaY2E3ekRyMERHWWp5a29iYjlyMFJw?=
 =?utf-8?B?QzNJV3dzUEsweWRjWndVcXV2Njd4YWRpZjZJRU5CMFlNbFQ4VVRFRHVIZVp6?=
 =?utf-8?B?SVFaS3YyUngzLzdPbGwwUEJjME9GUkVqZDhKbENBR0FYZHR1dVlUb2NHWFZR?=
 =?utf-8?B?OWpySk04b0NFWHE5ZUdtM1Jtd2tjMExDdzNjcnQ4UUdsRGxNVDBPSzRZL1hG?=
 =?utf-8?B?aG9kTWRQbnUwb0hHY1IvbldpVXRvNWp1SisvcDc2am9KbG44SkdUSGJMRkU4?=
 =?utf-8?B?a1FaVldkQlhNZG8zbG5aMmpkTWFETDhaQUJzbGNnd3FnMjFkdXFXYzFxNk9P?=
 =?utf-8?B?VUJIVEg3M04rMzBMNDdqcUEwa0dLRElRcjhZWVptWmh2QlhxUXcvV1piaU51?=
 =?utf-8?B?ajAzMzlvUnBGS1ByeCs3eHMzNXYzVzlOck5EUkR3amlSVGcxMDJCN2RxL2w0?=
 =?utf-8?B?UkdZckNnN0k5RW9MdDRmZXBWdCtKQ3pmNDFGKzN2TVdzTmpvL2lxMHBhNUNa?=
 =?utf-8?B?ajhSWlVzUzBTU25nK3BKZGorS09OeGtlZWFVSXV0eVpWL2wyN3QyWFF0U1kr?=
 =?utf-8?B?OElFUVBKaTVqVDBUQUtyZHIyVEcyMkZoWFgwQTF0SHhIK2FUR0F6d0V1eGVv?=
 =?utf-8?B?UEdkaTR2MFZqYVFmQWhVSVVtOFhoMTQvUVc1azJpMWZPVWdzTkdIWEhpNTFW?=
 =?utf-8?B?YnBHV0daWklWVFVtN2QyMTgwRVVSUnZqN3h0alFpamdqeUduZFlMSHNPaUlj?=
 =?utf-8?B?U1NjQ0pGdVM2ZDcrQVRVQk9ZVVdMOVlsZndnUUhyN1cxTEwyY2VQdzJIK0Rt?=
 =?utf-8?B?TitSMGNJdS9SNkdPbXFTbHZSd3VnNXFwNWFYZ3lrVlZyd2NnRWEwc0toQWtU?=
 =?utf-8?B?a2ZUVUd2MlZCMHNoTHl2aVZtWGluK3EwVzFhenpxVmVucy9rQzJoUmZZMnB2?=
 =?utf-8?B?MUN6d3lLUGtWdW8zMWFNWGpPTDI4QTcrNVVic291TGNoOGZ0Mk5GSEEySnA0?=
 =?utf-8?B?bm9FcXNqSlRPVWx5UnYzaFRRM0tiYUVXRFpmNUlvOWF1M0Z4bTRrOVczZ2dq?=
 =?utf-8?B?TXhBb1BtL2U0eWpFWHJDTzNhdTZIeStrZjV1VzZPL21FektBZkl3TnJiNEVN?=
 =?utf-8?B?YkdpRUhCd1VnNEZWTkJiWHJKVExqMXM4UjM1b1hvRnFJM1hobGgwRHpXTEpp?=
 =?utf-8?B?RlFpaXJ6ZXNrcThOYTZQbk8rSTN3dUZwd0VuVUFGQ2pvbW0rb3ViMlVBRHlC?=
 =?utf-8?B?Zi92Yk5uVEp5SDJZVWM5UzdVRnA0VmhPc2NNZC9LN2xWUVJ6ZFJVWThVRkUr?=
 =?utf-8?B?dG5naW1FdlY2WFRlbVdFbUQ0YUp2SEc1RndzbVYwbmRvMjhHQXVYSFVscDNa?=
 =?utf-8?B?VDNlaTkweGhqYTcxcXJuSXV3NkN0K2FIdTNUeFl6OGE0NHYxSTBUMDNnNWlv?=
 =?utf-8?B?WWsza29zUlRQb014c1kwbGZZOEZJOFVpaWprVmwvV2cyTklraW9aZitnNm11?=
 =?utf-8?B?WUVJZ3FaR1ByejdLblkvUS8vdkZWc1pKVDRTUkljUlBMQlFrY3lRSTBhQlR2?=
 =?utf-8?B?cXdLM3ErbTg5WW94Skdad2U4bHJPUm45aVVkWm82OGoxYnA2N2E3UU9iZDRk?=
 =?utf-8?B?Mno1MmhiVzhpL3BzMzRiRE1YYUNOcDZlQ1NpUDNOeW45RHNUWXgrRmxid096?=
 =?utf-8?B?QUI4SVBEV1pVV2czTC9ndjI4cktZVnRmd3hWZ255MkJuREtlaGp6ZDQ4ZTRI?=
 =?utf-8?B?REZEWXRHbjcreE9FUEwwcStJb3VIK0d0c015VlY1bHplaktTanRUU2ZNQzJx?=
 =?utf-8?B?SmdMT2RBdGpQb1dKYSswOFpCL2haWDdMWHEwTDZXVFNpOVd6ckNXa05McE8w?=
 =?utf-8?B?Qzc2K0RSSTlKWEtYcHNpUmJwWVdLTVR0WGszVFhFNFBpQkhNQWEzbmgvL0pX?=
 =?utf-8?B?L2xRRXBhd0doZTlnNDg2RjZCbWhuWm5BMmhUZEJsL1RhNXBLT3Z0Ty8yTnNR?=
 =?utf-8?B?K1JSK1BpL3BJWHgzY2h6VTUycEpjeDg3UFFaMEUrUVI3WWZwTXlqNjhGTjZF?=
 =?utf-8?B?TllnT3dVaFFGbE91NUQ4eFRLVldmY0pVTmo0QldVWFlqOWcyZ1BPWGdKUXY2?=
 =?utf-8?B?RlZiWkZvM2RnSWZYV1IxbituRW4yNUZGZEVTR1cybEVmRGQ0akNYdm92ZGJy?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ecb2f3-610b-48d7-acf0-08de02d60194
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:38:50.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PsoiYzxwb4o4aP29oG0ZFXCNVoXFTTBhOC0kbmRtNMcjAWXPP+WX5fwBDQgJCc94DrIopN/NAcFrDCwMD7dOHCevaReP8n/KazbzMEjNxvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7975
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> The resctrl file system layer passes the domain, RMID, and event id to
> resctrl_arch_rmid_read() to fetch an event counter.
> 
> Fetching a telemetry event counter requires additional information that
> is private to the architecture, for example, the offset into MMIO space
> from where counter should be read.
> 
> Add mon_evt::arch_priv void pointer. Architecture code can initialize
> this when marking each event enabled.
> 
> File system code passes this pointer to resctrl_arch_rmid_read().

A suggestion to avoid describing code that can be seen from the patch:

	The resctrl file system layer passes the domain, RMID, and event id to
	the architecture to fetch an event counter.

	Fetching a telemetry event counter requires additional information that
	is private to the architecture, for example, the offset into MMIO space
	from where the counter should be read.

	Add mon_evt::arch_priv that architecture can use for any private          
	data related to the event. resctrl filesystem initializes mon_evt::arch_priv    
	when the architecture enables the event and passes it back to architecture      
	when needing to fetch an event counter.

> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
