Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33EC1AA1D2
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 11:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781781176; cv=fail; b=pxdfgH1TDtYXWgKdN/Rf5jSR7yxoWTgAHoOy1yNDrWvHZR6oKlMBrm6Mh9Eeqor4rg5nNkYxkCuOZyaRblD+KDJjRcibppkaEYNUdQZXEKwz4r4oy0tdApVWf2efTgosP+hFEXn6atxjDB9bQcnXRuV+zoaL4MU1Oy3nZU0wp+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781781176; c=relaxed/simple;
	bh=GsYCO1uxnLESeBvz2Tgpsm2G1eN4fqNOGcuUEmNfVWU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DQSms1y0Aemr6WcTxA9r21bk+fLKKpk3M5lH44QRunOh3onQn9ZIT30mN+uavfVpqLTW+G16TZAm8lx6n61ETvYC3uXWPzqpzuFB/QSTPE0TDvhuBV4g9ttwzep/K5kSOAkFtLMoDAi/tUPn4gnfI+kdjLX/bTJZkNxxik1hK9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rw5LWJfL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=k0uZCVtm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rw5LWJfL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="k0uZCVtm"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65I5ddOp2480846;
	Thu, 18 Jun 2026 11:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iIYoyVfyzbbK7Bsswi0xri+o9FCdwZ+epVbQ4HtsfhA=; b=
	rw5LWJfLhzun4c6ZiuYVUiFPufYKWhzuIIPiynGHPTSrfKMTxtA+Ye+qm13jVCwJ
	CK3/k231lL3AOfAr4e44LLvH/goESFsbwuWy9FFAVZgqBjhGGs4SIvN848x03QgY
	fBPA3eYf7eI2Nsxz6tQ6rYOhH1kvItL2PWbtwxjmDJFDCCMYJjAwEc5aXVuddV0L
	7jm0yXiA3dbFAXsLrjPs84M8bUmD9npqFL3RIFD5aLXuXWpir8MeBK9diyDxL+Pv
	FlsLbZ2qyzm8VtPYajHYUBc0mOUniSdX2RbjHtdzk7kO0c+gehJKWtU4UhIkErLF
	/cH0xd76XkTy+aBMa+0CBA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg2jdev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 11:12:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65IB8X0u035343;
	Thu, 18 Jun 2026 11:12:27 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010054.outbound.protection.outlook.com [52.101.46.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ev14u1dhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 11:12:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fBy1OFfDncbCVnwPLBOnKZpiBdOMLDgGj9AbexZMxzqWKsBnQDA2nrfj4BP9fkIFniOM2WYqWbiOE5cv/b8VqtE4GLkzzyzy0Wh+/I4sZehJoTwrtfTFQTrpY86k/lMnLDP1WTtIkubfhuwSanzNZn1rw48Oheir/TTH4ICqfExZ6kRsLApBePFR4RelpcUH5QmLzIl4z8brt5QCchYPXG8kEKjOWuc3+uKayYT4AW8uZyri5MYbs5Y0vqrEqy8uXKGoSzpf1c+qDCkwLtjZLWnvFsjQ3SuJbx2hRYnmOzHN0Svtcz2P80vz/OaepvOdnq82GVeuwGsTtYuu9+GOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iIYoyVfyzbbK7Bsswi0xri+o9FCdwZ+epVbQ4HtsfhA=;
 b=mWiULu0gcMGOWJWM7Msm/VHIYUR7lTL10c+ekZTx0k/sk6Ix9UMG+I4jOmPF81FZ3+qsPicAja0QzdhxOtLHYWcFxeox/TV+qjYNoLbSZYZWV9NXBqEgrK81AjzaqbLT+Ap+tDoFXvMsFgmEgyFkCZkA8Kgbgxz8DR7dYlziGV0vuwBRBkqn68Ygn4zFkm03kUtRNSZh7NSDHVkgR1VxSt/FqhQihI5XjoEYng4TkPFDikWsOAAqvJU2Gr3pheZNKObzk2z9KwySaJPlviMu2RaaLpNAkgo2IA5J5oC71YSut5tyRoPgvL8C43J/FvIjm27JsroJ/O4diTPKVp0w+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIYoyVfyzbbK7Bsswi0xri+o9FCdwZ+epVbQ4HtsfhA=;
 b=k0uZCVtmyiy71FNgNRQyuExlinSLPLxvSJiiAiMH8PSYWAaFYMAvuM82doBx5LO4/2njfNpTPifSXTNoVUvkDCkBpz3ejF+1+xiPRbQkoJq/G8n1bt7Tp3ViHh2GR7FfQqUAVYWWbzFEJHxyTTW0CXoiITpajzthDPkXGQoHlmE=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DM4PR10MB6230.namprd10.prod.outlook.com (2603:10b6:8:8d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.11; Thu, 18 Jun 2026 11:12:23 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 11:12:23 +0000
Message-ID: <a323b095-78fe-4c6a-9804-221dc37be3fc@oracle.com>
Date: Thu, 18 Jun 2026 16:42:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 411/411] x86/CPU/AMD: Move the Zen3 BTC_NO detection
 to the Zen3 init function
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>,
        Nikolay Borisov <nik.borisov@suse.com>,
        Ben Hutchings <benh@debian.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145122.972422457@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260616145122.972422457@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR15CA0024.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::9) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DM4PR10MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d55c2cb-1871-40e4-8d05-08decd2a78b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	HtaxyvrUl4xEx4AhzCUqg5cubJPTDhO1O5lOaAlLWhIKn1FoO8ScFigQO6hIDwzxSmJZqzbO+Aawq+BsGrwND19Y5MkIyBPfVtqAfPEsmAGaOEsUz0hxA0rMYIpE3+kbQw/Cf6pqCjHjWR0h6O3WHMr5TI0/oRQmdOlUAVEkF+xanlJ9+9hE8rEGgD9IWziCrUeKQSRlGtPJPXQbOCabO6M7H/jEhXWK7jAOP6Htd9jP7OaEx60SxPBrmbB6HdRLnZ4t8XjVeifaVQmOUQlLXZ4RYaXqe8CnHtc1D1KRUPto2CTHo4kxfNpcORJeepBoDs/e5PtyQFTUd99PpgO6at1xb/wSs8otQkFoj2k8dFxMkkI9/SgN4yXNQP4J4L+C53e+G4ni0QKZSPEzIxyugoEASSADdArFHQmVbGeLzfRNCuVc6LLDU+SbWA+SpYGKzsfBor98RHvOxSvKufLc8SZI4sihBKYkyyjzwAH880xJ6EGH3BRg539l3a0yc83Lu0KRDLNxCagpH0Ndidq9yfdg4BT/lEptuzTHc/OnBocOIs5/6k4RxpqqnshD1t52sjw+IRvb5/wSNIe4/b0kH/olASvOednSkOa3kqwvNIHUTdq52gKP5Hb1LFnkKg2Ix/8MGMpO31Ro5HyUw0eav6XPCcUdF6bEkSA11NbY+DvRfbxcmMNGIyZ5xG9lmcbrGQiloNBy/9vTbzDoH7g+Hw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHgzTVF4TVVKVE5XVUtWTlA1RkdlZ3gwQ05QUWlncXVPNlVzOExPOC9RZVJR?=
 =?utf-8?B?NEF6UmFLK0hPOGpIUkdydTRZRHRKM0IrMXZMb0VUeWpsVzBqbVRBR3dCWWx6?=
 =?utf-8?B?TWFxc0hGaGRiSTJBdzBrZFlITkVteHNYQjNqdGpVbVJxYVRacmM2dTJuNUd5?=
 =?utf-8?B?ZUdyeTd5VFZ4aGsxUU1BbEtucUVQTHB2cWQ4bUdUcmZodEVtS1duSEkzcFNX?=
 =?utf-8?B?VkhDMmRsaHBrUEFFR2VKQ3k0dTl4aGJrMFpXOTA4MFFFeHdXZDF2RE96Z0pV?=
 =?utf-8?B?anRuRk0vb0tPQXdpSGRzQUpZZTgvTlpiVHc2UGY1VkVGcDFwR1lMMFRsRWZp?=
 =?utf-8?B?amMzenp5K1RTelBjclNlVkZiYUNRMTQvaXh3QS96OTc0RmlzcEg4K1FJZms3?=
 =?utf-8?B?clVjWE54NWpWcHpnY1lESUpqdzhrdVBBUGNSbTJ5RWJOVWZnWThpeittSnNj?=
 =?utf-8?B?TTJXTk9UZHJ1ck50YSt4N3BJQ2pvQVkzV0VVTHhvOU52ay9kS1JFYnVUQzcv?=
 =?utf-8?B?NFBJdTFlUFlZL2dHcDE0VmNIQkRQMjF0L3BBUFVqL1BCcUUxeUNUVExmNWpZ?=
 =?utf-8?B?MXh2UGRWcmNYUFRYMW1RU29nWE5OMFljNFBjQkg4Nlg5WGNmcGh0dXJBc2Yv?=
 =?utf-8?B?QjRmRXprWFRHRldvZ3dqSWVCU1E2MEVSOHRKOFpXM2d5WEd3U0NSdU1TbHEz?=
 =?utf-8?B?M1NMWG1TR3NPMmZkY3VyTGxYREQ0b2JMR1B3eEdkY01xeXdXa3g3QUljTUtX?=
 =?utf-8?B?Ymx3RElwWE9Hd0dDdjFKUGNOZ1l0ODJHczV6RHlSK28wdUNvRHYvQm1rNDRL?=
 =?utf-8?B?cnpCVkZJVThoR01YTHB3TVFQTnRodmlBQVZ1T2RBYnY4VTdzYnovNUdnNHFM?=
 =?utf-8?B?TFZoZHZLL29oT1lMWXZKa1FEdzVSNFZjdDhGbGNjM0FBYUd1SC9xaERkVTJG?=
 =?utf-8?B?Sm5YdXQ4VlpaT01ZU1A4Q2c3eTdMMCtQRFJydUNxQ1BMMWNrMGtkUlgzaU5O?=
 =?utf-8?B?eklLd3RUMkpnMDBwYTQveDJsY1M3RS9CZkh1ZloyL3krNmlHVjV2djRSTFA3?=
 =?utf-8?B?bmgwMjZyVjl5NmJpNFJqNGZoQStPSDVKMGd4cTR1bUZwNFZwM1oxK0I5ZGww?=
 =?utf-8?B?eGNTaGZFckxuNEZnaWJwenkyVGFoeDRwWlg3d2l0Zi9Tb3dWUnIrZUVxMCs2?=
 =?utf-8?B?eitIWjZwNUJxbTFnR1pnakdwZFBrV0FLYmd2VVJqTWJIYXRreVpjYmpvazBN?=
 =?utf-8?B?OVBrT2lDUWo3YzhkVXBqd3RmSG5nK1NkczRuUkFDRTUyRGxNMFN2NGlGblls?=
 =?utf-8?B?VTcrZjlmVGRCSVhVZWxodTdFQThqZlg4T05XdlBWUzVvZUo4cC9MYWtJMjZt?=
 =?utf-8?B?NE1tcytya0N2c1pKSEcvbHJZWWYxSUlVVkN2UDNTL3pncU52MmVNZlYyeTJi?=
 =?utf-8?B?YnJqOUZuRlhsNDJIRmk2U29kVHc0MFpXeUFjZ2doZU5lT1FUaXo2VnhDTUt2?=
 =?utf-8?B?dXYrdlZoTk9KZ29nZkdwakVxRXA4VHM2NlY0RkNVRnNwbXA5S215c2h6QWdN?=
 =?utf-8?B?c2VEdVR1cDdhSUxjT01SazJMcXpFRjdNL1g0TzEzSlBqNGlJUmNnNk1mVEJi?=
 =?utf-8?B?cGsrQ1M3b3lNUWdxQVMvTDB0NExuTzQ1ejVGWlplbnAraDRHNmd4S0I0ZEFt?=
 =?utf-8?B?NUNmWUkwRFBrMkQ5aEZaUWNvdzhPUXp5QS9xaUZrS2NQN0hSaER6LzB5QUVT?=
 =?utf-8?B?aVVrWWFmS1pZdzA4cXhSbWVCRU4xbE1Zc1VNRW81bFdocHpKWUtLNnF2b2xP?=
 =?utf-8?B?Z1ZDYTBPSjZsTjBEcEFWdjdWbGE1N3c2bG15YTc4a0VMOWlLRjI0UEl4cXFj?=
 =?utf-8?B?azR5VWtMYjBJWDhVSitvNlN2WFRLSm9PY0tOUW9RU2srbEVlOGRxektiZGJV?=
 =?utf-8?B?RTk0WHQ3dVNHbDlkcFh1SncyaUlCcXE2d1JIOWtaQUpaYUVTT29sbkJyRUhi?=
 =?utf-8?B?bnB3eDNmOUpONGNsaWZjUUwvYlp6ZG0wejFlS2hRWXFYbHR3dzZ6NTdFa1Ni?=
 =?utf-8?B?MzlFd25FbHBGL09SNlBNcWlZQWxlSzFtSjRpQm40djNSWFhLT0RPZzUvNDJX?=
 =?utf-8?B?azk0Q2xqd0pWTVBtcEpVSnRDd2hpNjdpQmpNMnhzYWlsb05LM1lkclJhMHRn?=
 =?utf-8?B?T3BFYXJHR2ZaSjZmSW0zWmszcHFjS0htR0VYTUhtUW9POHAwUTVpUjlpYXJW?=
 =?utf-8?B?ZUx6bGM4eHIxc0JRNTdXQmZPK2M0Y0RBUGRseXVZeTl3QnJQc0Q0NmtiRzMv?=
 =?utf-8?B?WVhsd0ZWWmt1MXRadVhtUEpyamV6RWhJMjRMR2pFc3RMdE8vdGp3V24zNDcx?=
 =?utf-8?Q?GCvEiwROsG6rrxgi0lrp5kpFhsDssurV+BpUd?=
X-Exchange-RoutingPolicyChecked:
	DIiNWdH2MwJghmqe1h/4IcapP+gLSvkr5YGxhEyRtzOjIvmGVnSHf9ZwI79Yyi7h1LDcKwduZSjz07trdpsqikgmnHmpOEG14e8pMi2oRybzahqZAAXjSJV9pOllogUlDtYSfL9Qyh0jmX0+C4L0qVB/dMRdgFFHa9eWxQjW1j0FL49XFnLtI3BPFd3c2XC3nglvBy2hA0MaLl1cTM7fqPZv3xBfYPhqLewYRR+InjURRM4uwN73KL9XA/xp4blvgWNcRJvcPyA6/Y67shXkELp6Tb90BeKkYCKlZBocrMjtiI6cRszYT6xWgLZPqJG9E1CANr/VIZDezirvJhNj8Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2qE65ji3uK7gQ8D+IVu3MG4A+lkevw76BSjmAjKxmkoeSopp9WjktS5c+pzC9CRoDyi91bKdkK6mNpt0SgHndEHQqiAhX/x/qxvNinKw19a7YMBuYAfhzvcPOfoCa0mxnnG7ucbJ5N7G3hhEXPA4+3r9gVhm8tuCDh9C7/qrNWTggDpH0CO72vC9zB5aaGcsPrjxlR5Pe5N0W9/5PEbtaUEqe67Zog8gP615UzQCmnd2KxGSWEkuKkiD76hsMfJN77wqGLRwHHXLlFfJ+idgOxrUNHkQVlEnzCzclb8OrqPAvWMDN2nzUOggeFHjSQUx2xDpmK5A6j1jUgxOLGwbQJRkGxz8B+Jn8rdnQGvxY0NGbOFDshNb2f4qtGF4F2leHKauHFvnGcxJDWFZlTSV6nkTEh7isX7LczPt9SEB6AVGH7QIMknDhbvrctV5lbQQ2s4Yaa2ZM0LpKNCYIbfRos5FHneZGuD8igal//P3wpqaICZcyYoE4pcJyudOf3768o5kuOKAMawHdwbAaCTema4GnAA5sleniJ6DAfxGAHNr/B8E6YwTl1FbnjHrhSGGEkC0biyiS8c7lyMsbPnlpYJTVFrMuREA1LR6+Nc3vyI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d55c2cb-1871-40e4-8d05-08decd2a78b9
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 11:12:23.2353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sm7soIGrBaGerFeju8s1nd2P4nnMTlCbFQUwXe1bh7zVVOmfXzlNUHpTYOPiUNyjEnPfCVP8BaHXuTkkdei5LmCtS7/kJC/V2594pahmUuOodFVJ3YNniawzJdKhN0SR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606180104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEwNCBTYWx0ZWRfX1in8K+aQuAtW
 YRoxC02gosn/sgwGz4zR7YeA1YVlGOH8aQxluOwOldi84aysEili3meUuOGkUwHi5iczSoIUUJ0
 w9+copdDUGxthP8kl1aSvF2lEPoahyVIALBWxPzEKnWuF1twQEeRiIotjkAwA75h+TNpEbTeE/o
 1FjVobGG3ul25wI737DV2s/XuGfAb8pI6NkTZP/xtueAkVFx9HC3VikoCFFU5h5k6wprCkPfamp
 lZ/0b65hQdyNDb+Q7gQ3d70uuu4cUOlOafKJJAeAE1VQa/o0aLyyI6btPVfLPssCBHeL/PsI1mU
 UtOduOsPbhRg7EdSwMdyuJZHHFBU/uCVaMcEexTc+Khgk17anJUssnfXhKF8dWiaBwFBLBmLxCQ
 E9R0tTBZBnAgN/FduG7SqvVKx4aitOgoC7bqbr7haWCOvwIN3VqI4ZbBp0FPQIwIrpCdD7lEYLr
 Ph4Ls3w0RlEvLDf2PePaLCX1zauWvI9ycUhvHNJo=
X-Proofpoint-GUID: jgOctSPTGzgKIYho7IdrsHZtsElgc161
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEwNCBTYWx0ZWRfX5ecBiaLDvAB0
 MbT6bzbphKNQR/xj2sudIGsIbPC5OwqgkKq4b107voZSkkBSmHT4/QEnD6qZ48zRmSm87EQpKlo
 Tm/esVaGPeKxk8G/WduvCHdH0mUz//JC2MZez0QcO1gqIFlcLmLd
X-Proofpoint-ORIG-GUID: jgOctSPTGzgKIYho7IdrsHZtsElgc161
X-Authority-Analysis: v=2.4 cv=UY1hjqSN c=1 sm=1 tr=0 ts=6a33d29c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=iox4zFpeAAAA:8 a=xNf9USuDAAAA:8 a=ag1SF4gXAAAA:8 a=Phjp5zwpNHbUTrf6NDYA:9
 a=QEXdDO2ut3YA:10 a=WzC6qhA0u3u7Ye7llzcV:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313

Hi Greg,


On 16/06/26 20:30, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Borislav Petkov (AMD) <bp@alien8.de>
> 
> commit affc66cb96f865b3763a8e18add52e133d864f04 upstream.
> 
> No functional changes.
> 
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> Link: http://lore.kernel.org/r/20231120104152.13740-4-bp@alien8.de
> Stable-dep-of: 7c81ad8e8bc2 ("x86/CPU/AMD: Rename init_amd_zn() to init_amd_zen_common()")
> [bwh: Adjusted to apply after backports of the above commit which actually
>   depended on this]
> Signed-off-by: Ben Hutchings <benh@debian.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


I am a bit confused with this, this is a stable-dep-of something that is 
not being pulled in ? Asin, 411 is the last patch of this series, hence 
the confusion.

Can you please help me understand this.

thanks,
Harshit
> ---
>   arch/x86/kernel/cpu/amd.c |   18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -1111,14 +1111,6 @@ static void init_amd_zen1(struct cpuinfo
>   		/* Erratum 1076: CPB feature bit not being set in CPUID. */
>   		if (!cpu_has(c, X86_FEATURE_CPB))
>   			set_cpu_cap(c, X86_FEATURE_CPB);
> -
> -		/*
> -		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
> -		 * Branch Type Confusion, but predate the allocation of the
> -		 * BTC_NO bit.
> -		 */
> -		if (c->x86 == 0x19 && !cpu_has(c, X86_FEATURE_BTC_NO))
> -			set_cpu_cap(c, X86_FEATURE_BTC_NO);
>   	}
>   
>   	pr_notice_once("AMD Zen1 FPDSS bug detected, enabling mitigation.\n");
> @@ -1178,6 +1170,16 @@ static void init_amd_zen2(struct cpuinfo
>   static void init_amd_zen3(struct cpuinfo_x86 *c)
>   {
>   	init_amd_zen_common();
> +
> +	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
> +		/*
> +		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
> +		 * Branch Type Confusion, but predate the allocation of the
> +		 * BTC_NO bit.
> +		 */
> +		if (!cpu_has(c, X86_FEATURE_BTC_NO))
> +			set_cpu_cap(c, X86_FEATURE_BTC_NO);
> +	}
>   }
>   
>   static void init_amd_zen4(struct cpuinfo_x86 *c)
> 
> 
> 

