Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C50117BBE
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 10:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725617144; cv=fail; b=S+0VkrqdZ5hI5mXkgS7sXsRRwXxJwK11WWaIXCyVoYNErurvg3gNodry+tL5nybdUa0lcIknsJUbIOdUYwhn3BIX5QXjmV7Eencpnhkbhw8Txndk2F+uI4fDhWixYJL8YswRskIsfz0alXcETR96juCvhb6qJeKSAt77dbkm6yI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725617144; c=relaxed/simple;
	bh=WJU/0J4Gkc/79LRgq4FcE8L3sw2e5Ron2rdDA97Dy5Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tkhVH/wwAAAOabIk6Fg4Z39mnQNM7qlqNolTShXiGpoaKnc0c7j8uCwOAauuDeKCQkbNRZxO5QqSoPVR9lK3yOjyMIRjCE+xRJgvAzBWj5nrJzILd11TC6ea7OpIuFBY84n+a64Uqbv69MTpcs4KlqoHEpInNQnb2h44+/2U4FQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AJ4DmLcl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TJYjEfYx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AJ4DmLcl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TJYjEfYx"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4863fYVM029016;
	Fri, 6 Sep 2024 10:05:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=JsH/avOdl0yVsCOEe94LGOFJdLJwxDIyCKwhgEDREW0=; b=
	AJ4DmLcl6S9dzi8Zf3T3uVjW2rtworDjg8tW49uK2V995GP9hanCG9J+pZSz2hwW
	B7sOuEwsBk6lxgoJAcBnvbo51zczeObfzvDErAer36pFFeqQRgq9nDJN48pa3I4g
	rnLrb0bMOMvGFQ3BwBY8YzBSbOe4pOeNdJrvNkVI0WPezvPEffjYeiROexfdpL3/
	uY0iQ2NgT84U957C3uv5mLXeZ2zu5c39WOmqnkcdyPJOeKumcX9blCaNi0vSnQA5
	xaaRD53aKsRJ2ChMU+LxyqcgIfvFlTvYntypggCYfm52hPExp90pec4EatuoflHK
	IUVjRvibuVSHNbe1pqYUEQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwk99h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Sep 2024 10:05:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4867V9n1006943;
	Fri, 6 Sep 2024 10:05:28 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhycrujp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Sep 2024 10:05:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOcQClCvKHUjuiLDaPtNKvTpnugADDtJSiPGivLfTGy0RtlifcaU3+RC8Vu5zWnus3bbFO8lLWjeLdjlqGLYk60Cu1mfLbKoDMFwuflyOhFdxL2oua9raI8oTAyW+PbNA5SkOy1CIQiA8aLImK58ALrIP51vpV1Qj9w4YEM4KIBGD7TXMb9k05wqzWgfSpbe1ukoD5iV4e8eZFAkjWvq8dIMvwiskQejBuNV2KkkinOwc+dPWT9AWp3D+7SlhhiNVlDaVR8hNfzz3NpGygul8BJZRbTHnPe4hcoG+Psg/3iR6XKYS9EZSL3OCwMWiNiC8yM9RbAOiImmVlJH2wiXtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsH/avOdl0yVsCOEe94LGOFJdLJwxDIyCKwhgEDREW0=;
 b=pf6+JElqBw1h1ZUXmw8M//ch6qrW17t9xPpnTL9NzMUfv6m38oAgFxtoxcdVydG5XJlnOq0SCtxRFU3dtZRrhjIBMosUwzmAflOcTXdOqBTUKaRUfxKuk3D0qYuNpRx7uRj3b9qD8vLtBLPf3huF6ub6cpB679i+N6L7kEB2isL073+X+WB/C/+LnHIedVBJGI+1d6+GtB4WlsDJDVWWzmM07dlwat1YBdZB9PV/fWTZDmUerbRC3tJK4IDdIomDrhWn54Tu7HpNIvUnoJ0XXA4GTZ7g2XL/ehanTGnAgqrVXeS49NQ3PRRs/wJkHRo3dZNgBvUOcNcM1dTZlnBC8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsH/avOdl0yVsCOEe94LGOFJdLJwxDIyCKwhgEDREW0=;
 b=TJYjEfYxqcflYtJrOv8PjrqtHs+ldzyk3zV4q0EfMQ1nbRDPReg1u9kOQSTeIuyN6qMdbJSiyP6yBiY/7T725Stl1lvy7qBFWyNvEmwDCLOoG4/BiZRSBrdN65WFFNctQOrC/wR6insZomTJ/ZwDViY/h29FXpwEEqSJikWLVss=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH0PR10MB6960.namprd10.prod.outlook.com (2603:10b6:510:26e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14; Fri, 6 Sep
 2024 10:05:26 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 10:05:26 +0000
Message-ID: <b9ef4b08-ff62-45bb-b39c-a14805e8420a@oracle.com>
Date: Fri, 6 Sep 2024 15:35:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/131] 6.6.50-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
References: <20240905163540.863769972@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240905163540.863769972@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH0PR10MB6960:EE_
X-MS-Office365-Filtering-Correlation-Id: 19cad019-c4ca-46b0-5817-08dcce5b6db9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2lXNmxrcXRHSGRRL3pQOFVZU2dHSVRmbDJLdXp3WUl3elZ3RUhabEZGcXRR?=
 =?utf-8?B?UUFwNE5sY29LREtyN2svTkM3Ymx2LzVrdjZsbms5T2grbzRZY1dCQUlBcXB5?=
 =?utf-8?B?TlZ6THU5dG8zYmVoSnVmZmlpdHpNVFhsREFHZEVIb1NpMDRQSXkzQ0VsTlhJ?=
 =?utf-8?B?RHI3dGlKQTd0S1B1R1M0SnhOajZOMVJ6eXdTanRNN2FBckFzNURYKy9pZFZH?=
 =?utf-8?B?ZWZheW1Wc1U4Unl0aldNbWR3Z3JvWFp5RThSa0FRSFViMysrT2V5K2V2UHNW?=
 =?utf-8?B?ekpjQnNiUFF4M1E5S2IrOXp4QUtTY29HSWkvYmFNbU5yZ2RMSitZNVdRUXU3?=
 =?utf-8?B?cG1OWTB6UEtLZE5maHUwcVVveEdrT21VZ2oyR2FQSUpvYWczOGdhcEFWUG5E?=
 =?utf-8?B?UFUxWTN5MndyT0FGZTBnTnZaR1BTT2k0SDRka3NYNWtSbllrcUg0NU9SeC9z?=
 =?utf-8?B?WG1qYVFOMDhNaEpDYzE5SFJWdDhRQiszZGtyTHFFZnM0TzZGMHV3WnVwUVp0?=
 =?utf-8?B?ejBMWXgzS1VMMTdsRStVNjBVVTc2eEJCNjlaQjhWeDhjNmczWnRBcERiZmI1?=
 =?utf-8?B?YW5oTG8yTDl1YUZzR0FFNnNOQ2pRS2hBcGRCcm1JMG9GanhuSmNXVTcwcC9N?=
 =?utf-8?B?M3IrQ2p3Y25RcloveUdjb2tHeDlmNnVrdXFKc2xFYStMMXhhY3RhUlBCeHhm?=
 =?utf-8?B?ZWk5aERENmIvcVpsajVaTUtTd2ltKzV1ZEM4cUdpeElDeC9KNXFWYkVuMk9S?=
 =?utf-8?B?NkRPNWplR3JYVHlPMG5haVV5emdXTlo0bVo4MEthT0FCMmhROGNMUFRzV1VZ?=
 =?utf-8?B?QWFVSUFkMWw5dUtmdzR0RlhBaXlmYnA0Snh2ZERJMWtURTJSQVdPa1ZoNlRu?=
 =?utf-8?B?ZVBtUVlhZk1lU2lDcm56UzR3bDI3OFJQYTltczRQSWE2cTlTaDZIYlFpdEow?=
 =?utf-8?B?VDkzaEl4MlVkTmVHc3c2UktQbElNaENuRXFQU09nUWVPUmpnVVNjeXAxSWtu?=
 =?utf-8?B?d0Z3VVphL2FRK3NnbHQxVFFNM1lTZWI0RnZrSHhhWEVmVDRJb0NPZUtBTG9V?=
 =?utf-8?B?OFY2Y3RzVW5nTUFmMkl0N0RrWnVOMG9DMFEvTTAzMmw4dFZYK1FISVVVdlE1?=
 =?utf-8?B?RTJPblVBRS8wNCsrZ3pKWW9SYWJPZjIvTTVrN0JUSlE5ckoxYWxQbUxyZkcv?=
 =?utf-8?B?ZkxXSnhwbCs5RS85SXkvS0FYdWhaRzFBQzA4eFN6Yjl4TlFFWnltV2d2V0Q2?=
 =?utf-8?B?Y09MTnh2Q3NPb29GK0EveVAwa3g2eUR2OEVFRStKcE5xcmZxdzRDTWhqTnpS?=
 =?utf-8?B?VVA0akc2cTRjLzZ4WDd0emRpQWp3Q1AvMWdTNGtRQnAyUlFWbFhRZXlkZ0NB?=
 =?utf-8?B?dHZ6QWt2Qm9iUGY1eU9rTHZYdm5TcHNNSHN2cEFSeWhncGd2SllxbWZtd0JT?=
 =?utf-8?B?YUI4RmlXdmFteUVpcDVLaTZBY1RPdGVKTnlINGpTc1hNam1OSjdHcG9odFg2?=
 =?utf-8?B?aDE4a0VaMm5KRml0eHBZYk5YcU9UNFloQ21QNVl5R2hYODRWVFZ6Mlp6OGNj?=
 =?utf-8?B?dllSbFYvandRaVBzQ1drR1JOcWV3ZkR0U0Zaam9JVzhUVVlZNW51VXJoeWYy?=
 =?utf-8?B?aEpPVnA5M0ZqV0lLYVRnSE1KS1NpcTh0dUR6Q3gwZkJLWHBvL3VWOWswK29a?=
 =?utf-8?B?TlVFeHJYeXcvaVdrb0hQR1pDZDNkRGdibGVET0dpaWh6bm9wRkYrUWhhNVYz?=
 =?utf-8?B?MFN5WDNrWXFVUGxJZFBNK3h4a1ZGbkVtYXZFb2V0REtWVFN3ZjM5bVFMYk45?=
 =?utf-8?B?dk1KTlpIT0RCMWtic0VEUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUUxMTdVcVU2ZUwzeGF3ZkZtQ2FaZGlOZG9CTTFWT1MxaXpTRis1d2NFb2xo?=
 =?utf-8?B?Tlp2Z0MzRFBzeWJJSjQ3ZzY5SklUQWxHa1o2MHQ1ZEt5MExQdjNETXFVVzZE?=
 =?utf-8?B?Wm5id3ViU1VYS2tCNjVNYWRUR2t1Q25wWE5vRGMwL2QwalNEVW1yYTNjUmMz?=
 =?utf-8?B?RFRoYmt3cFpzdi80Mlp3N25wTWp0bGVxdXp2cHBrNmlNdDE0RlFMOTR2N1ND?=
 =?utf-8?B?UGVtdnZmUG5FbGx0Ync5U1dGY0NXWE1CWmlLS3NNT0ZIcyt3QXlQNkR5Zm91?=
 =?utf-8?B?c0syMnB4TkRhQUlaNGFjT080d3EyZm5QejBGRjU0THlJWTdXYmUwSHA1RUI0?=
 =?utf-8?B?ZlpHekY5SGZqUS9JTDVDWndoWXpFZm5Lbmlndk5KTEJKUWJZUnAxalNwRnhF?=
 =?utf-8?B?Ykl1RHY3aEY3V2E5TDBRR3RESjZCNS9xOUhBZW9mUTYrSkVuR2NlVGNFVk0y?=
 =?utf-8?B?aUs1TzkvK2NtSlV2V3c0eUpleGJHRzVrakhuOUIzd25KNTBMeVhhMVdwU2NY?=
 =?utf-8?B?dVVTelM2MzlwWmhaOUxUTW81c3lvVU8vdmFJUlBBb2NIKzhiN2xLN2xST0pN?=
 =?utf-8?B?ZHBla0NuRUJENmhqWHo3M2ZiVDErWmpzKytKYVI4WGE3WHAyMDNlaEVGNnV1?=
 =?utf-8?B?UisyeUZhdHVkaGl5UzFWeHE4MWlhZGpzSXJBSFlpeklhdDVJN3lkeWgyTUIv?=
 =?utf-8?B?R3FtMEhRVU4ydjBYWE1qN1hxdnhFVzI3TnhnTk44U1IvNG5VTVF2ZnFQQ1Jr?=
 =?utf-8?B?SjhKNjBmaGMwNHJQV01tKytVSW5RQkJ6SVlUM29XeW1Ca2lMdXRpYUlxaklM?=
 =?utf-8?B?VjdRK3VQbWhDYk05TkJhc2N0aEU5STY0QWYyY3h0V0dNMWFYdEF3WmNJN1g0?=
 =?utf-8?B?UzFFc2JkL2FpN0x4cnhMUXYxcTlLS2I4VllhbDMwZ3oyRGQ5eXVvaGtpeDhQ?=
 =?utf-8?B?RnBxZkFmNy9qL05LZGlvVG1QbDJqS1daWHQzM1RtdmtkUEcwcm9wMW94RUJ6?=
 =?utf-8?B?b1Z2MkxMMGFqZk9NNlRjeWQzaEYvMVh6bUNGUmJZMHdpaldkTkMrRTVDVTFx?=
 =?utf-8?B?dEZ5V2pkMVZxcEZhWFhBMjFXUDhQOVNzRzloZnNreVp6dWdDTmlSNFVaM3ZQ?=
 =?utf-8?B?dDduUGxyN1F2VkppOVZoY09VZVczbE1vUkJWUGYvSE5URGpjaEtsR1N2aDJI?=
 =?utf-8?B?MHVvU04vVmk0N0w2ZW5UdFR5MjdXYlFGM1NmVklGRnBnaHNhL29FdHhqT0to?=
 =?utf-8?B?Q0lIb2k3RHU1NVNsUVBMZS9XRVN6dHZhOHdYTnJZbjJXemkwZDVpNFNkNnFF?=
 =?utf-8?B?QzBTWmYxZHZ6MjNVMXBCWmtQeFhDeTUyaUtRUml6cVFJRlRrTGNFRmJGQ1pW?=
 =?utf-8?B?L2ttWE1KbVU2MVIwWDNscmdiSG9JaTVZcnpsMHhFdEtIU1BQUHdrQTF1VFJ3?=
 =?utf-8?B?YnMwWnJBcWd2ak1iZ3Fkclk3aFowSW1GMElYRjJZSktMYW54VDFiaXhNai9G?=
 =?utf-8?B?c2h0Q0tYNVd3eWdodXlTMmNnenB5OXJIK1Fsbm0xL3JUblJXZ1QwL3Q0ZzdQ?=
 =?utf-8?B?MDNCTWNNNENXQ1lIWGFhekV4RkJYMy9lRkZnUmtoQkp3MnpPWmQ2Q3hjRDZ0?=
 =?utf-8?B?em1IU3JIMHROdnNpMXA3bDB4bVJIOG56bzR1bGxwUFpOKzlYbXUvV1F3Y0gz?=
 =?utf-8?B?Y0VqaFdwZE1MeElEOW9MOGw5VVJJUXhPdjVSWGtSazVFODc2b1JIYTM2UERE?=
 =?utf-8?B?NzNRR3FYc1Bwc29GOE9tMWovb21LYWQ4TFU0WW9LWStDZElQcWI1d0d2TC8y?=
 =?utf-8?B?TXZIT2ptOU9KemQ2YjNDRG9HSjBHbzJjV0lDb3QrZW5YcHAxMEpwNkVod2pL?=
 =?utf-8?B?cUkzQ1JmOTQrUXhUd0tZdUROZDcvakFtZExkNEVkZnR2aXBrbVhQSGIwZlVP?=
 =?utf-8?B?a0hyNnBaY28wL1Z3MmJuZ3F1aEhPUzU3YTBRUmR4MzJjRzFrMmp0ZloxYUNp?=
 =?utf-8?B?a1hRb1c5TWpvTU9qQmRoRTBIWDZQdG1SWDZCamlORnZINFd0a056YXd1L1Yz?=
 =?utf-8?B?TnFxL1ptTjJMSnp6QTMyc1hUcU50OWJndURUczAzeWN3Q3NidEhqcE5oUGZp?=
 =?utf-8?B?NVhBNm5BTXpYam8wb2diUmpnaGFidEc1WnVKTlZ6WEs4U2RoRXBmRTVqZ3dU?=
 =?utf-8?Q?HJ/PNiaaPZ+A4Q8W4rLvHt4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+1vaVaqXbhorPaTSSoz+8sksYesqIyvTdqr2ffhAtTjRdYi4WJx7oKGOYVkcpV9nEp2pU+8D+clX1RK/K7d9X2ZDi6/lIfBTeJw1y/U/aOaucn7WYVWWXGUeC4BiWjqSXqCmCnLIRoXrBwcu0nue3n4W2xAsqy42YcExP8V2Lg4rKnvl9nm4AIvxC6vb+TBMKl9k3Sjq6wZ/Pq6xCF5g7gNpcZyz3l2kCxRw1RhlP1VZESTT0CUc2h2zw/B9JwIFUKGNtqRHROn7Fp7jcKMILQYMgm5UGWZkriGjSdkHd4WXGi4ggY2ZOB4VkzeRPubeOyXJB1gArvOuZZT+NrSURX5TH5khRySqvLyBMBad5hvngdby9X9MaALCZJ7DhI+RciRVdLjFh5/+ofskHz2cVS00PQ9+leN5ohqmt8T7wFn03sAtcgvO4GpiXFg004lR3b++cOMNmuJh+eqIejgREgoH0bLiXvrgDXL86xohrU5dhW9myL9eMZO8mSY33oV+CNIUxxiyrp+FkCHhUE0pXSCe5SMSsy3e7HhsbMXgrGda8vfuxKB5BnYhroThJRTFpOSEzjg9nC36P49EyJax/XrbNCUnIIPL38iKKpbQz0s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19cad019-c4ca-46b0-5817-08dcce5b6db9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 10:05:26.0900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppb5eC/Y27QfjK9EhHVXrPj/p2ymCdwdndP972zI+MptdV0lQrMGqD+IOplKuINUwN9vnsc4CaO45R/TDatXU+M5L8B5xbepBDBN+I2oj6P1tezDg9M/qe7PkfKHwv9f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-05_17,2024-09-05_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060072
X-Proofpoint-ORIG-GUID: e2hKRxaT8rQwaAsyvRa9yfkyWVGuSACw
X-Proofpoint-GUID: e2hKRxaT8rQwaAsyvRa9yfkyWVGuSACw

Hi Greg,

On 05/09/24 22:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.50 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Sep 2024 16:35:08 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
