Received: from smtpout147.security-mail.net (smtpout147.security-mail.net [85.31.212.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780E315C14D
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=85.31.212.147
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565932; cv=fail; b=TKpVjvPrinPV1PVHCBYUytqG0hL6G6b2h6IN0KdL5zOuOmau3j8AMpHTIJnqCI8vmzYKn203UgaiSrsPR4q7Wb9dA0eiV41IrqllWxl66/2cDQcFvL0FONyf8/RWiGbhmqFjAyRmnj855UqH5ZPsul7HwF2XKGAewk/D0IjzDME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565932; c=relaxed/simple;
	bh=ADnbOxKEGr+4/HWF13UNe6Dd1ccEcNsSSd9ZwEivtbE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZFzr1gHv56Ko2WASR0F9Q3yoNaLi39BkzrhCOXct8kUi8vvnuby9j2tGFIWDk4MbobDnVu2klKVfRX7h4FeIA78+4GNEhimIdpbVRsYQdieQ2NYMqZQK8G2UU4RT+Ji/mU5YTiuO43fA6mTbVYYWcAqnOstS9AZ9CeidiEmwhU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com; spf=pass smtp.mailfrom=kalrayinc.com; dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=c4cW+c3+; dkim=fail (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b=W1VQT7rb reason="signature verification failed"; arc=fail smtp.client-ip=85.31.212.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kalrayinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="c4cW+c3+";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kalrayinc.com header.i=@kalrayinc.com header.b="W1VQT7rb"
Received: from localhost (fx409.security-mail.net [127.0.0.1])
	by fx409.security-mail.net (Postfix) with ESMTP id AC3F4349D82
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 11:38:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
	s=sec-sig-email; t=1726565922;
	bh=ADnbOxKEGr+4/HWF13UNe6Dd1ccEcNsSSd9ZwEivtbE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c4cW+c3+f1NOSWaQQgJQca8T+uwZsDBhgztunrGJnTjdPjkEr0zchq1cOfXDkbxH3
	 5x2fjzmUmJHkGMZdcfUlD9u8QhgcWg7XbP8ZBJoHhge/7XcLR2KN7tkUtQJ5uJWXw4
	 C+qxDpJ+H0m+uL30/NG7X/TQ2afJSuI9569SuuZo=
Received: from fx409 (fx409.security-mail.net [127.0.0.1]) by
 fx409.security-mail.net (Postfix) with ESMTP id 5E64D349D97; Tue, 17 Sep
 2024 11:38:42 +0200 (CEST)
Received: from PAUP264CU001.outbound.protection.outlook.com
 (mail-francecentralazlp17011027.outbound.protection.outlook.com
 [40.93.76.27]) by fx409.security-mail.net (Postfix) with ESMTPS id
 5A76D349D79; Tue, 17 Sep 2024 11:38:41 +0200 (CEST)
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:14b::6)
 by PARP264MB5468.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:3eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.21; Tue, 17 Sep
 2024 09:38:39 +0000
Received: from PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39]) by PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 ([fe80::7a6f:1976:3bf3:aa39%4]) with mapi id 15.20.7962.022; Tue, 17 Sep
 2024 09:38:38 +0000
X-Secumail-id: <ff41.66e94e21.58fc8.0>
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NaKsHIntC6hPDFj754G/kBzC0WsTfjkcjDIThLTacWMo5PRTnbe/RzInDEn6DWEXGxylSxkHgPvshf9otEoY2c3B5MFXkVwQK/NQ/rMrmbRqN/8mlD5kX0K8YUpXjRQOpIWeMR9mPnehz5tCQTcYAxaV03IRUpexOYNbf8Z2fxl5Gtt938nl6p3TJRuZIpPuMkOSTdICUR+4SqsvoBtyBiUgEiuSgHc3tuNC05BcblQoXfbPh6JMMdsqIfvR+yS7pAwGSZ8abioLoRuqAGQoVl7C0SbunJ+nc0LL7nY40A85n/0aBy4ThRLNw6tjNskQYsqzGXRfVrExy2bWALSEXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.com; s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vxu1iA/AqCH7qkC0qgFXr1TPAgZDdJ3HOtv/h04Yz3s=;
 b=xHu/2nPNi7awbw7K7y7rB4Wuh+QJPpxvpIzHP2tsrQ8daaCPIa/NnZjGd5R+ateqUCw0iG+i5t8wzZQqgWktIPPK2a8B4dJwlf1jw5lzrLHzBRHHHrty0+2H+r26megH1k/neUJ4UxoVi5QuaxqLj79ALdekWciCHWilFUPbZlAwX1xAeUUluDJ2WPENM2BycbRM6Q9QuqsowO8lZZPd15IzqqWYqpEwQk55ArVG+e+5dSudgTNWdTgKLVuHrHnl/ZZyG/UzMzoZDFWdM5RVTmNf4kVsrDPH5S3qOyQ5UMQ99CHG0qwbL9jCwlWdn/BPxTAKH3LLWLSTNXo0h/IN1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kalrayinc.com; dmarc=pass action=none
 header.from=kalrayinc.com; dkim=pass header.d=kalrayinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vxu1iA/AqCH7qkC0qgFXr1TPAgZDdJ3HOtv/h04Yz3s=;
 b=W1VQT7rb8EAM+tYhM1B7gNMn1tRtXUt7h/XcKwi1dq5e4E5AK0Wc3ePNnowBwbycL2eVMhVvjPlk6Mb+DHIQOl5w5kyaP09a6bzJ/wJvveGXsjWmOfk1/A+6F7PduSW5o9Q96ThoHcbWeQFVK0GjxoCBHGNCQ89h/4tJ/+X+nrFKKgYBUH0TyvshmICfWF1XHKzg1LpKltKG5MIrSg4r6lTvUcwzSh4flNeLEDTQPEs4K4bGXe3gMpcZ0j+8bxfIbVmv5N8udKg9/QjYb/etDs/TV66VS02An5mkMwa5x033PSoac5pxr4VdnC2SDI8oyF7B4bguhc9s9uMk+iIaog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kalrayinc.com;
Message-ID: <de6287df-929e-4238-b247-4a3d8b85a5ca@kalrayinc.com>
Date: Tue, 17 Sep 2024 11:38:35 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/63] 6.1.111-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240916114221.021192667@linuxfoundation.org>
Content-Language: fr
From: Yann Sionneau <ysionneau@kalrayinc.com>
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0009.eurprd04.prod.outlook.com
 (2603:10a6:208:122::22) To PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:14b::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PR0P264MB3481:EE_|PARP264MB5468:EE_
X-MS-Office365-Filtering-Correlation-Id: acab6118-722b-4384-4610-08dcd6fc81f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: zHCd1Pcltw43K3oQANPU6XsOnSo41xp/cZFLCB5PNzLrcDLbz8VgTMLJvI4gNl4P3bFT22QI5HzlvgnJBe0lP+R5T6b16vlBZHdHT+o2O9svg7CGrqVwxuPeCbwv0KdeCSaHYoWb3aj2u0bNAFWgp4In/xrfEvdaJV/b/j5xgy/OJVvKajeUHx+SwuXltPV92qf0Lz9Gwr2YmAbYnd5JS1amGE3JdUYb/9WzZcTPLHALpkpYg0otJDk5p0KYp+/9GMNdZktKr7ZpMcc4O0BpzCqv+PAONb1dbrzqunf1B71ycQ3IaVzyUGTgL8erLPjE7m6jjzNKEc7OBBfd06nzB26s9Qsc4RggS8DOfljLLdd8g5Y4YXc9cPdYlHQrli4sV1CQ2G/28coTMIXws409buGEIP6/1yb30KRJ5VZmeOjRztsHMFVI2govFR7RlsHBq//S+jmZTdkgZ06l4TkObknCIWz/NZsJnt4JaGMpfgfMvcCmhm4JgrQyrZiDPLwIsXb4s2VtUVF8Zh5KE6teXjpZ5hHHDkC6Si/EPT6HEfX2Xnk+1KdNLX/bejsuGnT/7hbiDwLiGKl2Zs5hIq9gy84X35VLoqJFS1gj0MjprrxAjBw/yB94AA9r7qfCwGdHXtCt8VtUx5oL20Gq54BoeCSltdg+2f/wO2K5BjXfbznQnjBFw56w5DNRxrOCn382kTPOIu5Jm19Uc0QZbihmIeLvi7lcisSD7qlawhaPsBAS+4mWu7vCgAW1VED70UL+v5edCAdFgaJVFI9L0E+XS75uSBu2zOkgyWBN5EyLErGhqgxiphlupPV1wEBS/pRFP96BpD/fvXCt6z7augasVesaSSj6lVN5kq1IBRzSAOOblwgqFwWrq5nCg2ix9V7Tlqmz8PzggcDEvvU7C4jaHRahWPTVq48NSxbctAMm9cEKD6IpH3uEetE1fZG3RPWU4yq
 yF/lyHtP7BB5LM0dwABpdIRtEnihha+dFE2s3vkX956FIDO8N3VD/qx00hwOHWfoZs5vabMylO06kMSHoTgm+l5uQcWjQYcMCqYzRRrALGOsbplzk9GaiWMc0PJx5LNKoapXz9N1jJwtIjejQWG0y+2XNxJF9ehURnFqs43YxwDT/A02EGATpwxKirQ/xJRbwJFvdwiUeni5QwRVZBZx02OrNrdMalz9QSO6z0L9k3n4R3846wWTyZKtFOmD7nK9jgYdm8Pfdmv38mDDNwpeHQeHvB75NR2sF635lhN0y7vPdb2lqlg6h8io4kpdMi7EFhnaFysBn2VC6ZTu9TTm1Utuz2nlbm/OjH3Xx3bwEogxCx1GxXl4HKwBd5m+nyZtSW6TdjvWKhDhC/LRmQzmziilrAdSRWZh5SGnJYwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: cy1QSvghXEyDSyMiU59XPGEEMSZF7qGWTp3xmaBaRKIMPQUr0DnNHnpdfhbfRJqB4ejt+WepWd1kKm96WI1WWPdhsxs+PadkcLmlpBnb+oH/mm4dd3HstPycwfpH6V0hiAqq4vjSeQYvX7h2VnQr9oVJ73xVDC8ypILzR2j5gWdFcScsk7ncz+QNy9so0QhT5yncfgksZ6XCDHdAaHG3P2PFcOvdghx/UIsU8JGLkOasFNAS/lG23/Q1Oi5FKjELtlEiQuT5xM+7somvOUZ7pZ/zngjVCma58dAVPt+s/Xs46CbPKypdjNvnPVUHrAhXn4kC+7MyiVu+LdVCY+KY4xxttkjbT15ACmRBeUZIsp34159hNEAZy9Z05g7tgxcozuuek+1a7eErCtwlmQLnrJNOIwv0IGynx/3eSxJoK0+HXFl9kErjuoMXVFLE5HwFs+qB5y0hUguC6OwWDK+8xCt7Ot+/qNIgL05g7Ndrvybgu+lMDBDInrka9E+xsWrvORU4uiHcIP990AwGLpqgVMfpXS0IpotRk62a7aM5FvT9bXwKiHmpUTz77NXQWAadYEZBQkGffL+GyI5ROFHL9bdHQ7wvwB/H6hwlJUNM5vjK8ZM/BKPqTHqo29fugOnKFYB91xFn01BDbTmgJhJK9+lF01ro6cFjmGONYF3xp7UIyVqHzhXVU3gyByRl84NGyOiRf98pp0l4wTpmNAt04t63biAXlgkNGW2iQB/9RzIheuwvJjV16smgMMECRveFcPPjjVW9z4T2XpLTZKcDmpUYvQjyXU2UFHdutHzUSJDDhYBKpi4uQTyeGbUW64S3/ypLYv7Yf0dkUsQjl18bcAJatpXjc/Fpk65gwF+mWfalhiasGr44Oh7NM1DzQjXbcysYjWqMC0a8N1sSXyxkILgCHxsDCdNyeTyaP2q2o+XOV4DxwNMpnSVaQFmNMYY+
 jG4X0Z3az1iM/tlPB8qlcoji+3tPu8kVGGmzfLjBJXjks1gOVyQ+8CZb7DJE1MX0zaht0WsvEbNd85ONWWbEBw9BhMiXDIA5xRJQwLWzXKHDKAy40Yj933WcInP8vfIBI32OimBFcvxBCWz49ZIU2qpG6AEi43p5JR9wSuD3kvXj5VhZQ2EflsPODANZh8qkAe0brIdI5jLudzt/0yyt5qf+ZB+9X/pkALwJm6kZBe6lx8jrLT8TeQOQkAB7A3ggQP+dHWQ51+wXwKIA4KellDNXmOLaWAWc6RbZ6QEMWQxAZlAsoXumzLdm/AxvrWn6DGd5k5YqQNdAF7OJJdsY2xpaHRZM3S2802pxAtM9QGfkkRM9NtjgFlw1c8DzSoSwFdHeKvX8nrXKUWyKqw6LhJ6X+b2O0Yl+ApELl9n3xrksWpijHaUokMHmcjfytBeTZ5omg3fzxJ5A21Wi8XxpS9srGdWClBCnip/D61aO+yDrw+aAf3JF385rxQ+u9l57izy5++4rbAcaxC32+TUBXQI3li/1PED6yCjz9k5gKTDlkvCxiInMyPk/eechBzoA8vIRnKSrav9tIUpduCIWul4AtXB0hWtnX+JkHsuYxYps50eHcc4+yWaPV/h53JHUIyoPKKptkdm6tOwG3ZswWg==
X-OriginatorOrg: kalrayinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acab6118-722b-4384-4610-08dcd6fc81f8
X-MS-Exchange-CrossTenant-AuthSource: PR0P264MB3481.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 09:38:38.3827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8931925d-7620-4a64-b7fe-20afd86363d3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxUX+vNfrKNkqXf1FGx2+SXNjm/o5n/+SedNrcGQ1eWmYrFqE31JrlR6izh8khYfwDSbFYDHZl3Flr2ozUBqZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PARP264MB5468
X-ALTERMIMEV2_out: done

Hi Greg,

Le 9/16/24 à 13:43, Greg Kroah-Hartman a écrit :
> This is the start of the stable review cycle for the 6.1.111 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.111-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,

I tested 6.1.111-rc1 (dc7da8d6f263) on Kalray kvx arch (not upstream yet) and everything looks good!

It ran on real hw (k200, k200lp and k300 boards), on qemu and on our internal instruction set simulator (ISS).

Tests were run on several interfaces/drivers (usb, qsfp ethernet, eMMC, PCIe endpoint+RC, SPI, remoteproc, uart, iommu). LTP and uClibc-ng testsuites are also run without any regression.

Everything looks fine to us.

Tested-by: Yann Sionneau<ysionneau@kalrayinc.com>

-- Yann





