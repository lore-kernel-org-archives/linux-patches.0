Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32849282E5
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 05:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721971584; cv=fail; b=k+Z9fvSI3b+SopayHAPdYJH+uVjk/RF1U+zFJkqqcBbpG4MQXo1BF+esqYvRHLFrgCx7m2JIgcWoUkjbxS9YJ6ry25K914qtCliLMmlHhDtCk2XiTXzXhatC+DU/HQGfJJPjnZ4AZunswF8LrlnPhtRcVNo4ctUMb7OhRTmFLA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721971584; c=relaxed/simple;
	bh=lHdNnBvAhCDKqoiHlPt6jo1W0F9LjtWCDAWyDJIg0nM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rce2coOhvNxXTN71S5M7vjrYOdJ4bYSbDT0feXYW0am3GLfC39FCN2FjekFUewJ2efdwqsTnC7MQdRP959htTc1Z0ewZqkzq6unvHYwpbMyxOqVwXZPY3hyRRQia1UL9NJDPwoRKk3hIO49QcIXflzREADewiobBGCSmcitG9Ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oMNmLvBB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zi/byQRR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oMNmLvBB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zi/byQRR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PLhUJn029196;
	Fri, 26 Jul 2024 05:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=e52Lqt2HnqtwpUEHFbKWG4fT+zBXlLkc2SX6e7Sfk08=; b=
	oMNmLvBBR9j7CxxwZehdyGQJ/0n5muQGCxVntp7OYTuAmT3Ji1ZCtR90mkkCuU1M
	K8eOt4zQCgjuL6GZAvFRSIe+25CY4+F6nyc5fHn3COJFiJlYVeGLLXtJTgiZ0HVv
	hI+AZ+0IVPcx+YcUoX+Mgtn2U6kXfAehrPEMY86DMyIbEopufRBzdVlSk8eLWnnu
	bomcPcta5b/v+waPzFXJwyX64Slbjn58C2W1bee723UlX/qod0MWZjXpD/naZzuA
	55hIJREgcL8cLWHQ6PInVorJW6l3GMvw3bBC7ezPsbrUBT5FCoo3IMuQDolJrZGy
	+YdTHEqRrM/Ygw8H+K8jGg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hgktcucs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:26:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46Q4CAos039088;
	Fri, 26 Jul 2024 05:26:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h29v0g7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:26:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmpHAx86CREK8JnFrnu2c5kSs8n8ACUqQEoBF9brktNfAWoWTTNLThkhNJMarNO5xRQkDJ9P78bVY7bTNwPCKeRncPR3Ka+ED+40pomsLHqAE0TUncqrxnxruO11epXCjk3r39X8jzvVwFiJGN82lGdrnCtb39RyrVzacDs81/Aij1E/VzHkjo9wVkwHBMA9kgo3fABZK0gsJFUCYnm7ef7JAYOcPFlQApuTKYSziYRy6Lbhs6VQ6ER+kmPtrbEweo07L3p+s1jf3yjH3Vg/W51PupPyzQlLc1N1H56pQNBpiAca3APv98Fcg3EvpMp80HIcgEPN291VEPcM6BtChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e52Lqt2HnqtwpUEHFbKWG4fT+zBXlLkc2SX6e7Sfk08=;
 b=blLTcU9n6wSlxT75lU2I7so3R0BFEv03OI2z3ZJS28QtwXMCxEeh5A+VY1WGBtF8llDL3+02lfM3DNWKVBEuDObZr+zH4CWeH0EWW44i1FCuYsmv1oU/31zVNCqsnc3fy477gXoAzruTMyXJ2dT3BEmn5STpVGPDC65t5hZXP1iBvdu2q8KZvx0K3imJ1VXIXkT/SfpaQZjPoH+X6nNNQEQg7WD22rLjYRasehJnWuYQ9GKocwnzDvxuOPL3PqWbCh11JHsAFBuQqTLMbvkaOEAJZ4aleaWqv7v58iZIjPBkYU5C7iTUZo/zmJUL5N2Sk3Trq4Fr9ZwBH9JxyWqz+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e52Lqt2HnqtwpUEHFbKWG4fT+zBXlLkc2SX6e7Sfk08=;
 b=zi/byQRRsYPeFtvU7Rixp7SJNKNKHAkvae5cIZdpg1NMl2CLlJxquJWjuFNKWoR+vbriChqgutLmuwD2/VhaE4DAavd1SyuVW6mvC94tx1+lDnk0DDiddP2IkXeN/S0QTLCrvxwtRMZWuDLViPnQEMCwhaTAdwE8fRA8sW/O+IQ=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 05:26:07 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%7]) with mapi id 15.20.7784.017; Fri, 26 Jul 2024
 05:26:07 +0000
Message-ID: <8db7784e-6309-4394-9d3a-14b5822fb5a8@oracle.com>
Date: Fri, 26 Jul 2024 10:55:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/43] 5.4.281-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240725142730.471190017@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0043.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::12)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: c508a72a-4633-42c4-aca6-08dcad33736c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0I0OWI1MHBST2g3YTAwNE5nZGJZNk1pU3dINUNVajhXQXdNTDFBb20rYVUw?=
 =?utf-8?B?ajNhK3NwaGJIUEpoMHVPOW12OVJqbkpaelZEdFI0WkpFa0M5WjRaSjh2eUMy?=
 =?utf-8?B?RTN3RXRZY0NkaG5LUzRRVlVFdWZYOHdWSHpnaGNxL2xick1OVlBwRk90K2k3?=
 =?utf-8?B?cTVTc2NJdDFJMmJWd3kvaG4zMDhkNCtLVFFqeFF0VE1uRHRPU0s2TkRHVzZN?=
 =?utf-8?B?aXp0UldoRVVhZTVMSjhZMzZQVk5LeVlSVUhmcE51b09USDF6eUJuZktVTGRq?=
 =?utf-8?B?QlpzOENZZEdRTXltZ3lFV2ZCcGJUSHR5dDE2QWRWV2FYaisvQmU3a0RlcldY?=
 =?utf-8?B?RTA3bDBFem1peW9OVVFSN0d3Y1poTGx3OWwvdExQdWo3Z0ZGa2xBN29lRTFD?=
 =?utf-8?B?eUtHcU51bEd0d2V5RTkvMmxReEtxSHFGdFg3TXZISVVXSWdNZzRnalRnRDhw?=
 =?utf-8?B?TnBaRStLNUIxOW85ckNMeTBla2RYMWxwSGNNK0ttUHpsNzhQN2FGRnF6cVpq?=
 =?utf-8?B?U3NpR3p6c3I0YitSaFJDekRONGwrenRJN2oyeXM2eWF4M1duT1F5T0FxbE84?=
 =?utf-8?B?N1c4bCtaN0ptSloyeFJ1eXJ0RmR1ODNTYW9wRHBxdEdjcjBYZVRvdDF1TFlo?=
 =?utf-8?B?UTlxQk50RXVRQlhBVlBzWm9FajhpL2loZkVoN2Y4NXNySmJ4Ni9OVUhkaGlk?=
 =?utf-8?B?cGkyR2pScFBob1JnTEl3WWsvayt2Mk02blZXUjQxYmZJRy9mL3h6bmtqckQx?=
 =?utf-8?B?Zk9sWTREZys2VVQvK0FMZXNuek40SUlZaDMwZXdtd3FWN0F3OFY1VW9Ha25n?=
 =?utf-8?B?MnBQSUtwTFZaQmc3a1BLRDJUUEtzdFJGNnI2eSszSC9GS2RCamlFUzdITzY1?=
 =?utf-8?B?WFcwb1VVMWdBcXc2S01aZGsvUXpRWlVsMFJJaDFJQUY2VkVobE5EbmRXbGdz?=
 =?utf-8?B?WWMvb1JDSGtnRGJjZmpPUXA5VEVNY3VZTGFpRkV3Y0NUeTg3ZTM5WXdWNEZ6?=
 =?utf-8?B?VUNYUFpnZnZ2ZHEwSjlQbUc3UnZoek1CdUFFeWxYV3hFLzRleUtjbEhSSGx6?=
 =?utf-8?B?MDhKVXhhV1Q1RjJPTVVDZEF4VmJlL0F5YjJ5ZHgyOG9pWWJUdTE4UE9JZDZz?=
 =?utf-8?B?dkJaclh3ZzMrZldVcThieU9HWkZSR0pYenBZN3Q1Q0pDelNheUVJTWxFY2Mr?=
 =?utf-8?B?ZTBLdFlYUkRpVVhlZ3hTNnFIbVA3dnIyeE5wQ3lpV1hzOVc1ZXFaVkx3VUJ2?=
 =?utf-8?B?MjBhRXRlRUtIT0gyNm0xN2FlWWIyRi92YUc5TVlWcmF2em5MaFRGRG5zRUJW?=
 =?utf-8?B?bG1jeExsMlpwWUtHRnFWZXJqNnVMTVd3TWs1c0JQN1kwS2xhMkwwbElsMjRt?=
 =?utf-8?B?UVNvRHc1YStoNk1pWUl3cWtOdGQrMHVjM052SWJRWUdqSm9GTWNmaXpnUkVl?=
 =?utf-8?B?Rko5c0V2bTd5WHRpaC84Z0dPM3FDc0tRK3ZjL1lBWGZOMEh0c1R1dUVieWlJ?=
 =?utf-8?B?Q2NITjdQUENoSzZkU2wwc3ZrRDZnQkJtTHJodzFSSW5ZYTZEb25zSDltc3Er?=
 =?utf-8?B?S2ZLVHliMTcxTGxEUzJYdy96SUxXeFd1eStycXJFekwwNFNkVDAxZ2JuQ1VD?=
 =?utf-8?B?RnM4VlRnZitVNjBHYjdySmg5aFNhT0hPNFdYVnV6SUlkMmFTTEZIUlJ5aS9x?=
 =?utf-8?B?cFhMdElXQTVwdElIbzMxbUlTdXh6Wnp0bGhGekJZb2QwMmp5QXB0clFTMXdQ?=
 =?utf-8?Q?FmBHiNSjHmAHZ0+Dcc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGNYcUFjZ1hxaUJBUE1sVVlRNEhSUGZwSGpJN0c3dXl0MW1pc1NETHdYUkJH?=
 =?utf-8?B?eEpIeHVuZU5iZmljRGVxeWE5QS90TFpGa3Fad1BnajNkS0pWeUkvd25PR2ky?=
 =?utf-8?B?ZzNRdEU1ZTRRcUVQVzVzTDdmbmFrTGJpK2c1YllVNmhqc2I3KzZIOVdGRXRO?=
 =?utf-8?B?eGZHTlhOeDBweEJMaHBBcStoZTNCcXpIaTFBRkQ1cC9ZODcvRklHeE5vNW9Y?=
 =?utf-8?B?VWFzS0g0K1FtL2ZXMk5MQWhQMm1wVkpoQVk4WE9wL3lzWldSY3R1eGN5QVU1?=
 =?utf-8?B?bzVXR1BVcHJ3U2kvclhKVGNDOFZVRjc3aFlqeVFwMExuRjJwaFNLSytpZWZ1?=
 =?utf-8?B?SmRKR2N1Q2g4UWdiVHZybldIQ2FCZzlTdW56Y0VhNllqZm9UNDQybE9vTitX?=
 =?utf-8?B?ejhYNGZZZUhyaWQ3eW9GZUJqQWZxNjVEUytIaDVRMzFUWXVYZzByWTE0dlFR?=
 =?utf-8?B?ZE52dlJRMVcvY0JYOFY4dmllbUt1VlZobnlreDNERXV0cGU0NXhNbWRKUitM?=
 =?utf-8?B?bk10ZGhtSkk2ZmU0a29VNlJ4MVdQOVdQRjMxNzk3eWc4WHBRRFRubG1McW1H?=
 =?utf-8?B?WFpNQjQ4blI1SXBPK0g1ZHl6NGYrVzNEZUdtTEtKREFZQ1ZWV1dOT1k5RG50?=
 =?utf-8?B?NUF1Tk5DZkVGV2hnajh4ZnFabDFabWdhdFRaVm4wTWREbXh4OUlLdjNLcEll?=
 =?utf-8?B?SlYxZEU2ZCsxYmdJU1pkSkRrbkRwWndTa085YTUwVGEybGxxU3d6MTlvNlpG?=
 =?utf-8?B?VUpieUg3aW9LakxPWDdQVHl6dVk5M3U4N3l0NFBLczl1dlBocnhGdmVtWWxR?=
 =?utf-8?B?cjlqYmxMMDJIU3dmYWhqN1RER1VnSFcwdnFIZy8xZmp5WVE3Wlp6eUYyK0NK?=
 =?utf-8?B?MEVqOGJ4U2hiM0RqVnpxRHhHNjhaalgvNlZaZnVESTZxQ0V2ZGRCN3habk5h?=
 =?utf-8?B?QmxkU0ZlRHpVd2JDaVozVFhIb0ZCME8rOEsxTHFjbForNi80MVF6WHd2TVJE?=
 =?utf-8?B?Q0ZJTXdLak0zNUhMaGRzbENtZThsS0J6bXoxTkRpeXdXMGtwVU12TngxSy9Y?=
 =?utf-8?B?bk1ORWp3YzFmUWVqTnNrOHE0cUdZOEduNWllVFRpcy8vSEZGUjVldTYwSFkw?=
 =?utf-8?B?SC9wdWZsb2liMk9YNVB6VlphTVdVcXJMcGl0YXR6VC9palByOG83MHNjcmRL?=
 =?utf-8?B?NDNLV1lMMmkzTzV4Ym9ZdmRvOWY1TWxVdnJpbEdpNmI3eTNDYmZJN2dVYkJh?=
 =?utf-8?B?ZXlYNWhlbWtMQ3RaZ0JscVZMY2p1ZzU0QytjSDMxS2VLN29sdVJkREQ3MWcw?=
 =?utf-8?B?R2xpb1ZqQWpnVTVYVjJsYXF2eHRmYnRHVWRNM2ZGVHg1YTBHOGZhbkh5MVJL?=
 =?utf-8?B?bjhDNlZOQ3lvQ01GQ0Z3dW1PaUJuSlQrbU9sZFZoSHNhR2RJNXdSSWFScjE5?=
 =?utf-8?B?TlgzcmtBZEFuckwvc2V6TUZKVGI5TklwL2hvK3ZaMU0yUUwrZzFTbG5BelFk?=
 =?utf-8?B?eWk2V1pxRkVURGloL2IwazUrT3JLL1JWb3lsZGtzSE96TlZkNXdEWHhXeVNy?=
 =?utf-8?B?eWttMmlqSUJJR0c3NnNMeUgzV0Z5bndjMnUzRm1OUHFqTjBSTVlRWENTK0Zz?=
 =?utf-8?B?OVMzMzA1SFhQK3NkWms2YUpQK0pnU0MxQWVBRm1HdDZXc1VMY2FIaDZ1dytJ?=
 =?utf-8?B?QnhZY2U5T1dZVCtOa05oTXpWaVB1cGtKUEk1Y0tEV2ZKZm1WNGdUQnNYczJQ?=
 =?utf-8?B?RDA2R3pjWlZzeUlSMExOVkVxcWRjWHJZaFA4ajh2bUtVbHh3ZDNOckNBZGI1?=
 =?utf-8?B?S1ZROW00M0V1VTVDK3FMNmtaOCtOYXpXYm0vOU5kM0s1UU5iZTFBbkltZk5Z?=
 =?utf-8?B?M3lLTWFCUVpHTkRqWVI1Yi9iQk5scjZZaytjdjlWd0RDYlY1VE95bi9RdU9Y?=
 =?utf-8?B?OXFzU0xxVDYzakZsWWdTN1BheHlYL0Zkc1pmTFcwUEtTOWtKaE5yQjNlcmZo?=
 =?utf-8?B?a0hmNzVHeHo2bGVzQVd4emhsYjRaZmpGSXpwWFUyYUIrNFliZ0NGNkduK0ZS?=
 =?utf-8?B?Umh4TFdqRTlxbDRUWW9OY09ocUV2ZjZFTFIwQVJDcjdlb3FHamhNR3NJNzhS?=
 =?utf-8?B?VXBQeGU2SGcwdU1YQ0tWVzBpUldNc1BNN1VtS00rQzNLbWZ2ZFNVeklYeGIw?=
 =?utf-8?Q?q5h2fwzCtMcgRg3fOgeqO64=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	24y7kHq+ptiML5YvgFX/f3Wajl1L+MgcO5kj/VMNNfjYGfiC0VW4WTj/haI3HBAsFzJrkayHO9znPZKLSm/29fJJDlSlLgiEAsMDf3rCA/7f221h03CRniAypmL6/GLHnROyPEmd+xErYJAvo4PS7Kr9tpuSMg9Y1zn6Iiq2nRwpidJjx8iudzllqR7iiYsWfKPPZnSTy5LFv2AOI3nBkZKi4bvbPCtpGDn1NKGBHr2WvhYGr4RVftesxXFz1s4O6KDBOacE9OL9iBZLLn0mKvPF6VFKEPZvSwMpZihR6lxC1Ggg8HGRG3La80d3Q5wI4oqL9IWHBIGZ2GNuT3CaZDXjd5OCN9O0qcjbQXm8wYYdxVQeDe7y62JpYpm6Y/q3SH2x9GklqFrgyBYnO7hhmcmZXMMDvUhwc+wQYs1eEUQDzDSebslHXPjo9v5TkXvUCcvdyUnb5hzgulGM5cB4B3Yo2/JcLdsOhy6HHIchtA3Nu+ryPf/3dzsbsFJ5SuX8uaUpYMCJRNN9Xc4SmGlp/OO7BU7t5VX7S9J2mJDmWJD2GqDNLD1JIBmmLaBhRpjoUozAF9HmJpudZfofGKFMGtmbSLmLNOSAtFN7Rp0IB8k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c508a72a-4633-42c4-aca6-08dcad33736c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 05:26:07.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: um6PsZG+65QGESXSfrDlXa+GNmqKNGXtJej1X/dwUqB0IDZ2qqYvw9SXHFoUS7NVAvNyFgovQK0ss1gEDpGnd2pYag6OF7IM6TnXQ9/brjtlYSG4f4HK+6xwixfpg4Wg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_02,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260036
X-Proofpoint-GUID: dHQf2fUyxM1IUJZtG6cQZGZrze8QYSgu
X-Proofpoint-ORIG-GUID: dHQf2fUyxM1IUJZtG6cQZGZrze8QYSgu

Hi Greg,

On 25/07/24 20:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.281 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.281-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

