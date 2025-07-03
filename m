Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA5C18132A
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556627; cv=fail; b=XtiuOUF7pf/0T14QZYPlg/Mk5lcRDc7QXIfasTvmrgWlp0PW70914X4Kb43TGBkLuHYfKbKUG7hDBUNQZhp/6dIAlJ9873xHurwgZwco+Ne7EIyPm2xVZ2a1TbFXc7vwqr2Tha8ITA9mIBQpCpKVPZ0QDKZ8Fcdl9KQSaMcsbsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556627; c=relaxed/simple;
	bh=Kxtg4QOi49n44gGhhf+7uzbuNW8/nqHGWzmumb4foxE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IP64jJAsaAiIdt2pmw5KqCt85BqdNbhzpjmbJ/4CBPNfFCPiFfOIcsqzc/dzkn7/7zsuUcJZkvD16piKXugAolX8MWNDUFIVxlSXRjY/KlGJ/585AQxsz8ZhjaXgZOTLPGkL6gJgX8Qy6NoWzlt7IShXQ5jNXR2pXc96sqblls0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BEFs0X9G; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BEFs0X9G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751556625; x=1783092625;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Kxtg4QOi49n44gGhhf+7uzbuNW8/nqHGWzmumb4foxE=;
  b=BEFs0X9GfG7JHzxFUZrwLHIlB6eKsyb+kD2XxfufzBa++/9Yam48C2Qm
   PdQA9IC14lqZRwBvX3ZeE/90QTTkycHUS9IsVYp8DLT5QK1YE+xjOHtAI
   uja7xLvoerZoZfelxO/jxk9dYu6mjxwPFuIivit/ZFwKkolD93/Qjsa7b
   11KnyFXxupsBDys0VCI3Dg73exqcFxEN/kH57Zp13GSbdVuhu8iOn9iCZ
   xZl42BsQji6F8Jw5+Ew2yGY6DEz718D+J3V6ZS6X357wybTNYJsc393Q6
   M3WdwChgfx3c8yTxZYPhuQJ7lMQwn+Efv4hp60Zm3aH5jpUbbZmKLW42N
   w==;
X-CSE-ConnectionGUID: K0wITirdSQKiiORvZsTK3g==
X-CSE-MsgGUID: z9rh0BYCTq6Fjl3sR+Oagw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="54028071"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="54028071"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 08:30:25 -0700
X-CSE-ConnectionGUID: RJpQwrU9SPqJbR6A/PsUBA==
X-CSE-MsgGUID: ravCmC53SFeHWizt3Y1u3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="154967994"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 08:30:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 08:30:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 08:30:21 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 08:30:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHeZaIxebEyQFJRgBeW6nIrHM6qFXd2kdtCLMyJIjua2zWcKGv3JN2aQ0n7ad3Lvm3rYtLW94vzqWX6bUJxfGQY20Mgtnj6n1Lja8fZZSx7BanMQjlA4FT/xATnFJLxQnMiTgdT+vbsR4jDHGPua67VRxl0R0x/jDrEmwPTpW5aLDcicdSS8scdu2eBst667hJMjLgLQywzRv7zzwo9EBXBbVjlkZOBap5/TfAZNXsR3h8cCnwqJMQc3IbygVmVPn9RKqb+Lx4Iz06bfdFLmj1w16RI8zhmTYhwqMCm36DAO5F3P32YJ7I8Cm6vfdYPcVRONg4IA3vPaanAvrtWe1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JmG1Mh5edK/VboGJmP2VEK3IrvSMzqKIwWojDC6+9Wg=;
 b=bShhqz7nLqjMBK7NA04XSkx15M99uoyb7bbLioz4azBNdqNLPYso2Ggm0uY/crCsTvLO88UsQSFtw6c3dbJneavw1ABI235irWW5bWY0xXKFpywoSuRZmDbUzWF0iOC0DSBRYRHsDIiHtEelGCtIwp+ziqVND435h6rw38pe3OtW+sLwYrA5bCDeZ8OhgLxBnmOREKIoKj7FYF/JGuzbj+GebyEidZps0QYO3gJf1KLdy5Gc9yxjUZXVQ2Pq/xWunvgbI7cUHSmQfRNRKowB0B+BpBDOZtfIrXQCndJxV3tpj8CzDZ872TtIy+nD0pp30bKWCvty97+kXDB0S4i+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB4845.namprd11.prod.outlook.com (2603:10b6:a03:2d1::10)
 by DM4PR11MB8178.namprd11.prod.outlook.com (2603:10b6:8:18f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Thu, 3 Jul
 2025 15:30:16 +0000
Received: from SJ0PR11MB4845.namprd11.prod.outlook.com
 ([fe80::8900:d137:e757:ac9f]) by SJ0PR11MB4845.namprd11.prod.outlook.com
 ([fe80::8900:d137:e757:ac9f%6]) with mapi id 15.20.8901.021; Thu, 3 Jul 2025
 15:30:16 +0000
Date: Thu, 3 Jul 2025 18:30:09 +0300
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Ville
 =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>, Jani Nikula
	<jani.nikula@linux.intel.com>, Jani Nikula <jani.nikula@intel.com>, "Joonas
 Lahtinen" <joonas.lahtinen@linux.intel.com>
Subject: Re: [PATCH 6.1 075/132] drm/dp: Change AUX DPCD probe address from
 DPCD_REV to LANE0_1_STATUS
Message-ID: <aGaiASySvb3BVXlM@ideak-desk>
Reply-To: <imre.deak@intel.com>
References: <20250703143939.370927276@linuxfoundation.org>
 <20250703143942.360601573@linuxfoundation.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250703143942.360601573@linuxfoundation.org>
X-ClientProxiedBy: LO4P265CA0231.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::17) To SJ0PR11MB4845.namprd11.prod.outlook.com
 (2603:10b6:a03:2d1::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4845:EE_|DM4PR11MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: 5756988c-fd70-4a02-a3a4-08ddba468297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?GxhoP5mrSZCBxPtTVRF0Cf8j+Y/hWeJIhQ+k/92FK1+UTVumuF2GnkguJB?=
 =?iso-8859-1?Q?155bt4wL3Aa+FLVisbbS44ZeNWwZPPCM8mgzSI1YUrymovAT1ujSm8zOUa?=
 =?iso-8859-1?Q?eeHzNBQVGnNxJl0Vf5NQs7z1TIQSLi++s/MMlAc92Hs+Y264QN2XdnRH+0?=
 =?iso-8859-1?Q?IImD7ss+L+lSOAdTnWodPR4ge07tsYYvGqkPjsFWqydnDEhk+MWn/E8OIY?=
 =?iso-8859-1?Q?+DcbEH2f2mNhBzxJqAag6TFdV2QDeL2rpCHNPIFEzQVExt5So8QDtHV3Jb?=
 =?iso-8859-1?Q?jrScgNaNJWr1xNsnvndpYaF5UG3qKJEFWgsrmLDlgdz81iYhuNwWXzCblI?=
 =?iso-8859-1?Q?hrvlfZHOu8t188VAl6AE7qqbf1X3SOLsln13vqmO8pV5/4pKNFBWeYIArV?=
 =?iso-8859-1?Q?R+LffwB7Cc6Hk8YqnGh+/j/q5Bvw9rVEaZcVlQUMZFyNUzelKxRwl9JphN?=
 =?iso-8859-1?Q?4a34W058wQh+C5BxMsbQOIuUR5NF/NRZykC8IMwqsMOhIeOYnhDYWXMCR7?=
 =?iso-8859-1?Q?GLWdTJwulRPZafA5IvCE5aNPVQ7bTd+HoJD+XkhhcG/9grPQdpeiruLFDO?=
 =?iso-8859-1?Q?nuU6Gm7gwDDJuoMBdGIDYyIWwaX3ODoqU8WO3eRKqvLITQURo0F3nByBE/?=
 =?iso-8859-1?Q?qboMFvK5SlHbTkzhWc628fY9n9t1VYxcglyh2ddnA029rejf7eg4mzMA1i?=
 =?iso-8859-1?Q?Q3U1XqraYP09QJ2WJP/AFvaVTIuYHUhDqurMsXviiPq9sCTh1lggVT/5fb?=
 =?iso-8859-1?Q?GO5VSvYPI5HjJj6iR98YMMzHxcJLSrnNGDwE6Y/8UlmVCVyWMCAI0SwaRT?=
 =?iso-8859-1?Q?EXk31LYqxsd/CrYOXnJ/47EwlwE2IAnder8d/cWPVthZhcYyLuJaihw097?=
 =?iso-8859-1?Q?v6LppQhft9nFmIWFqgR3W2ZNdXM4CkeQ59aZnBXErYu4eF4ZqqGEL1w1Q/?=
 =?iso-8859-1?Q?f+2044+WWXQfc/SbLnpldS1h66jxuouh4uvAGE8eD+ZL4LtN6dVHnrh9wF?=
 =?iso-8859-1?Q?XPpEqo861YoG1Nnhk/y0HwmuBDT5LIrcXUn/w7ezjbcpk5xsHdhORSUfRF?=
 =?iso-8859-1?Q?u8qDs7ohfgXSc3ECKJBoPYcuPhen7GpcIPVsNa0+bCNQCCob/4xmmIyfS4?=
 =?iso-8859-1?Q?GSD6pOaiV20MWJyTEC5Yt7DrEnECYjPQQcJuiyhArKMhHWiByfLGUuaLnj?=
 =?iso-8859-1?Q?3uy82VLmlU7W11+3WnrVizkE1Icx6in7y0tcs9e/1BUvriBkfSSYz4IkBY?=
 =?iso-8859-1?Q?lh55TrKM5DJjsWsYBR28imIrXrV4YyUH/G0ILq1BTvJ4PFBHCYCXArE3c/?=
 =?iso-8859-1?Q?2LcYtdfQhWoDfZutwfHWi9zJC71vQHiS0iRzk7moNYidrw+Aw/lqVwmefG?=
 =?iso-8859-1?Q?oPjdIQycKpnm3ZalKjVWY2ZYE019GIx01/NNJ/a2e3dREfLqtJE0c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4845.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?7sNowX+5kHsZ+n40yL5HK/E/dhcTSehl4JZTj4NTvgZ0n3iE6U2xWm8ohT?=
 =?iso-8859-1?Q?uE/uzQeRKr4YfRutGqkd1ckqwlntJlNDpK7w7bN20kmu9RDGr1/OIQnkNq?=
 =?iso-8859-1?Q?3uIeNcn7mfb6lCpNXtVviGqR0nEvZJsu6fY1ADk3zhv96P1/xpOW27PDdP?=
 =?iso-8859-1?Q?1Zxovok5JRBAZUtZ2COsTIVHrUxSZmosrfFPQGwx4YEE70S4hZe1vShl9B?=
 =?iso-8859-1?Q?jvfmRaVdxEnddQoD/6qFGX+csu+4G+D3BZIw62Kzr/SDcFQRSVsKTr/W2Z?=
 =?iso-8859-1?Q?90IYf8hb3WjhvVJCcY7yNHD2/fGX27co2XxhD+sCSj/cxbpGZJ4qGmQZ6t?=
 =?iso-8859-1?Q?sK4BkpTiHCyj4uMct1E4zE0sH79U9iwzx1H0WECSITyJRe4qh+CwK9H2IU?=
 =?iso-8859-1?Q?raOocy7JdYWmyHsjImjkd2fJIduCiGItbB8rZHnbPc4hi7lVTMi4owUN7U?=
 =?iso-8859-1?Q?wH2ocmnMre+DuyRtQtNUBkKxsbTvIihTDZyxsW+iStC75EW9b6BdpO/MQt?=
 =?iso-8859-1?Q?iBJW1YATEE7F3nPBedA0g8bfT11tcMHSE+KFGrXXVKnJctsuDO2O54NHAu?=
 =?iso-8859-1?Q?gjdCzG9JvYGUo0cj4zna7I2RuedCrcU4Vf/JaT/WGBR5CdCiX/6n+OVe8s?=
 =?iso-8859-1?Q?wsLz080cKrlcIzr0NNQHLtn0hwg+43Vw0ngKrHeo4HX2rW5MBD6o7WWron?=
 =?iso-8859-1?Q?dxihfUaa6szjopf4HRGV4vFXjfAb1C9RS1XsLUIhmVhnQxRvVrSLgORtJo?=
 =?iso-8859-1?Q?E1I5SSbL6GfTTW6bMU5mHCO5daP1RTSnrgeVQsQx9wi1iQgK4p4nxtQ0Gv?=
 =?iso-8859-1?Q?yuvgnmXVWuwX0JQCrH7IhSIGLM1q3/Hr/tOF/kUd5VADLJXWH7BvmeGr7U?=
 =?iso-8859-1?Q?KxBwDS9EcBxV+GqRNshRdffe3V8GS4dp4f184lyawE4JBBfTP+Ell7V06O?=
 =?iso-8859-1?Q?kG+HR98uwCB8AazwJmBt3QoAsnPCv6zxqj0DDwoWwSmGCdkaenjhCTLNSg?=
 =?iso-8859-1?Q?eqYEap3gxPJIcPGF2NBXrVCodZE3fL//fGp9ba/PX9Vk7MJ+xVyLt6Fnob?=
 =?iso-8859-1?Q?dm0pD3Wvz8i/b/ROBFdSNY5tySwx+z4QI+brQm8xA4GMh8X2g/UlbRkeWK?=
 =?iso-8859-1?Q?4ipu9uEFaEVVOGRhTVBTjYnBc3D+E+7ACerJjkCgaMFIqFLPWvGeQX+NKC?=
 =?iso-8859-1?Q?bE52NGCkVskdJI25krHmcxpXtknho3qozYRvozDfAIM3fXAAb/UECZ/yrh?=
 =?iso-8859-1?Q?N4ZdKZYgDXjcU32VJsGK2+MAQ8cCpHXWnlevwT46P3lClVH6r88r0oA0m7?=
 =?iso-8859-1?Q?tNz9+IyrUYhfbOnIVQfsvaJRHjm+uRqElq7eciEQcpLrZg8i7BWanEuNoF?=
 =?iso-8859-1?Q?cerolenPjAh+LlvNdC1DrAnf6yW2pkTnzQFlwJbXPGhV+GMRN3HMYq021W?=
 =?iso-8859-1?Q?cMaajzJOzTuxWc2t3OD7cXBgSxgpV8x8mo3N0ovBno87btGq7Cf1vY9CIn?=
 =?iso-8859-1?Q?xp7EmBty6IZCiKPrPvubkbL2US78qQOOu0ZflRPF3Bv5jgmy4VfpkQpN7k?=
 =?iso-8859-1?Q?8j9CHor5ZDqdR992cEfMwHtC4qFGq4pmWu3dv2r5+ehDCo79h6wlnMUe/4?=
 =?iso-8859-1?Q?1Or3QybsFJrwkuXS6R3MYYAov3BjBpqxqi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5756988c-fd70-4a02-a3a4-08ddba468297
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4845.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 15:30:16.1467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZ7XxiYnM8ncsHzLocO1ETEkazqZ7GRkH7sn+dxRPiVLSH/hAigEAGNzb+3km+mzfrRAP7FF0Sus5HiYxgIU1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8178
X-OriginatorOrg: intel.com

Hi Greg and stable team,

please drop this patch from all stable trees, since it results in screen
flicker for one user at least, see:
https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14558

The original issue the patch fixed needs a different solution, taking
into account the panel in issues/14558 as well, I'll follow up with any
such fix instead of this one later.

So far I got a notification that the patch got queued for the 6.1, 6.6,
6.12, 6.15 stable trees, it should be removed from all.

Sorry for the trouble this caused.

Thanks,
Imre

On Thu, Jul 03, 2025 at 04:42:44PM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Imre Deak <imre.deak@intel.com>
> 
> commit a3ef3c2da675a8a564c8bea1a511cdd0a2a9aa49 upstream.
> 
> Reading DPCD registers has side-effects in general. In particular
> accessing registers outside of the link training register range
> (0x102-0x106, 0x202-0x207, 0x200c-0x200f, 0x2216) is explicitly
> forbidden by the DP v2.1 Standard, see
> 
> 3.6.5.1 DPTX AUX Transaction Handling Mandates
> 3.6.7.4 128b/132b DP Link Layer LTTPR Link Training Mandates
> 
> Based on my tests, accessing the DPCD_REV register during the link
> training of an UHBR TBT DP tunnel sink leads to link training failures.
> 
> Solve the above by using the DP_LANE0_1_STATUS (0x202) register for the
> DPCD register access quirk.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Acked-by: Jani Nikula <jani.nikula@intel.com>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> Link: https://lore.kernel.org/r/20250605082850.65136-2-imre.deak@intel.com
> (cherry picked from commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f)
> Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/display/drm_dp_helper.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/gpu/drm/display/drm_dp_helper.c
> +++ b/drivers/gpu/drm/display/drm_dp_helper.c
> @@ -663,7 +663,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
>  	 * monitor doesn't power down exactly after the throw away read.
>  	 */
>  	if (!aux->is_remote) {
> -		ret = drm_dp_dpcd_probe(aux, DP_DPCD_REV);
> +		ret = drm_dp_dpcd_probe(aux, DP_LANE0_1_STATUS);
>  		if (ret < 0)
>  			return ret;
>  	}
> 
> 
