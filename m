Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E0830594E
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774654972; cv=fail; b=MP2LJrngMq0R7BNMtxnL/49wYNmudqXnV36DdxUNX8gWg1OMEMtRO1hnQdlxiJuFbxyFeTEN8AvV4R8E6gNPK6NRVaM6z8YxJ48zmB5YnvHKel+DAvFSs8+USUzud8lDUnrkiI8g+MpFATUdP4cXtURwKuEd2/zevX7OrTV80LE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774654972; c=relaxed/simple;
	bh=2lgRlkUALe/T3hzki+WJZRwRhCNgIU+bdufPEKhnmus=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YpYLUB1pD+OdSt6FJsH5kWtoOsLPNNLciceWI+6Ci/Vbmgsotaq+5tFa3mw0ogJaIrU9YyiwhI/7zm01MdGk4pcnw7ujuc6YNdKDAZ8W2y6klVok5nN606iw57WK4QUUVCbF9A62oZ88qggS2C/zmFw3DmS1GvswaM12OljdNWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AjuGp/Ln; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AjuGp/Ln"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774654971; x=1806190971;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2lgRlkUALe/T3hzki+WJZRwRhCNgIU+bdufPEKhnmus=;
  b=AjuGp/Ln0bQ82bHYCEEsU4K5DTar8tBRtK0s5VtUH33drnpUSm1tLF6U
   6c4XfXjdhvq/oF6OUBF0EcDbg37iYpDArhS2vJ8+K6LUBn0LO/4NrRPz6
   uomV0RGHDg0iPmpOkyScvg3kuTi3Eo2iJh/mpH7TYO5BRRuN5FatO2CvC
   fPhYqHZ8PEJF/k6odi9dGvTNSmKwQEHF7UWalTnStTs1hoctrmTgamSNW
   x+RKX8MzLud9sSYG9BAgvMMmZGVjUMfR+Decx1hWbSYBAF76IJFExQR5e
   4aW4X1vJCLrKumj/iAB5VkXtcjx4m0oiJ+LCzF/pk+BZwQmO8vIzYFj6E
   g==;
X-CSE-ConnectionGUID: SC7JwEgMQda+W9AbhL6pxQ==
X-CSE-MsgGUID: N1j/BNPoQcyERKjBUFbGtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="86353309"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="86353309"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:42:51 -0700
X-CSE-ConnectionGUID: usXF+fypThuiGTeIu71oCA==
X-CSE-MsgGUID: 3T1tvHTOQsCrLJTJG30DQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="263405066"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:42:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:42:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:42:50 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:42:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKPjBc1d8Ndm+2ntnQ7yzQTJyt5Vb9WeSW86Czl5NR3pfPb3aL3Ee+OV9p+g+1JMI5Hgsu9EuRWchJWe263l2HY5OaJjZUdFyjQCX89hv/LCA1vsWFUjaJz9KGi3FeS9VB+kd0NLHiy7j43tc37lvEpiEFucxdW0YkXLHq02mg2ooOB0cMBSto8SYJN5n61mBrhh9ckWO/IkCPYP4HA1bf4LVF45NN0v0jnfV/h5ZHECwMfw4jhgRlF1M85b0cSyOpDsHdlS2R+zQUsKYyf0HPTJDePPQnObvkj6P2+egEXgYgdOu/Qs8zOIzdrSGE0VM8bx/XPLerbdS78fK//ISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SeventzzJx9JB4my+K4B/raqU6IjkV5urATTIp7dgc=;
 b=RRK9JqEqLtzv7MkDiTeQC26d6vIWJnhLMxnWjdMoacX7ngl8leB+l1gfAAz55h7Tk1F1Ucnnw46dc2DFbmfBWSMWYPjWBzZyKn8iN7wgeOLVOmdCUFyEKRr5bJWW29notBsyPs2WiXrz5TcRyflO3fwzsbpKztEPRLAXRZRLPTtk8pOxNDxYiQN6dsEdlcAGSG30WpA+iW8ZxY86Ip1Mh6UZRZY7bHgHD33p1KmVk61m+pNwv8TDGy3jauafP6lqcHPnWp1wfPpMpnYN0gSPok4k4b5+o5TyIJ3OAPW0M3BRxVH6humb7IOv/nq0GxUQPvb+H+JyHCEcOHy5Tc0XDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:42:43 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:42:43 +0000
Date: Fri, 27 Mar 2026 16:42:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH 0/9] dax/hmem: Add tests for the dax_hmem takeover
 capability
Message-ID: <accV75BCtqJF2dUK@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
X-ClientProxiedBy: BYAPR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::49) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: dafcf1bf-472f-45c5-5de8-08de8c5a8a59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: X39ZEuAUm1LSUZhZsUrdBUQNuVDqkzKzmokRbd0Xoe2VHFcOQp643XdzWkAGOeP3OVv1jvxd2Lrnq2/DtPJ9yH/Ljq6bwkd2scwrTJzNjlnA+sxKKxSBR4mcZxfQIGumOm/1X5Gj0nahum68phicY/PYz/O2ckFF04wj5cLJG90FZ6v3YPaO2olBSdG5LxtVtGDPi2lYcy8UfCv3+hb3wytTIO8pAafsMYvLS0jnzydX47PnLrPnj81wNlhbc4+X6BuCiEQzstghu62erlZKncP8OnIzjJTbUiE8ovHWDUvdu1SVByxPqQIiJA4f/6LUslksHfSMTBRj/HEN+4O663dMJe3FOZg2hA2C6RO8RKTdb+PzhWRdJngjfV4fFhkkajffXwv9n3yJujTciqqiZwmD2cMZqymqZGnFoQyHHij6hl698Kb7nyNailiklKXDbrS0Soe6bRKIjNTFfGU/G2aL1UT6qN9ShL4BLm6CZd6s1KRLrRQJad60EBpEbgW43ctbikvBW/0Z6Cqk1I0vcT5x9tQihCE3mJuoXMiwIMfu+NUfskebrUkQv1NFcUmwImvA3r7Oj3tCupScC3n3or5QwpepiFyloOC/yD2z67AAsCIClcxtELhL2wO8K/pwqtIG8559MFVRetr78mYC3cjc0wvLyRtd3mb5kluKJcpNzA5IXsTgVbE6po3xE5XMH1WLtpX5aYKNaqFTlEayDjY60V282M+xJp646nbnT9Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4VMC9hWflx+sWLHJQdDpxOw5ZsbsGBN2RuyxJp5KSyRCtRzs41EKaY7YjIEF?=
 =?us-ascii?Q?U2igdvoTw0y6K7vQ6/QlcvZHQRBr03JCpEQCLIC4psTUdOxrC2q7XsXkyDEz?=
 =?us-ascii?Q?rzzAunVms+1Y4bI5LPypAlAD+5pS9NRoby5sbQop4q2xJU8ao7EGjxKNWm1f?=
 =?us-ascii?Q?J8B+l3CXWkyprQjCDK2fyMUglH4dyj3tdFSKoYbrH7LPjDnmarbm4dfj7vRY?=
 =?us-ascii?Q?xQU7Xq598ogl8VyxKhFnbEHWJM9mJ/EbOZhj1+nqcpbv16nVIcH+ByIRp78L?=
 =?us-ascii?Q?R3u4aNYz6VkWlEwiQRR+Q7r0WvnLpHoFcO1t4k87RuLGHi2m1OJKJUeZTK3r?=
 =?us-ascii?Q?zi2hqkm0bvr9wX6Jv6wCvvI8ooypH81PiCfY11wv8JpnNAKOVa6bKm45cehO?=
 =?us-ascii?Q?LMP1+3islHayD58JpJqknMOPEkFAtiyGMy++Vq2fMANs7J4z+TuutbozVDA0?=
 =?us-ascii?Q?sV243HZ/bufJYOQTznOLCkDo/6f162rTlnqGhrRZaR+feOJnKbT1dxb+8aTz?=
 =?us-ascii?Q?KolhRHIgbgAjhthLy0Eu9NE5qgJS0ViZ+lonlwvaY3QvZJzgo/MY8qBEQ4A2?=
 =?us-ascii?Q?1hiSWMVntIjgUjwrrFZa9MzqgDZZ7Tovdkz+PgLbxGTz9q1PDdoC5HevQVPX?=
 =?us-ascii?Q?ev+1l0FW0BihogI4FUSB8yywwdDmD3VhbGcLRIOrKr9PvIRpERxFuRiRUz8A?=
 =?us-ascii?Q?OSPuqhfErZlSStb261WLlkEWudQZbhGiRBMfm4isCRs+ICSe2szl4pO1Gv2p?=
 =?us-ascii?Q?9GG6KeyFZ6wGSoom/FTbd8/+t+6KQougwz4CQDmCyb0jF+cWSOS3dfoU9KxQ?=
 =?us-ascii?Q?pHViJisXnmijhkV1kk8snh8+QnoFKgR5nq7jo2JFdKWtR9qqslxPnl92s70H?=
 =?us-ascii?Q?chZlHOUZkjQzutcKInfwjBJ/fjuGIHjoCnQL2uJ+hpBSR1pKqUr0GTzd8Wnv?=
 =?us-ascii?Q?veohm7hV06FVqPN5O9pG2rHCRj63rAXaZwaZoXhTCZkcIjfGbWoSeiKCVWZ0?=
 =?us-ascii?Q?CSXC1H1BIckXXFfanFn/HFpZmhIW8KmUVIQEWO1uz6Kld3ey1VVZq27RtAFQ?=
 =?us-ascii?Q?sBS907uP8GlM1b//QvSJjrYNpnoxf/mfXN8VjeYGltMVUZoOHO06mozF4C2C?=
 =?us-ascii?Q?xO87+harPnqb94WLDUX1D0Kb8i79cboxLuQNZNjOCUMLUR/wO9oq4e3we+RC?=
 =?us-ascii?Q?etQdfjQsOfUCX3D0fTIWreFbnj5geQ9tKklHjON53/oUEa3xMzT7FpRC7XFX?=
 =?us-ascii?Q?GX2mDLNAmI1V+DkjUEm7QxyKfbHTRPpV+mcWBtlqojcmaA74CDGXTx6HzEOR?=
 =?us-ascii?Q?/FpjPjHgiHI+eVRvOwmaJtho3fQAkld58xXncORA0BcPjyyHkoDlN8jAEFYQ?=
 =?us-ascii?Q?nAUZwZC4O7d7vgrgboHSiJ3NwKkwdqOuyGhoc5e8iq2MN2n5RgJZkcBg8wxq?=
 =?us-ascii?Q?C1yqmU8MAvmnQ1VA5mx39I4hk9eH8z8YFLJB5v7nkjgw0Ozvr0V7I+fpF/BJ?=
 =?us-ascii?Q?TWZM6CrIZXUaQOFQVKrtzX7zRV98TY8WR2/rB+VGGlYpPIzgN3SKe9/t2mX7?=
 =?us-ascii?Q?sz8MyqucXwGogClCeHLRKiNq29ZFqLy713n/+b+4/7ayQeln9lRbV0Cttj+d?=
 =?us-ascii?Q?WHUUd/YGvgIAidmIGy+8SsjANLmFUAEPfkprlmo3CYX8kogAl/SgPRYHN+JE?=
 =?us-ascii?Q?Y9agqciLlgwN4TSh3RjIBDvR7ODsQMh63WpHjOWlPqmTFNkKCzOj8DjcMRJx?=
 =?us-ascii?Q?6J/TTCu1UO5BYx6U30vnpgWZqohJens=3D?=
X-Exchange-RoutingPolicyChecked: e9J9YJ0B7xbQevMSd/kMMN9popkiLM0lU3PcBAXNnahv4MAPCl4zxEwGDCzzGPjUcm4GNIhpL6SJtrV+5N93nyoqF3sMvkqOUzWAnBPne6K+piAuhi/Hz+3Vs7/r6TYG506fE2FcvhrB405JWvcfjp1LQVTk2Tib/tURkhWT1t8Nnqof7Pa7vMD0b2VChY9kV96i5wjyTrvDQPPExAB+DfYX8EFBkMMYasRHROpNg/ZFn1gEuJYIm461V0oiaSAv/1r2Z5ECnZY3MuRciiaBlrD7Kt8bav4KvC0k4HizDEMNWRE4wfMhl8iKUoc8ZGY92sCidzhw7Hk93d6wRGTcyg==
X-MS-Exchange-CrossTenant-Network-Message-Id: dafcf1bf-472f-45c5-5de8-08de8c5a8a59
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:42:43.1375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRIS1/UY004egfM4mrSJvv+2ZDLdzNrqYo1922Zmd08Bkzr3JEMhKwDySZQeCUjhq7KGn8aokIAPkzRnO5t0q+9U2yMnnAWkrgzBEXF8ycI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:12PM -0700, Dan Williams wrote:
> Given all the cross subsystem dependencies needed to make this solution
> work, it needs to have a unit test to keep it functional.
> 
> On the path to writing that, several fixes fell out, but not to Smita's
> code, to mine. One use-after-free has been there since the original
> automatic region assembly code.
> 
> Here is a preview of the core of the test I will submit to the cxl-cli project:
> 
> ---
> modprobe cxl_mock_mem && modprobe cxl_test hmem_test=1
> 
> dax=$(find_dax_cxl)
> [[ "$dax" == "" ]] && err $LINENO
> dax=$(find_dax_hmem)
> [[ "$dax" != "" ]] && err $LINENO
> 
> unload
> 
> modprobe cxl_mock_mem && modprobe cxl_test fail_autoassemble hmem_test=1
> 
> dax=$(find_dax_cxl)
> [[ "$dax" != "" ]] && err $LINENO
> dax=$(find_dax_hmem)
> [[ "$dax" == "" ]] && err $LINENO
> 
> unload
> ---

I tested the new cxl-test patches following your commands above, and
all good. I'll ask about the race condition in that specific patch.

Tested this set on my real hardware too, confirmed this with Smita's
still passes my hotplug test cases.

snip

