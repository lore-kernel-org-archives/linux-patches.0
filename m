Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56B32F85B
	for <patches@lists.linux.dev>; Sun, 30 Nov 2025 05:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764482031; cv=fail; b=LIdcuPR9ROS5d9yD6Qtk1Uo90Yqa5EVFKAiWtnxOe3S0+uGGuuERAZ7uU/oh7mvmJ9V1xErcbvg+m/RfUEaBFdnHMCZIKtfp6I4SYw7jEnBw/xvVeDyxk815Y2Y/sKmTHLeS2adNJ11MfGWFKR+jMFF9SUcKfBkW4fqsv5mm6zA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764482031; c=relaxed/simple;
	bh=vFiO2Z8mxkS4ZCE83GF+xNn0s9cmLo1FoFJxSOIoi9w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SsQL3AtvzEvZnbnKyKaPU+R37Wz1Bdm22iiploLoapH1QIsIPeHJbrHp6BhaiOYgG5pZXMmeQWhXduzELKCS88aAnAtHCxOFcOmohxCDk4Gy9Vrr9Yny/09Rmu5B7W26xELo0PJC16oghw+LbuQns3LFZ4RmBXSC3m1pua2JBCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aqVPl1tf; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aqVPl1tf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764482030; x=1796018030;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vFiO2Z8mxkS4ZCE83GF+xNn0s9cmLo1FoFJxSOIoi9w=;
  b=aqVPl1tfzQHgb7mYedr+9azDFwdAguU3nxOgAmzy1LqtNHg2St2GgSWi
   oUsIwvUSussxLlTCivCUYB3uBeiT1nijtwEi+yIClXSQMRVTsS629WBwy
   iNRS3kIc0JVgKVPheS0Irta8MGfXr2H0znp/DFGL3QD+BN+HfROy++SVi
   tJe8AV6xM4uZ5u/pYZIAC0AByHIxDwn8yopIC+ZRXNxStweUDMMfBZI8h
   Uavw71qzykI8uTqwrgHGiaNTe2Z4Z5ZRNdZO8OyqDY3HjQX7+OpSzNCLE
   VUQOjP+yPlE4TW9lk1+yApa9SMq52Afyq7q0lSJIlLXDjXPCPcjsJjE1g
   w==;
X-CSE-ConnectionGUID: dq1E/K1eS4OAixUNuISdQA==
X-CSE-MsgGUID: 6N3l5zorTkiQknMU/echEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11628"; a="91915625"
X-IronPort-AV: E=Sophos;i="6.20,238,1758610800"; 
   d="scan'208";a="91915625"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2025 21:53:49 -0800
X-CSE-ConnectionGUID: mwOCvgM4TDONWp+cJhbvjA==
X-CSE-MsgGUID: vcH6Dxx7TNm+P1iigUyOuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,238,1758610800"; 
   d="scan'208";a="198253787"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2025 21:53:49 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 29 Nov 2025 21:53:47 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sat, 29 Nov 2025 21:53:47 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.5) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 29 Nov 2025 21:53:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZKqNfNhmrCmqoA8GphgHWpszWini8XrbGXijXeOg+9f523VYajdd1fO+u9ZM/drP4UG/rVmq8lT/L7Vwaqw1FfTJ3T6Ar434Crb2tkhuWUz1//TlAcCyPPfCo4gFdWmRlrizxvjZRTQdj2dUWCfVePfS0klwtpEeKSSksZcapYknV2NJGNhS8ZSOx/gbQeGIN58T+59y9hDo4LnQTOFYs1fFUY58x4N1Zoelg+8Yja1qSdZEudwG4bDzrmiAdpDCffUK49wlkPLv83czM1+uhjImIUoiY+DVYJSTBxYaeWqKPKBjHdcby4U5wjx1qqWiZWxEmRbWV0RP4jNYZ3NypA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4q40oSZO8dB4/h+vRmBjfil4SpHtYpXF7QWXdCzOhDc=;
 b=BrVYGwrprVjCsxdgeBS2pr7UDeUHIvL7/EkFiAUiw41GUyvC7LVYR+vpywiYbDMAFMp/1EMOavUf07/U1Jv0JkF7Q5sktRAuFB3cmSYhPWHe2UWuoiyrgRTdD7tPMMrq3oKDcNm2VDXeR2wPaUqifEIdP80bKdTen8TbzHoCyavqMWFK4SqaHWvc30FlM0hzn5A6Puwn4nyttziwizTds6aSMN/J9A15ZHXDaWNGlBrBXVriXorg3Av8kiKYQ5Fv+e2Mram1SvZtk2KNK/lttVJH55H9vpoh//mKu21jRaXtlZYACalJkDLTd/S8FR5NvbQZ2KVWc/dO8rjPV/80zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV8PR11MB8560.namprd11.prod.outlook.com (2603:10b6:408:1e7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Sun, 30 Nov
 2025 05:53:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.012; Sun, 30 Nov 2025
 05:53:40 +0000
Date: Sun, 30 Nov 2025 13:53:27 +0800
From: Philip Li <philip.li@intel.com>
To: Yury Norov <yury.norov@gmail.com>
CC: Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>, "Burak
 Emir" <bqe@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
	<boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	"=?iso-8859-1?Q?Bj=F6rn?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin
	<lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
	<tmgross@umich.edu>, Yujie Liu <yujie.liu@intel.com>, Stephen Rothwell
	<sfr@canb.auug.org.au>, Danilo Krummrich <dakr@kernel.org>,
	<rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH] rust: id_pool: fix broken intra-doc link
Message-ID: <aSvb17mOuXfrQdfl@rli9-mobl>
References: <20251127213340.180090-1-ojeda@kernel.org>
 <aSkFwsx-6Gu5Eu2a@yury>
 <aSkJml0FI9KGdhUz@yury>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aSkJml0FI9KGdhUz@yury>
X-ClientProxiedBy: SG2PR04CA0160.apcprd04.prod.outlook.com (2603:1096:4::22)
 To MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5963:EE_|LV8PR11MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fc3d8b2-8de6-444b-9ca6-08de2fd4cf9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pTJLPjkcrOpR8j5xsOq3fLS/NUW6QADY2yC1ejXfp1+MAZsssa/s/pQ+gVV4?=
 =?us-ascii?Q?RrV9D/6m+Thfr8NgK6EnErg8UdK3B+HNKgGydHXZLVDrhnfrhmtgKd9/JnK3?=
 =?us-ascii?Q?x+XgOeUCLc3Rtr18UW+vr9g5wLOLyrcxIEWmpQpGMv8JLER+oCjr/RbJ/Tx1?=
 =?us-ascii?Q?b0YujxIzpUh86M4KHY9GVOFdsaUG8A/kKuhEdG2J/R6dmcob9/18aDFqhzsn?=
 =?us-ascii?Q?qL49fdus+GSmA0WsTdTrGViIyJExn8aCLaMvMm7nbC8g2mg7itH7CRRCiD25?=
 =?us-ascii?Q?rymDq6FtEgZBNoplg1cUyjtW7EHb13Qon6UBPbsGIj5Jc2rMAYzkpVv33lzj?=
 =?us-ascii?Q?TDIdTRFSnT+aSmLfiqsIHc0ljJ/QkqA0jyS3voO60X69nl4uRomkWsn2IX+V?=
 =?us-ascii?Q?Qzs59M3gPqG8rjg0PGLtx8Mucjv+h1/NPZv3hUpEoB/qsDUBRCNRwlGSJRQp?=
 =?us-ascii?Q?SRyzV2RuFxr8f3NUcSBOEMhQmPUarmTh2JAbdXeUx6urYYwHIOwJt/AsSc2C?=
 =?us-ascii?Q?vTOd4jwB1RdaOHI0Gwg/Sef6BZjA+3Z6qr7rNZ5moxyt0DDWznLzim7AnWza?=
 =?us-ascii?Q?4Sc88Sd86N7RDGvffol1Adc+jUjuLK/aKm17dLei69/BOB8uORhqv5QIc9bq?=
 =?us-ascii?Q?m+lIgKHP459XHj/zEBSTWEBHkK1YOXNT3dy2SHYv6sz3OK777zGyrAB/kf+P?=
 =?us-ascii?Q?zJ9o1QjsZX58I0k41HLVAvgx03KPDvpkvMm9yFGmwmx8c6Rvbq4N+eJC9oVk?=
 =?us-ascii?Q?t3utm6D/lrdk/wS6zSMaIbxBeHbMrEgK37fA2SS0NvTgeZ0pNTBvBbvaWliW?=
 =?us-ascii?Q?V8oQ75Q3Tk9U94K64iMKd2jh/dt9OvTJSlXiniBykJKLSxZtZ/9ZaPZQ91ZG?=
 =?us-ascii?Q?zGtTf8LNFurR3reyQWsvFyGY2kPRUbVgTn3i7Eh2m3TXuqUtrS7YkaEXSgd6?=
 =?us-ascii?Q?agq2v7a213NEwcGANw8RBS18ZwlZcUdveAFY04aivyo2a2G5pYJJ4DDhsVaq?=
 =?us-ascii?Q?OsGz+dzXF161ZY+zlShYXHm84bjFbDCJMLriV/045YTZCLKtICw9uDrf0HhV?=
 =?us-ascii?Q?e5YkIkV+kkhr0VPugrkMzqayCxXU6YwFcMize6kbbS6eppef5r1JHmtDX08o?=
 =?us-ascii?Q?cl++9/tgX8l0NXs71EbPjS2l9JcZIoIBxHbbt48CcL+5iaYnYRtFphE4qGv6?=
 =?us-ascii?Q?EftImdo0hU6Wz4U/HxXhJGP4Bc/yWsSaFL5Wdfzy+tLklStU56vS7krHEqEY?=
 =?us-ascii?Q?I+3rSguPekcbAqiaOtNSgpqM2dz6ASQoqbtnTFWxYC5lndTouMLJ05uT4AVr?=
 =?us-ascii?Q?36bLolCqCtFGs0Rk2HGJ4gDyR3U7/J8zTt5go1P5ONIkI8KXwUb+ulSl2SvJ?=
 =?us-ascii?Q?y2OCKAEL4zQ/ZnHEtzo5oYWthuCAq7lt+hX+iPiYkoLHzw88hHLuToQDuO5F?=
 =?us-ascii?Q?eQ//rr4zpFbx8PjRX87S/8fhvot9abUdwe/I7yCi/7SbUMjxRRvrcA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tpJak5gs7U3lc1WaOF+tkQnYZErr5OpKzj853glIf8uHk12KlnQz8C5YfY2Z?=
 =?us-ascii?Q?5Dvbd3jXR6r7KtIJYcNZ+bomLBigy+fLq+AzS6CW5oU2BvbW3R6gEpuAHz1Z?=
 =?us-ascii?Q?+e54L/DlmrvtzW+LiU/fTYF6owhj/EYhMUiespNtFBLWqHQMu7gESUyiw8zo?=
 =?us-ascii?Q?0HJY/T06dxfgDcnZZnYVuOhNezmeVmzBnydzMbbCMn6jZ0N9ePrJLEwMgBpF?=
 =?us-ascii?Q?idIbdvL2xOAA5gFwM5vUNjDVTTkqRN4MK8eOgSt9Y64jAP2FoXw07+6T5UVE?=
 =?us-ascii?Q?SjiSWd8PoAxNp3eAsWVXC6SA0iJI0v1MFYRDszE6be9mplAoZo2PRzqqA7y9?=
 =?us-ascii?Q?Qdg+uLZa37QaIWqKFRBxCwkXd70bv3z94pGdKSPOILCZ9BOx/HpulV/c3MEl?=
 =?us-ascii?Q?37wk4oLXjuVOIL6uKqY0AKdk8/k1j87Z+4PccLFM4uaPo+4kgTV47hFicJwk?=
 =?us-ascii?Q?XUIHMgRjalalERyqZ3WXEvO7tKkCzbfh6UCHV1HXMKz+bYLUSWTst9GZmRhu?=
 =?us-ascii?Q?s6vl71A/v+BPPSGeVL4xOPmq3CGlriuM7joZee4zlOqwXNW8LNVLjdefBah4?=
 =?us-ascii?Q?1WVe7RtMbfh3OO5T1U0FhWJT5YHH6l2UzXrVa+OvEF9iDSJmDOMMSQrKW296?=
 =?us-ascii?Q?1ELlisSXes3I07FCY95/tqHytNKwxPl/k+BTsF8lIM8glNBw4IPOfKQ9iT8U?=
 =?us-ascii?Q?hELNpoROV/5DwGMPS3fD4zZ0o9ZIB9DKEPV/lCoRTstdISqF54qFnHGrInlA?=
 =?us-ascii?Q?JV54SBZ8gYeK4Z+plfYNIF0HhoxMUpL9UlvbCs6gLQk4V6XJ2vNaJ9rQvgiE?=
 =?us-ascii?Q?kPupFY6FHgB9pZRj7/6fJknD9gcqVTIBWV0ySlyTHi8YOmVOPAvrlILsZcDA?=
 =?us-ascii?Q?Wign5VOGc3GsRk8dFDuzFIvvgNuAnJi9w019yvFLJ8p1u/4HK31jkxVHQq90?=
 =?us-ascii?Q?wIIsn5/BVepAAWRt4L25GbgDSfsTXPD/zVYmPvyHwIEFSbvbbHxedRYZZ8w+?=
 =?us-ascii?Q?6ew9z8V0XmNz6QKNusILyD4xYMF24fPwGoRevruKB+lZAMLyDHrCGgCOK7su?=
 =?us-ascii?Q?75YvhezUbF/eK5raR2NYuLLKPJlT/Ew6b0/vNAibIFyna1mt5NXBqvOJBkrt?=
 =?us-ascii?Q?SYSjMfDNO1PxC9eOQSgZTY3XB2OnJfMIckh5JXBovBrxR3KPwSukBZ55Nrl5?=
 =?us-ascii?Q?2VRHgkBzKD/9EJOrCZh3xa4kOvlr5wewllwCJ+z/jGzO+kNEEvJnxgmcYWKg?=
 =?us-ascii?Q?JOnI1A6eha4V5qFOA7hs2qcjAgrP224YjE8H0OHibehOLmmcv3IZi6zQ+H5H?=
 =?us-ascii?Q?ii9DS5F6kRd/WzX4KwGoPo/4kjMDF9upoGmLGxTQ9+E5cRs5V/cYvuJzuTlV?=
 =?us-ascii?Q?xc6OJlY32vispvOwLwcN4Vx1eP7cB7zNx4KvEsqpneq76F5uh1mNqURsYsJE?=
 =?us-ascii?Q?bwsTePG/KM2qcHqnKPqpfS4GOKcUIfczk/vjHSS1/G44lRZs+qVkvH7+gbRA?=
 =?us-ascii?Q?aZU0eH/4h971SjU7wN2MXjcz4uQm7txUreFhJv8yy+RJv8jXe7vrv/pyjl22?=
 =?us-ascii?Q?lIs/ieh7xc+OdRErSPtYrbMaKGXmKKzwqdKJY8pL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc3d8b2-8de6-444b-9ca6-08de2fd4cf9c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2025 05:53:39.9306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJuvM6KcYMM9kO8kwnDuYxHl7XkFp7TWfE6p4sfhPluw6WkXkExar0GX6dJlFFHLKDq4RLaZ9nqcdeOuFC0xDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8560
X-OriginatorOrg: intel.com

On Thu, Nov 27, 2025 at 09:31:54PM -0500, Yury Norov wrote:
> + Philip Li <philip.li@intel.com>
> + Yujie Liu <yujie.liu@intel.com>
> + Stephen Rothwell <sfr@canb.auug.org.au>
> 
> It seems, the below error wasn't caught by lkp, neither by linux-next.

Sorry, the bot does have rustdoc running, but missed this one.

> 
> Can you guys please consider adding rustdoc target in your testing
> grid?

Got it Yury, I will follow up this to make rustdoc check work effectively
in the bot.

> 
> Thanks,
> Yury
> 
> On Thu, Nov 27, 2025 at 09:15:31PM -0500, Yury Norov wrote:
> > On Thu, Nov 27, 2025 at 10:33:40PM +0100, Miguel Ojeda wrote:
> > > `rustdoc` detects a broken intra-doc link:
> > > 
> > >     error: unresolved link to `BitmapVec::NO_ALLOC_MAX_LEN`
> > >        --> rust/kernel/id_pool.rs:100:31
> > >         |
> > >     100 |     /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
> > >         |                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^ the struct `BitmapVec` has no field or associated item named `NO_ALLOC_MAX_LEN`
> > >         |
> > >         = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
> > >         = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`
> > > 
> > > Thus fix it.
> > > 
> > > It was a missed rename in v5 of the patch series adding this [1].
> > > 
> > > Fixes: feb3fdf1239a ("rust: id_pool: do not supply starting capacity")
> > > Link: https://lore.kernel.org/all/20251112-binder-bitmap-v5-0-8b9d7c7eca82@google.com/ [1]
> > > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > > ---
> > > I saw this in next-20251127.
> > > 
> > > I think using [`BitmapVec::MAX_INLINE_LEN`] is clearer in general,
> > > especially for things in other modules, but I kept the same style as
> > > other links in the file.
> >  
> > Thanks, added it on top of Alice's series. 
> > 
> > >  rust/kernel/id_pool.rs | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/rust/kernel/id_pool.rs b/rust/kernel/id_pool.rs
> > > index a4c37d6a0971..73a952d7dd83 100644
> > > --- a/rust/kernel/id_pool.rs
> > > +++ b/rust/kernel/id_pool.rs
> > > @@ -95,9 +95,9 @@ pub fn realloc(&self, flags: Flags) -> Result<PoolResizer, AllocError> {
> > >  impl IdPool {
> > >      /// Constructs a new [`IdPool`].
> > >      ///
> > > -    /// The pool will have a capacity of [`NO_ALLOC_MAX_LEN`].
> > > +    /// The pool will have a capacity of [`MAX_INLINE_LEN`].
> > >      ///
> > > -    /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
> > > +    /// [`MAX_INLINE_LEN`]: BitmapVec::MAX_INLINE_LEN
> > >      #[inline]
> > >      pub fn new() -> Self {
> > >          Self {
> > > 
> > > base-commit: a322638c15a678168aeb8dc11c8760f8a053124d
> > > --
> > > 2.52.0
