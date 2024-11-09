Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B8A146A71
	for <patches@lists.linux.dev>; Sat,  9 Nov 2024 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731168369; cv=fail; b=GLz6A4GuYq+RmFquyS1AtwdKkrWgLneWDm2nbUcbDpZ58MPwoweGvFZgNJEqpU7a86lFu61yqeLNjtMO3my4CMSeO6AUOVsJCaK3ZUoaeQdlt2Rbx4zyjxrl0gELKfrxcJiGSjacogA3vS4pGJI//AfLXipFpu3zOnMXTeazqUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731168369; c=relaxed/simple;
	bh=sup5A7nwG3Rs5mSvM4feBEWDLwWPpyB2j2abC93hq7M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fQPa1QxhFdSwczj7lb6YjppRcsvCFNmGUDnIm5W2026DsQsDppZUF5BSPFjrfxZTCAuSCPhI1iFEA5SK1CUt0AmmfwozFmksoAAC+zal1ZYleQIaeAN7Xkv6sho3Gg747CNaJKt8xut+BCSwQ6bs52E0fLFSWLptprSSmmBXFeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=opYK5RIU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TUIgunzM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="opYK5RIU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TUIgunzM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9BF7AC026002;
	Sat, 9 Nov 2024 16:05:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=LIFs4gSfaAvyUZqtftDDBkgwe7HG630Xzw3mHXbTwEw=; b=
	opYK5RIU2VDQpZ9EyMtYvmWj/vfC/yBtYJL7TXZ+8BhoVhpaztqpNBMQsrxn4NMX
	t8hiLVRKbLUaQyZ6UkaERjytOBEYQpVxa2XEI9/Gn9yNKJ9sjnEOO4ko0mKrnfjd
	vTiKvJ5grgaeR2uLyR3APIk8QKWhHcMnw6l1WzLxjqVl9OgEI/cwpFm+8+kqM/eS
	HlAxKlE1TWnGHkJaT0a7fC5rBh0NGuNbYWUzSDJUrOmOXE6LNY5gyz6jz2mwgIBn
	xzp1Ly1KpyosTugdGFcfsmk+CAx2SU6fuPL+lAJJm5HidOXALdW8jbha+BoxUb8G
	3b6ISyUM9F7Buu14SAOrKA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0hegc56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Nov 2024 16:05:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9FM7m0026144;
	Sat, 9 Nov 2024 16:05:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65dxw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Nov 2024 16:05:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WfTVYqfh7NSGvOvSi77OYssXYNo/X/bPG5kgMODxtMfE/mmw14rP9uhv8tfardelOWGhbk7UlPFlFuKzpKZ+rb4+MC7etFsG9UtgNb2AcpVicIrfwtAzpNV5eYHdGqI4kUoF/VN0T31OlwnC0fGA/R2P25xdXnN77PHaqcEBnwkeIj67l7bcM6EquDaHry+MLE+b2LXsj/dm6br7TWciv2rbQHd4Fxo3OLbwgIfynpaKc10Oi1bDqIl236AJTw5T0/Hli68d9yzaLoyMBkGYr9gas2q6MM34LO7gB856PFz0SqeurAIdmQm6tGnV/YeG4+Ni5NsP1nOcdXbIAiPNzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LIFs4gSfaAvyUZqtftDDBkgwe7HG630Xzw3mHXbTwEw=;
 b=ILoLIpKl05FM//GFUeFXJFdHdwmtGekbo+gLB2gjEMSKeqq4YjxlI53sWR/rYpyzJLIUrgTZyhvbqjCGWr1L0yRGpr7XUwHSHhMa33fpAVjJ31qLPTGz/bzsANiK/UqCdzht34u35JwOycwvJak9Bi+WdKoofKOL9xNJp64OA3/q38OfGKMvI6uebJQFpvO7C7aEQieKjWTDhkx07zq8VpxKlS/c8XRr89Hx0l+8gv335b78ayiZ8iRq1z1qOP2F10gItrqCdRbZUOAsby/L2MfSDrMQ/HnvVXFdmZDz10Ly9SwxOjESKDDL/fYBCw5smgmysMVCZLTgntLS724Htw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIFs4gSfaAvyUZqtftDDBkgwe7HG630Xzw3mHXbTwEw=;
 b=TUIgunzMT6B5KYQ7h2ljvo1ZrpD2NkDLt8Q2xsjKyHXSGtg6lKGY1mbruocHZbpvYwbfXbcgvBPZqUqpwe5uA6xmTFrjXJ7SQ6PNzqbPFoOoQfYVot7Y0mNkZZ4Hk8/bp00xenLmOif4CjBlKyxyJ834XDlQClZ5QOWsPYnZyY0=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Sat, 9 Nov
 2024 16:05:54 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8137.022; Sat, 9 Nov 2024
 16:05:54 +0000
Message-ID: <e8a09c1d-0675-40a9-9bd4-bc6268456da6@oracle.com>
Date: Sat, 9 Nov 2024 21:35:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/73] 5.15.171-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241106120259.955073160@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0021.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::20) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|BLAPR10MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: ec6b483e-babf-4d43-8c34-08dd00d86380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azQ1QVhiNEcrU0pvakJXSzFWOHZuL1IrVVgyYi9ZYnFCRTdrc3VxRmdIOStx?=
 =?utf-8?B?T1Rpd1dhdm9hWHJOUHR1QTdMQXVZbGw4TkN3QnJ1SmFZcnBCQTJSNitxN0F4?=
 =?utf-8?B?b2oyaTF2T2NremNMRVcrZVlyQUw3QlVQUTRNTjd2WWtGdEQzbXRZVlNZTGJY?=
 =?utf-8?B?b1l3OFYvQzZHRHVPd3d2R2Z1a1QyWnp5WDF0YVN4ZXhIS1ByMVlzQ1pMMEU1?=
 =?utf-8?B?YlJXNmQ5ajBmdmd6Um9EV1dsdVRjVVJrbEYxeFAyWnFwNUtjdTNwWGdPUnhI?=
 =?utf-8?B?UTVLNTRoOGo5WWlIcUJzblR3Mkp2TmRjQ2V5R1BSTE9QRHovbEQ2ZDhJV1dH?=
 =?utf-8?B?UWVPaWhLSSs3SXZZdjRKVXhRTG9QNjVnSWlNdU1KRlQ0eWZvSXFlU2x2ZlFT?=
 =?utf-8?B?bWZrR1FFTWd5em5tSUhiUXlIWURERnl2emtzeU1IWGFkZFFRS3NWRmo3TlB4?=
 =?utf-8?B?K1BiYjFsU00vZ2czNWNCVEkrYTMxWW9SSTVlTk1tZ0hoRFJkcjRuUUpNcUU1?=
 =?utf-8?B?ZHVFbVBzN0F1VVNwSDZzcnhVTE1HaiszWmoxbUF0UkY5NDlNVjZra2tJVGQz?=
 =?utf-8?B?V3QvNVl3ZjMxbEFHSFRQY0F4bXhNU0V3NEdJcGwrRDdocTdJZDFiTlVocmhV?=
 =?utf-8?B?ak9tS1ROanJtRUx3MGZKeUVabTBWbmZ3enIvNU8zZHZpNzZTbUtUQjJQREEv?=
 =?utf-8?B?WS90WnRKRTExWWY4YzN5NXFZZm5VOU5MbEFRcFNDOVJrdEh3Yk81MEJZMEVU?=
 =?utf-8?B?cXAvajdQNlkvL0RnSU81cUE5ZDZBZUhhaG5oK3lqVDZEeC9uK0g1RHpSS2RL?=
 =?utf-8?B?VWkvVitMamp1MWJqVUxYbU80QmxZMXBkV2lVU0pKTmhsYlFidGxCQ1lsbkN0?=
 =?utf-8?B?blJ0NDQydHE1SVZTWjBBaVlPRkU4WmZJVGJ6TlQyNUxSS0NWbUo1RnY2TlQv?=
 =?utf-8?B?T1ExNlJHRmRrc2VsS25SdTdpRFJjUTlRWmNqQld6T1l4UEpZMU4vUjlnRTEr?=
 =?utf-8?B?WmlyKzVFRi80bm5oYUJaMTI0aXJ6Ty9Sd09BMEozSTM2NWZsa1cra3JOanFI?=
 =?utf-8?B?ME1nRjhjRFpub2ZPSUtQSlJjaDllRElCbmI5eUt5WUxqZEhBci95OHplWlFz?=
 =?utf-8?B?VTBpaFZkV3F3V2Y4NlNzbzVtbDdUQUFnelhQY21USlVnR0pxMVg4VGlCNlJG?=
 =?utf-8?B?ckloTmFnSHpHbzdJQ0ZuYWtueXZoZUh4ekVVb01sU1FoOTZnK2JHUkx0OUwr?=
 =?utf-8?B?RWhiRVpSdjVHV1YyK3VyTXlpc0FJRzlyQ0hGcURtRG9Ld2t4TmlMRTE0a0tO?=
 =?utf-8?B?WDRDY3p5cGVvUjFpSExTcDczWHM0anpWWTd2QlNJUXBadTJPY1p2b2M4UmNO?=
 =?utf-8?B?SGx5Y3F4MklQMWwrdXM3cnV3WGV3MEVCUXQwWjd0S3o2eEtqV3JiWkdvVjdq?=
 =?utf-8?B?VG8wUFRpVVZnbFNGejRZb0JuRy91NERFQ24vYmJ3SlFUZlpHL3FCUThUTGJJ?=
 =?utf-8?B?dnJxaktkM3VHNGRwYUp3R3J1c3ZtU2hvMjUrSTZqV0NQbW9IR3BSNUg0Y0Ew?=
 =?utf-8?B?am1hbWhCU1RVYm5uRmZQWjlTd0pic2pEeXgyUXA1b0tIandqb2VFVlhqYWpL?=
 =?utf-8?B?c0pqZWZlYUlna3NHQm43aTJORTRQRzJaSnQxelVGRy8vZDRVa1k2U01XNHVD?=
 =?utf-8?B?QXRMM2JEMXc1VTlORG5pdmQ1bjRYVDZrZWErQzQwZE9DclJZMVhzQkZzNEEz?=
 =?utf-8?Q?ccd6l5NAVSe90jAlNBIICgF4eAwjP4vSNHCtUkw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnJhcjVGQ3dXVGdxc3lYdWlVMTBBZ2w4UHdlK0xucG5qY1E4NjkvMWRoNUdl?=
 =?utf-8?B?eGpaSFN6bXpEODBXR2VLdURqUUs5aktTNFhwYjNtK0x5eHZ2RHpjOFUrVE5k?=
 =?utf-8?B?T3lZbXY1ZXI5TThxUHBJaGcrblBDQWpEaHJqNFcwYWNSN2xpK1FNOWltVDZZ?=
 =?utf-8?B?VVovcWpCWHFLMDJKNWJjOHN1VGNxcWkwQmlDWUsxY1dPdUdaTDZMdGkzVVFJ?=
 =?utf-8?B?OUpQVmZ1ZWdZeFN0aDVIdFJQcCtNa2svSUtFNXdNenUrbUU5R1d4MCt0M1Ji?=
 =?utf-8?B?dFIxejRaQzdkeGVMSDc0OWZ1aUxBQVRlTVFTZUR4a2JQWDByWUJ0ams2RmJ5?=
 =?utf-8?B?d2pMQkRqejZ0M1pKT0hhWld2Q0E1d2M4ZjZTR1luVzJQQkdXbzBhbEgyeUxZ?=
 =?utf-8?B?cHRmZFhVVng4dEI4YlN3UXRYclZHd2RPZ1gvNHhkcldpZG05R2NNbzVlMExR?=
 =?utf-8?B?UnhyUk9wbXdXaEpPWUpKQmU4bU9pM2hJUGYzYzkrOFJidEQ4cENBa0o0T2d5?=
 =?utf-8?B?dUZma29qK1h3Mi9VUmxscWwwK3JxM0p1c0p6RVlwTzVIYStWSjQ3MDA4WFBW?=
 =?utf-8?B?STB6S2RZQjlMTi8xanlnWXlwaXhFaGxVNEFBalpydEkySWFPK2VWOGZZMCt6?=
 =?utf-8?B?TGxTSjBrY3RtRHB1b2tKeW9UekVhZ3psbGNLbmVFUkNGU0FhcFUrSVJIbGdS?=
 =?utf-8?B?MVlDeTA0cFA4cTNVRFFXSHhHT3lRNk4wWkR2dlZHVjRkSG1DekRWTm03ckd2?=
 =?utf-8?B?WStxVHhES3QrMlpjMWNmTXRNQjNrc1M3Si9Ga1JFcFZJeS9HdDAzOVVWcHBG?=
 =?utf-8?B?alIrc25DUHpiSVNOWkVOL210YXJvcE96eWdXV2swY3lqcW1VME1iSFJFN0FS?=
 =?utf-8?B?Tzc2dDZ1S0sxVGp1Y1BkV0lvM3IzMDlzOUJ1NjJkKzJVQk5MWmxkYURsTXF3?=
 =?utf-8?B?Sk5iVDgzMFZ0dlBuc0xHYUJjaFVReFVGVER3UGdCTVFTR1d3QmNlMzJhVnJt?=
 =?utf-8?B?M3MzVUI0RG5rY28zZ0w3MjZ5bCtvdEtFUkh2VVlXeFVMWnNZby9vSFYzcUV3?=
 =?utf-8?B?Y2kvOEdta2hDN2F5YTVUK1VVYmsxTW5Ha1p2SmlYeHJlKzhkMkZiK0lhbzhO?=
 =?utf-8?B?RDFiWVVIUUtuZEZmYk83VnhHTEdEellhR0lnR2JpdU9hc2tGUkxJcFlMT0R5?=
 =?utf-8?B?a2xLQVlGZ3VzZGU2c0pDMWhGd0VMYW9kMHdpdzRFdjZpUEdxT3F3TmZaS1BW?=
 =?utf-8?B?UktpM3FwUEd2Sko0N1hRTldaU1lWSUtFSnZMdWN1TDlPNitWaUlLaFRQc1h2?=
 =?utf-8?B?TjZvZmFyUzlwL3hId0pBNFlwSDU4dWl6cFhvcnY4REw1U0Ftbk5OaU1jQVU0?=
 =?utf-8?B?U1pyNzB1UmtnNGF5YnBTNzEzNDdjcjE2NXNXR0tLL0hFSjhiTVp3UCtBSW01?=
 =?utf-8?B?ZldHeWZFU0J5elJ0NmVOQk5sQ1JSSkx3bE5TNzFYeWdBcFRaeU5RazdmVlh6?=
 =?utf-8?B?WHhVWklic2xHdEZ4eUh0enJBdFlKK2E2M1E5VmgzZnVRTTlqZGJLb0IxVnJB?=
 =?utf-8?B?ZTM5enVUMldFeEJMNGhiZDRPWlExUFY5TVJDZ2FzcE02WlN6Z2hPalRDSzkx?=
 =?utf-8?B?a3duR1NlS1pBb0xDeUk4VU5pVGFQMmRRQzNQeGs2SXBrZW9zWElNZmpPT1V4?=
 =?utf-8?B?OEU0NndobjZyQ0xYQW1WVjRVQURYTm9WVE44RzE0dTdSYTk2aWMwSUxIU05w?=
 =?utf-8?B?d0QzdTdBNDlQRTV6RjMxMkE4WG9mQmE3b1kxQlpMU3BsVjkrVFB2Z2NSN0Rx?=
 =?utf-8?B?S1VFTm9XcUpUOUZEYS9EL3g2c0loKzZnUHh2T2Izcm4xcEU1UGpmTjlyK28y?=
 =?utf-8?B?SXB2eWhqaysycmpuaXJTU2FqdDB6cXM5VDQwTWQvekRFdko5NDdyc05lSlJi?=
 =?utf-8?B?R3VnbW1XallDS21vK0FjbWFUNmw3ckV3cHRaaEJZZFh1N2Q5UUh1TXRxOTRa?=
 =?utf-8?B?OTExRW10Z3E2cWN6bFI2WjRONmpGYzcxTWV5R2JxajZPWW5Na1ZCNTQ4a0lF?=
 =?utf-8?B?ZVB4RS8zcVpIVzVCSiswUGpiV0tLalo5aUdyUU1rbDVVNm54dWJZMUtwNHhG?=
 =?utf-8?B?K0VCQzJHZjZkVlNtaW4vUkFjejFGV2liYVVOZUdTeG9VQ0ZTdGNLTkE2TlFB?=
 =?utf-8?Q?tfQ58ahKhdp00VANP3vXvz4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BTSbAtIuoyOM4QlVUlogK5NGUA1qbDBgG5w4VJcpgpaOB2aXUEYqRyUdaNJl6uWdBbwnUtbH9OuX5I0TSOOsi0JsTXNTSgfHM0atwcvtB3YyYY05CHady2oS/NtKxVisXEQd5iez2dQ6OdU6RJcdw92Gv0edPfHPcgDYP5d7ryU4RXZXbue8N6VWQAql3+pw21VfDKSNBgKkdnsNBa45P/bkLEOQAJMVukYLJGVjsq1UDGAIHXwCzEBvg50K8O55lj4VSdN4+ouaX15S1W5HrznNwzhYPSVBqhpIM1mteKDui58QTqpBpjr+0aSlKBJIOinqbAbQzrXbZ60+SS6y4Y5i6436HgspNTOhagxnmcuUc16yTUyW+t0xLMduw/uP9KdodSU9RxQFPXnxWg8qtOAltwyod8LID1dzpW1Q9WOoiNQ2C5NbRzb2l+nuct/wyBs+9WmbdUfyws3sPdkYpQEvLnf4mxQpJmkYBxh9vkotpeGncCfyyZfieTVsUy4e+tNh+tSHa1xJWV3Zh0vTaA04CHG7mJ4EZ873wzhPOVs3Ki/+CUJ3V+Ab1amFIbhrYOCqsj6YyxuQebs0Pk0WPynLQ5ESHbvG8q5emXgQK14=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6b483e-babf-4d43-8c34-08dd00d86380
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 16:05:54.2083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8qPEaGzGmqlTqULSab0k557lJRSs+h1MqGBcvTert4PSP1/S8Ok2nx7gfnkw6gmvF+Cg/+SIgqYDTrkWyMUfqwJjPRiPVohQQwQc7o6lq/kYdri41F6bibMOr99VLuo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_15,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090138
X-Proofpoint-ORIG-GUID: 3YGGbdgnKNWWVtpC7h0A8ItX4kYxjO2C
X-Proofpoint-GUID: 3YGGbdgnKNWWVtpC7h0A8ItX4kYxjO2C

Hi Greg,

On 06/11/24 17:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.171 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

