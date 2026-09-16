Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498C53624AB;
	Wed, 16 Sep 2026 08:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546015; cv=fail; b=Nl2uH2Zsnj1A0DJbKP6H543BWgt2gdBrsQ68N3FqbBgLFt2RtEBId0CGdqgAQA9OfEmkKGOE8v6X74aoY5wfI4Mc0hUyBH1WADpGZQTpl2vAef+IKu2zNCRXksBb21zeBt8Yi6zKYPcg6mqIo2BWrh9RUcf+dqzw4U992lnrSS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546015; c=relaxed/simple;
	bh=+sLxhz5h3ABU8Ezj2edgMUTiQVmYqUooJgJbpJ8d38Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oIYz+29e8ivVMsY9S2Ct305qntn+Elm97TAhsRLBIKArldJ0rWKcuVOpC5XSllphaYVMFWiCXdFHNSakLGFTMOv/E4U33sBd3DcrvpIvT/7RGDiAORyhtcC8scA2g9tI89GtRikQl/myooMv8owXm30NOAjC4OR1n5VsZCzWmp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hesggyjg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bxXhFvYi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hesggyjg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bxXhFvYi"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLX0hY698985;
	Wed, 16 Sep 2026 08:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wORI4vjXnb1v1AabvCAIV85evoaPEUXT8QcD/+Dl2tc=; b=
	hesggyjgyGgMEanumjTjVgxebWbCCgcHI2C7qDn5sV1SJaoa4MNYcMLh+HtMbEtj
	kk4JgUWtSr+ra0XWNiMAYakMZLC1pSuFHiu/tTZoSZknqP/boC8AQmtS+nw7m8ID
	wtfQAlF6/cBGXJq8ev/lb1HAF8MwG9ZWCt42Bqpvsz3IDiEQZU+CzOErtJyColSO
	pQhcUYlbW32wmgbNg1xLBf6wRW/1S9gfcFREOpRq2O105UTPh0eDnovnhH1qXuqj
	qBzSJWpDjNW56hlKS7I7gnyW8Mn1KOEW0WB0FtVDgKoQvHMKfhulQbzMq3f6i2sr
	Ru1mtmtPHtvBw/bOu3sCQg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7d4hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:06:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G84oAx033817;
	Wed, 16 Sep 2026 08:06:06 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013025.outbound.protection.outlook.com [40.107.201.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6d2hmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:06:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELdXTMJBNlCQYDCjLIIvqeXxPW3B2yBHB8miIaHg2kjFe8o9L5PUYwQO8V7wjvGHGb/Fu0HIs574c7MRaQgFBBELcDYUVOvaBn8OaLbxb422pD3EXtVHuAm1hm4cNsdUAxNBEg76PoU3WZDL28pTZkgt+DdN1LKKoNzjVe5kvBviJ9jf5cZ5P8wsJFqT1kA7UuLGOJBzqyWMJ3JHfNJbhFMjPy6uCWccZ32vF6KoIpy+RmPXlGWmF1n4Yxhpat09CK2dc3M909AjzM3RCePuxk5Nl83LTDENXyMHdcBs9UVQz4Bx839tOPs4zVvaUpDwb80VptOuP6j46+YTJEMONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wORI4vjXnb1v1AabvCAIV85evoaPEUXT8QcD/+Dl2tc=;
 b=MUWb2WOswi0HvKovwT2BpPGehXokeBZlP/vBc0gaKq7We1NMsIQXREfQfWjXsvBQhMPQTnxHo11RvyHRmhT6zCE3mFJMu/IGpqIA7YPs7HsNllqVmYYRJLggVYrFuw/KfmTZW+of3nLsCUdjxvxiXf7ZIVa4zr7POCyUVs4/X3WzR5oA8aJWxU4hTKM1bw1hitbJQGXVKsspcGKdOuaXE58+NFC+THFj0sBa8YflOAWCQX7wBhVymY3PoHToSlQGKR4juaPi+pbywpll6Jb2ur08shBp40ifGIzAHUG2woDnuBoWlhuKHcwrUgNFQywhgurhG8pQAz8jGGVL40l0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wORI4vjXnb1v1AabvCAIV85evoaPEUXT8QcD/+Dl2tc=;
 b=bxXhFvYizOuEOBosRmGC3KCewzVS9zuaP7R0pm7N1PtcyAxyNmj0j0vDrd90mwA9qVNAN8laU7zehjWUa3Hl59nOW20R8PfUKtKjdMJyOqemU3B4QOeVdAwJu0Ngoej5Xibj+e3jY3744Y5AaWe9Hb2hsVcmioWIVn6lFbcmiSQ=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH3PR10MB7260.namprd10.prod.outlook.com (2603:10b6:610:12e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 08:06:02 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:06:01 +0000
Message-ID: <2f32382d-2f25-4acb-9126-ffbd14400486@oracle.com>
Date: Wed, 16 Sep 2026 13:35:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0909/1376] ARM: 9485/1: mm: acquire mmap write lock
 around show_pte() for user faults
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Linus Walleij <linusw@kernel.org>, Qi Xi <xiqi2@huawei.com>,
        Xie Yuanbin <xieyuanbin1@huawei.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065627.826818350@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065627.826818350@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3PR09CA0021.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::26) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH3PR10MB7260:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d3ae672-76a3-4722-7b74-08df13c95908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|6133799003|10067099003|5023799004|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vKqMBuRcbCniymn3dHS9hJEe+SlvxfYulZN6zkauKsIsTGICQYX1IaFfIpsN4ksrom3iYr46aL9A+COoOM8wBrnR17cK6NeKd2FWdXta9x1qGaV6Vn3b1Rp6OVQ4k/haOhdKJaveAgevVkMiDXEEPxFs9ar14Rvc26gxQX0+kEPTv9/w1lKJhRx0sOxZxV0A08mWoQMyhQ43fJHsWMzQIlV8K+euSHpqlrRVvl19CCB/eKrsGl8p0lbRpfmFBvpzBjMGh6gKdSdrX4LAZ/4AKMC47He9pp90YeeR5P7mpVdwSRnOpGBluHz/871vi7N+KL0GkhuGRuylMVnFnDM1c4zqvq8L/LqEWwcdEi/0IKcHo5szh1KDTVoBl+CCrBZJyikGO8Zu8x27bRvwGdXdgl60y2KGme0sZiHjlZzlUH9im6WFDINcaJiMZVzQjGdpEXqG6D5yngQGl9ByQW2YZNa9fYK50oJwJqJXfmZctPWaQQUhD79+ewsOoofgMI3ZKDFz8eXcxMKq+XFvABJi3tVpil9KQ05zVh3hG0Q6qku5eylGuotd6F0ruJZv+jyUk/sq0GISncaHBLARzAVJUv4NAqNIEkMkUI7ZiwyE3/o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(6133799003)(10067099003)(5023799004)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUtZS0tnU2R3U1UyZjVMallCeDJ6Q1VRV1pzYmFPYWlISnp2OUhRcTNSbThl?=
 =?utf-8?B?blk0YWpMb3VsWDc2N0M4SVdBdG5NcGJCN3U1NldVaEtkWTJ0UTBMN2xRMit1?=
 =?utf-8?B?b1N3YzRnWVUwaGdBWVJ4bDlOUmQ3Q1ZVZS9CNmtHOXUzc2gwWkZ6T041MXYx?=
 =?utf-8?B?NG8zVVBGbUFLOWlrVWkyK3dNUFRrWlduK2x1ZFdPRkxUQTNqa2VRNDNMR3RZ?=
 =?utf-8?B?WmlTMW54bHFsZWhVZTNmWlNPME9vdnF3c0NIbWV2ZUxIbExuOER1WURWOVFa?=
 =?utf-8?B?bnA4TUR5dmh5NjZlOTM3cXU0eTljWVAyZHJyaUNBa3NWa2o1aUtRUWhST1hO?=
 =?utf-8?B?NXgzVURibkxxYWVWSVFoMzY3czhHS2lrTUx3RVUvNE5YVW9jUEtYUzNUazk5?=
 =?utf-8?B?S1NYZmZmSGZDbzhjMnI2cmhhTXROditjbXJBWlRsZ1Rqa3BoZFFRRzRpeGpF?=
 =?utf-8?B?V2NqcWRnbVZqVVZsSDZyTkU3eU1WSzIrTW93b090ZjhrUzgrNitOQ2kxOTYv?=
 =?utf-8?B?U0RGTUJKMXorS3Q5YlVaY2xrclY3MVY1YTR3aGNFLzdhQzlXYVdnN3UzWVhM?=
 =?utf-8?B?UEFpZjgwZTdjMm9iemZYVkdjaXFIUjdoa2JPNU5TZm9NQ2h0VVZHMC9nWnRo?=
 =?utf-8?B?Ly9RS0tpVEhaSkxKeDVHQzBKcG5idlRrWmgvT1h5L3E3aitNM3FUVTdJR3J4?=
 =?utf-8?B?RUMzOG1ScWVPTjZQUnpZbGhEaWV1dStJd2hFMTI2bmJnSHF4cVl2K3A0UC9W?=
 =?utf-8?B?SmVLcnF3MFJrdzFnRmRldTZHWnZyTW9WaHNCZEtRN0tPNkV0T2FmblFRNFl6?=
 =?utf-8?B?R1lqVVpUOW9lNlU5dnhnNzVOU1FaZ1lRWjc1d1VsajVRdVlxNS91c0cvNDE5?=
 =?utf-8?B?TDRCSnhZWE1QdFJRWENiVTBscmR2TnV6b28yMmJNU29NckNjV2YrL1YreU5r?=
 =?utf-8?B?YllTU0RYSjlYc05oKzY2RFgwcWNURG5EY3VtM1IrQWhvbHFBK0plZnljN09P?=
 =?utf-8?B?b1dkZFBqclhWeks1VnlwMHJjQlQ1czZaS1BHUmU5aGxDeHhnTUs5VTlTOUpU?=
 =?utf-8?B?bjlpc1dnQ1dZQUNCSmRvT01pVnovR255bkg0a29UWEVQZHg5bi9PNS9UdUVs?=
 =?utf-8?B?THFOQm5yeU9SejZZSG00dzlRR0pha21XVXBqZCtDUDhPYnZwZFQzaFpEeE5G?=
 =?utf-8?B?d2pwMFpCOWdSZnVHWnQ1Qm03Y3FlWGFEaHVXSGNxY3lvV29TSE40K1ZtVENI?=
 =?utf-8?B?VHVtcUNhT1czNmlsVVpPRWVPYTQrUzA0RUZOSjRHQUZuNUYyZFpORFZSdWRt?=
 =?utf-8?B?Wk8xbjVqQWNVQ3NOckt2UFQrcGlUWjN4VGNWZ2IzVDVHYTkxSlZlUEtuMWlC?=
 =?utf-8?B?TVJVZGdEOGU4SWhQRXhKLzRwVTNNSWFxNm1LVHZaaXI1SHEwUHl0VlBIT291?=
 =?utf-8?B?NG5PRlZOdGpJUGh1QnZKL25tdi9DLzBjdTIzT0NxY2ZTNDN6ZTc1cTltd1NE?=
 =?utf-8?B?Wi9CZVM2RlZlZ2Y5cTdWQ2RaYVBGclU2YjRjME9JQXhheWpqV2ZsT3FKUTlk?=
 =?utf-8?B?MkRaTDFCcjZSTGxZUk9aK3R2UStSQnBMQWVUQnY5aVZTejgzb2w3c1JnVm94?=
 =?utf-8?B?TkhDTkQwL2xIM2RZVlFUZjdnYUlLWWc1Zis3ZVhpQmE0VHVnaFZQbHl1ZnpV?=
 =?utf-8?B?WFRpK1RIZjdWeEg5N0ZIL0F6U0NKbXo5WC9XNks2V3Z4dUdyYW5JekxOV25h?=
 =?utf-8?B?TTZuUzkrWFZvMnFPRDUxZEI1MS9uemdoUFdPaHZIbENOM1hGQTcyWTVJOW02?=
 =?utf-8?B?Z1FBNTJFamlJZGxxdEwySFZrekNzenFhNkx4TUYrbFNQejFDMHlJaUEvaW53?=
 =?utf-8?B?Zi9mNmsvdFR6SlU1RXVyV1VHeURreFpVOVRpV2VWeXhUMmtjSTFwUXc5cGtU?=
 =?utf-8?B?eFZ3V0FEc2grbWU2bVYwNkEzRWZHYTFWSTJkZ2l3RCt6YitSMzdBdE1OSjNu?=
 =?utf-8?B?VUdmbk1ROTVoLzZldFRRUlRkdkk4MDZXNzVFNXkvMjRleFZpR1NvQmdBUGpQ?=
 =?utf-8?B?bU5FWEN5b0dnb2hPclZGMG1EWU54cEdLWk90Z0F0cFp4SGw2emNUVHRIT2Zt?=
 =?utf-8?B?bG12V2JCOWZsYlM1TnRIdGlyOWo2czI2bzFLeXpKdGUvcDFCMGVndzlrVkxi?=
 =?utf-8?B?RFBYNXJMU3A2eHlyaHMxM0NFelh2T29VZGkrb3NHVUFYTFAwUkIvSGYzT1ZH?=
 =?utf-8?B?RU01NktxeVczTDF4K2hwcXAxVTZ5YVhuK2lVSnhBM0tLVkRxcFVoc0tNdDdi?=
 =?utf-8?B?K0ZSaFRUZEFSbXVJNS9nZ1cvMENWU0c0Qm5TNU5hZFZiT05vWUpodXNwcGc3?=
 =?utf-8?Q?fV+5oX5WNU+RlybdEqUQtjGjafg8R3OSLjA/g?=
X-Exchange-RoutingPolicyChecked:
	txqtzgX/scUOH/8dmSIiRQ9+FxPjvrqmOJlteNGPCu3ZC0wUa1gAbvfkbIJpVd1fGjehv4Q77XVdnHKSInXDDqdnzLigYU8di1qPZJRtrH6aBVUZ2WU5bFB+PI1uVZmjpcVR1IzZvVuwWc7x2q+Hy+29Rw73WFeoi3EuTcfIc3u7Dc3FRmPgdoUH4OnNkBcKWz/qB0PzPoCNJTTF6dpmC2dAvc5TiqFGA33YX3Y63aiHn1BhW2TKUVclC8oNiwP93PFGREpszdnA3ejmktKGI6NiUJqKcvR9pf94NQ1z9HxYZT9CmddwuS/1jL0R+C9upO/a0jJfduPU5f8p2LF8eA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	POfIrEHz3wsxII8ZLKsTw40hAb48LAjNQnZ6LmZ3nZMEmCwljBmJf3rGclFqbht+ltCR1kaVcA62g3LP4ujROWuqREy8FKeFY2cQskiOQNP5b/65HMCXAyC5RybMj9248p5DDo8OJ5hbT85HJc8qaU/Vepf6uyEbzvSU7rZ2FaTOHIkl/gwbKQEgpDonoRY54+C1TyBMq+5BysDJYbqtdCvqJkqny00ghVaxstttUxX9xNneizL7F9jJfJwO+erUFk0ijDFF9UWhkMP12ug1I9X8VMXOzTKWjmB8p+JrAa/CSakTQBSFlV1DncJSzld9aI757mTzKPLumI2sOCZqx2JzLlWY2NFKwwltNqdnwmq2k67bkt6r+7DhviWG/hfWICooADnReSz1ajiNv0OOmVWJpFYAH6Hhpom33G1LGON1t3Vey47E8ribGoZbmdsuwNaz5M/iMlqJOsVPDM0ZlzZCy7RxotPSa1AR7DxZ0pIDQNhYO4QPwf2pHOzMLItX4aXHm5I99khFI7Df/vb6q1tDHjzM3ELiq8Z9B3KsqWCDKD+/owjfgJ8+kHIBYxZX8w/9VJTx2brmVDlEywri68NdVllNi+E1whlj+lif2ng=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3ae672-76a3-4722-7b74-08df13c95908
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:06:01.3710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rp3O2rUlyBBsLfKeJrGUbZE6hO5PU9bmjF46TPTxKPvycUvj4Ie5gxIHQTqAQyyecnVk2jchIMnnNo37vq/ZdivVA+OT8ouoQSPNS0xMgK6Pagd5GYDXmBw3Fr0uDndO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7260
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160104
X-Proofpoint-GUID: N9pwOlU8qc5IeQfKqlKrCGCzmpfBEHbM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwNCBTYWx0ZWRfX6UiE9WKOPlPc
 /7DZsD1A9IXlbw/i+mV84MkQIt9CCIHdNCYXpgIqqEn51UvL18Rd3ups3FiDknKML/9kN8T2Ff0
 n5mk/7kk+RScbCv9263Dkt/r8LOD1Rh65fcrCqZYduSAGkA4E8rsGptt2hnvJioPN+WJELcuxAt
 ur94yEMKdn9gDxdRL/BJSD73BW5DC7cxYHpdBEROVvjUROP2V7IXdKyc70LfKzXpjCnx0shAbw6
 cA3nB4hgqeia+MyFMuuANyEAmH8xWYlfuAOh+etGfB83vd9JwdaR8YC8e2Lt1mwcTmbQAtAHxNx
 WLtY++WV/W9whQN5SxMHAv0/ks5KN9tOFK6Kif5mOrQqFfg+6WMzJNFLgRlUZ9AgnkifBp+4fwc
 8r5Ny5F6K+r91kWvSORaggH8dTqvFkp9Mii6925H5b4QJGJwKzTvK3r0FWpJpbup7JN28SbmjRF
 vaMEsXApBlu6fnPQ/Qw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwNCBTYWx0ZWRfXyiVJpO3SvUfi
 XtdTAKbiBZsWk2QonEduGHa1SOFobZFR+1wEnM0uiI6l7jofy+i0x2fUyP4fLg1nn+t6xYoZVsk
 npI0WWp6ZK/uPkq505MnZU9LKs09lt5Za2so3bs4c8uEemRTL99E
X-Proofpoint-ORIG-GUID: N9pwOlU8qc5IeQfKqlKrCGCzmpfBEHbM
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aaa4dee cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=PHq6YzTAAAAA:8 a=ARjobp2GWStgwL2ehk8A:9 a=QEXdDO2ut3YA:10
 a=ZKzU8r6zoKMcqsNulkmm:22



On 12/09/26 12:25 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Xie Yuanbin <xieyuanbin1@huawei.com>
> 
> [ Upstream commit 1039bffd6ae9c75b42b7d148d6c1106134107b66 ]
> 
> When CONFIG_DEBUG_USER=y, and cmdline "user_debug=31" is set,
> a user fault may trigger show_pte() without any lock.
> If another thread in the same process concurrently calls munmap(),
> the page table pages may be freed while show_pte() is still traversing
> them, causing a use-after-free in show_pte().
> 
> If CONFIG_ARM_LPAE=y, this may cause a kernel panic if the pages table
> of PMD are freed when show_pte() is running.
> 
> Acquire mmap_write_lock() around show_pte() for user faults to fix the
> contention.
> 
> For user faults, additionally restrict that show_pte() is called only
> when the addr is a user-space address (addr < TASK_SIZE). This is because
> the lock of tsk->mm only protects the virtual memory of user address space,
> furthermore, dumping the page tables of a kernel-space address for user
> faults is unnecessary and may have security implications.
> 
> Keep everything unchanged for kernel faults, because the kernel is
> already in the "oops" state, acquiring a lock may risk a deadlock.
> 
> Co-developed-by: Qi Xi <xiqi2@huawei.com>
> 
> Fixes: 6d021b724481 ("ARM: dump pgd, pmd and pte states on unhandled data abort faults")
> Link: https://lore.kernel.org/20260716014022.2823-1-xieyuanbin1@huawei.com
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Linus Walleij <linusw@kernel.org>
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/arm/mm/fault.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index 16b5a7d214808..6763a7c660780 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -205,7 +205,11 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
>   		pr_err("8<--- cut here ---\n");
>   		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
>   		       tsk->comm, sig, addr, fsr);
> -		show_pte(KERN_ERR, tsk->mm, addr);
> +		if (likely(addr < TASK_SIZE)) {
> +			mmap_write_lock(tsk->mm);
> +			show_pte(KERN_ERR, tsk->mm, addr);
> +			mmap_write_unlock(tsk->mm);

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

Upstream prerequisite code:

     local_irq_enable();
     mmap_write_lock(tsk->mm);

Downstream 6.12.y code:

     if (likely(addr < TASK_SIZE)) {
             mmap_write_lock(tsk->mm);
             show_pte(KERN_ERR, tsk->mm, addr);
     }

The two new mmap_write_lock() calls are sleepable. Upstream first
enabled interrupts in both affected user-fault paths, but 6.12 lacks
those changes. The backport can therefore call down_write() with IRQs
disabled, producing atomic-sleep diagnostics or a stall if the mmap lock
is contended.

The missing commits are 59e4f3b45b96a24fc9b7a89e5f8a2168b30f95af and
e79ca91165d4fd18549c536abdb86101e889052f. I suggest applying adapted
equivalents of both before retaining this patch. Thoughts?

thanks,
Harshit


> +		}
>   		show_regs(regs);
>   	}
>   #endif
> @@ -649,7 +653,15 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>   	pr_alert("8<--- cut here ---\n");
>   	pr_alert("Unhandled fault: %s (0x%03x) at 0x%08lx\n",
>   		inf->name, fsr, addr);
> -	show_pte(KERN_ALERT, current->mm, addr);
> +	if (likely(user_mode(regs))) {
> +		if (addr < TASK_SIZE) {
> +			mmap_write_lock(current->mm);
> +			show_pte(KERN_ALERT, current->mm, addr);
> +			mmap_write_unlock(current->mm);
> +		}
> +	} else {
> +		show_pte(KERN_ALERT, current->mm, addr);
> +	}
>   
>   	arm_notify_die("", regs, inf->sig, inf->code, (void __user *)addr,
>   		       fsr, 0);

