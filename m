Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3C739A061
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 11:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780487587; cv=fail; b=hYE7zpzdTygaRqAMdYRFnNoUVbUtAKqoAmbpHxgym6hpuq1P2lODm+IW8mYQT9/XrNw/jOgcP8UM9WzMXztI2vfj0GnKyBFoJkyWveHxJYYz7lkUFLmYHRlGojVIsgMYBbfBS8CLunpYBUJJ+zWRmROVvoTiLgCaNHVwgP71Di8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780487587; c=relaxed/simple;
	bh=tp3ZyhU4mVcorW6swFHQhyNLK3EPcl+YcYZOexoYAFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOP8xcvg6mL4SurrmvUPrD8u7qRhYTdZOYu4ox4cJ7tuBl8398rTmF5u+YVhfKjorR1GHinhAeXIci/GjrXTjgrAZS6sl5bsbfZIo4a6gHCPdHTdWr75kiNpLJpdXacFTpAz0dZ/SBEyD8/awLzi1qP3K0KbFpAuKWZU24aaGMg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=QRiiEy6q; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=LyurSTkN; arc=fail smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="QRiiEy6q";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="LyurSTkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27F91F00893
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 11:53:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cirrus.com header.i=@cirrus.com header.a=rsa-sha256 header.s=PODMain02222019 header.b=QRiiEy6q;
	dkim=pass (1024-bit key, unprotected) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-cirrus4-onmicrosoft-com header.b=LyurSTkN
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 3 Jun 2026 12:53:03 +0100
Resent-Message-ID: <aiAVn6ZXKoN_uUqD@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id 7A977354B4
	for <broonie@sirena.co.uk>; Wed, 03 Jun 2026 11:46:35 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E82160221
	for <broonie@sirena.co.uk>; Wed,  3 Jun 2026 11:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 6C6E41F00893; Wed,  3 Jun 2026 11:46:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.149.25
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1780487194;
	b=biWlFVPpeUWlavTXR4uKnqJiGKbNmyV9bBvrpGm4zjW5Y8Hq22ZotbNd84ZO+mR0l4gb
	 waMK7tQkBbUrrHcOWAKA4A0haBOmfaD8pZTF5rE55pJZD7yIiUyo9s6+HLvtE6FisMd+w
	 ldoQOHmMW40pUC05VV9iySTFkg27ROlMTiXXXz/1XYQ0cKXSut16hDa6sVPLpITPYUtSa
	 bMOYHxde/aCBnDFztNa4Vr5PhUrgq6asi+7J8flTDz46kO+4kBbPedAQ1V+JjGyFiw/TV
	 ey4fG9wVreGUt7aj0/w9K7rwV4MKma68eW0ZTikYGQIlJIu1pDeeejcqaH/wZCo9FWw==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1780487194;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Reason;
	bh=pZpb74SHHlxaFJ6qNN9RDVJSTrENq0JFoH8AMXsc3oA=;
	b=M6n3c4ImgYN+mXiVzNBrKGMtFjU8t9znw8ah1rp5ORpaEXR8goh0mgZJzWgqa/NrKz3j
	 D5iDEgz83dnrdqFqloo4uOJrPqRgI7H7jbG4i+An6w+yq0CPhkLUcSzTubno7NktdwEX6
	 yQSqh0CI5Zjy/YlkA94Y87eq4QaSuKw/3RnYmR+44Dbmo5yuZoan0Fx4MFfI5CK4Q1tKJ
	 qCFVouDTOrdhsK+wv4C4F/dpr0fph4fp6tJ/DZGuEOpYGmXIyxM5VQZ9HpdDtFhpsL6xP
	 4Nt+Ajgg1G4cVgD6ul8W6KsTS7ACioCaMxWlfjE4FjrY/DldgbL5P9zm/e4QEl74gZw==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=cirrus.com header.i=@cirrus.com header.a=rsa-sha256 header.s=PODMain02222019 header.b=QRiiEy6q;
	dkim=pass header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-cirrus4-onmicrosoft-com header.b=LyurSTkN;
	dmarc=pass header.from=opensource.cirrus.com;
	spf=pass smtp.mailfrom=opensource.cirrus.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.149.25
Received: by smtp.kernel.org (Postfix) with ESMTPS id 811CD1F00898;
	Wed,  3 Jun 2026 11:46:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 811CD1F00898
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6536iwut532894;
	Wed, 3 Jun 2026 06:46:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=PODMain02222019; bh=pZpb74SHHlxaFJ6qNN
	9RDVJSTrENq0JFoH8AMXsc3oA=; b=QRiiEy6qy+HjcAvRzUa8/M6/wATeNigWAF
	idQWTSoy2A8/5A5YVeAZqT+39nDBeDhp7gySWn5D3R0BPCapTgjEYAa0O4jYPjyG
	HGAYHeFHI8kEvXLzvg5vvZ7/Q+0F6qLigW3D6hwVWBplzB/nrtLhmq5maq2glWtc
	CYEaoiiyfT3wcsG7HcOpOoIEDqpjb73dXnYGmqwgAqCd0Wu1OgNKUPDTdRMLzbIl
	AtnPvYr8x8iGlFvNu4QY1uOn3+W3IJW3N+Uw7+ZunRLB8wJdMxqY0YvO2Rpa1hgQ
	ZBM5hbOxvkHTzhiXg2KSa6iVP4qdkESpgjLs1Q+SDbMH7QjfSClA==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022114.outbound.protection.outlook.com [40.93.195.114])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 4efwa15y71-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 06:46:26 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rL589euuEw6z10Vna/MuKgRtbH/cHSJeNFy6f9iT2tvsuZP2YOGHV9VyKwXVhiIykzzk5rQzVSwgEh4/RaID/NZmsx8Bg3Q4K1swh0oCfeKvlQJVu5TRwkwdxUqg86MfdfByxX0fLeaVOHDCZmJLkbR7ewWIeqPFbsM6nGdHwGoYfWa7BzGe16xHyDvdHkNEeNEnte2CPSlR5NdeiNf6UbCaFIx1NMB0LkQEcqp2OOu2offZ81KMh0PJBZ7qD8H2JdC/64yoEC3ZnXSkrPYnMV4fJHIM3lN7FqCvTNhfvkofCp123PaX2QiQ1+QD17IeJunWlyPeEiAKy4XMUqy8Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZpb74SHHlxaFJ6qNN9RDVJSTrENq0JFoH8AMXsc3oA=;
 b=lgpjmPrnreDyFgtB7Ras+5sFoLXJPq5ZLJ+lg0CKaKuWPnm39sDi87C3OJHre9vktZjO/60WhVuhkF60zb3nOMf/8sy+Jxx/B5a+uKwPL+koyki9D3qC73WhHPBhcqzVIMt6WAJLzbKk76R6Hq2nFfoxn4ep+HjMUvU4SLDv0plQYjn/sJgkKYibzPyHr0W5Uph0Fh63uCYFMlYwnXBNIllc0oQon8GJJKLotrNEH5xZkpY6VAeyKWbJXW9Ra5VHucK33SlT+19aCe0rq/BHhAPW3S6RjdVfw93tMXLKaWZjWy2I7KgWoVZbnc4HhwM/715Xc0XdbpnN94cxXym94w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZpb74SHHlxaFJ6qNN9RDVJSTrENq0JFoH8AMXsc3oA=;
 b=LyurSTkNi8TZ9K0dRKNMoO2goTQSuMto/iXzJHUjnKi7AEqbaTxtue6+/0RNmS7P92kr/oxMwnvi1SPW+J1huMR8mhdC9u2b8KiprfLNsiIiYyXCLfuL6glq8FD0Kq6BJhmx63NXwHQpwETxKKOisHG3lVw+oijHC6JGqtwuxMk=
Received: from CY5PR19CA0020.namprd19.prod.outlook.com (2603:10b6:930:15::19)
 by PH0PR19MB4986.namprd19.prod.outlook.com (2603:10b6:510:7b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 3 Jun 2026
 11:46:21 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:930:15:cafe::2c) by CY5PR19CA0020.outlook.office365.com
 (2603:10b6:930:15::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.7 via Frontend Transport; Wed, 3
 Jun 2026 11:46:21 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 84.19.233.75)
 smtp.mailfrom=opensource.cirrus.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.5 via
 Frontend Transport; Wed, 3 Jun 2026 11:46:20 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id 715F4406540;
	Wed,  3 Jun 2026 11:46:19 +0000 (UTC)
Received: from opensource.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 4EDC7820244;
	Wed,  3 Jun 2026 11:46:19 +0000 (UTC)
Date: Wed, 3 Jun 2026 12:46:18 +0100
From: Charles Keepax <ckeepax@opensource.cirrus.com>
To: chancel.liu@oss.nxp.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.com,
        david.rhodes@cirrus.com, rf@opensource.cirrus.com, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        patches@opensource.cirrus.com
Subject: Re: [PATCH v2 0/2] ASoC: cs42xx8: Add SPI bus support for
 CS42448/CS42888 codec
Message-ID: <aiAUCmZkcmmBNcYh@opensource.cirrus.com>
References: <20260601080224.1410292-1-chancel.liu@oss.nxp.com>
 <20260603095041.3906558-1-chancel.liu@oss.nxp.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603095041.3906558-1-chancel.liu@oss.nxp.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|PH0PR19MB4986:EE_
X-MS-Office365-Filtering-Correlation-Id: f5d2b1db-75da-4fc9-6ef0-08dec165bb39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|61400799027|30052699003|82310400026|56012099006|11063799006|22082099003|4143699003|16102099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	z98cPcRnl9KKXcrInEWOHX17Q05CSkqf6O97VJxO6Gbsb6Q10Q925Vd4J87XMJm65/zTVhB3YKx8L3DV3AH9vQHdHCwHrdvFx1iUe1dDa8E7MJL45U130PK9QQb2gn6ErHFnCrLZbu5+GfeUxD+sb7ABe8T9QL9H5L+GMSgT42eQTEvtdmZDUNPcbviIlZNl1RrX25iL+pVQoHNqr6P3hcwwVFZBoNBY688XPzb7KQPH7//ZzINYlHx2+9XrsJrX9KKhMr8/gU72Ii8UiYfqLNk5yaesYaXBesy/yi9s6LNnQVrWoE/Hag2Gtr1ddJ1wjg/T8178wpDumGP27Xnczmt1Sa84WD0gFUHQTTRme8siF31G+S+5RziEEfY09lD4PJ5VOL23Eyr+RECLRrLvuttZCyo8AVqXEPBE1fZCx/FvBHlu/Z1J04h9tMAPDdieIESv1M4EDv8h6i4ASPNb9b+XqeNPnf2KWVyvZ5gnTjOcN+3X2cf+c6PSQAAan0JahE4isNwyML2LxI99BELHEGvr+HvE8CVJNnW/U7i7qQpx8mzG/PSrOKJ5ho1wQOUOmckEkL5kXQIYGIwWeGjPYvdexiZnKKfwht2vva0V12tc+VDTz41ZA3r5n5/0iDU4++85uYeGWiQKCL2l8+dw7CFCiiAz+inYuxv3IgX25pKJvSJxaYi1Eks7uvp+eS7Xadbtkt4txTV534eWkTu/rLGauF+o8ceVpGVSVupb6Fo=
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(61400799027)(30052699003)(82310400026)(56012099006)(11063799006)(22082099003)(4143699003)(16102099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7yQII9MAv2FmsGpZ7Qw9JI7dSsgDDzV3fhWm+JQrKHg0NTSV2f5b6kArdNc1qJinfOv9EtbHsRgDQ72ecwwVI8Zc31YXsZrIL27Peoc7TP2laFE3i4P0REIVSKP+7ESv54zexOsm+xu9fuR33thcWCnJ8F2nlEG1frTj0Gpb5ATuxZ6quhaczvnTGU0R8L1XEgNYB4do6H7h9PTFtDnPFsGU0RQmflYJGOalT9EKzDXT1nsJbBKOM29iyzBLTBJlYgM+sPRm7pejr3P9w7GeAAHGw7npre+j+mS1xkolU7aHHmBGhM99Jt7zRDjF3xOs5lDFUWNZp+GMvmCfcRbXP5ClsjIcvRbWrOQYnZa75VF0rTKADievZ077J7bKaxn6QGeokyjtbPFuKG3azSKbqcZXCY+sCoJYnkG0108UEjVSm8Xu4jC1UMgJktKFYbJN
X-Exchange-RoutingPolicyChecked:
	POR/1b7ZA3mSfY7jK5V2kbcuvD4ZCrnWLjhvz3MSH6zn7537RmzO/Tyicvq0SwRj7ijZvdKg+ieUooj+l7ZcR7tOu80QI0lW/TQ1iaI+AjBF1DOzzCf9YVupYxyrRJeZA7v15N6Jxs3QPFx/ui9szx8Sfbrvg4hsd4a6wQXI0jEJrepk9sZ1RNRcKVrmpP0GowWg5rdDZ2dg37L0DKfPwAr2xU6uwp/BxVL4dDX57CsiK/gzuXsho9nBIljdQRWhx+5XFfrhdpE6gAOBublk2CCCS5C1XwDPxrLLWUPPYbR9+2fU/XveJyT7hdaNvwzCuAfVbqdU/BF9CgCw1AI3zg==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 11:46:20.7201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d2b1db-75da-4fc9-6ef0-08dec165bb39
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB4986
X-Authority-Analysis: v=2.4 cv=WZ48rUhX c=1 sm=1 tr=0 ts=6a201412 cx=c_pps
 a=EUUFQbW0xDvYytXbvhUq/g==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=Dj2-6B8FqX4mGL0U3gbX:22
 a=8AirrxEcAAAA:8 a=w1d2syhTAAAA:8 a=nsWskzee9EamhZopyIcA:9 a=CjuIK1q_8ugA:10
 a=ST-jHhOKWsTCqRlWije3:22
X-Proofpoint-GUID: 0FY2-ugb4VgtVuXa49th_jmi7qJ_vBhC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDExMiBTYWx0ZWRfX37+SMriITtvu
 HvFvmDqu6C+wGsWEFrri4zWvBNBNJCuZbOvbDtxOp40sDpHtCIrxNEIxb+QXnqTZSCoWS0euf6d
 AMTrHGx5AgeAFmi8gLhvhOBh9ylILy3s8XhtcZISlASneO7YKxaOvJ6C4/8zf+et6xnLuZ2IFPx
 9JdYYJ7b9Zjnbu4YCy3DXjypBOYeYEG499Q+Jo2lrP8PwAPTTjhnTVBWI+vWwI5enSwDpcG3oTb
 W/dfciCUcOc6mEKybbSvB3oN82K+61Irnnjl2PUNlmd9lMTwY6UN33kibGz0rwZu1X2q5MgbE1y
 1zzsRs1Y6F0khc3rC3bqc6CQmpUs3ZYWvNLl39KxNjXweIPcvuXzt+Q08JSTm0xkOnOu2A8mDPK
 LvgMXs1mIz4cA3nE+ORK6S2M3Lis5RdmlULPzVgY086iUqRIaxo2xrVcVCrp+K3Yfw9+f9dv1Ba
 Im9fUl8vODPBxfuq0mQ==
X-Proofpoint-ORIG-GUID: 0FY2-ugb4VgtVuXa49th_jmi7qJ_vBhC
X-Proofpoint-Spam-Reason: safe

On Wed, Jun 03, 2026 at 06:50:39PM +0900, chancel.liu@oss.nxp.com wrote:
> From: Chancel Liu <chancel.liu@nxp.com>
> 
> The existing cs42xx8 driver only supported I2C control interface.
> Add SPI bus support for the Cirrus Logic CS42448/CS42888 Audio CODEC.
> 
> Changes in v2:
> - Add SPI bus support in codec binding
> - Move format endian into common regmap config
> - Enable use_single_read/write for common regmap config
> 
> Chancel Liu (2):
>   ASoC: dt-bindings: cirrus,cs42xx8: Add SPI bus support
>   ASoC: cs42xx8: Add SPI bus support for CS42448/CS42888 codec
> 

Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>

Thanks,
Charles
