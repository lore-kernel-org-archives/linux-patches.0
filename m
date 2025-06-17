Received: from ZRAP278CU002.outbound.protection.outlook.com (mail-switzerlandnorthazon11020073.outbound.protection.outlook.com [52.101.186.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4182EFD89
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 20:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.186.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750191813; cv=fail; b=GnLD0D9tMeTCaKdDw/w8kDBM/jXnumwR99pDG7+zvXCGdAlvgVMmv5OSEDJka8jWhjHIDrQRtGQOs0xlJ23yON40ic/9deI/KFRqZb+Df7DRf5w3asLeZni2QdjpMFvfG9KQbuvIbc8vS46ZjzVHDeya7RUgP6Nllsfh39sOeps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750191813; c=relaxed/simple;
	bh=tTT2JuvEYP7DlJWEXvzM0jzR7L/hxUJ9BPw0b4+vV7k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mfHr4ycLNL5wdiDf0WS5osatGBWsz0ADK0ieHzMYrDioLgML1H+7b5dn2s77V6UzHyc1sUv6CeLoF+Oy5z8dhkSmXmeoLysEQ2U2XY/gIKdekZ4RtJXt1yE3clPtXYTr6tMPc3w0iybw19KIxXdKvJsnyN8TS70HXS6oRO8avVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cern.ch; spf=pass smtp.mailfrom=cern.ch; dkim=pass (1024-bit key) header.d=cern.ch header.i=@cern.ch header.b=PIwcUT6t; dkim=pass (1024-bit key) header.d=cern.ch header.i=@cern.ch header.b=PIwcUT6t; arc=fail smtp.client-ip=52.101.186.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cern.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cern.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cern.ch header.i=@cern.ch header.b="PIwcUT6t";
	dkim=pass (1024-bit key) header.d=cern.ch header.i=@cern.ch header.b="PIwcUT6t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yc95rJhZAK+k9iRy684xVMTeDLXkzBK1VpSKCuC29kkn4Jg1qr1kaPpYI6rc4dnngZIz0ljj6Y01gwKCyKVhaLOYh9pBDFW4Qhq4XeB9wo0paTUBXjRIPG85MW+D3ske87EwrkLdmkgH2WkmqXZAi0VNbAH5gQhUhe5RgIVAODmCN0AAnSG9e8TaZQE7fauTNlFN4eRuOGhsQXmHIeIs2q62L0ePrEY0ryROOedALEoUGlUg0pzIYgucpkHCB3S+qFXo9s2uyANXA39Y8EuTQs3rNCWKHUDyUy2xIoj4/85jffvahoZ9ceLHQDwP/8hMs6TZNsP+nhQJZT0IyblSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGMR9MCZsKV86v9DuisY40+diuLb3hvp/t/chO8vZaw=;
 b=NM+13LRq5xUXj2DxtyHfTxunkr2aHgkYMCzKjoEJL5C9+8hCGqY2ch6an1XLQNqJufDk8/eIssU4Mo94iF/9kmcwaSldVP+E+PTB9XnaP/QkJzY/qBXJ7ZF6AyMXcL3eXJKJu54IIhVlUo/0uPBxGfI7wMZkLEPxMrIc7lsKeTWM4hz5OL5dkvyxCJBLEozBi2FbHmL5k8blYJ9KAdDT+C1F3we+lIeZuYLNQerSFHeKQi14CMVbE1WqAKSIFKl1cpeEtb7FmBCZI2ysX6knFMImjI9UCTP2LyPsYGBwxYFDT06LUlWet4NjYcj4icCoUG/Loa+MztJmLBHb71W0sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 20.208.138.155) smtp.rcpttodomain=broadcom.com smtp.mailfrom=cern.ch;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=cern.ch;
 dkim=pass (signature was verified) header.d=cern.ch; arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cern.ch; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGMR9MCZsKV86v9DuisY40+diuLb3hvp/t/chO8vZaw=;
 b=PIwcUT6t9dClAXLeTKm98jR07hmY6GNMtagTTc1NnKnCPn7dEI1StGmXJQHztwfS8BJcdMAN2hXCWbik86TCRXNMdr7EaaiZCBUhQLTYPA3O5Hw9tQSqtUxKaKjd2dZFdj4f8+45ahbs+SBrr3/QJuBcDO7HfmX3uie6uuK5McQ=
Received: from DUZPR01CA0038.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::12) by ZRAP278MB0786.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:4a::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.18; Tue, 17 Jun
 2025 20:23:25 +0000
Received: from DB1PEPF000509E5.eurprd03.prod.outlook.com
 (2603:10a6:10:468:cafe::d4) by DUZPR01CA0038.outlook.office365.com
 (2603:10a6:10:468::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.29 via Frontend Transport; Tue,
 17 Jun 2025 20:23:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.208.138.155)
 smtp.mailfrom=cern.ch; dkim=pass (signature was verified)
 header.d=cern.ch;dmarc=pass action=none header.from=cern.ch;
Received-SPF: Pass (protection.outlook.com: domain of cern.ch designates
 20.208.138.155 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.208.138.155; helo=mx3.crn.activeguard.cloud; pr=C
Received: from mx3.crn.activeguard.cloud (20.208.138.155) by
 DB1PEPF000509E5.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.21
 via Frontend Transport; Tue, 17 Jun 2025 20:23:25 +0000
Authentication-Results-Original: auth.opendkim.xorlab.com;	dkim=pass (1024-bit
 key; unprotected) header.d=cern.ch header.i=@cern.ch header.a=rsa-sha256
 header.s=selector1 header.b=PIwcUT6t
Received: from ZR1P278CU001.outbound.protection.outlook.com (mail-switzerlandnorthazlp17012048.outbound.protection.outlook.com [40.93.85.48])
	by mx3.crn.activeguard.cloud (Postfix) with ESMTPS id 4715C808A4;
	Tue, 17 Jun 2025 22:23:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cern.ch; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGMR9MCZsKV86v9DuisY40+diuLb3hvp/t/chO8vZaw=;
 b=PIwcUT6t9dClAXLeTKm98jR07hmY6GNMtagTTc1NnKnCPn7dEI1StGmXJQHztwfS8BJcdMAN2hXCWbik86TCRXNMdr7EaaiZCBUhQLTYPA3O5Hw9tQSqtUxKaKjd2dZFdj4f8+45ahbs+SBrr3/QJuBcDO7HfmX3uie6uuK5McQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cern.ch;
Received: from ZRAP278MB0754.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:49::5) by
 GV1PPF2245ECCF0.CHEP278.PROD.OUTLOOK.COM (2603:10a6:718::206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.30; Tue, 17 Jun 2025 20:23:23 +0000
Received: from ZRAP278MB0754.CHEP278.PROD.OUTLOOK.COM
 ([fe80::a1bd:d6e3:3211:9405]) by ZRAP278MB0754.CHEP278.PROD.OUTLOOK.COM
 ([fe80::a1bd:d6e3:3211:9405%6]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 20:23:22 +0000
Message-ID: <f390d9ea-b752-4a56-b564-ccba928885bf@cern.ch>
Date: Tue, 17 Jun 2025 22:23:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 277/356] net: dsa: microchip: update tag_ksz masks for
 KSZ9477 family
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Florian Fainelli
 <florian.fainelli@broadcom.com>, Jakub Kicinski <kuba@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152349.344636049@linuxfoundation.org>
Content-Language: en-US
From: Pieter Van Trappen <pieter.van.trappen@cern.ch>
In-Reply-To: <20250617152349.344636049@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR2P278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:50::9) To ZRAP278MB0754.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:49::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	ZRAP278MB0754:EE_|GV1PPF2245ECCF0:EE_|DB1PEPF000509E5:EE_|ZRAP278MB0786:EE_
X-MS-Office365-Filtering-Correlation-Id: 07f5b9e8-e0f0-4320-36d8-08ddaddcd011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cjA4L2tvTFFKNnlyT1FPK05xd3NxZkcrOVltTldwRU1rUmQwSE9hZS9LTWFX?=
 =?utf-8?B?NVBLdE9yZ3BNODFJQkVZWi8yQUk5YWJaWldRN1laVkp4aTdVRkxHZHpIWmds?=
 =?utf-8?B?RTlWU2Z5TEpkaE9QU3lDNFkzWGR0aWNYWWVNUVduQmZrc0huQzlSbHkwNVcr?=
 =?utf-8?B?NW9URVdwK0dGc3AzQlRLTmV0RXMxRlVxT0I4ejhSY29Vb3Y0NElwMThwd1pk?=
 =?utf-8?B?Witpc3lKQ1Z2dDlxb3JlRTNmVDQ2dk1jKzlpT0s2NW1Vc1lVaEt2Y3I5Ym9Q?=
 =?utf-8?B?RTNHaVpSeEI5dFBhdzBvRHNZNmd1MkF4N2x1Wkt5NWtjRzZ4Z2JDVGRvaHNu?=
 =?utf-8?B?MG16Y1drYjgzNFFnTGp3YjlYSFpxL1JBYzZlMmVXQTUrb01xcG1PMEdZcDZX?=
 =?utf-8?B?Y2FYbGtNTFYxa2NsZ1NldFV3VG5xMzIrRThxNStuQzF5NDdDZE5HZHEydW1Q?=
 =?utf-8?B?WXc5MW8xdW9NT0diM1ZRZXJzVUdkYkVlNGJFTFV4RmwwNnk0S2FrQmZnUmhz?=
 =?utf-8?B?SUF4TjdsbEQvdzlWajg2RVF0NXlMaldXNmxReDlyb2d4Rm1pbEpKcTh6QldO?=
 =?utf-8?B?bVFHTFhqbnBkY3dzczQvODVNbjA3MDRhRFJaUGVJTDhpTGNoVktPZFM3SzBH?=
 =?utf-8?B?bFVVK2d3TE1HeGxNS0tzUnpiVTFIWFZieUtaREdiNHJycWxBZFJpRUNrZXBn?=
 =?utf-8?B?eDdtN0R1SERpeEtsVXQxZy9TeC9CQ1lDd3lQRFlFY3JFd1I2V3FlTEc3WTlm?=
 =?utf-8?B?OHpCZmJMSDNsUG1RRmVYSmljWWtUL01xSDU1eW1GSC9INEx2Z09Fb2lOVXZI?=
 =?utf-8?B?VGNDSGxJT00xT3NOUDk2OFJwZTY3Mm9JTlpQbEZGWTVQaU5OR01KUG1qZ09M?=
 =?utf-8?B?LzRzM2JBaVBOTDhodzZ6MkVyTFBWVkdnK0xKZFNSb0VLUXZ4MFpEZFpHZS9I?=
 =?utf-8?B?NE5ZN2VkcjQrVmt2eGFvVVI5WUpnRVdQbUpVS3VyUFRVMHppeHRQN2lwODgv?=
 =?utf-8?B?STlIeVVzMUFyNG9IVGxHbkwzTVNjNE9PZWN2WmMreGhWd2p0YU5McXZJVi9r?=
 =?utf-8?B?YUlBUkFIUnplejRxaVFzNUV5TWJ4SmUyWTFEZktjMHdKUldYTkdEVUVXNFFr?=
 =?utf-8?B?dGhQL0tUQ3hGQkFOTnFqOG5lcHFGU054cW5Ib3JSN2lweTVVOUlkanRwQWdP?=
 =?utf-8?B?c216SVBMdkhzWk9ldmQ2cFh5aTlXRTNNaWVQVVpWSDFWd2s5eTBtWjNqa1lF?=
 =?utf-8?B?RUNoOGpwQi9DaDJlWWE2Nm91cGZaalRGbi9HaytiM05hSFkydnUvU09qQURh?=
 =?utf-8?B?TnVyc1VsNGkydE5NZG5ybU5wdHNqS3pyWHhreGdzTXRNdGtsbkdoR0xlYzlG?=
 =?utf-8?B?SjlXY1d2ZGRZTHRkVmxSakJyTWlySkN0YTBXazFid2wyODZ6cUFlQmRGTU9k?=
 =?utf-8?B?eERLb0V3SDlFNzlkQmQ3WW5BWU5QVkdVSXJ4Q1BBc0UydUU4dFdBWFRtU3pa?=
 =?utf-8?B?MDlZTDRZQTh6ZVhFZ0kzWUc5di83Wjdvb2g0T2V2YUEyaWZhbXN2TDdRNlJn?=
 =?utf-8?B?a21CRE1ZVk5DRmo3U3lYVDBpMkRQTmtLek1yODJMc0xMRTBwUnpaK3FuWXQ4?=
 =?utf-8?B?T0xKRTJ3MFVFVnFERjR3a1N6cmxsL3N4T054L3V1QWtUa1NwTWJzWklSMkZG?=
 =?utf-8?B?OE5Ka3NaSzZRWml4QURMVmxiWDFML3FZQWlqd1pQNkU2L3VwZEVIRjgzYkZy?=
 =?utf-8?B?NXVYVXpYQzRnQUpvc0NSZ1NKdlRqUVRhNXQ3WFZEVXZQRFUzSjIvQ0dwejZy?=
 =?utf-8?Q?PgxOVo16oehMfahM0FXVtNXagYEcmi0e9fYGI=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0754.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PPF2245ECCF0
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aa7343ab-e579-4d2b-8699-08ddaddcce7c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700013|82310400026|35042699022|376014|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGhvWk5iVzlIQzJqWHJDT0c0SVRxMEpXMnNQODYyTzl5SCtnL1pyUkpDT21q?=
 =?utf-8?B?OFhaMzVXN3RBYSttR2VCb1RXeUJRK2R1bWY2MDY1dDdXTjNhRkZzcU9zL01K?=
 =?utf-8?B?ZzNyRUlrNFc4YWhzYnhCdktLYTlUR21GL25hTzk4dlVBakdDNWhvbkg4bk4w?=
 =?utf-8?B?SGZpdW1YVm42NWNVVHZKTm50QzBkaHF5dVJNOE1LQmM4Sy9pekZoZ1NwR2R2?=
 =?utf-8?B?cDVzSDNraG9sN2tRL3Bibk9ybFZlOFJFQlBpM0hqV3NqeHcxTnl1U3FHY3FP?=
 =?utf-8?B?V2NzN2NaOXRCUkNIVUpUL2cwNm5yY0J2N3gvWTFzUnNZNEVLZ0daeWhydE9T?=
 =?utf-8?B?MjVxaGZuTVZxaStWbnNxYUhURlRSa0NNQ0V2c3BqOFk3elY5U2xVanFnK0RR?=
 =?utf-8?B?SUcxSjAraVVlZUVjbjllMXkzWGxrNnQwS2UrRHBERWpjR1RTbEJFMUd5c2dl?=
 =?utf-8?B?ZTd4Vm5pcEJzWjNWN2c2alllNEt2Qnk4cnpUY2p4UERWSjRzeXZ6a0RHQTRB?=
 =?utf-8?B?bjVoc1ozU2dleVNnSWJYZjd6QjVrWFlEa1dveDNhcjgyeEI3V3Y2aElwZlBU?=
 =?utf-8?B?VjZLZmlyOG41K04yeVRrSmE0M21aUFpjajFLRjVLZzJhQzRKNkJjWnkrcnM0?=
 =?utf-8?B?UjQxckNVSEFyeGkydTEyVk5HZVlXV25wZkNHNW9tMmRwVUN4TVN5UjJZc2pG?=
 =?utf-8?B?b2M1aUtrWG96ZnRTT2oyTW5JQUlQNnl5ckdxRGtCbGo1aWU0YmhVMk4wWWhr?=
 =?utf-8?B?MWlyR29RaUgyaWRXVHorejJlczhzZ0RRbmNKZ2hJdVhRR0lnYjVpRkMzWU8x?=
 =?utf-8?B?NUdmTFR5TG1NVEFrT0NNYlAxMklZQkt6Z2c3Y1JZdkQxdzM4a25iOEh1cmxo?=
 =?utf-8?B?NDVsdDlvelVsYnhDZ1dBb0I4MWo5NVlxWDh0RzlZdnBNYkJwdnJqVWZvZHRm?=
 =?utf-8?B?T1Jobm9KOGhndzErbm83Vy9CSHVRUDA5NStxbGRCQmhyT2w5N3Bzb0MydW9L?=
 =?utf-8?B?TlJKUis2QytyTnFwVjMxY1E5YTZUZjF5YUxHQVNoQW1VVER5Q1RMU2s0QnVo?=
 =?utf-8?B?TXVjc2xXUC9GbktmRUFObmtnaHo0SGU5UitOY2RtZG55cXR3NHo2NGdySUFo?=
 =?utf-8?B?Rm9xRWV0blBwUDk3YThxdFAvZUd2ZWxTL1pIOVdyNHJjVXNwWWQyVnlWS2RD?=
 =?utf-8?B?S3hQYy9yOWI0SGRHMFZ4Q0pEM1ROcVpzcjdhUi9URzk2cmRtNUVwVGN1RGlU?=
 =?utf-8?B?MEJGbElRVnN6RnBjZEVoTjF1S1JMN2s4SkYrZ1J1UmtLY3owOGhCanBjOWNu?=
 =?utf-8?B?bTIrSXBQaUwraDFTVjhrcTdrL1Arb0dvUHFqWFFRYWc1amtUVktmWitDRjV1?=
 =?utf-8?B?U09WN01BWTd1YytYTEJ5c1BOWWE1TVJOQ3BjTFlPVmhHWVloSExSNFVGZ1lY?=
 =?utf-8?B?dmUzcEF1d3NPK0JSOGZtS2krdEZ0Nkl4TGg5SHZkZ3k0N1pBR2FVc2p6dlhi?=
 =?utf-8?B?ZWlJNFdjaEpKNnJvUkFuVG5lYnZiQ1pMV0ZiaGQ4cVRHUjIweTJFVXNDWVYv?=
 =?utf-8?B?bm1sUlRzNGw3YTRBZmxFSFRUbkN5L3JPMWdKd3hQM0xObmxwcWpadkYxNVBZ?=
 =?utf-8?B?ZWxBeEF6VlZ6eFJpYnF4aXhyMFRFQzgrY29HNk1wTDlJbUQ0MktaL0x0aVZH?=
 =?utf-8?B?aUxhalBNbWRYcDI5UGJtcXp6WnZST2g4UDVNciswaHlhNmorM1NYWGJWT0NX?=
 =?utf-8?B?Tmh0LzZWNDk0UWN6TU5lME9xYWJoeTdUaE1ZdGF0TER5NU1IQkRpY1BLQklq?=
 =?utf-8?B?bDljSjczSVA5SkI2QkN5eGZFcDlWRlFvTXpIWjg1bXUycmhxTU1namc4cXU3?=
 =?utf-8?B?bURyUG92Tm53SVpTb1ViT0M5SXNpa2trenVlT08xN2huRmpWbDc2S1lhUFU1?=
 =?utf-8?B?TTFIRHJUU3F6WmNIOXlLS3Z4WmxyRlgveDJ0VitSU2dJTUF6ZjRTeHBUanpD?=
 =?utf-8?B?UmJiR2QrRW93PT0=?=
X-Forefront-Antispam-Report:
	CIP:20.208.138.155;CTRY:CH;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mx3.crn.activeguard.cloud;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700013)(82310400026)(35042699022)(376014)(7053199007)(13003099007);DIR:OUT;SFP:1102;
X-OriginatorOrg: cern.ch
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 20:23:25.0413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f5b9e8-e0f0-4320-36d8-08ddaddcd011
X-MS-Exchange-CrossTenant-Id: c80d3499-4a40-4a8c-986e-abce017d6b19
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=c80d3499-4a40-4a8c-986e-abce017d6b19;Ip=[20.208.138.155];Helo=[mx3.crn.activeguard.cloud]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0786

On 6/17/25 17:26, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

Hi Greg, no objection since it's a cosmetic patch really. However 
there's two related commits from 6.12 upstream that are worth 
considering and do contain fixes, see below. I checked with stable 
linux-6.6.y and they don't apply cleanly but resolving the merge 
conflicts is easy enough; not sure if that's worth the hassle and how to 
go about it - let me know.

6f2b72c04d58a40c16f3cd858776517f16226119
0d3edc90c4a0ac77332a25e1e6b709a39b202de9

Cheers, Pieter

> ------------------
> 
> From: Pieter Van Trappen <pieter.van.trappen@cern.ch>
> 
> [ Upstream commit 3f464b193d40e49299dcd087b10cc3b77cbbea68 ]
> 
> Remove magic number 7 by introducing a GENMASK macro instead.
> Remove magic number 0x80 by using the BIT macro instead.
> 
> Signed-off-by: Pieter Van Trappen <pieter.van.trappen@cern.ch>
> Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Link: https://patch.msgid.link/20240909134301.75448-1-vtpieter@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: ba54bce747fa ("net: dsa: microchip: linearize skb for tail-tagging switches")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/dsa/tag_ksz.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index ea100bd25939b..7bf87fa471a0c 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -176,8 +176,9 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
>   
>   #define KSZ9477_INGRESS_TAG_LEN		2
>   #define KSZ9477_PTP_TAG_LEN		4
> -#define KSZ9477_PTP_TAG_INDICATION	0x80
> +#define KSZ9477_PTP_TAG_INDICATION	BIT(7)
>   
> +#define KSZ9477_TAIL_TAG_EG_PORT_M	GENMASK(2, 0)
>   #define KSZ9477_TAIL_TAG_PRIO		GENMASK(8, 7)
>   #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
>   #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
> @@ -302,7 +303,7 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
>   {
>   	/* Tag decoding */
>   	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
> -	unsigned int port = tag[0] & 7;
> +	unsigned int port = tag[0] & KSZ9477_TAIL_TAG_EG_PORT_M;
>   	unsigned int len = KSZ_EGRESS_TAG_LEN;
>   
>   	/* Extra 4-bytes PTP timestamp */

