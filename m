Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [216.71.153.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF76AF97
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708636738; cv=fail; b=OT7uJI+ntqrR/B9BUu37LWB9h2RksnBn+inf3I4C7JaC0qLdn9q6ZHvkE1aMKp+vnEJJjk44LHVN9W5DKQCB0ETDg+ENPeDhqCc+yYdZ5e2ql3B79DHTmsv4ZuCkC3ZNQN2lsdNrm+fAt/OzPD6RV/qSy8UMz4pi4Uun5ah/BtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708636738; c=relaxed/simple;
	bh=JNVVi396xa2NT0d8ZYJ2mo33jD9euRVOh7oeAnHzPq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CT8fmIXGvZtqz/3GePEruGKvr6J3cP13I6JHezV+QAhO/pTmY4W6Z9cIBkyxDpnJ2SQn4B7w35mMJHv6jTewnCJ+VSdLyTsumbyYlg0QlTvfwQPCK86A6vvdCD9LupMvUQmbBIhXXk8ia2Thedl30HjK8LHhEJ5gH8ipddCAQFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seagate.com; spf=pass smtp.mailfrom=seagate.com; dkim=pass (1024-bit key) header.d=seagate.com header.i=@seagate.com header.b=RX8FWRvq; dkim=pass (1024-bit key) header.d=seagate.com header.i=@seagate.com header.b=cIqJsB97; arc=fail smtp.client-ip=216.71.153.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seagate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seagate.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seagate.com header.i=@seagate.com header.b="RX8FWRvq";
	dkim=pass (1024-bit key) header.d=seagate.com header.i=@seagate.com header.b="cIqJsB97"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1708636736; x=1740172736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JNVVi396xa2NT0d8ZYJ2mo33jD9euRVOh7oeAnHzPq4=;
  b=RX8FWRvqznjd6ALXIZCvLi57yWIVgddznUFySNQjVm5D0VcoNMlrGYsT
   YcaIui1Ehmq+dscTdhNqNWU7Vc3IGqmU0KGXqbea56kJp/zK/OaPz9QJf
   oAvtanBNM0z0y4yrT/SD1AlYSl4GrWB3/v1Vm912Maqtw9uK8d/4hmZtU
   o=;
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 13:18:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWcc5depJqEk99Zutxi+FL1GbUn/iCjTfvqAFFWy47hc4jEjKYg0xPRjnQUtUMbvh0207lq8taaNpWNDK36Ut/c0WxODqS/o5PjoXYlemRNnCfeV+1Fyn9LQ7xMyZsCVD5PQBdclAvhJ1K/aa1hCNtl29YlmXx5b76f2X36PDqLXPphTAU2WNu+PR31XMDy/r13cv9pK21K6+CE+YwsRJOFUlROWqMvCNt+ccv5WJtvQfLI0JvuWnyK/N85FPaewyTvP/RH/hD6Ep24g7aMSZaIcW1/orBklDjURuP7XChFCW1Yd5k7LTPx5VxanhRQlFhjDf/kfsYyIs+TvcBYSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbTru4NpSzd4dLsf2NWBCpxiTGNnAhW2bzL5MXGRl4s=;
 b=USsV3NZuuD17ATWToEooE4EAM/eTjVh8eQ5mkCS+LFXU/Bhi22/IpPoogpzX3R4DaXsBkua+cG5kMsplgE51txB5ltd/WbN2fggdQv4S/+CkTMgyqpLQOxj51lQ1Wnim67opAf49QdrHVMsp96DGEhCALMI5wCEnww2JY0FxCr7rRxQ7tDMhBgwQFYjZY8cy/Bf0FqNwE40c8/dmscOKbWm6S78l1EdWhg+VNn7cS5cqkxbEjhnc+Kd9MbHdDYymQA6WEwHyJSFUjwT72sX4tabQgMJxrw3echhVLoIZBGijX7xjYL2Em9F4C0K24OUtOpbMYgnCwaiI9KjJJLdCSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 192.55.16.51) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=seagate.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=seagate.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbTru4NpSzd4dLsf2NWBCpxiTGNnAhW2bzL5MXGRl4s=;
 b=cIqJsB97ast7Au1ZsttSzKFAuBAAlIKlPsfn9EEmaSCxmgacBxcyDHo0jDssYdDYcInPYnSYn62XKxk8HhMMXdbbrRnZZFg5mqsDsELsKRlfX8+e9OeuceJLzVTLCWKX2+tWg7MsdpRZb9jOpF0ccMdWMygOBFmfF3t0AASsQrY=
Received: from MW4PR03CA0173.namprd03.prod.outlook.com (2603:10b6:303:8d::28)
 by IA2PR20MB7493.namprd20.prod.outlook.com (2603:10b6:208:4a8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Thu, 22 Feb
 2024 21:18:51 +0000
Received: from MWH0EPF000989E7.namprd02.prod.outlook.com
 (2603:10b6:303:8d:cafe::87) by MW4PR03CA0173.outlook.office365.com
 (2603:10b6:303:8d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.43 via Frontend
 Transport; Thu, 22 Feb 2024 21:18:50 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 192.55.16.51)
 smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from sgspzesaa002.seagate.com (192.55.16.51) by
 MWH0EPF000989E7.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Thu, 22 Feb 2024 21:18:49 +0000
Received: from sgspiesaa001.seagate.com ([10.4.144.52])
  by sgspzesaa002.seagate.com with ESMTP; 22 Feb 2024 13:11:41 -0800
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="114056584"
STX-Internal-Mailhost: TRUE
Received: from unknown (HELO nick-desk.colo.seagate.com) ([10.37.50.20])
  by sgspiesaa001.seagate.com with ESMTP; 22 Feb 2024 13:03:50 -0800
From: Nick Spooner <nicholas.spooner@seagate.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	conor@kernel.org,
	f.fainelli@gmail.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Nick Spooner <nicholas.spooner@seagate.com>
Subject: Re: [PATCH 6.7 000/313] 6.7.6-rc2 review
Date: Thu, 22 Feb 2024 14:18:18 -0700
Message-Id: <20240222211817.24480-1-nicholas.spooner@seagate.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240221125951.434262489@linuxfoundation.org>
References: <20240221125951.434262489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E7:EE_|IA2PR20MB7493:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 7096afc3-d83f-43c3-26fb-08dc33ebdd57
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/tM0LDtAnTg8kYuAXO82MkGZo9BTfFAxsAWkwLMUMECAStpStIZ5MCihuKwwyr5ckx+fB/rtBbuJUxKpS3geDnjhHeZoIcPkPM4JzIVYTy+rHp1WNEg1MqfNDRj7Ftobk64oRnRVcOkxhayY6dKbxOvAOCHwn4iQxk461ReD83QJM3kN0mP4RrkQ2r5IAUqS3Auo5viPcnAhJOCvbn14KieaVJ9RfYtFGdKoQlvAIBA+lh9ZdkzYI94TAQt4XOYN/dT2gFmAY+s75rDCh0ekOyRtJ74/a/Peus65Eqjjzf5wMYSSlOkJPNB+ZTKfM3UEVupEewLa0na8NcdO7uA18cpcRNpIajLCiHDbZDNO5vlHgIWgcHltqukuU7/HWLtTmYTSyQ62M37K/5XCZwnKAO3cpFhrONSyX4DBtfG2UyAq8RMzg/qncnIOBt2OQzAQsbTg+Ne3OhzsgbD0gX1KdmN6vd6vIr3FSbAVo2o0gKNdlnL45fcLa0RpXrVj04H4lBFkLziF9LMpOiq9xyX64vUdi2Fl2646g1QezJ6YcfXDdzA0jk9BuLDSQoNsTerKY768HxYswacyT8BkC0//XAJtvaRByE35fNfI1K0K6y/Az3fc4amqMb3UYB2wVeAQncBC2tjPgBmXzxOEVTqn3g==
X-Forefront-Antispam-Report:
	CIP:192.55.16.51;CTRY:SG;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sgspzesaa002.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xFz2V3UOw260Qa+HFje9HDlv1WOe9e3Tntyqyl/gV6/0sJXolz6VfsN5Bsu+vga2mbu1qZu+Ok+uMNUzp0a5wOSpz/hbs8c4PnkyXUogTaVRdwScaMIF1leV7NlOEN0K4aCqjSNNVC4Tz5Oq4yLOTCIa/quPMkU5J2QUC8WVBguvjVohcZ6lk8DaRuJ43yY2pNQxSVLuv/EkpwI7RqtPMwlsA0kI3h2gSlExtsPy7hpfsokrYmHM2bbvlI7ZcpFqfNCUdjky083LMtrwEJeTVNfntdkDbAPaZMDAAfgC9nQZ21rUyR/ITJ1MBAB/1QslQ4K594sD6uUo/0EePkR8gzD5RHKdppyX0Va5ujALdI8TjjyJl2scqkjmaKipXXQVxAQ/q65C8ppXh0wJL3Jg7W+pldWeDLruijD1RlCxe32I9w1gwEvt4y6btJbpbBx6eLomUV9SBBWAcw3XKEgvbEhnSPpXSLFsclWV+0/I6cfYMcQMZ7hUf1De1S/aEEj6vKvhz/kdw4oEGl0F/fWdbSP6XjwlvNmETQVzTen/jpyUZ0UNkKtwjzBvg5Nd5BvwlZBIojF7G8XwzgDzH/KhKLej3WlxzV5+sQx5RQGn53DguMmNxoMqdJXdQICNy462
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2024 21:18:49.6544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7096afc3-d83f-43c3-26fb-08dc33ebdd57
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[192.55.16.51];Helo=[sgspzesaa002.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA2PR20MB7493

> This is the start of the stable review cycle for the 6.7.6 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and tested on my x86 machine, found no regressions.

Tested-by: Nick Spooner <nicholas.spooner@seagate.com>

Thanks,
Nick Spooner
