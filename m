Received: from smtpout147.security-mail.net (smtpout147.security-mail.net [85.31.212.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCA71E0E10
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 11:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.147
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731066907; cv=fail; b=Vxoe/Kwi80exo287TGBQposozR2+4v1eeMASJLk5MM/+hohF2PXY/bohOfkUuGPDgqoEYxlJTD5DCXg5rfa5mgbZBPua+ticvCB9+bRvW7JrPzTwzaqKhNa5OXFzW2Gp6kR+KA21hTVFEGpmOTa4TK+eHTHqqkGq6PC6jtsaqnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731066907; c=relaxed/simple;
	bh=4Ta/0z4MGpd0AfWHhNf32m6bTDcYbPcLjRbtNxNeAnE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EkEkqiPD0UAUgcYvwtRIWJTpaG0l5QdjSzZF7wM5+zYLQrye903QwtaEnz9vRlE/AM8OCmcT6M73yNRe8jFxQhmcDv2ypWXQNVV/EBVg2j3al18Z4BEGRGyUbG+BbcZYMSd5VskTPIrsrPoTuQs1toabuXkJ/b2MC6iouKGUQ/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=XWGSwtv5; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=iuT2vgCl reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="XWGSwtv5";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="iuT2vgCl"
Received: from localhost (fx409.security-mail.net [127.0.0.1])
	by fx409.security-mail.net (Postfix) with ESMTP id 8BC0F349BD4
	for <patches@lists.linux.dev>; Fri, 08 Nov 2024 12:49:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1731066577;
	bh=4Ta/0z4MGpd0AfWHhNf32m6bTDcYbPcLjRbtNxNeAnE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XWGSwtv5tzhVlL/6mbcsegBG0FhtAgD4aA3WW33TaJwlTddFLjitf6Udl4ZKSS0k4
	 0iflA4p8AojnQsJjDWZkFZVrnJBRLfsbAKybdBBXGjRgXmK5j5UUahZRDOs8tk3ok9
	 bKn9gONC9GHeEQL6Rs704kE0Ap5d8DYIDwE+o7ic=
Received: from fx409 (fx409.security-mail.net [127.0.0.1]) by
 fx409.security-mail.net (Postfix) with ESMTP id 329483498CD; Fri, 08 Nov
 2024 12:49:37 +0100 (CET)
Received: from PR0P264CU014.outbound.protection.outlook.com
 (mail-francecentralazlp17012054.outbound.protection.outlook.com
 [40.93.76.54]) by fx409.security-mail.net (Postfix) with ESMTPS id
 137AD349792; Fri, 08 Nov 2024 12:49:36 +0100 (CET)
Received: from PAYP264MB3485.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:124::8)
 by PARP264MB5517.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:3eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.22; Fri, 8 Nov
 2024 11:49:35 +0000
Received: from PAYP264MB3485.FRAP264.PROD.OUTLOOK.COM
 ([fe80::4116:2d6b:4022:7fb1]) by PAYP264MB3485.FRAP264.PROD.OUTLOOK.COM
 ([fe80::4116:2d6b:4022:7fb1%5]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 11:49:34 +0000
X-Secumail-id: <151a6.672dfad0.11a02.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GMAHK04jnqgCJu7QubUy5bDTQAi4nq1t5ib6nS70LK6Kh1KMnN19q/VvN8gvazz9QjvcR7x/noX14sAS+2GRUGbwwOAtj1arUKhKxSl1mma1OwlGsZ0p7Pfjjf7GFS3AOlLTBpATuYTl8RGwOR3rM4mkkdB+ENbiMlB51cGyvEGQmIltGh8E2r+JxIqbdL+UnujnVL9wUInmv9+2hUK3JqgpsCjcBwyPH9KTqcClhDKWFSkRmM+iL4+4n37KhE30nbgF8ZioVXFIutpXpco6LaoF6x98cNoUW6DbC8vtItnPpzvFD5rx5aeyZ9DR0PV8X1eQBMgxM2mmPo86oywkZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZfsEP7B9OPouM6kTh7X1IzXlByytnE5AuXIIOk9xhxM=;
 b=Y2hCaJQqfVSsfCpqhm8Coq6LtgbmGw4gFuf0joHg1Bwt9zyKl4QTFuFLjq/+GCc+5vQMLJj2U17NgJzXgBnhjTXneYGq3sRBW211kkK5aXRYoOHMmZxCznXwAJ1CStjkl6RwrCxpY4aInjAqiIyA0/1nLQFAX/o/dxgaLCwZQyKl31GbWdhgw2DfcrcGQBzy2KJ5Q3a5O6uXtsZn7z28NVFJliR/V4z6BUDcqLFCNXK6kvfVzWeZyhmeDt/S6EAd7cGVWbILogC/33rKZ0y9haNNGvydQFf9PZisGS60cnN1hr2PScQwxb5ehl53ipqGI45FLo8jT/CrX91UKJoqPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZfsEP7B9OPouM6kTh7X1IzXlByytnE5AuXIIOk9xhxM=;
 b=iuT2vgClORImaVJVpdbV57l4Eylx3GjxHUfaLxVahZckIhjzEVmiNSGrIGuACMpTKHtvi6obW3wJwN7gfncioU4y/6o0rMH34fpUqeH3rMjZDd5KlfDueG+Z9p+pCs0lIVEFTUmfUkqPBEgt8jsK9dO65p2kMjmk1z9kv7uNcibuYr+DN+OOo8ddesuuU24ZDdqTbyFIzYP/wQ7/fx5eQoP6Ip8lmGCIozs4jzhM6o83vhQ8/dOUMcbrv6ZvUle8WUn+EKx1pzyQQSKci88dPdoV7rJnnb5aPV2Oy1BgPd+BnUn2xKU+pg1FRlEGr8OeucZnlW20EpwT2PCP2WunsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <d0ce92ec-eeff-44f8-ae13-9f00875f0ac4@kalrayinc.com>
Date: Fri, 8 Nov 2024 12:49:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241106120306.038154857@linuxfoundation.org>
Content-Language: en-us, fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0422.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37d::27) To PAYP264MB3485.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:124::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAYP264MB3485:EE_|PARP264MB5517:EE_
X-MS-Office365-Filtering-Correlation-Id: 33647f27-7693-48e2-73bd-08dcffeb6a37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003;
X-Microsoft-Antispam-Message-Info: pEksLvY7EBZuDLcpRLu86BExNZip2854bwgOYC0ggfmH5iDrtGLVlGHkozIETHspFYDc1KmjtPKCNex80apTQY4CzleJj/FcSOrvIXxLrZESBrtCMXFWhGcUUEcvbllqFz1jbu6b7qKEyI/wq62R1NjjVzU4gqn/P5JuhItqVMPclcpczWZn1+OLeWopkGKliNkzTaH6DGuE9+6VpLaAB4AF8CHvTqPhEVANucGXD+g4QkZC3VaMb8WL9XGTiV7Sq5KR4r1aLEN6mmzFojC06KSUEGRHt0yIu+9Pzex0NFuGYVOxxwKheVmHhR8g+sXmZGB9nzcCv5DtfzcylcTyvifpPni4d/9sPdRb8RQDI+2QxE98ypVJkY0jbTDneFq9cfkRUYiAXNpzQJNAsSz04giRiSWoL1+PUEex2auWLZO3DOlGL2Msj/dC+xDWXec8PKkW8bmrsuMaMiF3kBOybfVZCr5ghhBNoFcm8Fi2ty/izqVfDxYjjVQ2ASjgdabogL3aJPgmvglilpiRARKeW7b56C6IuUSvfnp0zM612tGNC0x17UxV7azoIXLqkthOPH1H2h/T+/XD+8jUAjc6DjSNvAM730hMMsLqpSHmhnc3unPkTQkujw3FkixLLZeEprDq9qb9HuwZ00v22dnY9i7A0IWF5ECzeq67Aj4WW9f+qfTfCpjSo5gKvRA2zWaJ/iKNbV2DnLzojyoBD7oy5CNqufuh26dTVy51dtMk0/MRm9HNNUbBp/Xvk50BFt+9S7uiTpStZOHFz+Ruv1nAJxk4elY/Li8bidIEn+q1/dtdZvBaCtwUHlcizEmQT91RRaMeEEGumpn2fDnd5Ot4uxx7dpOr0zP3YLqv9b29xsv3zNyMs+ckV8v3JJDSk1IC21L3x6+DeDr548H6zjB1SboxP0COxVGD50AAIMgC+Rnms3ML+vGkGn1k3DGrj6wMz7l
 oqUnIAaOswafe+tGtm0WgIZjbbmqS4kSHTEt44juxgIYS2Y5W5R4NH0lZkjyuIT6+sL/vL675rQ3aUGn0QF0V9hnWGOVTHTvJ2RWC60ZzdHMi2DLH/rajiIQ5Q1MXMb5M9LfgYDCAHzl1XMa5K0v+dc5mm2sUpfSgPUOhgHNCbrqOIFrsJqB51Ov+t56cyZ0QKBO+tyeA5hpz5s+daihJT3fvmgKZIHAR+PrXlprJEELioaBAQDdkUWsYj1hFOFWQ0tZUO7sqJzq3L5xuQlML3zluyKNZ1tMJuXxRVneP0pWqOro6CAdILu0/wstfpa8N/kITclq6XEdOKPGW3s3+TSouuYovTYQwy0QqN0voRwpji+N2CzAJdQFXqRij
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAYP264MB3485.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: cb50YnfkqBamgD2EZaugB7OTQO37IKSiXRs8ygEAw7b+n6H+EmfEmo28uEXcwvOELnzWuMDt+7nVWvVPIVYnmx/BCEckTtaE8rv9yJaHxyMOa9IJOVvV5Iol+/IAd2sJ/ypRT6gZukcpNEnahXuROXpKt3AMzZ0lhjAvjw5tLXciC+B/Mtp0e+PwM/3Q/KczI7Pyp9YLfORF+nnv4n0Wb8gTRGr/ESNrL3sc8La5R6l02ai83BJkiRNgAiUNIBA6VBIuHLaYD8jFUpYhuDRrlVPWcBasLyANiFBmm0pLkTf9rTYeyGTJfKK40EJ5c65RItW0CmuVRJm68EcRubC5zXEPX7ERzTE1x862KEjfKp/g+uAu/IRXQao5WIIbMvPGhhyfNIQHHgTPCUwxKxlZec8QUAtlG9hFhLI9etSP02vr+P4pH6M62+xplYSZvnLtvCo4Jts3ul/vt3EHYEro0W5AP1FMzUMkgvd9d7YA3cDOe6qD5QPVc6YO4gMzsaxF0KXrYGLs/fBK0md96R8GbMg59hr42owFdfvyIZa/Tn6XrylbrydC502JOnib7ye94x9taRJDF05eo3zKGyz5pnXYrnpR1bGEN7bF3fR6X1r2Jy/1D3rw1RAwe9OCdfYA5rGXxyGNBZtnazQwtxqHxKtXgiL7J0aYAsgLcKG8s/XZFmKxmzwmS/OIp5AMhAbpQ5RLdM3PwZMrnYic+bXQlCVMqv2TpmD5/uF6IhPNz9447qkchrnj3XbR/a4Vv2y2Jk+/sITsVPVecUcUG1aSjA33ioXejFbG+eSRUIe/jR6zIX9WTJnChneemC01GegZIOXVrkTPHVMjBngUXMMhspaNfuDl/jQvPtaP6fA0T6wt1TEHFjhsRin/BySTjJgIfmpJzp2yF2HUQAHsHETB4pS86jHxMImx0ItTkp2HrceJbX6sY/Bq26eCP/QHTeB2
 TWBuUqoKtgqPvHJb2OtsSMJ0Y0td5oo0tJVMGdEEVOxbkKDsHSdg40XqeVUZCzaPReTAPxv8VJX55ztsJLpm5++kEXCZGf2rN5tk61r3fue3Pjb85e0FuaTh9ln7RSYajO+r7VwJv/fTEYAVlBWIXAh9DEyKgrwKM2Y6eHr/6eA1gBSrcCdtJ56w/k5HZ4mlH6SffZOlEhumfgE5GwAkcx4V53dFPH0z0dzrIVDx2ZXaElsod245XE4CLxvch3zxjx0al8k0tWEB6ZASAoIXFlJZc/kDAuWSVj49KU5XVoDuc+8JYkbF5SROh3BY6j/qIGH5OvQ5e0v4cjti974Iv8SCFsXMCJRoJm+3uUFhUuHb8xTBh7ZyhIpnbcmEzq3mV2oGWmmrB7Dhf7NKTfAPsNDv6GPbP62s85KpEGbzT/Rr5kh88orCBmUTTzsx4LnyEYYoZCQBUl5w6pVx2VNSpbte0CCUFfQ8BSzfavQV+dA3EnrYaanaw072bMYt7wQREXvfIwSY+pl1l9Hx4qGtEhJdwYV9y+psjNOdhmyimEwzngZiUDzJ12KXLV3w9byUry3GSDIXf/UviEs2NTA7Or1WvXv0Zfsnkux6XZey9Y7ZvKVs2syjdsCq40lBn/tIPAiSs4NpuCxltnhbOtQZPv6lTRYBwU/fjFZ+f/VxvnRkZnqVrffy9UmAtyYFCx0p
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33647f27-7693-48e2-73bd-08dcffeb6a37
X-MS-Exchange-CrossTenant-AuthSource: PAYP264MB3485.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 11:49:34.7357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DbLIYTEL/KyfaFlCRc9S3NyCy5/GWQy3gxCxzfVrEl2qjkGxrUHielFIobEfRoPsEIY/nECvyqB0LuMF6qmBqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PARP264MB5517
X-ALTERMIMEV2_out: done

Hi Greg,

On 06/11/2024 13:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
I tested 6.1.116-rc1 (17b301e6e4bcf) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- 
Yann




