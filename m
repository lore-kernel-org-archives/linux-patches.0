Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazolkn19011026.outbound.protection.outlook.com [52.103.66.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E2528505E
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 01:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787275967; cv=fail; b=st8215j3dYpxN/VvXaybnobWp5OaPl1Oad2oE0Vgz16eRmxyRgkzFDTqgapzpi/j064CLGIn+c6iXAmUXen3GJDnjSl1pnIF+txZ6BAxvK21cRKz9yoQjl2FKih1W65EcHczDao6YPiAlmqsfPAcRGBIiHnYjEp0/TOgE9UW1PM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787275967; c=relaxed/simple;
	bh=lRCKbCrK4GQMU8nIWsX52fAgdBHwA3gUjqz194jtKDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wu/K0uzDCo3Ute12+Ld+5i7S7RyMG2UYZyEClhFi6kkUiumjzVovDvvAjcNLWDUQKmazOKONafCZpUOqb25AQi0esdtT9dPCRbiDnAqZqvZKWbRw8mF382+LqaPbi8JascPn4VgWi3+d7YCZfzEFlDQkVaeq5EmUfqQqyX/vVI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=RLSQhb5e; arc=fail smtp.client-ip=52.103.66.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="RLSQhb5e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f37qBg1ij+Kc3CKR+znTTjYfIqYxcCcVvUxX0mPXhTuPSuDco5W6XWVNlE7i4k/N3x2skAvielGzzCQ7vcrwfq8URESVb9oOzkR2ep8xrBbJ6Uc17XawIk9eeTlalXWEnFJm+ZVwBvDL0tatuYka75nAd2RCUmMmaYEoBDbxBxWhILDEdtAyPE+51Vx6Go+5JsXxyw64c31qnDs/YAE0Yz0nYj3eb+gYEy1YMBw5AsLGpMAu3u19kCnlqi2lF94pUfjvhwHkx8m8BCG3pUU6YnFesxTlTSwuuumBmibFu8h/gM2GNYNvi9JEkI9yxob//WmTHo0Kzhy0YYDpOTmiJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfhV6VXFe1cxpuCq5r2DkshmHOH1SkJqvltT8ky3gMs=;
 b=jy8tQjarikBGA0TzAYC2if8TcpV2Zbnv/BPcP7D44x420tm1HTGywFBDyLIDXRSiN7JYUQJMdkcHf58LVjNeS4cI45mp2ANQIQVyyZpZXZboav2SLZERw4o1KYDI4LqucSqGaAQ+OoMerEcKeEprTUSOtGcKg9ayAzEGtuITn3ZwHb5NkVhwXO4lnDmN7jFys+vjrAI+MrjDgUP8gvH7vFD23xUZ5Wlxl6QhoJbuEb5ebFxn05xbzxh3+Hv5SpsXA1R/niRj4ZuWbk7VvOtZlFWK1vfp7oPKRZ3LXrxSZ7FmLKjjKxHLIOFhdVqqVEytDUVGglK0H7b9YdmmWTHZGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfhV6VXFe1cxpuCq5r2DkshmHOH1SkJqvltT8ky3gMs=;
 b=RLSQhb5ennYpxEkFkYSpoPqPqZZ80LKe9tqoCafeRiwOyLXYwHYXpoC3bVn9ReJwOppkjug1BVcq+lllFVfjwV7z+SO0x2YD2dOUs03Qs5Gs7E5TwaDOpDq96Eec0s6+nA5ibqXIZsifxR0PfM0sDh1P/KSUgrY08BlIT7DhAKdU40U1/3IiOxyGzpP7I9rYAnaWm7h6rttrpkERlyoy3mqlFu279pSm2zStCFMWkJ9lfCF2oEhnGyagyYs64y2C9fpiXi4Xz1DYVX+lV0kMkeJB25uL0DUdhmWrPAMXIgLH0ZNjXv3OH4giE/Yj0a3vxWDqIogHncj62Q8k1iBYIg==
Received: from OSZPR01MB7795.jpnprd01.prod.outlook.com (2603:1096:604:1b4::8)
 by OS9PR01MB17844.jpnprd01.prod.outlook.com (2603:1096:604:448::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Fri, 21 Aug
 2026 01:32:41 +0000
Received: from OSZPR01MB7795.jpnprd01.prod.outlook.com
 ([fe80::7a31:a23c:129f:8288]) by OSZPR01MB7795.jpnprd01.prod.outlook.com
 ([fe80::7a31:a23c:129f:8288%4]) with mapi id 15.21.0339.008; Fri, 21 Aug 2026
 01:32:40 +0000
From: Shiji Yang <yangshiji66@outlook.com>
To: gregkh@linuxfoundation.org
Cc: frank-w@public-files.de,
	horms@kernel.org,
	kuba@kernel.org,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org,
	Shiji Yang <yangshiji66@outlook.com>
Subject: Re: [PATCH 6.12 090/337] net: ethernet: mtk_eth_soc: support named IRQs
Date: Fri, 21 Aug 2026 09:31:32 +0800
Message-ID:
 <OSZPR01MB77959549273821C1F6A75832BCA32@OSZPR01MB7795.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807143420.466574387@linuxfoundation.org>
References: <20260807143420.466574387@linuxfoundation.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0196.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::6) To OSZPR01MB7795.jpnprd01.prod.outlook.com
 (2603:1096:604:1b4::8)
X-Microsoft-Original-Message-ID:
 <20260821013132.9828-1-yangshiji66@outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7795:EE_|OS9PR01MB17844:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ecf2d96-7193-4b17-321e-08deff2416a4
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25010399006|15080799012|22091999003|24021099003|4140399003|5072599009|24121999003|19110799012|8060799015|51005399006|23021999003|3412199025|440099028|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AA1nq00nmjjqwxjmXO+Ty51mbNV8USPdz0XYLhigoHYTRNF0vw8SnwCdtfP1?=
 =?us-ascii?Q?qXZvz6yHWEQkBpOUWvxCVb0BOTzTZJQDV6b2WDv1lVZkJmILuBL2zWg0J7Tf?=
 =?us-ascii?Q?KEcObO4X6Fs6goJwugkjktQ/dESQdd55JzbYVwJFZ4YoyPsWW2AyYRcctSD0?=
 =?us-ascii?Q?vGqSHDaOeBP4Q/nyjXC8b1FtY4ov+WYIEuoeuESFNfgFsqkHMX5lX+5vqsOE?=
 =?us-ascii?Q?GMj8BuMKyiuI2+kMzjY9MdWUDgSK4gXWGjyUuSz8llR5NHC15cZH3hV5bI/5?=
 =?us-ascii?Q?bkEbrBVWhmvK/uvPM5mqWsqeBm442WSnxrdYoUSLIcrkj1i6hJ02tA/KVkIk?=
 =?us-ascii?Q?cwSkVALNX0K21bDECOXHOid0Q0G+AsuVIfJFnLHcoAKZevKQsxMMf/pj/nlP?=
 =?us-ascii?Q?Ss4bszCx9QB10xj+kbAtZFTzkZ+oHdegMAzwUMGwjRxSLNO8CCc7DT9+KJDI?=
 =?us-ascii?Q?XNaKj2yIxOEdYeufSzI0J9eJaJhEKLaZ3BKD8HWGNpM4t0EOQiHv1fjlDc8e?=
 =?us-ascii?Q?LVpotrxSkJUz9olO6xS9CGDJBozJ/GXASRZJMB9puhlYd08Py3DdTKSqG4nw?=
 =?us-ascii?Q?kb2Be40xjfhDH2y3oFlQpOePjYYV1AMOVpbMUoOM/kbVmKmm/MpIlQ7uAMvA?=
 =?us-ascii?Q?a/I0v2tR0CrO8fS070VwFdOjI3LEsSoZoKwQYNhmbr7odQoSyJ4V+6Lhx3od?=
 =?us-ascii?Q?+c97A7LslvqlvjRWQE+B7+z3mdtPum4zkwiI46Uzbv54pxzWjHLspxL0OtHP?=
 =?us-ascii?Q?wpuPDaL/sVg5yalBv39/O3xyVgtGTopnYUDjduTi0tsek0myXM95C8+vkCO7?=
 =?us-ascii?Q?pMhR0ZknLKRHw9bJ3r2EUSyBwXKzfY/oeiY/5qKynCxVugWBOsXlj7pXdy7r?=
 =?us-ascii?Q?D6DoAEDxF+c4hTWGxTHMfHXdWO3UVaSTQWsY0neBoVuiV+7nbw0mPZTpBFyt?=
 =?us-ascii?Q?CMIj44SxVMsCPmblP+jy7xjT30kLw/5fBQa/Tqo7Xag0LgD3jfAHHZpANHjt?=
 =?us-ascii?Q?mEkjoyfuTxQc29q8sw+a/Yd6QMU3QMSCz5sHHVdBfRD0MYU=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?clcTAT/wBYCQM4TVNCUxHR1EGs7mCAGP3zFinTlZ/4GKSbjwsZcdyPJELymb?=
 =?us-ascii?Q?/+FpoBYqprrAXnvXN2EwgJ0cgMM3TbyTyzXxMoGznHUCLIx8bz9DMFQpB1R6?=
 =?us-ascii?Q?9uNH31TWlemTT3ExjfmHzcsN9jg/JXOBy1PS/suHlmDZzHYVh2MCVdJEiHCt?=
 =?us-ascii?Q?blLn7OqJez9gVvqMnIRIxK7fAQpwc0z6RBm77pfNKnUwqA5/+1U6FU+Xwabu?=
 =?us-ascii?Q?K48n47xPAA3eizhSV4u3CXDPLUb0M/VM60EeuyTbBNjubkzc5AOIze1STh30?=
 =?us-ascii?Q?Uf/PQHPDVnN/rDa5hFGYYp/QENoqhMxGIZWu6b+zVoy3N3LZu5uSSdaAJFGl?=
 =?us-ascii?Q?t5uEQrStxPr1Ld/5UQsL6nrvkRYO5xtHyXIQ0+hyCEB3Q077gUCUPQEQANu/?=
 =?us-ascii?Q?vNOwIEAbYfdXdaBSrVBF8THjkEtRI15uJ28UF7SbsGs74ErSnEC+QdZOba3Z?=
 =?us-ascii?Q?UcNwRjMn6P4hSUriATCZCOQpM0iGObLbLekYNoXUxHvH+YcVOl2db2DRjiqJ?=
 =?us-ascii?Q?zhu2U47vcA+PlpP//Y+/59JnpZEraqeNFr2zjRTZ88suFvowutwBGoGJyq7E?=
 =?us-ascii?Q?BSfvQ1Bt8ejjBII+gGLlZQ8xiGRjPLhUqW48CuqhLpYmkj1Wkp/N0Itxfj86?=
 =?us-ascii?Q?5zmU/wC45xoRDqGwj2TAfRwc5v8IoHM8tImETPlUdYuNaQ9Bju65M5z93vPZ?=
 =?us-ascii?Q?SE+4Ot35MtuLqqmaCI5DFpDokJgrr+WT5UOY5C/E1uN5iy6Dzikx32YUCeQ8?=
 =?us-ascii?Q?vf6TqjEn3sd1Hr4ldfkACtsVDcvZGlAEf07ywofqkjyZ9DONcZTRao8d13eu?=
 =?us-ascii?Q?145/caqeLdWgM55QLb+xYkpcu3XUhO8Ui55X6EXEhHSVirdLNAVK1DaAw023?=
 =?us-ascii?Q?uflUb6wkPggexm/YV/sLDuZnsC9+aZVb7JfoemVYTLwgQ0A1PvrgaEn3KiN3?=
 =?us-ascii?Q?SJHUPELFthVCIpPj77RJrmU3ostQdy2J6Ka6y10lrVAVR7EgIyK0VQQ7gcTD?=
 =?us-ascii?Q?dA666oKmKclVwYhZJVlEyvLCT4qGDAng9O8glfuDtgSbxFXmIgxaLvztTyn2?=
 =?us-ascii?Q?mPZA6cvbk48+p4m+Ct4Ipm+jGqD+xVRoVW2dBeMd6ymSDmXTbqROJXhrveuk?=
 =?us-ascii?Q?9h6b7/9HaFxaH0MGMMI4YPiRESl2cn3VC5GHgM7AKuPLMq9E4WZLvP6fvKuT?=
 =?us-ascii?Q?ubf1DUuNQRqVadohYpji1ReziYHQKV2TTh/HjfbS8t1evm/d52bvofykKGdv?=
 =?us-ascii?Q?ZfQ6zVuiik9g17eZ6YJI67UKWdjoTbqXnL8JW3izNO1HS1QhNgupoXloGzB5?=
 =?us-ascii?Q?sn/JBwgj+VObuNKLiGjNwDCnglvKE6xXhe0yBmmw2kcs+gMxXNvGfqqx7J0E?=
 =?us-ascii?Q?lZqMxwpIvFkzUo/A1460vN3BkJ7e?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ecf2d96-7193-4b17-321e-08deff2416a4
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7795.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 01:32:40.8104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS9PR01MB17844

Hi, this patch caused the following errors on non MT7988 SoCs:
[    7.071127] mtk_soc_eth 1e100000.ethernet: error -ENXIO: IRQ fe1 not found
[    7.078022] mtk_soc_eth 1e100000.ethernet: error -ENXIO: IRQ fe2 not found

Please backport these patches to fix it:
070e98dd4e26279280e15db8f37077a001ca1b4c ("net: ethernet: mtk_eth_soc: only use legacy mode on missing IRQ name")
e81d36d48880ab3f2b351ce3df799acaa8b11c4f ("net: ethernet: mtk_eth_soc: improve support for named interrupts")

Regards,
Shiji Yang
