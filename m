Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E3A17B506
	for <patches@lists.linux.dev>; Sun, 19 Oct 2025 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760887197; cv=fail; b=Gz9fyguDjD3SFUJ/2X0bdN8O7Cc/Jvdva/snWtOZElNCm5dAY4/O1iGhStEvrOzYhoPbrw33vmwlNI0hCyKs3CWh5aK3iZIL6JbiLY3q8i1+jCS73rIk7IGFgHWechg8NoJb6RmhN9NN1hE6kgeS7gc5NMvP9ZSL3wTqSrLSo8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760887197; c=relaxed/simple;
	bh=8bpqI4AlcbxvrIdPef/+i5ks+L83M71kNztmF/rdpZQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YokO2kWVglTpPmo0BEonQ9MSutJhP22ydbJQOBch9oFv8VyWCeO9hKSy1GDw2H2e7l3zERVbLm/cohodNqr8F/ZGj0pSQ2kqa2zc/bVOGRX05lb+/19b3n4i7NB4mzhmdNzb1z58oLQbioenC+yd+DQTdQUy2zNDOjsiwjbl5QE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ewkiJM6r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m/0Ixv6b; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ewkiJM6r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m/0Ixv6b"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59JAFdT6007933;
	Sun, 19 Oct 2025 15:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WFcdTBrZg3BmefUpdA4eNCt4APrUKZMw9ryVBx696no=; b=
	ewkiJM6rNSnUS0GzeMJ419WuAEUHEXuzV1tKmLQka4z2oqnZAVxUFfQ2X1VZJpgB
	MwA9vxAUyN1/TLl1M6omzYdKjbX9XMbyy8kcxcbb5aMfnhRMfE9n2Zet0ri74UQT
	eYCwApreSIEAMa1i6uHFbioXHo/Jr5OOcVc6a9Waz/vnRwEtQq4ltLTZlRcW66l0
	OpyBPmMriI7yjwp6UPLC22oW7JcVzQceS+cNtW1KfnXDvy/PuS1VZVBDErwOOZ+y
	nUoUnmeACKk952tIaCFkXtnPDDQn9hx8+E1ATGsb78VQkghahf+S8UBa4z8ur/lU
	73iseRovn0vhhuw09vw1Fg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2yps3cf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Oct 2025 15:19:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59JE1Rnt035178;
	Sun, 19 Oct 2025 15:19:53 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012062.outbound.protection.outlook.com [52.101.43.62])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bay485-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Oct 2025 15:19:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAGlSwJIOhnvvBkpwQSvuRvjnB/FBwMEFY7+7Hrgy2fgVoG0XjlBdwpKGIdokf4wN/wdwJJt1DF1152iMkHUwCE9QC4uspAnfCp1OWuS3U4iEx7EL9btOBo6HmO83Pk28jssorAy/UQSRXHwPTVZEnjU1Xk5hVHgi4iF4BvYiI2uWSkJ1uM5cVhbJQooXuJP3sYiHId0R5ZO8SDvTo3dQJi1YvyRu8aLDgp0whWYvPWoDI10/pxE9ByQ97MY7X5b1q/iKRQ7JYgWnl4EK74LjgTrmgi5g8tKbdgmXc7AsW3mMjES095dQ2ghAfBogmDsZBhI/wfVgccOy2Vf9ShJtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WFcdTBrZg3BmefUpdA4eNCt4APrUKZMw9ryVBx696no=;
 b=Qb5CKY08dF2o9qnhpNcKxoxa7SNYDwWDrrZm+WQq+4dsqo1rp7t4KpV3nWWe9bjaJz3UqzZ+nWKwpkrj2PZXt+SiNkd62EP0yyEiTWD3K96r+fikW78heSTGYQwOFESfjqJSpop+0+OgPPROmFSnhteTYhlGO8RvoXarlQ8xOsXAHNLJEoG6cEAP9sbf2EB1dR5HMfCcJETVcRbgQKubANmWir86E9DipZpbEnrAb019xgtY7N2ggDVLWDmVCYmGkG2dF2hZpm+x43OIzZNkSRo3jNuKdxC4+/3fi14J4wpWtGxshzuY62rqgaxgOtrrG/uNCgZSp/lHHqajmegwBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFcdTBrZg3BmefUpdA4eNCt4APrUKZMw9ryVBx696no=;
 b=m/0Ixv6b8HGBft05nAwX89ndyupMU7c0WOi/O8GbglvsGC3BKyGDx/2bjCw9O33PlHCRkxE586B6U3fisBNR44uiwB6NjWWg0ZvX/wWH1YlVkzPNckiIFh2hxUjvUPOMUQJykCIxYTtDPF7etsEUTYrPa32NrIGXaH5W32mrQCA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA1PR10MB997583.namprd10.prod.outlook.com (2603:10b6:806:4b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Sun, 19 Oct
 2025 15:19:51 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.9228.012; Sun, 19 Oct 2025
 15:19:51 +0000
Message-ID: <ace83083-7dac-4b55-9c71-7e190b06af63@oracle.com>
Date: Sun, 19 Oct 2025 11:19:49 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 276/277] nfsd: fix access checking for NLM under
 XPRTSEC policies
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Olga Kornievskaia <okorniev@redhat.com>, NeilBrown <neil@brown.name>,
        Jeff Layton <jlayton@kernel.org>
References: <20251017145147.138822285@linuxfoundation.org>
 <20251017145157.237029632@linuxfoundation.org>
 <dbed118e-fbb1-4fed-adf2-cc6213aa93a9@oracle.com>
 <2025101933-bobbing-eagle-5c82@gregkh>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <2025101933-bobbing-eagle-5c82@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:610:4c::31) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|SA1PR10MB997583:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e3bb7c3-c70f-4386-2132-08de0f22f295
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?YW5PRW13NlhKVVNEQ2tpa1lWZHpuS3FKTnZLWkNrekJydWJRUm1yMWxmSGFw?=
 =?utf-8?B?bXpQNm9kZHZGTDgrWElqWERFUkRkMFdnZC9DbUhqdjNTcGVXL1F0dkhGUUJO?=
 =?utf-8?B?U2JMSTQ5Wm1pL1NxdU54WWJrUXE5b1FLMU1OdTg3dGlRRE9TYjkwZ05CZk83?=
 =?utf-8?B?d2lUTW5GVGpLUUVrZi9xQkZUejAyOUZNeUdaSUdMVlozUmE5dmxqLzdIRGJF?=
 =?utf-8?B?a1ZzaGZLMTU1dHZleVdzVGNrcTZvWEZncHdKcXRQcEdrSUt5clJlUUxOczdt?=
 =?utf-8?B?U1oxZUVEcDVDRWpscEdsNnA3RUdSVWVTZ1VpSmJSREdHUlNFWGdSWkEvWWpo?=
 =?utf-8?B?VTlJbTNjTm0yL0Ezbm11YWdVV0FURHVZNHZwOGg2RjZzdU5TS2t3VHR3cUE0?=
 =?utf-8?B?T2lhcVJNd0psRlBLVHZPZnRuOE4yNFprMjlqWkRCRmhoa1VRdEdscC95T3lD?=
 =?utf-8?B?MlhnWkZ6OU1Zc2ZhVU4vVkNadVcyZm5DNWdZbkRnWHl6eERsTzZtZGY1bjRG?=
 =?utf-8?B?UGRzQy9MK0F5bGh6OGtaL1NJZDBSTWZjTU9ocFBEYUIzNkZ0QnhVZ2V2TzBW?=
 =?utf-8?B?SjB2a25IQnNlaG1YTGRWendrYXhyZlhLK1dsU3BSK0hZQTY2Vk1rNGpQSGVI?=
 =?utf-8?B?MXVjOXNpWmcvKytPaHZuUlpESldyNHRNMXlVN0VDVVJqS0dTUnZGdE1OaTAz?=
 =?utf-8?B?ZkdST3Eyb0xFbGpTVS95YlZpcGFaMHR1WmEvS2trNG5kR2R5SUxSZDBJS09I?=
 =?utf-8?B?K3RFWkJQMmFkM2NrVVFEWGZycWIzU0sveTgxTWFPQW9UaXdUOVhnZFk2SEVO?=
 =?utf-8?B?VndDbG5SS0t6MXZWcUREeFUvZ2JYOVZLVFl0WUFwdk0rK2NIbFl3KzRwNVZr?=
 =?utf-8?B?ODVkQ25GK0xXQVMzQjNBSnhWbkRlZTkzWlFFd2lmRlRQUDNleDJqVHJxRUtm?=
 =?utf-8?B?bENvZXF6Zkp3cW8yMTlMNGVRb3pGejZvU250Y3FvY3NWblN3djFIa3V0MXlY?=
 =?utf-8?B?WGN5S1Z2WnI5anRrQmxUUFRtR0NXMzdmTHh6a2JBMlZpTkdEekc1WHQ3ekhR?=
 =?utf-8?B?dGtXV0tUOXB0cGk5V1NkOThkVG5VdFN2cngzdFVIQ2hGbTZ6UEYyQkpSbnFJ?=
 =?utf-8?B?MlNad3NwcWJuYmlKMURHOHJRTml3MWpkaStwdkhwT3JXejBrejJiM25hc04x?=
 =?utf-8?B?dFNteFNURFFIZEVadmVuNFZVZlJLU2FJblI3R2ZyQ3F1WmZNWjdNVC9UYmJG?=
 =?utf-8?B?MUVCc09wTlp0bmFUYVVjdmdRMHRPMXdMQmpoN2F2RE5jcVZGWVdWcWFWODNP?=
 =?utf-8?B?WEhEYUZhbUtBOXJvTk5Ra250bFJBUWdoRzhYaVJRdnVOVmh2ekxNdEJ2ckVX?=
 =?utf-8?B?RzVXdTJUQStzbERsNzRib1ZCL25Cb2JNMlFLYkxXTHV0cVhRemNaeFdxL3hn?=
 =?utf-8?B?Zi9EWnZzU0diN1RhUER3a1g5TXAreFVHUjhmOWIxOUI5ZlhMSnRLUWIwTnFi?=
 =?utf-8?B?RTFUWXhLY1JaOFFqR1E1ckJNWTRwZzE1L0pEeDJVNnRXQjNDejkya3VrQUUv?=
 =?utf-8?B?d1cyTVBLcVRjbGJIY0Mvb0Z6a1J3Tm9EM1VWRlpYc2dvOUNGcUhjZlN3dmsz?=
 =?utf-8?B?dkRQYWZDMFY4YUNidUQyRzhsK25zQjh1T05CaTZOenhaVUNzeGlKSVVvOVox?=
 =?utf-8?B?cjNTRkU5Y0JkWDlPYXpwbENjejBBb24yY2QyUXRCMUVVTVNJRUFTNkZVbEVM?=
 =?utf-8?B?ZURPK2xqeUpMSGdrYXRmQ1lJNTNvN2R6R0hQZ0lLWjhKQndRQjhOY25UOUNq?=
 =?utf-8?B?OWF6NTdVU2F2eWZwK2p5aXcwcVI3SUtvM3FZbmxXVWR4ZXpmUXRCQTdEa0lE?=
 =?utf-8?B?NWR0L1k2UnFiS01rL1BFWG0zYXMrUk53UUtPU2xWT21HSyt1bGE1b0NtQWdE?=
 =?utf-8?Q?VKYX0y7IWjCEs8zrGFN76cHn0M49vAoy?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SEZucjVWY2lpa0hYSkVjZUc3OG1WMUtLWldQbUxtREpZOFMza0wyaTJoUTJI?=
 =?utf-8?B?YjdNTXk0dkRsWVNteXZwdUFXOEVYYU5aSmFYYk83MmhxMTNqanV3cmZxbk93?=
 =?utf-8?B?MWcrVnRFWkJqSUVIM3F0cnI0RmNPUkhhcHZ1KzlOdjYrTzhZbE9CK245ekxE?=
 =?utf-8?B?aWMvY3E0TmZBc0hkK081OXAzY2JDUFRZck1uRlc0OXQrRmVqcVNzMGhmNEpE?=
 =?utf-8?B?cDBmTkFud0JsYWE2c3QwL01RRHhkUFNOaDVYYTU3L0tsbXY5ZjNGRWtpLzcy?=
 =?utf-8?B?UndyYzhBczMvQTRsTHc5TEdQMTdCeG9Na2hpZDBJa0NmbHlUS1A2YkJ4ejhR?=
 =?utf-8?B?QUNFcWVHODZWd1BxcTZYUUI4ZEJwWWY0SFN5Vm9SQUJvVTMyeERNQmc2eGdH?=
 =?utf-8?B?QXdLbUlyZmFTejl3dDJwTHdMalpwMC9OTkY5NFpDVHNuekZXdjBWM3lXQkJB?=
 =?utf-8?B?VGVDYmxCb21vb3k5MitpK2VzR2pZVkQvSDBIRFdhMDZkNXF0TWZHWWFFYUVC?=
 =?utf-8?B?RjNrdFVGb3IzN0hVajZGR2NtWUt4L2JMN2hvWVErejdjL1ByZGJhOTFQc2Ni?=
 =?utf-8?B?UnNQU3gwaUxOV1FCREVvSGlnM01Ld2lWMjBCYzBkRlVPeG5DTnh2RUZ3bm1D?=
 =?utf-8?B?NmNyRUIxUEhqMXgvZ1JUSEFiczZlYjgreVQrYlFXVkpsNkVIcktpUnhnMnRP?=
 =?utf-8?B?WGpUTFRiTlE2VmJ6SFhkRTNrcHRmY0x2dXhlM2FEaXFtYUYvS2FFcE9lWWJL?=
 =?utf-8?B?R2hDaHgxeWpHVXc0VUlueisvT0c4eFlSMms2bDc2SGcySGdQN1Ard3cyZzNE?=
 =?utf-8?B?MHhWWGNzQ1Fpd0NFOWlVeEIrV0ZQcnpNNzlIcE5ETkNLcktyNFdLbEtVNUEr?=
 =?utf-8?B?WVlhUlowU2ovdzErTDNWNU1zSzJTMG9sbUpoY3JaRWdIdVJnQjc1Q3ZLd0hS?=
 =?utf-8?B?S1NiRGM3aU80SGJBV0VlejI1T3htaXl4di90ckNyNXdlMVJUaHE2S3ErZ0RX?=
 =?utf-8?B?VXBWRkgyWkM4SGpTd0pLazJlVE4yTUpGbU9PekE5QnlZcU1STWtEV2V2K2pP?=
 =?utf-8?B?eDNjTmdta1pkNkxqdGFHYmJpdnUrMEtJa3dSZXBCU0VIc29jZGxVQUplSlQ3?=
 =?utf-8?B?RklYZVlwTDM1VlRDU2h1YkFpaWtqclZYMDRKYWFYWEE1SHNpOEZBSUtkZzJv?=
 =?utf-8?B?UVAzdXo1M21mTDN1U1FTS2lQUjZoeEdLQ3ZDVy9ZbEhRV1M2c1BVU2oySzQw?=
 =?utf-8?B?OEtZOGVpQTJpa2Q0bGlOZ1lpRTdrTFZJY1JYRWU0QmRzVkE2QXdpQW9vSzFL?=
 =?utf-8?B?SFJjRUUxY1d2NjFBM1c5QVBacjJoVlFJWWJQeDlhcDlhWENHcS9tNlpVcGdP?=
 =?utf-8?B?R1p6c1NjL1hxQ3NBcWZvU2NOVC82OTNNYitsSVdBaWNiTWJYZ3hKNTlWanFo?=
 =?utf-8?B?MlJOWk00Y0JKdUhpcGE1dEhNUEJPaHVETndTTzAyeDExUjdtaHlmbC9CWGpI?=
 =?utf-8?B?cSsvSnd6MnoxdWNJVW40SkxZa2ZFOCtRbHZzcnNoaVJIeW1YNURKcHZaZE5x?=
 =?utf-8?B?a3h0WXo2SDZHa0lHRmg4NXNvQi85UUtVd2c3aDNQUmxlWDFMaTloL3AwbVpt?=
 =?utf-8?B?VGk0MGNmdHp5SklUd0pha3M1bFVya2VrcGtjYXRnVnlTUlRuME1iaVRJd014?=
 =?utf-8?B?bklzVnlFWFdxeVAxbThRVS9LU2t3Tjl3a3l4aVRCUnpPT2lZU2VITHJNTS9B?=
 =?utf-8?B?eG9YWEtDR1Nyay9kdHV0Y3RpWGRoQlo0YkpydU1ocSthODJVQ0Q4ODNFbEZl?=
 =?utf-8?B?YU1zQnF4U3RkWVAybU9HLy9WazVHMzBCbWdVMHJ0UzE1ZVFUeEp2dmk1TS9U?=
 =?utf-8?B?cFUwakI3bEt0cWUvcmM5ZTQwYkV4NzdrVFRUYzZoaVNraXdZZ0UyYzREbDc0?=
 =?utf-8?B?RkZHN3Eyb3FFa3MxWlBWTkZiS1h1ZjRjbGVETWdNdlhGZEVrelN3L3ZjNFJF?=
 =?utf-8?B?Nmc3am9XT2hXbThnaENma2dBaUdiUFdsajVEYnRDSUtqRUc5dGNzWG5jUmZY?=
 =?utf-8?B?QWJoMW9VS3RTcW9KaXF5QnNwdWlhakU2UlhBSmF0VlNQTmRCT0xZbUtNUDF4?=
 =?utf-8?B?WFBjaDZWK0JiMDdMUktFVVBBbFQ5b0Z6L3RDK3lXQ1poYU53T0pLZU1uU2pK?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IpPYLV5tHgEnNXshrm4s3VUhfhLAf2zFjEE35obIVssCQqWZBQpdGPAFIvsoSLQqkeCrifN/Ab3Faxqk/USdGCPVW8FDZv1neUBhgSCF9DN9VFdoHaEc13Qu0Pjgj8+sd/W1z1ADNJpcyuvP/J/89zptRq3NvGQVA9DFNAqURaFgLK6KG1r9kyHWDCKiqRfSk8/4FRJNJvaGzcOCEXpfI2dz38LlEp8/+A9ahC64QD8O+iaM+gZF/nnw6cfrvaUzb/waSTZuSXQ/AvMmOF4RF0b1vT+EzQN2ymFurhTqMq+qcU5ZhzZJQJXdnSxXU1Lny/oZu/mtEB5aMW+7npzJC6ok3KAdmEMPgVlhGHGv5N4UX5/+2WHRJldQjYymON0SiSzFeKpop6GcmvDct9hH4Mg6TzAJB/4HdzhxtVkRScFSYOuRFXS7LOKt8YpshwYw9SUnPKI87kAyD+8O2JlpP8iT9Mz1Y8TFay5235VyvqxOXHfaxgdpOmdkskx2tjBiIbZiwb+i7Y7QAji3rFbybpyIuhYX5q47Is1ieWA6WuqnkB3y464K3JMZ63/JaKMq8oO+Atg74pnSNSaFhVl8khRHsJs2CY38YrlSqz+z3BY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3bb7c3-c70f-4386-2132-08de0f22f295
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2025 15:19:51.0395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9gZTmRjifEBXf3XXCwYmdEKSUY21SywbuX0E38NwNLyvySi33M2diNNZv2NLX8o8WbDWNbayBiF1hhug3uWFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997583
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-19_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=866 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510190110
X-Proofpoint-GUID: WejiB7W3kMjxuRlZRTxY4HXC8rz_hazR
X-Proofpoint-ORIG-GUID: WejiB7W3kMjxuRlZRTxY4HXC8rz_hazR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXzexX2n1LuH1M
 NHfi/phonNkd/wmfcouXw/cYIoI14hxE0L2fbzYFuOrhoekEuM1/+Uda3f8M750LpA5rlpS93Hs
 ZDEph6Xuah+8G5ufJpwTpb5F3bx7ZzKmqtfnSqUSt1MuioHHKMr1AfpPniKLCDprCazVgU1Slq1
 D/WcXxzTeH00cZDND0EvfYjTBPZGuoet88t7ncY6Rol8XIU45+vVSkAu+NjtJJ1xBwsgynPa0XO
 j8K/aNZLGvkwfZfvu6noPaNgwnkiVFSsJy5WMBYbVAFO/WEUXdrOPOKzGYT3EAwndKOpnwPx+0b
 7xWbM2Ru+wrN0/wWMkqyzT/pvovAFBQZG2IXlssJbGrB4Qpb+59kJCJmFRy17ACCzhmlKXjQtM8
 WfcC/VL77/Whdm/By0rSehbR0FJP/e2y4d53UIhI8vRGPCE4/7Q=
X-Authority-Analysis: v=2.4 cv=Nu7cssdJ c=1 sm=1 tr=0 ts=68f5019a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2isg0WKsvXsvI0d1TFAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12091

On 10/19/25 8:25 AM, Greg Kroah-Hartman wrote:
> On Fri, Oct 17, 2025 at 11:32:49AM -0400, Chuck Lever wrote:
>> On 10/17/25 10:54 AM, Greg Kroah-Hartman wrote:
>>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> No objection, but a question:
>>
>> This set of patches seems to be a pre-requisite for  "nfsd: decouple the
>> xprtsec policy check from check_nfsd_access()", which FAILED to apply to
>> v6.12 yesterday. Are you planning to apply that one next to v6.12?
> 
> Ah, I didn't realize that was a dependancy here.  I've now queued it up,
> but it looks like that commit still needs a real backport for 6.6.y.

That's on my plate. It looks like it will need a by-hand backport. There
are too many changes to take the upstream patch directly into v6.6.


-- 
Chuck Lever
