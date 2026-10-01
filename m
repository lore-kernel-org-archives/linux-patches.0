Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E627E361DA8
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 20:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790887165; cv=fail; b=IxrzflHTJoRh552nmXVK74Cdx6OhYS7l4IbZgSuYlWi3wftwKGfMRnclHDy+GY29lB/yJjo4oBk0Kheh2SCRg0bU3Y6Tic9pea0PYqq0EeQFaNuvV7U9Olhf46dmexY96FTaoe3kjUBIQJaWQEcB/uIYr7f0nXGSj83l9zTI998=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790887165; c=relaxed/simple;
	bh=lh6oIga1iDeWlYTNFS9HhoUTy79DsO4VpX4IRkPLWC4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lk22G7elJfQM2emoAZVgGyCTrKtjS1c/QFuKqGwv3u7pIxLKnbfmXSa/V0+EV5n0oxLZvmBAKG9lFpzAeysf3+ww6pR9c485l3Dez4/PmvcicwIerNdk3vWJD8+I2hxfoOlAr9xBjD/A77WwbdgJIexF+gWKUNgXHvtk6yMLqXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JhEpyj7U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N28VOtVL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JhEpyj7U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N28VOtVL"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691KPsj62545907;
	Thu, 1 Oct 2026 20:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ShhnNtAKLm2EFKMAJGwoX29tv5Fup5t2fQLFrrO9/Oc=; b=
	JhEpyj7UJ9+DfWvr2zDC9XAOudTVSL+k8v2yXgCiE9EmeqtJJNEXiqk751fv+l+y
	yt3gQwKUgt3wT6b02xm/KXI/IOlbsd/E64OgU2SD5ZahqWPHcdEQfMjjAMeLyPcH
	OpjulH7FsrPPe9aRaFpApmhuQt/YLqHFd21g1GxVNVeZaGOon3r/9KkHYUnyqLSz
	3WD0GlVpxePHVR6CQPF7oC87JcipsTNvHJ88Z1SX6sViQOQVu+XrzjW2xaqnO2zj
	hl7jgaVJ7sGQgcQnZEUVs4cCIAvP42dtCLcVrKxhzacyppOL6usHeMkiJRVIgw+T
	QLJ08DWnjIjUver6b9QOQg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx63c2a6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 20:39:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691KZtBT032574;
	Thu, 1 Oct 2026 20:39:19 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gt1sx8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 20:39:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wcXnm35sgW+/cZ7pi9wj92EvQmoTWGlgtsuzQV3urpl1MtJrZl8oWcNRdsAxqsvSikEnl5NMKYmInsgIl3Faxzg9DHeozAXEC6GYujj/xxIFFrixjYOBHcEkSxpu+65MBwv+23wZHZS52XUUykjc7zLew4axwhUlgQJK1GezKIrOtWR4AMY4E1niXQ4GoDU1ymIuO1B5WcUhKzSjCYm/c83IU1PoQ2m5cGVKuMaXwV5zkzM6F2aHbf9nHro0tpWzrbIZu+FoVXPkGsHve6XuFmv68hXjNcNSQvZCIp3nGKbHKKdoPvKn0ixGPEAyBcXGv7WKJ6MqkkDQzzqF7+ncAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShhnNtAKLm2EFKMAJGwoX29tv5Fup5t2fQLFrrO9/Oc=;
 b=Deh7vjojBx3TWAEeAWXEKfT6T9KQa7V0meFMa2oYsBYfisqbG5+VgnogWEX5L+TO22paIz5As+OXeaHLLfysmPOrvJbFoksOZOPF3vLqJRkxUDPGp7T8Pdm4yS7e4evwsJCtLvVXNiFLzb70M4YEx2B0tlLCkUdmeoXqTMwKuXlLnInw7l6jPdHN73iSyTn6Fr6qqQ0ZPypbMTSELN1Tx5mBRNKMp2goiCKtgPOScGFVxURQaWJBWAF5yPl/q+xKye1hr9JfPRPveMTpC1I7QPtWS2IWaWQIWnbbkEOxnj2N8IiIUqFDgS+Rv8OyNrtYBI/5x69DXDIZwS746F4m5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShhnNtAKLm2EFKMAJGwoX29tv5Fup5t2fQLFrrO9/Oc=;
 b=N28VOtVLYlx3MZCHDw4lNZcZtJoIoPGgI+VDPmU1GrWBalzVXexTh556AwJwW3AoDNAys1jQub0glpXlkBktSNA15MDx7z/VX0wrRkAWhD4tBEi1+86PkSR1IfzNBd8JJ611b4Qm4yt2RiFOBNzMXEsfDoMnNGXrU+VN81cbeZE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA1PR10MB997679.namprd10.prod.outlook.com (2603:10b6:806:4b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Thu, 1 Oct
 2026 20:39:17 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Thu, 1 Oct 2026
 20:39:17 +0000
Message-ID: <73b99ddb-996b-4978-a801-69a825da9954@oracle.com>
Date: Fri, 2 Oct 2026 02:09:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 107/877] ASoC: soc-pcm: Apply
 snd_soc_dai_link_ch_map.codec_ch_mask to codec params
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152417.048647943@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260930152417.048647943@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::7) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA1PR10MB997679:EE_
X-MS-Office365-Filtering-Correlation-Id: b28728e6-1231-4bee-882c-08df1ffc1020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|18002099003|22082099003|260925021311599003|260925022911599003|260925021911599003|10067099003|4143699003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	sh3arqWVKec2IxDtsZj29Of5ihJV20A2mDkPiVmHfsZtcrpRtpQi1mo2O4/462FOuS6QT+7NpyyT0hY+2u2ojgArbjJGjBBL6K+UFSSjTea1CEgJ2fguzUucGH4wmA4ebu5Bxy6coU6fuo+7j5YqKz9CoBxR7dRdwUsPWDSAKH/NlmHvY2E9zhak7xqqXPEm6KhcRvyzTFqJPG3UEmYRcRVNtSlOZcw1bWbFIMk3YZntsy0mMYpAm28OJ8tEJqW417toujlYwirWkkUNgIMTV43zckf1BMZMjUQA2SwfrT9kFR9LeVqNolAQjDtMEOfW+9PzbBzABSjxyM4HIb4wn2oBGTie17VCBoLpgyIvJTSvOddMeun/DZDugZEzaLmZSZkCG+5N5/63Y2SgqYE9rhNc90kTwESha6YFPUlqYLoDAwrL4tJTYs1vJXIsNYrUgBM3YbhCVyJ/dpQWzDya3XEhcJ5SWvFLMmGZ3I7WpRvOxC6WK/vZo/Gd9Eslf7xLQy0dZhmtC7t2cS/KfCcCp04KaTiLvJElwiwnoVgFvfCQ8EU/F7pIIXaov0JsoKvxEMzOe/8UKM/JgIo+y7WwKxGxriChE+krCLAxwbT8fHqAj4zBmHhBF73E1anhHBbe
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(260925021311599003)(260925022911599003)(260925021911599003)(10067099003)(4143699003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTZXM2t4NUpTVVZmaENEcXE2VWkzc3BzMHRRZFdaNVEzTGF3bGVPOHg5UHM4?=
 =?utf-8?B?dnFBUVlEUklQSzRuNUhHcVN4RUp5WkRIQzlTY3NhNmJLYllnZzU1S1Z4dWxj?=
 =?utf-8?B?NkRacWdEUEYvcEZlUTg0a3BWa2lNbVVSYk54SWszakd1QXIveGs3bDhGK3FY?=
 =?utf-8?B?VFcyb1NoN3dVVXhZV09ZTGx0WEhDOTZ3WExmZUo5cjhyMXN4QVBwZ0d5Tzhq?=
 =?utf-8?B?d09wQzhNTE5NdWFZK2FVZElYZnJpbjhySmRRaWJneEFnakdDMU9KV3lkOERt?=
 =?utf-8?B?ZXJqRm1UVWtGV2gyS1dwem5QOVM2eko3NVNoZXZpTTJNQzJDeDE4aTN6Y2g1?=
 =?utf-8?B?V20zaytVaXVZRk5FRmJnS1BPdnJOMW1kTWo5WWxUNGpJVjlEc0RFMmczZ0Fo?=
 =?utf-8?B?elF0dnd2MlNZY3gxVUw2OTlVVmdkODc3dVpURGlnSG42NGc5RkpIMFgrTWdO?=
 =?utf-8?B?ZGF2dzF1c1UrcFRyeEhvc1VQbDhhTkVGQkMvczVuRnZvdGtTREU5QUpieXpl?=
 =?utf-8?B?UVpGU3JxTnBGT05CeHR1Zk1PSjJpaHZud0JXY2tIRElmMFRpQ0dMSXZpQnlD?=
 =?utf-8?B?cDJEWjgzWWR2NG1YSzR2Z3N3RG1sU0NNa0dtNkMzVC8yRWtxdGRoN2MzaDZx?=
 =?utf-8?B?M0VzYXlCd0MzYm1rR2RRODZ0R0tSWlU2OE9WTWYvNDlMWFMrZXNpK09ERE5r?=
 =?utf-8?B?R01zQlNWakludmRaaVRudGwyQWl5bDc1SnJpZW8rSS9xVmJYcVVzTFBjOVJS?=
 =?utf-8?B?NVJENHFITDVvYlVSTVFBWDQrVDFLZUtCR0JOeXhGMVAyMnFMRFRDTFhtTXFt?=
 =?utf-8?B?czFBMG5LWE9BeGlFV1M2WHVhZ2VoRysxQXJYcU94ak96K3RNcTNyQXNkRGFW?=
 =?utf-8?B?QVhEc1E1R2l4N1greTFmVHAvWDhYN1hFeGRkYUJYbGdtYm5NeHJBWWtNNGxF?=
 =?utf-8?B?RlhzbXA2OTVHTWVZdHZZbEpMcmoxNk40WDFCN0gyc0g0OUZnd29McFlReURY?=
 =?utf-8?B?cWxPWXRZSW1ZWUJvNlFqZmVxZitpY3ljeEo1VGRFMFY2U1pScWcydTU3em1K?=
 =?utf-8?B?SmRnL0Jwa3o2SWw3N1RiUHFzUDhYVFR6TjA0alVISnRHWThSMzV3WVFiT3R3?=
 =?utf-8?B?WkhnVk9XMGV5V09wNHBxZzIxNGpUbDU1azBwSDdPNFIxUHZpMElJNzd1L1Yv?=
 =?utf-8?B?YjZPSm0yRStSeFp0bENCZ0Z1aWlQSTJHWTRLbmU5cjRXSGNhakhNVWtKdmZJ?=
 =?utf-8?B?ZE5KajZaa1B6ZS9XZzJ3bTQwZ3hBd0g3cU14bmFOUkZVekNDM1ZUWE1nWDEx?=
 =?utf-8?B?Z3l0MDcxNW43MG1OYlF6ak9RTllvMEdKNkZVSU9iWTY2RGZPT2ZMV2J5RE9I?=
 =?utf-8?B?bElrUE44UGlOSDBtVEhVd2pHOFhWSFZnK1hScjZ2SUN1YzFNTkNsM01iY3lH?=
 =?utf-8?B?akNpbTRFYkdQSXp5dzF2MUFJdHJsK012WjhCcWNWb0k3QUxwOHlnVTljZUlB?=
 =?utf-8?B?MEZ2a1FjNVYxc2FnODVtc3grNWpSZVJsMGJKKy94VTg5SWMrbC92YXMxMVV6?=
 =?utf-8?B?T2xySnY2c092NHEwNWxWTWU2bkgrUWkweUo1UHRuejd2UnM0SVFaNmhkUXRL?=
 =?utf-8?B?R3hrSXI3UU5kNjF3N2cxaVZ0U3FQRWVmSW9aVGkyQVdVTGNtcHhyZHVyb1Fp?=
 =?utf-8?B?bUFtaUlXY3RoZlQrVHRXUU1PTFFBdFB5Zng1TzFkUXZuT25iZU1pdmptcURn?=
 =?utf-8?B?SFpSNzhrVmc3WnplWHd0dFc1cnVaSTkrdXVVK1psZ25ndldFUUFqcmZrSXQ2?=
 =?utf-8?B?bjl2OUxFN2hMWms5SEd5azlBNHJQbkVXODhOYXVVYm5BU2RBVlFxSXVXRi9B?=
 =?utf-8?B?c21PbDBEMUFJckhSdEhhT2dzdGgyblNNRXVzYzd3MEJLWTg1dExvc08vOWY0?=
 =?utf-8?B?OW5kRWxremVpM3U4VWlmcDZjN3ZpT3QzUWhJZUs1OXZLdndrZXN5Y2V0b0dL?=
 =?utf-8?B?R2NNelRrU2ZsU01FT0ZwOHRnUVhTODMvSDFtSG83MnY1UWNLdm9vRExZMnN3?=
 =?utf-8?B?ZjdVdHVBOWw5K1Btb3o4MWREL2VnS3pMSTNBWDVFb0dLdjd6TUR1NGFqbUVP?=
 =?utf-8?B?Z1FTbVhpNG44M1N2R2lkV3o2Z3k4QW1PMkY0SW4zdHh0Q2NIZlJoRWdwb0pv?=
 =?utf-8?B?SkgvcnVkcGE1bm1adkJxWVk0cmN1MExhb3hIODVjVk5kMlRpT1NFWUVlWmRO?=
 =?utf-8?B?TjAwYUdxdkhOL2pBZ0xDcit5VjNVREYyUktqS2ZxYy9tMzJvL2VtaU1mRUEz?=
 =?utf-8?B?VTJJR1l3a01qc0pIUW50bkY5Z25pVktoTkJVZWRmMzBUaGRocmg4YXdyblNZ?=
 =?utf-8?Q?Dg/L36FEUfkDQCUG/hbAbuTlbe0maCxFpHSLt?=
X-Exchange-RoutingPolicyChecked:
	d3kjIjo1i3ZEclr8wrT4mnokDSZeGTit1E7exjzwnz+FaBKeXJN/Nfiqfj28Wz5Hz7EFlGvef7kROJylJwLAuA8UJn105g6sg+1ZpbO7OIhVGT+jQrjXULiBbjCVFXAMqvMaKJxqGGGDk/q+Ciices2sPn7nwbamEsPcybnweY39623VqGyj9/a20VJ9ytc7/F7lUEqnPn55lKiPkqND/z8xmoF+Gz6iSkTAf1lWbdJS/SDIs/6w58fczHE4DYkIC4sLv1zF5iB36LyqHpTpdKCdcTJTT/itvIxhtu0cPRN7IzNtiW3F1edOaK+3jSgUYxxMuxpVyDLUf3qaWK+PnQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HQLyz/Es9JPjTUvOtQnQOkK2njsNQw++ScEqJNuifVC1g4e5YLdwDT4jtX38jm2Qq83DSCIDa9aElE5wJOFGho/3eoSqj0kkh6J3VipsXulB3+J5mVnTQh0ArZetTvmWGQcPoxEyze5GyhVX80rgIZBKbSqrkleCOX19ZxPBTlHZ1vqb/ogOY31icEiZvEWZ6Q0HYMQko/rNED4/CaK7zeLNeOS4pejsYYxN8eizH7hhD4L8K9RPSQ+hCjTtpVUYMAITiCu6SLvq61ydBvNdEmAQmf4xoTv7zyKGmqxjIbvZ/RMfSbTt1+Vbyq4SpCkSV0YcqWgoefK1e+rynQx8yGDXWa+LtAWyjs7q5aa9qpiNLT5bz8RlKoom8V2m5XJEgQdtoBVdnCPO5Dg3irOp47hXzIRrwZx8Mvz2u3rQFFG/WnQXAvqp/Z9TlFBrDf+uSNjhMlHwTrwnGiOfLsNxX6O56cy/EBkSwqhzL5X9d7Aa2hKQCwObGW4U6uW8wA6wG7qwYT1MTeNB9hfATTcqSj2GauUV8pkZGecNuYGyaIpl1qGcwCrCFZGoNIXUuhGLJXtMjJ+QMw5QcrDWCeoymBTbBGfED5oxQNgY1lnrsZo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28728e6-1231-4bee-882c-08df1ffc1020
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 20:39:17.3523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZDrNleCOyDKfhzKocP0RgnuBVI8UcvjrXTfG0vwHjm0MM5unqa7jLP0497Khm1HnXnqTQ5C6zuvIASJUjbyG3jwaPp5acREfFtAlKqiWwbMd8G9XI2xirSxLjJA6MCfo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610010082
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA4MiBTYWx0ZWRfX+ysjHHDokG3M
 3yMwKO3p1HcGAs44PsHFPzIj7T4BmlJE9cTKPrX0COSoq9mvv+sfoAkoclmcBZ4CkBIKOMrekbv
 oL75L8sYJhEcLy/Y1IF8MVFSO9QEc4FrzqnVTYI5Ca76AZkMFYl8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA4MiBTYWx0ZWRfX3m4p736TwT0x
 l9X2c4vDPa7xV7ybOtuZWA64ZxNi8DPyoAJxGNsxegah3rEuS94007x86IY9ns+Z12s7olf2YB2
 tLkJ8DCH8bgmV05F7rGVUfAOKRHHyWpmaJx5iuPEMVAl7s5oign+IZez24wxcXXPhqWcR5o/J19
 HZJRj3j3W2B3KH30JNisWGKvD71CPABlp2IcoRmmph88ldqswEy4mcRUQVdjX1231Sx8nYZqTJF
 7/0lwC/GgIMnHj+f9yf1N56dhZNSFftIX5AFOY/VYqToiDFoGoWd4zOFfjsDb1hyVGQ3wjUaKe1
 24zkj7pFON79i8e5seVQLvRYHvSWGnKays5lrdS0srVuTxB8gwU5SvHpgdTwsG8Esk48bqp9yWO
 hyFJstTGIpI782GbwCVRb4a2pNtlvwPDCj9yJLxjHnIL/8E75lTUd4RaZgKW20eSYJWfCkQtESR
 FKs7Ecsp99RjpVc8SmIQY4pBWWIn8LQ45H00bvbM=
X-Proofpoint-ORIG-GUID: GMDNR4V2_2p4vzFtHBLTYy06BimyIcAB
X-Proofpoint-GUID: GMDNR4V2_2p4vzFtHBLTYy06BimyIcAB
X-Authority-Analysis: v=2.4 cv=PPGaavqC c=1 sm=1 tr=0 ts=6abec4f8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=bC-a23v3AAAA:8
 a=w1d2syhTAAAA:8 a=VwQbUJbxAAAA:8 a=31saV5u65Mkb_1bs-QgA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108



On 30/09/26 8:46 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Richard Fitzgerald <rf@opensource.cirrus.com>
> 
> [ Upstream commit 6b382bdfe26a2232091bf743e454e6794295783e ]
> 
> In __soc_pcm_hw_params() if there is a snd_soc_dai_link_ch_map with
> non-zero codec_ch_mask, use that channel mask to restrict which channels
> are enabled on the codec. But only if there isn't a TDM mask.
> 
> It is possible that a snd_soc_dai_link_ch_map could include the same codec
> multiple times on different CPUs so the for_each_rtd_ch_maps() loop
> accumulates the channel masks for all entries of that codec.
> 
> If a TDM mask was also set, it takes priority and is used instead of any
> possible snd_soc_dai_link_ch_map entries. (They cannot be ANDed together
> because the bit positions are indicating different things: TDM is a bit
> for each TDM slot, codec_ch_mask is a bit for each codec channel.)
> 
> This fixes a problem of incorrect TX channels enabled on the codec when
> multiple codecs are aggregated on a single capture link. For example:
> 
> - Two CPUs with six 4-channel codecs.
> - The machine driver chooses to assign one channel from each codec to
>    one channel on the CPU
> - But the codec hw_params() would be passed a channel count of 6, which
>    (a) is more channels than the codec has and (b) allows enabling channels
>    that should not be driving the audio bus.
> 
> Fixes: ac950278b087 ("ASoC: add N cpus to M codecs dai link support")
> Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
> Link: https://patch.msgid.link/20260910114500.1586637-4-rf@opensource.cirrus.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Greg/Sasha,

An AI-assisted review flagged a possible omission. I independently
checked the core and SoundWire producer at 6.12.y f4ffa8dc360b.

The core backport correctly preserves TDM precedence and combines
codec_ch_mask entries for each codec. The question is its missing
SoundWire producer.

Upstream's companion has: 290845e151cd4e307cc1f25319583aaceb4eeb30,
sound/soc/sdw_utils/soc_sdw_utils.c:

for_each_link_ch_maps(rtd->dai_link, i, ch_maps) {
     ch_maps->cpu_ch_mask = cpu_ch_mask << (i * step);
     ch_maps->codec_ch_mask = codec_ch_mask;
}

6.12.y asoc_sdw_hw_params() at f4ffa8dc360bce834e6ea7b0148eab0118f4a42e,
sound/soc/sdw_utils/soc_sdw_utils.c:

for_each_link_ch_maps(rtd->dai_link, i, ch_maps)
     ch_maps->cpu_ch_mask = ch_mask << (i * step);

Only the declaration and core consumer use codec_ch_mask in include/ and
sound/. SoundWire leaves it zero, so without a TDM mask the codec keeps
the aggregate channel count and capture restriction stays inactive.
Hardware impact was not tested.

Could the ASoC maintainer confirm whether
290845e151cd4e307cc1f25319583aaceb4eeb30 ("ASoC: sdw_utils: Set
snd_soc_dai_link_ch_map.codec_ch_mask for capture") should accompany
this 6.12 series to complete the SoundWire capture fix?


this is all in a series: 
https://lore.kernel.org/all/20260910114500.1586637-1-rf@opensource.cirrus.com/

thanks
Harshit> ---
>   sound/soc/soc-pcm.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
> index 440acec700a56..d52771a4a723b 100644
> --- a/sound/soc/soc-pcm.c
> +++ b/sound/soc/soc-pcm.c
> @@ -1122,7 +1122,9 @@ static int __soc_pcm_hw_params(struct snd_soc_pcm_runtime *rtd,
>   		goto out;
>   
>   	for_each_rtd_codec_dais(rtd, i, codec_dai) {
> -		unsigned int tdm_mask = snd_soc_dai_tdm_mask_get(codec_dai, substream->stream);
> +		unsigned int ch_mask = snd_soc_dai_tdm_mask_get(codec_dai, substream->stream);
> +		struct snd_soc_dai_link_ch_map *ch_maps;
> +		int j;
>   
>   		/*
>   		 * Skip CODECs which don't support the current stream type,
> @@ -1144,9 +1146,15 @@ static int __soc_pcm_hw_params(struct snd_soc_pcm_runtime *rtd,
>   		/* copy params for each codec */
>   		tmp_params = *params;
>   
> -		/* fixup params based on TDM slot masks */
> -		if (tdm_mask)
> -			soc_pcm_codec_params_fixup(&tmp_params, tdm_mask);
> +		/* fixup params based on TDM or ch_map masks */
> +		if (!ch_mask) {
> +			for_each_rtd_ch_maps(rtd, j, ch_maps)
> +				if (ch_maps->codec == i)
> +					ch_mask |= ch_maps->codec_ch_mask;
> +		}
> +
> +		if (ch_mask)
> +			soc_pcm_codec_params_fixup(&tmp_params, ch_mask);
>   
>   		ret = snd_soc_dai_hw_params(codec_dai, substream,
>   					    &tmp_params);

