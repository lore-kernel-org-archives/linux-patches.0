Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022099.outbound.protection.outlook.com [40.93.195.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1375332AAAF
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 12:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761656021; cv=fail; b=smXUywYLnAoA2Q5TtVZ0pFCq0sVQv4RoXjypkNE7xzJ35lvNTlKqSauLq3wNx+zCmANKMCJHqtbTtZIggmUa1XJ+QmVbEzV2HTb9j53ZPzRzcJnuWx6dKu85SKt4pROS5ic+9ZK64T7cvj5sD13DY+gdYYUUZr3Swp5YBtOOl7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761656021; c=relaxed/simple;
	bh=FTHPgbaZw53aib07+fW1v04o1XEUHG4GbnLLYNgO6yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lrfZGYfiGaD34hc1xdku1Ke+FgyCHAfdaUXfeX2v8IahzAZ7tOVY4ek9AZ4uatX1LLHlWGg2bwtNubOaKrIU8JR8oOP+s+RMULpL24IDy7KVxffm8wy+2cOQrzzbzfeCC8ihN8JCy94a9XIhw+b8n1hvdcbRZT2eqnN+8tOVgX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=in-advantage.com; spf=pass smtp.mailfrom=in-advantage.com; dkim=pass (1024-bit key) header.d=inadvantage.onmicrosoft.com header.i=@inadvantage.onmicrosoft.com header.b=F3lm6K+M; arc=fail smtp.client-ip=40.93.195.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=in-advantage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=in-advantage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inadvantage.onmicrosoft.com header.i=@inadvantage.onmicrosoft.com header.b="F3lm6K+M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ye34hWvkKencMwLwy/xXDW7DUW35rUl6vdaJgzBG0/mdIR1pUC3g8AVV9dnF5fpIlpIccF++wfRS43HdYxMv4ysHTCOV0RqFkj0Pf2DmuWVCxskQ4I93jcrHbsi5hkKPpkmI0igsxIQddbhj7vFY6hGYx4btEbs9uIkIitPn1G7aWqvWq887jPx4uMWT2XVwdPzvJEbE2uQZKHy/POao+g2oa7oaQfsXgPMOENBlvXEh4YFlztKrge3LpHtt4iuKDq7f+xyAx5xQkGPkIEXxTG4LyV11xmAOrpS3ZfgCMdQwJ06rxOAVX+O2MFvstf67DiUm9BOt3uT1C9vquxEaqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMRWU9MoDe0Y5iOeJXU8sovb9RGM4Ct2GslJ5HdBFZ8=;
 b=Ee8NWBxjHe5ES3YDtk6Ydmml6DPmTiu8YmdqJfNiwyLwCwL/RuS2Kd8j1CXVcTxm45qduKTj/J9FYvqCLEePObz/L2CrAVyUTVnqJZJCVIpz0nXCHKHgJ8pEg1OwnWqU7yefhZTpoT13TCkZ65rBxi3d4kkWndRhnWjCooH/suYBzMAJnTYsmPuEX8h3xZTmreaOPvAKyY0L6rMh1bhdKT1m6RXrIdBh7Ue0TCGAVCh7otZfq6SibWxmDWt5PNbuZouuIPSuo9o01OPe8zsNBqrdnXcF3By4OsHy4M2pwugwaccU8+bpTIn3yEgV8rooJMk4aTwlLDnSX8x4smljEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMRWU9MoDe0Y5iOeJXU8sovb9RGM4Ct2GslJ5HdBFZ8=;
 b=F3lm6K+MwQ975/LhAywf5hFSmR1Eq2OptxXp7pf6u4x92sUZY9Eatev1Ek/awYlYc8EzJ6HKVLCpbttXHmLTrzPrjbIIpudSLCoU1FSXefIDK/4hkWN4ijSTrwbNUmkGR0z+0rjX9mDfQ8bKG406Kdpv+tV+q2vQjqgLxP7uxTA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DS4PPF3984739DB.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d15) by SJ0PR10MB6423.namprd10.prod.outlook.com
 (2603:10b6:a03:44d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 12:53:35 +0000
Received: from DS4PPF3984739DB.namprd10.prod.outlook.com
 ([fe80::ba61:8a1f:3eb5:a710]) by DS4PPF3984739DB.namprd10.prod.outlook.com
 ([fe80::ba61:8a1f:3eb5:a710%5]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 12:53:35 +0000
Date: Tue, 28 Oct 2025 07:53:31 -0500
From: Colin Foster <colin.foster@in-advantage.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>, steve.glendinning@shawell.net,
	netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.17-6.1] smsc911x: add second read of EEPROM mac
 when possible corruption seen
Message-ID: <aQC8y_aM6wtcbnDh@colin-ia-desktop>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-103-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025160905.3857885-103-sashal@kernel.org>
X-ClientProxiedBy: BN9PR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:408:fb::35) To DS4PPF3984739DB.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF3984739DB:EE_|SJ0PR10MB6423:EE_
X-MS-Office365-Filtering-Correlation-Id: b080b4b8-4d9a-4b06-3656-08de16210173
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?46/KV5WL3wWWKeFH9if6NYvzo80tVxRNco6WJeuzfE+lo+F/1XYTmsoRgix0?=
 =?us-ascii?Q?QxIP7zdBFl+4MFfTWR/MzBRKw26EmGw/XbbrQKxFLdP0rH0PpOybXU4SZJNY?=
 =?us-ascii?Q?ZZqG76r3dAqqBIoXsJqLOivV64Yrek9DvgSCGqVr5BW8ll7ORwwE6rNNaMP8?=
 =?us-ascii?Q?v6aJG+1erDIubg+Sa0GVWktmWs/GzSan3klTW/fJM0BOTB5Q7IRjqKbTfLlh?=
 =?us-ascii?Q?re1s1xuzuWAoRns/hXTlhRwHcH/gIyfxmSD8WWVGtrjcZs8M0T3Hd7FTfmAV?=
 =?us-ascii?Q?9Rp9DZKAOMr77hVEtqbawvs9b1yb8iHHUDmdWJGUZS9fuJwOkbTU29RZrVbu?=
 =?us-ascii?Q?FKo6gVKBfD++tRFlnJa8b5I41Tyf+nweQx42LLrfI9dpvDzRy8OKGm3PcaCE?=
 =?us-ascii?Q?EJiXqitILIUE6hEFPflp7q3W0MJB2tgnZDfL5YG9FS7jzpvcYzt1S4Tv+hdE?=
 =?us-ascii?Q?cXeyjCzteW+y2nF03iysLnRh6WRR9+Sq+REr7smibcDgeQ3bmoOnaRpxkBXl?=
 =?us-ascii?Q?pZ4DT7u8SLMzcldYzps8cYQ0qh5o6y2npD/H/AkK3X0U1/aWxE5mzW+DIdbj?=
 =?us-ascii?Q?DW12RSckuC+Q2kAS8gfa5+8embCEY0ek/PT8ElEmP3arB8efCxGmIYv04rpi?=
 =?us-ascii?Q?ZANX9jWGLaNQBnvZ0GCmTle5D5ecERA9kcRzA1l8pmSVs+PdpThyRA1k5akY?=
 =?us-ascii?Q?rcXYHUxszCJpwO8gHJ8GMsJkcbFOr0jM3MDoERpHhaq+lNJnF/PKHmc9y+/+?=
 =?us-ascii?Q?5i+It2U0OJM9vUClFt7n055NYxtW/ZjPx5ywDZ16hSdQVg0SK9b+wXkDkcNp?=
 =?us-ascii?Q?2sYLiLhYo0iHmboHqF4OmexbB2lQOoKWUxPQfS1KcOnGhrHYc9q2++tNk8S7?=
 =?us-ascii?Q?90khIUYyRmVaOyAcO/BZrIOoVKiIyGUr1POS5rfVe26a1H5UZ9Gp5OQFM9co?=
 =?us-ascii?Q?nxbntKlHTKTZ1ElsU2tTiWHHSqTa3qrPgYdZ/B4csJmqimxFK2r4NETrm7OV?=
 =?us-ascii?Q?45Om8ynQ1/LSZ1QMFPPGLxYwxKRlTgpuF0Qe2EPUml3cxBwbRUTdqso+LVm+?=
 =?us-ascii?Q?Hw/DnInF1cOoLa+2uio0o+AcQ1iVWPYO2jX4gsI9nu87uH5SW/RsIv1+NhvE?=
 =?us-ascii?Q?jp7KiKn7zMyV38TZ3pZEIjmH4z1CFxFbcBnUuFnkuAYjSNwGUuHZhdtFyPD4?=
 =?us-ascii?Q?IuNqBy2y3ePiglXgaVdtkbBIZ2MR16cYQk3Boby911uzdxcCKlb5wYILUn94?=
 =?us-ascii?Q?GX8Sti2LrrFaM1ul3E6UmbyiHY3YiYwvrtJAdtD3ivlVj21jPtLSbNTFySKS?=
 =?us-ascii?Q?Vewl/yedQFh/ki9tG7l1hOIM5nrWgSNP3Dr48sGQ6jqjQfWLEnXlelSqL4n7?=
 =?us-ascii?Q?iu1ztWVrYK19mnLypTLUjdult1t1kY4prGo3zOk7jxafPHbS7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF3984739DB.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v6fKyYz+Rq8tJOhBw1L+nmXD4FlW2SPW9mpXTUjz5L3UWgD0CMS6o2s3btzE?=
 =?us-ascii?Q?P+07YigHxA6ZK8ZzhXWmfD77eaz69WBmGEfcCGtVY5NDAfSEbyYqZA81lwDR?=
 =?us-ascii?Q?jiQxVCi6kZuY+DgtfrZOR3O1tuk5jPHcYNwIKC268ssGfMpSutCYgwq+gL4e?=
 =?us-ascii?Q?gMp0vj/ZhBofzFNOiH5B2PO8zS194o7BrkVZVtfFQbaxkSOF9hF5SszupiDc?=
 =?us-ascii?Q?TXKfDhy39HQtWCazkqMI0ODthOkx+XqT7MGkBAaLEFV1oqyGX2OE36jTgzYz?=
 =?us-ascii?Q?YGwMhG3WgUJDTUXrGBfF2pBvA+do0zj3CZJewbq7tucewo6DQSFw1WuhjPHw?=
 =?us-ascii?Q?fFrUV2dhj/jlX1pufl54WtXbt3KgrgYgfnmSk0e7fUw0GOUQE+myxxf6Bken?=
 =?us-ascii?Q?/jjt3Pxwuj9sNe0owYY3rgKXR5MaBcd2bLhQAU1ocWmCtyJpATLcwzXQ68rQ?=
 =?us-ascii?Q?SzMkZZXBCPTlGQrDWZg65PsAwWIp0kcZBGt98W8akzZ3VIVaZzLSBjvo9ru/?=
 =?us-ascii?Q?1VIYpTq5TAMnGXx1yXNa31zIh0kgH+Q+wBgZ7gFyb22RHMOkmE0FL1UJtTGR?=
 =?us-ascii?Q?V1O/i9xb67KpNAd0cjT4wrxrBtND4eUeof+pukoyaae/c6mPYDEuLJOqFuHb?=
 =?us-ascii?Q?+ZL4U5dPfemm0cMXW5zQiv3iAT5fl58XSrCuUUk0fSGXJRjqXfkOClnCia7s?=
 =?us-ascii?Q?PHigrQYijAg6HWnYr49oCo7FiVWpaGLTjlgsowJMoGyw1MYMHbigi6xkPhhx?=
 =?us-ascii?Q?phAAapO6ATVN8n8G5OEE4NcEwOAUqfcmBcLyJ5LvIMXvGS4XjtWt1slfs3Pp?=
 =?us-ascii?Q?m5DKb3ttMZ/nGvCY43Lxw8bISjDkVBrFexWTqxX1ZYCjzM6daIJjWCAZf72m?=
 =?us-ascii?Q?nnlkXE0YEx8ZTpvPKnwwd2x3W+5TtmtY7SWwZYRXLkcFQaBHMlg2BRsL0msI?=
 =?us-ascii?Q?RGMDtCBGtTk2t5HZvbzNZBMPd2sf3KFocu2ndrrT21VoqTKBbmV22R5wL3bl?=
 =?us-ascii?Q?vgFv90ne/cdrXV2PKtbMVCoNv18hzq4llMEWQPipL2/zHiWzhP2oqJFfRZz/?=
 =?us-ascii?Q?ivj607wDl6La2DFxnsTvYrfQBpZ1BeagX2FJNgNFrNOhkoNv1EVChGtPWrQU?=
 =?us-ascii?Q?5PjJ+pIN439vHMU9aDC0DBkw4xSUEGacbglcF3AMOmZeIol5bR1sg+i58yXh?=
 =?us-ascii?Q?hjY75efJLFekTJRCxlDkl4V/yn9dPkZ7s6ThyYB40LBAyPzlTpurTaW09bpG?=
 =?us-ascii?Q?4oYG8z1xdF8qGsaVATTiDUGFoc5NwdNXcTbCX1CjZNQFfOGy56z99tgMJGjK?=
 =?us-ascii?Q?vmO+4rTJe1MSYSZ0/ajGSeihTtkN/iYtWxehQqn+Obekzs/vqzaO8hTuvhPc?=
 =?us-ascii?Q?y4IkcO7cUAOiqsG/hycjqpnkixj5ja4vykIpi81ThiHJPoEzojUODJ2svbHa?=
 =?us-ascii?Q?fj9MYHOIH1WZMpogOZY1dEdpIsLJTTbHiJ4KDrUz45LvXGHTnl2gr6F6Rtib?=
 =?us-ascii?Q?+m1pXDGvrV5mHUvlOs+9UahNiWu85RhWI1sGb2yKYDsptfyICcM8znN+XSlY?=
 =?us-ascii?Q?xrbr40jH8zfTAt/VcbC+KnUMPXqiLmmNOcursU7RlqywUo+UQ195Isux7F9T?=
 =?us-ascii?Q?ndwwuQ/dDsQY9eWMzv1PKhg=3D?=
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b080b4b8-4d9a-4b06-3656-08de16210173
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF3984739DB.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 12:53:34.9450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UmHSJnxmCnAgyMKR8vQBoXw8+728GujLOMjH4Zj/0zqY3mJ5tbQrQ493LavP7QANoPLYy1F2BxGeVobrpEi4Fj3vUClgJdGkHJNQrUAdpcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6423

Hi Sasha,

On Sat, Oct 25, 2025 at 11:55:34AM -0400, Sasha Levin wrote:
> From: Colin Foster <colin.foster@in-advantage.com>
> 
> [ Upstream commit 69777753a8919b0b8313c856e707e1d1fe5ced85 ]
> 
> When the EEPROM MAC is read by way of ADDRH, it can return all 0s the
> first time. Subsequent reads succeed.
> 
> This is fully reproduceable on the Phytec PCM049 SOM.
> 
> Re-read the ADDRH when this behaviour is observed, in an attempt to
> correctly apply the EEPROM MAC address.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Link: https://patch.msgid.link/20250903132610.966787-1-colin.foster@in-advantage.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> YES
> 

I agree this should be back-ported. Do you need any action from me?

Colin Foster
