Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B693213252;
	Mon, 28 Apr 2025 07:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745826805; cv=fail; b=Lunz/+Z06M/iQx2X6llKXTAfco6uXM6Yp4JPM9/isgRV9U3p6Tej+8FO+2L5b4L5qyUZZ/RYKw6ZhcXe58XSVIRqmZMsZoKkRuCWUEKD8rm2or4/vq/20xhtMvqxSssOEW+MMTWMEfyKLjVkCS3apJ5GaMMKiUof/7/ZGaBrkcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745826805; c=relaxed/simple;
	bh=sn6Ylmr9oc89ti0sGq1CCzErrJ9Pkpj+Md9ovV+D2mE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OIYCZMwlsy6Ec9MteQcTiuGENow8UX4KQBzXT45TZIfpqexNBdlhZXrHN5bXTdNUBbEjQ9ILLJYE1kiDCyP4AK1kmTSMENIQQmWrL15C5fTeZPUirYbGG3w6tF9ISKZrxPvKbGD9SgV/vduooUzOJhxwbTnGwt2oZ//5Vc2wMqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53RMuJ5A016452;
	Mon, 28 Apr 2025 07:53:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 468pf92kpf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Apr 2025 07:53:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDy8tFYiYgg21fSwaR8c3v3eaKkg62krlmYgJHMfgYpo+hSF8SldDqtZKdstsE9OxtDiNwLgx7q5QoKctsNdFrFTZxzw7lvUG+WkNMfoob3Tk8yBsup0FFHZ9sdB6sI+3JKpWqk6TQY2rxMC3xnAeX4brq4uKbj8ARG6nDtat0dIqqA8zKtaO9dUOdw/ps2ZazaaCd+y5JWNKOxY+ySkkFr/A9BidUV+5f4kxa/YgzlvCl0xA+PUaaKzupVYAYmNwSrjB2Im8aKP9hx3J+r4KHEi/xxif631f3KCGBzW9RvwnzJ+xbZhRmCcgraImg5fo1oH2BWoHmkCDYMCEBKqlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4S961YOBI68wurTxNegjh2T7RSXnJrS4YjiafMQl2bU=;
 b=PIaePyHC3xLtMLlfiooBaThMQ7HnwIQ+uKpsQtU7zG9q5GEbW61ZucZy1eCB2l+s4ryAJNvZANLrCw6MGUb/QcSUwLlt2KFKJVHIh+5v0ASv0VsdvKKypho9FHgLnvTr8C8YpsT/uJW4FXBe2nvoWYK6DOrAZ4WN0RWzFiPiP1LyhEgbRD0XvJwBSndAMLokHYApU0zSbXnzDOzngPpL26/ibAznkvcu6db1KYpTL92/nm3dq8ml6x1VyQRt9OdrNdNkxfS+QF0zdgJvFr8kPrbhoe7WLhv6S2s7uCmyAMf2cDGNMZ6iRuLwPdFy3PT8dHl8jdmIkmF/Th2OAHq11A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SA3PR11MB7527.namprd11.prod.outlook.com (2603:10b6:806:314::20)
 by PH8PR11MB7990.namprd11.prod.outlook.com (2603:10b6:510:259::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Mon, 28 Apr
 2025 07:52:58 +0000
Received: from SA3PR11MB7527.namprd11.prod.outlook.com
 ([fe80::3133:62e0:c57c:e538]) by SA3PR11MB7527.namprd11.prod.outlook.com
 ([fe80::3133:62e0:c57c:e538%6]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 07:52:58 +0000
Message-ID: <b3f78f39-4c64-4957-8363-5b67c19a9f1e@windriver.com>
Date: Mon, 28 Apr 2025 15:50:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck
 <linux@roeck-us.net>, shuah <shuah@kernel.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <srw@sladewatkins.net>, rwarsow@gmx.de,
        Conor Dooley <conor@kernel.org>, hargar@microsoft.com,
        Mark Brown <broonie@kernel.org>, Netdev <netdev@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        Anders Roxell <anders.roxell@linaro.org>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "David S . Miller"
 <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20250423142624.409452181@linuxfoundation.org>
 <CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueUa9H1Ub=JO-k2g@mail.gmail.com>
 <2025042443-ibuprofen-scavenger-c4df@gregkh>
 <e77b24ce-e91b-4c90-82d6-0fa91fcce163@app.fastmail.com>
 <2025042404-playhouse-manual-85bd@gregkh>
From: He Zhe <zhe.he@windriver.com>
Content-Language: en-US
In-Reply-To: <2025042404-playhouse-manual-85bd@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY4P286CA0008.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:26d::15) To PH0PR11MB7524.namprd11.prod.outlook.com
 (2603:10b6:510:281::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB7527:EE_|PH8PR11MB7990:EE_
X-MS-Office365-Filtering-Correlation-Id: 45756da7-e201-47c0-a065-08dd8629b0b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YnZRazVUTnJNS0pVblFDdzMrQ3RQYUg3L0lRem5QVCs4QndtV3hBaG5nb2dX?=
 =?utf-8?B?dlp1anJZNlQ4aE5XbUJVYlNFUllpWGxQZjN0bWVXVkJJRFc1T2kxdGdaVWVh?=
 =?utf-8?B?bkJKcnVtK0NNaEdQVzJwUGR0MUd1ZzVtUDhjRjhMSllLTStvSHJvVFQ4UDRU?=
 =?utf-8?B?d2dwbHNKTlc1a0Rjd25DUTEwaERWQ05yR3BEQ3BXMUlXcTRJOTdNWVU4NVpn?=
 =?utf-8?B?SHVETkhqaXZyZnlKc085NVc5U0drL0UvemlLbnBGZDEzNjRpeWd1SUZMYlFp?=
 =?utf-8?B?OGhFV0NiRldUelNEdWZ3MTdDV0IydWxZZjA0NnZsT0VjNE55cU9yMmZLbjJy?=
 =?utf-8?B?aWxMMkdGdnhRUFhRRWtWbzh3cGV3SDhGM1lZWUZJQmxPMEszTHhpRWl5THVa?=
 =?utf-8?B?T0ZyUE1ub1MyNlh6NmI0SS9RV21rcU5uTkw2a1R0akZORW9tMEIxb2RrMXdO?=
 =?utf-8?B?aUtIaldPMEhOVWpnZTJVRThwemo1L1doakREbmxsUTRHbXdDeXJSOVM3TU93?=
 =?utf-8?B?Z0s3ZWFCQUhGUlVUdjVCa2ZTSG1oVDhJdVMxaEtuSm1NREdHUGQrUkVoc3FF?=
 =?utf-8?B?ZlV5elZveG10eFgwdW5kRVF1cFdNSTk2WmRGK0xVUVFENEJobmFBSGRObWYx?=
 =?utf-8?B?UUR6ZDRqejFQTU1aQTVFeEpvQ21qYTRiaCsrODVRcEtlZGZiVVlSRXdQZm1I?=
 =?utf-8?B?M0xsYjR4NGFhMEFXcjBYT3pzakV1QmRUR0p4RER5SmxhWithY1ArTFdCUjhi?=
 =?utf-8?B?Z1hZUW9mUm1VRFVWckc5OVpuWU5leUhiNEFtMFE3aVFuUnhUd0QwamlDaTFO?=
 =?utf-8?B?MUdFOEFjRlFpYUpjY3l6MDdmd3FMdEo2RkxQNEVyQndiZ1Jtb1dxUWJmajhy?=
 =?utf-8?B?VVRKQ3piN0NEWk91WEM0ZGdIaFJRcjdRaThmNGI2Y01tcmhTMUxjWkNtZStY?=
 =?utf-8?B?U2hacnBkVXdCbnFjNCtwQ3JxZUgxSXAyeU4xVzFqeDNyZFZkTHI2K2RBYzJY?=
 =?utf-8?B?ajNMcmJNeXVHaUhqWUxlR2YvU1BjNFI3djdTWVBXUS9FOXN5K3p4cndyV0Vp?=
 =?utf-8?B?OTFvYXI3VU5kYUFSdW10MTRiYTJWdktQSk83L0JHclBRbmh1T1dZQkRFQ3BV?=
 =?utf-8?B?aDlSZmpTNlo1K3RGVm5QTkMzOGZETFBuejFScjJqY1FVcWQrZ0NRVk5ONG4y?=
 =?utf-8?B?a1BsTkJiZDcxY0FEN0IyVVkvSDl1MEhyTVVuSXRjQ1QvQ3Z4ZTlCTlFaQmkr?=
 =?utf-8?B?N0tlUHRpTlRRM29OMHpkYWpwQzV1eng3SUNmcFhJdmEwQ1Y1anVIdDUxNkwv?=
 =?utf-8?B?S1dxbWJGUXBkTVZQOHJYdTJOdWpXN2EvRHE2ZUtFOVdWWm5rMXMwRWlSb0V2?=
 =?utf-8?B?bEVxR3RNdVdUdDZOM1hNV0tKQjhjemFPV211WTJya05MRHdTVnkrK1hVLzI0?=
 =?utf-8?B?cDNrbEJaUjErWHhtS1VVSWxNR2YzbUFoWFo5c1Bab2NNMGdpZUJ5bS9yN3Uz?=
 =?utf-8?B?OU5SUGJsUkVleWRuZWNYazFtQU5TTEtPMmZIUDZtaHlTU0F0clFMYWhHSkww?=
 =?utf-8?B?MEN3UUpHc2twYVVIWmVCYXNuRktFVWpnRncydU5STndINVRXeVRwTjJFYXU3?=
 =?utf-8?B?d2JCWjJSMm9yMkZBTm5HNUVwY0E2WXV0UCtlb0h0cUNmK3grZjNycWNTN3Y3?=
 =?utf-8?B?eFFITFNUaldpUmp0VWttRjQ1ZUN5clJjbUwrWFZPVjhYbWRCbXZGSHlhZ0dI?=
 =?utf-8?B?dXFFcnB5dklrVEN3M1gyak9tUE9WQ0lWMGFTZEdQbWpLSG1CTWh5TEt2eHNW?=
 =?utf-8?B?ZmlHWXllaVhRQmVUZzJFNWc4VGtrK3NRUGdzMTdGYlNqS2dmcytKQ2xiVGZm?=
 =?utf-8?B?UTMzc09rMTZRWURLRjZyQmlWZmZRekVJdExlTWFHaHdvNXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB7527.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnZkR3FGbnBkT2NjNjJBTGdML2NPNG8yYmpseUdOUG5LNHZValVXSnlRRmIy?=
 =?utf-8?B?Z2J2bU5PZmgwZVlYbkxmQTgxYWFMcjRGc21HcWNUV2dYU25YdDFrOG5ZQ1Yw?=
 =?utf-8?B?L2c3am95ZjRFRTU4MENEdTFUTW8vVUV4YzN6OWdzYzJyQm9uR21pYkkyZ0lP?=
 =?utf-8?B?SDY5RWpQRDNMV2hoOXIrUy9ZUHVWRGZZRlFVNHM3MHhzcEFCeTBHbGJJWGlp?=
 =?utf-8?B?dXR1RFhzK05wZlVKdVVtUE4wSUd5NlRYa1lMWEM3RTNGMlUvWG9jVjVqK096?=
 =?utf-8?B?dzFVcG1XRzlnUmxOU0NWTS8yOUxLRW1sTmpKSFV1MS9ON2ZsMXJ0UUt3S0Np?=
 =?utf-8?B?VUV6cS9TQ3ZKMzhWY3lhV0hQYWlTZWYvRkhzK20yWlBoL2tHMnRFbHp4Ri9T?=
 =?utf-8?B?dWZNL0lwZ1Y3d1hsZmZZc1VWWU5jc3RpdElTbmRlK3BTYjRHVkJCaVRGY0xM?=
 =?utf-8?B?cU1qQmdGWDA5OU5MWWpNdXBVN2ErbzM2a2ZVa01ScXc4WWdna2pqWEo0Q2kv?=
 =?utf-8?B?WXNGNi9XYnpLMitINW4wZ3J6ZUIvNTFsNHM5Rnp3K0ptU29ya3JGN2tUYkNM?=
 =?utf-8?B?a2c0VitUd2R1ZkFBT1dWd00zRFpUL0M4ZWhpSXJiM0RmWEFTaUYzM1I5MTB3?=
 =?utf-8?B?MVpJcy9CTWNDcHAydlVPY2ZKemxpeGhrS2FMK0FSQm9UbGVlMzFYdWhrK05J?=
 =?utf-8?B?bk1ZM3hURjdvVWlFOU5WTWJpdGt0ZENUZmptcTJiME1vNlhGZEE1SWw0K3R6?=
 =?utf-8?B?YlcrRDQvMEtvOFBxQm5TYjIyMzk5RFNWcm9kd3BORzFNL1lKQVl6K0QvNFhB?=
 =?utf-8?B?UHo2VFFPVHJFVEViem5xL0pCQW95QzY3VnJzY2I1TzBXeVRMcjA3L0l3UThJ?=
 =?utf-8?B?KzREMWJDY1E5MmFGTkNpOUxVM2dtNXV6SmVHVEovS1ZUYkNYNXhmVERpU2or?=
 =?utf-8?B?YUNTZFZBNVNhc2xXYytFSDdyOWpnWjRtU3dlNVZMTDFSZ1ZHNnVvLzE4N0JE?=
 =?utf-8?B?ZVVwTWx3cXdhMUR5NU1jWC9GbHR3bXBhaVdOdTIrZXZGN2VjWWtTNklXdmw4?=
 =?utf-8?B?ZUhmbEhjSUVmdG10V1g0aTNOZFBRR3RlUGJhdHhDTzFOM1BFSUVLb2lvbEx6?=
 =?utf-8?B?cEFqU3lPSmN5ZTFaRWovNWJFUVFQbVhtbVUyMktJN2RYVjhlV0FWQWd0b2Zq?=
 =?utf-8?B?SWozVDhlSlRtWUN2VEZvK09SQnJiZ3R4QjVTTENyeTJaaDN5NWVUYktLbnA0?=
 =?utf-8?B?L3BwM3RTbHovdlZ3bjhvUFNnL1hEWENCVk0yWTlTcWlVWWFqM2FZWHRvanQz?=
 =?utf-8?B?dFFhUnI1bWxSSGZqQSsxUWRhVW1zbTlldzZUbWhGTVJjL042T0ZTdm5kNmdn?=
 =?utf-8?B?dTRMeCtXODY2a2pwQ3NOTmh1eHkvd1FiVVBxMkp4M3dTM0Ntb212V1NOZEJ0?=
 =?utf-8?B?SUtWZTRUSDQwUXNkYlQ2dElVeVdVOHJZMWhNamRvMHVIQUczUjgvTDgvMkxN?=
 =?utf-8?B?UnhDdkJQSWJXOWVadlpvMDNwU1Z6TzVDbkQ5K1FOMFJNQXRTOHlCUFlWdDVV?=
 =?utf-8?B?UE40Z3NZdTJZMW90dzdSWnZIOGRmc3A5ODZjS1A1TGljZVArWEU1a1NrQjdo?=
 =?utf-8?B?SVRyUEZuRUNraUdacktYYktub0tBbXBkRHV0SEZEQURBV3M3N3JTWndFY2sw?=
 =?utf-8?B?eUdUKzU1azE3L2FLbk15UE1iN2F4dFhuNE1ZY3BuV04vK1RWQkgyMkMveGZo?=
 =?utf-8?B?aVlobHRDQlovWmQ3N3FIRjJTakF3VHB3dzBRcGNlZXUrVjg2LzhMS1NXRnhJ?=
 =?utf-8?B?OGJRY1hNODk2ZEIzQnU1K1dERjg2ZW5uczdBSEk1aVNsMEN4SXBOek1oYWov?=
 =?utf-8?B?TnRuSXUvZFRDcXBRdUJRSE42ZWdOQXJnelBjdU5mdk1QMTFoT0RUbE1sZ2lz?=
 =?utf-8?B?YWlkTDZPY1FrSlQ0REExRVIycUFkdDdkVGJPRjhmbFpLVVozUUNuajh4a1px?=
 =?utf-8?B?a3hhZ0RHMGNqa1RBekx2V3dNRUVUSHErZyszblFWK3V5Y0pLL2hGVlVTM0xF?=
 =?utf-8?B?bU1xQ3RJMGlLZ3RNK2ZMQUZXWDJUTUdOMFZVbkNDN041M2NNZ3VLNmV2Wk96?=
 =?utf-8?Q?Zycls0T2rNBuDj6oNizv3JZMv?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45756da7-e201-47c0-a065-08dd8629b0b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7524.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 07:52:57.9723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaCGizGxlLLkj53TlmCMI8n8gU4zKe+E5XeaGU5VdSGGyGSpAoHGSrLFiWsxPMuj1B3ip137EO5BbgCi8C83Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7990
X-Proofpoint-GUID: fHCe5HMd7_cCq8fbaTAaHjky90LVhdjq
X-Authority-Analysis: v=2.4 cv=EavIQOmC c=1 sm=1 tr=0 ts=680f33dc cx=c_pps a=sGbpJkUcFVeWJOR+0qTsNQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=BlBv2f2rG0pTCLRqT2YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI4MDA2NCBTYWx0ZWRfX+tAE85Rd+H4+ aYNBL9IsZ8vZ/S71iKdxyRgT7u0R0GkWO8kDEVKIQOk3QDmaVI1EQa6zloYZjnzv+mctPqHD1kI GOjCrUhfVhA2ImUeESc33F0fH5zD/HVlzCVoFQuM3Eux2QJQDhQugUqGKCs6aUay0aSNSk9YW7q
 wSjkYjHcVMlN9egt/f/wCVQH60XNnrXkqs2Vl72iQfqJTM7UEnslQOop+7ow7zR197EuRHHIvMu mCOoS8AGLAMVtyUQY7rbZ73uWvDY5damN8tnYGWToUDIfB6+YoAmRcAZx/gr46/H6zJF7cPloTB 5Z4FOItw2v3EPLT3FrDi3pPWt7RPEXuFm5Cpslvg5ERtAISPygQsTrd8EitIFrYmHaT9Vwiu8Om
 uawe+VxRHaVe6vypwA8+1uY2jfhKsMnmiKOhZnz53RRQENi3qfqHCBcDcUSct0yt2RMEDugL
X-Proofpoint-ORIG-GUID: fHCe5HMd7_cCq8fbaTAaHjky90LVhdjq
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-28_03,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 clxscore=1011
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2504280064



On 2025/4/24 23:28, Greg Kroah-Hartman wrote:
> On Thu, Apr 24, 2025 at 04:34:04PM +0200, Arnd Bergmann wrote:
>> On Thu, Apr 24, 2025, at 15:41, Greg Kroah-Hartman wrote:
>>> On Thu, Apr 24, 2025 at 07:01:02PM +0530, Naresh Kamboju wrote:
>>>> ## Build error:
>>>> net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used
>>>> uninitialized whenever 'if' condition is true
>>>> [-Werror,-Wsometimes-uninitialized]
>>>>   265 |         if (unlikely(!(dev->flags & IFF_UP)) ||
>>>> !netif_carrier_ok(dev)) {
>>>>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> Odd this isn't showing up in newer releases, as this is an old commit
>>> and nothing has changed in this file since then (it showed up in 6.8.)
>>>
>>> Is there some follow-up commit somewhere that I'm missing that resolved
>>> this issue?
>> I think the difference is commit 16085e48cb48 ("net/sched: act_mirred:
>> Create function tcf_mirred_to_dev and improve readability") from 
>> v6.8, which adds the initialization that 166c2c8a6a4d ("net/sched:
>> act_mirred: don't override retval if we already lost the skb")
>> relies on.
> Ok, that didn't apply cleanly either, so I'm just going to drop this
> backported patch and wait for the submitter to fix it up and resend it.

Sorry for the inconvenience. We have fixed the above issue found by clang-20
and will sent out v2 soon.

Thanks,
Zhe

>
> thanks,
>
> greg k-h

