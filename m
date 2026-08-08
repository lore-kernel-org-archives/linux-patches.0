Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CFC36B061
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 20:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786221635; cv=fail; b=jkPs/OY9hATeYUrPxCuZEYEPF70tB0mTndeOExyY2IZJP+eVbdytE18EGyzFduCcqWLEenK3RTUz2GUkONEhNCcSxB6U4oIsusNR9KIzmrsp3ac6lVbc51iknGQ4lsN8cxmFrAOJqtJIkQFyXgSojFKs3tnLgQFnYEIoHKRXFV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786221635; c=relaxed/simple;
	bh=sFUa9CIHWP/Yn7MyCSqMahHNp/lK5ZtYTcoyhtY607o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Cf2Ieav/j0GRmGs60h4+9gvZL3p/dfbh/yiDuXBZcjaYps2TOAwEE7ZC6H7MMirfPSw9au18ERZVDQGguqEPEHWJ8QcAu4PbZebBx4CO3qb8jtvTB8CHcoVK0+nc8xc5n0dbGbtBR1Jq5RpIPLcgR71ZZk4t6iE7kih6YghR4uE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LCaqY/zO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MyzzcX6X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LCaqY/zO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MyzzcX6X"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 678JDOo74103779;
	Sat, 8 Aug 2026 20:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qG+kucvR7YjzRy048WjAitC5AWbcIKkFwbH4BWSdUTE=; b=
	LCaqY/zOe15wbYz+XHzJeAYhufLhppG8cUDTPjfcNizEX34K1k6CNb6aQbzrRBR7
	/dxwKiXOKS3Ee8rEcI+GDp4xRXCvuaYNzpWXbX4fxL0bXC1vJd9wQYrHES5BK3t6
	jZgnoi3ACTAqgQfgRBEcTQ3AwaqVjKjv/4YI+DUEkEmBVJC728i+tNM4iZSgSrOU
	aw45BSxGZlWQvgVfoyQEAc2GvjVSeEvw8Xd0oMDnPkZNvqjNJfftsiueqHX1XvuU
	YU1+r+vZ9YmnV2WSfvK7UPNl7/8IcavzefFJ5wsZOqegWRLzo9ffkKymtGjOV5vl
	Nh488yZQyUwXqkJszZSBzA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvfxrx34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Aug 2026 20:40:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 678KeFQ3025864;
	Sat, 8 Aug 2026 20:40:15 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011055.outbound.protection.outlook.com [52.101.62.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwb7qd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 08 Aug 2026 20:40:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yuKKqDw8nyqhSBzPlXOx/3b1HU4x+S1kXCOApwpRIzEMDPnSZeNvDQf6AsCw7tgtJW79M6I6CoSPpFVcbXkxr1dgOdge0/CC6BYcCwnDqlRjsvJaiAL4Q+uYN9Q/dFYeI2PWTCSH3Fx+TmNlAIed4XKpV6+rTDfF65xDYBvGictlctdsJmqjK0ALOhedvEKuEXKguuJQGONDoXIpTc5N3xmwk2jf+yfJpcVKcp1OhKBTO3JMgBJwOq06kOquPhPy9KX8/wVHIIkPQnO6SlzngilccP7U3ryeY3e5S+/Jqxr2mL757WT8f8UD1YiXt51asPNV5gdOifMAGp0vSlU4Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qG+kucvR7YjzRy048WjAitC5AWbcIKkFwbH4BWSdUTE=;
 b=kd6Vkm1EbGiPbLlaBHWdvdnDlC6enCh1eS6GcveGg5yhJmn2ewY5yv5UPKAZrCVCACveFNbxfeC1Vtf6V2JdwzxGo7Qslsf/JoihkY14i3jezErmezFpPHrqphlPk2bsjkSEPCfCmuJL22+l/LHCgfxjOz5fvHhQrTqM4PovlKjMMn60b1XdW4UEkB6aUOhhylfs2hYPNxTzht71qJwlMs4229F+wqU5eTTdIN+xkHj9A88e3TcXHpSaA3QLcQn9kLe9DnVHcBpLfiQnwXWEr/CaTyY55n13/6B44fuPN/6o7ge0dO6IjQGMZXtIOEPWZMEnndEp9mBpo/5vz66g3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qG+kucvR7YjzRy048WjAitC5AWbcIKkFwbH4BWSdUTE=;
 b=MyzzcX6X/U9Gf4Lul8fxJg2B3BvZYKHzg7eGTYLo+AaL1G7YnRRXb3HJhLvGAXEUukYqSAfO01c1JNH8uKVYSx3hBBxGZOQTYeFVdc1ZSgjb19eken3wOAvOa5bmmv+Gqr5S+KBEtT2YQP/BR8oKYv3n5huMdAwJbXBEpefdgvo=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ0PR10MB4655.namprd10.prod.outlook.com (2603:10b6:a03:2df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sat, 8 Aug
 2026 20:39:32 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0292.022; Sat, 8 Aug 2026
 20:39:31 +0000
Message-ID: <f73b680a-da19-40ce-a5a7-8d2a4c569b2c@oracle.com>
Date: Sun, 9 Aug 2026 02:09:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com,
        Ilya Maximets <i.maximets@ovn.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260807143418.516897842@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO0P289CA0014.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:20::13) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ0PR10MB4655:EE_
X-MS-Office365-Filtering-Correlation-Id: 55e82cf3-148f-418f-1019-08def58d2664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	qmnQ+mzVlOQJezkH83GM+hl4SZN5mnoCRQ7s0ZMt3UBU4jmUtpkpp9z+BURWfXKUrUEz0XcnjdD6N+eBbwkXFW5P41M9vxS3+mIBjlvrSKrb+2ztaKw9mWCG1a8wBIph8OQiU3fot0RVAaitMPjwj3bS21aLQdPkWVmFaDbievGzAXcuttk2KDIQd0oZ2Sbhy7NsuuZfEOYA6/ZxgMO5aojvyGVqMxDH71uDihIchu62QCi7Buc57/XemICZBNJFdn8bYUHPXGPxdfAhB3Ot6kZce+w7iBr9X+SoHgDZskVgP0pTpEsJBFkHJoJN5Jy2XmWsuvkLAkS1GoOvBcpveIDUBPyVCJ5gZqPxS5lk8qqO+hg26i01k3rhkHGJnRBUNu8bIFHw9TTtzPm/E4JCmF0NJc6kfQiEL6z2guX525TWmN9Azion4iKuW+nOnprX16yrYZND9iHJWL8hUr/qiqUI697rDigR0hBQh7Z9nIOtOcl2XSqYwYyZgUHjVm2uKmJeuUnhQUltRjOb+UmrbJhtpNRgxXhj0EFnvrr5QhQLMP4V60wO4uPhlfQexq4d8EOyrLNnnDuusN2ewGaeW3f4U3Gcu/ItlvIupAJFreE+mXO2h+GpseEXL2uGK5g6Fs5Pr3bYbbDIZGM1qrHYlF+t39/VBLYKi534BBx64Nk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1YvZEVqa1g4N25SS0cwS2IxbTFUcEZMREEvL09ieGVYZTJ1azNiWDZXTndY?=
 =?utf-8?B?bVVOM29Xazd4NVpka0pRUERoNWhzalZXM2JxemVaU3lRUENIYzdKcWZ5UU9q?=
 =?utf-8?B?WnpzREF4SVZ3NHFxOXB6UTQ0WUN0YnFDN3VGTVJUcXJKZXM1MmZrekw0Vm12?=
 =?utf-8?B?dkNna0hyNTBKMHJHUXIra1NHblJERzJsOUFBQkxKT29XLy9sMDgxN05SaFpo?=
 =?utf-8?B?SXpCdCt2L2pOWTY5dmcrcmVlaEtGRnFWbE1hUk5FUGdkdW9iNFl5bmkzNGFj?=
 =?utf-8?B?dm53MXpzeTdqUUdGVnFHUEVSZXRXU3dTQjF3SGFCYXNSS05ySW5CZjdUUE5F?=
 =?utf-8?B?alV0ekJFK05SQTNMdStERGltV0Q2cmFyWERZcHFHRzNrR3AyOG1ZQUpQMW1G?=
 =?utf-8?B?T3ZBbld4RGdGVFpwQmxtOFAwc3hQblk1Ky90REdIcC9qTWVPbDlNK0IrV0lR?=
 =?utf-8?B?SkU3Umh3U2piZUJxZVMyNUhJeUJOcXhzSDVnN0E5bGtFNGZZbTJ4SkhxYlZW?=
 =?utf-8?B?aGNmMWh6WnY3VFNmNVlRUUJYM2VlTGo2cEtrbzZhdnRjdHJpUTlWUHhRc2tL?=
 =?utf-8?B?bVcyb1oyOUlISW84OGJ5dmF0bzI3ajIrSTFOSFI4cXVDUW44ZG96bnFzSXNx?=
 =?utf-8?B?dlhvN1lNMWdabkhlWENwNGtla2NtNGFFZ0NnbitndW9VT0FkeStGdExYV1Bk?=
 =?utf-8?B?UE1Dd0p5RXE5ZlVRbVZsREpXMWxaSnN4TWpZN1puRE1Hd2RDRVA2SkRqWDc5?=
 =?utf-8?B?YmZDRnY3K0UzWXJSOURCdlBwZ0h0VElUSm16aVdsdk84czJoZTdnVFdMTmFp?=
 =?utf-8?B?YXlLTDFzMi9nZUZwdGpBV1FDU2FyS0pJaFRzRXVrME54bzRpcTRQeU1ROCtM?=
 =?utf-8?B?TVQzaHdoRmh1eWtKNTdHdHJRbVA1eUl2RGlyRlNEdVlQTXBqZE9sQkFjOFo0?=
 =?utf-8?B?dU9FSklsczFkUlAyVXNJSHlTaGpiZVlnNmhrVVBkdWtvSWVsUFZFRno3dlJi?=
 =?utf-8?B?dUVQVjdFMVJnZ3NCdHp6MVQwQ2NGWUtVSjE0Y1ZxUWxZWGZYZGNmbXZMZ0dD?=
 =?utf-8?B?ZXFCOXlLNjJEQVN5c0ZHcW1FK3J6N0Y5cEhLTzdtUGxnbmVPck9ad1E3YmtU?=
 =?utf-8?B?OFNET1FjV05Rd08xU0FIQXEwMDdrS3JNNGx3dmp5dVF3S2hKRjA0RUFyOWdK?=
 =?utf-8?B?VGpLclE3YTRvaExIUkhYcW0rSmhkcG9mZm9xck0wZ0h6TXgyRFIzd2xHeU5V?=
 =?utf-8?B?SEUvb29zc1dZQ3ZwQStUOVJ5NWo0bXZKZVdISE14b1grd256QitMZzdLTzBo?=
 =?utf-8?B?VE5oMDJJalQ4MGJaLzRNdnBvTDR4QmFZc21PdWRDc2s0cVNVTzFpM0hMVWpm?=
 =?utf-8?B?VzVCcTB2TlBFS0srTHU5ejhMYVorVkZEcXpSK21FL251VUw4U2pkUW5QYTJG?=
 =?utf-8?B?bHJEWFdHKzUzQUx6UUlFVk55UUZkQmJYNFNYOVljSGM5Ky8vZWJXd3Y4TSto?=
 =?utf-8?B?UUxDM3l4cmdUTkl6VzR6RzMvMnFaWGx6TzkzWkdDVkJYbFkrL0RZbGdTWitX?=
 =?utf-8?B?ZG1ZVGJNTWNOejZMM3QraHNLYWtOcENpWmV4VUtYTUxuSlRweEVzaWt0TThH?=
 =?utf-8?B?SzE0eFhlN2lDRStBWUVXQnlabFMyVjlZZXhBMldwRktEcDhBVnhUaURsVTNC?=
 =?utf-8?B?NlZNQVpvbm0vRWQzU3J0NEsvU3lYbGVvQTBPSEVUTUdLQndEZWg0WlRiay9m?=
 =?utf-8?B?aVl2d3cxNWlPQVB1MXJySkhkV0xZS056Z0RRWEFUUWlSZmlLQjVPNFBoRklT?=
 =?utf-8?B?RU1qVzN3RGVvVnZMblpLTFk5Ynp2RWQ0dEIwWHR5cVAyV05KWE1XNWZkZ0dS?=
 =?utf-8?B?Q0wybXd1Wlk2L25zMWhMZldQQ1BHQkxzamU3c3prTnUrd3MxOFZvSy9KUlo1?=
 =?utf-8?B?cVUvak56UW03V0g4VHFKNHljS29aVEhwNkVTOTlkT0RMY3UwaFMxNURWb0l2?=
 =?utf-8?B?LzZiamlEVGlsNXBlQnJtMmYrbmw5S3BTdzcvUjFDMEl0a2FNdmZabVJRYmd6?=
 =?utf-8?B?TFgrOHhpU2p4WmNKdXRHcmFBclo2YjRZK3R1VXYrVjFvWThDY2xwaWJqb3Ev?=
 =?utf-8?B?akc1TFk1dnpEQVdaR3o4aFA0VzBEYllOSnk4RFhMc3l3ak9xYTd1RkpFZE9j?=
 =?utf-8?B?RlpiaW0xeHhqSUZXZjB2TFBsWkVUSG8yZCsyVnJRcWlWNmhTLzBHNzZCNGRB?=
 =?utf-8?B?dFpkVVhOZGpodWlVbjRLWFJiYjFVM2ZLeHlISTRscDBQTWlGVVpVVFJaWjZn?=
 =?utf-8?B?cVI5NDBmc0Q4Um1ESCtEakg3VCt4TjZJL3lxTEZHVWp6YzcrRHV4QUR4Zm8r?=
 =?utf-8?Q?OlKW+IPC4g2B8JA5xEDi98kL52dW1gzk+WO7P?=
X-Exchange-RoutingPolicyChecked:
	CASjwIXSsqGnpA7/q32Pkv3D9BXeHRM4dBc/GYXIETRTadUtecKiByY6Z5YhcCeRERKju8BfCnxKG1/qRhivCCwd0L/3URfcFFUscd83io5ZkJEHvO/t6UfsMt6sXaCKexYbo0c96psahPIIQoPE2Lu/UZ3RpsCi5ouX3AozPPlbAlmnFukNwahObCmz5BfsZNeTXY4c8J1OMuvX+vZIsljxADIgeH7LcGGSSR7gE1qQo3/A1feZzL+MPFI4y8iMTTK5F2R6d7/Qfi+AST1BXhhnN4eUsO8KF+FmKqdZ65AHeaVRL5Lui+ZgYpqwJbPDXO10q+2QsIFlEfzjP2KdMA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FLU3BSECgJnbIlUgqofMRoVfSDfuWH5PIbfu3FFMdAmscVpiFOV71DXIWZH7eLLbGmc55fN8MRpWX/enKieB0290Wm0EfGGB7UaGhmpzHOTZG7AxlGM/3B+mQPMBhybpXLyFkFx1UFP4gsGpHApUF3PiGYhmiNjqJ5hq5Zz1KDIPMCiJWmNL1zA2MjWLzxFHQ5Sh8Ncl818dKY8Rp1517wiQEzj79GOx68SU/VNmA3YMjwNS4VOMKMylGfBm01V6T1MNh8n3hQkox9EuIW/AFbHPEySL4NiSAczK2Xa7VjD1SiIFuJBdctI0XOJSb+Vn6M2T2O6mgcKIJX2DusUWGwur6m+eGwj2fnDFI8QYtFx9gHW9nGEkKa82QnzXXsZwGkP07atroP3VUJ583X2SrzyCzCwJR8WIBfEIVOmCRylrK8XuobsWPSFEkrxBncBzNl1v+MuYULW1W4MuR9bx/On9wmEUvkO1o4wwJGUbMACsFEB7g+FAbdRwhHX4jsCnR9gxPLhXs9mMui+TdLKxjN5A73yFAflZZTb6q3pLUQOPMcmR/njEehbu2BEjEOTER5lEkUft7xQL0Ou3h1foA9ysjOPMKzJKIpkVRts/0EU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e82cf3-148f-418f-1019-08def58d2664
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 20:39:31.7313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUv8/UlRIHoFL03kBn267ImZtngmbF1BAQmETxrSfVriYKQ0GbvW4j26FUqx7GkHnHPP42ew4mHUBrt7HaMAdyCOgPwsN2xxnxHQMe/4/TA/b1t+H6RQVuvfcO42Ert5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4655
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-08_07,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608080179
X-Proofpoint-GUID: 6SNCqlysRwT-YeRmk0_FeX8EpN5S2cy0
X-Authority-Analysis: v=2.4 cv=K/sS2SWI c=1 sm=1 tr=0 ts=6a779431 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8
 a=UlE0iww382u4jLCPTdwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 6SNCqlysRwT-YeRmk0_FeX8EpN5S2cy0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA4MDE3OSBTYWx0ZWRfXyXeQgbvS0+K6
 tppMnmgpO+hHigESRBE/ABLhW3R3Sduqm7ilYE5Iia/CFdfkbnHJP2dHTe9UkQtQ0rSXqMBDrRt
 BnPwN/z74K3yFQyoe8lKXPGCLKdO+DW8GOsB6/vk8rSEQXitqgq34vhiYfsLXVWMNI3sOGRzSaI
 /vC53MlPsV/iKZwD101qeh+lV4RpeZc5kbsNF9L3pe1Jqykp7T1MT5t1x3OtQRSz9vT4Q8Tsh1c
 3nzvO+uswa/RzyFiMYoHGPd01M7CQHzi722xRMehXqAmw2YL8kuV/bhypK6WNGkJAsz4yH5UQ/u
 PJtYqdRP0w3btf4blBuRB2ZCVlnhe+spgVz2aZTgUPb9EDFTXWw9HK+hmxpQAbsoTEiiK/UWT1F
 QAP3MsZ8uYPsJPYksVlbd9NFl4Z2tIndi3/cVxQPLedHN1Mk+u1W+i9UVr3aU0xGfT6GAu15rqa
 odeiev6iBqPmKgz4n/g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA4MDE3OSBTYWx0ZWRfX2VsFhaxwd8Y8
 Wr/nIIoIYpMBZTkO1DEPhSfAjtvQ2lPPfF6jIspd3X/Zp2F3S+ZmZElQXG4Bhdf2DyjRxRpwmme
 RkqqYcVmnndrIwfDTONtS3VJ7Q7r0x5DNCEPGtG4uvVLg5SS0w/X

Hi Greg,

On 07/08/26 8:03 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.103 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>


Thanks,
Harshit
