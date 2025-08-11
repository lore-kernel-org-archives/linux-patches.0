Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89357235047;
	Mon, 11 Aug 2025 14:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754922202; cv=fail; b=ouhG/uWifitV8qanIITxo526QVtRp9UUGAlaNTxlPRPRNgo1j7OYa5Tvxitw3l/kl1mRaDmxAok9SPNZd7KCP3zoUajQCj6GewkT9a4a7UhU5W3oNK3zpDNOtpvyiZ9rBHuEwiy4GCZMqD2nzuhjeQn5094x47xHCril15PaiME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754922202; c=relaxed/simple;
	bh=Kjk5nR5cpNnPWO2Lfv8fm/3Jb2vfy91I25FLFqLv2xE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OszjRAoP75QZOYV+QvMHq+FMSJ0r3qlxewVhYilW5xPlWRM9r/t4xc7z+UbRGQxqoWVAfKutAFc0PnrSdW+GeaK3f1FrHli+j/jtt6fk5wQIyb2s2LezTtXR0ihUDefpBvRqAZCW2qwharn8U+7keq6DHYlESN4bfyn3mJi/1yI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1qrmXIv; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1qrmXIv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754922201; x=1786458201;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kjk5nR5cpNnPWO2Lfv8fm/3Jb2vfy91I25FLFqLv2xE=;
  b=h1qrmXIv5GAWhQ5cFS/uPbyzfRRFD6+7s0O54LFy2UDi9a4jUhu3vbAA
   9WQPIouoei4K/aPvAsdIsxmS78SxfiIA+PgAR6/Yck4XrCcgyvPlly+lg
   4MX41r/MoTqbaXIXR0/x1xEi7Mvk2JEJEr8OV8NjJH8U948VuM9q5oXeR
   9//hxYki72y4rBKeZ6e4NvC1E8Mj7i9aASBYToajOMau1qyIkPTAEYIMB
   EZCXvdpkWUdZjkMt4RFRDPi7tpo4egUmU+EWK93lzQ+MNQnTIizwDKOFI
   NjWogl2j8LJtv5pzmsIuLyU71ytH0tlv1olmTE+G1dn/WZs07B1+Ox5AK
   w==;
X-CSE-ConnectionGUID: L88R4ConSMOUaz1PDLhMuw==
X-CSE-MsgGUID: iC/2TmezQL2sI+8nbjRtuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="82616621"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="82616621"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 07:23:20 -0700
X-CSE-ConnectionGUID: y9HIteB/Q9qFQtgQ4jSpfQ==
X-CSE-MsgGUID: L/z6gsN7R/K8D1emCwaeLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="166724998"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 07:23:19 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 07:23:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 07:23:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.82)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 11 Aug 2025 07:23:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KdMQVNT3VY6tGn0fTOmbzacUMPHywkVLA0VgkKpcGJmJxAptXqbyVk+J9LO2oEruCT987HGppmbdStOmZi8ktZJgxDG9W+XSlgDnjWi/OyDL8/IiwKFkgoN2/AqBuHD+cK4FOyTCb9kwPuzID8ho1vuljJiYIH0WF5gFApASgNFHiwNN6rOg4ADBfxUoYFWB/chzlOctPZ6qhRTRDw/QZePAEkh9k/7mmUeUuDmTLPKeW33OjiXVoM8pChrmOKfZC9jxWGLsENAKEeQKM/SjpUFVfyajT6c9l6xRz5qXZcBnApm09ObiPl4uOuLimhEKowe2UzYJQ/GhsGzdyKIx7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjPAyTeoJnMMVTC0hmNvb1hOtXpMtAT4quo5XCwfhok=;
 b=QD/I8Md82GOBVMk4Eo9MOJsrmbEhjRvLiXbFMdnt3G7QoHdAsm+Kzi8b3aIxWqulbEKkIubcJNyN1K/Go6Oc8GryHHYRoebAbd1oppMOGipxFAEDjrw5uV51FIjr85CJALOcSkgmv6yJ7s1H28DJuu24yMLcBT5FLhzbpR5T/gwvTGQZfrCTKPonl/UFh0PvxXawKQXKJBU9b8CepJdDLaTgpH06z50hovAJ/H2Tiya/btl26i9+ViicG3RWJYG7PB8ZZo8TlJyqIVKUiL6pB5G3WYNeCjXnKd3aPNMlyUr6ebn/l/NXrhIZ4owvx7LEU/+Z3bNZvSzgflSZaI8UMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by PH8PR11MB6901.namprd11.prod.outlook.com (2603:10b6:510:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 11 Aug
 2025 14:23:17 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::4b3b:9dbe:f68c:d808]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::4b3b:9dbe:f68c:d808%6]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 14:23:16 +0000
Message-ID: <a9c64598-41e9-4ec8-8ec1-add5a5f903b4@intel.com>
Date: Mon, 11 Aug 2025 16:21:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hardening: Require clang 20.1.0 for __counted_by
To: Nathan Chancellor <nathan@kernel.org>
CC: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva"
	<gustavoars@kernel.org>, Bill Wendling <morbo@google.com>, Justin Stitt
	<justinstitt@google.com>, <linux-hardening@vger.kernel.org>,
	<llvm@lists.linux.dev>, <patches@lists.linux.dev>
References: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
Content-Language: en-US
In-Reply-To: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0177.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::26) To DS0PR11MB8718.namprd11.prod.outlook.com
 (2603:10b6:8:1b9::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|PH8PR11MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ce3b35b-3a8d-4e22-9c22-08ddd8e29cc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aU5KdGxoSHFtU0pBUFdJYmhJcFp5cUhCcVcvdXVSb2toZjRyQ2NlSnFpUkh0?=
 =?utf-8?B?cmRrSjRVNDFLd0RWTENUYm1xeFA0a3lvaGxZdkY0Y1luZmFNZC9OMVFIS0NG?=
 =?utf-8?B?VVFETWVVaW1VWTFsdUVVOE03RzFrZFZNWDMxdVVHMkxZd3FWRnJ2Zm1qRjZI?=
 =?utf-8?B?aHNLejBvOXg4dXczZ1c2U2dSekpxNFdwTjg1ZXlKRExnb3YwWUNWSUhGdXln?=
 =?utf-8?B?SDZ2T3h1T0MzTVpMUkdNdmJRUWoxMjduczdxVEQzWXJJTHNEZnpoODYycFUw?=
 =?utf-8?B?ZStwWEorY05oN05wd0g0WDF0Vm9ubjFoWlNJMFl6NjZBZFYvZzJNa1V6ODht?=
 =?utf-8?B?aGs1emUzVkdQemZodHpSWTlSbUNHNjQzbFQ1VkdybVZBdVBaZTRnTFdNUVVC?=
 =?utf-8?B?M0pDay9SSEF6MmNmbFNubDJFLzd1WEMreWdoODk4dEp1cFB0akJRZjhFck5B?=
 =?utf-8?B?SERJaDc4L0tXVFNPQlpTRlRsTTUyczhncVlFL0h1bUlxQTFOakYyZDhRbm14?=
 =?utf-8?B?MzhLbC96YWwrNUltdG5NQ3lvRnp0UitTMytQN3ZZNXdtY2RTMVZkcnRPSHhH?=
 =?utf-8?B?czA4UGtrN1dreGY0VGpFbjhrZUR3UWFRdkRTK1VJd21ncVlTTW1FbXRLN2xI?=
 =?utf-8?B?VWRsOWpCT05IbVlHR2p3eWN4Mmc5bnF6TDhONGdVSWY0MHRHWm1hNDRpV3A2?=
 =?utf-8?B?Qkcwdjd1QzZ0d3RrU0Izb1o2bFp6MWhvb21IWFl6MjVXNmZ3eENsVWpWZlk1?=
 =?utf-8?B?c0Fpa0RlM3NwNHdxQ2dLeVJtWkJtcWg0a2pPVDhIODZHdnAvajZzWGZqVGNL?=
 =?utf-8?B?OWwrSDZHc0dYU1hnQjJZRXNHSUkwTmJ5WXNuSHhxNXpIczVabTk3Zy84Tnk0?=
 =?utf-8?B?aTU3c0sxbytmOFpqN0UrbjduZURMZnB2dDBYSnNBZCtUNXhmYUNwc0k0UHVD?=
 =?utf-8?B?Z3hXbmxPWXhTeHVpUHdkMTIzM1Q3RjE4bGt1WS9HUm5aTHFaRWFPVHBQR0xN?=
 =?utf-8?B?MW1qcmhEM3VoOXFzTUNJRkpnZUNIaU55QzQzeHJ1cjZ4TFBOUlJZaXhoeUxB?=
 =?utf-8?B?REdOODZpVWEvVHlKVitvdHlwWkhRb1ZzQjdSZXZYWE1LYUNCR2xVclNKb05l?=
 =?utf-8?B?YlRodHE0SVBqN3hPVm1BQlZlRnFEbWNMRWQxbUZFWnd0U2JMSElwc1hNZnAx?=
 =?utf-8?B?MnBPU1IzWlZ0V2xhem1IWUtjZHhKcEVPV213M1BnTXNEbjgxaUU1WUJPQUVv?=
 =?utf-8?B?QStYMk5ydGxjRFoxUi91VitIZklZcWN4THROcFdYcGtRZ21PMkpiMjlUV3Zq?=
 =?utf-8?B?VjFSdlpvZXNNV0ZLd0s0K0YxMVFvNUxLRGJwd2w5NE5KWUNwSFllYnI2SWsy?=
 =?utf-8?B?SkJGdThnNTdRSWdxd05uazRMUXBPRW96MkJ6VW1hZnJQSVBrd2FybGRwNGdz?=
 =?utf-8?B?VllMN0ZVK3ladU53VWFxT2k3dHNDMTcxWTVzWUxtYzJ2d2o1Vm5vWUVLY1Br?=
 =?utf-8?B?aWMzL000ZFdFVENCYnc1YzdBU2QyWjBraEJxRXk3dnZ0QkMxam9QaWtUcXJ0?=
 =?utf-8?B?L2dVaEhNKzhrSWVPTkxiTEdpS1VlL3crSnphbytGZ3NPa3orV2tFbE1TR1Zl?=
 =?utf-8?B?MEtIUUxKcnM4akxTRWFhL2xsLzBlbnpyYUhOcUZFd0pCRnpDRHZhRUNnd3Nw?=
 =?utf-8?B?VGtCYjRNNGUwd29NMTVGTUpnZFZyanlDN1NHMHlRYkdnc2czZkx5Rjg1Rk5n?=
 =?utf-8?B?aWxGTXFPTW9qVGFsYU4wcktvRDRZelZIaWFZK05DbWFTR0VyTXFOWnJPbG5z?=
 =?utf-8?B?SUJYcjFvSTROYjFNK3BqT2xzR3pZWmN4UzJ2SmUxMnBKUGNjUHJsWkl5S1ZK?=
 =?utf-8?B?R0krb0VRSEFmLzRTT25Rc0dDaFZhSzFJdXZ0bEhzcWUzbURpeDJ0a01PK3Nl?=
 =?utf-8?Q?yEZBizWr2KI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHg1c0FIZEZ5YS9aVTg4ak5Xd1NDNHpCcldRaEdGNGY0VU4yTEFQbVhXSVZY?=
 =?utf-8?B?M3Y0WWlWRFFHWTRxYndOOEcrMjlnZzNOT0FiMyt4Y2JIVis0WVc0MSsrNEZH?=
 =?utf-8?B?TFdYR00xWndsd0w5Q25JenhjUForcW96NEZRc0JnWnB4UDJ3ZkFEUUZYWHdT?=
 =?utf-8?B?QjBTTmQra1pLTnc5cS8rS3lkMmpTSXd0VCtTYkMvUFJJNStVZ2FZYms3NElW?=
 =?utf-8?B?ajBxdGZuMHZFTmpWTysyOWlYSWdQbmRML3VjcC9yVnJlRW0zNjhtVkFKQUds?=
 =?utf-8?B?ZlNlb2piZkhWbURGK3VBa3crVGFLSjNkZEJEc0tTY0V3Q1NvN2k4TDdBcHIy?=
 =?utf-8?B?NnNMT09EZkl5azBGeHd0RnVYVjdHMkRTenV4N0l1SmNHNkJtNlFaNVQzaGV0?=
 =?utf-8?B?M1BRdHkveFZzQk1qNUpCeXE3VlpzRUl0ZUNyNU5sT1RBK0ZTWEZ1bm51Tnpw?=
 =?utf-8?B?b3JuMmQvYjVOSjM3eWs4K0I3eGdiTWRqWUlMS2k1TkhaTEJKaTdMUnBpdEo5?=
 =?utf-8?B?YlZ6a3Q1WXExRHU5NnVkajBsM3hwU1JkL3RNTzBRb0IvZ2E4MHRPaTNXamkz?=
 =?utf-8?B?UWpnRjBySHdpWG1aQk1wTlhNNGZuRExqT1dKQWZmUmtvckJFSjEza3pQNGIv?=
 =?utf-8?B?UWp3enBFZ3N6ZXFhY3pWeExBUmZOSHNIcmZxMkhFdndoYVVJdzdGSHhnN1Fi?=
 =?utf-8?B?bXZhNFBCWXl5Z1QvVnNLdkVRYkhkYkZCYloyZlJ4anZmdVRVN2RVUWwzR3dt?=
 =?utf-8?B?TXJLSWh3NDU3ZWs5SG9aTWZSSkw4WldHOVMzaDZXbkRZdXdKQVNNRkhteFVJ?=
 =?utf-8?B?NFp3ZTk4OWlST0JKMW1mQUUvK3ZqbUFIOVhnMEVjNTdIYnVtNGUzanVuSlZX?=
 =?utf-8?B?L3FjaVZ2Z3pqT2Z0RENlWkdtWnpqakNNNktVZ0JoTm1lc1RZb1d6YnQvNjRn?=
 =?utf-8?B?UGxLSmxwRVNLVnE4YldxTmpTVDcxSlcyOHBvYXAvM3VKWTc0WlprWk1Qdlow?=
 =?utf-8?B?SlB2MFltZFRQcG1ZeWN0eDhHaGJLdjE2MFh5amlSdktaMHNzMDFWSS85Rkp0?=
 =?utf-8?B?YW14czF5SFNkT0cxU2ZLWWw1c0EvdGgvSmNnY3dzT011MjRjZEk3c01NM2hL?=
 =?utf-8?B?dFZ0TGQ2M3hqUVlNcTYyZDRGZ3cwZDd0ZEFWakNkMGJ5RS9PSjdqV1QwTUNv?=
 =?utf-8?B?S09UU0pXU2dXa3VONlNJYUhYUndTM28rZE15QnllRzNmT2dUUWRYTnpPd0Qv?=
 =?utf-8?B?bjZDdk14S21VSCtnNXZ4V0JTSnlSVlJNWktvL0pyQjhiVVRQTi9IdldUcDdO?=
 =?utf-8?B?ak5CU3pIUWh5ZVR1aldQeEhQVUF6aGhqTUdUY0RlekRkbytKdU9LR1pmdkNM?=
 =?utf-8?B?dlB3MnA1RWVmdnNHQ0Vpc2gwN0lPVkhEeXlhYzB2VjRpM3hmSW5wbllvZ2lG?=
 =?utf-8?B?RWFid3AydXpFeWFwZDBBZzZzTzUvZzV0cWJVRzYvUWI2RHNsaU5BY1BsUDlH?=
 =?utf-8?B?ZXpvWXQyalBWaHpPYzFJMk1rVzBzZ2lObEtrZEUrSTZtMXJVS3VVc1hGM2ox?=
 =?utf-8?B?N2N0NzN6cGlCTExLbjJUU0JyVTFHRlYzcnZtY0RVMGNwM1A4OFJRN0ZyTXZl?=
 =?utf-8?B?NmFFRmhUaTZkSmxPbHJIb0FRMXNNZzhPTDZYUTRUc0hNVjRxdW5ldC9Xdkt2?=
 =?utf-8?B?Y01SeGY0TmJRSC9zVkhVbFR1ekRxVDZmSXoveWZGUmw0YThGTlN3SjRrZ1BX?=
 =?utf-8?B?c0dRTHBML2ZqZGhDWUVpN0xObUhKWmFxUUNTV3lENVVVMGM3K2Q1UG1YVmVq?=
 =?utf-8?B?UmxLMGFnekluRnVyMTRVR042d0R2UDN5WEs3M2lWV2hidGNJTGYySnhZc2Js?=
 =?utf-8?B?MlU5STZSQkZhbGZhT3htVFBFRW1zZE0vL2N4SHJIQjE5UFVmZU9MOFdQV2M5?=
 =?utf-8?B?Yk56NkFJZ29kL2Z3Y0dGN08zUzdDNFI1YzJ3STg4L0NpRDgyQ3g4VnBmQzli?=
 =?utf-8?B?SWpiWmVVL0djYWsramFLVmtXSlpZdGJ0V2owU3o0ZTVrQ3c0R21ad2Vrb3Vy?=
 =?utf-8?B?Y3NHaktBLzBrSnQxcldSaHg2eFhua0w1M0R2RERUYzZFd0NKODRrOGlTcEhH?=
 =?utf-8?B?V1pYa0lsb242MWN1clBPc1BFT0hBc2dtWFEyWmpOenRUZFAzSnBBR3FLNVdH?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce3b35b-3a8d-4e22-9c22-08ddd8e29cc0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 14:23:16.6534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXYW30QKSmxSjnjAWT6en6yVfNoSPgdfQLFUjEiOmiBAZ3ERkSRcricFp83/mW0CFvrGf6mPFrUg6d7gfLCQMvg7GUMMc5HwrW695FSgyIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6901
X-OriginatorOrg: intel.com

From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 07 Aug 2025 14:36:28 -0700

> After an innocuous change in -next that modified a structure that
> contains __counted_by, clang-19 start crashing when building certain
> files in drivers/gpu/drm/xe. When assertions are enabled, the more
> descriptive failure is:
> 
>   clang: clang/lib/AST/RecordLayoutBuilder.cpp:3335: const ASTRecordLayout &clang::ASTContext::getASTRecordLayout(const RecordDecl *) const: Assertion `D && "Cannot get layout of forward declarations!"' failed.
> 
> According to a reverse bisect, a tangential change to the LLVM IR
> generation phase of clang during the LLVM 20 development cycle [1]
> resolves this problem. Bump the version of clang that enables
> CONFIG_CC_HAS_COUNTED_BY to 20.1.0 to ensure that this issue cannot be
> hit.

Any chance for this to go to the next 19.x (if it's planned at all)?
I always use the latest HEAD from llvm-project, but 19 is still widely
used across distros etc =\

> 
> Link: https://github.com/llvm/llvm-project/commit/160fb1121cdf703c3ef5e61fb26c5659eb581489 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Should this be marked for stable? If this makes 6.17 final, I think we
> are fine for mainline and newer but I wonder if a patch that adds
> __counted_by to a structure would ever be backported and expose this
> problem there.

Thanks,
Olek
