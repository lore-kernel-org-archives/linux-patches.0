Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013064.outbound.protection.outlook.com [40.93.201.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E6E15B971
	for <patches@lists.linux.dev>; Sun, 18 Jan 2026 07:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768721413; cv=fail; b=CoHp4RKvWh0hSNXqiINnAPg9Q0MiuGOcJ1eQquR2HUGZHeCPUciWurodV4yDn87ifCkCuxHhDv6nGHr+JhUl3Mvl3pzZMyiMgznx7SXWmbIFZmGkHbyrxnlVRm1H14JXmUe/YzBPkqAgQTeNW+AABu7Djm0CLTuBNF/JznO09f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768721413; c=relaxed/simple;
	bh=PYxEiwcVdNDlu/DqN2aEzk3E1Yjn+aROLfTEYtqFSrk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WZFT1fkWDJtxoN9ZUmi+RIiep+iF/bP1VNDJtUUVERT13PE0YFZbdBqHdGm0xziNFaqZCnfmKrtRv5AauUP7QRYjpq5YVliQFlsq6162uYzYaIxp0Cey+4J0IQ6miatXvW5yobHgAB3eH53RQFqB8JYeSayYeen+mmvoMvr9apA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d0pvL8t6; arc=fail smtp.client-ip=40.93.201.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d0pvL8t6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pFCGc4iNm2n/rVXCdJ1LfPhUnAtM7OZKuqJxcVErUtyQenGRhYxTopWGXaZluhV9+58Awqdw5h2w4Df2JR/v71ajp/qVZYR4JP9+HnrrqZg7Nu0BEqVWgtQUV49gcrZDs0PEePu1CSEfT/LpHQ0vsD5TttGwOIVj4ymBv/ojGkQHIXfOx4PqmBegy/K0cwQwcdTgman2C3K66xmSSxMB8n9cJH7yB8LS0uwAPcMKZVsVooCexgnRhv0UFGZofek+c1cWBh2uEPU7qyiy9NjzTMVsphksXuQWMWKezl3ogTc8aDrcwbWkmfsDr3EGYbnK9CBJXhMwLXJmJ6xgbmD4lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHBqHbL690tibbuPBdsBFfkbW2azGYK+Vm+eTCnYGdc=;
 b=VvlYq+Up9mQW5PdAV/3bORxwR9OaKYDGBp83ph7tcVOrEsgctCue30DBHh5nMuiY8mJUQ2D8/5oFFbJ6EJ9C606+7zfcWtA5qtaQma+dhC+Qprb57FUacvVbJbu9Edj1BCKY2wl+gEjhGrBtGRs0VUMJMDmlk8A53vutvcDrEWKONOpHAWFjawflA5RZhKeorEKdgKDTJ82dbR9+uMnyt0ugGj60SuAjeRqCHqJ+Eg54HcKig37zXgKhWG7kjY4apUPkJ+flQkUKeO69Y+KhHyBwOToKV1l0alQH6TMLYF2Qv4QviA0AG9FFsEHFmVCQ09+/F28fAqKeNQT8a/cH9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHBqHbL690tibbuPBdsBFfkbW2azGYK+Vm+eTCnYGdc=;
 b=d0pvL8t6ZzOEL81fPok1w5moTCFSjQS9NURXQiznbpZZZtkEdvZH7x96dGjEXCf+NBuqu5n2ycpUoHSU6LOpALwWLKxH9NQwmlM7PhgxfZ4eodlae70YhwmjchRBIhQRl7I9ifUHMNssQfKiJOe2FfSSMj7EDFMU+QjbCIrwq5MbE/aW7acBR7W0bW+M96x/0lAtesIAqT4rS9iGRvyQnfRq/oAjL/l0QibQLHnGQyx9q4PFxW9nQyKvcG5KlxLTZTzpj2wP9b2budRdqkvdfX+vQjK9zgI8AH7hxCXv+JdQpj+dMbKzY6sP1PzAOpCP3sl1AAXcdE9do6sQMXXW5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7003.namprd12.prod.outlook.com (2603:10b6:806:2c0::10)
 by SA1PR12MB7248.namprd12.prod.outlook.com (2603:10b6:806:2be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Sun, 18 Jan
 2026 07:30:07 +0000
Received: from SA0PR12MB7003.namprd12.prod.outlook.com
 ([fe80::4099:396e:1f40:169b]) by SA0PR12MB7003.namprd12.prod.outlook.com
 ([fe80::4099:396e:1f40:169b%4]) with mapi id 15.20.9520.010; Sun, 18 Jan 2026
 07:30:07 +0000
Message-ID: <5f6519fc-adf1-4418-beef-251e4a930e48@nvidia.com>
Date: Sun, 18 Jan 2026 09:30:02 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 183/451] ethtool: Avoid overflowing userspace buffer
 on stats query
To: Ben Hutchings <ben@decadent.org.uk>, Paolo Abeni <pabeni@redhat.com>
Cc: patches@lists.linux.dev, Dragos Tatulea <dtatulea@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable <stable@vger.kernel.org>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164237.523595757@linuxfoundation.org>
 <188e82d04a1d73b08044831678066b2e5e5f9c3a.camel@decadent.org.uk>
From: Gal Pressman <gal@nvidia.com>
Content-Language: en-US
In-Reply-To: <188e82d04a1d73b08044831678066b2e5e5f9c3a.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::18) To SA0PR12MB7003.namprd12.prod.outlook.com
 (2603:10b6:806:2c0::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7003:EE_|SA1PR12MB7248:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b264c8c-9f76-4fac-2416-08de56636781
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RkhiSDJ0MmFCQkJhYTNwVDNuOStFVDZXa1F4MUVna2orR0pCK2Q3K29JZm4v?=
 =?utf-8?B?aUoxaDg2M0R3U1hCN00rSnFUcGR0VExwNHd3UjJIQThFekxINGNzWjhpMVl0?=
 =?utf-8?B?OVJ6VkhiQ2tqeG1Cd01TMUlBdDhiTXcxOFpiMGVZWGlRVEJvL0o5cnphQ1Jq?=
 =?utf-8?B?cGJCRjBHWWpmbTFGcXZUN2Q4TllId2IwdmYrMzJMRGEwZklCa3VRV09vc2ZL?=
 =?utf-8?B?aUo5QkRsdmtzd3JhOHZBR2dyMVlCOXNkM2IvZTV0c1lRWjlFRWVOWmozTFBk?=
 =?utf-8?B?b1FDdXRLRWFoODdMNGdTcVhtbXNqQm40UTU1QmRqVVpZcGpiZi8ya0V2Qzl4?=
 =?utf-8?B?VlRFQ1k4V2dlNFY0NmE4M1B6SUMvNEtVMDhQNEYzZXF1R2RWWTlkaUNlS1FU?=
 =?utf-8?B?MUFmWGFtV0x3QlB1b0ltb3ZESW9NWmEzUDltaXVVZVhuU0lVNVBwVWlEQyt3?=
 =?utf-8?B?Nkp2NVpVclFtNHhrRnYwZXhlbUpTQmNMc1lGemJPTTFKdk8rOGQ5ZTMwUXRq?=
 =?utf-8?B?MTRBN1JWNXJYOGZ1VHBxMEJhWkU0U2lXMlIxWUZ2dGNmWkFUTVJBQnJIL3o3?=
 =?utf-8?B?TTBxOEYyWkxnWHpLOHV1UVk4NHhUOVhVQ3c4SkFGeE5aRGtFZXkrNmJiUjl0?=
 =?utf-8?B?dXZsakNrUWxJay9wdFg2ODhqLzg0WTAvZGtiemJxSTdWR2lFanhNQ2pJQWx6?=
 =?utf-8?B?am5LNmQyZnVGTWxRaHFvZzNLM1RzRVBETFFvZHU0blFuT1lxcm9uSFdyM2o2?=
 =?utf-8?B?VHdvc0lBL01BUFlTNDlYT0ozZjFTYVo3OHBYQlhwRlJXeS9vZlJweSt5ZXpk?=
 =?utf-8?B?ejFsd1g3bFZFYUV6dWJyalFtQk5tZWRHTjFxdjVrUTl1RDRhUnhaWnBBMFdU?=
 =?utf-8?B?YXc2VVdMUHNsa1BYbHkwUmkrc3VzWmlGSFNRZENJUUpsNklUams5QzJpMjNk?=
 =?utf-8?B?b3JLeWpYY1dDS2dmSWplbEptQ3R1MTFkT0Q1VjhnRjkyTUpvV3UxNDdpRnYv?=
 =?utf-8?B?cWhOb25aZ1VtQU5nZzhJa2Q1eU9OL0RVYnBnbGNvdnk5YTRid202cnR5cW4w?=
 =?utf-8?B?NmprVFBkN3dwU3VpU3o5cFdET3FYeVdza25nK290WDI4aGNESEJRQ055K1Vx?=
 =?utf-8?B?Mjd1YkNPOWlKdGpTdTludHhhZGRaOUo3ZFkvREdBbDg3WjBFN0hFT0VscW5t?=
 =?utf-8?B?cHlUV21Pc0p4YzI0V2tZQVJRYjFOcEhNUUhtQTNaMXUwR0QvdFBxNDJKb28r?=
 =?utf-8?B?MFdSVk1Ydnp2bVozSUloRG1nNHlCV0FRVFlvL2pQMnliNXh1dkZ4K2ZnMCtW?=
 =?utf-8?B?WnBhUjBVRzlIeUlrYUl3ZS9QbnFaMFlQYkxiK3NJdytQS3R0V3JnSFVMcWhq?=
 =?utf-8?B?anRmelQrMkdPbGxWelNxYTd0SDlBN1JYOHNVek9QY1JiTU5Wc1dtT1ltRU9S?=
 =?utf-8?B?YndpSW05V0YxQUtyZitlTVNtMWJIYmtZVzhNdUhGaW51UERvbWEzd3dReVZp?=
 =?utf-8?B?cW9FYk81cnBNdGZqY2VPT1oxSmZERG1QRWFHNkI2Q3UzQVU2UlFveUVxRTY2?=
 =?utf-8?B?b3pCNmY3cnQxRVpDSTR5Ri8yVjkralU3NHZvSGVISWJhMW1JVFg2VUpQSm83?=
 =?utf-8?B?cFpYcWRlNWhLdVF5NU1EbngzM1pDemZwT0EyZHpYZUxPdE5rRnNMWFQ2UVNO?=
 =?utf-8?B?U0Y4dFl6TkhmZVIxMnpJZEdwQ25aZFhMb3RrMzNlRSs4Nk9MMGZIWGR6Ri9v?=
 =?utf-8?B?RlpJYStmQVRUWVZHQnBBTG10WTRqY0VrVGIwd01aR1l6N3ZyS3VhSWxPb3k1?=
 =?utf-8?B?YkxYckRNblkwSndSUUhYS2ZnaCsrd1FZclp6UjZsQUk1RW1uekt1ZXJRZEhO?=
 =?utf-8?B?S3dReW5iT0R5b2hxNElGaDlsQlU5dEVuTkdOOGlKby9pK1pDaGFzSFBRMXp0?=
 =?utf-8?B?Q1VYdXRMeElYZ2VQb21XWm45YWRDc0p2bDFzV2FwQUJlcG9ldkZFdHl1djFw?=
 =?utf-8?B?VnVQcUJqeFJTREdpSm9EdEkzOEcyQ0dUZmpzZ3lwVnQvVGY1LzF5c1NKM3Ev?=
 =?utf-8?B?cnZaMjBlTkY3Uk5IOVdTQUE1ajRVRWxOdTBaL0s1bGdOUHdNMUNpbG1hVjRX?=
 =?utf-8?Q?50EQMfKoA2HYtOZ3xOo8uTQTS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7003.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3hMcWpVOUV3QTVRekM4aWdyYmFSejlRRnp0K3BYWWRydnVieTg1bmZWSis4?=
 =?utf-8?B?aWVpcXVFV25IczYxeHNWUDVNWlNGVnhNd1BKc0dtdUdBMFpwOXQrOW5MN1JI?=
 =?utf-8?B?Rmc5TmlVQ2dWUmdJV3pacDhHV0ZPdVNwWEYxeU9xZlhqSVpnUFhBSloyRHVk?=
 =?utf-8?B?NXFkSURMS0o0QVNsWmNZdGhiSzliNW1KWUJCa2VPZXl6RDY3bStkVC9oRWlK?=
 =?utf-8?B?SlZjNkI5Vld5d0o4MFROOHFkamlBdHpKRnlJUndMeW0yOHF2OU1QRXR6a3Zu?=
 =?utf-8?B?WGtDOUExc201aHhmNFpRbUJ3QkxtQ1NHVnJDRU9mdG1iL0dTMnNYMGJGS1hU?=
 =?utf-8?B?OGdGTGdyQkt3K0NDWE1nUnBvTmlmWTFzbEJXWWluelQzZ0xYRGpCelJXcDlt?=
 =?utf-8?B?UVN6dlFuZ3FOWWlHcXlFMlRkM2Y2c25iOU9XbXpFTitrbzNwdWJLRUt0UWVX?=
 =?utf-8?B?VnVwQ0JyZDhMTHU2NnVlcDE2M01rTUUrTUVSa3YwcS9BNXRaekhRZ0IvMmtH?=
 =?utf-8?B?U0pnMytLRmhIUlA5cmYvNkRFZTRvbmszRTAzWEd2ZndZNVd5eXZMVnk5MHBU?=
 =?utf-8?B?N045NG9UQkwycW1ua0pNWExyMzhPbVpRSVJaZzdCNDAxNTFoYzN3UVJIOGxo?=
 =?utf-8?B?R2huanNYUUtMUWJYclBCejRueUVKWXByYWM5OEVRRGZPb0I4b2dxY2d4cHlZ?=
 =?utf-8?B?NUx2TEF3QWlhcXU3NUhJamhlaWlDOGRQMjc5MEVzTXBMMisyQWNTaDdNMHZu?=
 =?utf-8?B?V0xUVzEzSjNjb0szYXhKWlhydUpScWkvcVpRYTBOemVjMmhoWlFpNFBOTTFT?=
 =?utf-8?B?TDBqYVB5b0hBVi91UW1vOGo0d3VXODU5TEZoNEN6bDQxL0FoaXpHYU1qeS9j?=
 =?utf-8?B?UkZXR0R6cUJsUkZUcTBjYUZMRHlvNlFrT0RFemNkbHhsZGdzaHNFNllRcUpk?=
 =?utf-8?B?M09xZWFVWkRScnV4bnpNaXF4eU15eE5HOWZ1aFovNW95WE1tQ29XdjYyRWVW?=
 =?utf-8?B?eTNyaVFXVHZuenk1aUFNd1lhOUQySExQamczSnBIbTk3RWU1MHAwalREcDZa?=
 =?utf-8?B?OVVLMkl0QzR0TWlDcW5qUlpwcW9nYmo3US9qb1VPQkdueEJCQkhabFkyTlRP?=
 =?utf-8?B?ZmxjNGhaR3Z4TlJQUUh3N244UFdGSm0wSmFYTis5MDJMREMwZzBsNi9MZ3g0?=
 =?utf-8?B?cHZISVNKU0dGdGxmR1Bxek9Qc0x5QXNRU1hkWUhqT3hwM3Z0RHVrTnhIRjVY?=
 =?utf-8?B?VytqUzErZzdQejhGRk1Wbkw1MU9nY1VuWGNtVzJIUmlOMGNsZjRCQXh5azVI?=
 =?utf-8?B?ZnpWT3BNVFNpQUtDSlc5TVlPVFRHaTBNVkFWcVFkU2p4ZnF2dG44Vnd3UGFN?=
 =?utf-8?B?RFJqaHJENjZYM2EydkZFOG1leHlraDg5d2tuZS9yc2E2OC9HTWZUQTU3dWxM?=
 =?utf-8?B?MzJ0OTNoNDdyRFo1ODNlRTlDcGRxVXowNmZjS0hOdVg1WjQzV0ZLTWZ3cDMr?=
 =?utf-8?B?WDc5M2c2WTAyWUpqUURuQjdhZVNiUDg3KzJzMTM0R3RkZWxYRXpwU0NZRzNH?=
 =?utf-8?B?b2Y0WXQrUWN3clNidm5ZY1dnSGtCM0VBa0RzTE1WRDkzSkFrazNJYnpxRGcy?=
 =?utf-8?B?cE9uL04zUjA5YW1YMlJHeW1HQmFUVi9SWE8vQkhkS25tZlJXdmMyTmlnV1Jk?=
 =?utf-8?B?THhRWi9KeWdhZGpwSWJMNDdBL1dUbW9LSzE2RkYraWZwcFJ2VmFRSENyVzB4?=
 =?utf-8?B?YXl3S1RRUlg3cEhTaXU3cXJkUEVzd1RkeFFZS3grZVNjRzNEZFRZV3RnemdW?=
 =?utf-8?B?NDdxK2NhVHFuc0pBMTkvUHgrYzRDck5kNXVlMG13ZENVNVI2T0pWZ1dUcnlG?=
 =?utf-8?B?OWEzaTlkMWQ3NnVRMWczR2pZNFd0dGhzVDFDMFB4YmJ5Yy9tUWhWeGl6YlFO?=
 =?utf-8?B?Y0pmZnlKMm5zOWlWMWhGaUI5L0dlbHQ4WXVvYlR3NWdkV3lvZkNnZVllcE1w?=
 =?utf-8?B?K0RFaUZuQ3I0YUFiL3FTNFdoTTBkWVFhZ1lMVkVuSkdUaFl0cXJMV3YwSUh3?=
 =?utf-8?B?VnNqbmNjeWdUQmdISjNtaXVjZzA3TVI4aWN5UDJqTXZMTXJBSnBnUTFZUUor?=
 =?utf-8?B?djgyd1NxbVRIcUZXTzRsbjQ1R0Y3M3pQeERDTFdyb0FBdFZBakZ4N3VJYTlB?=
 =?utf-8?B?enNVbVVjWHJjQUladlU4VnkyWW05QkRpc1ZOOVZzU010SWUyWnhyUDMwZnBy?=
 =?utf-8?B?ZFdYT1lwSEtJRzBNaVBZQUV6aHFBaTdBQUt1eVRrQld5eGorcmxWSkZ3ZHF5?=
 =?utf-8?Q?U9euPeLuWiQpy9Fe+F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b264c8c-9f76-4fac-2416-08de56636781
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7003.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 07:30:07.4213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAnH4Q4c44dzJCCjaPWKUdw8IPPB3omlSKDiOaXnHfOQcWLDMYyXUSCG5CHAiFJa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7248

On 17/01/2026 21:58, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:46 +0100, Greg Kroah-Hartman wrote:
>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Gal Pressman <gal@nvidia.com>
>>
>> [ Upstream commit 7b07be1ff1cb6c49869910518650e8d0abc7d25f ]
>>
>> The ethtool -S command operates across three ioctl calls:
>> ETHTOOL_GSSET_INFO for the size, ETHTOOL_GSTRINGS for the names, and
>> ETHTOOL_GSTATS for the values.
>>
>> If the number of stats changes between these calls (e.g., due to device
>> reconfiguration), userspace's buffer allocation will be incorrect,
>> potentially leading to buffer overflow.
> [...]
> 
> This seems like it could cause a regression for the DPDK driver for
> mlx5, which sets ethtool_stats::n_stats to a "maximum" value:
> https://sources.debian.org/src/dpdk/25.11-2/drivers/net/mlx5/linux/mlx5_ethdev_os.c?hl=1324#L1324

The maximum value is actually the number of stats returned by the driver
(see mlx5_os_get_stats_n()). I also verified my change with the DPDK team.

> 
> Everything else I could find with Debian codesearch does seem to
> initialise ethtool_gstrings::len and ethtool_stats::n_stats as you
> expect, though.
> 
> This change should be documented in include/uapi/linux/ethtool.h, which
> currently specifies these fields as output only.

Indeed:
https://lore.kernel.org/all/20260115060544.481550-1-gal@nvidia.com/
