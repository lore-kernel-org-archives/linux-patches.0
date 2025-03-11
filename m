Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2044.outbound.protection.outlook.com [40.107.21.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4FD22E415
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741683670; cv=fail; b=gj3QDCWvXd7ENfPfslovMs0TnheUZzCAcHZSkAwhPWrDiA79YJKFNrZoc2FqJC2wVOgsras6b4wkhuPWrQkRk+kLUOGbYvqB8+QsfLMi3zttynmIvRG5jcvI929SiT6WH2HJMxNvNupRt7a6sDXFI7JSYGDJA50MgN80l2Zi4E0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741683670; c=relaxed/simple;
	bh=wX0DbzmfoyldiGOZt1p3Inw0N5BQpMQ7wAg/PNwBQTM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kLITEXRsfXh9Bej6tk1D0RLiCGa87uiIfhIU7g641iotma8M6lk5/rcAT8Ok383AJIAcVxFjPlfXTIIjJGABg4PH98/NFoTW79YxDMiMDBpxOyyePclcomBasfjx4vFzU+/xY1OIbXAiiJTiJ9ZARQufDRWUFeY+PaQSx9iPsv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cherry.de; spf=pass smtp.mailfrom=cherry.de; dkim=pass (1024-bit key) header.d=cherry.de header.i=@cherry.de header.b=I7P/VljH; arc=fail smtp.client-ip=40.107.21.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cherry.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherry.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cherry.de header.i=@cherry.de header.b="I7P/VljH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yp6bX9pa71I3HR9gMvttA0ChX8Ba11M2nzEtj++FT+tsS2066NgF+oAxSdj1iaSLh8JLHI1CHLSNxirquSZP/jHben2WxKqxBfeUYwiRP7cTLnrAgCzkU8EfthWv11fyM1xR0qRQzQcB1UdelD0LY+mJicUtwrNmPaLJx+6d20hRRzKmdNy1g92Ra5bvZY2I4rcE6dRNfEiwsirj1zJZ77yjTsA0k1sWyo3AVEqSq/yq3tKM4Mq6ypQgpsOJIlSLrG+5P+mnWDJAtVk7KDuNx/6QYIrWqRfQqP0675ryfLy1bslwHs9zcjqPTgW0a7zO6ihxtbxZj3HFPcQnfyMgKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9LrznG2kNghNxdca79rWDVVqFyTONynWKzWPHfPCMM=;
 b=UJ91KEmcnekIVUEZvesI6M1eh76JE3aVRTnu7lD0DGjtRKFSAxZ350zO5DZ40p/cWU0FT6yk6Xh1XXp8xNvL6BO/rSHZihEdtV8c+aBjQRr/RrmpjLTcxMRe4LknmSGdKyRKPftbq0u8mRzJHm4v52ob1uDOA7SH9Quz82pzaZdoiu4dMAhpFEaA6bRok/m8EWfj8JRnYPyNFZBSgU/ZdsDZE5t0zClYHHb28EXFLBmzhvcijvfFBU5rEFCtIxBSE84PqcmfkIOaHL3EyQHjrzZcerbZBuLsPwrQg706SwuldVtBOt9VFDN4Ktnz+e4/rI2OaGcZeRpN3yokiXI+og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cherry.de; dmarc=pass action=none header.from=cherry.de;
 dkim=pass header.d=cherry.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cherry.de;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9LrznG2kNghNxdca79rWDVVqFyTONynWKzWPHfPCMM=;
 b=I7P/VljHvgLdLlbuhFTaoxxwoGq+EfZV455cZ4aDDkR7eY7TyVjF1MjlP4KWUfTfSDMOQ3VJClhLq6CjCunIdilg22BgWyIVlssLNdbAZYCtcpV10y+fJJ3bqHJZFAJSbY6h4KYmOesf4Pdbp6VPdM9hRxzD4oHLVtWg5G5bmmE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cherry.de;
Received: from AS8PR04MB8897.eurprd04.prod.outlook.com (2603:10a6:20b:42c::20)
 by AS8PR04MB8593.eurprd04.prod.outlook.com (2603:10a6:20b:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 09:01:03 +0000
Received: from AS8PR04MB8897.eurprd04.prod.outlook.com
 ([fe80::35f6:bc7d:633:369a]) by AS8PR04MB8897.eurprd04.prod.outlook.com
 ([fe80::35f6:bc7d:633:369a%6]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 09:01:03 +0000
Message-ID: <6fbfebac-2a36-4307-8e3f-3f5961fd12a1@cherry.de>
Date: Tue, 11 Mar 2025 10:01:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 005/145] arm64: dts: rockchip: add rs485 support on
 uart5 of px30-ringneck-haikou
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Farouk Bouabid <farouk.bouabid@theobroma-systems.com>,
 Heiko Stuebner <heiko@sntech.de>, Sasha Levin <sashal@kernel.org>
References: <20250310170434.733307314@linuxfoundation.org>
 <20250310170434.958553347@linuxfoundation.org>
Content-Language: en-US
From: Quentin Schulz <quentin.schulz@cherry.de>
In-Reply-To: <20250310170434.958553347@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::17) To AS8PR04MB8897.eurprd04.prod.outlook.com
 (2603:10a6:20b:42c::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8897:EE_|AS8PR04MB8593:EE_
X-MS-Office365-Filtering-Correlation-Id: b847c5ea-82a8-4f4b-7859-08dd607b4062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YnFmbDdLK2lWYlZoNlVDNEt2TmF0dHpvU2JuZkwvK05JUGJNc05TQVJJbXpq?=
 =?utf-8?B?UW1CdEs2MmFQeGp4OStZb3lQcHA2VENJRUppSnFTcElQKzVzSkVleDVZMkt0?=
 =?utf-8?B?cUdXdkRLbFZQL1hKWGtHdWM4Z216QXNmbUFGRHdsWWJnb1Q4Y0tLYTdoYjJl?=
 =?utf-8?B?WTZIVVRtYnNtcmUwL2VJSDZiL0FYODlZRk8rZ1FQZUFrUXVHNWFNUUtuZWZn?=
 =?utf-8?B?SFVDL0NOWlcxRXJvelljQmNGNUtQaVVyOFh1V0tyYWNUSTRjUEpWYzlmL3JF?=
 =?utf-8?B?WkZBWjVWbTNEZ09rT28zaU1PNTNJeE9PTVJUVnNpSlh1NGZ4c1YxQ0t0TG1X?=
 =?utf-8?B?ZFlsUnZvVzNyV29OazEzbTQxazdFM28xYVJ3Y0RNYnZTR29kV0NiUVRYdlRG?=
 =?utf-8?B?bmxvdzE1L29ObFAvUS8xZ3FTellwMkZpWmVGenBBbUZTajhIaUxDdmd1NTFm?=
 =?utf-8?B?WUltNzM4UmxiRjBjbUZ6Wk1XMkM2VVJ4U3JhUDhtTUpVNzhaaFc4SmorMjZV?=
 =?utf-8?B?Z1RualBld1VGeVZ6RWtmUFl3aDFGSnlhWTFBK0dyaUpEc3h0ZDhDdWdCUS81?=
 =?utf-8?B?cFpUOTg4bWxobHVuc2YyT1pEd01QRjJEOUtTa1NoT3M4Z3paNXh6eG5sWVBK?=
 =?utf-8?B?VEJuR0M0QUJqcGdjSTdhcnJtSUJiWmlDeGRSQXdRM2ZsTlYraVQrMGtkYUxD?=
 =?utf-8?B?WTlMTkx0NkJweG40NnFZb0Z0RFVmNm0zV3M0TWNWVWtLTm1jYW1vazF2STlZ?=
 =?utf-8?B?Q1R5RFg5TWtDcmZDRTBwbkFVUzFzd1FwZ1hQR3l6eDN4Q3Yrb2hBOUxpNWF0?=
 =?utf-8?B?R2lzR2lLYlBwSFE2UVo1c0dHcG1GQlJOUHpuR3p6aSsydnZma3Z0ZWsrM2JN?=
 =?utf-8?B?aThGYkxNNVVqaWh6eVdYZE92KzlNQnYyNEYwQmdXMWNJZ0VTVDVSNTIyZ0dT?=
 =?utf-8?B?OGhWcGZoRDhTMVNWaFRxa1p3dVluc01IQnNxZVdMK1hGMXg1UDVCRFJWWk5w?=
 =?utf-8?B?YnY3NFdpYUtpSnRUZ0pKaFFodjNMS3pNV01ITXZQMCszTUdpUk0rZWhVSmV2?=
 =?utf-8?B?YjA4ZG9hM0J6cVBmQkp3NUozSUttbFFSbERwWjNlNVJXUzZMWUdsV3JJQUgz?=
 =?utf-8?B?R3N0QVE2cU1XNWRlMWRtb0tBUWNyMjN3amFKR3luQ21TUEc1a1hXL2JPNUhk?=
 =?utf-8?B?eUZQQjM5NVhlZXIwZmdUcU5rYW03NkE1Wk9RVjBhMHd5RXNGcmsycVlyR3NQ?=
 =?utf-8?B?V1I0RE43cVNCd0F1UytNM3B5eE0zYXI3Z2lRVDE2MDNaZ3hwTnlRZlhxem94?=
 =?utf-8?B?c3llZDZ5RVM2NGRBOVlOVWtwSmdxZ2o4RFBIQ0wyeUxtdlZweFdVQVc2QW1u?=
 =?utf-8?B?K09NMzBZU2c0cWN4TnpBMnhMOEpmaklwWERMaitUSW1BZkZXZ2VZak1RRlRL?=
 =?utf-8?B?UGFpSFMwYUxUNklMMTBQMTIvdnRaQkJjdjZaaHJrdTJBWUtPZUwweWQ1UVIz?=
 =?utf-8?B?OTl3R2tpMTVPUFUyMGUwaVBUaHZwblBVNGJVRVVDTTdpUG1pRnNpZTJway9k?=
 =?utf-8?B?U3R0NFFIWkdPQ1RUL1phSGplZjdYakJYM0EvT2M2RXlEem5SeHJNRnkvWmRL?=
 =?utf-8?B?TWFObzF5Zy9DdFV0YVlqVExJWFRjYzFuWExabzduOStNSUtKNnF6bTBhMmJV?=
 =?utf-8?B?dUdUQk0rZUNCbU1CRUNjQXFWKzVzS0dOR1hYRHFZbW5HVngrWW9JWDFMYmNr?=
 =?utf-8?B?b2ZWUnR6TVV4SVhiTk9jV1I3aUZZMnVMckgyVkZScEVNdzVvejI2UkJjbUpI?=
 =?utf-8?B?N2xNL1dobnpORFMxWmlDZjExd0srU2tWVUhSaVR5SktUdEt0d3Rhb21XYXpM?=
 =?utf-8?Q?25f4inv0WtGuP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8897.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek1nRzQwVG9FbDlRUzQ2YUlUb1VVSnJwN25VOFZoczhyWjNlUkRKblVNeXVO?=
 =?utf-8?B?ZXhadXVaVmxzQjFHWjRXRXdTSjBjNUFHYXF0SWlYbWhnY25uUy9Rd0pkcFlm?=
 =?utf-8?B?Ukp0STUxMWxGc3N3L0pWcWdSelU0MUk2VzhBOWlRK3o2ZU1VcjNFQVRKVEg3?=
 =?utf-8?B?ajU4UTdjRjFSTHNYSml4dkp2ck5tVThPSGlyNDROT3d5M3lRQzI1UklPTDJZ?=
 =?utf-8?B?ZW16UnB3clZtRi9keVNQVGVXM2lHUEdWbjVLZG4zSTFJUVozSWR3NldXZzdv?=
 =?utf-8?B?NVI2a1RxWHN3dkpqem5DeUNNT3pFWkwyZWpJK2lYV25uM2pFaHliTU1RU0Js?=
 =?utf-8?B?dEFFYzRvei8wVkVKVHYzald6ZklvZUt5SUxGS3RrZnpZYnhuRUVwQjkzVFVW?=
 =?utf-8?B?N2lvOEExYkhPdTZqWnRRZEJaSWplWFB4M0dYMXM0SEx5cGxPN0NWV2JJNW1q?=
 =?utf-8?B?TXE2UjlNbkoyM244cGVnYmpTSEVQRHdZcGRSazhKTWZJcDBGUVYwN2VUbDhD?=
 =?utf-8?B?eUZqVmNCeTAwWlpaeFRmM0JqUEV0a3o3SmtHUm8xSnVyZzVmak5xVmJuQTZq?=
 =?utf-8?B?QmJoVUZSVjh5ZTk3MkdITFBkTWVHQWxoT3VZK1U5RS9VU1E4R1pVVUZpcHpo?=
 =?utf-8?B?K21aVzkwV3pYV3hENzU1T2FSUkdYMHgyWURDWnBNQ2JYVE1yQUxyc2s2KzAy?=
 =?utf-8?B?YkVoMlhISWVDQ3lrMUlhTWxSWGRkS3ladEp4aVRCRklFSWkwOHlNYVlsc1dt?=
 =?utf-8?B?bE0vbnVPdTJleUZlQ29IWHFuTXdXeFZmTlJMc2dIZldjVS9yRk8vc1J0ZFE4?=
 =?utf-8?B?UVV3ZFNHdUNpUUE4YTZGMEdKdkxISFlCY2JudVEvMy9tR3EvWm8zV2o0b3hh?=
 =?utf-8?B?eEZjSmVyOU1iVTVJVGNJRXZQbTBQd2JtbnpXRktTOEU5NmxLUHFsVFVTeVd3?=
 =?utf-8?B?amVuNEIxWFFLTUVOeDdzVU00bWlUL3pWQjc4TnFoUm1xMTBncmJiL09oN2xK?=
 =?utf-8?B?VzVReTRBZVpCQ0ExWHM0ZDJHRHpkdm5DdlFYK1JnQXhJTEpJaDg4MExQUFJM?=
 =?utf-8?B?YlFiS243WWJzZnFrNVVEa3JIcmFkY0FseUJ2bUhmdHg1M3MxSkNhdlFkQ2Ur?=
 =?utf-8?B?Rkx4M0ZMK2NuL1pQK0V6T29UY0RPemIwdjNDWGhIUDltd3FYaTJyclE1bVVW?=
 =?utf-8?B?YUZXMW1sMXh0REU2Y0tzVjF0Wmhqcms1d2thRmJLN2dpdkkwMENHWWkwMVJF?=
 =?utf-8?B?L1BlZk5teWQ2TU5VcldydEpibmZZdVlLb29SMUE3RmZVbFlKMGpDeFc2eVkw?=
 =?utf-8?B?RSt0Y2c3dWpldEFZRTdoSXV3b1hWYTB2ci83NGRRaGpBYWZORGQvYXNwRUVk?=
 =?utf-8?B?bEVUOFdXQnJ3V1FTUUFnVi9MczdIcnZhRkZBc1ZheDlORlB2V0NHdGdFNUtB?=
 =?utf-8?B?V1NDdFVwNFJ6MHVUdkJ0REN3TDI1WVcwamltSE9LRzI4OTNFdjUyQjVRcTZQ?=
 =?utf-8?B?Q1RvK3REcjFRRjdvU0hiMEExRk9jNjlSekhheHpQbklxQ2ExMTNRdHJ6VVAv?=
 =?utf-8?B?dkJyR2QyTnUxczEyRkFZZjRVV3p6ak9CTDlBcHN1R0dtK21lZTFwQVNiM3VU?=
 =?utf-8?B?VWRrZGlhNXY1cmhHdE5vMDB4a0I4aTBjbWFNTGdXTHF6S3dNaEY2bEJjU1Rp?=
 =?utf-8?B?YWlZbXZpWlkvRno3TEc4dFNPZmQrd1RqaVptYmx2S3ZSSGtXeXh0cnZmaXNx?=
 =?utf-8?B?S3RXSFNidnRhN0pvcGxXRVorRGtWeGt1bnoySE1JQk1XRzRBUjRZc2ZMY3Rj?=
 =?utf-8?B?ZTlaTnBmb2ZIbGI2TEt0VnF5NDQ1a3BXK3Y2QWFVdnppd1BUUGNvaHpyejJK?=
 =?utf-8?B?NFZnRnVZOHNaS1gzTUVJMzIxWTVZenhuYkxZQzlrSldoOUxVM0lhb0VTUmk1?=
 =?utf-8?B?eDdwZisxWFpLOGZFMnRQZWZxZitoTTY5SGhTc1NvRjUvNmFpT1BtSnY3bXdQ?=
 =?utf-8?B?MDdRZDdZSVZ3N01nUHdwdE92c2c2d3IwOVp2cVpJQm0vZlRwR0FXT25sMWlF?=
 =?utf-8?B?U0lMVCt6aWhScHg0TXJTVXpCK25yYmYwNSs5L2IrYWpxdDN0TUNXQjg1ckxn?=
 =?utf-8?B?RDZUSi9TMVVtenREcHVxMkxGaWVKWVhqdnFvRlBxMWRXQXhZeUlmRWN2WnVI?=
 =?utf-8?B?Smc9PQ==?=
X-OriginatorOrg: cherry.de
X-MS-Exchange-CrossTenant-Network-Message-Id: b847c5ea-82a8-4f4b-7859-08dd607b4062
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8897.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 09:01:03.6736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5e0e1b52-21b5-4e7b-83bb-514ec460677e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1eW0IOEDjfp6JzrGTN0BwppRaVEQ2J5YxfxSJ+0LnAPkJNM8JkX2KwteZw/39+VjnQWJffEGSWaUKKtw0E67VM89YoJrutxEjC//m45NN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8593

Hi all,

On 3/10/25 6:04 PM, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Farouk Bouabid <farouk.bouabid@theobroma-systems.com>
> 
> [ Upstream commit 5963d97aa780619ffb66cf4886c0ca1175ccbd3e ]
> 
> A hardware switch can set the rs485 transceiver into half or full duplex
> mode.
> 
> Switching to the half-duplex mode requires the user to enable em485 on
> uart5 using ioctl, DE/RE are both connected to GPIO0_B5 which is the
> RTS signal for uart0. Implement GPIO0_B5 as rts-gpios with RTS_ON_SEND
> option enabled (default) so that driver mode gets enabled while sending
> (RTS high) and receiver mode gets enabled while not sending (RTS low).
> 
> In full-duplex mode (em485 is disabled), DE is connected to GPIO0_B5 and
> RE is grounded (enabled). Since GPIO0_B5 is implemented as rts-gpios, the
> driver mode gets enabled whenever we want to send something and RE is not
> affected (always enabled) in this case by the state of RTS.
> 
> Signed-off-by: Farouk Bouabid <farouk.bouabid@theobroma-systems.com>
> Link: https://lore.kernel.org/r/20240208-dev-rx-enable-v6-2-39e68e17a339@theobroma-systems.com
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Stable-dep-of: 5ae4dca718ea ("arm64: dts: rockchip: Disable DMA for uart5 on px30-ringneck")

I don't mind the backport of this 005/145 patch, but this Stable-dep-of 
commit has already been merged in 6.6 with a conflict resolution, see 
bcc87e2e01637a90d67c66ce6c2eb28a78bf79f2.

Cheers,
Quentin
