Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0E52BD11;
	Wed, 15 Apr 2026 11:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776253348; cv=fail; b=TWm/T+fxRD7F6OtG0k6B/cbkW0xGB3FXaRLVnk7SPKNX+orba8NYPHf7JGYsQKdTcWh8b4zkUbb0nS7/j1+UfKgppPLKw10JCLZcWwVwjNMeb/Cj42BilBdjgv0HyelKx+NtfA0IthL7b3nD3jDGi885AN3OAWHiKpBjTdw3meQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776253348; c=relaxed/simple;
	bh=bxtzxFUfEcRtSe94UVT2xFCk8yHibzI9FCogpZj0BjU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WwEqsBSXlE+bFZXNfC6JVGG/WKgWTtrdGGUauLFfKq+fuX7YUtaoSqjcFdjTOhZ9uttsGNObopHSlG3pQ+jnrDwpGGaQ+BWElbFyj3A3GdwWHLXeazKVB/kXRQP5F3SXeJn7XJyViS8fxVbi+F1/6szz8SIQ6EyWX807tBqD5fY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CwKSUWDh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ioga4atQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CwKSUWDh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ioga4atQ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F9BXmx3491409;
	Wed, 15 Apr 2026 11:42:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IUbn3/0Vqs3erf+5H5NprTvKCxEYfuazejCZC1VQnBE=; b=
	CwKSUWDhaEyKE2qw7Jcci5hp7Fe1TiSkOMrCm9J0vc+EXoY3HrdNmJgkLlmFC+g2
	/FFPp4wRW7epUTiHCYM4c7R6c4L7cy2K/V02dyCC0M4XlyixrHcanIuaMvNUjFC6
	Fo1nnvLkAKOY8WKEoNJONbOP+6z9cBW7NryjbikiiGZdIAf7bX/u1UvtymZU81fU
	EDzffGtsuWcVdHE9Hlgn+4OCftPfTe+OLkOa9JYiCTBgHK68dMHqNx2ym3d26HUN
	dbPdgJc6FPCPmUaFk4FX5pClXY+BeY1AG1W6ROrPcte53GsME/4N3icIxfzhn5FL
	q38fzJowCJa9hGigSweT0g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87mcxw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 11:42:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63FBdMGe007178;
	Wed, 15 Apr 2026 11:42:22 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dhyk04ft7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 11:42:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7s4fCdQCtc91unak8JGMAxELsok7jlyobbuEky4VfKy2AFnf0Wvm9xOBPuf0L0bZOBeWMXXlQ3Cp/qjhN3FUbMzR5Dr+WqqweQY5z94RBcZlDHXpi7x+yyztgc0xNxkfQk0fMTucndpmdMREo1wh3SphqvSW508ZKBQ8Y5XpQT5xhWMhx78fxX7wvWwfkT/SrIogqdGFKRIdiNT4f/W0lxTFR7+JJTj0jDXftnZUiH9QwFcCOuvQbrWRfduxqZaBKOXcgDNjzO8Ny/WguDyvLJIH8p4isjMUcn5dGEV1+TKMrEf3cXwJZVY6JQZa7iM31Ls/lxjx7lDitXFj3wmzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUbn3/0Vqs3erf+5H5NprTvKCxEYfuazejCZC1VQnBE=;
 b=afmom8FZgbSG1Zb1uAyOuMOayXa51+7m+v2wCds6ABkchEKiJBQhiwQAgnHdj9Kl3uFcl329PM6jGOwPjkSUce7CeOuLaq9OKgdv+NkztLD9y9ykm1Fx7aZ+kn9PCbWahSqbzyblNTY2IQRa3rX+SLs1IHqB18xSDvKDPP+kSFBJJXIG2YJ5sBQa9rqDQcgCLpqRQG18XYFwieZnopQUxjDl0ifB4X1Dj8lKDscHPhL3EACN3upIxoAHBQGNuNsrpItHey2GiKBBJPNbkDYoU62KcKjsdhdq0Ss1y+K8NimIb4rkkAmv85fDnmdwGQj23IixJhl3yvCS0mdXwg/NYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUbn3/0Vqs3erf+5H5NprTvKCxEYfuazejCZC1VQnBE=;
 b=ioga4atQrpbF4PzUfvVolZFjku7LO2iQLEz/04FpR3f1USTgYu0NbIS+dvK9rOX8NOqCL8rXfi0E2eGGo8nvc4I3A93T3RaMDarKh2cUM1Tef8bMdkuu64jxWww3obTINnkiNUdacG1dxkqrCPkor/bWyk3BHsQFSorBKdTKLrE=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA1PR10MB5759.namprd10.prod.outlook.com (2603:10b6:806:23d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 11:42:17 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 11:42:17 +0000
Message-ID: <72718777-af7f-4d1a-902d-04e765a8e8aa@oracle.com>
Date: Wed, 15 Apr 2026 17:12:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 386/570] dmaengine: idxd: Fix not releasing workqueue
 on .release()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155844.937196566@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260413155844.937196566@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0094.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5c::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA1PR10MB5759:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb943f5-777f-4211-4b32-08de9ae40be8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CXy0oOGTKlQLfPVxG/duX4OoKYhXr8oXDsP8SAW62RBEDlCyHBSZbGalK1mZJPqTpycBGaoydQyoAOh2cvD9Sp8HpwRDnrUrtmnpxa1dK0Pk1hSZGJMJvotuGOw4F0ZmGCxxcVCzm7bcAnUYEPqs5IQdfZkdl3GfC5ccgHhiSLBB2Iy8VIpiD+rRuPKUvU3nxGcTxXW0gGb0uTatX8haXJPQaxKFjCCDqoaSK6mx1eiMJbpBo9Sw3YwYhCco4Vmd08ob8FztsMSkYqADeR7WL7/zo6oNYZQjbf3FJZDROiyrexnGWInPs7jQJj+lUDAq0gZqg/P2yD62JGBYyVILg/dI7qiSiPPNzp6Vmq06xNaffRMPOT5/K/GoJo8hoY9acNBlHwYxIHnipQNpKEWGbstYOIXVTXAhFGTA+e+sJcqOWmtlox65SP7jEwvc39fhAqJd9ff6S80BISC/AfyGFTjV/M7bxRoNyo2b8eIfT40iCZw7ADQutt5/hi0uKWFbh2rXBsBWfwMz4kvEVzUC5/JBmseUoWDHgghkp23KCZqvRdnCmU0edO10N2aNXE1186uUgGu8lFEEQXBeViXhzAoGjzvxXPBQRxMke7V1EZgSWATEE0o1Yi0E0xYCTayAa7vIz6FpnaqmZ4C0ghWYfnE/dWW6VWH5/P/VO+/k0cwkY67emeGp9eLD1ytfdfja
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VG5jNzVaaHBHS1ZWTGRUaC9HMHB1SWVCSjJpSDVkRm1CVmY0UnNMcDQwd3k0?=
 =?utf-8?B?dE00VDBUM2dyYnFSMDBSUWdIL2pqV25JSnB3c3JING5menFWaFM3THprb0VN?=
 =?utf-8?B?a0pHWXA4NEFTa25aZ01zaXNKZ3JDUFNxL092VUd5YTZaYXBXMVlJM1BUd2NY?=
 =?utf-8?B?SE5jRjFzK3d1UTQwWXIxb0FkVTdwT1dmYndHNDNkWldHam81Y1RJb3Rab3Ax?=
 =?utf-8?B?bmQxVVNFMVR2bzM0eXRUcENxOGpZamNTTlVWZzZYa3VhVU9hQUQxaDgvdzM1?=
 =?utf-8?B?NGtBREVZT3JHVkFOOWpDK1I0ejQwK1JvV3l5M2VNK3JpUWxxa2VoQVBGdDdl?=
 =?utf-8?B?U1JXWmFhWmw3Z0puY243LzJ4YVpWV21LT2VqWDhsNHJxclY3OWxPZW9VMzJr?=
 =?utf-8?B?NEgwQk1xdmpoNU9sdGk2c1YwUmRoNjBwcUhJaUhBdlN1UTBkbHEwMVUxbUpU?=
 =?utf-8?B?c0dUUlFVejlYVnQwVmpaS2tuYWRabDFxTm1XWjQycEQyVHMrUFd2cWpzbzZj?=
 =?utf-8?B?c1ExTHFkK00rdG9xaFl3M3RKN1ZNb0Z6QTVQM0RwRGQ5ei9QOEU5WDdDYnAv?=
 =?utf-8?B?cUR2dmZlT2E3aWlRb3VsSTl6ZDF4aitvK0EwVGlLdGNqUG5Nb2JHZGhxR0Zu?=
 =?utf-8?B?emdzZ2I4c3UxOGtFZG5MVEpUUWR0ZlA0UVdlMk9WTDBxajNrUHdvSE0wdEN0?=
 =?utf-8?B?QkQ5QW1iQUZweFN4MGF0bXRJVnRJOTFla0RKYW9UYVVUSTN3ZVJHWkVVcFYx?=
 =?utf-8?B?bGtFQnFPdENCNDVtajJEa3lsVmF0Y2VKTkZJRGZHK0tiNUl2TDF5WXRzQ0F1?=
 =?utf-8?B?TUR3Q0tBZDZidEhRNTgraUczS1Vob2xQdTQ1bkkzWWZtWlVPWUU3Smt3NTVG?=
 =?utf-8?B?d1h5SXlvcjNJbzdmbG1qT1B5Sy9qSnMvd29lZEx3UlUwaFZSNjVEYldaR0ZK?=
 =?utf-8?B?aE0wdHduNk9OSnI1ZzBCTU50eXhTQzhkWENsZDdyN3YvQ2xFUFpBdVZxZy9w?=
 =?utf-8?B?d2QvSy9WcDlCTGM2SlZMNy9tZTRFWjFYbFNTL1M1U0JFamo2NUp3bS9ORE9Q?=
 =?utf-8?B?STd2dVl4UG54eUYrQUJCNm1ZSGQ3aUwvQ2Q2djZUbXBuSlhTc1lOd3hMWFN1?=
 =?utf-8?B?U2IyWnFCMUlNOWN1OFcrOG40YUM4MXB5S2dLMEJacEpzVzIrYW1VTjZPeUNL?=
 =?utf-8?B?N3pLdUlFZkRPak9WN1ZUaVUyMGp1ejRTOG1pVXpDekYvNkZPWFN6S2JQdGhy?=
 =?utf-8?B?dExxYk8vNHpnc21jSFE0b3FyUHB1VlpEVVRoRldNWUc3cHNHK0xjNEFmZWJX?=
 =?utf-8?B?TWYvVlg0K29lTW10SFB0emwxRjE3a3A4ZmZDb0N5SVYxS0VmTlRjQUxaZGtk?=
 =?utf-8?B?M2oxdUZZTGs1ZENhbzA3MkpUVDc4MU40RFo2Q3pDTjhBcXFGbm5XdWZrd3pz?=
 =?utf-8?B?SU5hSjJIc2tNbUZNMkxxQjI3RW1BYUNYcExXdHVmcGpWQXFWTkppMW5sZ1NU?=
 =?utf-8?B?VUUveW1OS0JGdTM1K2MzbWFJT3Q0NjZ2SnpKUVZXdU1ydUprZTNNRkwxSi8r?=
 =?utf-8?B?c3ZzZG1UQnppd0RvalAvblV1Rzdna25UTS9zYUkwY3JIQ004U0docFA2QnZx?=
 =?utf-8?B?NzVldUxhUlB6S1drSktZcWIxMGhLNjVDKzZjSmFXSnhWVlh2RVNjSVkzc3RS?=
 =?utf-8?B?U3h0cjAvUmhid1ovbityNzNhd1NJVkRBcFBjZUhiTHJiT0JUbXg5TVY3Z2JG?=
 =?utf-8?B?dkwvV090NUJEemZzSnJZVXAvNmZLN3lWNWJMcW9UbmhnTDAvTTRKQzNxK0Rv?=
 =?utf-8?B?ek5vK3FQTnJhSFRqWldQSWZYb0ZQaVZETitIcEVLWlI3SEFiT2EvMDlsQ29N?=
 =?utf-8?B?MWpJVmk4eWZkVU4zazFQZEo3Kys4SlVKYy9zbmtJOC9lc3N2WDd3WnJqeVBl?=
 =?utf-8?B?MjFHSDk4dWNiQkl1cldTNThoRGRWSGFDL3BwdUdWRjg3eERVTnNjalR2aS90?=
 =?utf-8?B?UmhpUUlTZ2VLSVFwWXI5QUdGSG9aSFpYTTJ6REgydWZaSldpbDVxRHNld0VN?=
 =?utf-8?B?VS9GZUpOOHhERkhJa3RuQ3dGRnFQYWgzek1CQ1plTThvNkV0QjRxR3JRQ1F6?=
 =?utf-8?B?VVE3ZkE1SVJrbnE3eXd0Tnk3anZpemhkVURUNHk3VGN2ME5TU1JoT0MrZzE2?=
 =?utf-8?B?WHNOQjc1ZDRLL2xhWE5xQ1VQakJDQWh3T2lLNUc5bTdVSkM2TGJRdnhPZ3lL?=
 =?utf-8?B?UG4vbGIycTVIOHlxSnRpd3UzQlBieHVORldYS3FQS3JKbTVZazcxQ1lBSno3?=
 =?utf-8?B?VVVBTnFmL3ZqUXZkVW9KTTUzaVRvR2U1WnhXUlNERzQ2Q216ZzE2ejZ3bUhL?=
 =?utf-8?Q?6NnveXMl/IVHmzwjwY1d1zrpGjGLNuzNgBqtr?=
X-Exchange-RoutingPolicyChecked:
	QDj1/LlGwgGQkogsXbFO4Q1S7HDToRAAhTV0thCHVyRn8yzAT3Av9q/s8oAo/UlV089rctJpgGoCU9L/Mg1jCpJLAFydhWwedre0t8ufBBXsyajuroaCtzWqHJqJXLySMpRYuu9Ngn5rbhG+x9wnjLZWu4T3HgJl3ew5bDWDlLf0xh5tuEdb/PckJ7PEzOhSTc3Ir8pUy+vuYccMoClJ6TKDZkzrz3eva8rCNQWUTvi6sPddc2WQXH2wd08JnZVWBJ7cV/tPeON9xQmj1IlzvUX/PvQrl+Hm6heTOM9UluAbFRlN6qVKIXmQYKSctvK5vE+jPMd4L5cQiEDRxYBzlw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ebp9T4EiFlq2LBC3PWzl8l7X71uCTBVwV6WWSipBvT9qd+oLbHJ+V7OOvfeQBRz5MpiMf+gmo7cTSt/BRFSGfcgextEw3B2QGkDj3bNgB/eFaAbQR2iI/0JfRu3XQ+Yailv0FbR9nfTIjrReFg0hk7vDenN26jTvSKgXoL53NWWK0GmFyDO8BDhsv2NW5M1XKMHex4vx/4AfPrTk6xEDsGaJ8rc7JkqoEZlm250upg6b8KWlbYrsbOG0MwDxlNrBUGBJBGWzP+Gh5uYlDsEclqD7Py3pOLdVE1LsGR3KH5w1eWBgQX57Icuux3KCnrI6LY5F2MfhAniXQKVsgyoIJn7C5X1su18ArU0+bETDXoLpg7N+8dgJ6mzuQgCk5a2a+XrVRdJWZ6hxDve2Bc/B/JNMyANTr88tETEJbUsAwZ959oriaAexkLy2BSiw/Wew4C/9SsafHTf5Ov9Xpnf5tyMycOw458zYqRG6GZUg0RF+v1DZNXV71KzLCRMylj2L60MNMqTy6Esufnsong4Ecqv33AtamQFIoOYLjUjFXewtR7psRpxHG5Lj49Zdn3PescpEgOYGETsg81sOEuiY08Gh0/w5NOC7kDjuu/S61+M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb943f5-777f-4211-4b32-08de9ae40be8
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 11:42:17.7605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1VVeTW1JP0UOblIssxVPQIEezv64sgLjwJTRp082aT4nj1hpSmX62Oi/JC7OAgRaOCp4ybA1X5GeK4tr9H4zNVZlbPQo9nOPSkOvl4RbzIrr1emXWaUl5xpYkys5+JV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604150108
X-Authority-Analysis: v=2.4 cv=JKYLdcKb c=1 sm=1 tr=0 ts=69df799f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=kdjpdrYDhPMbfWtHnXgA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: 0JxNRKvQ1bkhLwoUzv7IlpUINORFB5sv
X-Proofpoint-GUID: 0JxNRKvQ1bkhLwoUzv7IlpUINORFB5sv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDEwOCBTYWx0ZWRfX9pQHwNk6ct7q
 ph9wPOMo4/Ovfyai5En0qXpCqN4QBudR81AyzMqDEwbGTKIGcWQqv6ksoWFPQ3icH6QjDsmFrwg
 ksR2nvR5t8lQ3eI+7QipN/jy3N8W/F/LiSI8r8JcxkAF5ouaexIwr5Wy0xvG1Bn8mxCnz0fHxN0
 sNFM+YhwSoTXmNmIlE3guVqH18S/Bo+JlOp7IgTZuEKOv5EHLy+EcBImR/H0RYW4m+mglluCK6g
 rZnFN6xmbFOzt6mdhaJNl7I3xYFDJG6ttAeXbOi59Kz4c6iN+fl7L1xjiJvBYQSz6BZKDH/dvyv
 62OSIfK4h8UQ+K6vsFTIy7I1b3xRjjprnBcCnogAIuV/sjvVTUZ/KEAs/wId0g/yzynPFj9dwyH
 LbNokI/NkLj81oW11E6tpB21g37epEzlhZYXWktkOPp4Vkf8lfppT8znj54a7z4HM0/zOTjWOrN
 xVWfvMKOT1UItLnpEHA==

Hi,

On 13/04/26 21:28, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> 
> [ Upstream commit 3d33de353b1ff9023d5ec73b9becf80ea87af695 ]
> 
> The workqueue associated with an DSA/IAA device is not released when
> the object is freed.
> 
> Fixes: 47c16ac27d4c ("dmaengine: idxd: fix idxd conf_dev 'struct device' lifetime")
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-7-7ed70658a9d1@intel.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/dma/idxd/sysfs.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
> index 489a9d8850764..ee208dfdd0cb5 100644
> --- a/drivers/dma/idxd/sysfs.c
> +++ b/drivers/dma/idxd/sysfs.c
> @@ -1271,6 +1271,7 @@ static void idxd_conf_device_release(struct device *dev)
>   {
>   	struct idxd_device *idxd = confdev_to_idxd(dev);
>   
> +	destroy_workqueue(idxd->wq);


I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:

in 5.15.y code base:

the remove() function is something like this:

   get_device(idxd_confdev(idxd));
   device_unregister(idxd_confdev(idxd));
   ...
   destroy_workqueue(idxd->wq);
   ...
   put_device(idxd_confdev(idxd));

put_device() --> release() call and this patch tries to add 
destroy_workqueue(idxd->wq); so that's destroying it twice.


idxd_remove()
   -> destroy_workqueue(idxd->wq)          // first destroy
   -> put_device(idxd_confdev(idxd))
       -> idxd_conf_device_release()
           -> destroy_workqueue(idxd->wq) // second destroy

This changed in ustream during the refactoring commit and followup fixes 
of commit: a409e919ca32 ("dmaengine: idxd: Refactor remove call with 
idxd_cleanup() helper"), so upstream (6.15-rc1 origin, it is backported 
to 6.6-rc1) doesn't have this problem. looks like we will have same 
problem in 6.1.y as well. I just checked, it has the same problem

Thanks,
Harshit






>   	kfree(idxd->groups);
>   	kfree(idxd->wqs);
>   	kfree(idxd->engines);

