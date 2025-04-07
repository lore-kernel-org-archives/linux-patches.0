Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20FF19B3EE
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 20:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744057351; cv=fail; b=VOW7B+4tc78kIKKeebmu9+x2LDQwwcKZsBts3mlNl1ITezkQtw3HnWyIj85rtoOBldeCnMunsIjeXQHPQgOWSNDaxrZdvffDLcgQYbNSlnf9iUWHBis2Tn+AoUerZZd/9e+gQftzLlaaj3oEtihvyZtMpjO8c9RNVM1qnD0Phvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744057351; c=relaxed/simple;
	bh=uk52w8IDyoIs4SpJ7onNOcdXq1OT/MJqhp/qFsRdnJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YDBaw8sefqbg2OnImygbfWJHy8J1MYefiYdUUq/G0UC414jml1upf1olhx27/iA8E5Wc3H6PWJKx91E0Inltf4BoF5pXUBtGIKQBedK1HahDxTRxWmwh5tC+pbeVTV9U9cWK6HMDkmjL6KhLsZ9MgiooTt0ulcR4w5sYYyEFEBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IytPlRIb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DViMByoz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IytPlRIb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DViMByoz"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 537H0lHL024602;
	Mon, 7 Apr 2025 20:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=zUzMRfKckwbrwJOuw2
	htdO75ZiYtWtV0XDTDSAmTpbM=; b=IytPlRIbvwV6YxC+/dYgFtBtBP+z9qgvpC
	wz4sJkcJpZKH8cJoZ40CshY4kzEAMAs8lamSrkhjOJoEhK+eYElRwGy8UfBX8Mch
	xjrhXri7+P+24kxMIsKU78XW0uMBQJdZjSHTJogUeIjWgPInXg8sDqr4BRgoSUiv
	a4uSGR2M56IABFu44cIVhJNmVkzqDzo8EAxwtAYQjFFYyuDwfr5jO78es2GPeZhS
	fhWQFMhcqeBxpGFCjOluQTnYsb23PHdoaJmbP9Y+2vHbu8ixdbR1wBhHXYuh2loK
	ULKGvW6S9Z/o+21b0hbhwmhRgzCzgSsYtDyYXTO92Z+ARxSy5ixA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tvd9udet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Apr 2025 20:22:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 537KKjhu016239;
	Mon, 7 Apr 2025 20:22:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45tty8atkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Apr 2025 20:22:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bdmX09+LMNCKm66B5DpZBoxnXaRJUghih9/2HDQfkW7NBDExSChcGjEnq3rQ/YE6KbWTvL2TSEpSVE1Sh4rudks1dibFLs442ju5JMPUvL/LK+6gCNFVFTthDQG+l8ajZysFoEzxlkbN2Duv0mHUG9i6W12xfu2w+PYwMAYZeeOWNYLlJXumAj/tmEkZnXmenIiBcOdiR+GOef04RIVzNvUdLzM4EXSk018cfP7Q5FT1EP8aVuLm/seu7Ae0cqEtwas5+r4SGij+8Z0xXOrMuloU26iBdyP2l8EJcDvaG9cMZLMBpjVypSmhBfKzPyNjQLZD03rQ0Yc4tUpj0W+eKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUzMRfKckwbrwJOuw2htdO75ZiYtWtV0XDTDSAmTpbM=;
 b=HO6kdcUg2V9Jh3l2QyhPfgywFmRQ+YltQyrWidx+3kwNa7ZfCNTUhBawEirlnYHCIgWH1oqGY2WW5qjuPdtDvmP5psczQEeDW5WMf75Ag9iqiC+P3uoCkAv9jpyywMUpeaX1UDk7ZN6SKzkH2E60jgj9zjIWm7wUFko7UGqWIEC84IEj4+0QwQ91ROZ8nowZqzxp7XxOFrUbIhz+rydz5Y/8bB2xTphqkJglJncuhRPCosM5GnKtxcQyb1IHaz5iGA8Uw5ih+GduUSL0rbWpMRR5/6GDdwvIJUtKIvuE/4XtfM7VZkC4LTJOKJbq2UXkum6Xw+KVdfUst2U2CCxswQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUzMRfKckwbrwJOuw2htdO75ZiYtWtV0XDTDSAmTpbM=;
 b=DViMByozbkY7efYtLZN7HOgQ96OZMzHjCtVXFxdDPqfG20Y1ZVEza8rvwjJ2vzXrOB7/TGX9fvVaAOVzw2AQLrluGb4J2Lx03AjkBHX11dj91GYnZkoScf+6yuO5NIU+0JknuP41jOslkrba8euKLAHAtCoQLoGqywT++lBZb+4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BL3PR10MB6211.namprd10.prod.outlook.com (2603:10b6:208:3bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Mon, 7 Apr
 2025 20:22:06 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8606.029; Mon, 7 Apr 2025
 20:22:06 +0000
Date: Tue, 8 Apr 2025 05:21:59 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 1/2] MAINTAINERS: update SLAB ALLOCATOR maintainers
Message-ID: <Z_Qz55SbnHK9LoW1@harry>
References: <20250407200508.121357-3-vbabka@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407200508.121357-3-vbabka@suse.cz>
X-ClientProxiedBy: SE2P216CA0179.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ca::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BL3PR10MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: 61e5bc7d-8294-4efc-cee3-08dd7611dd62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sBIud73SvdOerPWn9miZLJ8dJIXOiJdswL6xzQkyIngcaoMXwpl7iNGSVn5O?=
 =?us-ascii?Q?ORi9g5GxdUb123/NW10U91Y/FgOZ2iZKaSmBcqQv/RKax7Y9zSH38xPNEhTX?=
 =?us-ascii?Q?2JFSMnt29ky6iXskqS+B0kBLsFIxW5EYUyRgWO4VaB9M5BSO8uO+Jn+7Bs6k?=
 =?us-ascii?Q?7JlTOK8C6zILAgPHhB2OFBy268jnOQnlwpmWLh3rXQ09Tpt8qSY5Li00zAkk?=
 =?us-ascii?Q?mILNNuN/pmglTcumO1b0h3nJjazo/ccIf0fcgquhQqQuBPs+zyXU9+x1zMgA?=
 =?us-ascii?Q?t2/cdh9KRIyMok30hcwjLHs/MvcNahtBjavznv0Q38xXZzPS5TddbVRXcScr?=
 =?us-ascii?Q?hsRN/ZpS26ZN4R7Ih/Prs52IRm+vyrGPjWM9kZkTqrcZpX5mLN3uROkSKuYq?=
 =?us-ascii?Q?+wdz1ZcmHSkCE5eDHRYSm7x9g9GUy2L88IMRi3yNyVrIuU01ET8EfsyYIZid?=
 =?us-ascii?Q?Ja4jF31hUf3QWpl5wQPbYtg250o5Cjh4nvuaFxvXmrgM3rrrou2w7GhaIqtr?=
 =?us-ascii?Q?bngPQbOiaP7rbbioScIEsUWjJEv64zaARqVAjpL40qWsI2AZxy5Qe8tM/JTr?=
 =?us-ascii?Q?W1OKQGQKn3LwL8eLI5pj6WYY64CyD06SIk8/2uFP85dewvzfEOYkHuRmnbcS?=
 =?us-ascii?Q?+SovV7MTV4vN19DxVU613Qrd1EQCxGLhJ9cByD6jEO323FAGTWxAro5whcyF?=
 =?us-ascii?Q?+msSJECnvBEhjn6b23UQRI4NfA5wM15vLAOfSD9yhbOPFouIF5A4V82V6jKm?=
 =?us-ascii?Q?eOldQ19XvNx+odLQdxRZVBDX7dvzObsf0ML63Ht0eH7zPnU0pzCcWC8tCEyp?=
 =?us-ascii?Q?yClUN01P/odRtYjDU7Za7ukTKnEP5FXK0gCN1M29GC79ntbEC3JEt0I2pNQV?=
 =?us-ascii?Q?NQs9GX36IPEFy47YCorE+B2V1eSf7beyosINyxk6tXS3fVFRuwC4KShFT9YB?=
 =?us-ascii?Q?SR4cPsREfbEing38WQU/pYVqTMy73wfFNwoiizdPET/16YuMwMc4vGESnUpc?=
 =?us-ascii?Q?NYekJXZLEqOZ+R7/ndwofe8UeMjQzhSHQyWPtURcIAuwDvdkAktm8/eV4bOu?=
 =?us-ascii?Q?d26z/Ki4newPraVeJ5SsoT+uyTGDtDJdGQMUbZF85ohdirN9O/BQxkOaQ+Aw?=
 =?us-ascii?Q?bm4LrllcP3PrtCAzUaExt8LQrh3PBJ3z6MVo3oBmyx1MxKlCTSMfI8H9eLdp?=
 =?us-ascii?Q?ojLOKbuCYTUvy3Q/hcQTqVgo3ItS/21iUcKti8un7HvI0h9ImZmVxPuuH5SL?=
 =?us-ascii?Q?7hPbe6Ybh/iLWONDppehLqPkh2psq7aLmkOL1JOVA3ZcxddBdNcthunMP1xX?=
 =?us-ascii?Q?qWfXtntzL2QOPegM3jXr9q3qGn9Yi5RnlybjkiXfOBGzKfaaqfMAd/ZxNcfD?=
 =?us-ascii?Q?bmXe0aGdWi1ibXLxONZxp6S/sjae?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oQjkRG9XgRg/dBIA4koIq/U70piwFRDRyVLSUCZAJZn2Z3hfn4cb1bBk8EIg?=
 =?us-ascii?Q?HPuQH1idbyjVLlZOsMwWCt1W28nWN+fmwsqW8Q6Xkkjy7v7WTQWYpbMXlhib?=
 =?us-ascii?Q?7d/H0WLIWncUOUfk7uWbfTTJ4/TKCEDAHT1dXc+BGj1D+lvI+zg/kQr2M+ef?=
 =?us-ascii?Q?Fk5BEAl6eIVxwIyDN6xztnDhICN5dpLkpTH4TLRCiWXIevXG8VcJ36dNOW01?=
 =?us-ascii?Q?+qQxze010KFTxw6abU1mwjo7caGb4321wSQ3BXk+6O+azrer54GmGxkzRo27?=
 =?us-ascii?Q?tJzAnlwiTSb/Lba4PL2yDiBmuuBP92DbHbzyqY+yAeAnXq01cSYzLFCLSLS3?=
 =?us-ascii?Q?aXNs+g3Xgz+BjeMrFiohEhNsUqiSgW+GtCFLAblOfsG315NR3JhRVqVbjCbv?=
 =?us-ascii?Q?ruMuvmZKrugMze737l/OB9m/t1P5Y+zwFtFMLaKryeXENc1ZNNydUidJ2nFB?=
 =?us-ascii?Q?EfbV2EStc/0R0qV69d15tRJSmHxLawK5Y4LuEgHYHCiaasY/lkchHF7/dTO7?=
 =?us-ascii?Q?2EBlpgu4v6ktq84h4RzAtrMMoefKy/WsLL11UquXQCob7e8KuchznN9oXtLd?=
 =?us-ascii?Q?7PgA3QR/cIFiEgJooH2vyMgfjfmbGLZzTIPnmBZXtewTC12OAHcVIlX0GoAG?=
 =?us-ascii?Q?3xJ2THnGEXgRSI3/915mpL3eo+CkiMZt65hEzUvWuG6Js8rXoZnruGKIQwIW?=
 =?us-ascii?Q?ruhpEnxoFSbHe3ersZZ3u3hx6m1HQFHm5DWd/mVWCgPiN8+qRf9ygPC/owzR?=
 =?us-ascii?Q?CsdvdDbRfLyeSMWm5O2H4vYmPzSyVUtRCF2+KgISVKXx+SgUOd92h5YWX2d5?=
 =?us-ascii?Q?U2Y/wzlBfGo4MZ4hlruYuDR5vz90MfvazvK8S6FxOg8oKRor7RbABdD+32JY?=
 =?us-ascii?Q?ZlVhVMjbtLVs1kHQ8+/yKJ3f700DN7H3qF3vKY1gWKYmV9rYZsW91qtWY8BA?=
 =?us-ascii?Q?p5rkgJZKSxbamRM9vrp8Tljdj7x5CBPQINM7oK6h7dIn6SOoq0W4gxk+MaXe?=
 =?us-ascii?Q?mgc5gIMOc8OHWhrsAp9Hs2Htc1xUU6myOc80JXdaKTcxxW4+fS2d31aH4sDC?=
 =?us-ascii?Q?yQxIU8l8NOTfuEquNYPyp1ssDmKOHvJZeEnqIuZMWdIlKdSiOGxh6RJPeFd/?=
 =?us-ascii?Q?031ujbPCpoxdvRAfjqL10fra+LSGWYgtWgANS9NRqTrkjAZGcSeExddRa3GW?=
 =?us-ascii?Q?TUIxAqR4Z/LxClpPQ5+aksnpfkcKOvuaMA2fPDQcnhxQLHYLft0oQGrx9rM7?=
 =?us-ascii?Q?t3Bv1StLIuq1thqhICNmhXeD1AQ0ocNJmroqOkC9194O/y6KeofnhGrZQ6dP?=
 =?us-ascii?Q?THvfUP0po0SEdqUdJ6SQ94Xi+B3KaP4IsXS6jwHKAwNM0DRnXvDlf15oa6+k?=
 =?us-ascii?Q?KxshvvPoDliNMrIZY8BXpH5EyRjM8SAs5O/FXpmHda7wsb0J7PcKucajjkSx?=
 =?us-ascii?Q?l/JMXZE5FhKw5tGboNLPZM586mGw4aRsEHvT9wQRwtVY64OdIx3vKhyMLfnV?=
 =?us-ascii?Q?7Y7pWu7PQYjX4yYx9C/SZ4/Rvbs5DY6+7weEI3l7aBbCzpnH+TfC9s84SjlI?=
 =?us-ascii?Q?27j42R+osVrTMhRQ3tH+2z8biswvTw3lx4IBIeTG?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qgL9imLLZ/uTWypAfH2PG/l4TtEaE+lhRq+vYHnMqoQefZLKBGaBjNe/6r9SpnvbPidrMmc5hTFNXVfPv5EPKNBPIjDA8lx2EQVrHODyT0o9frc6hh452gYwM75R1uwxTk1rRy05xJ6zPi6Mv0FQHLNs4cjRr9+Tq5IT/ulgkkuOIN7/YdavBP0kdqJysi8ylteoUtrlsWWON7dEBEwY6W6/dq3Fxo1ONkcnK5rbZ7sVulrS54qrmIednrNY+1pfscEQt+zcerT5wqHtW4iKWW+FfoLfjrEucqSYq8z7ly/bPx5EfljQGKEvR5qgP6+vYh5/5qiw3ov/tJAzLdun1gjb2k3/reqguGqOKwUawgQJi9GZfYCTmpsz++g1rdL4geJYRyZ22LXtk9DGps3SzTXL4uWvq9bfdeWjKeG0SC+mkcmycj6c5K0MxA5UeeUcu/8mTnhs3Pu1TRmS+Dmljr4Va42nmdmX0IKlPuThrN54Yf/axSd9ts6trllckV+V6OreX8F1UH7wQEYF2VncbnvWahj3RklS9DHo3NXQ/bAwgSgjqvm0tXsB/qqunsRxgny7Sq+nEAA1IDRQCfEKGsieGbUICjVgZf9gyKdoI08=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e5bc7d-8294-4efc-cee3-08dd7611dd62
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 20:22:06.0348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPIQoYFsXPMJ7AunOK/GH32FwxXJaF37HF1aM2FVQYoWOofL27I9GeQVt+alkSeKgmFnkOe+r5H0pnyPJcyI8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_05,2025-04-07_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504070142
X-Proofpoint-ORIG-GUID: Yqv6xFMeQgR6L18Xj0H6Y31xbL_arue_
X-Proofpoint-GUID: Yqv6xFMeQgR6L18Xj0H6Y31xbL_arue_

On Mon, Apr 07, 2025 at 10:05:09PM +0200, Vlastimil Babka wrote:
> With permission, reduce the number of active maintainers. Create a
> CREDITS entry for Joonsoo (Pekka already has one). Thanks both for all
> the work!
> 
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Thank you, Joonsoo and Pekka, for all your work you have done!

Acked-by: Harry Yoo <harry.yoo@oracle.com>

> Thanks again both for all your work. Please let me know if you'd like to
> adjust the CREDITS record while at it. Pekka has currently:
> 
> N: Pekka Enberg
> E: penberg@cs.helsinki.fi
> W: http://www.cs.helsinki.fi/u/penberg/
> D: Various kernel hacks, fixes, and cleanups.
> D: Slab allocators
> S: Finland
> 
>  CREDITS     | 4 ++++
>  MAINTAINERS | 2 --
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/CREDITS b/CREDITS
> index 1b77fba6c27e..f74d230992d6 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -2071,6 +2071,10 @@ S: 660 Harvard Ave. #7
>  S: Santa Clara, CA 95051
>  S: USA
>  
> +N: Joonsoo Kim
> +E: iamjoonsoo.kim@lge.com
> +D: Slab allocators
> +
>  N: Kukjin Kim
>  E: kgene@kernel.org
>  D: Samsung S3C, S5P and Exynos ARM architectures
> diff --git a/MAINTAINERS b/MAINTAINERS
> index de97cd54ff24..4fe7cf5fc4ea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22240,9 +22240,7 @@ F:	drivers/nvmem/layouts/sl28vpd.c
>  
>  SLAB ALLOCATOR
>  M:	Christoph Lameter <cl@linux.com>
> -M:	Pekka Enberg <penberg@kernel.org>
>  M:	David Rientjes <rientjes@google.com>
> -M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Vlastimil Babka <vbabka@suse.cz>
>  R:	Roman Gushchin <roman.gushchin@linux.dev>
> -- 
> 2.49.0
> 
> 

-- 
Cheers,
Harry (formerly known as Hyeonggon)
