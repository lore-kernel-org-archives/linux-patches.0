Received: from smtpout35.security-mail.net (smtpout35.security-mail.net [85.31.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDC4143875
	for <patches@lists.linux.dev>; Wed, 14 Aug 2024 10:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723631406; cv=fail; b=aAmzPyttwG16hBQdW0+DowaPgM8n0z/PdmCey1k4ie+acDrKlbOc51e4UC/7nBTF8n7rj5ADEOMMTITbRkVZSHE33xBLjQuWF9FiBZZF8HP0Oy8cqcuDh62RfrWCjmEICPpJbp/u47hx1/5KH9qAOkK8pvF3elqm3xrOHfmkMws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723631406; c=relaxed/simple;
	bh=i+TeQZsk2w3L2kzA3onIbIEHvngNPd1Cdt/9+NlMZgE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FAzEtPsQoEWdatL4Ctj602B4hS9SWnQ7eVIP14HIkoUYQePSgCAZl5ZkOghzwSFoI952/ddEKsoXiIbqsJfbCoMht7jl1X0KzxcAEHxd9303uACyG51di9l7jCOw+kjJ8FfQ8bi93yF5lrrkRsZv0ml6l7bnMdE8Q5S+IR2eY6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=P43pMssp; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=o+yBHgyb reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="P43pMssp";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="o+yBHgyb"
Received: from localhost (fx305.security-mail.net [127.0.0.1])
	by fx305.security-mail.net (Postfix) with ESMTP id E5F8B30F0E1
	for <patches@lists.linux.dev>; Wed, 14 Aug 2024 12:26:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1723631161;
	bh=i+TeQZsk2w3L2kzA3onIbIEHvngNPd1Cdt/9+NlMZgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P43pMssp5XeSk3H/NTNgLEcQ2tRxN/1komccb412nr9g24SK3lvqg3NFLb3Ph7SmZ
	 KEq3viZ33RWI2oOGxwPMAxjSwtCpCOIHw8YRQxTK9SVUtQNB21SOZa/G/JuQ8VrvO0
	 Ch55elL2q04Woq6+EIB0dGg/wk6cTD2Op8tn/11k=
Received: from fx305 (fx305.security-mail.net [127.0.0.1]) by
 fx305.security-mail.net (Postfix) with ESMTP id A229430F0D8; Wed, 14 Aug
 2024 12:26:00 +0200 (CEST)
Received: from PR0P264CU014.outbound.protection.outlook.com
 (mail-francecentralazlp17012051.outbound.protection.outlook.com
 [40.93.76.51]) by fx305.security-mail.net (Postfix) with ESMTPS id
 D313330F0C1; Wed, 14 Aug 2024 12:25:59 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by PR1P264MB1951.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:192::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Wed, 14 Aug
 2024 10:25:58 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%4]) with mapi id 15.20.7849.021; Wed, 14 Aug
 2024 10:25:58 +0000
X-Secumail-id: <9bbc.66bc8637.d0ac6.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hFMUzUcAYqshraG8i67BaChP5CiNypulHW3pvHvuom1gicEl7z3GzYwT2EULWL9lyE9qGgp1zYVt4GhpBEz2kSviYe+m2CNrorMxjv+R1KRF8ShFngIAXre80W8EwOdbuA3KioF0oAAbxt0528jqAsGVpSVEBWAzB+JJovCOr+Bhz3v+Ca3MpXeNQO06wdKRVmM9WuCBw0QJN57nYPkmJu6wuWSc73TAwEupqCUGEwGAlyToWhhoIiUtcSQ9p4QJczOnIKBmtqrXa+49c57A5Nnc2ZjdCyfvQfFPPFnCtz0dkykYDFTM7MRGnTjpcTPVV/lPWwX2peCczBHPeIVOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mNyCxX9CVdD0x1b9l4Htt/lUPHHlP7RtqN6a/saKN8=;
 b=wboc5tcc94kqbZMclO1l6fmCmUVkMIU+ZI8fF5xGgprIwjwm0JvXHDRoio2hoYveQg2Aszi5cuxBD8uyU0Em/Y4ey9G4xlCVyK/PCAbj6zOd12mbyrcrTz93+uewum0B/e91jFLgn/QR9hqaXIJUyvotWWh4kUmGfLfBfFFaH6sxu4amyJQuZ9CB+q2XMO2qUA3wfWYLDtKa9iUFZIMdPejR59wCSDZh1blM7E2Os/yeAZAC10OWK2r+xsq9YxgQXVknFjOL7aCXILtUdXFc9G1zaRx8dN1h8/p12I66BCBeXdB4qHEGBd6df3SsxUp+MdBMoQ0WpyerxDvtJz+QQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mNyCxX9CVdD0x1b9l4Htt/lUPHHlP7RtqN6a/saKN8=;
 b=o+yBHgybdYoLda83GQk9+1MckT2EOxUcfQmoGW1wwI30dEwrrrYaRwi/wrZpa2lms/jcHGFlhViHbShfwS1sFbVqGRkbMPTk4ElTIrAlJ654dpZgKqSEMO+5wPVMtZ/BB4ZEekOPbOo8P1XYN+56Vm75pHMU/+avfRn29WgWjp80iX+9Y1Pfsf5Y1Yf8wahxepD+whusRsxBzyr/2NQl91KgeBlXK3PqxrY5dGkZdKZ4kmpvStdaI0MUDHuhSX0Ixnx26x7VyQSb3kqncQ4C6O5KBgStOKedhEHXuDd+XUPe8JU6mPTaTk65rT3EuIiyxWl95zUzorebIDtpddrkvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <53db9c3e-a765-4045-8a9e-b02e2da5e0f8@kalrayinc.com>
Date: Wed, 14 Aug 2024 12:25:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240813061957.925312455@linuxfoundation.org>
Content-Language: en-us, fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0194.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34d::10) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|PR1P264MB1951:EE_
X-MS-Office365-Filtering-Correlation-Id: 9be7d561-0124-4ac7-d112-08dcbc4b7cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: 4RVu8rDZVgTEcBEKVSEDLKIl85oqCJE/G5cW5DXvSkb0+WUzPwJsGHEagRJ/492u7EpNntkdM4BEGiF+gL2GLScS84QZJJA1Fovld8vGbyrH53goV924/aUV5iaOyMgvfwPiZN+A8T/uWl2eIs/8c3zJc3xIrbNCl35+Dfw56Q9V9asYuvHP2pyKI3szse36c4P/kZXmIE9yAcakzqpEGbubCwvclyCIDCwFr4Nv/B1bLZUXq/nz9R29+SL5t/aRi/NEbCdY0Fxhh4EQhiP8By3nzMe5QnUB4VzB+5EonyiWWGDmylmSCXSJ95/R/lZcdYtebcwqgvXyYC9mG+p28ed5Z3sk40ixxBqH+8h9H84e/Jpa/AUkb/ilowNZ4lYsNC6nyIaGPp6nfdIUuWWbkGMMNDt5zt1fZpLvl6TI32RUnki1lUfl+pdeNt9m6kAAZelWSdOZhMMQdHdYE/8rRF69BaqtaOsmZVNdmqsMvz3Y745m8hEw+PR/RkMgC5RASRTxjN9k5a9bgjq9Lo+Umqp0TrcGuKd+UHkrqdrLP+8Hk65bRU29ZnE7wtbJKM6TWfBh5GcrPiLEMzogqv5QzlY+OqAriHCz/2EVQwlujqU6Lg8FsgnjAN65kEThta4MeRNyvB7rEVmdJ9cI3rCUj6qP9pCrhMWg+MccAwHQlpjIZar7EkoR3dUF1kAsVTcqBJicKys9jQlgjpZCd84N2KO6G74ntb96LtwX+4uOZTCxpR29VSrkHn6vANIMYyOUrvOSJMn2YseDnaPMBhrJDGrnPGVkfL96C/mDAkVTZ6HFsqyTiya5t9RySJrdO/pPjdpcGA5D6ucVCrI+OdRqPX5JsBqR7llwkut7QdHXtf9O0OrBug6yWLHPnhkubiJyJnL6O7NLzZk2GotQwAPXqTZFFNP6BWmurOk3BoJpreNQhZt4MSc34spwwdh2ESzA1jZ
 v/koC78t0lJOxIbgfn0SjEupct5930lKX02WMdXFYpPvTnxoBOaDF6qKlqlgU5zGbGydmk2aXpS0mWAPJeSnihdtLLjQTo5vE5B4E0LOFNvCIBmDUzKraHQtTz+KyaOOMXTSSQ62ZyVU4Rk/cQv8Pna9QmPSw7CZFbcVvXqAENHjKFuLlPlPaIheqaPDbbTm7m1yggmu/xdFE37Ldc4fMlIlTKM//XdaMeB8IUJHVLtKvTGjuUOSxLqgdRmOP/SxXDcmi4detZgVK42TP2ia8x3CfsNlpheMWwyEnG+7o1U3uhtATLz8ymJ81vgOa91ZGKVLlVEys/nj1eMBIPy5O4R+T/jNYVeO9ZrP8Xfs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 5aUdmn5pRTDtNDyqi/TxJvIo4Xt3qanFGo3y2oXgI1mQso93gHX3BDcUvFu9Bs6qCWg2vJsd6FOY6xhJSfDpKMU8uUUAgBRZmvRBLv4z/qRWohRFVlCiryXqmqPXaDcK/Q68crntSCyatI5DqJUh5064dH57/kWtHvLSnrT2DpR1Hte5rcbUHTg6mR60EnnDbSQQ37AMNkw4VnXjNcSGY7s4kJdeXR+Gym70I5L6jA4gbRcSm2YkgK5Iuaakc8vK6RHNC2SsDvIV9IVbsdBWuu7TUSRhPEKLlBpYkbuB8jTUyVoJeiwwX5N5IA+KOGv86vErv2i1BaBGSoa7OU98Z2Ll0scW+9KAs2bqK8g3N0XmK6RVcPUnBxbbmGVFB+9yRiFfH701j1HpE/7/5TY9cbyu1J+XNdoB8KxByW1ML8vUrGSI7IiK1o6EJOCuDkfUFk0EjSml3TkUNryLeQHS4ADXx7SuN9WtFP8f0VcPrUswGuNQWH4QLB94u0R4r6dTWwas/K4Cyz373XdQ1mkWQRGYNHExLbps2/5EFF0W3LEpmFmucckJwK9Mq9NrkZKyM2cty1ocYW6wfUG7Krcj/PPqtq9IXbduT3vtkp5binP1SAi2mwsAb9R2GLbcW1HRiokO/MKFBhBmXW5XFywcqI/FhlGlTtV2qYmp3JIJN48jFaisj7b7Yo0wNLQ0xvVYnztnsmjOAgENhDJGbOSW1O+5x83rfeWrNWua8sHOLvb/mz4/UQjhLDEegevcQtUhhTPwTN4wqElicIkjD2DK04ALVcqQx00qG3zYBeRkcQnsGm+QVee2ZXonlhtO8lTm/JVn+xG6DI9lgAnrfkPtqoXGrCOR9nDFjq6pe4Ng3Ni+Hv8Vs8aE27dT2qth8C5Fz+vueBxoncGkK0EJYT+B/lY6quUhlkf6THxIb5BaUzb8mCUWGSkqjvFkha+anZJJ
 7D7GKt2OS4+3isucFZFChbNeeMaHWmPjdVSuJffEM4W/YwFxdEhvg/RAkdu1RufZ72q6T98pl55D9de/hZYapLgr8ADW52UCUXJznLx2wcY2G72oDAy0mqEIsxlMmrN9q1GSId5LObQ21OIU1FvBMtIyV/iYKx6zEUDC/tLSTvrGDDC7HZiz+Uw2cRfBkRWB0dPuJIPEJN3ppC1y22r6V26df4LFgLJBZgsv2PPrWGnlOrk48IWn30MJ6Y8GW0qrKXGSDdU3lkpqWb4WTMNLpM9AYMgD5zVMz50PRRg68KNgANZGpiy61yNhGD7CA3tPJ7l1cD45PXNW1HzZqI1CXcoVo2FSO+J3A3kVWD5PTLqckieHbaaPCnInBmt4XupHVfGnDmnv0a4hhC4nGxA574NHMADcYG+DEJSU1q4hg0iLzjQdtpseiB6CnJS/c50emfFjW7WRceDsRgRsBvXpdGa8ypKwSWzhsK5gektc4AiMzldn7zlX/Tyi8tQh/VDwn8hDjKGyCi2MDGJXA+kZwLcRUTnNKIMOnWQjAH4TjKBPA9w2ITwG2HC1k5vNGD6cgSE3YRhPCKhHtSZ31EDGzWSXDazEJ1rhrbCKdbauChR1tmqmALUVcG7wp3bgb9GzR7fXJi33OwZdOUEH1D+XxQ==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be7d561-0124-4ac7-d112-08dcbc4b7cec
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 10:25:58.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLDIMiuyQ1s/yaT9FyICfFhUyjkjndElt3zNXwRyRjWfaqCedJE4VR5cRR9QOPthWh2HrK2SITHnLf33aFuNtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB1951
X-ALTERMIMEV2_out: done

Hi Greg,

On 13/08/2024 08:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Aug 2024 06:19:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.105-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.105-rc2 (9bd7537a3dd02) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau <ysionneau@kalrayinc.com>

-- Yann





