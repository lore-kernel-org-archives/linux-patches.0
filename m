Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F30376E0
	for <patches@lists.linux.dev>; Sat, 23 Nov 2024 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732378343; cv=fail; b=nvpEsxmWSuDlQkaU308hzBrY8lSyWDqyRkyQopYzRmpzUR1yfOo1b9flUyA4YoZZokb2ZqY64sSPLYLEQVu5I2KXXAPL0Rz3qQaz/TzLT7m5LUSLZD038STKelgpY29/4Ln3/+Dh9mDUlCO2R+klv6K6h4qejdDWxn0y7abuh98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732378343; c=relaxed/simple;
	bh=lDhF3993OW+t/vh71Vo2IezZx8jptYB2upkI2mpz4Kw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jcFc7G/Ei6g34gXz9THCX5Jmf59W1dJtzWFX0QeBCaEuwrJiIMDUFp4PiUkasv2fP4OWpCJu7WHXAgKzg+SHTnDADAo6l7r20pCEVQBIPtjFNAlfdpAhDkbH4ze680HiPClN/i3Whczhmn9iRJEppRAuSwmUvqSMfmnxvvIMbBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J4KF2dWc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=crwmUj4f; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4KF2dWc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="crwmUj4f"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ANG2MFo014938;
	Sat, 23 Nov 2024 16:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=lDhF3993OW+t/vh71Vo2IezZx8jptYB2upkI2mpz4Kw=; b=
	J4KF2dWc0HlEAEzmfT6xhX8InUeddMzw/EKyd7wJEDuCJK4XScNV3uDqDgWThYtb
	2ZtO0pQDeykHiNCsQAp0ZmFJnORRERTMiD8v+5Ron/4dFl3L3Qfx3X1dMKrBEChw
	nKiICiTAbiP5WR1DVwfa7hXMLhPBruU6YWup5ZGTKkptAjS3HfSudWutsg1+o8ZF
	Z3BWSSTK8wRiTnnF1GK4aI0LPRWjzaF5rVGOXU8KDfryPlC13FmJzAVPTOqRXVYr
	+yrDSuixmxxtXUQDLE978nHUuUwTfPxRZPYYmhbKWQ4OITT2FahHkVbWBz3wXqvk
	e6AviiuVnXYyvi0ddz/74A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 433869rfta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 Nov 2024 16:12:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ANFknsV004739;
	Sat, 23 Nov 2024 16:12:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4335g5srf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 Nov 2024 16:12:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s4Y1iOfrriH7MRxwY82Pbf56H2axOpgEMN+JWYoXhtyxtcXOPFWNqh4a3y9TqBs9c30wSFCReJ1miwY1jTytwRwqDITkOFH0CZBdFFJhLVno/HR93NtqwLw+ZTL+ES4To4VbJxQUHz08Wrk0A14t/x4qWaqtQSQ3wZ182iOyVkpl1GxsSQGR8fxN6EP9eKzkPj0QfGJgBvn37q3bfJ2tI+VEFghCT8BhcT8I2LIXFYjUj8l1n8YecGMcXzU7uvOmTf+K4LhL+Lp38xyPsCW8CdGQ1Z8vocT1X394vqPhEFlaQ4rt6nPb/FhfXC/jhWTRCARBtctNiaQABq7VgG3+/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDhF3993OW+t/vh71Vo2IezZx8jptYB2upkI2mpz4Kw=;
 b=QWg6o+wQbWAzJkgp9LWZ0oemrIhWhPR9YGhOYDWPpgoGPOMvnAgfnrnR9A4i4peoSWI2A/1V/XNV59pG1ppHc692j3MdaxZSYrZUo4GPqYyxweagNrSgOm9Yjns4ygmzrEe8Ai1lLyqLo/+FguuulgGAq2LhNymUsFVpjnu0jE0ywPRvXrxSbqpBQusUlQF+Ek3T2ucDKgINvYdxTMsCSVFnEJMRouaVq+Zn8QxzUNcv+7lIU91NAU3EV/Ikv+6lOv+6ZaE2/EFaZUqZ+55o5Ks5vHzYVWP9HCfOBk0t9fr7CvyZvwxX/XTZPOh0vyjzisttEHYE+WxqYoxje2IkcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDhF3993OW+t/vh71Vo2IezZx8jptYB2upkI2mpz4Kw=;
 b=crwmUj4f1GethxMAY/1adqWxHD3IJ0GH2oaTh7KRXOeNbOvR/IxKjsx5P4J+PhMzO1ASDF2q7BJyyKop9hzvPuLgmNg1/Afe71ySBKn5ucNR0THQFlaZLv3xMxT4B3HIGUahGRCK+JxTaCjB+/BRXmE9q7hHuKCmlXwNBGyXvdE=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by SN7PR10MB6305.namprd10.prod.outlook.com (2603:10b6:806:273::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Sat, 23 Nov
 2024 16:11:58 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::39b2:9b47:123b:fc63]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::39b2:9b47:123b:fc63%5]) with mapi id 15.20.8182.018; Sat, 23 Nov 2024
 16:11:58 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Pavel Machek <pavel@denx.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-stable
	<stable@vger.kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com"
	<sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>,
        "conor@kernel.org" <conor@kernel.org>,
        "hargar@microsoft.com" <hargar@microsoft.com>,
        "broonie@kernel.org"
	<broonie@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Thread-Topic: [PATCH 6.1 00/73] 6.1.119-rc1 review
Thread-Index: AQHbPXj4T7O9Wg5WBku1fQSXrwSjAbLFCdcA
Date: Sat, 23 Nov 2024 16:11:57 +0000
Message-ID: <4EA31082-AA71-4E14-B63D-A7AE2480ABA6@oracle.com>
References: <20241120125809.623237564@linuxfoundation.org>
 <Z0GDhId6mYswr+K0@duo.ucw.cz>
In-Reply-To: <Z0GDhId6mYswr+K0@duo.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51.11.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5134:EE_|SN7PR10MB6305:EE_
x-ms-office365-filtering-correlation-id: 64ab5cf2-0b0f-40fc-7c06-08dd0bd98e55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?T2NmNDlncVptMEtpa0NQbmQyUWFFQXhCcCtoWis0SmtYZ050OXMxMEduY1pJ?=
 =?utf-8?B?UDRtZEJLL3dBYlQ2TElNUG9zcWdGT0padDhwWk5oREUrOGhmSE1GcHFoK29I?=
 =?utf-8?B?aW05ZFF5dERjcW5wUmNIWTZlY2tEb0xVY2c0Q0diY2VqZzZmZS9idnFtWEd3?=
 =?utf-8?B?cytYUVV1N0I2bUVhS1NKU1gyQldGTmVxTFIvaTJhTGxTOTRSdU5aZVRMVzk4?=
 =?utf-8?B?REZQcFIwNXFrbzlmeUxoRTNNWjJYVmJ2QVZuQlVQNWhmNm5JcEhsMzVLblFl?=
 =?utf-8?B?RUJVV0d3WGxFRFBMMGN4Q3B0TEIyN0VLOThFZi9HUmhTbUt4UDNJc0hia2lx?=
 =?utf-8?B?K1hQZ09zd0Z5Wm5haVdHWkxsYTIrS3RLc2tSN01pZXdPMEl4c3hGQXNGWUJY?=
 =?utf-8?B?UEtmWThPcHd2cUV2MUlvOStoNjdVZnhYSTV5V01TaXRDM3B5VVhjUVN4OENK?=
 =?utf-8?B?T3FZTWdGUU5uZXh0YnJNWWV2WkxwTEZHamdFRmV5cWQ5UDd2bW1MTVdDRzRT?=
 =?utf-8?B?K0lXRXF5QVZrQVRjc2NySkxKcWR5N0xFRGJrcnZLSENBODRxejdJK2tTT3VN?=
 =?utf-8?B?Y2VjU014VytVUW5vZHYzYUZhbURlK0IrUEo3TGdROVNlUFFYU2FJUVpyeU5D?=
 =?utf-8?B?SUxjVzNrU0lCSzZscGV3OWNPanlRektLdVNxajlOeHZidkFUY2VRbm1rbDZj?=
 =?utf-8?B?aEdMYWFyOHRaY242K09acDNzSEVDbitkNThDYXc1WmRDZTh1U3N6UVJjSWM1?=
 =?utf-8?B?NmhrN09jYnhFTjZXVWIyMThXNjRUOTNCa3orQk1aaStSMERUZmZIanpSY1Bz?=
 =?utf-8?B?UnFudkh6SC9kdnh3b1hybGcvN0xPRWhzS2ZmOHVHV0MwZTRFL1NEVlBIZHRY?=
 =?utf-8?B?aWFvNE5OYVJ2YyswOE0rSlBxUWdGVnZLLzI4eW1aRDFHZWQwUFZWZlRZRmFs?=
 =?utf-8?B?Y0hEVG4wYnJmYVJNb21yWTRhV1dPeGpreER6S0RQbmtUQXg2dmxHb2JaZml0?=
 =?utf-8?B?NDVYUk9uQUhFU3hROU55NGVtV0VCTUZNMVVzSTR6L3htQXFlNkI3SVVQeFpC?=
 =?utf-8?B?S01IalpwVlZNRCtWdHlhRklFT1VqN1BYRzEreGE4UFVNZG9kaFlFemwwbmVx?=
 =?utf-8?B?L1RYbUdPSnlxUHZlUENWRHZwdk81MkFXb0RiVDZhZVFPVjBLZEp0Y2F2a2xy?=
 =?utf-8?B?aCtVWW5hK1NjcjcwUVlzcTJ2NmdCZ0IxUWx5TGt2TkF3MEtoVE9LUEVuLzBP?=
 =?utf-8?B?dTVSRDNoOXZ5YmppNWpjVEpMSFJiUkFCRlI1a0NjT3F4YzJYb0dNMUthb3pS?=
 =?utf-8?B?KzJzSU0wU2Fjb2MxaEtIQ0JUbzV5VWRjeC9lSTRMSFBkR2xvNU1LUzlKR2V3?=
 =?utf-8?B?WFRjQkc5QVoraEtORGN1Z2I1ajZpMysvSFpJQ1YvTXg2bUlzWFhBNDV0ZXZW?=
 =?utf-8?B?bWwrNlFSQkwyVjVFUnBFaWQ4SkZZZmR4cFdMaTBhN2E2UnlUa1o0YWdtU2xK?=
 =?utf-8?B?S044T1BEd0hzQ2pGa3lDM3MrbDhsVFl4aVlqOWYrZ2E0VlZVemh5T24wVWQz?=
 =?utf-8?B?WDFjMlNBdSszcTQ2TTBZbDQ0Wkx4UW1LUXFBeFZ0YnVGR29oWjdTSHVFOTRJ?=
 =?utf-8?B?anM5eHRuSEovMnUxWUFUQi9td1cwVFVqWUFrOGhPWGJxaitFcUdsbEYyZEJi?=
 =?utf-8?B?STV2T080UjI3NVV5ajdaWjY3TC9mRmRmQXBFQ2JvSG5kanQrMU9KSUFrNEZ0?=
 =?utf-8?B?TlErZ0EzZ3pEY0xLL3R3NGtEY1dUQTRzUk9HRDV3MlEzUTdMeGQvU0lsdEV5?=
 =?utf-8?B?b3ZjL0hOZCtxLzg5bm50b1FxVmxWNTBOOHFPWjk5N0hrZFB3RTlvVkEzYTZO?=
 =?utf-8?B?VjJTVmQ2cGIvS0RXK3dFelFwWlliZER4QVB5QThQeHNhcnc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Tzd5cXJoT1R0L09HN2NmdGZjR1B1aXVteWg4UkI0UG0yRzNRWmNLamRuc1dE?=
 =?utf-8?B?enB2cWZOTDVHTlN6WXdJQWsyQStLb1Nwek9lSktuTHo5TzFOS3pmaXJJZUth?=
 =?utf-8?B?d1BWeEVxcmxxZEkrZEZON3dMUmdqeUVHYjMzb2c2STdwL21SUmxIY3lKZGM0?=
 =?utf-8?B?K3Zsb0hDa1ZUZjRNMyt1WG82NjJzL3U3bUdGVGExeTRlRmduOVNGakJnbncz?=
 =?utf-8?B?bi9RRXgvcmt4WXZiRkJTbGhtQUgxM1czdVVBV0c4bXF4TE1KaXhvYXJGSnZ6?=
 =?utf-8?B?WjdRK3VXdklkU3NPazUrYU85bVlMOXFhbkVGYk5JY3RMODlsano2VEt3Vko1?=
 =?utf-8?B?cTJuMWpRQjZsL1A1Z0l5M21Pc1BGbnR3RWFyYm1JWFVTSkkrL2IyNWVsbk1k?=
 =?utf-8?B?cjIyUS9JckhVRDBZYy9MRmJ1V3J3aXV0bDZuZTR3TUx1V2s1bFBsNFNEeE9P?=
 =?utf-8?B?ZE9ScEdrcDFJSTUxaG1IbmZTd3p3OTN4M2JMazBtR2tjemIwa2dFQnAxL25N?=
 =?utf-8?B?SkVuNHVndkhURStrRTJxNi9jS1M4a0RjWWFYdlJPeUI4YVFoS0k4TlpmZ3pV?=
 =?utf-8?B?YTRQWldVTjBvdWE2RU5Qdyt5NkM0d21acDhUc3VHSTd0NWdwMU1Jbkg2bS8w?=
 =?utf-8?B?R2VBS3VKTXBRa3pWOHI3Q0hlb2p6ZnlLcXZOQnhDV3FUQUkrUG9GYlR6VDE2?=
 =?utf-8?B?YUQyYWpBRFZNeUpTemkyRm9oc3dYWGtKUUlac3VHakgxWGMyUEpFWmh6dDlJ?=
 =?utf-8?B?T3hXaENabVNSZU9JNGFSVUdMYjFUZHBOSjR4OUpEN3ZORkRuVW1FSGUwNDlS?=
 =?utf-8?B?aVBNZFY1UjIyUzJ5c0JTNkFSK1ZUaW5XL0huK3F4RmUrcmlvVTAveUhDZGQw?=
 =?utf-8?B?UWJTRXJVa2hzNTZEZXhlSmpvV3h0cWJ0dGRZOTdrbzBmS2J6NkliYys3NDVD?=
 =?utf-8?B?OFZ4dHJ6aFhKOEF6a3g5Mlc5UmlVZFdLYXNROUhKQ21tdVpzOHNSQitLVlNY?=
 =?utf-8?B?K2JVRGliaFR6VjlaeXo1UVhLU1dibXoza1NTOS9OeDdmVzQzMG5YWkN4OTBs?=
 =?utf-8?B?TjNlNUh5ZW52ald4OUJOSEVsbkdyYktUdHQ0SkVETmI5WHZvSmpUUTRBM1VN?=
 =?utf-8?B?OG05bGxXMWFvU01DWHNpYXpldkkrakxKRlVHd2Y1UmlGWnVPNFpreVAwN2p4?=
 =?utf-8?B?dWRvUDh1dWNSWHVNUGJSemk2TzJqeGtkWTVDL2VHa0ZXV0JnT2NCMGJSWnNT?=
 =?utf-8?B?Qk93ckJET3QrT2JlWFZVVmlyWHE3Y01TbUNGeVRGT2ZLT2wwTGdZbEE4VURj?=
 =?utf-8?B?aG9zNUJFWWdyM2J4MTBjYk9pcHFhMnpWdVRhdUVLYW95OWorYTRXNW1TMkhN?=
 =?utf-8?B?U2NnMDZ1Y0lvMFhPaWxpMkxSZWNWdkthV1RQQkpSQWpMUTFadzhpd3gxK2Zn?=
 =?utf-8?B?RlFFbDBldmhZbjJ1djU3dEZzRzFoT2t3SFlLdmZzY1V0aFBKRy9ZK0gzRGRJ?=
 =?utf-8?B?MU9ObHAwR1QrdngxOGRXNGtvdmJYeHZtbFkxTTg2UVRpMCs3L1hOKzRMUHZk?=
 =?utf-8?B?NlU5MXBRRWowdmF3b1V0ZHVBNklCT0x6dlRlbE8wdlpDY0h4Zys3bVJHSzN4?=
 =?utf-8?B?TlhVTHdiRTJWMmgwZmszOTZsRmE0b0IydGNRdkhSNGpPaUZibGtzaFB4V2RY?=
 =?utf-8?B?SFhTTS8wTFVKZjBSNFpOa2lsMy9nUkdiRmJqVjZ6L1U2eTlaMGxEQ0lkMDhs?=
 =?utf-8?B?d2NyVWRDN2VHTGFSOGRHOThRTmlFV1RDMVg2S0hTQUhuWjBYN1d1THV0SUc3?=
 =?utf-8?B?Q2ZZOVp1K3U2d3RwbUFjd0V2SUdwRXhHSnN3RzNrd2hOR3pqNVpmTlpuSGFY?=
 =?utf-8?B?OEUrVXR6Y3M3K3lNS2hER25BY044cXFvVlQ0a2FUUFAzbWcyeFNPeFBYSFo3?=
 =?utf-8?B?dTZYeFFEYVhEelNyaDNlUEZIcGlwQVowMjBldWUzMTYxZlQxclFQWGVOQjV0?=
 =?utf-8?B?ekVabWVuS1Q2Tm5oZHE3SzYrYklzN2JMNEg5RmRVUnBNYVJNaWdQYVc5dm5v?=
 =?utf-8?B?M044Zk84RnBqNDhSWms0VGl0T2JVMHVqckhtS1BHUDc1ZU55Nk9zbTgvUHFF?=
 =?utf-8?B?cXZ4QkFNaEt0bjlGSEZTUmxSUVlvNFJJV2RSUFQxV1FPRE5kV2dBQWdSM2ZM?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89FCBF6C470CAE438A974F42FCF8C164@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KB02D4GVaTyEL02Ft9IF3/WTOBUEV7UBK9Plz0LzSIihkK1Pkacarh+MfOECnAcxJEZeRh7dn1fHvmxjl+2flUet23QW37pR05S462TMHfSQntFCHt1y2TYus2ILrG7C5vJopOkzi0ywh7N9Hv8xyGJRvrZysHjnXzFs3gjjd7sL6Bvsd5dYJblN0chA5ZrrT30xx5qAaV7gpp3l44OhiNnaRkv+lYFdLbTawe+pKNlDAzfi9lAW8IFd7t+xgC/zfzmrOn+yQehiosDiDfpROUUwXAKUHm/EJqJTsCjKqYwybOzjP/a1KRUbV4FLqo/RgJcjMJJHYAgVErF2zVqHqun71gUTlmEM8xhGna7KtTIZaoiHfhnJI6va/WvVovxUSo5IZW5snI5GNyXRqQobFhe8rtc/RTO/4QJDYIHA18r/akud0QcNeAb3IBfw/26HMuSFrdYcei7q11soGU4lofTs+US5GB3tFUVMv3uQEiTM7QgXB9iq+zuro2O5iSBj4CwjpxSsADa3IsnN1h/24USgRGQNsaAagcbkcLvWHzBfL311VofbYBosy7iuVa3mIcOCIbbTFBjw3AqonYyWmBoOnuHw1WuPLmRjEwN5Gh0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ab5cf2-0b0f-40fc-7c06-08dd0bd98e55
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2024 16:11:57.9761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rHE2C90FnnkkyHDZfaPX+2JrLmzs8EoFT52wSOJLzRzCB0YCwBjwhBF/L3x++PK8YaQnhH3z1prhiHgbpJ20UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-23_12,2024-11-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411230130
X-Proofpoint-ORIG-GUID: bh4W-zK0vc3lhwtdMTDXTTxcjJiUqsZd
X-Proofpoint-GUID: bh4W-zK0vc3lhwtdMTDXTTxcjJiUqsZd

DQoNCj4gT24gTm92IDIzLCAyMDI0LCBhdCAyOjI14oCvQU0sIFBhdmVsIE1hY2hlayA8cGF2ZWxA
ZGVueC5kZT4gd3JvdGU6DQo+IA0KPiBIaSENCj4gDQo+PiBUaGlzIGlzIHRoZSBzdGFydCBvZiB0
aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDYuMS4xMTkgcmVsZWFzZS4NCj4+IFRoZXJl
IGFyZSA3MyBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBhbGwgd2lsbCBiZSBwb3N0ZWQgYXMgYSBy
ZXNwb25zZQ0KPj4gdG8gdGhpcyBvbmUuICBJZiBhbnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0
aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4+IGxldCBtZSBrbm93Lg0KPiANCj4+IENodWNr
IExldmVyIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPg0KPj4gICAgTkZTRDogTGltaXQgdGhlIG51
bWJlciBvZiBjb25jdXJyZW50IGFzeW5jIENPUFkgb3BlcmF0aW9ucw0KPiANCj4gQEAgLTE3ODIs
MTAgKzE3ODMsMTYgQEAgbmZzZDRfY29weShzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLCBzdHJ1Y3Qg
bmZzZDRfY29tcG91bmRfc3RhdGUgKmNzdGF0ZSwNCj4gICAgICAgIGlmIChuZnNkNF9jb3B5X2lz
X2FzeW5jKGNvcHkpKSB7DQo+IC0gICAgICAgICAgICAgICBzdGF0dXMgPSBuZnNlcnJubygtRU5P
TUVNKTsNCj4gICAgICAgICAgICAgICAgYXN5bmNfY29weSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVj
dCBuZnNkNF9jb3B5KSwgR0ZQX0tFUk5FTCk7DQo+ICAgICAgICAgICAgICAgIGlmICghYXN5bmNf
Y29weSkNCj4gICAgICAgICAgICAgICAgICAgICAgICBnb3RvIG91dF9lcnI7DQo+IA0KPiBUaGlz
IGlzIHdyb25nLiBTdGF0dXMgaXMgc3VjY2VzcyBmcm9tIHByZXZpb3VzIGNvZGUsIGFuZCB5b3Ug
YXJlIG5vdw0KPiByZXR1cm5pbmcgaXQgaW4gY2FzZSBvZiBlcnJvci4NCg0KVGhpcyAic3RhdHVz
ID0iIGxpbmUgd2FzIHJlbW92ZWQgYmVjYXVzZSB0aGUgb3V0X2VycjogbGFiZWwNCnVuY29uZGl0
aW9uYWxseSBzZXRzIHN0YXR1cyA9IG5mc2Vycl9qdWtlYm94Lg0KDQoNCj4gKEFsc28sIHRoZSBh
dG9taWMgZGFuY2UgZG9lcyBub3Qgd29yay4gSXQgd2lsbCBub3QgYWxsb3cgZGVzaXJlZA0KPiBj
b25jdXJlbmN5IGluIGNhc2Ugb2YgcmFjZXMuIFNlbWFwaG9yZSBpcyBjYW5vbmljYWwgc29sdXRp
b24gZm9yDQo+IHRoaXMuKQ0KDQpJJ20gbm90IGNlcnRhaW4gd2hpY2ggImF0b21pYyBkYW5jZSIg
eW91IGFyZSByZWZlcnJpbmcgdG8gaGVyZS4NCkRvIHlvdSBtZWFuOg0KDQoxNzkyICAgICAgICAg
ICAgICAgICBpZiAoYXRvbWljX2luY19yZXR1cm4oJm5uLT5wZW5kaW5nX2FzeW5jX2NvcGllcykg
Pg0KMTc5MyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIChpbnQpcnFzdHAtPnJxX3Bv
b2wtPnNwX25ydGhyZWFkcykNCjE3OTQgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXRf
ZXJyOw0KDQpUaGUgY2FwIGRvZXNuJ3QgaGF2ZSB0byBiZSBwZXJmZWN0OyBpdCBqdXN0IGhhcyB0
byBtYWtlIHN1cmUNCnRoYXQgdGhlIHBlbmRpbmcgdmFsdWUgZG9lc24ndCB1bmRlcmZsb3cgb3Ig
b3ZlcmZsb3cuIE5vdGUNCnRoYXQgdGhpcyBjb2RlIGlzIHVwZGF0ZWQgaW4gYSBsYXRlciBwYXRj
aC4NCg0KTmF0dXJhbGx5IHdlIGhhdmUgdG8gYWRkcmVzcyBhbnkgaXNzdWVzIGluIHVwc3RyZWFt
IGZpcnN0LCBzbw0KcGxlYXNlIHJlcG9ydCBpc3N1ZXMgYW5kIHByb3Bvc2UgY2hhbmdlcyB0bw0K
bGludXgtbmZzQHZnZXIua2VybmVsLm9yZyA8bWFpbHRvOmxpbnV4LW5mc0B2Z2VyLmtlcm5lbC5v
cmc+IC4gVGhhbmtzIGZvciB0aGUgcmV2aWV3IQ0KDQotLQ0KQ2h1Y2sgTGV2ZXINCg0KDQo=
