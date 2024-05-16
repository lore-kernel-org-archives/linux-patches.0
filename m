Received: from smtpout36.security-mail.net (smtpout36.security-mail.net [85.31.212.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE6914373A
	for <patches@lists.linux.dev>; Thu, 16 May 2024 09:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715850907; cv=fail; b=jlA9X3fTYCSSjb9IdOx5HkGSuT592JvyPHVQh19qTckJE+huIZSkjQDEBBt1RZtjhKzDMFjBk9FWe1rO/XBQ4oOLbScrvnf6rAf4DOX7M6wVCEIxTb+DxEACJR7284XX1hG/3ALZ1zYfiLHHf7WxBIBGrKi1uTNc29lrJLoqmdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715850907; c=relaxed/simple;
	bh=Gk97dZ93D1jbPehlZpifsIayO1o78Zn1QAGKkvOAPIU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OGkqDU2/x97lcs87wAI+O192A47rVuAphUJbPWULeE7Bcrgr4HY8rP18l5VNdXlJVB9F/juqahYz+uZhNGJu+JFMMg/uHYwIdbLUzJc03h2u77qV27orMOCjr5fZbsPf26qKCYtju88RRoZyvyiE97wg7yRQ8XSwR4X2tVBHENg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=cmmZPd2+; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=cpG6DbTl reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="cmmZPd2+";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="cpG6DbTl"
Received: from localhost (localhost [127.0.0.1])
	by fx301.security-mail.net (Postfix) with ESMTP id B486F3D0ED0
	for <patches@lists.linux.dev>; Thu, 16 May 2024 11:10:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1715850653;
	bh=Gk97dZ93D1jbPehlZpifsIayO1o78Zn1QAGKkvOAPIU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cmmZPd2+98eHOCfqRu62eD0E7SduEfGb78p+KUu9ya5NdAM3uKGQOmUw546Rv54sT
	 TyZHrFs3RQQOaUox3fafqaPNuNcVtZL82NvP+83UWwca5gWEjKLvjmOyJqS5ZxSidP
	 56XBNhBpU4gB01XvQHr8fwv1T1Oc8n32PBVJoJw0=
Received: from fx301 (localhost [127.0.0.1]) by fx301.security-mail.net
 (Postfix) with ESMTP id 6E8833D1433; Thu, 16 May 2024 11:10:53 +0200 (CEST)
Received: from PR0P264CU014.outbound.protection.outlook.com
 (mail-francecentralazlp17012010.outbound.protection.outlook.com
 [40.93.76.10]) by fx301.security-mail.net (Postfix) with ESMTPS id
 D3B673D10F4; Thu, 16 May 2024 11:10:52 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by PR1P264MB3511.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 09:10:51 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%4]) with mapi id 15.20.7587.026; Thu, 16 May
 2024 09:10:51 +0000
X-Virus-Scanned: E-securemail
Secumail-id: <575b.6645cd9c.d2d8f.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMMBLEwBE/ObnHKQ4khNT0mpp4RqPE3IrUG9HSK2mJwo+3+qFDJHyC87qO/OZxG1Vrb2p3yLGN+EaAxm4shNCy61GREWDVuv0fb3bIVEMyy9qLCPGiULpfokIpxngUYPXLMXAyReio9uO3rqn0KHRW40H0DP+NhE7SqfFcQt4B9cqeY2uXflsVfV2BMV76GGcPLhoPvao3Y3jkMswkFk7OFP5KM5kBfa4DOLgDXvX/sW0AxgWqVntAtnkXXqNbjWoyUmUt2FlqG+CLxRNker/cF3CSnoy5KOf24mjpa8k13tJRAt6p/6cvctVpNaimJvd14DJnrvvfP2lo6xwZRNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSwz5Dq6FqvDtkKK7Kx8CrgM6PvxxFnc83+LktgGgug=;
 b=bmNrdpu01GleGm83Ya/+uqwR6Th2q5+mk08HNhJYu9ZQSO7Zuk9Avot4L5vvhyi94yTXO6b08odmBkopIPRPWAIp6DYvQ5wMHhBSVufNQ60n3esRUT+TAa7l3wS0CJJ+vzKwr9NBMzKOa+r3gYkbOZKSPLXFxuKH2gF85ftYBSEGp0djXTi2dDW9wLlt6mi8PIW1VTz+tKRNPOCbVyhGCm+plq2HVPwKxCnRqBlsPoiXZ6QhXFxZQiuaztco0ubjH0xez3W5Hy0TWagiL9+yzih4G/YKiw52hn9IogSePPcsfVHp0vTXfNUPBFPjLddm2QSd5wxrlVrx7rANXjoa2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSwz5Dq6FqvDtkKK7Kx8CrgM6PvxxFnc83+LktgGgug=;
 b=cpG6DbTlQ2P/iKLPbscBYpFtc4yumxYPigVsaJ1oltIFtfPpnCR4QCLnT8wOfV8dNoFo9Eo12rKQW3ZIub8CaVys01l/Ea/tTfoQeRNdTJ6oN4SORZsSOr9gXU+agQAJylZShPwFDQ1aTnQhBat9Pr9MECdae5/jnt0Kv/giyV1601T8bQX3P5ECW0IAyloz74iSL1RFJ1kkJkC/LX9KkXCJRieq+up13XUi9sbWtSz1UCLyCrIgiFSSlB+S8lz9zGwR5KtplSrpg4X+ToaIN4Amqf8/Scxarbw726Bin/rxKUzdKA1Ix0zFFvc2WLEuTw7yb1GqMs/83H5578Iuzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <7a8a015d-24d9-4bd3-a252-988f5273978f@kalrayinc.com>
Date: Thu, 16 May 2024 11:10:48 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/243] 6.1.91-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240515082456.986812732@linuxfoundation.org>
Content-Language: fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20240515082456.986812732@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR09CA0022.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::14) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|PR1P264MB3511:EE_
X-MS-Office365-Filtering-Correlation-Id: 45aa62be-499b-4cfd-9b37-08dc758814cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: CKgO31rDIVR80w7uwKkQ5GdGz9OUZvnRGxlqq08ElYbP0oLS8ZsodafFv09la2Weealuz7oJuEffxbwOKcurseqizL7+EI52y/aJ7auOcJgyUah95bFm4e1eLUKeslgB2zX4qnMGCu1eyOKz/s8tSXLBnsWeQTv6HepXBzzE5yRyRAop9yDvZ6UFweMgODkADIHayM0HOKCpAUxvXTmoM6s7xCa3/74HUSYtqjVHCFkwD9z1k6KRrnRbItqklkbdTnBZ5Oix0QiU6QcuPpIGPXBZNz7xpj8Nb/sjcgrJccDXjVZ+dwWW/yGd5F6bo7U3GLQGBPaPSLV8U9xhlUz+q75bf6kx8kipkKnWow/Ir/Jepu/8xBEuHBylgyvs9bsSM+Y66ytn5kr6fVsY1rhtJUGM0lcApnCYuNfVqZ+lZmLOy5EB/GyRKSZv719JyzavTqRwbmAWVrN6GSup0q3pesEqeqLmx3vRhrSQ7qb9uwYPdCV4hAccFVJ1DS+zLrpkz8JXsTNFrF7l2QPgqBO8zQq6PpRGyEG4ebOaCWFSzBNwpcFUl8VZ9PpA/ojTjL4SQ9gMBCN5+UN8kAQiaTTzPWXz/IHZ+0vOooxourYmirZUqJx57mW5KJTnIk8MJFCxpbfPFCsFFrDsXAV/cRGi9W4uurkwOnREzGRJK6S0G0G4XyaM8dtUsyt2P5M3PiGostTN9I0uJf3PUAJRB5Rs4loC6wgdFzN6gjhBaiGtUE3uMgFwdBN7jX33Sf4DoJX3o1kpBKDhb/YJW1Oss/tx9zstKlqUZpcGHQdx5sw5sdgEyQJLArZzIaV1inK8k0izLHgv2M5xcW0p+4H/Xx7KnarWTteYFY+G1NGwQ6fwHhYnJjw0x4/1pEb659FQQvgnmx6NEcLu2onNXdd/GhnzEaJmv/gTn+sfJ7L/XFstTiQdcK8otZWk2q8+u3pvEGYoQL/
 PitfbMgR/02roedsmjNZtHwdRN65emeb3oc4aglfhytD7mXNW0qw6mCdFJGy6VVjNTbNeIYwh9Uc5l/R2IHNS0HJxRrYD83SlfhuNycBJ06Mox7u7KwNM4SWDEPCFcAQt21Us/WHafmMikKOBR7YHZ/IkExRwzpBhRPWbcpS8/+yJM/kWvLanWR2Nz/WVqz9mkrMw/+uOiRDHxFL7TbUaLv8yO8GR1XKF3SuG2rXy/+6K+ZcpOwFAa2u3PQXPr4bCxCcK9A7pp3TNBb+MtP618CbG29F7WzP9z4eTy+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: ao8OStSqmEU2P3Z/OZHzowA/hZjArs+240tkugjwrZQRi5As5OvCRxQJPUT67qacHp+lLCFqJ0UB8aLEH3MI+J7PfoCP/GV81bHjWBTBiLxCZBhYuRCVe8eXBOFY5LlK520THh4Im7IfxcDw3nCSsuAKXmuoxjJaN4zxCoXqlDo/UJgMjvbhRrl2ExSptE5xrz76ZzbM4uTBHJHAKLk223TbcsMgQrJHPAYjbX6QCP1BpffWxfVNdnVpSn2QWMreZ3lSTVhv2wK4QVvmEiKWIS27mohE4cv5iPHYl9kK28EbjqaYS88wUo4Id8Rf+CP4dWu7f0wgcM7XeDuuR/ViekwSn3U6a3cUiieN6AJ9mr4J9y6jC707uCj73Ltf4ZGKo9NKsthEd8SmBgZZ7YjVj75bfXslrQs1IGIsrOm2mz0i31OCiuN7Wk52x8VFQGFwGtrXHYpw8Sn7RbmmAnVtpGZLZUFe6AsgPVsXwBg0D/CzlCQAkYkOiTs5uNxykiG3uPHpyOY29mOFsI95Nsal6IRcsHUiReTXqYUIsqupA+uJJtO4w7QJ560DeUXbuTnxgm8F0YvJ4HCEu5ylBLuyDYEtNEL09+7KpiwkNK6pkgPp6BpDmd4OEyKX3l9YpVUAyqc/e/7n4os0K++ifdF1jYkVVdCSzn+ILUZHwm2dRyStPGFo5h88YVuAnmCs3qjsqcoS4vMcIho4qQ0g1c1VTcMPCn4DAsjW+I0r+/HNWecOxNsFCYJXyxAv0br4MM957zWcIsjLq70gjhKc6qX7z3fUm7jUDEFWYSwM4T0oCRdYNs7Z0Hf65uyvYM1ZIHTWffFhD30q/TwvlIqhtH8qYbG8PZoGxralChQTHaD+CA/E3SjSfTuAJCFWEplYOrKAXlN1ChqFI+oxeDS/Z/sGzGc5bYJvWW+PQ4WitzOLDEIgJZh1bjdsT595K1kLy/qf
 5T66ivC0jwP6aZqJsEIL0oYv3DWTKAdTAeeatHSfsGRUIYC+PyqBIegP2060iJHHCuSoog4m3roFJZM0KrL07RH1WEvVPbbyk0TBF5Z8Js+PchgbvMYIdrVvNMqWyYQesXqcS76hp6myM3L482KnY7INcAo3m1YJQtisdX8HJTmiT+5oANzcCQKQcsuVDEKxeoBK6IqxBFi0Eg56MCOAHj7PGxHtxWPao8Ctje5VmpnMeC8PeXoH6mG9dd07FRdMndMQ++/Gq8dh7HPIvBXmTCNTdEEMa/TXScwERONK5t4LXcdVy8VJYvl2PWWx91TCYlkHKRK3f6C7Sgiwmy1UFXUmPHPxo44gKIsP7LLwEI6j9ODmwKLwrL6Co57wkbkkVKzQc17ZdQa4ECOKtq6XPYac2hA7XwtZoTjrzJZxHyEPLgfbZ36tYpyoajMFeRd0q8Yos23YCzNvIwDQxRGItyrQaie+0nEbmEFRnFj+qd2Z97iwAQO3c3Yt7aLjcL/ONqy1zfS1le32jw+YwtlsZNLbmYcQ1JUvSc0lvCMMl17fQV6448iWROOnT56GaGAuYvlZnguU9IRo4DjNbdTjC0Thm+zVOmeTCDwJLJYwER8UTR5tAwv+QQFzDkda0IoNsFIbe7b3SB7wZ6qQxqbuOQ==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45aa62be-499b-4cfd-9b37-08dc758814cd
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 09:10:51.3906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QJtzNeFVmIp8RHXD69CMA7qcpeftJ4TbBxdNCnywckcsKpkGSDtnpDSZ1JFhC0+J4Rs4TV3YJQ9ayeYb5Uh3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB3511
X-ALTERMIMEV2_out: done

Hi Greg,

Le 5/15/24 à 10:27, Greg Kroah-Hartman a écrit :
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.91-rc2 (ca2e773ed20f) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu as well as on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau<ysionneau@kalrayinc.com>

-- Yann





