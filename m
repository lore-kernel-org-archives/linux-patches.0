Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1800D2571A0
	for <patches@lists.linux.dev>; Sat, 25 Jul 2026 02:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784947633; cv=fail; b=H9jOBZl1jBwXOOgO1js6DHgZCes3uedWDgvTrIJRzSvP6gvuGDNqjlLOdFIBu4dG0HZ6fW5y/CUoIoVf8/8fLIDZuNz1fIntcOvWhzz9yMrWJT6cgy5f4Vt3zYSDS4jiBwLmFnxAanan7V9+hfvO2pvrIryd2vTstG6lUMj0dLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784947633; c=relaxed/simple;
	bh=gujfDOpN1Ly37kvLb9DO3KdKTjezuYTA2xog437HRm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eS2OK09wGzYDYdsxXoTGYB4ft7qIa5huIsnGLB7mCGU5qqnD35w+D+epiUjPlbe0DIL5f0JVblqEu5jS+fznMlUI0VY0LQcTeqBuCbONrnjx3oqDdfRlGpWg1UVqrC5eesueeR6vMFkgh8Xz5NhRG++Skj2Jf7yIDE8tvz80IuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=G4hHJvtF; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=nEkWGDC+; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="G4hHJvtF";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="nEkWGDC+"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 66P0sMsg2517521;
	Fri, 24 Jul 2026 21:47:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=IHzua5Wv62BF1pkViWs6ysjVVFxO0kjp77ZdELnhK
	sc=; b=G4hHJvtFCa9re4ti/Z80l7acuQMVv1aG4cQQxxSl62hJKqlNhambQuEn1
	HVfZUlhT0zx2IKLB88qDM4KV17NKYk+8+vt39NLyrV+LPRNCPeSvhoSD6z+ImXae
	h8U9CwoMfwVjzbrhyx6B0pvUQGa9UQGTjGyoD4AJjdbVcR+grMLsLMp/BLFFwo9d
	3hFUwvjByCvjtCjNeMyfoUisUkWroyCfapK2kIbO+53tqEbWzk5PXxk+vv8XcuSP
	MMl5fgPbsetlDJ8OSzszEvmyr64PaRH0Qnu5N11BSBfGOBaQMoC07BGACdwSJ4no
	RZ8SWzwTsHA9BBaJAajLLYyPSnmlw==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by m0380145.ppops.net (PPS) with ESMTPS id 4fm8jubnfg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 21:47:09 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXELWTivdJ2OsBDEEu+rQdK2y115TXbLmUh9EbOaZR1mgnKrHJRLGd5+D1WtDSyKpLk0faAutQykK9cSGxPEPb69I6yXekKzEgq+prQMu9qOyVwy3GZj8q8OArTzF4F7tO/Wfp5dT3UNbdWFEJkxEDIMCIUhxBnoz1PItO/rih8aDjcV8YNlgaZzjOCzUN35NJODExnATA5NmYnG3tmzLq4k7RgEDfdnXaM+fJD9RNvzgjECqFJYgT2UqaSVqmT9oX7xq5dRwNNDq8EqeO9hchww74oniZHYQY9iR664mNa033jc5g2IwDsZnZd1yAMR1Br8hptBLQ1ZUKaL8IFgqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHzua5Wv62BF1pkViWs6ysjVVFxO0kjp77ZdELnhKsc=;
 b=UgvQUCp+cBjQXESL2MINiJB3sWHzEd+qFl27PJ1xPtS4d+2yl2qs28k3lwJyneAc8zPAwh+7Yfew81gu2JQVamvvfPJrY3RU9snMkGihidWRLK30pqWa99nIn4yvuvMZkJsaE95PMEPKj8jXOpuf3mK1lc73lsIJyxP8/lMDMMPbRCgkDGO9eTs4Mdb6w+ylV2wOHfGWS0fTYRBmfM23vmSrWC/K68+0c0KMq+U8A+vyUAmSurbw/qduyFHWXNouTK+5/ToLDBxF5MP7igQwgCKZCGXiDLEWczwMmmIdy8/mlCrGKrnCWfk1g34x2+5Kj0qpEYiZkLtU+6eXmfboOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=oracle.com smtp.mailfrom=ti.com; dmarc=pass
 (p=quarantine sp=none pct=100) action=none header.from=ti.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHzua5Wv62BF1pkViWs6ysjVVFxO0kjp77ZdELnhKsc=;
 b=nEkWGDC+FmY7XQn/VRnuSp4+qVJL2+PPtguOUF6wsJNrXGnYW/aXn+SycyAtXufkXf93tDo1p+Webk0WRA9onzDxt3XR0ATp49iE/Sjm6ZicWIlArTHOjdCG4Wof4nF6cnHGUFUCW14drDwzrp5+jbmxAUhBex7ueykw+TUYZFI=
Received: from DS7PR03CA0222.namprd03.prod.outlook.com (2603:10b6:5:3ba::17)
 by PH5PR10MB997758.namprd10.prod.outlook.com (2603:10b6:510:39e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Sat, 25 Jul
 2026 02:47:05 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:5:3ba:cafe::37) by DS7PR03CA0222.outlook.office365.com
 (2603:10b6:5:3ba::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.12 via Frontend Transport; Sat,
 25 Jul 2026 02:47:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Sat, 25 Jul 2026 02:47:03 +0000
Received: from DFLE215.ent.ti.com (10.64.6.73) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 24 Jul
 2026 21:47:01 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 24 Jul
 2026 21:47:01 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Fri, 24 Jul 2026 21:47:01 -0500
Received: from [10.249.32.203] ([10.249.32.203])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 66P2l1oA154281;
	Fri, 24 Jul 2026 21:47:01 -0500
Message-ID: <56a9f2fb-64ab-45ab-89ac-8688f4ed0cb4@ti.com>
Date: Fri, 24 Jul 2026 21:47:00 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0820/1276] arm64: dts: ti: k3-am62a7-sk: Add
 bootph-all tag to vqmmc
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Nishanth Menon <nm@ti.com>,
        <vegard.nossum@oracle.com>
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152504.415619146@linuxfoundation.org>
 <59f6db07-e73e-4f78-9016-1dacea0efe10@oracle.com>
Content-Language: en-US
From: "Mendez, Judith" <jm@ti.com>
In-Reply-To: <59f6db07-e73e-4f78-9016-1dacea0efe10@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|PH5PR10MB997758:EE_
X-MS-Office365-Filtering-Correlation-Id: 7241b8c1-3754-4165-9f69-08dee9f7024d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|1800799024|13003099007|4143699003|10067099003|22082099003|18002099003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	Zvk+T26cFPrEHXaWJNQDaSU32S4m1TLNYwB9wvCvKUE/OUgP3IndQ+RIW1Tk8sCyWf5VqmO9iNuT5JChpM2jwSul0nmopL93+rZd/l84FS0IWoVG9Dw+Al0BK3sR1pFcWgC+2EaBDj/bn+Zb5I2QSFF24/sXgG8a+yIpHvPrvq0vINzui/kr7u0kBYOu+chiBdulbJoB9vah5Spg1wf8pfxhsGz/1XNnRj2Rcv1DK5rCwlJ7biSB8AvNqwnueiFXcAqMzr5v3egpv2I8ZWlIdGNiuuVjojfNidEWAyn9czmJgPlE3cfe58LT5PYHTsM/wMCx5hEhGbdo/bwAT4zHHloC5X+LrCgblvaasb5NNCmpIZyat/pDKDaCk02xspjBAEuLZVxbYb/8AG0NYsBI6e6uZ/sQFyZXjvizdCBC9luJ0oZMHV3lLJDcBIDjOnzn1ruXKrq0C3HUld+Ch28coeBYVXC0jo55/Gy9W1EEhghujy6olztujYUNTDilUjkZrhGafQS5aictTDztheknF68YOVQFTGCRxSQ7Cz6mOtx2l/Gm1JF+CxzYyTIannbJw2694BqNH4c4u4FcPfGSfuZOT5j+ioTnppNRRpcst5Fic/4MWVCHN/X8j3j/sO/pgVZmiGhAP+SzhD8QDgB2bg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(1800799024)(13003099007)(4143699003)(10067099003)(22082099003)(18002099003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ujoKFZVMIAMX3d2pfXNpstJI1GRHZh+SMnnVn8ZXEZrDoGwFedNialjB+rQVoffQpaghN7bbodOS+ToZZS0+sfNaqknVeqbNs9d3ylpy0OVUDZ8svw1zL2rTUWvi69965H8DShF+Ge04+u1DKDGt7oNJpTn63qHA/cTALvd1IuyoL/Y5t7ycU/Egryof1OpqyGoYE4AuqiqKYub+IYsMEf3EeGjz+0gMRcBtfV3qz1lH1luN3f+qzQs+adt9MuddIQFWEwTaJ0Yqv6zWvU3rEvTPBTxoaamJlwkCAlo9E4JsFFx925WJcxSwVeC6iH5WoYPnsU4A7HZny3vuusNS8rVHW9ccWB+RopVsIYGRMaNYYl0VYBqKOGKYmmXjEzIVPMLQk/WoEWhq2ZLBD9lF1+jZz2tw37GgtdOqee8XE/NrIzUCMrc2Het2EDYkj/hN
X-Exchange-RoutingPolicyChecked:
	bB0/1aRbBijTI/mQ4pEJ2WuTKSYg/sB5S19Y/Mdp7npu8fzAtVhuFM5fr17WboS+YYZxx9pT8HjyHOWW/qFbogL5A/sfK5FaVmH3wImvm3f8X52Yfd2bd9QMXJjiM4Ap0o5hCgSW6xJk58u1VqQXcCtef0sAjC9ZdKRQMO/TkvbfLCT0g4uo4vu/RUIIqGw9GmMUFOvC5BoCRJY9hFyLtv74p27tEklCcOHHpVqvhpExELXzYbKqVWipHEohHzrkpLyRJeYa5gysaiRvYUQSDxY3U3hzwO/LZ4NXEFZQKU1qUxdjzi7uBZ6Y4sUmwlDgfA5gZCseS+7BG9W5Nu0GSA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2026 02:47:03.6804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7241b8c1-3754-4165-9f69-08dee9f7024d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997758
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDAyMyBTYWx0ZWRfX223nJ1yov9k7
 +TlixUXpHfzaNS6plIoVxxBf+PwLbS2GnZs6TMct08QTFI5O01brpDg0n9QmE0ga9GCmd0jfgpO
 8qSqjMwV+Of4J/AhYhI04jRu/ks+DzJUba4oNH2BXKd0N+iyWB+ervym3UmlfsjJUOaYkjO8FpX
 Uf3BBfaDVGrR77gRhOtry/aTJk3M1f/Q28Sm1czgWRieOTLDbECxQMfBkMSAAbuTB0dA33L67EA
 bvmxG1cZE6KQn30nuHnDj4Nw+65KYXpg4hf2rzV2RHFMjcG8yRqRkOIMqJl+cKV89ZlwQvIvsVD
 /P1xuVHWFvuxHwURMA3JAn+G1dZ9/2WE+QRwF9BhkgAp6ut0MXDfoGrEHFF2c2U1bMEoVrOXWy5
 d2+tU5TyWYfmJP4Pu3mE3b1e2OCxrx7p5RH8lCg0UNjWu9azUWjn1bkgeU24FEsXvp2bBK3QNP/
 BOr/KRQ5QjezgGfIpzg==
X-Proofpoint-GUID: K4PK17aMFWveJcRTSOBE5R64QflcVWYr
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDAyMyBTYWx0ZWRfX7Ev5vBGZ40yZ
 fU2I1USHOTR9XNc4v82j8tHBb8l1MPZgn1y/S86Lrbs/XLZ0oM1dTgX+Q85uCHe42vGQSo1ueqk
 KFDqFsDUtMBFFBVK6PVo5kuAF+d6nNs=
X-Authority-Analysis: v=2.4 cv=LJ1WhpW9 c=1 sm=1 tr=0 ts=6a6423ad cx=c_pps
 a=TuEuCTxUJaX1tclN0RLokw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=bC-a23v3AAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8
 a=ag1SF4gXAAAA:8 a=z-U_xtq-xX8ol_mIiz4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: K4PK17aMFWveJcRTSOBE5R64QflcVWYr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 clxscore=1011 spamscore=0 impostorscore=0
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250023

Hi all,

On 7/24/2026 9:52 AM, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 21/07/26 8:51 pm, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Judith Mendez <jm@ti.com>
>>
>> commit d8fe8442366ffd8306575028bda92389d0dfb674 upstream.
>>
>> Add bootph-all property to vqmmc voltage regulator node and its
>> corresponding pinmux node to make it available during all boot
>> phases. This allows to run tuning early in SPL stages of boot.
>>
>> Fixes: 8f023012eb4a ("arm64: dts: ti: k3-am62a: Enable UHS mode 
>> support for SD cards")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Judith Mendez <jm@ti.com>
>> Link: https://patch.msgid.link/20260324140247.1200631-1-jm@ti.com
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I have run an AI assisted backport review and it spotted an issue. I
> have taken a look and the issue goes like:
> 
> Upstream commit d8fe8442366f ("arm64: dts: ti: k3-am62a7-sk: Add
> bootph-all tag to vqmmc") has:
> 
>          vddshv_sdio_pins_default: vddshv-sdio-default-pins {
>                  ...
>                  bootph-all;
>          };
> 
> The 6.12.y backport leaves that node untagged and instead adds the 
> property to the unrelated PMIC interrupt pinmux:
> 
>          pmic_irq_pins_default: pmic-irq-default-pins {
>                  ...
>                  bootph-all;
>          };
> 
> The vddshv_sdio regulator's pinctrl-0 points to 
> vddshv_sdio_pins_default, so tagging pmic_irq_pins_default does not do 
> the intended fix I suppose.,
> 
> This is probably cherry-pick fault ?
> 
> I think 6.12.y should move bootph-all from pmic_irq_pins_default to
> vddshv_sdio_pins_default, thoughts?


This is correct, boot phase flag is supposed to be added to
regulator-5 and corresponding pinmux node as Harshit mentioned.
Thanks for catching this Harshit (:

~ Judith
