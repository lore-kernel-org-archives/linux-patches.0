Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F7640D594
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781899397; cv=fail; b=fOmXqqRkvm5NpL+94HMk84B3eZH9ciQdJlJBjQ/kLE1cT5Sh1bpYrdaWkQMXNGzynBhmEFLTozGh/HHqri+VfHC0cJeI6g8b+Qa5v68YDcwYxZEJU7o6eA3zQ62vnoV76nKjyd2gzLwCStge6JgzLHivNvc42AiJq+WW1HOzHiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781899397; c=relaxed/simple;
	bh=+tQjvk/uccS2qo218KBWFqPCrGtcWh5tCw/HStbeJhw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q8DTj9GkD4R7t0pa1msNIfP3TgB5veCugQBcI3obVMcAIl6WQuUsoDe0MYJ9cftgvd2jRfu5lEaVga6BH4DYqjsPHWEo/UpNgPZ5mXHMDp1/yDRXDiLPeotKTnPXANiaLnqGzBgTQLYtoRLj9e2yGi54fIpuIM8byJoWbyuazqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WvpcUaVd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0SPsy/jL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WvpcUaVd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0SPsy/jL"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65JJu6pp3658150;
	Fri, 19 Jun 2026 20:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IrFZzCqGu4qzs4bRUHGP0s5lZj0Y2WHZ9rOeTctL8ck=; b=
	WvpcUaVdckGk4LzXBMSfNuZGt1/mHXGlauS+6mLy2JhFhJplELqCZPZYUamO6Fct
	xMSX7dRAG+/bpjFq5NlIQW7bJMMYAbW/Go9KqJjjbRXgraWyNVjZGYQKsFUvpxNr
	w6eEFNNFfaYyoB16LFBhb1uePOpPFcDsv1hyxLfRtG6yUH7u+jOewpN1l9dUo28g
	M8049lkdc4AvExl96EPE/I0h7h7IMH+rayVdfQFpHON+IchMC9LgFjk0cdyBYTKH
	+W7d3s155WkdSJ8YXbrRJiF6RVMu6ON5Tvygdn6H01sxAtyratQRctoryq/7WWID
	sZ3iAlcmPOfuKzFI8gxP7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euegd4kg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jun 2026 20:03:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65JK36DN019178;
	Fri, 19 Jun 2026 20:03:10 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ewa7pkdfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jun 2026 20:03:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nROJqLy2Gek8TnAztst5cNdJ9MIwsQAHYkzEOkwf91YK0h6navzYIKRiUS4xckA+HyTHy6TgyVTfs2QeamSPHo5Km1ouSfkWWS3Qgl3a9Z0PAN7kL4rxwJAb/uPAq1g51KfawaBFU5fIjJbAMl0mTXhYWY84Tvcsr38SLdffhpB18hN0ew6s+CkZfX14PY1UHuvoiOP1qjtYmhoULoFYbKQoFjKjW9XvGbgfOqAGGZYOvP2Min2H9M4CQ0sX54Q+wZ6/GhKz7FWFmB2LQe72disa28Eqm1SWHqm+I+w790D5l+dQ+ih28rdJYJlVaMwxO6AuIVHRsvisMslMFXgevA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrFZzCqGu4qzs4bRUHGP0s5lZj0Y2WHZ9rOeTctL8ck=;
 b=yhpfbnlwLO6zuV3FyhuC9JlIqDQ9S7I+hftGQJVm6Aru1t/UdME1caRsEHiEA3BAE2p7T7St9kLg1kPaywtPn6DhXDYTfuPVXArtSVnFJZMh4nf6KJPm8j6OeFMYN5mETHIJ2DVBUeSfe1FRqjpIe6DR1jWQ+WzZqzuGl0k/OKxfatvXxakhuBplFXRwWKDPem4KVGYdPxzBnav5EZvcN9SPfifgRqtXp3c7++rBQvH4jcX/YAtr40z3MvmqbbpNq7bVr89iCSWEDvjfR8vXPF9gsxLuWSxJ2DASkVafvMywFgGRnwaRsjmOw8TDsH+QJoQgMCawaNk9HFnsWpYNrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrFZzCqGu4qzs4bRUHGP0s5lZj0Y2WHZ9rOeTctL8ck=;
 b=0SPsy/jLXc2Gv79GlZrDfIdzkvZMeBqHPZZNTD11Vb348DqV6ORz7QjQ17kM/bl3q5yMPiXryaS8XnKPFUsN9sM6oo+ybj+1x9fqll0ytTfhrs6fMSaIP4tX+6ztNBsPPN+44dKW6F9tUNVg2c4XDhhvI3qJpsYHHb9wgSPnl/Y=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN7PR10MB6305.namprd10.prod.outlook.com (2603:10b6:806:273::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.15; Fri, 19 Jun
 2026 20:02:56 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 20:02:56 +0000
Message-ID: <6b5efda6-50ad-4f85-8e61-7af4ee21ed99@oracle.com>
Date: Sat, 20 Jun 2026 01:32:49 +0530
User-Agent: Mozilla Thunderbird
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 193/411] netfilter: nf_log: validate MAC header was
 set before dumping it
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Weiming Shi <bestswngs@gmail.com>, Xiang Mei <xmei5@asu.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145110.984893387@linuxfoundation.org>
 <167562b4-4472-4ead-a107-6eb83275825c@oracle.com>
 <2026061924-treat-enjoyably-08c8@gregkh>
Content-Language: en-US
In-Reply-To: <2026061924-treat-enjoyably-08c8@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0248.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN7PR10MB6305:EE_
X-MS-Office365-Filtering-Correlation-Id: 03ece74c-79f5-4535-02d3-08dece3dc10b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|6133799003|4143699003|56012099006|5023799004|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	+dsJO4V7hPKD/+mIwtTyH1BJRNdW0b7Odz4APe8DiAzDxkrsF5rjvnOR38LHXSjnKAqOegITvGLBOpVDbqjvth1WQFV0ClGn6eaKhAkIWeGg8z/cGU+OSmI4R4o0fD0YskJ7fdMGvvRYTtTySjeJEE3iZelNxa3lPjj5Jd7QrTrlprgVDnYd44cM81y3DcfMZ+JGyBAbEYOlynftx9CQLzZ1Ylru2/HgrC21qsbVn1SO+IzONIwZadM9rrklAsDNG7Lo/a12fhdywRP+SiuUPGi2ltwi1pTHuL6uzwNIYrgD91084mxXSe1PIwCmAeOC4JVNj2OM3E3to/iy6y5hxE0BKQg5hwhcKwkLQ0SaGdRzBLKrfg3GFZ1Y7MLxWXwajCut2ZiIKJ2+P8Ll2MFXcUWC742o4AcSx1REY8gw5niZpelLRlL8nb85s0YxPj83coaFFSh4NBk6dVlPhHh3KPMC3i/1Dbmvr+otd9N/O/irQRzwf2AMJ0dWvz5guBM0RqWN+jdx8CNewhScDwhQ6rbvMWDifc6Ih0JYS+hOdIWbzEPGOb8hftYwQFXfXSQSL1zHJlmuBgtD4bJVzym73mjLVBo7SavH40vYKMXQYQsc4KoqgCwnIH7bfO6YAb3g+cxQKgQWKGHXhaucHWXNxxMIRxARurPGLL1hCbkvpoE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(6133799003)(4143699003)(56012099006)(5023799004)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2ZGL2FJWjVla1FJbDJHUitKWTFRaUt5ZUdlbVFTS1FiSlpmYTU5MnBpUGZ0?=
 =?utf-8?B?SDd5WnlFOFdNTGZwa085eXJRVlBWUW5zZG9uRzByNFRXeis0OTI4MVB0NCtw?=
 =?utf-8?B?M3ZqL1ZESlJVa0NiTlNxTlZ4U055RFF1ZjgzVnA2UEtqTTlIV2JiR052K0pp?=
 =?utf-8?B?RmRBZ0lTQTNtSEl2Q1dTYkZYdmk1VlFEVzhlQlZ2VUlUQ1ZHYW55SzE5anph?=
 =?utf-8?B?Q2d3SHc0S3oraDBNYU5kWXh5R1U1RlVSOUJxL00yVk5LcnN1SFhtZzkrTVNo?=
 =?utf-8?B?K0tuZTRlZ1BhU2c5L2E0ZWVWVlE2eUh4WkNMWGVxWUxvRDJaWUFLaktPLytj?=
 =?utf-8?B?VEl4SkVXK2JFYlBxQkZpeUxWd1B6ZTZkREFSdUw1YUdPWFRBdW1USGpHTC9Z?=
 =?utf-8?B?QXRnVVpEOFpnaDhYNDA2bWNjU0ROVlpVK2dTcURybHFqMjZLazNQWDRmMUxr?=
 =?utf-8?B?TlFCckd6Sm5Hcnhab2Rsc0E3dGVYbDBFamU3d3BVTjJ3d2dmSllvRUtrbHEx?=
 =?utf-8?B?WHhOQVlISUNxb1E2MFoxcFFzeXdJbUphWHZkNmdGbko5Z0Q5K3RHRjJXQ2E0?=
 =?utf-8?B?TGNNOUsxMnZyc1p4L0FkRGtJNURGUEtPZ1k1M2NISzhyOFFvc0RVTlRrMmEw?=
 =?utf-8?B?K1RpU2tZbU0yb3cxV1g0QXZIczJodWs5YTh2dlIwdzlqc3ZWbE5YYWlNVWYw?=
 =?utf-8?B?L3ZuR3Z1V285cGxvLzFUMDNLd1BsajN1NzVQZ2o1OVNKM1M2K3A1VXNTakwr?=
 =?utf-8?B?ZHF6aEM1V2k4cTJleDhlMjFIQXoxZWV1c3BjK21SVWF4bW5lRzJrb3BsL2R6?=
 =?utf-8?B?Y2VqYTlFQWlYTTAxN0hBZ254MFZJUHpoZVRrZUExNWhzaXJFV1hGQkUyTjdK?=
 =?utf-8?B?WnBQSkdCVzQ1L3RNYlJsWlNRNUFzZUdkbnhPZDBSR3Q1OUlKdFU4bll6bzFD?=
 =?utf-8?B?VXBUYnpMWnQ3RTltMjBqNWJoTDQ4N0NJSzRRZ3ExVFBNU2tRajVLc1Y5b29L?=
 =?utf-8?B?NDMzdnl4WmFxYUdwbHl1Q3RJREpIcHhQVWVkY0pMRUpncC8zNFBBMnJxSkJw?=
 =?utf-8?B?S3hTcnB6TWJQOE5lUDY4WnlUY1drQ0lYZW9sS2Q5TXlaL3NrcVJjL1dFMmVQ?=
 =?utf-8?B?TTJtMW82K3RQazZEekJuTWNCQU1uNUU0ZmhZRUc2Wm5nbllWc2RBWnZ5MC9H?=
 =?utf-8?B?dmJrSGdsM3JUWDhjb2dCMFIxU29yTUpYZUs1TkdxTXNnVitMSVZIRy85a1lp?=
 =?utf-8?B?eDMyMWtoaXVoaEdBV0FNd0ZVcnAvMEkwQm55TmRvWjUyNVdrNU10VENtdmo3?=
 =?utf-8?B?M2xoZnBQUFBvcTAxakxDRitPVXpCZ1h2U3dwci9PTXV0VE1OOEo0SXlnWjVK?=
 =?utf-8?B?b2t4RkxKQ1NuNk9ibHlFYk1mTVRubkhBMlFtUXRNTjFUUVE4TlF2NVNCaTQ1?=
 =?utf-8?B?bWhOVmVvV0NlTEFFY0p5TjRMbHNkS2dQVzZGYURxZTBONnlwdi9MVkJEYm9L?=
 =?utf-8?B?MUh0b0Z4WURuRnZBVW42SUpkbUJEaDdlTE1FMEdGM1A0VzFyREdDN1NZWnFv?=
 =?utf-8?B?LzZ3dEo1RlVZbjRUYTZSQ0YvTE5hOFd6L0drcW5KSTdUWmhJTjJYZnZ1YWVy?=
 =?utf-8?B?SVdnNWRmbkhhZVFpeFpndmJTV0phSWlPVkNIbmxKQjRKdUpEN1ZPS2N4amdO?=
 =?utf-8?B?cGpOSVc0THU4anU4djlDNDRjeGJyOUVHMjc5WnEwdVp5TVNqNklhQmt3ZWw1?=
 =?utf-8?B?TzRpMDhYOTEwYm95TkhQVW1URFJFN1h5R0tVNWhvYVpIZVdXZ2xwQ2d2NUdY?=
 =?utf-8?B?VkZPemtrc1JJLzREbmdJR01vZWwxa2E3VUh4emU1QWdxNGNVZUlSWlhVdDNs?=
 =?utf-8?B?NDYzZVM3bGE2djlhV0xzYTdPcVZrK2pzZXRuNkF1T0FKcitDTjZ0MCtTODNh?=
 =?utf-8?B?V0NhU05GK0NhMjNOZE40S3ZMZDFBRFlIbk9lSGR6NjdlNXhOSVpYalFjZE9U?=
 =?utf-8?B?eldsQlJLZ2FPMzZRbC9RWHNmSlB6dFBEalYya0UwSHVHNkNCSk9SZ3NtR3BX?=
 =?utf-8?B?Yy9VK2cxYW53cmNod0NLbHJxNnpJWjlhUDhmVHJSTmhYYzhScVRIdlYxNnNE?=
 =?utf-8?B?N1lRV295YS9wRXBvSXVjaU9qVy9uWnhsN29hN1NlZndOcVdoYzQ3TGFla0lN?=
 =?utf-8?B?ZExOby8rYU10ZHVzV20xTzFLR1RwYlZFa2ZtbEJlMVFKazI1Vjd0TFFOY1Jn?=
 =?utf-8?B?dmxEUWhlR2ZFS2w0ZHR2MnpZMU54dEdrSENwWnRoOWdFRjRpTEJhbVZhM0NH?=
 =?utf-8?B?cDhQTlZlajNlREQwVnYzUVdaR3pWNnp3QStMUzNwWEJTMHFXMUZ6VS80VHZ4?=
 =?utf-8?Q?1jMzA+M1l6lBO33FX+uOLPZ47XCXlCh20JfAm?=
X-Exchange-RoutingPolicyChecked:
	AQ58I4p5C9QQDjmxPk5bu94ngdToCfc+2NSg+fE1vhOO7473kf5I2iOxwplrMfYyJvNvzD6qswgLh/aWsMOJShtOQeWk+CDPqc56D9WjPioKs4wPiQ02KdKFs5OBUm1/p2cugdZ2RPASIqAOlY9Qo3j11CknUZROL35sh18pQb1nOLmElXMEanPEgqlXtzqexyIg+Ifujai9w3olc3xn/r+SBvuRXAn4YZAK6PZ2qf7oq9NHEF1sVMLNL7jilurhosSBy5JoBu5SX4EsHGyNejdEdCuAn3tF7BSz7JJ6sflcOKksJBTGTZN2vm3Ehrn5mObbCDUMONpkI/A8KpIG4g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rNWYwm25gJ0KYIvqa6NPAgkfbYe3jJwEx+iTp3WgCbAoY0rAMt1P38uuM3VL/0AUH7YkPlt28E5J4CkjlfKp8NW+9yUI9h0C7FqKwPPXi/qo4hLbW/VtfaAysPVgHR6Me2O9y5viS5lMn2UjGuSN5ttE/gigAf7BOGZrvUcFtuMwbNTkkd6TCsTmwuSlMr8N9Fn7MszSuXW7i8NwJuEPhOnf/16AM1T8nCSg2nb9Y7DdAuqTGQnQseM4rsVoot/iLh7u+xNCy/PZHXOhPwdhu0be9kM3iyixOWoWAkiYICiOtRYd4VYS53LBkKdF4VYKbTRqtjvu0yDiIjUCAllg6c7hcsKUEhgc16rCSx9v8yKhqkaaMwZ2ebp8cqWVnMg3Ab2reJ0oyucmlrt9Glvh/fqbFpxlZ5yWLND9YJ4se7vO4d4jqCS0VGtQ2V3kDVtu0DfyPkmYHDVRVVVvKXPG+aA9tKAlewe96OAemrD5nnGWiP0ywW8ipG9x/CBqgwMQDsNdl7yzO9wslNRoROydGWasBMA3KSlJQp8+YXKrtaDnFKKofSimkEK+WbeoU/H56+/XR0aOascj7hNY77b3dEKhUyPk92FAfy5UIs9ev4E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ece74c-79f5-4535-02d3-08dece3dc10b
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 20:02:56.2703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHMQFUvQcQHFti9B/+b9nE4KF625kbjAgQyO+AKfnlDfI1cAGvyIPGzZXYYaVqqh3pBkpryk1agqkb8uJX/T3orXrwdq0/sOPMeNG9dw5oh0R8xfvEQotmtan+Ug+17E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_04,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606190192
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDE5MiBTYWx0ZWRfX2zmy2E2Lw82k
 D/adW8ytWGxCZyTjjm3FUFO+bMr3pB/bYhfjgMhmEnWb/76E/zvjTIyo73ageorLSrGCw0Vho8a
 ZHV8kUpsdiDdmGBeppptKfBbjfKxufy1U+sNkAglvLpRzCiV6k4w8NYrYvRbqWNKfqUfho4/uiS
 H1/mMyQTjfxW1dPJwsk3oegpd371kSh8BZlQVZ01U77LR/p5xSoQ6yuDpyecaY9riVLmGyIgLeS
 kHXmIoJ4xapHs9jBAHapLe53fGGz52eAQjOcpoKwrZEACq8TyhZhGN2mVwtdCEr2POvEWC2LypP
 OArtzs0pjG29A637dGY7w5BrQ+t35qzsAf8uHM7YWX/sWt503p1TIfWbTOOWemiIDWCJu15kxHI
 Gxz+LPLgsic4FUapZfBl3x5zrCH8jTUKQZrk9WkzGG5ZsxH0V3d3WffjZV5QB8nBEPMAxDZ54iY
 HmzCHhyQq+V5BaLTL2A==
X-Proofpoint-GUID: KxzFswpfW6uq7RCjoowyueyA5o_8Qjn7
X-Proofpoint-ORIG-GUID: KxzFswpfW6uq7RCjoowyueyA5o_8Qjn7
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDE5MiBTYWx0ZWRfX1bil5kq6Uk7P
 4HgrNcpmEbxSZWivvN7wZ8diC7GHTJ44kCMKF5o/byO8VTXTMUGd7CMnaoMExIp6JnLG1hWR0RO
 ErBgvoSyXyt7XqkM4veJq8ILgpFto42YQfe/U/A6P2faKBDM6FY3
X-Authority-Analysis: v=2.4 cv=GbMnWwXL c=1 sm=1 tr=0 ts=6a35a07f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=9OYJ3IDRjKaucir0iYUA:9 a=QEXdDO2ut3YA:10

Hi Greg,


>> I think 5.15.y needs the same skb_mac_header_was_set() /
>> skb_mac_header_len() guard added to dump_ipv6_mac_header(), thoughts?
>>
>> And this is because 5.15.y doesn't have commit: 39ab798fc14d ("netfilter:
>> nf_log_syslog: Merge MAC header dumpers") so we need a similar adaption in
>> 5.15.y
>>
>> I am still thinking having a TODO for these sorts of things might be worth
>> it, particularly because we will miss these easily where upstream commit is
>> backported(so nothing to backport from a git perspective) but that doesn't
>> fit downstream perfectly(so more work to do). Btw, its just a thought :)
> 
> Yes, a TODO would be great for this type of thing, if you can come up
> with a way it can be tracked/handled, I'd be all for it.
> 

I can't think of an automated way, but can we have something like 
stable-5.15.todo here:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/TODO/stable-5.15.todo 
<-- something like this as location.


Report: 
https://lore.kernel.org/all/167562b4-4472-4ead-a107-6eb83275825c@oracle.com/

Report: Link2

And then when someone fixes it they could use Closes: 
https://lore.kernel.org/all/167562b4-4472-4ead-a107-6eb83275825c@oracle.com/

And we could search for "Closes: 
https://lore.kernel.org/all/167562b4-4472-4ead-a107-6eb83275825c@oracle.com/" 
and remove entries from the TODO list ?

thanks,
Harshit

> tanks,
> 
> greg k-h

