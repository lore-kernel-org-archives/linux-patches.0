Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0D170A11
	for <patches@lists.linux.dev>; Tue,  7 Oct 2025 20:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870077; cv=fail; b=m7C1v10Zg4i0lAs4BVNYaWrqHinZlzip4A3VJTZnkt1ydWXs+kYPGWjqFKG3b4iU0zV2EwDSCH/H/lMsj78TKZl/SBIOOOr2Jo6bx+hZfAy4W6jJwhVVV1aXgJC472m987IwV25VBWjsW286njx2aT9pBa2fByXGQ58aHuAOSr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870077; c=relaxed/simple;
	bh=0S48lcADXxwwjYsztXyFUMczBkCQZXv5tTQI0YsG8N0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eByklBa/VXmrCJq52MdPU0/B5v9yJsNGP7ew2FBnFhnz7EA+fqgGi02A85m+RpPYfOYONiWbLKV9FTK3KW+6lCHgN08CzbayuBK7FCDzvHBVcLqqP8drYotwjXq1mGI+7HfHONmbt+ieY9hqgtzv5w3B1IgCoMvY0h7syOki6qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SzEeisMS; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SzEeisMS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759870076; x=1791406076;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0S48lcADXxwwjYsztXyFUMczBkCQZXv5tTQI0YsG8N0=;
  b=SzEeisMS0UJdRcmouw8JYYxgtD1kdzj6x5GSq4Lbc51qeTPTN3BYF52T
   HBnnI49a2cu545Z6BU+QmKpp8Ctf1EvV1W+msmPgmLXhocTfZKJI3NGoD
   0frnvrwPLyRCc1KTuE/lM18DwmBiqF1ljMg8MAS7pnIooLjqku8vzafdk
   NudMf4gdyf4DgL50Xjt4SFlrrMVVbzurQylJaoPlFHHir7PDcb/G2loGz
   wWwQckVjAXYvxzsuHc03USrGDwnJpnafXR2+HquS+jrBNvtwfemTFILSn
   xbVQa+9H56sz8MFx/F2PGEozKBLv0F+1q5aR1mAjhA7tSLv9zvgo/gh2x
   A==;
X-CSE-ConnectionGUID: aB9VAjqCQyOuUM59yJcgpQ==
X-CSE-MsgGUID: hU8C0v/eSjSaAhiIeIZm/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11575"; a="73406791"
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="73406791"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 13:47:55 -0700
X-CSE-ConnectionGUID: TxbgtLCnRxeRCAa79zW6dw==
X-CSE-MsgGUID: oMFeHotdR7i0YvIHL6o0eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="179381983"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 13:47:55 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 7 Oct 2025 13:47:54 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 7 Oct 2025 13:47:54 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.47)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 7 Oct 2025 13:47:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URnY5VI0JPSf7ooMjv/hYC1+n2kQNu8luCCXiVANGB3pdkG12hvoq7XIp/zzLK2+0AKXd1nLQcbEDmoSuSN5gxRb5SrNfwtdhI/jinlhluaeAMMtbEy+0YEclidxaArU0Ro28umcTQveFfhDV6jGgb29wE1oen1wJ3LC40+URAAk1VAh7otzraBHvitI4QBDsY56g/wRUbUzg4uGcb/BQSxEBUHc9pK3BCQt18Z5xR79aIZL97yDHc8lAkUY8uD6VUhmp4hiBR3+enAfSerRmMcnbYVXupzLY60UuflPljANmKPA11OSbh7r7LnYQEE93enLYtwgeHvGuVK4Uo4kvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMailrEw6FEcS5msx8YYRzC+Vt342kB1DJExdpBaQ/Y=;
 b=OWUfbTP0jiPOyD3+O1C1dtdj05g5tk4NlgFo39Lu2JcUXXuK7MZ2gEoAchquI6j10RNmYyowgxv3beM3FLyGEzUApcZwFVmbcLTXf0K6s1WZAkKHxlIdg7KxDDr1QF5ZUr48K4s2wln/as5xar4B+2E/jZXmsG9ZzJF9eWcfKcuSUw4Bhp+ViUIjY7OChD3eidoa0/+3G3VMOpqOJbyAUteAmnz7JH/rWq4mfcfzcElJR3m3UfeU5DA0Qe4slQwmdxwcaRCP4O1TFIth03lynHvEXMIyN/RMdlnOU0dqf5WsmjcX9DJ/R8U1OiGaKYhX/6PBUu9mbo/dPZEHnNjdHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA0PR11MB7160.namprd11.prod.outlook.com (2603:10b6:806:24b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 20:47:42 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 20:47:42 +0000
Date: Tue, 7 Oct 2025 13:47:40 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry events
Message-ID: <aOV8bFiiQxlPDske@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-15-tony.luck@intel.com>
 <08a35a50-480d-48ee-bc07-b7405274a487@intel.com>
 <aOQIMQsgBOta0PRP@agluck-desk3>
 <89e640fc-6bd7-40b1-8968-ca1a85005f4c@intel.com>
 <aOQ44WJMXweGNlL2@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aOQ44WJMXweGNlL2@agluck-desk3>
X-ClientProxiedBy: BYAPR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::23) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA0PR11MB7160:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d2f2fb9-5aba-4322-9198-08de05e2c2a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jNoTbU6r3XA+IGfuZTpIno77Q+4jU82t0J73x+kpqT01Rj3QqWfbf+TyMEyj?=
 =?us-ascii?Q?bIRLtZr/8NuWPNH2WPJu2+StiZjwBRoTBtn/qqFdQ9v/VpB9VYIqAznxujzw?=
 =?us-ascii?Q?H1RNa1LDGK16K3j6hzsDeSTp3DS/JwT/EVfNauXSNA5tcwdzQaeuPRBx32eS?=
 =?us-ascii?Q?tgwRI+cJ+fLIQMRDCozzOpN+qouLxNcKIe88yMuCc1XK+1IuZSKvT7tMOXOo?=
 =?us-ascii?Q?Jp1JpwWGpBJKYB7dlZK+WrE4RN65hgvpmj8ejzK1M49AMMnhdDYMvNQsfnp8?=
 =?us-ascii?Q?hqo0FaiRdO6eU9fn61Eb7KZ5FMvhUngNnrfWi8HM0otO1W9Y/WYVd0spTSTg?=
 =?us-ascii?Q?QFH3b0OJsS1wQBTnUGCBmEdbl0Xd8ziGiYHFRGmosk3APz44WHjylo9Gg4z4?=
 =?us-ascii?Q?NMzJu1NJKbD2QDWGguiAm/XfvG01SuyCWdoJxpiugF/HIueqMFuWqQoUgFtB?=
 =?us-ascii?Q?VrGUD2f2BidE+U6tg4hVFOxvutwhs/PHKnAA+HIp0PBOwqgX5RI1OzdiqSND?=
 =?us-ascii?Q?udkMaNwhKG2VJ61n7efiTpZZmhSjyC5Osq4MwXvzBIfVSfpwI2f2at7RbA+a?=
 =?us-ascii?Q?+sl20DYnEmWNrY3df2ka6f05+gYgjwjiVM1VFiXvdGFk1CPQ0SsCze/pGRBg?=
 =?us-ascii?Q?2PUvMz7T7dyVV/ExY3j9b2m+9rJQW/grUGiHueJD9c6OyWWe7QFt75z4Ozlo?=
 =?us-ascii?Q?wMLd8Eu0HjGFBYQUyC50u2tHPIjIjlPXfUocJbHjiLR49MY1tjmoTUE3/wRZ?=
 =?us-ascii?Q?b+w9cP3/U2WJ/fSWES5mGzAw2L8REew1P6T87CIWmU5lfl3D7rZ3wQarj2yj?=
 =?us-ascii?Q?i8neCVpZdIkJmP2DmqxNhXYFm1gxXEckJU/VTWjU3m8uht2rwbZEiPIoIKEQ?=
 =?us-ascii?Q?pcpmD+k+j5k+i2Ojvd467ptk5N/w/HywDeW0+k6pqwHxRESzxqw3YXdXfV2R?=
 =?us-ascii?Q?Aq3UhMyU+OGwQfnt9xJd7xm6c9NU7+5Y4l6jqjyPestHOo9VuyuGMt6SwgX7?=
 =?us-ascii?Q?dxN6NQD39MMzsDK3O4cLKa+ck/n6yrU8v2lBXh7VNFb87xogp9esUBguW7U0?=
 =?us-ascii?Q?5q9nIPZlBLXTIerSCsO9lKy5bNY36b4zKSNmG8fk6rVTZzT4X1DRFjcoIHFL?=
 =?us-ascii?Q?E0YlGKmgKA/IfvHCbKK0LYtKJVRWCT76/ILNypzK4jbfsZ8/xfb+zv+2FzAv?=
 =?us-ascii?Q?utzFwNmXIKYtXC9rWJtm13i2X716/NdoZgwMn8L19k9Os5phTqBvDFPGyAUe?=
 =?us-ascii?Q?HpuKu0cUsGGdlG2+xG4yXZDGU4joC3PREoJZcR7JqeiEn4gOqh26AwHY/8IN?=
 =?us-ascii?Q?Rlhqe52uTHe0yWdTVIwVcOgzUlUA8w+Iu95wMggOSkHevoOj6m81EGtfpvoz?=
 =?us-ascii?Q?22qtAhjzUq70K9dkXAUkzAII9D84e91YgirchYC2vcNbsnsv/rJIcNuhxOc3?=
 =?us-ascii?Q?afOnMimdulfUs0peFI8LliMnEnryvNLZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fTVz3EHEKLbEYciLxaEvFyKGjQb2VDysji3jYUVnSJlwHol6IH1hkfE5b570?=
 =?us-ascii?Q?HKnb1cbH50QU9sO+5dQVq4DwymqBlYGuzheE7BmaZ6riHAnZok5xKrdTRuJO?=
 =?us-ascii?Q?S7Hefun6dLfesblv+J+F8EVD2b8kJqpVbfA9BIevP4tvFnM0RZpnGPyWClB4?=
 =?us-ascii?Q?U7lNuDJK5OT9gRlmPSuuUhEvMc9+yluXjF/vxCxCl7VZuv/yz36UQDgthWRM?=
 =?us-ascii?Q?8Dc0D0JWmRsPkfmz/bRqzCJJ598iBmRwK55pfnt0hhA3EC0B5/NcvHpaf+Nf?=
 =?us-ascii?Q?yvLr7OrH/4ULamek0Us6aWvif+GJrsF001OtTJI8/FJm3W+BTUCke6hB6NCj?=
 =?us-ascii?Q?p5x51hz33jvHPBUOm2W8y6O0y4jJsCT7KZYQOGPp1bmZzJ3hbkitmjvSxdHX?=
 =?us-ascii?Q?gY9LsiidFM14WJ9Fw+6afLtMbUeUxeT0yD0yijvgVDRdudWnFE9cZNAYaJYm?=
 =?us-ascii?Q?SBt/prs4k6ejq+uDYGlJPO8c1/QtI7/mg6xdtFvgrBVFyCKVLKImFYT0KcEc?=
 =?us-ascii?Q?87jsMa16jsWJeBSEqdRzAyYd1hKatMAYYF0cKJMCDisFkz2iuA7fB/XCZ75N?=
 =?us-ascii?Q?tn88pp7g1lWFWUElIARhzUTuJwWIadul756hrv1OiiayYDkB3D9djfm9A9Tu?=
 =?us-ascii?Q?CWAG/wQgxFseNszjizX2RsPJNoN0AoT+8WHf9d6SJjPlIu+qh2QPorS8/N4K?=
 =?us-ascii?Q?PzTYto4i7+Yh5hShMdtOL+ziBqMaC+sBWwCa6wKRro3CFRC9ps4hmLJ3ledP?=
 =?us-ascii?Q?E6G9qGI3ogNlFhYr9JPSut7z+MuTkS65cRmkDs+J4j52SKRxfw6RQ1FTdhgN?=
 =?us-ascii?Q?MWgYA2wW4CP1FnJNG+1T5Y6e41RskfE7HKHudC8NXu0jU5cba3+wuBmrbCRF?=
 =?us-ascii?Q?4vCNw08mlPJr1KTnoLB5GK+xt024gSi2eEWtLVp+BBDhkwtkwc3DfC0QBBSy?=
 =?us-ascii?Q?7KSlluTVoNW60qxHtnq2qg56QP3/8ceB9QGQceTeKVVijy3nGTc6PLwk+Wo6?=
 =?us-ascii?Q?Yqp3VHgMYqTyjukcbwVi2POn+ljUpXhVIa8deY2kmEtg8DnBmpd/IvTc9BJD?=
 =?us-ascii?Q?G30/SXpA7VwXpe3ORhO8AWivA5pSlL8zBTlEGmPKvi7GrOe2l75dYBaoNkbH?=
 =?us-ascii?Q?2dVztBCVZ2dT2T39RSFKFmOvsxhXHE8Ih42ru9MTYNZ+L04bNrgZajglc+j4?=
 =?us-ascii?Q?OPrag+ukac34WKHwONPRtrLxyGURj/agqsLNESs/BYn+vuJ5vT5vmwyn8jBk?=
 =?us-ascii?Q?FEB0cT8SkZWbWI/AGPCoako8p+3Xg3IC92Rygz6yYRPguBLSHdARyPHfHmlh?=
 =?us-ascii?Q?TmkKC1Vmvn+lR0b8rU+9DfzArxzpHr2yCvvAQ4LLPe+lsR6Df84WMnUyZb1A?=
 =?us-ascii?Q?wL8sS+0KOQBBPzu5ZiYi0jGmvO7K460YbngwtABY5+quevCLcHL2n2fZ5Fwe?=
 =?us-ascii?Q?jFWItzb6ef0zAeoKhLX86Fk+4J8OtnPHNQnEMZb24aUOwMOqx6dXHmaA1PAt?=
 =?us-ascii?Q?HD4svBac3syipIj1pav0xOUyKBg8fVtkWK+cWC/eMB4h4B/3bE3tOB7eFqAc?=
 =?us-ascii?Q?OrFvwbC+cNk0Djy4dK+yJOLhUAozNxOHmMkpdWkH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2f2fb9-5aba-4322-9198-08de05e2c2a6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 20:47:42.1113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l29k94LSoXbIS1u6N16tcKMyX5qGMENDeSrmmKlUnzFjqGNJxhqKM/XRsg5Vcq3sLODS4zcAVhr0cfs+ghmcCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7160
X-OriginatorOrg: intel.com

On Mon, Oct 06, 2025 at 02:47:15PM -0700, Luck, Tony wrote:
> On Mon, Oct 06, 2025 at 02:33:00PM -0700, Reinette Chatre wrote:
> > Hi Tony,
> > > static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> > > 			    unsigned int num_evg)
> > > {
> > > 	struct pmt_feature_group *p = intel_pmt_get_regions_by_feature(feature);
> > > 	struct event_group **peg;
> > > 	bool ret = false;
> > > 
> > > 	if (IS_ERR_OR_NULL(p))
> > > 		return false;
> > > 
> > > 	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> > > 		if (enable_events(*peg, p)) {
> > > 			kref_get(&p->kref);
> > 
> > This is not clear to me ... would enable_events() still mark all telemetry_regions
> > that do not match the event_group's guid as unusable? It seems to me that if more
> > than one even_group refers to the same pmt_feature_group then the first one to match
> > will "win" and make the other event_group's telemetry regions unusable.
> 
> Extra context needed. Sorry.
> 
> I'm changing enable_events() to only mark telemetry_regions regions as
> unusable if they have a bad package id, or the MMIO size doesn't match.
> I.e. they truly are bad.
> 
> Mis-match on guid will skip then while associating with a specific
> event_gruoup, but leave them as usable.
> 
> This means that intel_aet_read_event() now has to check the guid as
> well as !addr.
> 
> An alternative approach would be to ask the PMT code for separate
> copies of the pmt_feature_group to attach to each event_group. I
> didn't like this, do you think it would be better?

Working through more patches in the series, I've come to the one
that adjusts the number of RMIDs.  The alternative approach of
having a separate copy of the pmt_feature_group is suddently looking
more attractive.

So the code would become:


static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
			    unsigned int num_evg)
{
	struct pmt_feature_group *p;
	struct event_group **peg;
	bool ret = false;

	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
		p = intel_pmt_get_regions_by_feature(feature);
		if (IS_ERR_OR_NULL(p))
			return false;

		if (enable_events(*peg, p)) {
			(*peg)->pfg = p;
			ret = true;
		} else {
			intel_pmt_put_feature_group(p);
		}
	}
	intel_pmt_put_feature_group(p);

	return ret;
}

> 
> > 
> > > 			(*peg)->pfg = no_free_ptr(p);
> > > 			ret = true;
> > > 		}
> > > 	}
> > > 	intel_pmt_put_feature_group(p);
> > > 
> > > 	return ret;
> > > }
> > > 
> > 
> > Reinette
> > 
> 
> -Tony
-Tony
