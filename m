Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEB43CF58
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 12:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734180481; cv=fail; b=nXdL3TZ3lbgIgyjXdhBoHbmgNDKCawdEpU6l4uux6ygqtzKZsuMiV5kVhDMV2Ie0pk5+TSAOQ+KW6bycY80OJ6Lt6nq7wfalVyBm3oYXEzLbf+wYVhNC19tpT8jqZTDtDiacQTStkeKJL/cD8h7mVofQN6k/RqeTf6ZFG8lDYIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734180481; c=relaxed/simple;
	bh=b3Eq9rc+Edpna4MdajscFUcaywmwJSejtw0xB60qRqA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FGTGIGortOssmCD2j31ppZ4PlHNlpBZJNYJoeYo8y02+vI/Z/aN2O5HGyU3a/OqKvGDqq413Ed9q+pRddv5trZGGVe/avat/3s/iI5me9Lf4PEBcLqTfgM6bpi6LptPsR5xguvWLK16Ys+Seb0zNOiKSxh9eEnZ5PoPl12m30zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DExksJu2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UUZ4BARo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DExksJu2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UUZ4BARo"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BE5U1wM018446;
	Sat, 14 Dec 2024 12:47:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=21e4mE6vay4Gy4a6QzvbLCQTOSfKu/BAaD/M9S9gHFU=; b=
	DExksJu2eVMQ9k7KsajK57kSsNMw5/LDUS7fg/gAgwmpfM8HGGTTZ2q4Ogo1bK8F
	lTk78CMy6TnvPg5szfDhOpzdU/Lxm+hbitV2SCQRE7Lexna4yKhUiTKnMY1nh4og
	z9k6W7X+1WGxZXdry7Zo6NPSqSwNbm/krMT01TnX4Iuo3OfPL34DkiwhOGUYUtur
	itLZ8O39a8H7Kt9fY1rdECfYx700POuT5ApAO7SLw8Qi83Cd2/SnBiBxYaPFAWKb
	nxdUGte9KCydiT141mon9pT+53bpZRB/21fIYzLUZlZF1jVBTEqufg5I96jdt/sV
	aV0tI+SGNFCGqyQarJr4Zg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec0f1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 12:47:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BE9vcYH018310;
	Sat, 14 Dec 2024 12:47:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f5t9af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 12:47:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IHBgc7cOAC3OTv+1eTrfi8dYdqvZoyG9AyY++nma4CfPRXcLLrx7fmI1CWqP5EYQNBftCD4vu+KWy1LPRW6WJhSEBO9tCVjSJ53lCWB/cxmG+y9teZZ2EtTsq5YkWfIWNqioqqV/2gApZKmF7R4r8HIpFfptNEWL0+2M82jbtxgZy7Za+4r7u0RpBFHwyKewDo42pGMz1TXoh0dN2ZuKXss6ZJKbGl1t7ftQaOGKJnC3hmQpZgN9HOSco+Efsk+4DnUNesAyXyYd30AWsccwsHu7jzhrSvGXFrCN40j1/gPl3MbqiyqxyuO4KHhdcKz185e2SK4uX+zIPFz6H8KV5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21e4mE6vay4Gy4a6QzvbLCQTOSfKu/BAaD/M9S9gHFU=;
 b=aE1G0c5wY+YBLhc4uM4jZ9BMKOXM+H9L+YfnbdsZt58FBJnYZhIlmEdHbIrYrLQYAyN0OWdp9OhXidiOpsdKeWcmNiSpWsiH/eVWHwKQ5fBq8M233LvzTn6GJDgDioak2HSJ76HTyqKlSw45brQIgi0xPr6R4OBUc9K/iLeaPutIT17qANvNSvRdrgBNeKi8Eofnt/PVx4bAg1HJRioHyV01CW7AUDXr0pdFpitB8/Yw44nauwBkQZgx0m7d1TOmhlhi5ONg8au5m69xlvwEFs6Plq2gEcswjaBxzf+MOw5sbhsh9kUshC0ZoJA4YZpTW1NFC8O9Ul0fPoxKK0Q5rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21e4mE6vay4Gy4a6QzvbLCQTOSfKu/BAaD/M9S9gHFU=;
 b=UUZ4BARod7svakHXLyY+itxcOws6htjiquAJ1Mzg7t3tXAWhJtMWBufmE2QYDD5Ic/iB+apAAn4QSyznVhicZ+7aYtH4732n7V77y1f6mukzc7ATO+RUlyev2NNtAqyPCXg8bVID0Q3Gtj39q1Qbew6MAGGJh+ZSpK5+FXO6LdE=
Received: from CY8PR10MB6873.namprd10.prod.outlook.com (2603:10b6:930:84::15)
 by LV8PR10MB7967.namprd10.prod.outlook.com (2603:10b6:408:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.18; Sat, 14 Dec
 2024 12:47:47 +0000
Received: from CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0]) by CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0%4]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 12:47:47 +0000
Message-ID: <a748a561-9680-4362-9395-b7bb60f537d1@oracle.com>
Date: Sat, 14 Dec 2024 18:17:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/321] 5.4.287-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241212144229.291682835@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0043.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::14) To CY8PR10MB6873.namprd10.prod.outlook.com
 (2603:10b6:930:84::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB6873:EE_|LV8PR10MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e4c9fb1-a162-44dd-23ba-08dd1c3d8276
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1lkaVZxU1RoZHRsVXNkSy8vcWhhbkV5UnEzTCtBVHk3RVJyRjZyakV1NWlv?=
 =?utf-8?B?UHpRRkpKZVQ2K2pnNEZGNld4VjZvVnhYYVUwT0VId1BBYnltK0J2OVB0bnFw?=
 =?utf-8?B?aTBxWHFRNU03MUozYXY0OU0yWFhPQXpVblhOV3Vsd1p0dy8vekl3SU95NWVI?=
 =?utf-8?B?TmF2QnM2Tzh3SmdyNnRRWTNQTXEwdi8rSitjVTRrQ0VIZVU4ZG9UUk5WRVNw?=
 =?utf-8?B?a1Z5MXU2dUdsU2xYSTNBZWdCWE9mZFd5L2JFL0UzRlVXVmQwbXhteXFwVnMz?=
 =?utf-8?B?U0NTbEVvN1NaVEMwV0dhRmM2SVp4YlpDand2eUVqN2prNDBOQVVJeVBzMnds?=
 =?utf-8?B?cmIyaE1NUWV5OHMxM01PdU1keFdiWW8xMEkzUUlyZHlvTWJReWtxc0QwdFVD?=
 =?utf-8?B?c2pibU5nbHNNMTdhM0NvZ25tdnpZZGNYQTRMWEJzc0pXbUdZWFV5b2o2K0ZW?=
 =?utf-8?B?TWFGalBsU2UvK2pSOFg0OEEwQTdmLzlCRjBQSXp1emxWUGl4b3VZckd1c3Rz?=
 =?utf-8?B?ZHE2d1YvcEtwWHArN0ZUci9kdlBoTDNVRDJhY0ZmaUtFTFZUL2RoOG54dkdU?=
 =?utf-8?B?NnV0SG81c2FzdGhsQ3dodEpTTUlhMjlCOEx2QytmcE5qR0RLbUM5cEpEcHVw?=
 =?utf-8?B?Z1JkdjMwZ0hyNGczNzM2Y1BobStGT0RuSzVKRlpSZ0RZbWt5dUFwOFpnSHZw?=
 =?utf-8?B?OXU5czNTaE1OcGx0eFcwTHNkbDNyODNhdkZybUhFS3prVVA5SXdmRkpyd1Ri?=
 =?utf-8?B?enN1bG56c0VaSjRNTCt6YjliZGtFUkhHaU0wcG85Ykh5RE85cUhOVHp5T3RX?=
 =?utf-8?B?NnRydmFZdC9LQlZkZU5vK1FWUnl1TUZDcFdGemlrUFZRU3FVeWlocjRtUUpU?=
 =?utf-8?B?L25ZQnZ4L0VEMDU2K2R6dlZlWkR0eXBOYlEwQWsxTXlGcTdzZXc5Y2p1ay9n?=
 =?utf-8?B?cUhEeURsUzBWMHJCRGVlb0VUSHcyZVlUMGFPY2h0L01lVDk3Qkw2VkVCSHdr?=
 =?utf-8?B?WUJBMDJZTDQ1Z1lidlZqc2RJbU9ZWEoyMGM3aWlGb2tLWVFBTmlXMnFBZGtL?=
 =?utf-8?B?R2xuRWczMU1zSmpSUnhOWVNua0dZYmYyMXQ5U1ZpeU9WM0RTZVpLMDE5d25i?=
 =?utf-8?B?cS9RRkdBZUpjYTU0MWJweFJrZDlDZUxIWi9JbGExU25ZNTBROUdzd3lhNVZW?=
 =?utf-8?B?WmNNdDJCWTdHY0V2V3NYa1F0WVlpQjE3VmZmeXdPeEZPVjZHSkVmaVJWU0RH?=
 =?utf-8?B?bjlIRys2Tk1MQmdXbmJ2aUNUZmFKTDVvNllVdkI5UW5RRTVnMDVBMEMzYVM5?=
 =?utf-8?B?UHJlbGRwd2RMSFNGbHlWbmpJT2JTRE5udHByUW5JRFN2WHM4R0c4KzBkTkFu?=
 =?utf-8?B?VmxBMmlhMUlRK3NBUGpDeEtuS055MjVzRnptbE9LMnBIQnJsWUptTVBFcnN1?=
 =?utf-8?B?Z25tSEJVbjVxRnN3d3dQN3BYWGdwSDI1MFFaU3BNOEEvYjVzcFJBN3BkMXA3?=
 =?utf-8?B?aDFSZHFsQjBDTDYzTVAralRjV0Ryc0xPazRvOXdwRythWG8vamRzMzBLUHM0?=
 =?utf-8?B?am4wMTRSMjcwYVZsWHRBb2F4Nko1Nnk3MzNvLzRNRnlWM0Ixb2JTRjNNM1Ji?=
 =?utf-8?B?QWUvRCtaVVZaREUwdStBZDB3ak5LWDZWeTRaSnp0YWFzaHdBQjZxNUl5N28w?=
 =?utf-8?B?cUxNS21RM2ozOHRnR3psclQ3UFcrMC9BNjFhYWhDUEJrTytSMVdVUmQ3MmFB?=
 =?utf-8?B?YnFlSTNpRU9MSFBFUE9wRnRHZ0NNb0Fub3hXTXNOUzFuSm9rUkxuc1kzK01u?=
 =?utf-8?B?MWhIVi9Nc2JyWGtEck1XQlZ4UHhlN2tOOFk0Z3hGQ0VtcUJLbnFVN2wzdmgw?=
 =?utf-8?Q?W1Qp/gSh5+fOs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB6873.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UndYQmZpTFZLc2hvZ2VNbVk0aENYWFpQd1RXaFlxQngvV2hjWGN5VnRDd2Vp?=
 =?utf-8?B?VlVUOHZXUE95czRYVzJ5TXpOL2RhT0dIS2t3bDBpNW5WRXN0SUFTS0FPdnk3?=
 =?utf-8?B?WnkxaVd6QXdITFpPY3VXTWZVY2Q4R0MvQ0NCZi9lRXl3QjY1M1JES2d4THFN?=
 =?utf-8?B?dlllcWRuVE9IMFNxcFVsWUlkTWZ5dXg1QTFxZGJpdFA2UjZHek5iUyt5L004?=
 =?utf-8?B?dUhYbzZ4V0c0dzVVZCtzaE5WWHJQQUlMSXA5WjhnREYzZ0g3aWZ2cE9mK1BT?=
 =?utf-8?B?d2ZVSGRMNWE2V2RMQUhwLytDYTR5QUdhalVCclU3ZytWelJEeGhSRmNwSnZR?=
 =?utf-8?B?WmZJZnRLSUtlSTVobVZ5ZFF1elRRckRNa2l6QysybHNYOHE3MlJ1N3JPMGlK?=
 =?utf-8?B?bzM3Q2t0eGcvRkYyaUo4T3RweFVRNCs3cUFXWXVveVZxSkxTZVVxWGFPRU9r?=
 =?utf-8?B?TlhRbjZiZ3FpOTNEVzN3eUtyZUYwamV0TXBHTHlodGx6UTlPNUFpYzNFT0hG?=
 =?utf-8?B?cGlnekc5Tk1ta29EVjFkWUxvTU9yNVpRUUxrQkVObDdlSTNoTXZUNUVpS2pQ?=
 =?utf-8?B?RHdPbDNJTDV6QTQ0bnRiMkc5blZGL1VTZit6WUJkUmIxc2xNWEhvTWVIUzN4?=
 =?utf-8?B?MWFHTnJ0ZGZjTFpJT1YrRDZERUhVYy9vNjV0TGoycjhIRzN2M2pTaGhOZXFQ?=
 =?utf-8?B?WURCRUNna0xId2dOVHNVSXdNL050WHF3ZFhDV0JNTUhKbjR2ajhyRmd6Z3J1?=
 =?utf-8?B?VFY3d2pkSHNTTklMcTlVVFp2a1hMSVlrRmhhQTdSLzlSSnVHVDdwTDVlNEIy?=
 =?utf-8?B?VWJQYW1oL2ZocmJOZjFoRFZva21NRGhGZURldVZocHZxL3dkSUozZXRDV0Vh?=
 =?utf-8?B?TDgyS1RiMkNkMGR6dUZlb2hQRFM2bjBLL2JJQm9sWnQwbE5oVFExTVlubmpW?=
 =?utf-8?B?L3NGdnhwT2o2WDBRdTF1MUlnNzd1OW1TMTRicTRCaWV2WkxnQ2JZdXoyZFpR?=
 =?utf-8?B?NkxCbWtzaDlxV0NTTE4rSENDaVhIWlg0amxra094SzhQQ2F2akNGV2hSWTNT?=
 =?utf-8?B?T0ZhVWlkV2lqR014QUl2ZUR4T04xdnRwUlhOdzBZaCtkRTkyd1hJYXgrVHdR?=
 =?utf-8?B?UWlkb0NnTkhmZExOT09yTDFqTXJncHZRZkd4dVZ2cHo3cFA0a2ZrbGhRV1JH?=
 =?utf-8?B?dTNEQ1VKL3VsbGZzc2lyZ3J2K0IxWVpjUEpYcEFXTFlaZ0IvNCthYXJtbTFt?=
 =?utf-8?B?Vk42QllQMndNL2dxenowODdoUkVicnBxTDVrbFlTQ090K2VSNkkzNGZFWnZX?=
 =?utf-8?B?K1Q0VUwxWlN6NHVWY1V4U1ptUlN3dE0yTVRGUGxUaXZhRTR6WGl4N1RuU2Ri?=
 =?utf-8?B?SVBOTGFYWkNTeWwvWUNGMnlqVWZ4QkdtTWZvUDcwNGYzZ3huMm8rZFRDWjdR?=
 =?utf-8?B?WFZuVVdqb0pYckdFcE9Ub3RxWTVCUURYcHhQZVNvN0NxQ2tjeE84cDNnaVhH?=
 =?utf-8?B?M1BrZzBERXRJNVJzcmMwSmdaSzFEY0tSR2p1QnRreEdBK0wzdWJydDBVMXlM?=
 =?utf-8?B?ZEs0M1FKUUUxQWoxR3d4YngwZjVjdzFCQTNwSHVpWTZVU2Z2eVdjQXMxWDVk?=
 =?utf-8?B?VVB1ZG5hQzNhaGs3a1Vlems0OVVQNmZlOXgvRmVaRnIwVkpmRFRCanpodXlh?=
 =?utf-8?B?dG5oT1pHdHZzclpZVHdiS0VTRFFKWTI4VmZ2Z09ONkNMTjZxRWNHSExXV082?=
 =?utf-8?B?WVprcTZVeTlsaTllQW02L1Z0KzU5eE5YSi9mTEFpZmxSQTdkWElOc0toeGI4?=
 =?utf-8?B?dytTL1pIT2V0dXhHcHd0NklBZ2xVTFkvT0RTQmJ2azlXR1NCQldVb1I3aTho?=
 =?utf-8?B?bFlzeWtOWXNLZXRQYzR1NnhrdUIzbGZWS1ZXczI2QWtxV2o2YVRqaWY4Q1cx?=
 =?utf-8?B?RGh6N3Y4cGFjVHRna1lqVjE1dE1rZHVGSHEvSnA3WnpySFF6VWZaTC9nbVNI?=
 =?utf-8?B?eHM2NXRkZE1Gc2RPNnpSUnJ2eTNaOEQwVk9jYXVmSVViNlVKOEtNVHZkYXN0?=
 =?utf-8?B?QjdRS2dCZGwxeGprN0laMVBldWdGOEdEb0w4cVdlQ1JEbjhFWExtVldKL2Zt?=
 =?utf-8?B?c3pjWjNDOUFnTkt5cWsxNW42WlVDZ2RKOGFDY2ZPcG5KSTkzdDlOWGVYeTF3?=
 =?utf-8?Q?rMazM+S4xZMGfsT6B5q0/PU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	itVZIA5qRNJRhEmB3bNaFI87DggJiwERNn4f0SPTLx+ruj8MuVGFLRy+VObabeDkjUUpw2jxm6YYWWP+FWzKXNQW1tkeoEIimP1zW33QoSw10WOrG2+eiyQNHgTyXP3rmlARO2/V+Ndi+3vemvujqKvKTq4dPwvE145lX6/EefN9lUrc344xeF196paiK2z65cu3Ao6psL2+j5Ufz9lWVcOEm5XCUFDMpEv0qkgwES6pnoqyyuMF6eY+66n9douKAgmOcYWH4IRcz4G+Y77pnbiPeFjBS5NQgc1Kh/sudQ/V7ifkQgUoG3y86YbFBPLUafOS101WU5FpoPmxljzKOdBR8ZgTlBTJ4RcLfBZjUvxo8ts2C4rIHRdkRfczYN35bAFDaXBI9jEVjQggsBZR13jkDJ85ZMy74Yb5yrgH3ml9WVo4cOgRcHxir0Cnfiqjow9d1RBw9Qp6eD8M6oH8whuk3i9TI8V/DR9nVekLQhlBh/Gm5WAW+AC93y/NUCraogxXnEJ2Goh4nCXY+3YAcqkt1MdiNeLai/P6Y7diSK3Y28yXPUyXIqxlWttF5Lc0bB+b1BLD85wEzFQUTuzSOmex6owYQY5gjnqXpFwNsT8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4c9fb1-a162-44dd-23ba-08dd1c3d8276
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB6873.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 12:47:47.1954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JKcIrUAPfmXkr6c6Xt6muSA/UAq6pHSdfUHbgclOqjcBLQsBl5aU0YX8Xu50bWmI9tvJD0xBzY5CJUuyJqAVFhSfOH2fz6gu5IS7iVEuiYe9pK/RWXsgFEfUwHh9Cpo7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-14_05,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412140105
X-Proofpoint-GUID: BAgSJfKwNtmbqK58PJQkcAzfGWOsIKkY
X-Proofpoint-ORIG-GUID: BAgSJfKwNtmbqK58PJQkcAzfGWOsIKkY

Hi Greg,

On 12/12/24 20:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.287 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
