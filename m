Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06958187344
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 09:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725268514; cv=fail; b=W8RZgn6il6/mAZGJavAq/oOCRwN8FcsmlAVmfnoNSVths9IeRts7B7lkCBMYkKp7GuKkQy0HSpXIKxQa1QK47E7x5/gBK/57C1f2Y4yEfeAvJ1Gc3205psSOvXq0EOh7XKNbo8pgevb/OJ62sl7KhGexHl/uRBoHjXSUiWh2U8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725268514; c=relaxed/simple;
	bh=Zuh1xOzDQj7mjwSs6zc85QLKBgQ07QGy4jcF0bOtxJw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H0q9X+Q8YemcCO5pouJHshuxMhQ5lQbajtchYpIeXMmN4ZB3E15mxu8foC8S/b1m2Rhd7W3VXvHvkyjikenXMQLk1vn5uVpVUB0saw16gQB+FA5q/bvz1CgKagB81T/kLENOSC70Gbpg/7z0psO+PbGn6U9bTq9Fpj5dveEP0Kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iLxwCPiN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P5CnceUR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iLxwCPiN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P5CnceUR"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4828I9OW020863;
	Mon, 2 Sep 2024 09:15:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=iYcwojuIorsOHrrcmKhbFY3YMryORG5pRA2ebOaFhSw=; b=
	iLxwCPiNX2BbYbaJPb6QaOUo7ueKb0tKNzoQiR3i8ivqX3Q8r1AXm/nQr9wd0YRc
	16KE45sSqeVHql40WpvheSj94pXtlgC3CDr3zT+8JcrX+W7eNqNnQUOzTnbse7sB
	pZMXd7uHRmeb267U/lsJVSs/6Shs1dW9xpo18/M+ISkyDZ7Pm0poXtzhvNPtONKk
	N4/zuwhOAR7J/fshJPmJv2WuQ5SBse2lRYMIlQ0zxS3Jt6RQY0butvBBNKNpu+Zi
	XmlLGXOsBI3y1teHqlJAXXn+Hp8jj+l/B47ucVTFCjYjOvWuo8KDLTbqkp7Udutg
	fiz2R/rKPiJ281ZpSMKtEA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41d9qu053b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Sep 2024 09:15:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4827Ojro040116;
	Mon, 2 Sep 2024 09:14:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41bsm7ftv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Sep 2024 09:14:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZRCKGP481dbyl7WreGHEspX/v/tW5wWVVtmXRhRzASDkNLHWvc+UnM25qFL3FFuQaLzW3T6uSzTnTUg1w2M024TVdzjv7xr0dRE+LZmCHH9ZxEmbOALdSohYqPyuWhi/te3+qT0fI51W+5YSIWhkhocN2FsuwDL9FZwQVSVWvZi9wc5zcOxou7WRe1pgJvsNPxWEL1iSpJInWSm6mLIqtWxc+Mp0dZTf7R56XrzdFOBF9oAy4S6QEA3YborI/66Np2UQBP41HoSU0K/wHXnPGKHpT/9cw0theKgVjHw9hs0oiKVv9Toy4HkvPRDR+FjEFZw3joxMsF0sAWdsQ5g1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYcwojuIorsOHrrcmKhbFY3YMryORG5pRA2ebOaFhSw=;
 b=vWphTfUzfWm3sQE45dIzglzc0czOZggTF+86GiPEgM8IUvKJKU7Rt82EJNmvaNiUShRQR2Pu2uu0R+7iqGz98WTOPeaAUXBJfplpKioxuMXF8vRdMs++ps5pckCQ5JV5X++ysWsTemmaeBzEHHnqDk/61sly80Edpx2CEdhSg9ZUp56oUFeY3WQ+1A0+IEWHUyh1zyioqBuCuaRNfOWPQ+NqfTOLbVE29pNvuKmm4GPOkpNkrCwkyqQyTGP7tn2+K9iW2nJaBGaOJtmjVWKQXkadJw9WLPFUzGwggrPn0bv4P33xsWqn7khGy4oG54ReCFL0PWC2FKin5FhmjcN0RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYcwojuIorsOHrrcmKhbFY3YMryORG5pRA2ebOaFhSw=;
 b=P5CnceUR6SdQL2eJUAQuSZcH6yQII5HvHOwAkcauxgABGZoTMmgHTWEl0GDsnPPKn4EKhcmFg60eB2PCWT1lK8wrxe+yeqfth0LUg8lT1FCYAF2e17t82asI1m5glfR2lrKeC04tAOqx4r8F4USbEoWNw+jliVPQnSVAVAOZomA=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SJ0PR10MB4413.namprd10.prod.outlook.com (2603:10b6:a03:2d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Mon, 2 Sep
 2024 09:14:57 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 09:14:57 +0000
Message-ID: <98f6ad0c-65d0-4a39-8a11-a55b3dd83b7b@oracle.com>
Date: Mon, 2 Sep 2024 14:44:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/98] 4.19.321-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>
References: <20240901160803.673617007@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:3:17::32) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SJ0PR10MB4413:EE_
X-MS-Office365-Filtering-Correlation-Id: a62a1d49-ba8a-421f-71a5-08dccb2fb695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUF4UnpCdWZ5RUVMTUFKZm1IYTZXL1EvNnFZY1hBbG9uR2loQTlINWN0UHlW?=
 =?utf-8?B?MkZKeVFVMVgrUzNLNnpMbnNoL29OZU5MVzdkNjRYeG41WmY5Y2R3T1czTGVk?=
 =?utf-8?B?bk5YSndXclBDTitoN1dFVmI3cktXN0l5SDVVckd6Y3dxOTd3M29WaGw3Rmlw?=
 =?utf-8?B?U2Zjc3l3SDdxekFhTEticHVnWG1mZzFGaGRBTmkwUXpRd244cExJa3JkTGFz?=
 =?utf-8?B?eThXRkd0bzJMMzNLb2s2WlNSNXpmSjF1MWNNNlJwWWdiK21sUFZEMFYyL0RJ?=
 =?utf-8?B?QjZVcjhLcUUrbjgvK3pOY2NBck10MkJMNjN0QzBnQWg1RytQQ3N2S1hqL2Zh?=
 =?utf-8?B?VXRMQytrK2tpN2FKclo3SnVua2NHR3NMZ3F5VUMzempWMFp4SmJsaHFkRWFE?=
 =?utf-8?B?L1pZZXYxTU53bCsxeS8zMWZZOHhuYzhITnBUQnZtN0JCZGErNXkyUEsvS25y?=
 =?utf-8?B?Ly85Y04wR3htVXBJNU9tRm1SR0IwMDlUMEpaejdzMjh5VGZXazh3eTIwLy9E?=
 =?utf-8?B?ZlV1ZHlBeXZRTkZtbVJMTlJZd1dTMVN5bHFWUWIvM0pES3hjVElEUk51aVNa?=
 =?utf-8?B?c3lQMjI2MkMyeTZKc2lxNjBLK2VWdi91T09qM09ZMjhheUpiTGNNaHZPdDhu?=
 =?utf-8?B?S2xmTDVvZ1VvNHdSa2QyMTBhZXQ5c2g4czZiYkRrd0FDZ0NiYmNQSE1rNVJs?=
 =?utf-8?B?Q2NIMFRxYUxLLzhFS0prMnMwVnJyMjhZYTVwNlErSHAyVHI5TThEOVYzbXJJ?=
 =?utf-8?B?UE8yMlB2SElZSm5SNGVocHJxQitSQm1rVlpETkUxeEVtTWpiSnhEdjBWMnlp?=
 =?utf-8?B?dlh1M3kwSS9TSlAwcEZoWXk1eFNJRTZVYUplb1B4ZXNwZTROMm9DdFJGcXA1?=
 =?utf-8?B?L0pQRDFrM1M3WGUydmVJZmZsYXYxMzhEdEl0dy9jTUNtRFRjOXFKVzh4aTNr?=
 =?utf-8?B?S1luRytKQUQ0Z0t6V05ZOG9sa0hQaitFaWowem1paFdHRllNNkw1ZTdDam92?=
 =?utf-8?B?bExFdW5ZSGd5eXBHNEx4bEZDREZhU0F6UWlrZzkvWUlwbjNoU3MrR2dZbkRY?=
 =?utf-8?B?WEpPOTNReFFWQTYyMUZ0V1Yra0ZsVTMvT2dCOFZPR3BYL2Z2TFlyeGVCcDds?=
 =?utf-8?B?ZEJaMDZpRlkyaERqNVNmVGV0b3M0cDhnTlFwSHd1NnNiZDc2ak9pZGlCUDJu?=
 =?utf-8?B?VVdUbnkvUUx1Smp5ZjB6ZmtQRUl3ZVJYclVQT2JNSS9zL1c4SVY1akhjY1dE?=
 =?utf-8?B?N1BpQ1VYaFlPMWZTSGI4NUdhWkFXbDNvMTJBbjB4VGZkWTJjcDMxRHE4NWU0?=
 =?utf-8?B?cmJYTjZERVpieHp0bCt1ZjBTbXdwcXhLZmdsdTF0bmpyMzM4U09sMG5UZ0ww?=
 =?utf-8?B?VDFqKzBoN295dWhVc3dYVU9FbU1PeHRPUmc1NWw1SzR5VUhqRjJxejVRNkxP?=
 =?utf-8?B?cENoYjJJS1Urc1Z1ckZ6dnk4Mzh1TWwxbnZ5V1hFdkN4eTJnUldSZjVHWjg2?=
 =?utf-8?B?TFFDY2d1NExoVFltNHlFV3R2a3pHZDM4WEpjOGJDT0RGUWZCSWV4ejNFS2JV?=
 =?utf-8?B?UjdXSjg3Q2lUS29uMjBxOEJVcjlGUVlCZHVsOUFDQVl1dUMyZjBtMmtxSkVq?=
 =?utf-8?B?b0l4aWY3eHVCdEdndldNcWJUSFQzdEthdFZjV252MnFlWHZyRVM0Y3NYdlRx?=
 =?utf-8?B?dThpRng0bHUyei8vNFdXSmdxcjRqT2pPbGkyMkJRTzZPZUFYYzhNajBwc3FC?=
 =?utf-8?B?WVNUS1NzZytmYmYvdytxRTdBTGVBQ2kzZjJ1b1ZTa1hqOUF5YkFYV3NGdHpk?=
 =?utf-8?B?VnBJZ0pMRSt4TUdhVDdzQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STY3Q0NjKzBmc2Rsd243UUZiL1c1a1lCb0tpOGtyVGN0bHYzV29LTisyVnls?=
 =?utf-8?B?ZlNhZWQvS2hhTnNWWU9zR0hJdTV6ZU1kcER5MXZhNG83QTgxZGpvSXZPdWJU?=
 =?utf-8?B?aVlMdU4vZS9LMXNVblNHYjhOOHlBRkhzOWJtU3AreVpMWkh4ZGRsZlNSZ0l2?=
 =?utf-8?B?WitURjUzck1OMXIyVDZ1Y01LcTFjNldOUGx2bW5pSlErSG83Z1FMN2dQTkJD?=
 =?utf-8?B?aTFNNUIyMXdtcHBtQ3paZzk2enNKUzNGaThMc3VYMGZKOHY3K3FQV2hyZGRj?=
 =?utf-8?B?dFhZaUtqNUJXTGsrenFuN2xScjJza2FYMUVuUzdkNVNpRWxpbHh6YVFvaERP?=
 =?utf-8?B?ZVJKNnR3SGJLbG1XdU5jQk1NS2JSRVc3V0pnalJCdFVBM2ZRdXdjdFczZG9j?=
 =?utf-8?B?VnZaOGRaRXFKWHZWaVlHOVdQWkFmTVZrbVB2aVd5OUh2SUp5MVhlRTl2MExI?=
 =?utf-8?B?KzJLbzFjQTNtUS9EczZDZXZ3K2QrR0FWRmQwQlVFV0VhVDh6QWFFUGg5ZWs5?=
 =?utf-8?B?b3JlMHhQeXN0ZlEzNHhUbkVEVS93aFIyMHNUSXBITHgwcFFDZnpzQXo3Ymlv?=
 =?utf-8?B?WXFpbXNDYm04b1NzZ0VYZzl4RzVpNnE5VXBSNkUxemE3MjdWakJFdDRuYllz?=
 =?utf-8?B?U2JDSERLZk55L1pwWmREa0xPbm5qSWF2dExBV0dMbW15R3FBcUJhbkVJdDdh?=
 =?utf-8?B?WktwUVdENDBxTWhKdzVOUkdSVEczSDQvQ3FCQTNQME9xQld1Y1VIUGw3Mjl6?=
 =?utf-8?B?Z2dKa0c4R1ZXT0UwT2F1WDJWbUI0SHdrdlBGcmRJVGZvQU5JdVVwb1JBUXFS?=
 =?utf-8?B?eW5NQTFxM3F2VDUrektDSVBZLzRieTMvVHZmRFdjKzc5dmIvb1FQRFcrc2V4?=
 =?utf-8?B?OW9IV1IzSW1LZmRWTUJoRXZ4dzgwNGJSUnc1b05Kc1g1UTdxL210YUsvdHZs?=
 =?utf-8?B?cEt3WjNKazk2Mzh2QnlTNnF3M1I3dnRVMm8rbWJjYndzUjZpUm9qRGY3Tkxo?=
 =?utf-8?B?Yms0SThzaHI4WHU1YVhGSFZTQk5GOEVlWGVZa01YK1JGVXJiMkNML3NoaEdP?=
 =?utf-8?B?NnFwSllVTVp4WFc5RFJHWUN6T0lmQXhIeDh4STFMNktRUHlNNy81TnBVc1ZU?=
 =?utf-8?B?L3M4WVRteEx4OTFuS0NxY1Y2Z0tPMlcvbytaRWpUckxJdHA1V2NVNEh0UEVB?=
 =?utf-8?B?N3ZpTmtnWlhPNzVYZE8zRE4xcS9naHo0a2x4MlcyUUVoZmVLSTB0Q1FrU1h2?=
 =?utf-8?B?SXdwYndVVCtmRkQyU2VPOGVyU3ZUNEgxSVJ5d0c0YW9nNEZvbUxFaHRsdU1C?=
 =?utf-8?B?VXJlWVBOQW5tQ2lRdTNPaWNUMVVmREovSUsrNUQzanVUcDE4S0Nic1Nkbkpl?=
 =?utf-8?B?MEk4eFdKTXoyOGk2Sk1ydTR2TThrTWswRTFyazJhdEdnM21zMDBWaTJpSmRR?=
 =?utf-8?B?Nlo3MXNXZlVKTUU1T05wcjdRNXQxVEJUVVNLVmlRUnpBVU5OM01Sa3h6bEdJ?=
 =?utf-8?B?d0ZTakdOYS9MSXBvZ1RDYnFRcTZKV0dET2RoSGpIV3lydDFHTWdhT0dyQzhx?=
 =?utf-8?B?SDdSSld0SDAxVDhKS1JUeklIU0J0eUU1UnpwRVE4QTZNc21wWXV0MERXNWN6?=
 =?utf-8?B?aGVqbVlxc3NSK3RFSnJqOWhsVVZzejl5TWx1ZklzSHFFZHp4ZU9VallaMjhQ?=
 =?utf-8?B?cS9veUNtZW9MdlRnZUhQOEJDa3RYVjBLWGJjSW1kRzVQSHVWZGRKRlgvWVpJ?=
 =?utf-8?B?L2YzU05YK2NMbVU4WDNtZElpL1d0b2hWMFJZVXZIYVZycHBtTUNqK1BpY3dX?=
 =?utf-8?B?ZXN4ZEticllDY2o2Z0R2VlFNZnJtL2E1bkdkUjJzVWZ5TmRHdmt0UnUrMk9h?=
 =?utf-8?B?ckZGRFhZT3ArcHU0aGd5Qk5FQnpXMHlVZGpCSHlRMWR6b1NlbXkyR1ZhTk1m?=
 =?utf-8?B?U2Q1RlRnejBVbDZ3eHJsSTFpMCt1UndUbUtxSjZuSzBSaUxpUE9ySzVCMXl3?=
 =?utf-8?B?dG44VEU1WXNIc2xzV2Q0VVZEMFZUTTlCRWZRbWs0bHF0NnhHckxKUC9Rdm16?=
 =?utf-8?B?akRhUmppOFU0WDZHUDBUZlhRSk40V3N4S1VGV05keXFhQUl0VEpVVTIrVVJF?=
 =?utf-8?B?aHVMSnZ4b1I1ZW5mckRyMnJTUTJIOW8wS1p2NXhDSktVU2ZIcXZPaitwRllt?=
 =?utf-8?Q?wNaM72lbO2rYXa6cEL4g+3I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ha01WDH2h0kthmHV/Q9VoN7AUbt853XvrFnBkLQdBS4O+IVzaWOpU8lQlBMfPs81czEFmAZMFm8bZTgfz87BEhR7RCyiTR1RtXvWqrjkwZZMjde64nsFOAzCpRTUFH8WDaxYYpMcFDBcXhCCvdWw70dlZCfv7qWIlUL55/nAHUYq7wHOc0utpaCDz/gaHFh/RRW0/TsZcRrgp5pjxU++zLTtJ9cdVJ/lso2wewp7OKiFgTR6ulvAMFNhsslk98TXOdND6Il/o5I9eiUoaZdJfwEDMdSKt7rwZfmosur9GPxCxoa2AKZvtEg9e18gx/dS6IYBIpmMf0hFP7uSgbXw90+MtZaogi03IS/xMfjIiAxasTStyMZwFrunxKl6citCLqthDoriKDItZARy9RkmMyV4P6RiWtopI50ZPv7fqRZwPpAcPJ9mA2L0uNFWLtLUaH//H9f32Zq85ffLAACFmaQCWh8YrEQHgY2vHv6IradUGWYikaK3rwWwgKL2NrxwyCpduibtgyIzCrsFVRurLHt859SDdhLjrvmCGGq2BIYQr404v4PFSFC+PxO/m7LQqr4PYUy5P8/QLe00ptZlwX5xhGN7bWCKOuu/ISvGm5E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a62a1d49-ba8a-421f-71a5-08dccb2fb695
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 09:14:57.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fqRCQLncIKaUiAxRzER2qp/NlcTrfzUaDO7cS56IAcDFGAq2HiJ1oLrLVpuEyQkisSG/YIX77CIP7NMgJORszT0kPMs2AdzP9P+Mvaw3FX42MedAWdnzxiPXjSLjp59
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-09-02_02,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2409020075
X-Proofpoint-GUID: MiC2XkPOf0QO1IC9kG3zTtXTlsMa8EGt
X-Proofpoint-ORIG-GUID: MiC2XkPOf0QO1IC9kG3zTtXTlsMa8EGt

Hi Greg,

On 01/09/24 21:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.321 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.

Build fails on our infrastructure.


BUILDSTDERR: In file included from 
/builddir/build/BUILD/kernel-4.19.321/linux-4.19.321-master.20240901.el7.dev/tools/include/linux/bitmap.h:6,
BUILDSTDERR:                  from 
/builddir/build/BUILD/kernel-4.19.321/linux-4.19.321-master.20240901.el7.dev/tools/perf/util/include/../../util/pmu.h:5,
BUILDSTDERR:                  from arch/x86/util/pmu.c:9:
BUILDSTDERR: 
/builddir/build/BUILD/kernel-4.19.321/linux-4.19.321-master.20240901.el7.dev/tools/include/linux/align.h:6:10: 
fatal error: uapi/linux/const.h: No such file or directory
BUILDSTDERR:  #include <uapi/linux/const.h>
BUILDSTDERR:           ^~~~~~~~~~~~~~~~~~~~
BUILDSTDERR: compilation terminated.


Looked at the commits:

This commit 993a20bf6225c: ("tools: move alignment-related macros to new 
<linux/align.h>") is causing that perf build to fail.

Solution is not to drop this patch as this is probably pulled in to 
support bitmap_size() macros in these commits(which are also part of 
this release):

6fbe5a3920f48 fix bitmap corruption on close_range() with 
CLOSE_RANGE_UNSHARE
ef9ebc42c10f8 bitmap: introduce generic optimized bitmap_size()



Applying the below diff, helps the perf build to pass: I think we should 
fold this into: commit 993a20bf6225c: ("tools: move alignment-related 
macros to new <linux/align.h>")

diff --git a/tools/include/linux/align.h b/tools/include/linux/align.h
index 14e34ace80dda..a27bc1edf6e5c 100644
--- a/tools/include/linux/align.h
+++ b/tools/include/linux/align.h
@@ -3,7 +3,7 @@
  #ifndef _TOOLS_LINUX_ALIGN_H
  #define _TOOLS_LINUX_ALIGN_H

-#include <uapi/linux/const.h>
+#include <linux/const.h>

  #define ALIGN(x, a)            __ALIGN_KERNEL((x), (a))
  #define ALIGN_DOWN(x, a)       __ALIGN_KERNEL((x) - ((a) - 1), (a))

!! But this breaks the build for arm here.
!! Not sure what is the best way to solve this problem.


Thanks,
Harshit

