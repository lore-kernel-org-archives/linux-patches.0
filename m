Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6185E3B1EF1
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 10:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781780391; cv=fail; b=ROO0j28rTfvKekLmZDLswWo0tiCMLic1kaUKqp3wXWLq+GIDZCwxNDqLm8pJ7eoQy25ghC8XoU1l3OcjshIt0RVhJ5grYPjApTXR1JrKqsYBNMHrk4rzh065qfoFaEraBNPvObxCJCpe5YywFGCUsygaoeOZSCkOmRRlZy56iEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781780391; c=relaxed/simple;
	bh=Ukz1eBJST304bWwdTOb4g0eGlyqHnCli1GmFblITtNE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SnYipahniJq2B/AweYvRdwWY/1kNfOnwkFeYnh5jZDdeU4ySHb28r7hpHQeEyjxv2VJde7P/LBftK5fSvGwT2JSdiIikPItfEOzWVRjugaASwf2apVAaxYDNFfy5IwpU4VcF5EUULGDrfjNok684TUcd45vaTGknkqfTFkKTHZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r2iAv9yB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h2BCCUVi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r2iAv9yB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h2BCCUVi"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65I6aC2Z2367895;
	Thu, 18 Jun 2026 10:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wa2U6OQsXCrXqyZAniqtH9uX1wzW2iT6QKLR34CYea4=; b=
	r2iAv9yBVB061nxM0p+zGwSRqYt8fSu5rU2dsw6nVVqXl+Y2Y5Y5p1s0Oyizm3KF
	+MlL9QFIcQ2rjNyTvaEW1tW9OLhp7QayhEYUU+Jh/rgMJ3gJCYoNwIvONgertfCb
	rjMpsf5rTPCZmqrfa99X07nHRRoFqcCo2Knm6Vx4F9Z03ZdXXnkMrxvDbb1LflFC
	Ga2LTxVysEezG0AZj/ioDGNBuiiCjhE4d58IGPGtSph0EyVPgJXXmA70tpozx5IY
	t1xG4R/EkN7IdUL38iu4YvkINu4BWEVfAEkXGGWpYpeFc7oy7HEnaVpq3wLNUkwn
	3cAwlYc6lPYjGUR9jfEF/A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg32c66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 10:59:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65IAxWim019525;
	Thu, 18 Jun 2026 10:59:44 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012064.outbound.protection.outlook.com [40.107.209.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ev1bqr51r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 10:59:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUxcolkCdT9OqjYqnPh4cEFUdq1INyNfeRRyfLfq0QPLwEpWYzOyVb+4xnujGDW+e5aujrZ9jAoRF3QKssznZbF8Xee3L7I1i02CdR1ejHrjZnr38yOsKABuVMjJJrm4s19kFk1hlLFX6Hqeadd0j/LkO0Q8C7fHNwfG5T9yN64hOLrm+QM3XR8E/CZ3RJDIso5kdNnfWCuLLQRhmMRVJ9xn2dlHWVeUBPnHI4rgo/eplPDQX5LSV59JUrOz9x8l2vkQmqaAeXG3WX5BF0Jcl66brn7I3p03nML4v2Tri++GnZotcYjkMCVnEGfkupW86hRccbt4s3q+qsN0t4SpDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wa2U6OQsXCrXqyZAniqtH9uX1wzW2iT6QKLR34CYea4=;
 b=O0Fqt22Pl5Q/NWR4bkH67r/o+rIkRN+N7PWZPn3XtxCS2SGUG/QPaA6Uwccgq/wQdGUSSC1x/n1FLhmlVhrLmYB2sUFBr74eq6yNk//TFhmciljXW2/++OlKETRdZSlu3M7ofsg27qGWS6oG2bRmHpgFY9AJ/dEFzStK30WgCRlv2KLwf6GIQ81Y04yjyQVyVbZMsgzBB6ggAvVy1eT3Aa6IgsWPXs9IPw4D1GpNrUnWdsauILljmbiKi3XnOPG40GHz9RNMsPSKpUAn2nuB+TQ3ZmA+pYwsqgDSVzmxgmJ69FyU/CKXfj7jJgNXxdp11WdNPZv06aIJ+LooozlGlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wa2U6OQsXCrXqyZAniqtH9uX1wzW2iT6QKLR34CYea4=;
 b=h2BCCUVijNZDt8pBXwuj/8NgkVztmICrtS554YSoUDJVCu4d8T7b3KUWTUki4E0yOsS85+V6YDoCbleK7ppQlOSWeMRW0769MfR4iGTIDlMJawV+XMxOb1iHCnTzV8q9bPqwIzJHzu8JgZyYgzgxX/rjzTj6HjaRwItEmjTb28Q=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA6PR10MB997682.namprd10.prod.outlook.com (2603:10b6:208:5dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Thu, 18 Jun
 2026 10:58:10 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 10:58:10 +0000
Message-ID: <ed09740a-561f-41e4-8d7b-ade8f6ae0763@oracle.com>
Date: Thu, 18 Jun 2026 16:27:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 100/261] netfilter: nf_log: validate MAC header was
 set before dumping it
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Weiming Shi <bestswngs@gmail.com>,
        Xiang Mei <xmei5@asu.edu>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145044.869532709@linuxfoundation.org>
 <20260616145049.667194632@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260616145049.667194632@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:8:2a::27) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA6PR10MB997682:EE_
X-MS-Office365-Filtering-Correlation-Id: 256727ce-2406-4b32-c98b-08decd287ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|22082099003|18002099003|56012099006|6133799003|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	wu0+sWprXXNXOpKaZTOSpPWvwLU0Pm6k6k+sVgbW+LUWSklqUvwBYajmF/9YqhHJMROgAkFPhblhlspyBFW/V20aBmb7zknfC1/o48KIRd0HkIOdsb8dsAwBNTp2xehRid7UD3C8mnFKqAe4wq8NtfNX/F57RaCqNrEJGdJEKRapXWYw5cMEijK8ZCnU+4cvEOLKZmPdO+tbDcK1x/Yxa7UEJ99A1pWgotAilwK9wEYkGLUnAfGz4Ri6CJuA/KlfqGDbsDIrgS91Y/yBdmXpWsmUp/Qh8wQZOL1Mx0abY5L1cAJruDQXWZIJmKKad0ns5O85f0mt+4cw8ssrr/XwoOgsAqdV7t1UNCtMZ+R0Ah3eMYN0dX3s5DaDbFtP1ioOqRp9VSNvJtHBhLime3wtZU2xPWmTZYhcBYMk/tyhazChBlKtmn9eIJcGRYSX3yBzA8bYMXH6ycL1jwHQrnQTuXGLWB8e97AJKcHoBdAtKlkFCUa3cqJOrW0EQ5zcrpnfppUoUKbwqmrvzvPvQhq00HlTeAlR6NwtuCu47HtQqyIzq6j1g9kwRfelgKUu6RzAjZPmYcvAd27fTrghPh3uKEIYvH+LS1tURV7G032BTJIwrWt4xLh4xOJyW067/CS42nB7RTShMACl4qPVBuEQ/pyRbmma+BAK2qxhV0iH1FspWvcBD9U+K1N2wXPHPp5P
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(6133799003)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mk1TcDlmR244UDBIZnFSKy84VFBvZDBZb1NLTmJxam85bk9sMFJNVlBTTjZ2?=
 =?utf-8?B?Rm5SRGRCbUE4NGtJbHErWmhvQXZINzF5L05vTTZIUEFiMnVzYVd0WGVYcVB6?=
 =?utf-8?B?QWFhaHEzM2duTVlJckRMQlc0MzZhc2hLVi94MXFFdGtGQWpSdkhnc3Nma3lT?=
 =?utf-8?B?cDIxMTFEc3FDTVZCZnM1M05GQjY3bitGUzh2TFVyMWJ1ZlZ1dy9MdW9xYVJV?=
 =?utf-8?B?SEF0NERJdFlhRHR3RThTSjFyRE1XVnBLd3N3L2t3MC95MC9aZDkxYmRMTVZx?=
 =?utf-8?B?NVlRUEJEdkRnTEtLeEJYV2tmVStGc1hzVTJiMjVOdnRKbHk2WkN5eFRnU1NN?=
 =?utf-8?B?dlJOcVhPY3ZXRFAyM2R6ZSt5WlhOSGtoT2lWSHZubUV4dzZxcnd1cXZNeEUw?=
 =?utf-8?B?Z1cxbmZZS1hxK2tFelgxWDdrOU9YamU3RVFsRmFWakpkdU9acmd2NStxQ09j?=
 =?utf-8?B?QU1tM2ZYd0FycUhFMXhrdGJZMTg5Znd0TVVPbHNqeTM5MGNmOUZ5NWxQZExV?=
 =?utf-8?B?UjZQUlZJVmxXTk1iUFZ5b01XQ3ZiS2tQcHpaZFVHb0tLNmlQS0NjY1YxUk5U?=
 =?utf-8?B?SFdaMzdTT0M0cjhvWVFTWUNvRjJJV09XSHBVRW15Yk9ONmxvejdTWGh4N2Yr?=
 =?utf-8?B?QVJhR0JRWGJZblJFeVBMZThMNHRSNzZTRlRHTEhCNHpSeDh3NDNzOUVqeXRy?=
 =?utf-8?B?TlNxT1Z0Tk9pcVBRQy8yZkdNQndXOUNUVGJwYURDdXE2OUJ5L0pOcGVOVWR2?=
 =?utf-8?B?Y3BDNmVhRlBDVTJGRGNmbkJDY09mWHBZcmVsOG1NYTYyUG94ZkVzQXRFNWFB?=
 =?utf-8?B?VFpCekdHckxCVVJtVGNZeXFvMmsxYlJhd3RMRy9ZVUh6VmJBTzZuU0dWa09S?=
 =?utf-8?B?VEtESDV6OWhXY3NiMjNYV3NZdkliWGh4UXFvNVZBR0h6VFFWOFlRWnp6L1V6?=
 =?utf-8?B?YTRZWWhaU0xTOFUxOUZrQWdubzJtSEZGQ2JobnBMRUFLcU5UTjhhSnJYYjdQ?=
 =?utf-8?B?Kzd2ejYwYm5sNkk1VkJ1RTFlMFdsZjV0Z0NoakE3NDNPWEFPbGZSUXQydUk5?=
 =?utf-8?B?c0NXUjFDNktSYTkxaFFMcTFQaXF3Sm0zRHFCMGNYcHRyNTVnbnVUOWtxKzMr?=
 =?utf-8?B?SjJjemYxamVMRzlXaEYyRjBaR1RIOThZNmo2UFgwM3YvU28rWjVXY1FJeXcy?=
 =?utf-8?B?ci9IakdhdDBTdnhkMytuOGlsVGR2NjNjYW9xSnpqcnZxOWlhRDE3bTY1ZDJz?=
 =?utf-8?B?TnJ6eUtMOHVRZEttbmYyeXJ6WndmWEpkUmVEVzZZMXdGa20vUUVzQ21aUitw?=
 =?utf-8?B?OXZ0aFAzZmVBc2N6ZXdaWGlLaGdIZ0Z0QmhoM1pwMDA1VGp4ZUVlN3ppVEQ1?=
 =?utf-8?B?bHNCVkd0SEt4Zmk3cy9YUWZWaHZ0Qkw4NzBEVmJyYjFDYkRlY1hiMlBwbHRS?=
 =?utf-8?B?RkptODYyRG9MQ2wvMWxQS3BHbzNGQWN3VDFDZWN0cllLTUFEVkExSWwwTkRG?=
 =?utf-8?B?MmRDK0ZjUG83b0JqZkVOczRhczdzQ29iNE5jb0R4M25zMk1Ha3J1S3FhNzhG?=
 =?utf-8?B?clJ6ekZaUHNEd0N4OGM1b0FBODViaXRXd0ZPYitsS0FaWnc3eU12cVhHa1lD?=
 =?utf-8?B?TXdSZlBEdTNXZG0wdi8xY3JHQk5RSUVjZ1oyRXcrS014cXRHNHBJaytlT2R3?=
 =?utf-8?B?K2RhN0ZWMWlVaXAwRU84eDJtTzhrUkx1VnpidDhVVjBkNUlzckhILzIrZkFh?=
 =?utf-8?B?Rm5TZGx2am9YcnRHMEQzSThnMWUvK0JxaThsRWt3QlFDazFVNXpWNS9zK1Ex?=
 =?utf-8?B?MFRwdkpTU3NoUFFpTGlmak5memVZZEl2UTdBeXB3Z1VpN1dCOVV6Yk5UNXdT?=
 =?utf-8?B?QzR2Wnk2Nm5vOFVDbzJjaE5MTVZjd2FPSGFZaGZFY244OGJ2aFZmaGVEa04y?=
 =?utf-8?B?R2JjRG92RXFWRWgwYnh1dUl2ZjhML1JUbVB5ZjdKd0FBZlZqRDBpb1N0dyty?=
 =?utf-8?B?MWJxNk45WGZYbm82U2lZblJzU3FyY0l2K0FjQWtDSVQ0RFZTN0J5QTFWbDBs?=
 =?utf-8?B?VEdSczU3T2MrTFBPVFo2TU1tRFFvckd2ekdld1V4MkFiT1VpMGVLeWkwbEdO?=
 =?utf-8?B?K1R1T0NTVFl0dC81SVBRWi9zei9qUmxNSTAveWhRSzJmbzhEcTJxaHk4dlV1?=
 =?utf-8?B?RFNqam8zN1Vkek0xZUhJNXNKMi9vVUZFZU1iYVdlaXM3TExvcFZSeHNzTFNy?=
 =?utf-8?B?TXhhUDJnMkhqa0ZjeWNMYUQwM0Zva3Ayc09Vc3Bac2hWci9WUW1JUjFISmp5?=
 =?utf-8?B?c3YzYzc3RlZ0Q2NzMGlPMjBUODdGV1V3a0pHM3B0MGRjcXZmdzhrVVZDa21j?=
 =?utf-8?Q?eGJTQvx//+hYYxm9sGSpj0jb/p6RQR7g2eLqZ?=
X-Exchange-RoutingPolicyChecked:
	i3PrGZPI588ZMogqzjXNFjv6b59BJkjPH8sogezhcQXejgVW4NTctpMM5dYK+ygf4tTprlHPMiKYjn502BNNhnYPcCuulZZ+sBXKwe8SpkUeSdFFDwZXQowZ7/eJrIKiwVRbctwqIpwD6kXvlQ9KsgxERpHPj1/GL5+yUZPuw2NVapJF6Y62xQmWZVKA0NqkvVItiur2A9MAU7ADOdHAgqHbfEODZqIGDyBIfRx8Zmzopp2YICeLeFh+O27vHRaY85VQD/i5GkJA0yU8UiZ3dF3gZdiA+kEim7ClFNC3HFdpjsDrX1Tvuje9Ld5ZI99kxxZwBtj4T5fzkhT1KnZs7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Kan/pj4fX0JeN0N8pUtUicjTIPF9DLVOBts9u8CPAlWPYrt6K0m8fcGyuk8Xxf8hQSaYFyYXzv7qt7BV2UOjlUDAhAf4FSpPO6biUV+RGfIlWcA0QyxazaRyqyZp6K0GPNeXxawk4rzcU9xkiDijQTQDd1xvobympVkVXZTHwS4rHsqBg1I2UOk4ngCE2bAIZnixbK32M3NSYBxnXd1nIDVs5fjGDSNIDI92829mIx06E8me9sQmIlavZ7Wx0zyTL88qyx/C/m06iP76ZehMXCgZ/7dO6wi72Z1jnd2GQ8ZlgSjMhmKkw3uMyVK019jvK36y70Iqgr7kWb91mf4y3yw7i4FwnfxgVDe3BPB4VvmqFf3qJsHeo9gN23KRnp1lKSz0puqdeCXiNemaQaajqRatxGRkcrFJkxAb3vhKZ1uY8GcM2AtxqavqNnlKdm3ac+KoPA9m4tCqZnx3u1vRqpB0PNFi5IgT6PRec6PKGvDmWI6DrClk3qM5UwRkGhwd13ST45PcFhsb+bvOXvMm6yBN2Lvhq2mpszcwfRB/CeHLSd+asYC5gASOS+Od7OD4oAjgvK7qn9aNPLvuFBoj1RjKzgfaTxfwc6vipxnzosM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256727ce-2406-4b32-c98b-08decd287ca3
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 10:58:10.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: al7wK65RJqUEEcMAaz3YB8zEDZqTFt56+bIwBNXb4raucJx4bME6Konvvkv6+BnAtW/GRU5jbKtLnTIWwYW9Tpvc9cmHtw409lAruXyoeBzzI2/whrSRN/TfgqmBsoEF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR10MB997682
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606180102
X-Authority-Analysis: v=2.4 cv=I8VVgtgg c=1 sm=1 tr=0 ts=6a33cfa2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=pGLkceISAAAA:8
 a=3HDBlxybAAAA:8 a=VwQbUJbxAAAA:8 a=kl_69m0PHjG7E-OPZtkA:9 a=QEXdDO2ut3YA:10
 a=laEoCiVfU_Unz3mSdgXN:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13723
X-Proofpoint-GUID: VdJhVI2mdAoBY-3DK_wP0Jg-Up3h-Wi8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEwMiBTYWx0ZWRfX7IwWfQjsPRp/
 tF9G68r2OxLVNkHr/p3ayvpZ2k7dN1GrmWDiW6rx6cgFgBm3ebeX0pqE7uyi7lx4TVAa0/u/mfN
 7Y1a8EiZEFbB1J8U4bOr9nastzm6NNFtkzsMbfKCLR1/lW2wQkd/tlbnHLRDtP3HAdUIh9Ye2Zt
 uhHQJPOvGX68OiR+Jaeadrfc2Qh+iyPZGR1NyBaIzV76zADW1wQyL31jlT4eRsuHTkz6A9geN7e
 3Dv8n/6EjtIzjye3vR1tpch2jX4HxCLXIpZYER02O4vqsAb3d32kQUdQYT+bPQNe40Jt42QFYb0
 BGw2NhgDjUnZIgA3+7hltACq6oY0vVW5E6qUwZ+apwKnDau/XH+xgbbJaygoa3NAlax1czAW59s
 qpbtC5ZebP/j1JDf8QX+zvNol/YU6NVMAEfryw/P8s3Fu4CruoIuTZOgAXBgrc9XbobUDpd5Kcl
 nF/9x1VjLc3F9xlivU9fJH4xo7KmSHR1ftEf6EZ4=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEwMiBTYWx0ZWRfX1clxFfMMXF8u
 SOLS5AxRmZd7bvN//HrBWNILR+laRZMxvLQp8vMJNybQuJkyYZ5oVNMHfbIb171e06tDnWRSbAl
 B0kKnZT/ytZ5qhesnGMzwwmJ+Fd9O1h4VJ9UzCztxbgqAiQy43HM
X-Proofpoint-ORIG-GUID: VdJhVI2mdAoBY-3DK_wP0Jg-Up3h-Wi8

Hi Greg/Sasha,

On 16/06/26 20:28, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Xiang Mei <xmei5@asu.edu>
> 
> [ Upstream commit a84b6fedbc97078788be78dbdd7517d143ad1a77 ]
> 
> The fallback path of dump_mac_header() guards the MAC header access
> only with "skb->mac_header != skb->network_header", without checking
> skb_mac_header_was_set(). When the MAC header is unset, mac_header is
> 0xffff, so the test passes and skb_mac_header(skb) returns
> skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
> dev->hard_header_len bytes out of bounds into the kernel log.
> 
> This is reachable via the netdev logger: nf_log_unknown_packet() calls
> dump_mac_header() unconditionally, and an skb sent through AF_PACKET
> with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
> unset (__dev_queue_xmit(), which would reset it, is bypassed).
> 

I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issue goes like:

Upstream has this before the eth_hdr() users in dump_mac_header():

     if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
         return;

     nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
                    eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);


but 6.12.y still has:

       nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
                      eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
       nf_log_dump_vlan(m, skb);




> Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
> uses, and replace the open-coded MAC header length test with
> skb_mac_header_len(). Only skbs with an unset MAC header are affected;
> valid ones are dumped as before.
...

The posted backport fixes the fallback MAC dump path, but upstream only
assumes the Ethernet decode path is already safe because of 62443dc21114
("netfilter: require Ethernet MAC header before using eth_hdr()"). I 
donot see that commit in 6.12.y, so NF_LOG_MACDECODE can still reach
eth_hdr(skb) without proving the MAC header was set and long enough.

I think 6.12.y misses commit: 62443dc21114 ("netfilter: require
Ethernet MAC header before using eth_hdr()") so this backport might not
be complete, thoughts?

Maybe we need to backport 62443dc21114 ("netfilter: require
Ethernet MAC header before using eth_hdr()") as well ?


Thanks,
Harshit

> 
> Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/netfilter/nf_log_syslog.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> index 58402226045e84..09b9152e9e5492 100644
> --- a/net/netfilter/nf_log_syslog.c
> +++ b/net/netfilter/nf_log_syslog.c
> @@ -799,8 +799,8 @@ static void dump_mac_header(struct nf_log_buf *m,
>   
>   fallback:
>   	nf_log_buf_add(m, "MAC=");
> -	if (dev->hard_header_len &&
> -	    skb->mac_header != skb->network_header) {
> +	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
> +	    skb_mac_header_len(skb) != 0) {
>   		const unsigned char *p = skb_mac_header(skb);
>   		unsigned int i;
>   

