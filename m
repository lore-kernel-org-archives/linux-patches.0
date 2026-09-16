Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2113FBEA5
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 20:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789590956; cv=fail; b=TJhIeZet846hIrxW8iNTONfYvP8R06gY5K4DrLh/OHUfhyuvd09rhnr1tlP5QrTjgxXjYe7FzTirZ9+J9rzlNiTWAWyOe6S6ZmLZAW4JQTM+msbbB8WHKZP+GXnWGQ0idyRyCK783YNinbAnHytmx2NFUT1vqwe+VUFoqLFGHbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789590956; c=relaxed/simple;
	bh=ps5oS4etVuOaf6WYtG6tVAxbDO3CTZ0ZHJdQ8zjPF/o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iHJl5ktzGOdlZddb8TzkvRlBsjhhvtPR+DvD+RF95lEvqyW+Y3Vw+45zpuhf2uiLGYIx05JYWRbq2OqUYDsAd7btH51K57SYoFPBQBoMD2xR4QpRn+74Xe4XVtuwwohvatCA7+6pLGixVYryZKwlJrRYVCD4xM8Dm0m+QqDcTnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gnN7fwnS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PMVA60pd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gnN7fwnS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PMVA60pd"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEBf9A2380008;
	Wed, 16 Sep 2026 20:35:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ps5oS4etVuOaf6WYtG6tVAxbDO3CTZ0ZHJdQ8zjPF/o=; b=
	gnN7fwnShZQEaojdzHb6JAdGrYl7GPWFGKcsvrpB3bItwtCyVs41PwgL1XT1R3EP
	GEByjJgpS8DdImAzYRABwi+h5isVT//79ILNxslQiA42mFT3fWaJH6wowy34exFx
	UarMtOuyyO80PxMujHooyLgRq8HeoOn7/S+i0jsR5bDBNJC9C6rSFekU7Tnigi5p
	G5j9Np9bT4La2+gDL9SvudYBDD3wd8Rut7yghc4eyEJwQPK13kgf9SDIzsSL7Bj/
	PiG/lNxg+8cbQ87fREdXPyYPgrozxtxaAdi9NBc7WN/AOxl0BdlSuxkc2uADEFOL
	kv2RJkZ9wdPgdQ4ZAcrGbg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7edb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 20:35:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68GKYpOq039603;
	Wed, 16 Sep 2026 20:35:39 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012014.outbound.protection.outlook.com [52.101.43.14])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6e1xwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 20:35:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Or84ozo0pPo2jUvWQgiTVFWmUrbwarDGHV3RNy6rH708Mi5FTkEQ6ezSwIcTSlDDm5IRqtZEHDoW+tvjcXYH9KbKjHKjk16rTroNEwPeEWmH5J9Ie1tp4jmpXY/EZ2Pb3wdDm0OTuGHGFb5cytuKe9ZdFuYt4VtqKRNgCtylo1qfeTbthK2BBe4LRU/ODKN4+I9huiePfko0zcfcfa7I2zWKcxZOfahCVRnRIuIroaWFgUH4fKm7tz6CTUOFg5keeV19fq7An3h/w2W/5zm3zzMsJgkAnmEM3NO0drEGBYffDTCGA1f9ChFSeoWtYLnH1uVKhmuoQZbbrZhXWYtkQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ps5oS4etVuOaf6WYtG6tVAxbDO3CTZ0ZHJdQ8zjPF/o=;
 b=Q9nq6G5cbFrTWmt9GPtZ/ICnOW7nTLTT/NyK93zwcMREOcnK4GxTeF9n3lcCWNZyS0Phpk/cdij5BQ+B7sVmeoRakcOt4pNzDdgCTY6AKsbBa3lIuIgBa//cvjpkaXClgzsOQKpyhxINuCoINaC2KSOTluAot+vxytkKpYwhreAQOoQ8O2GckYD46MtfVFEinW6MKf+nCH2F9ZxBWY0xFV6TACzJuzo1nbIjnB7PrqoFeDoqcLc6UrcTJTw8+U9/8KR5biRn2F4AV/huPZB98BnWW8WMqGhxsM1Zmsf3mfyrSx6FxTqKTdB8W2nscqhsCRfPiHHGNxLHiNfU4CwC6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ps5oS4etVuOaf6WYtG6tVAxbDO3CTZ0ZHJdQ8zjPF/o=;
 b=PMVA60pdnZMp9WFFBtgUvzyLtNT4lXXGwo/v5aiUKpsl6wwmvZ71HWh5a4Loz9mV35auREAmMx/sUe4AGoncGJq5aVftBaHQtdiDhXvFRY9EFIByag+d5IvkiD05H8eUSWt5gDG81UOCA44vE2BeyrJBGLbtPDCaBub2aWWeUUs=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA3PR10MB8707.namprd10.prod.outlook.com (2603:10b6:208:571::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 20:35:33 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 20:35:30 +0000
Message-ID: <21de6e6c-1e05-4ab4-8bb3-ab968a2728a2@oracle.com>
Date: Thu, 17 Sep 2026 02:05:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1096/1376] selftests: harness: Mark test fixture
 objects __maybe_unused
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Alex Williamson <alex@shazbot.org>,
        David Matlack <dmatlack@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <9a88dda4-16e8-4205-8f28-428f2da245d1@oracle.com>
 <daily-reply-20260916-0010-re-selftests-harness-maybe-unused@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <daily-reply-20260916-0010-re-selftests-harness-maybe-unused@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0033.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::8) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA3PR10MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: 157c9689-d022-4b30-0b6b-08df14320c69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|10067099003|4143699003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	rnSAecgpiThuVRdM8P/Z5+eilLgvBOTzq+yMLMcz28aipzTSinBkhrcHex+yNShJAnCnXl48uH+RNbeHC2BSTuwF351N5n8riijL4uLGclYht3NpaXCB+t9aJ+oydq3JuYOEYK48G50jFKPmLw4E+cQjFb+btFFIndX5r+nyJzm1IXhJJJ2ecjJt7gx9gGuYc0vPJoWOB1HPoGlatLOTwPumom6IlAVwzK/9mjHFGTp1yqShrP6qoj6NDRuIe3v0TcgNKRZyZzjj5FNxWx9Vd4aEYu88VAxgocpmVmRJpxb0tpSCAfFEKn+oOdvLY+AH7h+uMpTn4o76jDDzi52eIessHLGW1o9iNH3VeZrvMhOG0BZHear07PwTN7f6swmI0CLCgO51aa7RbV8rBTnVcU4mIPIKYMFiECR5DUrmgrG7xwYbW8oJzlrghHg06tsnMS23B9WGZz76KBs3H6oUGkoHFj7w9SsmswqxcGqDWeq8RGiuHL+iAL8HK37pVXst9NoXnErppKNGValVSn11UJqMATn8PicXUSYnfEN8a/0ds4KHuon7se7joymtagFoMhTYn2l8nNus/HCjzlo+pYcqbldNMDjOBRnuzU/vAeDJoFSEg7dxzmjOlrfpdy0zhYLtIs6895IVAJ8FC8HdJj1V2ilpoBvcyvzB+iEDhO4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(10067099003)(4143699003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGtRUldzSlRFOGdHY3JFSDJLZWJDV3pGK082eXBLTll4QzR1cTJiTVZWdFg0?=
 =?utf-8?B?eUpPSzdEMHN2ZnZEeTcxYjFsYnFiVWNuUlFEWDRkWmFNaXpDeklaUVZsbnVE?=
 =?utf-8?B?dG5MVTVPc01XOFRMVTlvc3l2dC9tZ3VoQzdGNys0OW91U0dSaEJzWUk4OGpF?=
 =?utf-8?B?aE51Mk9OWmdiTTNTMTVLNjdwcDd0RXlLd3R6WkpCdHgyUGF3WU9HY1FnaEZZ?=
 =?utf-8?B?V3FjK0xkZkxRZXpMWnBzSDBuTjdSSDFVUjRmUXcxVytXUmxLanhML0NJU01X?=
 =?utf-8?B?U2tYQ2JTL2Z1QUdMV05jTUpHb3ExT2ZOTEd2Q1BVZkNoTzJOZ3ZWd1U3WGd0?=
 =?utf-8?B?eFpYKzJXWkNSQ3ZHMmoxdjdyZWZ2ZTdJb3d0YWZnSlI1NDdiZU15eEl1T0hS?=
 =?utf-8?B?MnEwU0hkNHlqVTdtN0dwNGh6S2ZDNHI3aWNuY3BpU25iSll5QmJ0elh4cHYv?=
 =?utf-8?B?ZHJxK1NFVldrVnlLNTFTWkJRVEhPSVRSRE1BRjRER1hOcWVST3lFVjliT0xo?=
 =?utf-8?B?R29oQ3dLVms4UUptZzg3MjFDNDRyN2hiV1VLT3FzYTgvajMwdCtHalZ1RmVr?=
 =?utf-8?B?YjdSNVNUQjFneGFqckNzTUE2R3Z3TUlvMHpZL1RTaEQwV3cwcWgveHpqb24x?=
 =?utf-8?B?N1VkT2s2cTV6cWE2eS96SDRDd0FoNUgwWTBaN29LQjhCNVdiK3Q3T2NHZzEr?=
 =?utf-8?B?Yjgvb0p2dmNSMytXWkhZRGdMcUErVGxOb29Ob2I5SjNvY2ZETHZTUUczb09H?=
 =?utf-8?B?dGFGRW5uMEI1Rk8zek5PZ2pnOUJqb0pPZW43a0dZMitSSXlDMy9ib0xra2JX?=
 =?utf-8?B?a2MrbHVSSytvTTBvWFp6OGFsZXZQKzYwNG1ZdFZMaEh3d0phR2lQR1pucHl6?=
 =?utf-8?B?V01PTHlSUy9jUk9RSm5YSHRhanVjOFR2amVIa2FZdld6S0MvRVdqd2VnbkIx?=
 =?utf-8?B?cnY5M002NEJOVEMyOVRvQ0xScnFlTjdhYUxsTEQrQnpJeUI5N21MZmV0MmZw?=
 =?utf-8?B?eklmdW53dVk3U2lRYmVDNllqSmlMY3k5dmRuR0Jnd0lxMFNaMTNuc2N6N0lS?=
 =?utf-8?B?bENwUEVZWlNobDJ3dGdCMDI4WFdlcndQYnc1aWgvM0NBRENhckRCVytYY3lW?=
 =?utf-8?B?dURraElzZlViekhIM25rWnF4cEYrdFduSzdReWVLSmJYVDlLaWh1WXFHbVAv?=
 =?utf-8?B?TXlNdXRJUTVGSmh0ZmNrdE1hMVJocmt6dDVOTW9HVzhMRUdRSmZMM2d0dFNk?=
 =?utf-8?B?R1VUZ1ZEdjkzbE4wZy8wWkJzNUxEckNXKzh2ZE9uNEhmdzhpUTYzRDhNMkw0?=
 =?utf-8?B?UjhxY01uQm9kT0crU2xzWG9iTHd4b2RadTRWbGNHR2VkNkc4Nkw4VVZTWVM0?=
 =?utf-8?B?WVlBbjExNEpVR2xTb0lvY00vZVZxL0RQc2l4QlpWcW9nanNLc2NGYWh3V1N4?=
 =?utf-8?B?VWZkVHduN0ZQb01xUHNWdGx3R2lMeHJqTWNMZll5ei81M2RYYUphNXBZWGhv?=
 =?utf-8?B?eitUYTRCdnJFZjV1UXN2TnVCUU1DbmtyWW1OcGN1MzNMMVFCbHRzSCtXTFZq?=
 =?utf-8?B?VVkvcGlLekxOT1lFSFhUY0d1eHcwMFJkNFhxLzhQV09OcDFuZ29PSmpuM2Ju?=
 =?utf-8?B?V2RCTjZVQ0tuemhtVmJraDlmTGpiT2VqckdiTDl0WHlyZjZzdmxwdW1VTzA2?=
 =?utf-8?B?blN2MXVZSlhEYXRManlHTzlZWTVDcjIxeEZBTkV2NWNrUWdoaDZxWDNmbDcw?=
 =?utf-8?B?UkZla3V5aW5OY1Nnc25MS1hRSDJCOXVwVzJxcExjWlpJSHZ6K0Y2NVM3cjdh?=
 =?utf-8?B?ckROSXpERXA2R1huZldBNGtsTFhCSmNzSEZ4d01RWWtnMXNjWVI3Ylk5aWtj?=
 =?utf-8?B?VzNkbmZNMS8xVHdadTRoV3JIV283L0xXaC93eEM4SzJPZ2FZM0x2MFdLMjFw?=
 =?utf-8?B?ZVlYMzVGVForOGRDMFdtUkw4RnRKT1BtQXJULzYySUZ5V2MvNm1zYXdaekNy?=
 =?utf-8?B?M2xjTXpHb0Y4NWxjYVZBWDBvU1V5TURPaHNpN0FqdkMwKzJWbTJSZ2pRdVN2?=
 =?utf-8?B?UWpIekJYZDhxeGNsQ29HVDN0ZWxkVkNwYWE0ME9jZ1NkSzF2TXBrNFdFWTk3?=
 =?utf-8?B?eTdjTUJmRGFrQlFEZXZQSjFHRHExL2NaaS8wZG1xQ3o5bEdtRVFFeUVucFkx?=
 =?utf-8?B?dDlwMzF6MlhjSW1iMGYyQkt6czRjMnU1bFd6ei9CditzVU40dEVxdnRWdUp6?=
 =?utf-8?B?aCtiZDBPRThDcGhzZHV6bnJBeEExVk5ZRkxRZ1d1TXIrL0FrazEwRXlCNEdQ?=
 =?utf-8?B?c2JkcUEzOWpBdjBsT0pvZE5PbTlKbHBnSk9lOUw5U0laRmhoZHB4bFN6L0Nw?=
 =?utf-8?Q?dnUTRhlXpa7oE1F1qtW26iOztrOqzvf1y8MCP?=
X-Exchange-RoutingPolicyChecked:
	YZDZYcC+jcBVaNvnMM3ounXXFAvahkFx3zYBwU7snOuJhV32G0Rmva4DWBXh9EuqkY3fxSG0hFPO1H6o7QgOGklLYIM7dnhtmjJ7/MFxqthhZ81N901V23wTH2xwnJ1MUHY26XPe/d+SGE2Mfbkq15waOzG0xVADkFNaXZdnSdy3WSi0f0Fij0R+Cyb1D9p+nLT4BceTm3TsiKOVnXgRKD+KbwvWWSOMhZlMtcHhAJMwIOxkfi0OZp9H4fUdgiAL8QSyLq3W/+Fln33Hdje50V7meSXuTsC1XVF3Z9/tHPjhCAaiwl17yZP9uS2GjUTQmlmJq3Dk0dRUSIvz17oJ+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r7ijwaG+B0BMuTwduS14HqKlh2kRKiu5U2DotvPnUWTSztkYpkirX83bQ6X/UuDap9zY7W7umNUJ7gD/Wu3lDvcfu929M3Nkl8WDyl0//BJiuEMzG+rIq1/1PHcWm7rmlKjcQmtLrEcIlZnjsAmT+XFufK12hkoHZ8g0sE+5I/xviEWD5g4ZPdep0hF+LctBUQjKYronJ6G1MiikGKjL/Q2hNCrAeKOPpYu3MHo9bDrZvIzBz2cosROUPF1UUjL19GrzAumwPbVbyxNSL7qMUsMxZtn4jwxiW8u/Ghzsx/tu0ed3V9ZcQu+7F7049JRa2/xcPs5sUKxTPsJ78ePAFQe72yaIRzX1blEinraV3AXfx1oh9ZA0NAOpK3VL7Wd1bOxcQfg3uVFUn4btkc1L0Cba4a7l0k/dKuxZgac1Ute+161L0MHquxdNNjFwFnfE4MREzjj9qfHMCfUZG0x/cdCWhR8BVb/z8eE2ZO5w8X09lnOrih9yy5bGet05hwbn6U+26qpNbtenYpWbOyyBF2+mVlQ3FrqfXHKQpDdJtpW4WkVhucNL9Uf9AmoHWDm1zqavQqHuRMMpCrJcY8ds5P780jNw/eO6sVvjeM5pSjs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157c9689-d022-4b30-0b6b-08df14320c69
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 20:35:30.2031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyt0d6yDCxwuWEIqS9PnufBOGcojy/MDVJJCGqVWpv6d1EX43mLIYWoFA13UwgUkuyeodK0ihNE27oPMgK+k+KUu+m2J5iBnYJwy+0Lltv6dcpYMf4rw35ez5HFiRooR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=714 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160286
X-Proofpoint-GUID: VLwgOM0sbwOD2eOfh7R-e-ajbOcndYsT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI4NSBTYWx0ZWRfX7kunWXiLmi+2
 WSyGhBmb3TJ5oSAp64DI+EOdz5OpV2swDKfAWOGGDRmtCwWK5JCWmhj2UMjEnzx1/OUyNiCC0sO
 zpIH1X4zcSrlo44MRP/80s0fdXele3Qj5Uz/G9yZCvv1hG106eQuk8vTYSImWAGAp6nlkZ99kZo
 NYTt5Lx0RVhvzyytN6rN8n0hvcBOa03QhsJ/iq6p7Jn9TsHCMOApp3Lu2mNrFQBfT53pR0T5dt4
 QrJXYx9nFVXcNsf77ny84oCOK2Cv3fb1w39UB66bwsbF2HSaMFafVWEz8oAVUanumeVLQx4Ih1C
 i0WKejA6IdBwJr4o3BUbFfm8XyhIzvTRysvSSd9MTHtZpBDKorjipGb0w1x9SsxBpgchamt1FuA
 zxmMqgPGuySfL93x1mpWhB+6tNySWNFsS0au6QUR5LqD5s+mq9sjIEREArqwWsUQzaHbaFUR8Q/
 qqkln2XCRoNWSZNQ6qg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI4NSBTYWx0ZWRfX/3jOF5ziDOaw
 n/roC3ARA/IKTPsbG3ELKw1L3Pl2/kKgi87OWdzke5PHXmX2mfXiIpuc0VUZTOqIdqnUEj0FLLX
 D63owI+l2Lhy6U5nHmDVguRKLY0uFX/9rookM4Ple2bvJqMrEmKi
X-Proofpoint-ORIG-GUID: VLwgOM0sbwOD2eOfh7R-e-ajbOcndYsT
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aaafd9c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=T13ga1Lquqf7n6KsKOkA:9
 a=QEXdDO2ut3YA:10

Hi Sasha,

On 17/09/26 12:58 am, Sasha Levin wrote:
> 37ffa24c9d07 ("selftests: harness: Mark test fixture objects __maybe_unused")
> is a cosmetic cleanup with no Fixes: tag and no Cc: stable, so rather than
> pull a second selftests header commit in behind it, I reverted it on 6.12.

Agreed, best thing!

thanks,
Harshit
