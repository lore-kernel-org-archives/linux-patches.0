Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46F4365A19;
	Fri,  2 Oct 2026 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975113; cv=fail; b=uvB/U7tZtyYdlAu9VF4gpT5lT/BJibjcK6WXQecvj1ArBLgbbWMkA4T1gnOe5xF90tE4KEVY/iH8GnkS2ftPqLiJsJMVsMp05K9IFXdc/ZjKl4opeQ4CX4FekNj433uY/SZC3HXIozq8gAqMd1BZTld8n3HsNGByWHr9RnBKj88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975113; c=relaxed/simple;
	bh=J4NYJhW/SP0gXECO8wrvzPeZ4lPG/7+ZD+YpM2oM+0w=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bCYv/7Az8EASwY/0/5HengueAJ70m6LWiY53aHpU9NWU6Y9ZoEUhfrZzWwUqj1mz6zl1KvNclSAPawN4iqwTs/GzAia+EiPK//e2ftyHy+YZ8Emp2wspoQ4J0DWLdUQpOxvRbfoUToaLMQliZCvwNNIsn/enh0dH83ozKXOOklc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=StyKn0iM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=phuPpEw2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="StyKn0iM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="phuPpEw2"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692EblOY3283840;
	Fri, 2 Oct 2026 21:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=z6FAPpxCUu2cLC7EzBVuKSotajZ1B9fDAm+EnKjrKiw=; b=
	StyKn0iMSrZyt16sZ2w9/zO7OD59VHqhZOTw12csJqt7qR9i882uAtioTOyVJG8j
	3K2OF8pklnNPpqKmS+ypA4hgWcAXUdF08PHoLm7/R9PF8UiP2Siy+akiaUeW9BIx
	dadgTtmQpLvHKy84yqrhTlTrQDA7i1/R/WK/izHfC+r5wNITi5NJUCosbPAZaxmd
	rtfv8XI1rr0bDwiX0uWB/TwgvVFMjxGVhr1I+DelmRXwTirRqk5UaNGjQY7hETBK
	T/lqDaJzheJq/H9EskyW3Mk5KNjHHQfgUVBTlBp7KDXyEgKHVDuJYY/fjZxLPbiv
	CNFKXgV5fjYtenDneYO2ZQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4u2mjva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Oct 2026 21:05:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 692L522Z030623;
	Fri, 2 Oct 2026 21:05:04 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gg6m3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 02 Oct 2026 21:05:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vl9UhIVAS5fSb1O0UCkmAQkKhf6CkXMgpuq8DQZs/fE3sTTi3/VTr6+iXvD5wprhUDKdj2RPoIL/jcT4CAER5sg1q40307CkRfwlsaZLNCdiBla4MBuLRzoJZfWCpy7K+hVxIjRK/KVKVEb2LXwBt2nzI2bk+0XH/ehAs3efjSWAYvM7z/DLBOLO8NFoq6TDODiyPTG8oXSzhp0N4NMwoOKTl0wo7ZjUxXqjr2hAmOJUCHEe/gq8Oxw33XovcqHDt2TND+FygcEfZKCkx4C31vaJqyo3AfJc2Yfh4neXDhKetpbGWDljb5lLbD9TWYsZBjKKaSoiEZ9HWKyxEp79fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6FAPpxCUu2cLC7EzBVuKSotajZ1B9fDAm+EnKjrKiw=;
 b=VuCjvJCIEiL5Kxh6ehiaV1wGSad68qpRVIEZboIhZHmhJOWaKvg1U8ScGARU8LgsUyH81DzDQX49Gd6hji18Af1C7DliO2zpYH//AIlQJSHPjyPfqPhjMKkGAKT0Pc3ayv58X3ewoGGgwPlVL7jaSiKezAhncdGYiqokq1kq4NFyutPcslN3mqcETtONv8aGj4JttqdqVM+a0EOdEpc5CSx19Zt8x86Sh1rsvSXD+0B2nizns1l26ZrAPa5set/Jb0brwHEkr5uSSjGhma+v5NG5aRgzBT5W0lyZSnNIhmD11HX9UOEWCYV/OxFCV1s6KITZgFi1i8sHcx3Lh6CWoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6FAPpxCUu2cLC7EzBVuKSotajZ1B9fDAm+EnKjrKiw=;
 b=phuPpEw2OcwszRC5FnHZKajEcopGiTTHh81ZJJKT7gB55gyU+aphWCOeFX82tK4/inInHdz/BmrAG0g2hu5nuIVZjEQXczRe6FzOTcmD9vEKHh0lBO5sd4qnh6g/GNPkJyyKNn1C8S/vUkRVY20rLhJ6ijUzNDZ5e/2NYS2yzKw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Fri, 2 Oct 2026
 21:04:31 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Fri, 2 Oct 2026
 21:04:27 +0000
Message-ID: <630d79b5-28a9-4443-8ab1-bea938ceec66@oracle.com>
Date: Sat, 3 Oct 2026 02:34:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 746/877] ipv4: remove fib_devindex_hashfn()
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152430.793210817@linuxfoundation.org>
 <0d9af3d2-6656-4248-bdc9-0a09d5f7bd40@oracle.com>
Content-Language: en-US
In-Reply-To: <0d9af3d2-6656-4248-bdc9-0a09d5f7bd40@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0674.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: acc831de-0c98-4f52-f9f2-08df20c8be8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|22082099003|4143699003|18002099003|10067099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	xr+JZvDqD5GeOOidvFRWmWqevdz8+UtnZPtJfH1wuMghpTDOaCJAFrVWvHyHqFGD9O4SlgwEFg+LdLvrbh1m4js1q0NayWhTGArxcWGiIA8cl+VyhJItXKQxU0pVHdM74/vvzRDi5ZGFRvMkSiSwNEBawoNvNdk8ppNh+xUNVRoqbzyQqvipE3Rro/t6zn9VBjnfohov2+OcCLBfNxlbgnpzI09osuWQFy4+vUc35DSq7QfVbTe8dlbaC/w+nc1MH2U3ZJgImGJxuIWZWaSKGAXYndUsVWSZFUgKOlDmdTrhGkxtINnlZB8KkHv9VCAqr5JX4kW/bpNMGLjXJ2IMPME+vmgfNn9ZacA7MVofU/NpZswur2EnecwG1iIPOAg52qWE2vbBu9knvG12ppnXsoBMDVmHaGCgr1uX9opCK3SDnxzueAkMZlagPII0REHU08KVsnU9L1uhjN+FfkATlAAC9ZPsiaW9FfrYLlmGtdBzaNNq709eKIeGZDz0ebu8Eb2/YzJoJmHTyTRGXg7Ej/AZUMXdjHYidn0EBTwhfy24NCM3Gcc0lCrRFgukQJYP+lt1YASyT6Lo1ImEIikUJ+G9nR8a37qB/mNRdO7GX0Sed8QticC1oOrL7MWWUsrDNqayU1a+VfgJPBRdoWdZG6HOuD44KNcwo3v4fLfJCKY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(22082099003)(4143699003)(18002099003)(10067099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXB1anJ4ZHhUdzZzd1lVN25oNUJMM3RaQmtZSTdpTWlFK0pGSmVaaVlmQ2VU?=
 =?utf-8?B?cDBnVlpwdFhTWi82TVhtV3dyVytEc1VpNmZHZ2VRdml3bnF0SzlGa2NmR1Uz?=
 =?utf-8?B?bWxUS2dCdmpYd0VhOWVrUjRRanRUYWUvNzJaeTVzK2xLbWtlc1djOTBES041?=
 =?utf-8?B?ZXFyanJzTTZlWGxsa0pjRW1ibmZucXNveWZ4cnlFTmVBdWhTalYzVnA4RzM5?=
 =?utf-8?B?L3pqY3ova2ozRWxRbWdQWFJ2eFR0dStCbXo3K0ZEdEQySkNKd01zTTViVWVy?=
 =?utf-8?B?VEluMFdwNE95VHdqd0dKWnhiMlhockZ3T3NGMWs0OFJIL2xWOTZPSGRGQy9u?=
 =?utf-8?B?S2pjT1RWZ1B0a0N1U0RTTXFZY2p5R1BBNTBHcDhCTmt1Y3Q5a1EwVU5EL05D?=
 =?utf-8?B?VWJmbXJUZk5NR3c5R3FmQnNMS3dXQ25tWWxTU2gzbDdMUWczZFdId3dBRlRN?=
 =?utf-8?B?UVZOUEFReGRseG9MUHF4dG8wL0JVejh5anhJRXVDZGRkaTFqcVd6K01FbXVO?=
 =?utf-8?B?MTVVYUQ3blB4aGJvS3hzU3UyMzFOTE1UaHFMQ201QTI3WW9oVHpsVDFLQW9a?=
 =?utf-8?B?UzQxM2I5enNXNFpUMTNoLzI0d2pZbVJpWFRZREd0MkJxOTVYdW5hZUFkZFoz?=
 =?utf-8?B?aTBLMmJQcStzVDVRcmhaazhGUHBuNVU1RTh2VXk0aXRqTE1VWEhCOVJwcWJX?=
 =?utf-8?B?YVpmYTAxYytpQ1U1WTA5bTJjNkRzSVZheGlsTENQY2k3QThiS2Z1MHpja2V5?=
 =?utf-8?B?cFhIU2V2SG91MzNZKzlXcGhPeFlNOG9meVJ3U040MWxPeVdFaGtzODlmaGl4?=
 =?utf-8?B?UlBOcXJXNW45VERLdmwzTWQvMGRiN29vOXFlQ1cybkt1Q2Q5RzF2OHIvcUph?=
 =?utf-8?B?TWVqeTZnZjk3TEFKWk5RbzFpN09LRHNDcURzSEx0K0hKSkhxQzROL0FEdHAz?=
 =?utf-8?B?K0lsR1ZxekphcFp3eDFhMlhteEJHK0xZc1NZQ1RBak4yMnV0emhwVVpqRUEx?=
 =?utf-8?B?MFVvYnkvVE1nY0pscUFMWnJEWXZDRitCaXdvbHZOcUpiM3FYRmhwUlV5UTRO?=
 =?utf-8?B?cytvWnFxVXoxNHJvOWNEZEtzS2JFMnBEUkJPTkpFR09vcVRhd25kSzRIWm01?=
 =?utf-8?B?QzQ0aE5QeXVxWWZPZG1LSmJVbnlrbDN2SkV0TjBOb28xYTN1SnF1V2FhWDFO?=
 =?utf-8?B?c1lXdlE4UlVXbzlVRWNqL1lZeVBwV3ppMmd1WC93K2xEdC9UbUptR3RWMklq?=
 =?utf-8?B?ZTNFYk5ZYVhmOER2MW9hckxFS3JyaGZFWUhnU2JKNWQrelBRdWhIMnp4czNa?=
 =?utf-8?B?QXhmbjlUWXJLZHJkdlVkK3drbU5sQitQaXFKb3kreCtKYkQvdkdES1JFaWlk?=
 =?utf-8?B?dDVQTDNUQVdHUFVUdEx3MlNLNVkyejRzeFc4RCtPeEMvSFdnRW1IQkRJeXR5?=
 =?utf-8?B?V0xsd3BEQnpZb1RIQWd2UEtPTUFzMGdIREdvb2tXdG1DN2pNenlhc0tsWC8y?=
 =?utf-8?B?R0ZIQ3Arakd4all3dUxNVU9TaXhXaUdFTWtndjhwZUk3cGZod2NnMGNzRFly?=
 =?utf-8?B?VW9oUkNJNktweTRseXRxVzFjZG0rRjY5RDRaMGs0MVgweC91WGV0YWxoVHFo?=
 =?utf-8?B?cGhIeUEveFYyNEt3b0IxeEpocERMN21BWVkrbmJxSU9idThNZ3QvcVlIV3R5?=
 =?utf-8?B?K0JzcVp5RWRZdEo1ZURpTUdDMjhNR2w3S0FIS0xDcUVUOVJlM2NrZ0VpdW55?=
 =?utf-8?B?ZzZwM2NHaUw2RFRyZVJ5MFB5TmVEc1VhSVc3bnJaUEJJODdOS1ZRMkNQR0pU?=
 =?utf-8?B?dnYwZ1krVzVHUTA3VW5RN3FyVDdudlE0ZS9FeGVMSkNrRkM0YUt0RDR0cEEr?=
 =?utf-8?B?ZXRodXZ4V0dnTit0Z3ZoUlZ5ZkJ3YnYxWW85bmQyZzZETEZqejVTQkhMdm1R?=
 =?utf-8?B?a1QrdVFaUjBtZUM0dXp5VFZCMnZPYUtLL1RYby9CT05FRTIxZ3NIR3VYWTJG?=
 =?utf-8?B?am1YdzdjaHZmY2dCVXF3YnZQSUxUUU8ydWR4TERta0VPYldpb0ovbnZydVBQ?=
 =?utf-8?B?S0FhaTJXZWc4eWNsTHJ4WkhvUVZFWk43K0ZwTlNza3IwNklPaGFod1pGYTVo?=
 =?utf-8?B?TnhuTER2eTliUi9WT2g0UTBvRW1STERGRk90ZjAvbzNkTGQrRXR5UXVRb1Bp?=
 =?utf-8?B?cjVDV0c3MmVlSXNrbFpQUlVzTXVnekRuM05kcWlwUjd5ZXBNT0hWNFc1VGhQ?=
 =?utf-8?B?VWFTMnp4OWhYakZQRk9WaFpUSlFNOEZkSnRlS3FoTkNSMnh1Rmp2MnNrQ210?=
 =?utf-8?B?bldxMnNrRGMxNDdYSXJDSGtHb3N1QmR3ck1nMXBwNmtydlhCNlczeW00TXA0?=
 =?utf-8?Q?RCDy1U0L4DKIt70Fw+2huicwvl/MDruCKbnwk?=
X-Exchange-RoutingPolicyChecked:
	iw21KboIS9hFYqBfPnAGJR+8dbrfPcqnaOw5Pj2zJFOS9T7GF8SbYMoW17D7gAIF2ooaVD7+6IDluuMOdBwUfdbPFpj1GTNTV9wifOzPsmWcB1G7XLRC4fYb3IWSOU5dMQqia6gjLdfDm8SmEmkFZncfClQBz5AT8TKkLqDd/kOs/d/2F922UXRbs1+unzcznZ7d4FqW+MHCl45/nTcJg0cyMZu5g5Kod3noGDQpxqLh+Th1970dZyr1MjzWMeodYCEXnPvaP5GfJHj1b8wNCq2BSfk9kmh/JefaNvSvlm86388OzQYPUj1CzqOWrPjNCOfLl89xFNMZzxG3J/a/bA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fTeennmBGxfa9b0/V9kOmB8YPQMrV/M3NAduCpunP+G8bbM1P4qMTxkjtnTL25O+wtSL6Hxtzgn4ikDFTP5UpU5wWcfm1CiaWYZm28hO/wWxlAcetJOjsOSN+qAb6Jd+QPWatCD8nRBbj9lcbq+cJ2LuEueEgdQMVktrTNjeUBrgxY0hpjyR+R4QoS5Q8tQ4pJsu2pIFQ8NzArV48sNGYcb9jf9ZSGMpICJG/z7VPTagQSB7cp0PTY/n018nHreyry7EdpzX7WFL+TAducMpxf3065OdWBkchbACGa8QcF6LSq9Kvfb3YXOGZgemVfn+q/lgauGAme9FaQk0MXBK8MJ1PCdscvQj10mmUumpp11wcpL76yYe1A6iQ8PCmS+IRqMG2lhh7HjWv26GM+w69Cyf2zcy8lH8sZ9K1CpVG8IXE/9hhVMkfSM+l+BUdRKgyaB80i+npkuYHV3sq36F6OWSIL5UHYwnl9R142FEInlkoO144KVGhp+w1YEVwu3DCCbY63Iv7Wuf03PV/JnrXUIJYrC0b4fisWOdOBGpAaLE4tjKnAs33z2kwkL+oHZ0z9rVNw16tlVBEKnnCGDXYbKwfMkAIOFo/fW2f+sngAc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc831de-0c98-4f52-f9f2-08df20c8be8b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 21:04:27.7888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDbo2RACxoAnfc0z4umUt4+GgDeyvOdF2HE4RpX9o5QFG54CO6wffOps5EtqkM3IjkPILYroICZwBRzzeKeWQdaqfzyDmAEF1RzB5JI/F4IpMmCUZXgUAkNUm3t4qmzU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_06,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=871 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610020084
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA4MyBTYWx0ZWRfX9VSTg06UN8B6
 S6FWD+62Y71Pnx2NpsHCHiNKLTiG0NmOq3/5TQ9Wg0pHrJDjgBzDMTNt9+xLVKnpWOExrz0npaM
 Mie0Vq+PwD2Pe4qGq8xFPbqyFVT5SMhuNgmfD2Wv4Bw451/iBJVE
X-Authority-Analysis: v=2.4 cv=W9itxhWk c=1 sm=1 tr=0 ts=6ac01c82 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=1XWaLZrsAAAA:8
 a=eSD2JtJYZaDRrjKyxzYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: hZhwzYrmqtIt5xGS5mmaNcHGOB5kMbnm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA4MyBTYWx0ZWRfX7jQaj1CwkVL+
 8mJMmH73Noiu1gWECXCkhbRPb7FEfU01JWPd+KmoIKGjClny7W5M2+oi6IBOLX3HbOhGffjBLKS
 4Ss+7JkbL0n/15h1TlCXAE+nte+9y17rzU2wDl3bj2N26pqkHN+kk3gwsJljszkrqLF5+FZPwhS
 Y2YmZPh8y3jMm5fAXPzMZNUJJyhxGpSqW95PvuODeaEhJ+9J/ENG3yNO0ITnNsQLYYCgwb5z9Nm
 NMaRHBGiYK2Yxkv/bP4T0lBEO0jyE73zEH5FJgPUdGpalXNp0rCe7R4aHuXoAB2HLUr2QGV1hEA
 n+pWoWqrlfvZWySqeCHdSzP2c4XDZBmtMAKX3xHfIZEA85sr7wA60jdCoeeSF2GCXmjbLym0tGI
 9uiB2AB2aV2tR0zLdmXeNgCse7b7usY6K+uk58UaUDjI0yDqBzrBgkTn4yss38+zO6KpWOnOqLk
 6ouY/FP5WzCGipbeTbw==
X-Proofpoint-ORIG-GUID: hZhwzYrmqtIt5xGS5mmaNcHGOB5kMbnm

Hi Greg/Sasha,

On 02/10/26 1:54 am, Harshit Mogalapalli wrote:
> 
> 
> On 30/09/26 8:57 pm, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Eric Dumazet <edumazet@google.com>
>>
....


> 
> An AI-assisted review flagged this, and I checked the upstream and 6.12
> code. Removing fib_devindex_hashfn() also needs the upstream finalizer.
> 
> Upstream, net/ipv4/fib_semantics.c:
> 
>      return hash_32(val ^ net_hash_mix(net), fib_info_hash_bits);
> 
> 6.12.y still has:
> 
>      unsigned int mask = (fib_info_hash_size - 1);
>      return (val ^ (val >> 7) ^ (val >> 12)) & mask;
> 
> The old finalizer ignores upper bits of raw nexthop IDs/ifindices at
> ordinary table sizes. In a 256-bucket check with equal route metadata,
> 128 IDs differing only in their upper byte use 128 buckets before, one
> after, and 128 upstream.
> 
> I think 6.12 needs 9b8ca04854fd1253a58aeb1bd089c191cb5a074c ("ipv4:
> avoid quadratic behavior in FIB insertion of common address") before
> this change, including both finalizer callers, thoughts?
This also belongs to - we need not/should not take the fix until we take 
a prerequisite category. Could we drop this until we have a proper 
backport ?

Sorry for the ping.

thanks,
Harshit
