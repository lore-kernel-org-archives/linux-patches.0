Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF9E3EB10C;
	Fri, 24 Jul 2026 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784905266; cv=fail; b=B1fi3fLZEWEWhPw2QefOeRUq5rprhgwY4iSEixTFZVwq2tSVl2MyTd/g2OTZDBgQNNGeRn1j8Q6bHqhjaAtpRzTFq5/QeaoQXk6LiqIaf6mPSuW2bHoC8q4qt/W5bt9sMC/iVd48lAdywKVe/T0R4JRdjOvs1s0QBcLH4RPWZFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784905266; c=relaxed/simple;
	bh=32PpMRKEVK3ES87kNDQhGBYZRrpK6CFirO0FRQPx4dg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k4h+j8mfw8yMFiCFeyR9LnmbZAPZo6x5QBsaPEI8Mr0Ws7c1w5lEnekeX455t8DruJ3L/OR2TUHATHBaYTlPpDjPB0/C5pIQIXR4nORxvtTQ/U/1W47FidrV0IOtOgGzM646pcU95AESmjNorlQVLegqlR3bt75hF5lJTbr4bzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YqYAib1l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iaMkx1HK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YqYAib1l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iaMkx1HK"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OCtdGe093218;
	Fri, 24 Jul 2026 15:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=klE2ufQpR6neaRFPRh1SHma3hoVni06MwA4OD571l7o=; b=
	YqYAib1lPIanM9/Vm5XhEHfTJo+InrQrhUYXYaea2RzLE+0VbLdzVlYe6MbYGhKW
	vFda3QNRDT3Jkz+uVWmK1Go5nejGY/R3o53RnHNr4+qzT+Kt0mI+H8noSp/ZAhbj
	Q1CcdL0+u1rr5uBN+WPIiX6ijAhqARVLKkmfW/VC3uIneq0YQbcG7rKlUtScx/ux
	wxtzuYWONFch5e8RYsJnG0BM2JvV+5A9MjtS+m9P1ij94SwYD1mH4ElpEwpg4CkS
	sdU19RxaLfb+Zx8xQo/CCdBMuvkhTKGjMIJhZjhKbuKoA9A8la7+nVE8ESCaWaUt
	+7u6DtlF9fauxjfKGcjF5Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n38uw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 15:00:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OEmCdR012951;
	Fri, 24 Jul 2026 15:00:48 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts2ch1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 15:00:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m9+bNCtbZ6POcjFKnQ+Icg4ULHcfoyG3gKrwxL0l55MGN1M2Grzyu+1wviG2rvoq+LNRQUH3gTqbsuzvZHb6Q0b8/96qd3JG35PCoDJYxtxk3c0Q9bHHAVVKM4W9/tPCCDImcIemEKJCT2coJKNuBS2WIbIzOWjCLSf89Bgw43wxdGnZCallsAr8gktHM+RbnzX8J1z3LWITsDLpvD+6+JSEO/irAwKu0mWCc61LdMlokp9JAF8E+Bemsp4D3Sfyss8OiuUukI53GaTV6rv1Y1kiZggQyATs4Hg6pyfVWmDrtz3QEGMj0ssat71zQrCqorzQNrQmSi2b5+yZtKg13w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klE2ufQpR6neaRFPRh1SHma3hoVni06MwA4OD571l7o=;
 b=XHJhnIkjWCLAMUOuWCBzvx9B+vZ2fOIU/5ExGGwj/TlolnvF3n4saGFNMWQXaxKc7z65MlXEDsZ9a7ma4wCnoL5s61SO6UieYUEds888GtgCL6EwM7MEP0+PfisJHBBLYhbntpPysxIO6NaePQwJ69HKTjTox5aNA+qF9WsDR9bIcS9GzCtVQD3HpIqFKr9DKEXacXiuDP8IJWRgPGw5fEssJzQM1dBFJ4Tk7Y6nREGPKqOeJEaGRcpOjM7RRC2HGV4VWV9BFBu6B2QshOgOOTwROrEwnZgnkdH8vbNl9nNAd3JgbM35pUttBfU9ghT4GIcRyh3FO32SZVB7rDr/3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klE2ufQpR6neaRFPRh1SHma3hoVni06MwA4OD571l7o=;
 b=iaMkx1HKVpR8vb9TjArprdFpgFvQTGgZ4pf6N2HIthgIZdeTwXtgSqZ5PLW49/qb4ngOm8ZaifNEoogWpgZPjTffWtMNKy5KXk3O+AvZx8c4xeTmD0DiMj/NoQxiiT7WZii6ab2MMWYT8hGq2tq/4npuQGB4Imna7/t+i5PPfQE=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by IA3PR10MB8562.namprd10.prod.outlook.com (2603:10b6:208:57a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 15:00:39 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 15:00:38 +0000
Message-ID: <ae4d5ec1-9e10-4230-85f7-88b99028ff17@oracle.com>
Date: Fri, 24 Jul 2026 20:30:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1139/1276] iio: pressure: Remove redundant
 pm_runtime_mark_last_busy() calls
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152511.493081649@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152511.493081649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5PR01CA0040.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:264::6) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|IA3PR10MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: 81f52a22-356c-4b75-a8a0-08dee9945291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|5023799004|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vYARdidOM5VkKCXuRq2Bfo73QrivSACQWXScbknlf6Boqga9UayOSU6DlU9k1dnKKtEf8EqwU64+CpNztEzqC61A6vL/oD3C72TLgXxUPMBHmPOJ5R/52kdo7JthFhRk8IBL0i7PpwtcB/beOAfHaTTHlhXnS1gfKKtkxjJxKFFWxFxYCE0hfP3jyJXkz4QSqPVtoD3T5tuIqJaxktqbrQ0/05FECDBNTqwoGzoa61l5tiLHNTnTV0kMjVNepStHDTAABfIwiW12hLl0BkxspVrdwEDb9ewTXfi4C7KbF0n1Xnn+465ln43f2WuHIC4ImHWLTSaC7QRDVKmH6D6RD83JrASWqgcPBtS+BtDiAOVjPbJLGAP7/NrS2Ai8D+Bo3O+V2zKSkKPP/sh2pnup00bxWZHfp7Ua/6/s0zRWZeYmXYrmKKaKCtc0Wq+mjOe6jQ34aUR03LbOFPxV9I/y3vr5hwKocMeR39CcUwZcTgT6VUvQ9WGhudDjzsn0e+y3rkpS4sHfD67CTs0zo6wnrmVU2UwTsUf/661yFd1mNiCo2MlETiTQ9fLaXrEwP5IsCbPIcZ1n5qYcwt1ipJjq+MFqhfbebnMK24hEAcsTxAA63f8obWV8diCdbC2GzT+Q
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(5023799004)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUJucEozSWFURWFhalIwQ3VDOXY1K09wWWd0NGFRU1pHaDZlczAzd2NYS3Ft?=
 =?utf-8?B?RW5Kam1CZHB4TG5jZDdFNHhCNnpxZ0E1UnF1U1FwRTNxU1V4ZjQ1UktVblZB?=
 =?utf-8?B?OENGTGMrOENzNnVyclJUbU45SHZOL1RRZ243OWxObWwxYmE4cHRpbUEydlhw?=
 =?utf-8?B?Y0h4ZnFkdlp3K1FUNVdSZjFXTHZkeEM0ZS8yZTJZdlkxbzRhNlphSlNVM2xD?=
 =?utf-8?B?SVlsc1dNanlONWVNTVUybFBoYjcycjZtOXhZcHR3WGpSL3piVXlSQ0JEVHg0?=
 =?utf-8?B?N2hpeXVFa0xnVTJsLzdYNmY1ZmpkNXp5K2cvczlBem5Hb1VhWENFcEVJVFk0?=
 =?utf-8?B?WllWZnhPNlhOdmxQVStiM2V5WFZuNGNPWGxveXJQVjlkbldEdzFUQk0wNmp6?=
 =?utf-8?B?TVFURU1YS0FrR04yYzJFY25MNXp4WUU5bk1BN04yTU1uMVNhckVtcGRibW1G?=
 =?utf-8?B?NFlpOEVQU1RZNnpzWktTWW5DclBrTzc1L1dDNHlReWpwajZaaUlyanVSVXZ4?=
 =?utf-8?B?MXlXZExuKysrSnBMUFJ2a2VERk1heVpKZ0lyK0ZuTmJKWlYwZXFEckhTSVNl?=
 =?utf-8?B?dGJJd3N3elBwbE02TnhvdDd2WHRWRTdDbjE0NmxDdW1JcWo1QkJvWW40bGU1?=
 =?utf-8?B?SnZvbXloTDlNRXp2Sk01enVQT3N2VGJiTTYrWHhSNzFodmIrWDFBWW1naVlv?=
 =?utf-8?B?TDZoc2dFbGFtMWhkUWpxSGpNVDZXZ2w5TXJ1R3lIQUdJMGhkS0ZrYm5zUTYv?=
 =?utf-8?B?YVpBbklTbnoyV1BUc3NmazJlWHBOdFlCTjBaZUFwSytrNHJwTHZkUFVrNWZF?=
 =?utf-8?B?VGFkWDlCMG5rbWcwSG5KazVOWVFxR0IvcU9LdktjN0lxYkZORW1WSEo0bjhS?=
 =?utf-8?B?Qlgvb211SkQ0UkZhNGRMWEk1dWRzblBBRDlFcXF6RXVWb0cycmgrdW1HcURq?=
 =?utf-8?B?aXNqaEEvcjRCYVpOUHFXd3Q5ajFndGU2Mk9UZEFwQTZTanYrVlB1dkJGb3py?=
 =?utf-8?B?VUZkR3o3SWtSR3Jqbm1zeFNGaU1NMnVkWGUzc2hJcHlzT3dKUWFLcnFmaStl?=
 =?utf-8?B?RWVqRmFqUFBxcUZodUxVWEJodFlXMjBYa2JiNDlRd2dMd0ZuYzZMWWNHbWU3?=
 =?utf-8?B?cUFjS21vdHJrSDB2UnBic1hMZGxWK010QTZjMVFHOE9zZ0g1c3c2TVRaNE1Z?=
 =?utf-8?B?UzFXS3JxQStaTVdsTVpaRUNEWUlRL3NCVm9jQi93TG1WTlhmWHFvdFdxZ2dB?=
 =?utf-8?B?a0JsbGpldVhsRW0yb282SHdnZGx4a2VJSTFwdFVsOGZsZTI3UTF6ejdzazFF?=
 =?utf-8?B?THVGVEpsT21KNVp0YzhOVjVJOU1ndXUwTHMrOGV1bEZEbHN3ZkIzN0VaYi9G?=
 =?utf-8?B?VU1EVDg5U3UvTmVFOFd6eDhhaDBuZzMySjVqS1l5a0NNWlVFSWYzN0JJUlRw?=
 =?utf-8?B?ejd0NFZlS1J2V2dQOFZsN25qNmdYZjRhbjI0RGtROURMMXQ0aWcreW95RFkx?=
 =?utf-8?B?TE9sL3JUa0VwbU4relczSDBrUlFVWVBUbndTdys5a2d5RUdBeVMzZER4R0w4?=
 =?utf-8?B?Qml3UW1FUGF4OFQwcDBJZzRtaEw5STBPeCtUeUNNQXRJYW5WVkJJZ3VPSDEx?=
 =?utf-8?B?TjJTTWdiM3NTck51SkZYMDBDSS9WSjFtVU9EWEk4bTZUaWozd0pUcFlJei9J?=
 =?utf-8?B?TGptWWVBRDJUamVucnRjQURiYjgwT3ZYbXFNYU5kbXlJZWs4UW9hdkpuRXMw?=
 =?utf-8?B?bDdUMWZKeXdxVUl1aEU4K3ZzUW1Rc0duSVAvZG1CdU5JZ2tkcjRsaWl2bDRY?=
 =?utf-8?B?RDZTVTRweVoxSlI5cy9YZUR5MVJyMFlqZ290c21OTUsvMll3dGg5cWpkN08y?=
 =?utf-8?B?L0J6VEJiUGM4R0hoOXhqcHM3WU5lU3hjUWJzaU9ocm9sZFdrZmljTWZ5M1Vt?=
 =?utf-8?B?MDBUVGJqNnk4RWZPcHQwNzJOc1NOZnMrMlBkbHJrUE9kYWp0czQwRGhORnhi?=
 =?utf-8?B?dnpEYTJUMFEyR0ZmNVNZQUVUTG1SdVBrRDc4ZTdPQW5GTnJLbWdQRTl4Yk00?=
 =?utf-8?B?VE9Md0dQZUZZRUlSQTdEREUrcWNnKyt2YlZoWkpBTkdJaFRiVSt2eHZXQ2pZ?=
 =?utf-8?B?czBSRWEvTmE4K2JTcDJGSnF6UURwbU5BcEhGZzdiQ3MzN042cVZibFpFNU9X?=
 =?utf-8?B?bXpSUG00YTFNbW50V0ZOUlhWcWRud0RESzZuaEdWUGhlZWJzMXhOU2lrbE9H?=
 =?utf-8?B?aHNERXFmTzZlZGs2TjJDV2xtc0tyV2xhbVJhNlJjbGJkamJ2TXpPckhlOWk4?=
 =?utf-8?B?NjNtU2Rrc2hhVWhVcE9QdG83MkJ4SWdYdE5vaVAreE5neGZQVjV0ZFZraW1F?=
 =?utf-8?Q?Iy03MUWjNM0BMzZJoCie8QS/gQt7lvh35cWND?=
X-Exchange-RoutingPolicyChecked:
	nYVDKL91EP7tYEd5oPaLTYOKu/3Bdwxd5c05p9K+9tsM1vQN/qcpzYje+9Sf3ZBO3F40aLEeL6k7NVpvK5+xhhtFqz5CNlB18q1JsqncxJxKkanhZfz9E2ggsZIMhlS/W7sqwCp7mIEE0kjRdS1usM7GR3Ai/S5OofKVCgqeWD4D4PHhOqvLtY+7eur4/UapH7oJ5E4DoYwWgWydDE410ciTuQDC3sVzjlo1wp3yOTHvl0E7ykPl0Tv3Kg3cl9QhezxBkhnf6eTDyGJhPynK+XtHyjgIjMY9EEzKQdg/jOwsDj9CeLJZs5YKxm4Ttmc16aCpdJRbwyEtAaBY6B6grA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E36Irvv9MtGXUmIiBaVmcL6UZWm+khj7ldCvNKlCnWSQICdkG0XaSfrldHTB7JBnj17GB0R0FbuuyZUludynMh+DBBJnWzfHLtTFvFP2fgiZlHRzvKYUJuyPHZ/EDwcFqu18CPV7ogrh4yWZ/FUQP5PDFxzuoQHuqIWAJm/vhpA6nNLWkLWWz/1BhboAx+2DzbvSKFHXTtgZ0aQ9uDgbVHjXfzPLi0jDKe88eBrm/DHXStBb9bsSOaJTSflekmWxFZtPRrkuESlnxQn8M/sPjtShgnAPGFpRtuKpdxFQpF8ZKJ/aP0cOKsPqQqMA3I+BOkOPdkl9GiNGMRHOPRQPnNAsbxbwS5rYGYbDW7YZCvuXbv8i3dGkSGy8kw7DzStIuLf2r229aQ290rjH28aVhGWsVNUv5CyAQsQUbgAHGWcTs7ws/rcqXWtuGz6m8x1vXppK97I+MMicjJyGC8zLo2GanycZsHNcCoMXYghvQO54XgwfsBfhcNQR4WmoNo35wBLsXgvwyyoSWQosAzGR7Lsw+veUnEr5dDs0rWT+BsoduB42Dk8WwAR5Aw5VQNVaHB723q5eDE6p1u2GrIegMejVPcekWo5Uxuu+Rl6VOnw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f52a22-356c-4b75-a8a0-08dee9945291
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 15:00:38.5212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PdMElBMcq9USyEFK1LgHK3bRicwrOg3rne1bT3HuZ77TwpNh2UsynKmTQjqz/p+3AjV2dDkq738ExmYAwWQsbDZlShBmoMdrDj+Vc0tO0/2Vz4c1L5aHRRcRRY4GDsy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607240134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEzNSBTYWx0ZWRfX/CuoGtj6u0xf
 MQufZBbYrFRFgGNq1b3tLhvdVb1bYpxpTtksuEA6xz3zvqDUGSn57C2scLxNRvmCnVDewe8Kx6n
 aOYxak/bUpdYbR2EI5b4rCzWqWzfmpVPvopjYUsZdSZHIqqX9wgMNab1wBurBIhT/xm9tZElYqL
 AeaBgkrS0YW7PwQR85kWxe6K91e/XE1g08G7zlsK2t8Mbo35beKQGZH2qyaePybzQ4t8hdx4lKG
 65ATtzZsYxSVYGaxpvyNgVLYeQVaVB5L5MeiSU+qBX+KX115oQcaAwNQsey9KjnXmX/TOgYgvUB
 DUPoeVELJlP0QhUU4w9VHt3YW9QFzo4ksc3cXdCQuEWUMtFRc0fH1MWd/EAo+8PdYWpME6MSHs8
 amdLsSOEHKrbA28P0fn5s+p5cRjUxfbFtN7C+NkY708EFIb0GJUmT7gt4LxZphDh2AtRLXqsA6q
 k9D4KAxf/oHXaNhHH3A==
X-Proofpoint-GUID: BuQ6AO6cbTaJOO4ItQvdYN2LnznKtAWg
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEzNSBTYWx0ZWRfXyPogu4GFNLiW
 XjpU5/Sn6pf18xghWQy1rF7jH5OSnabVkwqc/aWev3GRiQ2J76tyw26skyJCKQHpTw/VytfQGGD
 NePGP6EoZaD9E4GPPjfcLvl6jRTCPGMXkevUZqid7OHJZ/mGZnnH
X-Authority-Analysis: v=2.4 cv=JrfBas4C c=1 sm=1 tr=0 ts=6a637e22 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=bC-a23v3AAAA:8
 a=QyXUC8HyAAAA:8 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8
 a=qs14TrG_rUihYl5Ky7YA:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: BuQ6AO6cbTaJOO4ItQvdYN2LnznKtAWg

Hi Greg/Sasha,

On 21/07/26 8:56 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> [ Upstream commit dfb68a8ebb2e8d9af6e356ae0806bfd8e854ab44 ]
> 
> pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
> pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
> to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
> pm_runtime_mark_last_busy().


I ran an AI-assisted backport review and verified one issue.

The 6.12.y backport e23d3671bc0a ("iio: pressure: Remove redundant
pm_runtime_mark_last_busy() calls") removes ten explicit last-busy 
updates before pm_runtime_put_autosuspend().  However, in this branch 
that helper only calls __pm_runtime_suspend() and does not update 
power.last_busy.

Upstream dfb68a8ebb2e removes those calls only after b3db492e8335
("PM: runtime: Mark last busy stamp in pm_runtime_put_autosuspend()") 
moved the update into pm_runtime_put_autosuspend().

I think 6.12.y misses commit b3db492e8335 ("PM: runtime: Mark last busy
stamp in pm_runtime_put_autosuspend()"), so this backport probably is 
not be complete.

Lets drop this from the queues, I see this is a stable dep of other 
patch, and the missing commit is not a clean cherry-pick, so we could 
deal with backporting that later and along with that we could probably 
include this. Thoughts ?

thanks,
Harshit
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Link: https://patch.msgid.link/20250825135401.1765847-11-sakari.ailus@linux.intel.com
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Stable-dep-of: fbe67ff37a6f ("iio: pressure: mpl115: fix runtime PM leak on read error")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/iio/pressure/bmp280-core.c |    5 -----
>   drivers/iio/pressure/icp10100.c    |    1 -
>   drivers/iio/pressure/mpl115.c      |    2 --
>   drivers/iio/pressure/zpa2326.c     |    2 --
>   4 files changed, 10 deletions(-)
> 
> --- a/drivers/iio/pressure/bmp280-core.c
> +++ b/drivers/iio/pressure/bmp280-core.c
> @@ -747,7 +747,6 @@ static int bmp280_read_raw(struct iio_de
>   
>   	pm_runtime_get_sync(data->dev);
>   	ret = bmp280_read_raw_impl(indio_dev, chan, val, val2, mask);
> -	pm_runtime_mark_last_busy(data->dev);
>   	pm_runtime_put_autosuspend(data->dev);
>   
>   	return ret;
> @@ -922,7 +921,6 @@ static int bmp280_write_raw(struct iio_d
>   
>   	pm_runtime_get_sync(data->dev);
>   	ret = bmp280_write_raw_impl(indio_dev, chan, val, val2, mask);
> -	pm_runtime_mark_last_busy(data->dev);
>   	pm_runtime_put_autosuspend(data->dev);
>   
>   	return ret;
> @@ -1951,7 +1949,6 @@ static int bmp580_nvmem_read(void *priv,
>   
>   	pm_runtime_get_sync(data->dev);
>   	ret = bmp580_nvmem_read_impl(priv, offset, val, bytes);
> -	pm_runtime_mark_last_busy(data->dev);
>   	pm_runtime_put_autosuspend(data->dev);
>   
>   	return ret;
> @@ -2026,7 +2023,6 @@ static int bmp580_nvmem_write(void *priv
>   
>   	pm_runtime_get_sync(data->dev);
>   	ret = bmp580_nvmem_write_impl(priv, offset, val, bytes);
> -	pm_runtime_mark_last_busy(data->dev);
>   	pm_runtime_put_autosuspend(data->dev);
>   
>   	return ret;
> @@ -2634,7 +2630,6 @@ static int bmp280_buffer_postdisable(str
>   {
>   	struct bmp280_data *data = iio_priv(indio_dev);
>   
> -	pm_runtime_mark_last_busy(data->dev);
>   	pm_runtime_put_autosuspend(data->dev);
>   
>   	return 0;
> --- a/drivers/iio/pressure/icp10100.c
> +++ b/drivers/iio/pressure/icp10100.c
> @@ -265,7 +265,6 @@ static int icp10100_get_measures(struct
>   			(be16_to_cpu(measures[1]) >> 8);
>   	*temperature = be16_to_cpu(measures[2]);
>   
> -	pm_runtime_mark_last_busy(&st->client->dev);
>   error_measure:
>   	pm_runtime_put_autosuspend(&st->client->dev);
>   	return ret;
> --- a/drivers/iio/pressure/mpl115.c
> +++ b/drivers/iio/pressure/mpl115.c
> @@ -108,7 +108,6 @@ static int mpl115_read_raw(struct iio_de
>   		ret = mpl115_comp_pressure(data, val, val2);
>   		if (ret < 0)
>   			return ret;
> -		pm_runtime_mark_last_busy(data->dev);
>   		pm_runtime_put_autosuspend(data->dev);
>   
>   		return IIO_VAL_INT_PLUS_MICRO;
> @@ -118,7 +117,6 @@ static int mpl115_read_raw(struct iio_de
>   		ret = mpl115_read_temp(data);
>   		if (ret < 0)
>   			return ret;
> -		pm_runtime_mark_last_busy(data->dev);
>   		pm_runtime_put_autosuspend(data->dev);
>   		*val = ret >> 6;
>   
> --- a/drivers/iio/pressure/zpa2326.c
> +++ b/drivers/iio/pressure/zpa2326.c
> @@ -699,7 +699,6 @@ static void zpa2326_suspend(struct iio_d
>   
>   	zpa2326_sleep(indio_dev);
>   
> -	pm_runtime_mark_last_busy(parent);
>   	pm_runtime_put_autosuspend(parent);
>   }
>   
> @@ -710,7 +709,6 @@ static void zpa2326_init_runtime(struct
>   	pm_runtime_enable(parent);
>   	pm_runtime_set_autosuspend_delay(parent, 1000);
>   	pm_runtime_use_autosuspend(parent);
> -	pm_runtime_mark_last_busy(parent);
>   	pm_runtime_put_autosuspend(parent);
>   }
>   
> 
> 
> 

