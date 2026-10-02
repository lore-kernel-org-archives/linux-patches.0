Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CCB3B5837;
	Fri,  2 Oct 2026 21:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790976222; cv=fail; b=AguO3rry6tPKbWHoTVb5iSdH4jQevVgeiB0l99AU2JT55Wfcij5KN+L0hnPaGqFlstb0kYz0FklirZyf1FexBrjPy982RecIIoVIcoxTjtUR/AEJKJLJrqTs45upDV7l+g61IsVGNPaMEVRDjlN1o8+K08CQQ/O28po8toqtM8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790976222; c=relaxed/simple;
	bh=B4wznwKxkJNMVzZfrvh9lox7fY1prQEX4JxCvfP614Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Twc3K9t5C1l0Gr0CDC2p2lbaTKMiSUBLsWGpSwoRMnbJ59w4BjZZy8tmnZ1M/Hbp0kgJFizT7Uga4XYO7U3VzIsSJlvJUTqQcXc0HEOx2g8f7RspYg5VLbyhnfLGdkBh5DrcQzN3nYybszC26/JSPsAWcTSiuKPjgTMjID2OFBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kMGuOH1B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DxgNboqC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kMGuOH1B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DxgNboqC"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692Ebe2i4070641;
	Fri, 2 Oct 2026 21:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y49i54uvNiVl636vquz6oZne6t2iuZgWXTfXdXId2Zg=; b=
	kMGuOH1BrZIhgSO8YWbio+6riAUJRGK/hhtzT1/D9L8ViZ+Knj30c8CEBfqTY+7h
	CqA4ACcvCqwsXb0gw2dKmsLXszNcEwMvC/FSJTqOYqJ3wQvhu9eM//wiYcTYq/gq
	/J4pk2SUARGfCyLeq6e0dTVFkLF9U0yfYuR5vM7teIgiCNGe99imn7+ZYn63YRgJ
	PjTJN98BtTRShPHhhk3OPWInQR7eyT7dAICWzco66EdwmyzSAEfILlHvHfdLVmh6
	ULMSXbqalet3XyIoGy7BVUY5uiegrxvPqGsNwZ6wdWT33nYOWy5MMVXVQGdka9tj
	Up3ab+nYJ+jE5C1c8+xPQQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4y9mtek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:23:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692LK0El009657;
	Fri, 2 Oct 2026 21:23:35 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h2f6fs88j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:23:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TNxmdav7plAAnO9v5BdBYzqF74CjafmPHk3O5htlMyttp/iLGWtmShRFZCV3ujrsxc54cVZ1FrTVSxIAot4yi6s2dMAFh51hbcXvWFeKYUF5L61vLgsbfPHF1GOd5z3Vh+/3NuoiaWCzQOjGT2kHckUdbCxVlPSHjBixyEMZQOFyOvKdZu0JIf7VKDlX6geCetVNI72H6PGdywI9DUYEeUiOGC9mlB59q9faB/gQkf6rkCO/oFFyeNvfqpkewv38MofkFbP30tPwm/bGDIEy7smTSUrdtXFWIxzJNc4nLeQIUFW8VZoQnb0WSiBMEymo2WOgVzQxyXY27PN2BayI2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y49i54uvNiVl636vquz6oZne6t2iuZgWXTfXdXId2Zg=;
 b=xDq+J3dITfiv3Mn2cEqtYqrONQOel5V3u7nDV2z/RNRrztNfIYfHWcv2Mf3khy/NHudGG3mEFeqeg2dQCdkdFaZT7ID0gn7cq+Da8YiM0egHPzD9u4NPM36BD9ZapgjbKfqNtrVORbyzrUmlZt/d0uj55TZOmPXaq3AKt7v6fILxq5m/PEbwWIaIYWaMJ5bGMbLi+Dtd/DGguhlIIsla+d1eOYov0HNKlxGyFG+h+G0rsItTmxCr9vGoX1WcIOfsF5+o+CpcsQaOANNzXR0ht5EDjFxr+nQdfOLt3kHiR7WTKSUF51t+SZyue4+2+AEIiz5URtuvgp6G6+ypq9LxQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y49i54uvNiVl636vquz6oZne6t2iuZgWXTfXdXId2Zg=;
 b=DxgNboqCsg68af6HHccu2fL367bY/kNFJFXVVOvwIOCbduuGcga9RsNT8i3Ph3ewY/N5Zzz0iunjjmbPNrzrvHuG4zEf0P3Aa2wOUVKP72xvMdavva4nP3psMzZz/kMz1ee9/AwFhawrtW7hn04EtWSYgxbG4HtDSe2js5tmDqk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SJ2PR10MB7788.namprd10.prod.outlook.com (2603:10b6:a03:568::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Fri, 2 Oct 2026
 21:23:28 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:23:27 +0000
Message-ID: <5f9e94bb-0d5d-46fd-8269-e249f052fccc@oracle.com>
Date: Sat, 3 Oct 2026 02:53:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 092/877] neighbour: Use rtnl_register_many().
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152416.722458210@linuxfoundation.org>
 <d26d9da3-5d91-41f5-9270-863f34c772bd@oracle.com>
 <2026-10-02-1-daily-reply-0007-re-neighbour-skip-default-parms-6-12@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <2026-10-02-1-daily-reply-0007-re-neighbour-skip-default-parms-6-12@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0231.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SJ2PR10MB7788:EE_
X-MS-Office365-Filtering-Correlation-Id: 33e940a0-bdc5-42d5-3609-08df20cb6641
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OcoVK/BSpbPOF1BJBLueWT5qOx2eivAfgdmX0ypIEG1ZGWShoxj0D0s7OVJSSmrUptQe1u0VMTom58fgm+bLyKYux2gzaJCqd/way0Tk9nnhldFTe8hXA6BRup5QHj5jfRUkDGWA8pniC8CxDAnoVbuLOzzUt8T/6soB4n+cMP6TfZU8H7+Q9PRejo6jlJFX1leMgdNzu2IQVhgZYNzSJ2pjOEGK2kM9wsGhf9+ekMIREx9OKUod+gY3/bi3MPUpsBwce10SolRAK/0AZUiC4UMtExKd8pZiqD0CIk+Gjh3rw1Rz/risglNqNpMfZ6mqcV4VuEGKGvaP4R2cF5oC5rerhJ9/ld1Frcm76BT6h6SgpCePKfUEv4hss5bcZ+os7xA44k0KZtljZ0r5BHvb/ioydRrvTb/mvApJP+EGvdQ8fPTC4HDumzzkkw3+evNM41XspqbpisbJ91lhxny7rXMjQaUZejAqsW8k0CfoKgBEChbGernrL80R+m3plFo8CHRM/303YCnnThdI88RmnVcTyIKzEgNKFDUSGXY7yUdzU3C5lBlGNdUbUkPYh7G8mOqdvIud6SANs2vMEav/Ka/SNJeh9yQvDLrGim1fegWLj67QhJM3HX9TpFCQElchSCwEp8J4xwfT9EVXZQi9I8f4HQ6Pg8F6z63qq8vSCwo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2dSWGxGcENBd04zeDVOMTVNbmZLOVZScFY4UDU3cmh6S3BLbkIrdnpiOENN?=
 =?utf-8?B?dmRGTjc1cmkxUTFSNzNZeUYxZmFjbjlIem0xeWZQc3c3Nzk5K2N1M3p5OHYr?=
 =?utf-8?B?aVBacS9EUmVVUTBtRnY4MStlRG1qOGlYSFVseFJubUVqd1RMaEFGYWNKTlB6?=
 =?utf-8?B?Q2VEOWp0K08xbnR3M0NEVGZyc2dBUEErbGJuSVg5RnRNeU1kRjh0VjZVb25Y?=
 =?utf-8?B?SkZGSmFTeklGbVNiSmFpbWxYNWFqLytzTW1pdWpyNXpxV016eDk2Sm9CUnNH?=
 =?utf-8?B?MzBLck15dVA2MXlEWXhpdDJFTU50VmFOUWVFRTNuYjlzaHJxVVhEMGpIbjZz?=
 =?utf-8?B?VC8rMlgyMVYrWTZha0k2OVRockVTdm9OSklqb1FMZFl2U3Y1WXgzMURIUjg1?=
 =?utf-8?B?V0JSRnBWK09uTDFrS3hPTW1Uam1ZRjhOd3kvU2twanJ5eTVCQ0NDQ0wrYkNG?=
 =?utf-8?B?R3hsQVRncXZ1dmMxc3hUSzE2QnltQ2FHaHQ5c0loZnY2RFU5MHV4ZXNjWkZY?=
 =?utf-8?B?Y3FaY09oelFoTEtwRE1UbU1lbVdLYm9JMlZ2ZDhHb3BVbEUyaHVPTEpXbXh4?=
 =?utf-8?B?QUxBUnJRZk8wSU13elYxRlhhc3QveVJSdk9ad0hhODZUc25YN0pUV2ovYVFm?=
 =?utf-8?B?eTEyOEh6RWFiNkx1QUNMSjR2TldwYlpsWmxpWEZ4WDJnL0lRV1JkYmtHajIr?=
 =?utf-8?B?VWYwdWJXRUpnMm4zc0V2MW5NZU5PY2t4SXhtSXJKL0xXTWxiUWc3SFBKY2di?=
 =?utf-8?B?YjJFYVUzRThNN05WL1dtV2kwYi9EVDlicWRSRm9VcW5BbUZKdEh5MjJhN3NZ?=
 =?utf-8?B?OXUyZkE4RTV5Y3htQXEyTDZrYU1TTzI2OU1HNEl4UEk3a1crL05vS2ZueTNR?=
 =?utf-8?B?L3RqNUM4VFhvMVp5bnpCNVdWVklhNDcxa2tNRzZFZzZvRDE1MjNiMWJ0SVpq?=
 =?utf-8?B?OHo4TWhCaWh6SmNhQlZUaE1DRFM2ZmtoendXUm1SMXo0OXloYW1MSjdQUnBh?=
 =?utf-8?B?K3VGa2xBWGMzTlU3c3RHTVNzSSs5OEhvZ29VSTBhTU9JTVZKN1M1U25yYXZP?=
 =?utf-8?B?WDYxMnRwNkwvaUx3S0VmRW1FdXFDMGdXWlJ4UHhzYmprMkkxdytWK01HbGh5?=
 =?utf-8?B?ZmhzL3l4RmxSU3ppU1VSa0NpUGM3T01sNlE0cGV6NDJrVjVQMDJHdjd5QjNw?=
 =?utf-8?B?YXVnTmFEY0VmY2tIVERCN0JMUnQyNXd0R3MxcklXa1ZnWjlWWkE2ZXdtNHhB?=
 =?utf-8?B?Wm5scmZiOGxkamNlakRPRmI4bHd0Zlk2dzhGUjQxTDRvWkdSdklFUkNJdXpt?=
 =?utf-8?B?Rm5LMUFCQmJHK3pLUmNKbDFtSXlEc3ZhbFFvOWo1QnllakdCSnorMExFaHlM?=
 =?utf-8?B?THhwWjkvWWp1aGZpUm9VWnc1L0V4ZUNWTEo2c0h2a2hWZnp4WGRPSjN0Ulpl?=
 =?utf-8?B?VXJkOGYrQXJ1cUtxWmpsUnVuQkZmM1VxYkk2N3hOdTZtUWhLVWJzSllxTlBR?=
 =?utf-8?B?OUg3OG5kUkM0L0hSdUQwOFcrTDYyUzl4NDVOdEpObzF3K1FhVFRNd3l6bzRT?=
 =?utf-8?B?WWpnd0xwcitNT3plUmZVbEYzemUrOURicy9MWU9vazk1aXh3V3IyUkF6aWdl?=
 =?utf-8?B?VTZ6OTQ3cFFCaXNicHFuRDY4ck5naU9Yc3FNbjhGeXJDa0NTSmJyNTRWZk9V?=
 =?utf-8?B?ektYYVZGOUpwQkNZaHlPeFVrTHpUNkcwZldsYjdaeUd1ZjQ1TGx6aU14N2ha?=
 =?utf-8?B?Mi8wenJNVGNSUGt6QlVkVkJ1MXlqZGdWeHpXaXFFMnBxRU5aZWxqRmlCY1FU?=
 =?utf-8?B?dmp6aFRKMzlZbDJoelIwQUVUZTh5d3Z4ak9IVU9NZU9VRFk0TVEzZVEwQTY0?=
 =?utf-8?B?NU5oOUZKN29jTzJKaU92QjQxMGVaSXpMcTQ2cGJicDNvUktYL000S1oyVTJ5?=
 =?utf-8?B?UXQ3anh6U1ltY2Z6eTlyVVdhamxTclNlaEw4WmdsZjFzRHJxa0hTYTRLYmpQ?=
 =?utf-8?B?NHp6OG1PM04rNVR0OWl6Q2M0YXl3am4xVFQyd3BUcm1NRnpaT0xDOFJHbzFt?=
 =?utf-8?B?WEtFbVMzZFR1WlZUaTlEMWFEVmZ5aWxQdXkzdUN1TEo3OG1UWndkVUNYK0Vn?=
 =?utf-8?B?SUtlN2YzN3NHbkpieXRZOXRiYzNLVHBXREdvS3JVbFJ5Ym9YcmFIZVU2Y2VS?=
 =?utf-8?B?Q0JPN2VzS1FvdUhHTUx3VVF3OVVUWVNpREtlRGZkMDJ5WVdVdzhobE5yUG1j?=
 =?utf-8?B?WitIU244T3hWaTNVSkdQV1BsTXQrRFdmTVI3Y2d0Mitsa0JRb2FIRkVBRnU0?=
 =?utf-8?B?dm8rMk9XNmRpcmRHV2pmWmppdUdBcmVnWXkxbTZoeFJCWjhGSXI1S01xVjJW?=
 =?utf-8?Q?QXAh5T1APNSbWF8IQCeXECZoa+qbslrpSVhmZ?=
X-Exchange-RoutingPolicyChecked:
	hJ4xDt85ARPwHbf705b4jxxYe0wADOYCTng0fD/ZW9OiH8o9P49luNPQV9pfPhJmASVzAGCZ7ZjNGmV9C1MQdgyM531MOMAArSioCVh1FggsRudtCxmuw17yUFKrmQc0yLmPW6KSKeYu5ivWATyhvgKWYXtvVpJ7ZP5UpLoGaoX1lBSzaSK6g/EdG+6hHa6/sAoUjGPNKHUPiV19wdepIegERjmd7ySqU2eQVwyPg7VJ7IRVXogMsmPp3SE1Ph8aHzq33b9wvZEt/DOXXshqHac1tS4BQXEwXHxGCYkal0VNgWGKXnh2oxYnS8eVwh05zqlAkQpnfkyUSr5+JRqjZg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	goRlyeay8WvlttRy43ii9tjGv0Z7b3DtT/GB4PYvrZ8u+X9UdQUp1BPTw3ARcHapt0GM87WLiPeZNQ6QbiARULEx9wqZykA+9hS8c68Bm/Q/9keBw5X2Ooc0wxdIObrah2l2bSoKzxQMnYFU+1SOadGkdNvfEaCKFdLGsQZPz7raNQlIemLZiqy0XHyO/cxgUW2kXeRZRCCd3yOhoL5za1ewVZXZ5Dh5VvekGdXP+hLKFoYBjj+lF1wa1c+qPaAc9zbM3hv66jYdP4UA3t8uvoJG5IDWT5EznwCQnk83ywndOcujIMQJDOjFLoFkH676MPnMu9nhBGGKdQf1ozjevarvH93M1aAUicf+HgF3f49EAL0ji6KVeQ3iTC04XQ9n5IZYM/B3ddpk1FbHQwZFvp+b2U46G68e/Td3HNft5flzFvCk7STMbZq0ltLPinL2znEB2zC1R8NrcP7o9E4bHxzXgrz337E3zQ+sKB+5sQBtJv4mzXnVRXQ66OHZr1biM+1YX/7zBKfsFgr64rCLxV+vTsUkqT2Ait+bJlnpGtw83428KRdCGLnrxl66OvCHwXtFQgGvEWxD8Zdcg5r85pcspfzFJKWpJUAGhBDOTLg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e940a0-bdc5-42d5-3609-08df20cb6641
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:23:27.8845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/fd2GtwiHiFUFT0Z/TmTC/8P6NoiZ0tvDKHhM8RiqifdYNcmqvVC1q84CccXKemGAJ3gKMhKNi/b7BTfjbouA7yMplNQ+esQXGDN5DlfHtBxNE/6baGV1wBySNuy3k3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7788
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=906
 spamscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610020085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfX9leZvNKVTwyC
 OgjRzF13ug9B0ifqjG6Sx5+ccV+0VoWTAN2NFb+QxyKgZzbmppige6jDz7DtOgTsAgVM99p1W8w
 ljMY4ZDYwYMab6S3Fae18fesGN2xk+4X+wAuZKjjG4BTdvL1aIfx/nrRrV3rI1gPn74GdijFReF
 yzw41aSrzrLaj8qhNy8FUJ2oAdCs9uw5pyX3QGPjUtvk/P+pHatEqzrE3hezJ+Ya2qgU7PTCroP
 +yVMKi5KbIWMiY+zN4Zjxx1JsWOr5p0C5TEV+xZ1REnG1T4tWmracIlWhf+EHsOEbFQb0n1hReb
 eFA3nodbUvd1PY5CUTBYRC47RbysXomrneCzgaVeuGFLNLDLEWF8qfRcfSrugiWChyOafNJoSAt
 z6VSnIPJltp/e39QIauCMX7jWTcKJUHHov+psWzCrOiJ5NNHasdBUPAFKqo3Ga7D9POxkgbwNDY
 ZdhAumzY8uXEtbyqNRg==
X-Proofpoint-GUID: I52SN4nWDbcKXqCJVaTgNcMCyGynKkro
X-Proofpoint-ORIG-GUID: I52SN4nWDbcKXqCJVaTgNcMCyGynKkro
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4NSBTYWx0ZWRfX30Juv17XGCjK
 v/Q/CFL68F01THpkMHFI6uqh1kBe0lii7+bp1FLzbGjcuaOEbalADCAnNuA42P1dVcnfRij0v3h
 mxJ5WJRQrN3CEtvR9RlUG+mCLfCIXRyyjy/k7dRFClbKik7SoPhh
X-Authority-Analysis: v=2.4 cv=IuyL47/g c=1 sm=1 tr=0 ts=6ac020d7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=-UlKSLMc9x9OKeqU8cgA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22



On 03/10/26 2:40 am, Sasha Levin wrote:
>>> Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
> 
> [...]
> 
>> Lets drop this until we also take a prereq ?
> 
> Greg dropped the series. I've queued the neightbl_dump_info() fix by
> itself for 6.12, thanks.


thanks Sasha.

Regards,
Harshit>

