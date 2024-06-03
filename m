Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8245B12D1F1
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717422299; cv=fail; b=mJ7HbMykbEfvJT0fyr+BrkamHEdA7/kV6q2X13BcQxgxArFhNl7GB82BktY5VZBIDqM+uYC9+BQjStURzv1Tg9Ola5QCFkPFjsnahR/BCdD1H/1w1+w0A6Usy6ULAqyrka7F4R+rmEnxNvLIPyXxJfeiLGrJuBkt1QDk7gcFbu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717422299; c=relaxed/simple;
	bh=+287RwK4JxRd34Aq4MnkjplCYDQfHuj76SdvIxGP6mg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Lqv79w1TU7Rtv4dA9QZX1HdOzI6TyJUWbZV10DmAzReAeQseGAlPmzFrcU/YFYYh12Don7xisbIU2G4/+aCCJIeOIVp2aRkRKJtx24++plHcclIUK85N1WqB9q+LcuJYrX6H6WDXwP0IfOge3W1IcUNUHNzsP6cKFXsoYvjkguY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453CQpgx015062;
	Mon, 3 Jun 2024 13:44:19 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3D+287RwK4JxRd34Aq4MnkjplCYDQfHuj76SdvIx?=
 =?UTF-8?Q?GP6mg=3D;_b=3DGjAAB/JRSYjN+QvW0+6KQcoLFJyhawbFOzI6Xxrq0uN/hfyrc?=
 =?UTF-8?Q?4OSpvWkZlFUP3VSSvy3_rKhR7tXwZ0YdKQdQrjpgf4rKosFT1nrgSkps9sFA8nd?=
 =?UTF-8?Q?3zjjpPpOtIiojLaEc/xh2sNYq_2cqfKjiDmBIzabrlWfGXM7CWY19APefOr6i0V?=
 =?UTF-8?Q?RCPDz5qi9mxl+hbzLdq4N7W9aanHsR+_tRBCq+vukLT8VnkaJ7JaOYy814QBu6S?=
 =?UTF-8?Q?RjzmlxOEQTlmPVXb22ah/Y2gq1SheOgGySwuW_oGxFQmSHAszJEf/aYwExzAuRo?=
 =?UTF-8?Q?D2QgJPlo0BaHM0aJyNhJym+f9hqcIbuEoO6Nl1WdViA_Rg=3D=3D_?=
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv05aw42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 13:44:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 453Ca6lp023968;
	Mon, 3 Jun 2024 13:44:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrqvebry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 13:44:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Edf24Q46OhtzPsjP2EGfg9Z+qGEKMOi4CDsG0clewO2yC0F/JShXlm0eJqnin2g8JfFNyHjhywyNeMv9ShzzMSa4RqjAISzCvZRcUu4621kLLwKBFJGEzqbgzxF3AUYI/Q0iBIXJquQOpTF/h+KfX7cbbZ1PVigAt4MUoM4efkpgYVzGZIZDtbdjiyYRxyR/2j27InoAhpxFc84Y/MMDUdDBbHkgw3TsOIMEvJOWLjsctTGhZAsM/c8a+J4eE0v5nNxAWb1dP2KRkkJdGmUbepRKmUioCY5VxzUHT6XUMLddT+q2zvh/2X9z0vPhVNaP9CL2UEyEZ8IcpUQPC1Cq8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+287RwK4JxRd34Aq4MnkjplCYDQfHuj76SdvIxGP6mg=;
 b=A6x3hSa3NVokUbM8uCaV8OwIIMz6dTnfzf1LJnxcU8i+P9Cia8sUnm0RoAd4FvAhqwj9e9ffhgW72A6U2NgzpvdSHc2bfgUgOpJLmyFYKu7k2+boTRJhy9T3D/AYnYovC6hPACopEGK5uLfz1/GurWevTviedYL6qx2qcBvf1C6DpbND3kjoXxm7/1gBV2ojL2cWfQ2y+qiZuFeOyJEFPrrR17+nEpNzzgsPEJh4JZ2x5y21yATBJ1w+aTXHF6erMDMMkgcpONy3FpleancDAMF/s5Ao5ycYdiAGuGBfrlMtKmQb2SVZl+DaFfZBDptQqKkQtlyMLihZVO+3c1uuUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+287RwK4JxRd34Aq4MnkjplCYDQfHuj76SdvIxGP6mg=;
 b=Hfjho1IEipB6nb0x1Yki11oEOwXdwD1nFVnWIp+ZJCQrNXfA5405+ToLfX7Xy6RFM+8KYz6nAXmLJKVST760AlLCxK1qMFWWPk64nyXHbfLTZ5005BqZMFrEJ8AVrYDgMS8vdqzPp8W06XiJhkST5l08wIiTEnjSXHFh5tbgL/o=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MW4PR10MB5727.namprd10.prod.outlook.com (2603:10b6:303:18d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Mon, 3 Jun
 2024 13:44:15 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 13:44:15 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Neil Brown <neilb@suse.de>
CC: Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        Chris Packham
	<Chris.Packham@alliedtelesis.co.nz>,
        linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com"
	<sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>,
        "conor@kernel.org" <conor@kernel.org>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "broonie@kernel.org"
	<broonie@kernel.org>,
        "linux-tegra@vger.kernel.org"
	<linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Thread-Topic: [PATCH 5.15 00/23] 5.15.160-rc1 review
Thread-Index: 
 AQHasN4Kp5m/MZVFZ0aHe0MmQeirFLGsoDYAgAARwgCAAG8IgIAAElGAgAAcSYCAAJu2AIAAyTqAgAdh7AA=
Date: Mon, 3 Jun 2024 13:44:15 +0000
Message-ID: <69829969-72C2-42B1-A189-957D0A57A2FB@oracle.com>
References: <58fa929b-1713-472e-953f-7944be428049@nvidia.com>
 <171701638769.14261.14189708664797323773@noble.neil.brown.name>
In-Reply-To: <171701638769.14261.14189708664797323773@noble.neil.brown.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|MW4PR10MB5727:EE_
x-ms-office365-filtering-correlation-id: b3d68625-a4b2-4084-034c-08dc83d34243
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230031|7416005|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?Zy9RZUsvTGMzdHlGQnV1V0NCMWRtWkhLd09SdVY1L29JdEZpcXNIYmYybWR0?=
 =?utf-8?B?Rk9sWWtZQ3BpemR5SjdXaGJ4YncvNDhLdlhjL3dzdzkrdFVIc1NHK3VoVlE3?=
 =?utf-8?B?WkFhOXVFUjlmY1ZkM3JWSXR3WEkxeW40UUxDMEtpUVhnWFJxYWYxK3ZzLzkx?=
 =?utf-8?B?WHNpc0FUQy9XMjZrZXJobENBSmJnWDJUMUFXNjNiL2kvQnlHRWVHT09POTZD?=
 =?utf-8?B?TUpUZnFsSjB1ZU1aRUliaUxhZnZxdGZhc1pCVEgvTjA1bS9SaktFeU03SmRQ?=
 =?utf-8?B?K005VTZ3bDR5bGptWTVZS0lpVWNrdTBSRVpQbVU4MTZNUEtweHBlVCtUYkR6?=
 =?utf-8?B?cm8vWnBvanpMVDRaaldUc2ZLRnFlZUpvb2tHMlFIWWZCTURzTFRudUNzZjgr?=
 =?utf-8?B?Q2hETjZHSGRHVUUveFdtTkl0UlVMa01MNitmTlZ3cjRVRndjQ01QZUpJTnVN?=
 =?utf-8?B?empwVTBtWHhGc25tcFNlN2ZrdzhPZnpJY21DS3cxazh4bkt6Z3QxN0ZXT0hR?=
 =?utf-8?B?KzFoV093RlBHK2NIWXhjUGhpc2N0ZTFXL0o5ZjZjSFRIM0dPYkJrNzF3b3hs?=
 =?utf-8?B?dmFZaDBJYXBlb0picy9zeVhCY0N6NVBNOEk5ejl2WlBHb2k3c1FSaGFUUDBv?=
 =?utf-8?B?ZTZ5S01yZFNqdmF1SEt5UFB2bmRURXFZV0ZyM25VdkRMaVR3NTBrSjFFZ0dl?=
 =?utf-8?B?a3RFcU1xS3pBR01Zb0diR1BKb21xcE1oeEF6RHB0MkpSY1RrcUZTRDBHT0t6?=
 =?utf-8?B?NkpDR3VyWHRFRXFjT0syeGxYU0hjalpROEtodFZpUGxWVDNScFBpakptT3lp?=
 =?utf-8?B?N2VhRVN3bzcxM3RHVlV5UGdVVHhmalJrRmZHd3I1OCtuSWhsUUtsUTlQSkor?=
 =?utf-8?B?OUZXc3hDZlBBTjJEVlBWdmRqajFtaERjalFzQXRveXpvYzlzeFNYUHEzWmIr?=
 =?utf-8?B?d1ZlWUQxb3FESmkyMUc2YlJmRVhCQS9EWjBzZWtGNzk0SC96R2kxdGNvaUpz?=
 =?utf-8?B?YnBNSU5LYUlrYXJpeVVQZlhYQ2RDZm5KS2krVS94cVgzMEJ3ZFBDZHJDVTlk?=
 =?utf-8?B?S2c0ZFBWR0R0UjVWbllqSjRnRlNKbU5DeGhwQ1ZsZVRNMlgyZSsveWR4NFM2?=
 =?utf-8?B?QURFTG9hWWJDc1JGMjJqY2E5WjV6RFFPTGl6QXc5VWtGTDdYbFltMWZOc24w?=
 =?utf-8?B?YVg1U1RVcjE5VlJTeTFFNXEzR1FWZVMzQ211bU43ODMwS3k3anlzU3lWeVUv?=
 =?utf-8?B?LzBaK3d3WUJkYWhnTGt2Um43QTN5MVBhUkR6NVdyVWsrUTRFbzlYQ2h4RW1s?=
 =?utf-8?B?RVBydDFXVFBiUFBGejUvSDJHby9VMGdJZ2srQW96ZUhVK3d4MEVSd0ZVWDY3?=
 =?utf-8?B?SlNkemN1ZzdHSHJ6QzlSTndHNkxldzlUN0pyekRQZkVkSjJrUUg0MHdZaHk3?=
 =?utf-8?B?ZFl4MjIyR2djZEdzUnFCdStSRUg3SG5rVWZXSHhDaEhvMXpGaVQ0cHhGKzNy?=
 =?utf-8?B?VUxHUlVZZzRNYzFIS29OS0JVc2tNOU1yejNkS3dJMDJtVXZKSXVHeE5WcDFz?=
 =?utf-8?B?WHU0RWVhaE9VK2RGczdnUFB0VU56YnZVemVqRVBwTjQwWjl2NWgrYXBycFhF?=
 =?utf-8?B?SHJrU0hHZ3BRcTJWUE8rb0tLREsvQ1FZRENkVTVYa2x5NktkM2RENGlRWnRh?=
 =?utf-8?B?dzhGV2hNOVhaSGRpT1dTT0NlMWhSbWhWV1paNmROMkFQdHpEZk5HYURraVRO?=
 =?utf-8?Q?I8xspE+78w5JaOnrw1PCHzVm5dAJqtBEKI5/LDe?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?dlBzcXQxWG00L0wveGVnWExtd1R4VVUvTWFBL0kxcDB6c24wZzNGT1pPN1J6?=
 =?utf-8?B?V1dUU1dxYjdJOXVGUUxUd1B5dTBhUXhzaVl4RXg4b3U3aGFHYjFwVWQ2Zzhv?=
 =?utf-8?B?OVYyb05TelN4VTR6UzJDVmY2SGFOdUswUHpIUjF6ak8vMzZsVGRFTUlNYjY0?=
 =?utf-8?B?eHRPWUZpbXFQbkNVYzZSbDd3QlFiK01OZTJoSVhtSVZIcTY0N3BVdG9WK3Iv?=
 =?utf-8?B?Y0RkZVQ1K3FNY09QM0ttZ0g0aW9Qa2Z2S1NicmNRUStjdU5oSWF5WjBManFF?=
 =?utf-8?B?aTZaUko0TmU0emV5bmtFcjhBcXBrdTV5bm40RGpub3lZSm9LbU1QcDF3bTk0?=
 =?utf-8?B?M0VDRXB5S0wreCtoM1RveUR5UGVCeklOdmUycTZCNStCQWtNTmhXbndlUHE3?=
 =?utf-8?B?amhmeU40cGljZlZLUlhEV3VTTkpTaGNtY1FnSmJhV0VuVG80NDVQMjFLdEFv?=
 =?utf-8?B?dUU4SlVzaWhFY3MvRkV4SlIwemNEdFI0NWVmdnY5Q0ZLdlVnY3g2WjdQdzFz?=
 =?utf-8?B?V0tITWJ1WTZOcEFWWjYrL0FWVHdjMUR3bkVONUVhVlJrbTBWQWZaczJPWVZ2?=
 =?utf-8?B?dWpuQ1BPWm9hQ2pNbmw4dWxqQ1JMcUxpQzNyMENJYW42VWRuVmRNbkFwWno3?=
 =?utf-8?B?VEpqQlNGZ0hCZThqUWdBK05oRlh6NmZWanBYM244cHE0UlFUZUgxdDllZk5o?=
 =?utf-8?B?QnViYVdKU0JkQnpRTE5GcHhDaXhEZ3hqenpkaThmN3RURkhHRENES0xQQ3pq?=
 =?utf-8?B?VWJjSElQKzd2NzJ3MTZJc1duNm00d1dhdXFUTk8ra2ZEeEdVTGFpNFZDbGFR?=
 =?utf-8?B?SjEyVUx1UXdSTmYyNFY0cmtJSmcxN0ZtSGY2SHBCQkpEak9abXJRelB0U2c0?=
 =?utf-8?B?RjQrN01BQ3d3SHc3R1k3eUpVaE8rUlBqejN3MFVMN2tDbEUzSGdkMGhUVWR0?=
 =?utf-8?B?R1ZMU3NoVmduUzBUek1lQXVZbm5nV2pZNDBBVmliNk9UMXU4Q1l4NURvZlkv?=
 =?utf-8?B?NTVUNTdzUjhKVFNOMFBlWmJGOTRJSjVRUE5JVUUreVM0NDVPRWRnaHEwejhC?=
 =?utf-8?B?K2RLR2poSmFCd2J5Q2MvUlBzRUJGNG5yWDNGR0RzR0M5WDRzZDFVR2ExSWZq?=
 =?utf-8?B?Y0cyVUdjdVl2N3Q2UWh6dEUzS2JYM1UxTnJjNWNTeko2SS9WMHBwcnhySTlz?=
 =?utf-8?B?V1YweGRLYUVYUVJ3bG1GRUZTeXZIdEtsckp3eUVuTTFHUDZacHZiNGdUTFQ0?=
 =?utf-8?B?bnErc0lYUlNoSnpzdk9OeUE5WjR0b1BCcTFOOHBlZlltZklqVzl6b3RIOWhM?=
 =?utf-8?B?dkFMUzIzUHNqdDQ1KzlxUk5Mb2p6TkhWR3N2RWJ0cExaNkFyQXdrOEN6cGI5?=
 =?utf-8?B?NE0wTDh0U3d3d2xhK2tGK0s3NVh5Zk81V2ljaWErZjZOUExEcFlmM2FrcUtl?=
 =?utf-8?B?TUxYbkxyaVo5MmwvVFI1R3ZnL1poZHJ2SGl6R3czeWJUNEk3dTB2OXFUZzBm?=
 =?utf-8?B?YjJaREZ2U0xDWkhwTWMxRmQ3V29TWE5WaEJMRnovZ1c1RjZ0eFE0V3VHWGl6?=
 =?utf-8?B?d1hkbGl0WEVOQ1orZGZGa1hvM3Q4bXFHRm1NRzdkTmF0bjAxY29paWFUWW9u?=
 =?utf-8?B?TlBrWUZkWnM4Ym90akVOTkVYK0dwU3RCQUNiTE5uZTAxRFdtYVI3dS9KcWQ5?=
 =?utf-8?B?TFMySnB3TnB3MER3bWtBbE5OcHY2U085UTdkUVVrQUgxL09KNWlHNFN6dzFN?=
 =?utf-8?B?UXIvdytSVXkyK050QWNFWUhDOGVFNTNBQkg3SW14em9FdkhxOUJIZHliU1ht?=
 =?utf-8?B?enFyaWNKYlpKcFIwbU4wdzZacHZYR3NSRVF4OENtb3h0V0ZjeFc2L2ZTSCsr?=
 =?utf-8?B?WG9Ma01PVUdnRzhBaytPQ2pFZ1prWE45ZDlpQzUvMkg2T01jRE5qQUlhQnJ4?=
 =?utf-8?B?bC9ORFFlcGc3ZjUvRHhXTnIvNGJoTUVPWUFPL1JHUEx6bUdYYi90NnBkZng5?=
 =?utf-8?B?bDI4ditTRHBUOVhCNGlra2Rjam5GS2YxVllrS0JlUFo0NzYrUUdjSnJKMkMr?=
 =?utf-8?B?TEpRUTZnWnlWb3VGMEhybDg4ejMwYVIxR1RhYWR3MWRZbmQzeXJlSE00R2c2?=
 =?utf-8?B?UkJWYUxkTFp4OForMnprcFR1eUI0K0dKUjh5UHRpWHBBdXRGUUxwU2YwMHJt?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <714B33FC99CE9248A60B2D0B173E8297@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	J+wgmzXDEs2geOqSI9PLrNQ4MEIykh02LUOhznj0FVAG/F/nC7eZEApoNtrZI96iwwKxv//HQu3Jonp9eGbADqA3qbZ7NwfyHb71nOeMJSZQn5MtrLSnuyU5lt7egheox/2qcPIYS9UgFOjdE+wacWEMpfEUWWVM6UGYGdvli9uEynDPC7UzjdW82YuuH1L07/xLtWGizlQ1QrsSwKZ3nPJgDRHoWJYO/TrC4QAvnNP03w+ZJGuxpuoZCyFKdMxUPVbJY1CfNflpQtYdwlPeGajK5TjmA7T5gEb9AEgEehwaTOoBR0RtH9GE2MYVTiyT+vpQ41WQuOgBPzDcAmBCmBkntLo7fF2DqE0oz0RrYP6Khfh/Dez5CSLr18Wr7p/SjbUWe5QkN68ha79kNtVORevuRG1OTxp1huvCjAGpqTiHhKDq/+Hw+9+OHCSzHtY5BLeRPnOr2v1ngRFsXlnssn5IhJn90w7QdCRo5qdDO1W1F8Znz+tTQwIACMiw4SZOAmd8/oP+08/gn4qGiJg9aCOxHeVe5dDMPNeU7KY+Bkuw/TmUyRooJgXnC0YQmGwAqTMYbKkdxLulv9U+zZ91zsp/ViJn0k6kiLZA/VoK0Fw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d68625-a4b2-4084-034c-08dc83d34243
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2024 13:44:15.2587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nc8/7SfGrDzNIiQzl0wprWXQ2ol/sQPZg5goFOUBU2ybJidmzsC3w9XRwt/zmEfl5TCvs9iiXJHqLJJZHINOYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_09,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406030114
X-Proofpoint-GUID: Ep1trWt_EVPSEFxFFUAVFnIbBjbqvhVU
X-Proofpoint-ORIG-GUID: Ep1trWt_EVPSEFxFFUAVFnIbBjbqvhVU

DQoNCj4gT24gTWF5IDI5LCAyMDI0LCBhdCA0OjU54oCvUE0sIE5laWxCcm93biA8bmVpbGJAc3Vz
ZS5kZT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIDI5IE1heSAyMDI0LCBKb24gSHVudGVyIHdyb3Rl
Og0KPj4gT24gMjkvMDUvMjAyNCAwMDo0MiwgTmVpbEJyb3duIHdyb3RlOg0KPj4+IE9uIFdlZCwg
MjkgTWF5IDIwMjQsIE5laWxCcm93biB3cm90ZToNCj4+Pj4gDQo+Pj4+IFdlIHByb2JhYmx5IGp1
c3QgbmVlZCB0byBhZGQgInwgVEFTS19GUkVFWkFCTEUiIGluIG9uZSBvciB0d28gcGxhY2VzLg0K
Pj4+PiBJJ2xsIHBvc3QgYSBwYXRjaCBmb3IgdGVzdGluZyBpbiBhIGxpdHRsZSB3aGlsZS4NCj4+
PiANCj4+PiBUaGVyZSBpcyBubyBUQVNLX0ZSRUVaQUJMRSBiZWZvcmUgdjYuMS4NCj4+PiBUaGlz
IGlzbid0IGR1ZSB0byBhIG1pc3NlZCBiYWNrcG9ydC4gSXQgaXMgc2ltcGx5IGJlY2F1c2Ugb2Yg
ZGlmZmVyZW5jZXMNCj4+PiBpbiB0aGUgZnJlZXplciBpbiBvbGRlciBrZXJuZWxzLg0KPj4+IA0K
Pj4+IFBsZWFzZSB0ZXN0IHRoaXMgcGF0Y2guDQo+Pj4gDQo+Pj4gVGhhbmtzLA0KPj4+IE5laWxC
cm93bg0KPj4+IA0KPj4+IEZyb20gNDE2YmQ2YWU5YTU5OGU2NDkzMWQzNGI3NmFhNThmMzliMTE4
NDFjZCBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDENCj4+PiBGcm9tOiBOZWlsQnJvd24gPG5laWxi
QHN1c2UuZGU+DQo+Pj4gRGF0ZTogV2VkLCAyOSBNYXkgMjAyNCAwOTozODoyMiArMTAwMA0KPj4+
IFN1YmplY3Q6IFtQQVRDSF0gc3VucnBjOiBleGNsdWRlIGZyb20gZnJlZXplciB3aGVuIHdhaXRp
bmcgZm9yIHJlcXVlc3RzOg0KPj4+IA0KPj4+IFByaW9yIHRvIHY2LjEsIHRoZSBmcmVlemVyIHdp
bGwgb25seSB3YWtlIGEga2VybmVsIHRocmVhZCBmcm9tIGFuDQo+Pj4gdW5pbnRlcnJ1cHRpYmxl
IHNsZWVwLiAgU2luY2Ugd2UgY2hhbmdlZCBzdmNfZ2V0X25leHRfeHBydCgpIHRvIHVzZSBhbmQN
Cj4+PiBJRExFIHNsZWVwIHRoZSBmcmVlemVyIGNhbm5vdCB3YWtlIGl0LiAgd2UgbmVlZCB0byB0
ZWxsIHRoZSBmcmVlemVyIHRvDQo+Pj4gaWdub3JlIGl0IGluc3RlYWQuDQo+Pj4gDQo+Pj4gRml4
ZXM6IDliOGE4ZTVlODEyOSAoIm5mc2Q6IGRvbid0IGFsbG93IG5mc2QgdGhyZWFkcyB0byBiZSBz
aWduYWxsZWQuIikNCj4+PiBTaWduZWQtb2ZmLWJ5OiBOZWlsQnJvd24gPG5laWxiQHN1c2UuZGU+
DQo+Pj4gLS0tDQo+Pj4gIG5ldC9zdW5ycGMvc3ZjX3hwcnQuYyB8IDIgKysNCj4+PiAgMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPj4+IA0KPj4+IGRpZmYgLS1naXQgYS9uZXQvc3Vu
cnBjL3N2Y194cHJ0LmMgYi9uZXQvc3VucnBjL3N2Y194cHJ0LmMNCj4+PiBpbmRleCBiMTk1OTI2
NzNlZWYuLjEyZTkyOTNiZDEyYiAxMDA2NDQNCj4+PiAtLS0gYS9uZXQvc3VucnBjL3N2Y194cHJ0
LmMNCj4+PiArKysgYi9uZXQvc3VucnBjL3N2Y194cHJ0LmMNCj4+PiBAQCAtNzY0LDEwICs3NjQs
MTIgQEAgc3RhdGljIHN0cnVjdCBzdmNfeHBydCAqc3ZjX2dldF9uZXh0X3hwcnQoc3RydWN0IHN2
Y19ycXN0ICpycXN0cCwgbG9uZyB0aW1lb3V0KQ0KPj4+ICAgY2xlYXJfYml0KFJRX0JVU1ksICZy
cXN0cC0+cnFfZmxhZ3MpOw0KPj4+ICAgc21wX21iX19hZnRlcl9hdG9taWMoKTsNCj4+PiANCj4+
PiArIGZyZWV6ZXJfZG9fbm90X2NvdW50KCk7DQo+Pj4gICBpZiAobGlrZWx5KHJxc3Rfc2hvdWxk
X3NsZWVwKHJxc3RwKSkpDQo+Pj4gICB0aW1lX2xlZnQgPSBzY2hlZHVsZV90aW1lb3V0KHRpbWVv
dXQpOw0KPj4+ICAgZWxzZQ0KPj4+ICAgX19zZXRfY3VycmVudF9zdGF0ZShUQVNLX1JVTk5JTkcp
Ow0KPj4+ICsgZnJlZXplcl9jb3VudCgpOw0KPj4+IA0KPj4+ICAgdHJ5X3RvX2ZyZWV6ZSgpOw0K
Pj4+IA0KPj4gDQo+PiANCj4+IFRoYW5rcy4gSSBnYXZlIHRoaXMgYSB0cnkgb24gdG9wIG9mIHY1
LjE1LjE2MC1yYzEsIGJ1dCBJIGFtIHN0aWxsIHNlZWluZw0KPj4gdGhlIGZvbGxvd2luZyBhbmQg
dGhlIGJvYXJkIGhhbmdzIC4uLg0KPj4gDQo+PiBGcmVlemluZyBvZiB0YXNrcyBmYWlsZWQgYWZ0
ZXIgMjAuMDA0IHNlY29uZHMgKDEgdGFza3MgcmVmdXNpbmcgdG8gZnJlZXplLCB3cV9idXN5PTAp
Og0KPj4gDQo+PiBTbyB1bmZvcnR1bmF0ZWx5IHRoaXMgZG9lcyBub3QgZml4IGl0IDotKA0KPiAN
Cj4gVGhhbmtzIGZvciB0ZXN0aW5nLg0KPiBJIGNhbiBvbmx5IGd1ZXNzIHRoYXQgeW91IGhhZCBh
biBhY3RpdmUgTkZTdjQuMSBtb3VudCBhbmQgdGhhdCB0aGUNCj4gY2FsbGJhY2sgdGhyZWFkIHdh
cyBjYXVzaW5nIHByb2JsZW1zLiAgUGxlYXNlIHRyeSB0aGlzLiAgSSBhbHNvIGNoYW5nZWQNCj4g
dG8gdXNlIGZyZWV6YWJsZV9zY2hlZHVsZSogd2hpY2ggc2VlbXMgbGlrZSBhIGJldHRlciBpbnRl
cmZhY2UgdG8gZG8gdGhlDQo+IHNhbWUgdGhpbmcuDQo+IA0KPiBJZiB0aGlzIGRvZXNuJ3QgZml4
IGl0LCB3ZSdsbCBwcm9iYWJseSBuZWVkIHRvIGFzayBzb21lb25lIHdobyByZW1lbWJlcnMNCj4g
dGhlIG9sZCBmcmVlemVyIGNvZGUuDQo+IA0KPiBUaGFua3MsDQo+IE5laWxCcm93bg0KPiANCj4g
RnJvbSA1MThmMGMxMTUwZjk4OGIzZmU4ZTVlMGQwNTNhMjVjM2FhNmM3ZDQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KPiBGcm9tOiBOZWlsQnJvd24gPG5laWxiQHN1c2UuZGU+DQo+IERhdGU6
IFdlZCwgMjkgTWF5IDIwMjQgMDk6Mzg6MjIgKzEwMDANCj4gU3ViamVjdDogW1BBVENIXSBzdW5y
cGM6IGV4Y2x1ZGUgZnJvbSBmcmVlemVyIHdoZW4gd2FpdGluZyBmb3IgcmVxdWVzdHM6DQo+IA0K
PiBQcmlvciB0byB2Ni4xLCB0aGUgZnJlZXplciB3aWxsIG9ubHkgd2FrZSBhIGtlcm5lbCB0aHJl
YWQgZnJvbSBhbg0KPiB1bmludGVycnVwdGlibGUgc2xlZXAuICBTaW5jZSB3ZSBjaGFuZ2VkIHN2
Y19nZXRfbmV4dF94cHJ0KCkgdG8gdXNlIGFuZA0KPiBJRExFIHNsZWVwIHRoZSBmcmVlemVyIGNh
bm5vdCB3YWtlIGl0LiAgd2UgbmVlZCB0byB0ZWxsIHRoZSBmcmVlemVyIHRvDQo+IGlnbm9yZSBp
dCBpbnN0ZWFkLg0KPiANCj4gVG8gbWFrZSB0aGlzIHdvcmsgd2l0aCBvbmx5IHVwc3RyZWFtIHJl
cXVlc3RzIHdlIHdvdWxkIG5lZWQNCj4gIENvbW1pdCBmNWQzOWIwMjA4MDkgKCJmcmVlemVyLHNj
aGVkOiBSZXdyaXRlIGNvcmUgZnJlZXplciBsb2dpYyIpDQo+IHdoaWNoIGFsbG93cyBub24taW50
ZXJydXB0aWJsZSBzbGVlcHMgdG8gYmUgd29rZW4gYnkgdGhlIGZyZWV6ZXIuDQo+IA0KPiBGaXhl
czogOWI4YThlNWU4MTI5ICgibmZzZDogZG9uJ3QgYWxsb3cgbmZzZCB0aHJlYWRzIHRvIGJlIHNp
Z25hbGxlZC4iKQ0KPiBTaWduZWQtb2ZmLWJ5OiBOZWlsQnJvd24gPG5laWxiQHN1c2UuZGU+DQo+
IC0tLQ0KPiBmcy9uZnMvY2FsbGJhY2suYyAgICAgfCAyICstDQo+IGZzL25mc2QvbmZzNHByb2Mu
YyAgICB8IDMgKystDQo+IG5ldC9zdW5ycGMvc3ZjX3hwcnQuYyB8IDQgKystLQ0KPiAzIGZpbGVz
IGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9mcy9uZnMvY2FsbGJhY2suYyBiL2ZzL25mcy9jYWxsYmFjay5jDQo+IGluZGV4IDQ2YTBh
MmQ2OTYyZS4uOGZlMTQzY2FkNGEyIDEwMDY0NA0KPiAtLS0gYS9mcy9uZnMvY2FsbGJhY2suYw0K
PiArKysgYi9mcy9uZnMvY2FsbGJhY2suYw0KPiBAQCAtMTI0LDcgKzEyNCw3IEBAIG5mczQxX2Nh
bGxiYWNrX3N2Yyh2b2lkICp2cnFzdHApDQo+IH0gZWxzZSB7DQo+IHNwaW5fdW5sb2NrX2JoKCZz
ZXJ2LT5zdl9jYl9sb2NrKTsNCj4gaWYgKCFrdGhyZWFkX3Nob3VsZF9zdG9wKCkpDQo+IC0gc2No
ZWR1bGUoKTsNCj4gKyBmcmVlemFibGVfc2NoZWR1bGUoKTsNCj4gZmluaXNoX3dhaXQoJnNlcnYt
PnN2X2NiX3dhaXRxLCAmd3EpOw0KPiB9DQo+IH0NCj4gZGlmZiAtLWdpdCBhL2ZzL25mc2QvbmZz
NHByb2MuYyBiL2ZzL25mc2QvbmZzNHByb2MuYw0KPiBpbmRleCA2Nzc5MjkxZWZjYTkuLmUwZmYy
MjEyODY2YSAxMDA2NDQNCj4gLS0tIGEvZnMvbmZzZC9uZnM0cHJvYy5jDQo+ICsrKyBiL2ZzL25m
c2QvbmZzNHByb2MuYw0KPiBAQCAtMzgsNiArMzgsNyBAQA0KPiAjaW5jbHVkZSA8bGludXgvc2xh
Yi5oPg0KPiAjaW5jbHVkZSA8bGludXgva3RocmVhZC5oPg0KPiAjaW5jbHVkZSA8bGludXgvbmFt
ZWkuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9mcmVlemVyLmg+DQo+IA0KPiAjaW5jbHVkZSA8bGlu
dXgvc3VucnBjL2FkZHIuaD4NCj4gI2luY2x1ZGUgPGxpbnV4L25mc19zc2MuaD4NCj4gQEAgLTEz
MjIsNyArMTMyMyw3IEBAIHN0YXRpYyBfX2JlMzIgbmZzZDRfc3NjX3NldHVwX2R1bChzdHJ1Y3Qg
bmZzZF9uZXQgKm5uLCBjaGFyICppcGFkZHIsDQo+IA0KPiAvKiBhbGxvdyAyMHNlY3MgZm9yIG1v
dW50L3VubW91bnQgZm9yIG5vdyAtIHJldmlzaXQgKi8NCj4gaWYgKGt0aHJlYWRfc2hvdWxkX3N0
b3AoKSB8fA0KPiAtIChzY2hlZHVsZV90aW1lb3V0KDIwKkhaKSA9PSAwKSkgew0KPiArIChmcmVl
emFibGVfc2NoZWR1bGVfdGltZW91dCgyMCpIWikgPT0gMCkpIHsNCj4gZmluaXNoX3dhaXQoJm5u
LT5uZnNkX3NzY193YWl0cSwgJndhaXQpOw0KPiBrZnJlZSh3b3JrKTsNCj4gcmV0dXJuIG5mc2Vy
cl9lYWdhaW47DQo+IGRpZmYgLS1naXQgYS9uZXQvc3VucnBjL3N2Y194cHJ0LmMgYi9uZXQvc3Vu
cnBjL3N2Y194cHJ0LmMNCj4gaW5kZXggYjE5NTkyNjczZWVmLi4zY2Y1M2UzMTQwYTUgMTAwNjQ0
DQo+IC0tLSBhL25ldC9zdW5ycGMvc3ZjX3hwcnQuYw0KPiArKysgYi9uZXQvc3VucnBjL3N2Y194
cHJ0LmMNCj4gQEAgLTcwNSw3ICs3MDUsNyBAQCBzdGF0aWMgaW50IHN2Y19hbGxvY19hcmcoc3Ry
dWN0IHN2Y19ycXN0ICpycXN0cCkNCj4gc2V0X2N1cnJlbnRfc3RhdGUoVEFTS19SVU5OSU5HKTsN
Cj4gcmV0dXJuIC1FSU5UUjsNCj4gfQ0KPiAtIHNjaGVkdWxlX3RpbWVvdXQobXNlY3NfdG9famlm
Zmllcyg1MDApKTsNCj4gKyBmcmVlemFibGVfc2NoZWR1bGVfdGltZW91dChtc2Vjc190b19qaWZm
aWVzKDUwMCkpOw0KPiB9DQo+IHJxc3RwLT5ycV9wYWdlX2VuZCA9ICZycXN0cC0+cnFfcGFnZXNb
cGFnZXNdOw0KPiBycXN0cC0+cnFfcGFnZXNbcGFnZXNdID0gTlVMTDsgLyogdGhpcyBtaWdodCBi
ZSBzZWVuIGluIG5mc2Rfc3BsaWNlX2FjdG9yKCkgKi8NCj4gQEAgLTc2NSw3ICs3NjUsNyBAQCBz
dGF0aWMgc3RydWN0IHN2Y194cHJ0ICpzdmNfZ2V0X25leHRfeHBydChzdHJ1Y3Qgc3ZjX3Jxc3Qg
KnJxc3RwLCBsb25nIHRpbWVvdXQpDQo+IHNtcF9tYl9fYWZ0ZXJfYXRvbWljKCk7DQo+IA0KPiBp
ZiAobGlrZWx5KHJxc3Rfc2hvdWxkX3NsZWVwKHJxc3RwKSkpDQo+IC0gdGltZV9sZWZ0ID0gc2No
ZWR1bGVfdGltZW91dCh0aW1lb3V0KTsNCj4gKyB0aW1lX2xlZnQgPSBmcmVlemFibGVfc2NoZWR1
bGVfdGltZW91dCh0aW1lb3V0KTsNCj4gZWxzZQ0KPiBfX3NldF9jdXJyZW50X3N0YXRlKFRBU0tf
UlVOTklORyk7DQo+IA0KPiAtLSANCj4gMi40NC4wDQoNCkkgd2lsbCBtZXJnZSB0aGlzIGludG8g
bmZzZC01LjEwLg0KDQpJIGNhbiBhbHNvIHJ1biB0aGlzIHBhc3QgTkZTRCdzIHVwc3RyZWFtIENJ
IGFuZCBzZW5kIGl0IGFsb25nIHRvDQpzdGFibGUgaWYgeW91IHdvdWxkIGxpa2UuDQoNCg0KLS0N
CkNodWNrIExldmVyDQoNCg0K
