Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2139.outbound.protection.outlook.com [40.107.22.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE3914EC47;
	Wed, 16 Oct 2024 05:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729055180; cv=fail; b=GpQjTcwZ0BlHwMHvW4BUABjJlat8GMHkfsz2Jaswd2Tw5jObuD706wo19zrwfQTuyJuXgCfq6gAS6oSxBKy/bONJrWdkH0BNJZini51AD2KLng1lvBg1fN/6y/Xfg04tfJlEfhYSyAr3MPMl+msMdcb8+3VKeCSZ0lo7r+gNiRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729055180; c=relaxed/simple;
	bh=8R6eDn1eaNIfHChUh6YzHbS07Tx8sc+DJqACGm2rmzo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rnimD97mEKq5nsdHxFNu1RPHgnVRM1uA8P0TQ552lHM8Li78xhA1winhByEW44CBysI9RZpMP5lGed/YX2LKe89xCtbCzK4/uTmXoHbIBtZm+cf5hokBI00IKzxOkmQQ02yuV0C4/0z60vUB8RluQIcXdGDLAiRjrkMSYMGQ3kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wolfvision.net; spf=pass smtp.mailfrom=wolfvision.net; dkim=pass (1024-bit key) header.d=wolfvision.net header.i=@wolfvision.net header.b=uJ8WpXQP; arc=fail smtp.client-ip=40.107.22.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wolfvision.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wolfvision.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=wolfvision.net header.i=@wolfvision.net header.b="uJ8WpXQP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cix+GdF50+9M0Si2nYJt1QUHBLheEcU+C0Kyyqn9PTjArqdPJGod0+hQh35kX+PfotdsxLSZci0npQJbXMcwXq/w3X8PEF7DzQXHa9hFCR2+HDfciM8RmsrUPn5Tti2SW9OlkF3FRDIdDZXJsGLtB5MGn8RHHZAAPqrdbrbRsRgIO786ZX8CDx10jO0ZJFWWJOAUxa5epUbU3x7iWIbOOVyO6XlbvpCzGFTtTCrB/uNpUhpE7G++6jtD+/oJKtc4tgFxmH39WGv3We28fHKJNireiFUTN7MZ1WDB6Rotc43RfJFeAlSQ3AIxp6EOUmWg0bCylWkWq74ocSpwWDDE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SLZd1tqM2wPlvejjhhuy9dLVt1gY2l5vxPl1bsCh9Y=;
 b=P9/Hf5xmIGfUKkqbBihgc45DJ9zFkbQ2yjnbw55qc+qIDH+DWstUDhAllBEUqFzfDp2JnHiYf7v8hvnECN258FvkTbRMLuVDmZmOzWeSJG53YZnqpNna0d1H6B593rSdjXvhlzzEK/nOZqZbkcTos0c1Go4x4y7npz5NtDyOTkds1BW8DVyZFoEwQTBwZyrKj3TDbwDt3gEyCaC9rdbYni1QgIjIuySokJczyZOe6bDTcrZIWBrj1vnZD0bDtFNidwauZskfTEyjuNo27LyMsOQT5kdl5o1iK4sYIOD7gCuOUqe0DpOk0OG+mhYhF1rJGrbUdVO3McV/nyDJVC7w1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wolfvision.net; dmarc=pass action=none
 header.from=wolfvision.net; dkim=pass header.d=wolfvision.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolfvision.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SLZd1tqM2wPlvejjhhuy9dLVt1gY2l5vxPl1bsCh9Y=;
 b=uJ8WpXQP3fqOgKuiWLLKMBoQQzPrclJl1sWzAvebOpJlYYgqaa8zo0pW/qwdkkXd36xSiqajaxZ8zv80gJT5EvLb/uYBYJVuCfQpJmf29JLy9APaje/d7wnrfRRZKbPiIzJFNKTqDsff09usEx98GJCupu2Ajq/bi/ewe/QZ1q8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wolfvision.net;
Received: from DB4PR08MB9190.eurprd08.prod.outlook.com (2603:10a6:10:3fd::21)
 by DB9PR08MB9636.eurprd08.prod.outlook.com (2603:10a6:10:45c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.30; Wed, 16 Oct
 2024 05:06:15 +0000
Received: from DB4PR08MB9190.eurprd08.prod.outlook.com
 ([fe80::c7a:6978:9afa:19a4]) by DB4PR08MB9190.eurprd08.prod.outlook.com
 ([fe80::c7a:6978:9afa:19a4%6]) with mapi id 15.20.8048.020; Wed, 16 Oct 2024
 05:06:14 +0000
Message-ID: <14a202f2-aa79-4171-9f39-fa9eeec21823@wolfvision.net>
Date: Wed, 16 Oct 2024 07:06:13 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] staging: gpib: Fix PCI header include guard
To: Nathan Chancellor <nathan@kernel.org>, Dave Penkler <dpenkler@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20241015-staging-gpib-fix-pci-header-guard-v1-1-dfa45fe8d63f@kernel.org>
Content-Language: en-US, de-AT
From: Javier Carrasco <javier.carrasco@wolfvision.net>
In-Reply-To: <20241015-staging-gpib-fix-pci-header-guard-v1-1-dfa45fe8d63f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR04CA0137.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::35) To DB4PR08MB9190.eurprd08.prod.outlook.com
 (2603:10a6:10:3fd::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB4PR08MB9190:EE_|DB9PR08MB9636:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cec11fc-aa81-4655-e3f5-08dceda0427f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWpXek5JbFRwVTlYQmZRT25IYk4zeDdpM1FPeGNJU2gxb2lHYkhlVlhRSTNU?=
 =?utf-8?B?ZEZXTXJ0bXNmOUI5NmRMeTJvQU92T2lGaGcxL01OSkxVcVJBbDFEeElZZTFj?=
 =?utf-8?B?UGsxei9XZERDeDdmQnZrQ0FRMjV1bHBuNUZqOEJtNU5UdHcwV3NLcXIvT2xE?=
 =?utf-8?B?eWpnZEw1M3RoSjcyWEpTemdScEw4VVM5VmRPYXRhOUVBS2JqeXJNdEpVb25Y?=
 =?utf-8?B?K2ZpRERnVWQzY05zRjhGbnR0eUNweEVFQVhOcXc5SlNNSDFjSTRIZ3QyNks0?=
 =?utf-8?B?MnFJanlhUDFaOUk0VkVuVVpzRGwraUVHQ212R0xUWVVuV2piUlA5UDVjNThN?=
 =?utf-8?B?aUNOR0FKVVFRUzEzbmJvUysyc2RjanFIVnJSSlpCNm9EWUJQZk9XMU9pSzZi?=
 =?utf-8?B?WFY3SHRVZ214NW1aKzVzL2NWWWdSUWlVeWd0dWxkeEtvVVJXd0M3VUVzYUpT?=
 =?utf-8?B?RVgvWmNobmNFc0dTeTVkNkJhV0I3Y3BKMWl1Vmh0TmJiOHZXVDNEczczMTFB?=
 =?utf-8?B?MjhDNmJOazk4MHQvd2NaMi9MZmMvNDR5NkFmdnpzYmFLcGx2UEcxZUVhK3B0?=
 =?utf-8?B?ampyS2JuZ1ExQTFSL3REMUErVHBtOGhXbTM0TCtBTGtSQ1NSRlpZZytnaWFy?=
 =?utf-8?B?d0lIUEV4QlRZTVkzOGJxejhKMUpUYkpEd0lmMHJuaHRXT0ZwOUFSSU9sQStC?=
 =?utf-8?B?cjdtTWQzYnlwSXEvRGVFeU1IZ2d4VVVlSkd3VVlwandldGVDeUtIN0hiNXNG?=
 =?utf-8?B?Nkpka3o5cXB2cTFKejdEWVhWY3VZYmlUcHZYSnBpdVNrR08vUWZQWm51M0xD?=
 =?utf-8?B?cTRsZ1UwRzREYTNBQUN4ek9oZ0ltUHNTYWhzb2dGTEdhc0hTci9TakNWUytB?=
 =?utf-8?B?cDlYSHRzSUIydWVkQ2J3bzdQZ3JMOW52V0xHSGs2R00rSm9QZHo1VGRwOFFs?=
 =?utf-8?B?YnlYblBYMExiaEYrd1FNRkd4VjIrQWlkdGZWU2dBMmx5YThoL0U3NXByU1N2?=
 =?utf-8?B?N1VaS2tYaXhkQmtvdDVERWZhNmVZMXN3eitDU2pwcEswNm5rVTFRVGt2VGtK?=
 =?utf-8?B?RGtMRHVVZTUxakVzQjdxWHJ2NTFYL1JvRDFjRTRJc2s5bmlyTnZXekF5N2g1?=
 =?utf-8?B?QmNYTmxINkdNZ0FGVUYyL21vcGZ6NG01cE51SHowVFh5K1BMNzNBekNXTDEv?=
 =?utf-8?B?MGkwcTFPTjJIQVdQQlVHSExNUHZSQzRlSkNtTVpZMGFGeTY3NUdhdkVPeC9z?=
 =?utf-8?B?MThsMVhaYjZBSnNjU3FiUFZQZjVTUDRyOE94cGI2c0QvWW5OQitRcnpPWmEz?=
 =?utf-8?B?VEsyaUU4Nm01VjEzUHYyam8zOUtYRjRodG80czA5UHJ2bTFlYXgvSHkzM2I1?=
 =?utf-8?B?UUE3N0hqMjQ2MzJNazdkYnI3a2NBTnIwRHl4MVdFUUhWbm4vOFV4NWlGWnJR?=
 =?utf-8?B?THYrZTBiV1V1anR4bDlwUU1hRWRseUhReUNrNG5xNloxaERGV3ZQZy9NNFF1?=
 =?utf-8?B?eDliQ0xZcEY5UXVIY0d3Tk41a3FZRGhOWk1TY0RmUU5VVFN3UXliWWI5Nkg4?=
 =?utf-8?B?MjdzcjhaUXFncnkyL0pRM3l5bnhhc3B2MVFkUHpoZzJMM2xKRmdVK1c5VlBL?=
 =?utf-8?B?UW5ydmxyQm56Um9JNVkrbWdnK3MxMFU5SU1aRzg5NUZscWNCZUQrK2xDR1la?=
 =?utf-8?B?Z2ZFZTBEZkpLWTVSVFhhVlpMc3FzQ1lSb0syci9SM2JMREYzSWdwVEx3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB4PR08MB9190.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFhGRG9sdUc4eFAyUGFhSW04TkloUlUwajNwOFJuekZ4KzB5YUJ6SGdmV1BZ?=
 =?utf-8?B?Z2pRbmRXalRiRjZDZHByVlhwaHRrZ1pIQzU0dHdKQzliaGdnREFQY2t2OC9R?=
 =?utf-8?B?aEg2WU1FcmluZGl2WGZ3eHFSTzdCdkhBcmorNi9vSEdXbElaSzBJYzV4Vk5N?=
 =?utf-8?B?ZmxLQXNzQTlzenhPNnBuZWJPeEZQakxtd3kzZ3hCWmM5VFViQlZxWWVKRXJK?=
 =?utf-8?B?Zzg5UEdtRkVZVE1IcVlVY0VJWVFFdXpJdENZQnA4STlrTXovbVFIdjFZK21u?=
 =?utf-8?B?SG4wQTZ5cXYwYVBHTWQ5MVNOTGJWRmpYSGFSWk9RUHNlWk1LTGtLVmF5Wkxx?=
 =?utf-8?B?VVd2QzdDdTU0RnpDbitERFFJZno3S0liL0pzNW94TUV1Mm8zeGlxSnhtN3Ix?=
 =?utf-8?B?emsvNml2K1BVdDRTeWhla01qK2E1TVR6d1BvanVhckJKZjFKbnJLd2dnbU9L?=
 =?utf-8?B?bG5Jc2ZaL3VXcjc5UXNEVWZ4UjQwY2JiWkhYZ0xGYUZYS3llWi9HeHV4b3J2?=
 =?utf-8?B?TElCWEtiektrM0lLNXJwQW1zRG5rYkplRWRGaGNGSFdQak9oeDErc0ptdC9m?=
 =?utf-8?B?alkvWTU3TnNzb2tGeFhNR09DNXJ0ZG4xSEtRZlQ1MUtjMlFUc1AybjZBVUFE?=
 =?utf-8?B?cFdKY2JybW80YlpMZTFVb0czL1B4WWhCRHNLVEJhN1UvZWRCMjlrOTFRZnFN?=
 =?utf-8?B?Sm9mK3pQSC9uYUJzczZQWVhDc2lHRGR6cXQ4NkNjRXdwSS9nU0dyQkNEVUo3?=
 =?utf-8?B?UjdTbE5CTzA1RVRMcEdwYTIyRXJYV2NwdFJ1UDlBSUdWcnc0azlxY1BzWW5i?=
 =?utf-8?B?TmJxYnZpZWNVeGU2WUQza1UrOVN1enF1UjVMbE5NcTVCZG1GTWhLeG1sY2hH?=
 =?utf-8?B?R1Y3cUVZNkdENmtQTGI5UWlwdzNxSEgxS09wdXZldG1pOWhKMWY0QU8vcVE0?=
 =?utf-8?B?by8walozMCt6d1d1eFR6UGhNWHRZOGsrbXhOSDVyajdpcmQzaDB3SWlrWXNE?=
 =?utf-8?B?enhrTnNOWi8vdnQ0QWx3UTVELzhYWFN6N2c2RG40R3FoVFAzQU5pdlE4NHJE?=
 =?utf-8?B?TVVFd0tyZkc0MXVDTkJBejFydjRDRFhZT1BoL2ZBV1BGYXlVMEt2L3ZFdGRv?=
 =?utf-8?B?SFA2RDU5ZXJncXlpL1B2cVM4VFhTZ0ZaWGFuQnFYMWZjNFMyL0hEM05uZTRD?=
 =?utf-8?B?Sm45WHZlOFBNNVI5Y0dpQllPc1UwQVZwazJMVWM0S2FxUGorSUFOcFlTdi9Z?=
 =?utf-8?B?c3FLaWdGNFlScm9SZndkeGpBTjF4WThJQVFrNU93YUJzSFlQMW1CZkJDRko0?=
 =?utf-8?B?aUQzUWY1SC9MdHdvZDlhZUQwa0JqR3NLN2JVeWlZWkgwK0F1SjJQVk9xL2kx?=
 =?utf-8?B?M2xqNnpEMnNRYlNWZDFuZ3VldnlNRk13S1p6M3dlNWEwRjE0Sld6d3huenhR?=
 =?utf-8?B?WVRnYmNKenNsWWo4b0YrVnJnK0JxN0F6SVFydk9nVDg3bEZCcGNDZkV3Mlp5?=
 =?utf-8?B?Rldoc3paYSthRDZFVG9xTFlJcWJzSHRIMHhpSXNCS3NDNEtYcm9JYUZHZXdK?=
 =?utf-8?B?YTl0ekI1VmpkaW1HL1V4YWtOcGowWm5iUlRueDloem04VnZSNWpVL1hMZFhI?=
 =?utf-8?B?cCtUVllBbHB4V0orTE01M2x0U2JUQ2lnLytGSllFK3dhSGk1U25QNC9URmQv?=
 =?utf-8?B?QjhLRkhHVmg2UUVETUV5MUZ0d0xlMWNwTFlMekNEckhqeEcyQ0xBZlJtakRo?=
 =?utf-8?B?cWI4SVJodzh6YitwWC9VRVJ1RnAxcXJXQjB3OHVyUVFicWVHbThYSzVSWkNJ?=
 =?utf-8?B?ZzVPaEoyaTB0TWFBTmJJRXowNTZNaksxTytkcjdZY2ZLTEV6dmdmRGswSHBK?=
 =?utf-8?B?THJ4aCsvNVlRQ1JLYnlPbEEwc25BM2pZRjg1MVVVaFZRSjBIaDJ0bUJUeVZy?=
 =?utf-8?B?VXVkYStrbG95OUMyRTlHNUF3bDNMWm5xTXhiNm9SaEpwVElka3NjaXJTdFBD?=
 =?utf-8?B?OWk5bTNuLytGRVpWNFl6WURreEVScGRKaVo5TTF5QzVpcWZwL0NnUTVZUW0w?=
 =?utf-8?B?cktnWmk0QW5ycXdwVU1Dblptc3RsRDdVTGFObkczRWRPUTZLbTRFdVgwMVor?=
 =?utf-8?B?ckZuck5WS1dFdklrekRLQkx2NWIvVG9nbWhBZ1hWdUkvVmVaaXo4M1BxMFU3?=
 =?utf-8?Q?JmGrBmrd1aR1uBc8+0DSwfw=3D?=
X-OriginatorOrg: wolfvision.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cec11fc-aa81-4655-e3f5-08dceda0427f
X-MS-Exchange-CrossTenant-AuthSource: DB4PR08MB9190.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 05:06:14.8607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e94ec9da-9183-471e-83b3-51baa8eb804f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQBhyHq2LuyH22V6THQPIEjhj8eNlzA2E93BaFUrH8NAuLhj3UFHB+r9JV7pCuczsQaOOO8au/dvp4y5U22LWFHMblIgM6MIcfSy4u1Nvvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9636

On 15/10/2024 21:55, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   In file included from drivers/staging/gpib/ines/ines_gpib.c:19:
>   drivers/staging/gpib/include/gpib_pci_ids.h:3:9: error: '__GPIB_PCI_IDS_H' is used as a header guard here, followed by #define of a different macro [-Werror,-Wheader-guard]
>       3 | #ifndef __GPIB_PCI_IDS_H
>         |         ^~~~~~~~~~~~~~~~
>   drivers/staging/gpib/include/gpib_pci_ids.h:4:9: note: '__GPIB_LINUX_PCI_IDS_H' is defined here; did you mean '__GPIB_PCI_IDS_H'?
>       4 | #define __GPIB_LINUX_PCI_IDS_H
>         |         ^~~~~~~~~~~~~~~~~~~~~~
>         |         __GPIB_PCI_IDS_H
> 
> Fix the define to match the guard like the note suggests, as that is
> clearly what was intended here.
> 
> Fixes: 6c52d5e3cde2 ("staging: gpib: Add common include files for GPIB drivers")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/staging/gpib/include/gpib_pci_ids.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/gpib/include/gpib_pci_ids.h b/drivers/staging/gpib/include/gpib_pci_ids.h
> index 162b02deb0ade7ede08ad81ebd41a79727374448..52dcab07a7d188925a4d696d6b658f397f3b0153 100644
> --- a/drivers/staging/gpib/include/gpib_pci_ids.h
> +++ b/drivers/staging/gpib/include/gpib_pci_ids.h
> @@ -1,7 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  
>  #ifndef __GPIB_PCI_IDS_H
> -#define __GPIB_LINUX_PCI_IDS_H
> +#define __GPIB_PCI_IDS_H
>  
>  #ifndef PCI_VENDOR_ID_AMCC
>  #define PCI_VENDOR_ID_AMCC	0x10e8
> 
> ---
> base-commit: e0eb7cc4d70d672cf9344916aba58136fd6e495e
> change-id: 20241015-staging-gpib-fix-pci-header-guard-997bbc923818
> 
> Best regards,


I just faced this issue when compiling linux-next/master with GCC and
allyesconfig. Renaming the guard as Nathan fixed the bug.

Tested-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
