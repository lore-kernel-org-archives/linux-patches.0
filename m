Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0471C1A316E;
	Sun, 18 Jan 2026 18:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768762517; cv=fail; b=QlEXjAgqrjWHENWl0BmyzrGdSjBW1TBXuo4IIsS8RTPBqzyPjjj8NYMeotuBLTviail/+S+YB+OZN5QIEPx8B6xySxr1oXDsaEfuQDt1o8YSPU8xD+D2jDNN1qIR4uGoZPp0mgszjrupO2AlvRVX6hRxQCeWHXIpMrW/RIla+6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768762517; c=relaxed/simple;
	bh=A83VKrsYj6vgX60eAaYzlIsBCrBWxxCZrFf7dYRWRC4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kuBsGYIj46i+BaSJKaM1Q3nt4+fPklKnMI6E9fyq/ygnkVinGHuLsWMlmbOQO2xUS7duMuzvsPfv+VF9XcnKyIeZDEomVFRaLYtSgEUmOmg7/vzVdtD6pPMbqpt7FvkSd4/DbWUvB1G7PerLTJ24SrC1AnHYiqsZpsIMFCf/noo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aTo8FQsG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tI3bhuzM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aTo8FQsG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tI3bhuzM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IIhm0A4049649;
	Sun, 18 Jan 2026 18:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=isqXqMS/hRttLD2aWCrrJFRAadCgrnyg979fUl0ALn0=; b=
	aTo8FQsGjghEG9rBlykKITVPISg/fgEQybDSV3eiNjO3rwtwmfEAFwgSzgDP94LV
	zqoJsi+Z3ekBiLfxR7E4p0y4Nz4z25j3a4Rwk38E5it49GUtELS9QmT3reUChZ5J
	JhqGyOaIooCU/5dQcjgDs9y7EC2i7XHrN6n7tuPQFqpgEUdW0SQX2EgYM8Thb1Io
	ZiXg6yY60tqYsrfIPBnf4n4RbVg5WQmlMRtl3JBHxIXnwu1HI3SgdcIm+lBFyi5M
	TJx4NbmsvQVQ+Eq7t7tqCJX3n4iA4/vcRlNQlrFUANL6SCaW0+JDJjy+EchTIQw/
	YKkDgu3iTU1lWhEeAO35kQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9hf2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 18:55:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IGbEdW018024;
	Sun, 18 Jan 2026 18:55:04 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v7jh9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 18:55:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2YjcUZg0Y7UdrT5784H1rhVcuCrXa65JOasRrbl5bBKxOmraq7uuVcXhJUiUKv4fiMHKtc4WCYT2cZoJ8+yQPYSIpqyQz+P1PMvPjyfJSwIH74A15IVa+QxHmJ+JbtDQU5Hv/WdxzCe7VGSbE7SUC28z4FpiAb/orS1iCAhQW6DBN1wgomXIpit9WKNib5836sYk+3wNgyLnWv0MYYKcDH87CMjZOTCa/LKwNoX4VqR698qOt5QCcNksPZhDn2+MpUOLORe/6v2PyuF4YXYoFU61AKyM8KsOQ8lVDxGYGLJefNKrI/LBsYfqA8T9y9+C5lt1YBzGy+yJjv/waC9YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isqXqMS/hRttLD2aWCrrJFRAadCgrnyg979fUl0ALn0=;
 b=OU6fuwFMzwghAnX9ZSOegaNDpihJ5mdJpu80rwq3Mz5QrrVBjaOme2FuI9aG8bIae2m2zvD3a9NGIiKAUSTSEoqyaJVB2GqX+kaDN4KzzA2p+HGNy5cIMWYHV81qUojxVY609JTb2yj4ZUsNrArSxe7qraL2B+M8pgMqCdFEVvh1yopugL4/Fotg4vU40IQCRgc0kREL4m1j8+ik1BjQ7sA3ysioxDugztMW+1vSDDeDk0vHgL8TFUjl+NQA91jET2liU9ZnG06XRIcnsM8hsP1oL8PlKfxfDDNeCCgTKkKM87zN9dJXvm5yzq7+r0FNzS3kkLUA3zMGzvop77PE+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isqXqMS/hRttLD2aWCrrJFRAadCgrnyg979fUl0ALn0=;
 b=tI3bhuzMr68hmqadGODJU1qZdIPZu1WsBoo9bOYW/l0IX5A416qJgSN5ZQakLw9IKFQEkIbG4h6PPtjE2UsP3io9ak3i9PBu3IR0mmimajaYW9dMO4/dKeAlSgkuucdy1BQS57afE8EiTFzewPSi7WYTm7p8s05QQn9gz7CxlAo=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MW4PR10MB6654.namprd10.prod.outlook.com (2603:10b6:303:22f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Sun, 18 Jan
 2026 18:54:59 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%4]) with mapi id 15.20.9520.010; Sun, 18 Jan 2026
 18:54:59 +0000
Message-ID: <c0b4aff1-eb65-48b1-a869-ecb3ed5a513e@oracle.com>
Date: Sun, 18 Jan 2026 13:54:45 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 393/451] NFSD: NFSv4 file creation neglects setting
 ACL
To: Ben Hutchings <ben@decadent.org.uk>
Cc: patches@lists.linux.dev,
        Aurelien Couderc
 <aurelien.couderc2002@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164245.151340252@linuxfoundation.org>
 <ac4bdf4fd2952f95a300b027f705dddffbe54a1e.camel@decadent.org.uk>
From: Chuck Lever <chuck.lever@oracle.com>
Content-Language: en-US
In-Reply-To: <ac4bdf4fd2952f95a300b027f705dddffbe54a1e.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::11) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|MW4PR10MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: 9902ac22-e86d-4921-82f5-08de56c31464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZjdObUFoMlNyYWVJZXdQekVKUWdGV1RUOEs2K2YrQ3A0RTE3eGlMVEJLVVB2?=
 =?utf-8?B?RGloa0RTUllCeU51MXNmMHhWeFJnWlBvR3kxWSt3MXU5VEgrclhyMmcwRGFF?=
 =?utf-8?B?Mm5XZ1B5dmFzcksxZEFsUzd6YWQxQ1RjdjRWQVM4RG9lcGo3KytRNWdkUzRI?=
 =?utf-8?B?ZVJDSmVMWER0TllsMXRkOVZSMWxYc3lvRE1VRUF6cWdYY1Q4dGcwbmxJS0h0?=
 =?utf-8?B?dzNrRURaY0J5UHU3a01ySWw4S1dZcDFtZFRPSzAvZkVmSVVqOGdRVlN5VGEx?=
 =?utf-8?B?ZDdzbU1ueWRBVGs2WHpCYXp6MmFmbXBIbzFUNkRpTU5ZL2R3STFDMlc4OXBJ?=
 =?utf-8?B?WWF1Wk9McStqTi93RTFVaktJandqc1VmOFdKKzVQZjNCZDJjRFo0YktXaThC?=
 =?utf-8?B?S21xQW9sZHY5bmVCT1N1QVNvSlhhejgrbTU3ejN6R3ZvblpMRzIwUTZSTFRj?=
 =?utf-8?B?dUJSaGpzaEZ6TUF4MGwzaHRWQWgvWGtDNnlYZU9yc3hPeEwvcVgwVHhHOEVD?=
 =?utf-8?B?eE9MbWFKWFV1RHlDK2RWYzZoQitONHZEc1lwSEJZOWJCTUlvcWh3eWVoNTNK?=
 =?utf-8?B?cEN1cTdxdG1vdUNVcWFCVklHL2xQMjA0MCtMRnpQaWwvN2dhUDB4V05sYVBa?=
 =?utf-8?B?YUNwZklnQmRhUGYwMnNTd1B0cVlFVVBhZWVSc3VieGJFeFFrYWdvL1BIQ2M5?=
 =?utf-8?B?cjRtN2JlNStuYS9uWTBlQlI3aGpXbDFxTnVUMkUyaUlncmFKQU9DTzN4dEpm?=
 =?utf-8?B?VDR2OGQyR2hxd0ZuWjVkTVJVK3N0Y2NBVW4yRDNSNmI1OWszVmhyZ201NWFj?=
 =?utf-8?B?WHdBZ05iTWVjSS9PbVpNVlpHd2g5OHRWa0VEanFXNmFiRmlzaEV2VlpWc0NW?=
 =?utf-8?B?VkVzcU11K1BnUlV4VHlTWkVySENrSkUxZXJYWWpOWkY0dTVDOENDLzY1bGkv?=
 =?utf-8?B?TXdFT3pZTGg4eFJicTl1YmdGK2YvWENrRm9SMHVsai80V1dRVGVnTDlKUjdE?=
 =?utf-8?B?WWJYc0hJQ21qaElBK0dIdFRTdnBDVHJKcFBHbitEVG1nMUQ5UERZTVVFRS9L?=
 =?utf-8?B?aHpSdUFsSFZ0K2gzbU1xMnZLc05tRlhLdFlhUTNOV2JETXJtanVhYmVtanIz?=
 =?utf-8?B?a0lsMWJ2SnphdzFLcTdKMFUwM1FNZ0E2bEk1czJ3bkFmZkdBNmUyNlBxV3cy?=
 =?utf-8?B?TmJzMkhBUDJ3eFh6azh6c0FYN1BFMmNhSWFid2ZuaEJMOFlSdjA1QW5OWnIz?=
 =?utf-8?B?aDAyRzdBL3RCSjFoSDRCS2tiVzhVTjRkdWQ0Q0FiU29Fcy9Hei9ybE42eHR3?=
 =?utf-8?B?YnhPRkg5c0JWNkRnek95Wmh0c1V5Nk1SaTNmOVI3SHI3RjZTZ3htWlBoT09n?=
 =?utf-8?B?VGVhWUlnRjJQaDZ6S2NnVmZqUnpyZ1VrQ0oyZmFtZkhSS1JYeFJrdEw1MHpi?=
 =?utf-8?B?WDVSbUxkT0FLSHR0WFZVTXNxYnkxRkxvU0p0UlhuaDVUYloxZEVZaks1TmU3?=
 =?utf-8?B?S0VITFhoYUU2RFhmWDJwNHZyamlsbWdwZDJqUUJTSTVSaDJ0NWVmQjBnaFJp?=
 =?utf-8?B?b2hqdGlkWGZudlhyN1ppR2luR1V1emZHSnFYZzg3NkRaZml6aGJQNk5paHQ1?=
 =?utf-8?B?Z3FreEdOZEdmbk0ydG4yNnJ2N3JhQ05aZFNsNWxXQTN3Skt2b0haQzFnRHNi?=
 =?utf-8?B?T2J3b0xPbUEraDVDbi9NaFEyTS9uWm1PaXNuRlZkeFV4THRCZkRoSlBHb0ZB?=
 =?utf-8?B?WDVVR2lveDhhaEptMkkyK1RZMmFvcE91RmVVRVRCdnpOQThaWDlaNGc4WE9a?=
 =?utf-8?B?SkRWOVZ6NGN3MjRid2c0VnE4TWFROW1xUkUxRnlyQmpPM1BZMk91YjYvUkpa?=
 =?utf-8?B?VUIrQ2lwc3cyWHZlYUIvd1pHNzZCMGxwTW50bDNNVXB5R21wYldFWTR0Mlo2?=
 =?utf-8?B?bC9GcnJmL081Yk81YWRpYWdFSDJjWm5tQy84ZWRXVXNubFJ1czB4RXFWTk0y?=
 =?utf-8?B?Rk5VK21RRm1wVGdvTG9uSW1jOHdjekp2ekNNUWlrZ1Q2aFg3dWozbzRrb3RC?=
 =?utf-8?B?R24rbWkwUE5pTUZvaCtyU2FWU2ROR3UxdDBmRFpKNm9ETTFXUi90RkdaTEhn?=
 =?utf-8?Q?T/Nw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXZaaVZvb1B6NEQvRmd0bmpxbmRvcXJMT3JXSGI2SkFIOHo2NEl6clI2UnRZ?=
 =?utf-8?B?WGsvNWhORy9SWk9HWFJnTEVoS3JjaVJqWGVpTW53elpCMnBiZ3N0STZxaVBy?=
 =?utf-8?B?ZEg1enp6eS9ScGRzeTFjWUJwYmw5eGpndlJwWm1aYy80OStoM3c2Q21vN0ha?=
 =?utf-8?B?c1NpdmxoMFYrY2svQk9pYk00VWFEbGVHak5LbXFxckNXWWNYWm0rT1dEL2Q5?=
 =?utf-8?B?LzRORXh4RjVKaHVLWWJESmhuMkR3T21iSHRHWVBZOCtVNzliWE5zU29iVjUw?=
 =?utf-8?B?L3k3anFFeDltQkRvV241TW1RZzNjeG5vaWIwR3RiUUxhT05PblJ3c3NCQU9u?=
 =?utf-8?B?WGZqK3p5Q1RDdzJhajJBY3lxclVUb3l1OHEyNDIxd0w3bXZ5OG1tcUJSSnNK?=
 =?utf-8?B?REt4ZGhPRzdNOG1reFdVVTVHcEZPQUlGbzluazhCQ05Yb1ZKZWYrK3RmeDZm?=
 =?utf-8?B?RXcwalhybWRrbjZ2UGlyazRyQTZONFlXcGlQM0htVjdxRG54U2F5WHR2WHZG?=
 =?utf-8?B?S2xtNklRdE94YVRiamdvOWtiN2hieFlyYUFiS205WHRhdnBxUHdzTGlYSk5m?=
 =?utf-8?B?RFNRMDBVN0NIOEVFaEFCM0pWeG9PUk5wM1ZLZWtUdnl0dDhvU3I4dHRZQ2Jh?=
 =?utf-8?B?aTR5Si9GWFZ3VzI0bW44R3RxYXBaYnJ3VDRTTFo3bTkrR3FicU5NWWorbE1s?=
 =?utf-8?B?Z0hiWFV0Q0x1SWZoZ0drZ0VveHdyOW9kb09INDBsQ0QvL2JjcHBsSzRERTJy?=
 =?utf-8?B?ZVM4VVQ5S1V0RzlpSk80bVFQbnVTbDRPeEg4QWsybHZQMGcyeEs0M1I5WlRJ?=
 =?utf-8?B?SEJGcUtIRXMyakk5YUZtRzkyVmpxVlRiUWxYaVNpbzdiZWxGMHNTTVp0ZnVJ?=
 =?utf-8?B?MUxBaGViTnJLb2RaejZyTHAxK0dES0daRUUzVk9BVUlHT1JTVHMyWDZvaVcy?=
 =?utf-8?B?ekIwdk5LWURUZlhWeTVWNUloR2J1NU9qSXFhbldHL0xzVVpNbTNla2VRS0pU?=
 =?utf-8?B?NnQzNlZ6NEROZU9QeUpmZUVkYjYza2JHbmh2c0NLSmVYNzVPa1AvSmYrN3Fq?=
 =?utf-8?B?SEw2MTN5NVo2Y0N1b1dsNk9KQVZXd1NhT1o0eUhRazFoMnFwN3VLaFVFdzRN?=
 =?utf-8?B?RFNTM2JoZ2IvZzV3V3dKNFJFVUVlbHc2Q3dDSkNxYWF5ZXlFTWFQcXQ3UVRx?=
 =?utf-8?B?R01HcC9keUZCMHVRYTVQOUpyTEM1b1c1NDYxaElCREgzc1BPczhDNml6czdH?=
 =?utf-8?B?YUhkRXl6bVFpVjZxSkJsM2kxdDBvbE5SVEM1WlN3S0xUV0xiWXJTd1BWcllX?=
 =?utf-8?B?VkpMV3huT2dTcGV3TTBUbW00YTgzVGJ2SmJZMWVobE9sUmx2VFNqQldMU21o?=
 =?utf-8?B?c0RVMUlBL2p1V1kvZGE3YVNaNXJtS21sMDZ3aUlsTHB6YlY5WTZiK0hMc05H?=
 =?utf-8?B?bWpPRzF6dnI4L0ZWR1QyNWZobVhJT3NneE1nbGNnTnFRUS9YbzVlNWpSTllp?=
 =?utf-8?B?NkxXSFJnSDljVzZDWFVzVkNKWGJUTGpDQXZ2bUl3VkRUcy9vMUtlcXl6cnoy?=
 =?utf-8?B?Z3oxcVVvaGhMcXd3WlN5c3lUSk1qOWJTaEZRdnFkVXFQRGZRem1rSUNvcXZi?=
 =?utf-8?B?dG5sQVJ5Y1VCeGFpYm94NVdLdTFDcHlaQ1JQOEZXY2tva3ZIZUNUeU5US3VZ?=
 =?utf-8?B?MDJHdzViR1VtM1gyTVZ3WWFDTjErSG50em9JdnpCUTYrUmpPWis0cTR2Zkty?=
 =?utf-8?B?cnF5Y09jdFQxa0FTVmdMeGJqRmtZeUlKRlpaTjE1WW0xU2IzVzJ6by9mSE1M?=
 =?utf-8?B?aG1KNnlmRFNwcTd6RUtiaXFxZ3B2V25ZVVJ0K29XNEl3dXIyOWFKV29SSWU2?=
 =?utf-8?B?a2VrTUNFeHBUWnlTcnNEQm5MRjVxWHY1WTg3NjFpQ2pyWTFsRlFiR1ZaSUM4?=
 =?utf-8?B?MXgyMzVmT0NGNmFuSXBodlNHRDZYeFlTZTVUaHFBMG5QOUR4R05hVllZSHZn?=
 =?utf-8?B?Z1UvaG0wd3hJQU80ZEZtdkhZc1NBNmVxUUJyQVRFVGRPaFJGT09KWUJkMXhN?=
 =?utf-8?B?S1NuRHltN2k1MVNtN0duZTRnN3FFTlFWaGt0TXF2bFc0SGpHWkZ4dFdiL2E5?=
 =?utf-8?B?VUY3cHVoS0NhTnBuNVBKSDBKQ2h3OW9VRE5nYnYzdis4Sm8yTzEvU3htZEJR?=
 =?utf-8?B?RG11WUNVc1RjSDNjRmxCSnowZ1BvdlBFcHVtd3JFazlLOU5hd2RDZ3dpYmZO?=
 =?utf-8?B?dnl4UnJvM0tzdm9VN0QxeURZUXpsZ09FTzg1VlhYYUgzSGs3Mmh3NXU5RHVk?=
 =?utf-8?B?cnNvU3ZHdG1UaHRTV0tYajlCRU1oS2VBUGcwQjFXTUdLYVVSTW9CUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/mKuqAEonyLcmYhBCU8Gx9bxFUIsIUXRwKbBM+QgYJvFaCzrAXzJTCr9hURz7X3jluiHIYFXpegE5PIdIJRKLlZz3avqNEULCw/aLvu/K5bPFN1hee5ZbOWisL8U2gc92dzIadvbAShe1lZqr5bcEWHwxhuOw3HWA/6tSYJY57Ydcq87b1T7d+FchhXw1xMU8wq1CvDdTaQ9Q9f9Xw77R3t3DTzvqvdreKnfJIhbgv2G2Sx6EwEKnQ3RH+ru+TqWwDEtPYQae6tDBDXPp0jZ1U0e6uMlPD5SKwjn/Op+DNXxIUAEp4dlr+ZcwdfkTaaA7JsZSDyCkoky24IVZIqJ2npVgILw2jQMatGdr3uw4DKEI+Ckm+54ayFatFJ36sBbMvRHC3AiGieV2TNJLSomZlCIzKvh+HhQQ7nds4+W69FzzpgXD7Z5SmKvWMJujFVu/QJlZfhj//poRX5NEvT31t9nzfXwJYScSWWfX/s0cNqyuccIpBgEDklDthBMXt0WPWAmkwta/jjfmrBKagnPBoXep3GOBm3ZL8jEboFXrTUQBiM+kV65y+jw8lpK/eCzQ39HYiZ7CsZEduQ85RZo9eUbnQbaCDaBh78oUItV200=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9902ac22-e86d-4921-82f5-08de56c31464
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 18:54:59.5353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3wbLm5Ds5Eq6iPns+qCErHrKRT8xviY/cuE+gZhYCS518PkMYAAGi80YEM1yXF50QAo+zywkEBqBE2DmSizzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6654
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180166
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=696d2c89 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8
 a=dxC9QWALQOsBklYfruMA:9 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: 5H74SAJ_I07vtw8NofNAhsXDdPPA3xDm
X-Proofpoint-ORIG-GUID: 5H74SAJ_I07vtw8NofNAhsXDdPPA3xDm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDE2NSBTYWx0ZWRfX+YBiGyytshAT
 IRRLBvYDa8MKBHWPB66t/51A/Ji89aa2F2cWdU/32Gxy9fCrLhOz9ZjtdRG8LQFd9wC6ZTupyBy
 EHuFfrh/8Jm9BqlDiJTIXlmWz5QLNPTq1uVbX6WPg6rPPrpH3l+Kqd2kroSfRkFS/E2YvuOTEqx
 agiGHuxXT8ORJ56AGIPQhQtf1h9hausqJ9baGdrkwVGnbTf8MpCNopv/vhcO3Tl82hnMKBNLO/p
 /cQ7EOnVSwGH4ItjQkB0w3PftHqli7Xn1ciT+yUVucYIbvFiUGx2E9hIbPEwH4oSIkowZ2411y3
 4hMq3qu5tL89o+06kJtMTJJmwZJpcIQyk0McHKHZ+vK9clAVYBcLcEktwAqgIUb4dhQE/qCDOM7
 d8OkjK9xk2pnxFOQr1/11HctUfHm7W71FBjov4ULvcMcgcCU9ZN8pe4RwwptOUiC6PA8JV/ovyR
 yucMDfyjKbkPGAscVsw==

On 1/18/26 1:50 PM, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:49 +0100, Greg Kroah-Hartman wrote:
>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Chuck Lever <chuck.lever@oracle.com>
>>
>> [ Upstream commit 913f7cf77bf14c13cfea70e89bcb6d0b22239562 ]
>>
>> An NFSv4 client that sets an ACL with a named principal during file
>> creation retrieves the ACL afterwards, and finds that it is only a
>> default ACL (based on the mode bits) and not the ACL that was
>> requested during file creation. This violates RFC 8881 section
>> 6.4.1.3: "the ACL attribute is set as given".
>>
>> The issue occurs in nfsd_create_setattr(). On 6.1.y, the check to
>> determine whether nfsd_setattr() should be called is simply
>> "iap->ia_valid", which only accounts for iattr changes. When only
>> an ACL is present (and no iattr fields are set), nfsd_setattr() is
>> skipped and the POSIX ACL is never applied to the inode.
>>
>> Subsequently, when the client retrieves the ACL, the server finds
>> no POSIX ACL on the inode and returns one generated from the file's
>> mode bits rather than returning the originally-specified ACL.
>>
>> Reported-by: Aurelien Couderc <aurelien.couderc2002@gmail.com>
>> Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
>> Cc: stable@vger.kernel.org
>> [ cel: Adjust nfsd_create_setattr() instead of nfsd_attrs_valid() ]
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> 
> Would it make sense to also backport:
> 
> commit 442d27ff09a218b61020ab56387dbc508ad6bfa6
> Author: Stephen Smalley <stephen.smalley.work@gmail.com>
> Date:   Fri May 3 09:09:06 2024 -0400
> 
>     nfsd: set security label during create operations
> 
> ?  It seems like that's fixing a similar kind of bug, and would also
> make the upstream version of this apply cleanly.

I'll have another look. I think 442d27ff09a218b61020ab56387dbc508ad6bfa6
had some significant pre-requisites.


>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  fs/nfsd/vfs.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/fs/nfsd/vfs.c
>> +++ b/fs/nfsd/vfs.c
>> @@ -1335,7 +1335,7 @@ nfsd_create_setattr(struct svc_rqst *rqs
>>  	 * Callers expect new file metadata to be committed even
>>  	 * if the attributes have not changed.
>>  	 */
>> -	if (iap->ia_valid)
>> +	if (iap->ia_valid || attrs->na_pacl || attrs->na_dpacl)
>>  		status = nfsd_setattr(rqstp, resfhp, attrs, 0, (time64_t)0);
>>  	else
>>  		status = nfserrno(commit_metadata(resfhp));
>>
>>
> 


-- 
Chuck Lever
