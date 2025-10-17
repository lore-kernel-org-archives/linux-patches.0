Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90D72F83B5
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720836; cv=fail; b=eS8LXZd1ePiqCeXtsyDoZ5EyYY7EXHCzT+py1j56KVt39FqR4CJKxVtAlCK/twdnSGE6tEOg1SWqBcdOvQ4KHCve3wCPUK4Ss76nkAMnILLG0S8p/qallKxbteccK+jl0bjqvxIhrvn7Rd5NBFq5RBk9K7tewX4VRVQXX+gLFAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720836; c=relaxed/simple;
	bh=wCKRb0Cy2uMqLAvrxqWtXEl8MzRNDhsj0VZzkeTTVSg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DWEL7gAGZlW3wOXlCYEtrBh/DtsPhhmpVfOxbpJcGuxrCjeahUSZLb1TxzF+1BmK9VKZIuDpyuJKmYE27An0q7VGdWfc+1A41g754tSa3Y6D2TVsFcO2HqrNpNyiJXb/16jnP5Y7TKPLw86IKc2ero33z4oE7Oo1RW4FHSxKPBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EgqHVntr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iK0zp5yQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EgqHVntr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iK0zp5yQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCddp3021110;
	Fri, 17 Oct 2025 17:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GxOVnYOR2AiFG/xeYeiPh9V2Px3k/6QGdz8ShXJLNzQ=; b=
	EgqHVntrq4bUIVstgLreXrLeNRt4qR6GQVV7qU+Tw+ACKgF8kOh9t5yKouAJkV7m
	6Xuj7WxhqIeE47MFcsh1OXB3LtqXVe+P78r9CX5lLk+K3JLDmYHTSf3ysfvaOK4Y
	+6nChqjUvAgpQ4AliNhlz5AqxM2SFaHgLhC7A0qDSXl7i3y7jrwX7jUMGbx8LecM
	ZZjaYlRqynVmGnN85khNDqqoKpaSOVwXUvwol4A1ylRxLK/uknDHWah+ahSIwAgc
	g4J7B47w20P/NMRSEJPQ/mG9ZeQEXAzcfs3jF5rZh+TE65wCVNFiljzAZLw663wL
	gZUT6cf2ofHxHWvRn5BDTQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1qjfqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 17:07:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HGA8Tr017938;
	Fri, 17 Oct 2025 17:07:02 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpd42jf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 17:07:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cDFfbr3jx5nBv0EEJBDzAJ68Vb9x9EgzTi6FbE7VM63F56C6LJvTp0J8wlKeRPZc0mpn7lnfSz+D3uVV8ZOzMg/+R3WoYvHx30wH+a54mCzIHJ3EUsLO+ogwmDxSuCb35yuYZjP7F/LHhP/7jNkmEn46KD4YSFS2Bd37o+QnFXuzQcMPPGUZgrSfKvtXS2yzYXaLChgRAb0QAKEBn+/edrpfk21v4LV48yX8dVMuL1E7YJSvJ6Uno6uvT4F8xk/MLQ6W1biFjCipbEQInSy3lMRpXGYe7sbdgL7X8PWXpQwJdqfmwgIfvmAT/6vA5PvHs+HcyoXpVud1Sn/IXH6H4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxOVnYOR2AiFG/xeYeiPh9V2Px3k/6QGdz8ShXJLNzQ=;
 b=G5xCqvH1dUSufsooXy6Qbc47SKwV8bPfQjIjaAGz4o7DUP1Bq62YA5q4KA3lNUpMs2BTqVCQMSWWKKsLVlHhf9JBhbg1GTy6F1T5Ptrt5FwVG/IZEEYg1JrXb0qMKD3AjgbLvhYEoqib1DBuS4B3+TW3OZt8Bvk4N4JvAMMV572AMS2lAh3zKokyfqtVa6GVyZ+juK5vSXA2aqtiIm5MLrpTcxDQ7ymfg4ow+wThw1d62GQSlbRjrethB970vA3FAKFf8lR22HmzVvByim6vK0oufEvfdMavwYS/7F6jDLUO1aQTX68Ook13geP9DSwbOSM9gEQI/K/rutUDOHFIDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxOVnYOR2AiFG/xeYeiPh9V2Px3k/6QGdz8ShXJLNzQ=;
 b=iK0zp5yQA7q1zb466xSERDfj57MfXmP1MIzoRowKOjZYOFr4rf/r4srDhHg3URzxIrEiz9dlL8lq5YJRfobskpZowLSyBCAUyaZr9bpC+3jhfNcV+PAG5eCs4wjuBre9RX/8c5vauHEFeNcPiWB6+hh80yUvmG5VYTU3qUV8wqk=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by CH2PR10MB4310.namprd10.prod.outlook.com (2603:10b6:610:ab::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 17:06:59 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9228.010; Fri, 17 Oct 2025
 17:06:58 +0000
Message-ID: <ae8249d9-afdf-4d5f-bcea-8c9ffc709d70@oracle.com>
Date: Fri, 17 Oct 2025 22:36:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 238/277] KVM: x86: Advertise SRSO_USER_KERNEL_NO to
 userspace
To: Borislav Petkov <bp@alien8.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        patches@lists.linux.dev, Nikolay Borisov <nik.borisov@suse.com>
References: <20251017145147.138822285@linuxfoundation.org>
 <20251017145155.829311022@linuxfoundation.org>
 <ba4f2329-8e29-4817-993a-895b8aee4fb8@oracle.com>
 <20251017165325.GBaPJ0hXW917YN8BX0@fat_crate.local>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251017165325.GBaPJ0hXW917YN8BX0@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::22) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|CH2PR10MB4310:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e8070d1-250f-443c-3937-08de0d9f94f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXMzZ2ZCNzZPM01aTytHUXIzOTVUazZ5NHVDd2l5bjd1RUtkL0J1cEdzQWJn?=
 =?utf-8?B?anBsZ1c2R25JbWxTdkd4RnNUNnJ0NHhZdkJsUUh6OG8rZ0JyMk9KWTVsRHFS?=
 =?utf-8?B?bXJWSUJOTURCRGhGMGhIMHQyRS9nSzNraTI3UWc4MjNqZEw5M0hsdXhEOXAy?=
 =?utf-8?B?amlJd2ZwbzJhQmJseWxFU2xxam1vNTJmZk9iVDUyYVNRWE84Mkd2dDdsLy9x?=
 =?utf-8?B?cXFTYlFLYWhGRUpnTmhOeCtMRGY0M29LWG9MNkNTNHdTRWtrVWN2bjk5SFQ2?=
 =?utf-8?B?cTRiT21KRFFha21pMkQ3QXQ2SXZQaXUrdjhjM0MyeWtkZEthQ203bjlNQ21E?=
 =?utf-8?B?WCsxMENUTVlvOVVmY2tMQUlyVDVidUxaeEg0Q1Z4Uzk2dWdjMXlhMS9PbkZB?=
 =?utf-8?B?YXRTaWxYNVBmbE5wUy9KUHBiRmhxYlRpbU9NVnlZZURrL2tiS2lPb05vRmRP?=
 =?utf-8?B?dTl6bFRZbjV6c0xtbkp4NXIzNGR3dXFKUXFNTSt1VWtYL3R3c2hMV2tGWEV4?=
 =?utf-8?B?eFdWVXNFWmEycDk1b2h3WENxL0NOUWxqTzNRaVd5cXQ1UlFHczkvbmgrMTdt?=
 =?utf-8?B?ZXVNbytGT29jRy8yS2pnMnBydFpEOGZTYy82QTRBSExHcnR5SjlheTM5YzRT?=
 =?utf-8?B?dmF6dUNKUnZNTHA5bU9QWklaaWhwclQxTVFWMmVUZkxpQjZ4SjMzUTV0Rk0y?=
 =?utf-8?B?WFNjRzl5SE9RYmFoYnVTajBVV1lSVmdQUzRtYUQ1Wk5zWDlaNVZ4N1YrS29z?=
 =?utf-8?B?OEZ2UExLWXVJTGxsbGRDVVRuR0dIa3pFODNnMUlaNnNaK1VjTXhZYk9lTllh?=
 =?utf-8?B?U3hjVGF4b1dXQlYzeGVNVmlVM09Ncm5vRWI2VUR4ZUpWYVhOTTJ3Q2E5VHds?=
 =?utf-8?B?NUkrVDhTT2pvWGhFelgyZkp3TFNSSytnV0l2YVEvcXlua0RUQ0xwRkxlYlkx?=
 =?utf-8?B?aCtzdWhZZzg5NU1TaVpabm1rUDNwVi9UNEVFOHVMZnJxYjlxd0FNWWltRUxu?=
 =?utf-8?B?alV2aWJpZkJ3NzhkWHhvck5OMTZyVGtZT1ZOcHVtOFRCZDd3ZGQ1MS9uaVox?=
 =?utf-8?B?NmZWcXhZRnhud0gwekRpWDFzQkJtYjVwcnh1OTJLdGFRejl6OCtUL0VJNU4r?=
 =?utf-8?B?RzJ2aWQyWEVST3MxT0daNDVKbExGYmQzYzdLNzQwK3FkZEhzdHNPKzh2cHhG?=
 =?utf-8?B?MktTT2Fpa1BjdGRxY1R0K3hUcVptVDk2b0dOSHdvUHE0NDYxSlJLV2wzTXdm?=
 =?utf-8?B?L3lueDZFc0Rtam5WbHB0S3E4Ykdoc2REM2RnRnNuZU8ranRuMWJvMi9EbEVU?=
 =?utf-8?B?aVFzaXNsZWc5MjFaY2xEU2EwYWphZzJxQU9wSTh3RDc3VkNnZGJSYmF6bk9y?=
 =?utf-8?B?KytmSGtmL2JvNDFSZFg2enBFazcxMElLSmlwdDd5SHkvd0N6cVdyMmJzUVVM?=
 =?utf-8?B?cDZSS2gzbmhpZ1dlY3dKajFyeG5LU3p5N1Vvd0RqbWlCMnQ5b01WZGUva0th?=
 =?utf-8?B?cE55bmtYbXkwOC9mb0hlbmtIUzFCdHJmVndRQlYxbHRab1R2YXk4YU5PVnpU?=
 =?utf-8?B?cVdUbHk2SEpkcTBqb2tZZ2pkR2tlYkJmcHpUYkhHSGg3UzE1cndvNVRINzg2?=
 =?utf-8?B?T0tES3BicDFubDViZUZFY1ZZbzY3MjFkVWNpYWt1d2xWeldCYUdYWm12Z3Vy?=
 =?utf-8?B?c0lLTFlKVFoxTmtDdytxOEMvekVWYnVBMi93M1VsU3cxRFNlem5HeEtacFFy?=
 =?utf-8?B?aVIvbFZwWFJpdzJQQkFBM1ZjYjZLUGZRcXFha3gwUHU3WnVoOTZrbmFEeWZI?=
 =?utf-8?B?MFgrSmF6LzA2MkdqQzhBcWtIS0xkSC9MK2Jnd2tadHRtamxxQWJDbk5vUC9Z?=
 =?utf-8?B?a1JjSnN3RkRJZkU5Qko0R3g1eGFGQ29ncHhKcnNjWDRNcFdNUXRtelp1aWl5?=
 =?utf-8?Q?me+uhbtPxRurhTroLIPGzlvEgbJv/O8S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkpHMzRaY2M0eThkOVRLS29MVk5JLzBoeWZoKy81MTI4REtVWEhsT3Jrd2FH?=
 =?utf-8?B?aDZqcENuQ2ErMU96ZFJyaHhFcWJRWnZXUHAwRjQ4d3U4NmNGelVDNnZ4Q1FS?=
 =?utf-8?B?RUp3dG5iL2w2SkFOYVcyeFF5aWxXMktjUlg4bi9LT01PaWFNc2hpUVFqbnFX?=
 =?utf-8?B?WTBNemcvZkJKWE9xY2xzQ0FyS3dzYnlDQ2ZnV24zWkZmMExoZ0VaZkdCTlk5?=
 =?utf-8?B?SFFGVVFQanZHZHJLaVRwakNVeW1UTk52WnJhZFJNZjhhYUtCMTF4U3hQcU5n?=
 =?utf-8?B?SXN1UDhuY3dzWFQ5NDZzR29zank5citkOHpBb0VySGxyN2JrY0hEK21EM201?=
 =?utf-8?B?Q251YjlDMVhicVRjdkFKVGpEcExJblRUWk1PaEdobWRpRVdHMmMvYVhTT3NQ?=
 =?utf-8?B?NjVmZFA1eG1QMzR0bGdoSi9pYmwrendtaXljSU92RGV3dXFXejNHNGt4NjZU?=
 =?utf-8?B?NkZvOGFDSjdjcEJNYVVwM3BKUEsrQTcxWFNya3lEUThNU2plWVhlYVJleE9x?=
 =?utf-8?B?cGRzdmtSU1NYVDNvTmhRZE13NTVFekI4NGFudGJVeUcvUnhJN2FqdGY4VU4r?=
 =?utf-8?B?SWpXZHdKQ1JhbTNBOGJvbTVFSDduNGdJUldLQjdwU1JNRWN0SlQ0Z0hpajhO?=
 =?utf-8?B?K2M1NHRMaUsxK1ZKeVNxTGRjMDdHR09rOElvQS94RkpmeG9KN1VhSHEvQ0di?=
 =?utf-8?B?OWNsamF6ZUYvSXhHKzRMbFBhY0UyNzRsSE1KUUFVYm1Oc2VEU0Fvc1FrSXpO?=
 =?utf-8?B?ZWJwQW5QRUVjeWcxQXBtaklhcGVPQnBMTlV6d2IzQUtuNkNaKzhsRDFFemc4?=
 =?utf-8?B?RVpJdXFBS0l2eERtUTEwYTYzS1drTHBjOE1OVk1MSU9Na1VUcjBwcEljb24w?=
 =?utf-8?B?SGI4bHBIbmJMS3NuaVJTMTZzK1N1dUVNZWJHSWVXdTlPZmRTUWN3VnRNcUhZ?=
 =?utf-8?B?T3BsdjVnTlpaSVR4MFE1SGdzWC82NDdMSjNYbHFRcUxlQ3dEZWszZUxnQzQv?=
 =?utf-8?B?OEZmUi9ldGxLSVJFam93em9lK0EwSlNMU0ZuOW9sT1ErUWNwdXJRTURuM2pC?=
 =?utf-8?B?bUw1UkVxYm5vbEFYUmljbnFYZXI3Z1hMTGFzZ05zUVdlTS9EcmU0YmYvelBj?=
 =?utf-8?B?SWJ2bHBFbmpaMFg5Qnk3MENTOExsZThUTkNCdlJERXI1YmRkK05KMHRZUEM3?=
 =?utf-8?B?a2J6MmRMZEZQYmJZL1BTZVZiQXpxbThlTXRCcTZYVjFHcG1rZmVLaDIyWDVz?=
 =?utf-8?B?OTlaUFpQLytXNE9KSlRsa25ucEJCQkY4Wk5saVFiUnFBbjdqd3IyMklFa1dR?=
 =?utf-8?B?M3o1WlVvYkthODJZanVQbFdOS3dvZWdFVDRrYlR0MjRXSTdENlZOaWNvc0RQ?=
 =?utf-8?B?NVU2N3NNd250WHo0Y3dCV0ZZRWtpQXFZSGJPckdIalZJdFVYMmJiNmMrLzhX?=
 =?utf-8?B?MDFGeFBrRDFGSzR6OFhmeWhvUWhJUDlkbVdjRHZWUXQ2eHdmYjYyS2lDakJY?=
 =?utf-8?B?ZFRsd3J5UWZtamFYclFhZVQrR01wYzVaRmwxbGI4b2hwYzhka0ljbGZ6a2dV?=
 =?utf-8?B?KzNiZW5MMGFMdlB6T1owd0ZEb2NxeDNmYXFabnlJOUpQMi9MRUNsa0FrZ0Fz?=
 =?utf-8?B?cFNJMnBobXpKaEpZMmNRWUdaamlvc1RUd055VUFLMjRQMFoxREJqMmtJWi9P?=
 =?utf-8?B?Y0dmblpySE9FTTcrK1Q2R1hyc0N1SkFUbEV4TlYveEdSTXN5aTg2VUJRZmg1?=
 =?utf-8?B?dFl6eGJkcEpIWC8zbzArMmhDdDNlNWtWblRGNzZZL3MveU9uUTNobWlzaU5K?=
 =?utf-8?B?OVBSTXkzMVVaNVgrdms3RWFBOFVNbUhMVTlsYnZLN01LeW80a01EWHVkbTZE?=
 =?utf-8?B?cUlmdkpML2U3ODhpTnJ4NjM2YmpJMDRKQTBUV3cyTGJsSjg0dWY1UEx4c0NJ?=
 =?utf-8?B?NExwL0Z0UzhkbEgrQ0ZublFvZTZzdDAzNXBWdWgxaVlIeDJaUzl4bEY1L2RD?=
 =?utf-8?B?bkZNdlBJM0xOVzBJQS9CRGZJbzE2ejJERDIzUTYzWXUzcWlCc2ptQ0RwWG9P?=
 =?utf-8?B?V3Bkd0MrL3lvWlY4eHVmMmQ3cTdQd3VFa2g5ZTlwSHZMVFprRUUwWXBPamtY?=
 =?utf-8?B?U0l3c1ZMTUoxejFrWE1sZmhPUnJzN0pFYVQ1cFBsT1YrMGJvQnV0bzBvU0FU?=
 =?utf-8?Q?/q169A+fKrHKFzT2qOyZBFw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MmwllFVhwWsJKR5Ueh488joJ4OJlkUyyr2h1FS/XNLS9h4OeuzioIqqEE1/zfRNOXT9EfXVlcimvEkOy7JKwPyTBSkr/YYtimxEyHzKZrghYGGa461WTgVErYqqAfc6TSREVfxPincrRHJiuKx2XViE5iaZNPwL3A4pW3qgwkA4N8bD7bndYmHGHj0msM/6QPoOG7/j8yr6P2HX80Hh/sjXPpctqV6zCE3wfwu4XvzEg6RQ252VzYgVdAjehe7pcuYYAQGpyhsLixUCiugzex8tMVkYUuqBNPM5JrJFhUwDme3sfIGMclyzDzY1zojm24+fT+sAwMJ+dv79qpGlXP4M/p54/YzZ/LldBrQIiS5aICOUuTjMvHklu2IXQfHcDkH3DZX4I4qyffeXfC2daJnDUnMOTguvTSSLs8IKem+KVecGfG/vr6ae/Y3Av9r8Z6rw61syyv73N6r9wagtBDjTrt+Tls0h0Ei1AjOedgp9xHo/Cp0iBts4UuUV07P9314b8Az65ioJmOSgvq9s7swkrHf3nJWEiPk/Ha7xPDypGEiUk8SUOO/2KRblZZSFOgZeox3Ek+KQclpicqAqGrTwa9Zm+STSKaMnJWJeN2QM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8070d1-250f-443c-3937-08de0d9f94f3
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 17:06:58.5271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hohKtfSeiBi3yjf5nyLXC9axajEyOiwSox8V8GR7EiE210nLQDiLn6gX4c1klmxynd+dak+FSFFVjBtYyTu8OwSORM5Jv2EuueTaBmUrAwV5IZ6HwFLLBt/bhodzMIX8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4310
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_06,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=978 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170127
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX2S2pE9gJ433j
 NhcSTbTYH9Rb5+4n3rrITo7iWogCZcEE583LURUJDNtHk/nSOnGCsC4uKRD2j+sDJuM/U3nAj1f
 bHUuC1O3g2pXLbQ5yjK632UPTFxNOPmq56vKibSCoaWIZHAYPXTUCAe17vIevv5Lh31puhMY0yI
 7NbZvaaInuOzny2uZK+GX+SGIgjlt+l5O2yT+YJKYUMDt7fAYS56/7RrCXYa/bKkO++1qT7Az/+
 NppOwmll7Dn42bcenr108iAAdg2Of2MCJJhU+mgtoE3+ZjoqOTnZBQJArJS1nPY7zs2K9H27qpm
 p9r1XoOhnkVpi8UeS3700dzOLVCInVrdVJebjqT5KliSrh7ZTYylxK6/PRo5054cRh0wbwimZ8l
 B90eol0DIPNeshsFRZEk3/Zh/cUrEg==
X-Proofpoint-GUID: mlbyFUK5OdVwDo1xx4MiOntOv9GqLfsX
X-Proofpoint-ORIG-GUID: mlbyFUK5OdVwDo1xx4MiOntOv9GqLfsX
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68f277b7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=_9S5ANYKEwd9yIye4SsA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=cPQSjfK2_nFv0Q5t_7PE:22

Hi Borislav,

On 17/10/25 22:23, Borislav Petkov wrote:
> On Fri, Oct 17, 2025 at 10:11:36PM +0530, Harshit Mogalapalli wrote:
>> Also, I haven't yet got ACK from Borislav, so should we defer ?
> 
> I assume you're in much better position than me to verify those bits are
> actually exported and visible in the guest. So you don't really need my ACK.
> 

Thanks for the reply!

Boris Ostrovsky verified it(thanks Boris for that), so we will go with 
taking this patch to 6.12.y.


Greg: Summary: Let's just trim the text after cut-off line "---" if 
possible.


Thanks,
Harshit

> Thx.
> 

