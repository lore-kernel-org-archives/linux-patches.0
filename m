Received: from smtpout34.security-mail.net (smtpout34.security-mail.net [85.31.212.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73230146D54
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 07:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725435005; cv=fail; b=kiy/BjYSZCfLtEe5Bpweb/wil3ZrKV6HVu1VDM5Fl8NXXYEe2YOdD/dfC3uF8GCyfBPpBUT+s9E5ExtngneHCrAutC4MK30+MbM0zRX77xD3Vh4T9NIZNaeDWlpLKB5n8JPeqoQ+35VmMnLdEQhDf42bVkEva1toZlG82GXl+7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725435005; c=relaxed/simple;
	bh=Sj/rJgzBoHYf3QYBPC+6jd9aYnvjPwMWhTTokvmQDrU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jHcEWf2GL5k78ffupGyFnT7oL62pnSRO1ikl0ZuCmjIDZEQIw7lwn6hGV8OsLyBnNc56HFgG2+CrE45kRmlloDcy0DzB58rMkynXH54/PFwhOY5SmM/FMXuwQw2PHE5/S5csjQgy5x7ske1OF4z9hfA4jsi2p9hHA6k5G1hSUbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=TWWtaDa5; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=iKkMIL/p reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="TWWtaDa5";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="iKkMIL/p"
Received: from localhost (localhost [127.0.0.1])
	by fx304.security-mail.net (Postfix) with ESMTP id 8E49F6E960D
	for <patches@lists.linux.dev>; Wed, 04 Sep 2024 09:24:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1725434646;
	bh=Sj/rJgzBoHYf3QYBPC+6jd9aYnvjPwMWhTTokvmQDrU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TWWtaDa5+A930Nr2bIMPE0QF7kTTROQhxRrmA9qmJh8vjBbQgzutokBqOS533A6s7
	 wIA2UETwrY7vMfzQNf9P4D7NeZBsgxDVWbf/G4821NsXfLby7Bq+kCU/wNROChfNJb
	 a2ULrrGFPmml1BQnmaOcMJxML0NlFb7dMEysENzE=
Received: from fx304 (localhost [127.0.0.1]) by fx304.security-mail.net
 (Postfix) with ESMTP id 573C16E904E; Wed, 04 Sep 2024 09:24:06 +0200 (CEST)
Received: from PAUP264CU001.outbound.protection.outlook.com
 (mail-francecentralazlp17011024.outbound.protection.outlook.com
 [40.93.76.24]) by fx304.security-mail.net (Postfix) with ESMTPS id
 B0BD26E8FCA; Wed, 04 Sep 2024 09:24:05 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by PR0P264MB2408.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 07:24:03 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%4]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 07:24:03 +0000
X-Secumail-id: <139d6.66d80b15.afac8.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JvAI8FYYp37HGkYZZUL0aoirlY02hsyV2S4hSeavsMkZ3xPzalNmPptLgxA7o2s0nqb1aSebyteB9F1yyr1h6/Iwquy9Pbs7IqaJJ8BWp+usrXj81fISNpGhJQfYMxIg6bjwqeiEuRj+pD9lZBLHALP5qwltRoU3M9/oKdp/DKOpAMtDpH6t4je0rlxmwXEBqt/ijVslqp0zWWaCqkFolSvdPVIllMy1th9wFyomdLXJstQsaWVoPuPM7eXW4EF6WQWXfci357FxB2sjl6Dp+NaPeTSQsoserhZnevVsfRTlA9/sQuFUXR2+sxDI9YZwHknhp4iReCddhob5He94lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEdwQomjGQiuiI74slAnmz4Efbo0cTxGEWQv1TblVvM=;
 b=rjpQgqJtDb3bY4Tibvvkqp2rrUNhpnTY4QnWRumwwbI43XPQ2IxgJg6LfpgYB1E99JXA+/ccXcE81W5ej2FCPDsjY0TGmcXA82eawEyUliA8RC2Jf9R7IJXLKuD/VLrPXPrkyxvgCaX603+5Rtjd/nu43M4j/dsOnfTlTuc/Lx3g41/SOM8C3K1ubGi6SHBrmuzG113+aAQuudVVAi1if8UFk9fosO3XO+Pac/E9hiQoo7J3j8vy7HYYZ73XJ7g475w8+mrsBLB75BWETQItpTo/YPPKRPxuMhUoLgbg57OyKjcUrNp/bSDXa+axbzOWIFnFISl3tW6UYnMDAh8T6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEdwQomjGQiuiI74slAnmz4Efbo0cTxGEWQv1TblVvM=;
 b=iKkMIL/pC90VYbse7jAQMcBTYFW5ySNpKNhuu5D9Z2FCJIfga8aT1vGPABiK6Y9vwVPc/d96c8ajqIscGgJbeKjOJQ30E0IeEmWrUGg7LriPtsEFMMheTSajaeO4OQASTVO92BZnOASzjbUxlf3cJ1gJQQmWmwhq2w2E6mfebjxjqOS463U1SioF9MHZ8d/K+CcK1vAOpDvw2m6G1xzxlpSahsNuX0TOSZb+KzRknaT1V8Ki3PbuahZtH6CCgTCK9GZgzRHFkEM3EQniHMaRgSotOoT3cRWenNySLBOlHenuza0GDxczRv1gvygdGAwplcplOZI8kHNKmRQQHI/nGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <4b77aa10-5ebd-42b9-8b82-2d0a10da95ec@kalrayinc.com>
Date: Wed, 4 Sep 2024 09:24:01 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/71] 6.1.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240901160801.879647959@linuxfoundation.org>
Content-Language: en-us, fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0054.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2ca::8) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|PR0P264MB2408:EE_
X-MS-Office365-Filtering-Correlation-Id: 590c6409-08b8-4f0f-7f1f-08dcccb28d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: 2yVuVgZ50AQa2pvy7UBxJOh8F2Ow/QNKTo8zyVkMifXsKuAw861+1QoybqGa6lu76dqfEVLMiszF31HKyalWL1hlLLoYX2bRQnLAHxYMNcRfKMnM7wtKFMYgacXYB0nTPwBe0kIza8gLqavfiFELLZ08qwKSJxNKq/oymzxLk5bRBn4+0HwNRqdDrd4hdHJOZB2N96M1oUpMVaTBxuOKU6R/Vh1ZNI+4V91hHKzkG099SbJuNSzzljUeKYkQQqfXXDd9NCvvxQgmyvCb0v01VBr6ecJwctGreCyKzC7fFcpyUzn5uk5p7gbHtI09FHHwNerM/aSp2rDzB2ajw2BOvmVAH2sDgvXe1CozzOLbSuw1VL5ZJNob0VCa4jp1ZNxTUcYwE5ov0yapGghdbGJx4svhe4ZmJDDHhZ0fTtoJd5i2bn1b3m8tcnJuOuRUj7pC8164kh6KCOSqLnJ/QMa1dP5mujYhJH5bzchiYHInDLwmrJC4Q96TWoajYWlJxb7DoCUO01GWVSkcLykkFyCPhIbi1H5zGLT/b46aPQY+gqTl0/xzqFuSoZZG5IWIUTnOWIz4P1doazL5yMIuzlAS4DhE6yAiVb1WX29LfwgmHBiDfcGwTipmYo92imaX+bpeYzgOAaNFe3+rwLCjOPglLoM1Ch/21GtvPz9knW+y1ENDSVY4XUN2Ws6FCrZFUWskdPjGDL7ywlr3MxaHpN4Cwz81Z7o212XJ5VVJ/IrxxmmWL1BLlqmqV+4dz+rnCc3oVYIxXNKKaw89er8Xb+KrSeNdCjH+hDkcQpemzvUC26DfcPJDVWOtxXRugEW7+TuZDb7Zf7guaaRu2hQr4QALOcRXG5mHtW1ovnPs48pBsdLJ0SJbSOrWzDCy9rmVN9E5U0KKWypBnHBKRfPWF4gCtAATsoCWO0KRpSVJevYeFpBd7rt7xIfDHow7Sl1G9f9RoY2
 kcieAjzvyRScGBa4cObnyR6wcHW5rf2bWL99Oiolzxpi2OtwQFsPDqFY+jt4gTTM9HhClWjGHmlyGS/d5qkCSx6KyqaKdJmMQj6+ITL73unePxpfvVNFhh6aERRnZRjO8ToZcFzxcGICAAOAJZ9/ww+2bMrbkaRLFXuYk2/J50RGlb/qHPrtaKf+q3E4zpmC4mFUgst6A12vcEEh6mt6zhEZWLUtjJY6IajobN1YBMTjJeRxANZArGVt4eE+h146RfCL4P7VD5Ea/JWlETkWS2cyNf3bwfT7D5s2R7wkhyshoJj1e7UWIeDgZdsSzpaK/T66fMzgIgNQGFcYXijt8LiZN14JkdR4KOKNjfVmb8fiNbRe+GLhMhwmf+VEE0oUkMsso9gWw2XIYJFdInqHA5HpDnyUZZ3d2PXgEkvE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: s1n7AQa96Y96ct0V7zPEeYXyZFLxU683fdXNdFhaILv+xkM/Fh64YNQeve2xOoPc8ORUWPkUGXnCsVqToXHgHHkSCqXT6ORl1YYWhjHcP0f0Y3p2HF/Ui/dYMrEiTvplEBd/X5Q3bjTMXtQly/OWcjr17+lNS7FBMFSmUzq4d4cbrmeF4J7XpPnquREDMLct5Hnruj4HIPaj0mFxTvXeWYUOqppVzxfP749RSe4gz4oEHUBPMwadYzQdBaBumS1pjiGoCWwghEUmZuypcLl1lT5r8os8K6z8S/lHUsCbrnjpMTpjD00E3NjmfOuLRc15TrhjJNK8bHwb7E7K1ZAIIm2b2TiYNd0GYxKTbM5ffjvmSqIiTWKAapOYuwLdJKN+r2n98xf7IjmtKLa/2AhNB7m1Eqxh1L3LxnZx7rraQ7rwBPGMGVFvzGYovBzBAuAPJRB0fTN1euL/YTPPmK8gZnjLp18nDPCNhDAXwRwuKC+XU7JKT0FHlnIW5tUkYQPVh4RVWzNwb6V25JJXclGoTj/UVOKi6W4JnDyaJLEFxf4+0aWiJwCZdKvRFpBO6vGeVEx3hRTGptUlo9eksEijfr2aq2R6a/OM2ytqJx4hD11GA86Wr0cd//5jkeQzZORifKYk7WdJnrPGib39NiCJFIrNhG0y+Wej6t18+tDHaqE7/ePitxb61R4pj97n+OKqR0K5bDjGgMA3iHk8nY3TolTqtcMSOfLputpvC2Qxe28KDvtOYepIeqm000tVGg7WjfQUKVy0mjRIN79I1vxwqX57iyZTDw5w3766zZk6cGnaPqq33BzCrRvkW9mUtQlCoBwVLEZ5YnzALX0XvYupMVv3bU2WloVs75cV9wSyYnhTEus3HgSAjxhlTnuQrI5ZeOqFrM2cdIlFIk4Sm1rZcUR740eTFyitk24c0Pw7o+h/jCDieqkfvAGlXOHK4COD
 ZM3F5YU8PfmkkUJhCPmP+DaDprL2IOiyECgdLLArsU8VUOgBwv+jZGajwk4kasA+Cfd80lFf//rzWdMLLhrw/Ms0FngBOGHDF3mtCx6h8q8zGpA+xdTQFnH5KS1IeY3BA01W6K+ogilxeaxa0ZdaAFYq3SKVlc0jpphEdkcaLOvA17/2MMC8HYhStFZAg18nD9tKTMf4VeOW8rx2JzltcBtN4WrIxfj57IIRvy576xO005J451PGtfCbbiKto3x/uhOdAtkI1GF6mUk0IHCj9kOtCJ3DVdZtbbbFe9nItE7vTfsYktzYYtKhGUYFd3OYdyhJOKhVut+uAzRxs1mpqRYp3d69xmOAh4wmwln7ZraH3Qt4yRTaHphr4RE5CGXLUBQoiCPDq7neVAsMEHnp9i5YICN+tTYQ4Sxx9B2boYEVj8XvsQx7RT8sw8jBMnuWZ4nzP9ZhJhnI9jjAdTvHNFZpgLPBm6bkiRNUswNnxGD06vzK4I2fFd5kk+9FXCZkORgjUFmDG8kxFCe4pnRSC6Q2hOihtR5mHhYEjPksK5YrsVs/QJQRlHRTkBGNJvPzwfk4XggAWHZj4m7SxWbUBST6Oa7AybPL8357fBAKtjcvaza3xz9SHNr/5Au1m966Edrq+UVd4mtNjZbjlqEvMQNQuAPSlZ7w3+3xrMMZDQusc4KYWX5mJbb9jqod+7682jdmYw5hsqWRKO+vdPUMjg==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 590c6409-08b8-4f0f-7f1f-08dcccb28d03
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 07:24:03.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5V7ifvi/ytNjRbsnIWUopm5ujqLHnBkqrmxwrheZIEDdE8ArMzMD+LVpuTGOmPzXX3fVG5NHrGCzy8a7685CDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB2408
X-ALTERMIMEV2_out: done

Hi Greg,

On 01/09/2024 18:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.108 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.108-rc1 (de2d512f4921) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- 
Yann





