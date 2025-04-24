Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11011056.outbound.protection.outlook.com [52.101.65.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0B21FF26
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745487908; cv=fail; b=rqC6N0/PEcWjMwm5jAyk9QSGHW4KA+TCC/OQKjBnDAeuwhA8SMCsmzIObjMZqd5BHU8Erf8H9oZht46hKs5vZRupx4cAXOqbGRDbHQxf3JP187lrlNgGZ3dhBu+xdnwbA/dmijM+joTzfH/+9eIDfU3RrfXEGx7l2tb0NwbC9mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745487908; c=relaxed/simple;
	bh=SiGgAkU/+W+BTL0Jg+terKO4DtbEkDdwvoAMYtN5k3s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VDzO4Q5cxJ9WuuSpZc704Nlwk55fJZqnUCAbYItuttJCW64FFXRKEJlSEgCr4MHKyCJC5nXgm3jLr8+YtoWyUaL9qAlHOPXs7jkQYm6WjHvlcC4UlaUfIDBl047D4HMUT7CRM4wsp8Xqeet/pCVcluRGipq95pjD26ID9Wzk/9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arri.de; spf=pass smtp.mailfrom=arri.de; dkim=pass (1024-bit key) header.d=arri.de header.i=@arri.de header.b=cTFMKkXW; arc=fail smtp.client-ip=52.101.65.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arri.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arri.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arri.de header.i=@arri.de header.b="cTFMKkXW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udu18zswb3lJDn0XUE1iScSiDDrBkLoiZk/VpEZFBS/oA01yAhwiZUc/VX/oAijJD5dkQQgsU0h6rYOS9tC3V4UC+zfDlGiLwMPiP7HB2lteSh2Zd/DYMMEUg+rcr9EtOsMwgf4XvMT4Wq79TakaOPFM/2GLEGz4thVeRgyipYCZ8yXELwIORPA6PrH1PbtEUux6plBI5Wh6+fIWv6chYhPpsddU6ORNzwc4o/0iz8cEYeThk3lrQFCSR7vvXhx/PhZMjeMTXdzFGBpCxQ/DfpZdr60J/ON4K2NoH0MMJAZO9FouIBRL8GAq0w8HyCw3tUimUSrOcvRj/l0sPgYVLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3XsSf02t5WTDVm04SYFQMV7wy8nenThFTItJeseykGM=;
 b=YiNMalrKecO+l1/xFHmMI8YD1oUsG9ntsd05TkscXC+Ec8Ql+nJGRpv5R84vAh22DAtXC1SGK0k28xWLkr9QLfNAOtT2iCOSEXMvBImOEXSe+Co0VdWCa1FZ/m3T4v4vti72kWro8rU/88eLKmRZZfpjZDO3Sj6KVF+XCQW0JM0XB1vHfc3Q+n3OnCCacw8Nhfxjms812H9cGzhUBWeQWv2FutzpvUJjJ5jzTs7HApsunQhD6A0FtQjGiRck7Lq123D/nM1RgE9lhKQTjRFiefnN+2DIlr+01zOb9zp548T8mge3mBPabxsR9nrTAeobl9ZVOUMneUhAYFxL1K2n5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=arri.de;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=arri.de;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arri.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XsSf02t5WTDVm04SYFQMV7wy8nenThFTItJeseykGM=;
 b=cTFMKkXW8RzW2JOJRW+dN8pW2DcKf+m10G5xpPnHAbXDIahGfwIXK9FXuE2u8tmCdiO99Du7UZWhVbBfiGnkoq+hjhfoMhlTb7szbGkzZvdvB1fCJhmPHvUgDtt60c6xK6RFXGPSnECISyVq5QPw0H1GX5TMuRXAKoIXmm86bF8=
Received: from DUZPR01CA0291.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::9) by PAXPR03MB8115.eurprd03.prod.outlook.com
 (2603:10a6:102:229::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Thu, 24 Apr
 2025 09:44:56 +0000
Received: from DU2PEPF00028D09.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::5c) by DUZPR01CA0291.outlook.office365.com
 (2603:10a6:10:4b7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Thu,
 24 Apr 2025 09:44:54 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 DU2PEPF00028D09.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 09:44:56 +0000
Received: from n9w6sw14.localnet (10.30.5.38) by mta.arri.de (10.10.18.5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.38; Thu, 24 Apr
 2025 11:44:55 +0200
From: Christian Eggers <ceggers@arri.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Naresh Kamboju
	<naresh.kamboju@linaro.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<hargar@microsoft.com>, <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Tudor Ambarus <tudor.ambarus@linaro.org>, Bjorn Andersson
	<andersson@kernel.org>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.13 000/414] 6.13.12-rc1 review
Date: Thu, 24 Apr 2025 11:44:55 +0200
Message-ID: <2176888.9o76ZdvQCi@n9w6sw14>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <CA+G9fYstVDU_e27mkqEJC0O742zUb0A=wny59n2SiiH7Z_ouJg@mail.gmail.com>
References: <20250417175111.386381660@linuxfoundation.org>
 <CA+G9fYstVDU_e27mkqEJC0O742zUb0A=wny59n2SiiH7Z_ouJg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PEPF00028D09:EE_|PAXPR03MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: 25cc1391-e17e-4567-b016-08dd8314abd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?jkkCYdeJzlD1/2NB0adaPHP7Fd2Sr1IwdRjyEKQ+bvNHceVT5apwkR2cur?=
 =?iso-8859-1?Q?G7c1TcSprNECuPWgJG7onwZDUa3ZKMOpINDDngLd4LnHxgd12LkUjTNoco?=
 =?iso-8859-1?Q?QyvJCtfdtm02twkhqmjD2F1Bc6a9dl0Smb9QTqSN7AjWX0ljBnFRyM2n8n?=
 =?iso-8859-1?Q?jgRuWWtkOs+LT0eKP53Mk29SvzzOTnc7TWhxidXW/yLpvM0ekcl7mSNzC3?=
 =?iso-8859-1?Q?PeeCijQNRMIdEnM0GNwYM65ZYvXrQEaRdvySQXEOZ0Zai7UwGeeCGdvuNF?=
 =?iso-8859-1?Q?bDo5NzS+Ive5lb0RI8N57wrQDvD/IBEDHH+U1RXtsqfqtiEfukgX83+6am?=
 =?iso-8859-1?Q?NNJivqkjw91RoQEcBuyYz1euwgC9qMjIbzjkbZ7++8o5CAkM0FnpfjRk+8?=
 =?iso-8859-1?Q?7kctL4/7qzPuom0pK+aREdjWdEdSK4NgUJTQcAMwlDqgiLzrOal2lQRZEt?=
 =?iso-8859-1?Q?rC072Ur+70hOCP7QkxQ7Jp9F8saljSxDs8uxu+1pyZ6e1iRyH3NN8RauGj?=
 =?iso-8859-1?Q?6Bm/E+yY5fVM/xiGuV7NO3fLniXWfgUV4oVHne1y02fY7KWMIiXW7B0b+j?=
 =?iso-8859-1?Q?1Z54YAXRAYc0NZYqpISYQuFcdVNMRphhvs9IdtWExScxHsMdXs3uHYGZ/L?=
 =?iso-8859-1?Q?1dpPUt+ddfFSeIm/xgzRxKIPXFqbOiAqiKjxhcFhCShaZUCfjJt8aENdKl?=
 =?iso-8859-1?Q?2vR+HUgBPGxcXSBtnGeSJN1B7vMAnsIBWEmgZzIOfA8E59Mv7783YRZsEW?=
 =?iso-8859-1?Q?FlvfEErJqYN4g19Et5WkRbIiTY4qshgsE4SCnQ3NaMcG+bFP/BivgMWgze?=
 =?iso-8859-1?Q?OeqmRVMeLLL6DSHIKeAOFjQOPzRTjMl64IkPrUAgrB5NtvxY3CueGnO+P7?=
 =?iso-8859-1?Q?mzJhLp7dJNfdRvC5P5xqZlSj5t96C/sHO3iiilqoS7qR4MBB2T/edzHvvR?=
 =?iso-8859-1?Q?hwO0+/PH7lBlzhSL8BhV9OFcF4JU5NpIXTfPiAIx4hr/dg0MN62o2m/5+3?=
 =?iso-8859-1?Q?sh66I+7gw92CYybjKeZpi7ckExKq6rsbS4Dcw2kkqiU5HMAU+v6TEGiGLw?=
 =?iso-8859-1?Q?hVhfDhzqs02Jn4e43qCNr+31vWRdfAoHvT+cZDGNn5SwqfTNJ7TTctbTJL?=
 =?iso-8859-1?Q?LO4mzFVwluwvFI1SH4X7sKMrF0Tt9WQyyVeEyv0NiI2hdAPPxwsU8WqJTl?=
 =?iso-8859-1?Q?kFBb9bXFTHAAoc/ALIYoeTg3imGxybY5E7ao4BNBhCaYgna4oX7aABFmiT?=
 =?iso-8859-1?Q?5wcut889s/mUQ+WGp/PkwtSky+elCjK5T2KeXnjgSJLypNXrKDHTAgcHrS?=
 =?iso-8859-1?Q?l/g2zyzKNQZHsifMUJRVJZ5/e/qV6kvTjWoJAngy2O00j6M6DoIoVXKSvd?=
 =?iso-8859-1?Q?dZtstm2o/ZgN264BRK35w8v9Q9rvUbRiMyOVqBLAVfeHERk2M7oA4qy3wA?=
 =?iso-8859-1?Q?2edc1s7sS/gWoYMlNTuWwqE8XID+JZLEVGUZpE4KMYEXgjVWvicLNocLho?=
 =?iso-8859-1?Q?DPTDGNjIsZcsYMr+GNigz4srst2b2DUvuRSpaRxUng5g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 09:44:56.1018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25cc1391-e17e-4567-b016-08dd8314abd0
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D09.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8115

Hi all,

unfortunately I was away and couldn't look on this in time. Meanwhile
the git trees have been rebased, so I am unsure whether patches have
been dropped of other work is left.

@Naresh: Can you please provide a pointer to the offending commit?

regards,
Christian


On Friday, 18 April 2025, 10:39:41 CEST, Naresh Kamboju wrote:
> On Thu, 17 Apr 2025 at 23:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.13.12 release.
> > There are 414 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.13.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.13.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
>=20
> The following two regressions found on stable-rc 6.13.12-rc1 review,
>=20
> 1)
> Regressions on arm64 allmodconfig and allyesconfig builds failed
> on the stable rc 6.13.12-rc1.
>=20
> 2)
> Regressions on arm64 dragonboard 410c boot failed with lkftconfig
> on the stable rc 6.13.12-rc1.
>=20
> First seen on the 6.13.12-rc1
> Good: v6.13.11
> Bad:  v6.13.11-415-gd973e9e70c8f
>=20
> Regressions found on arm64:
> - build/gcc-13-allmodconfig
> - build/gcc-13-allyesconfig
> - build/clang-20-allmodconfig
> - build/clang-20-allyesconfig
>=20
> Regressions found on arm64 dragonboard-410c:
> - boot/clang-20-lkftconfig
>=20
> Regression Analysis:
> - New regression? Yes
> - Reproducibility? Yes
>=20
> Build regression: arm64 ufs-qcom.c implicit declaration 'devm_of_qcom_ice=
_get'
>=20
> Boot regression: arm64 dragonboard 410c WARNING regulator core.c regulato=
r_put
>=20
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>=20
> ## Build log arm64
> drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_ice_init':
> drivers/ufs/host/ufs-qcom.c:121:15: error: implicit declaration of
> function 'devm_of_qcom_ice_get'; did you mean 'of_qcom_ice_get'?
> [-Werror=3Dimplicit-function-declaration]
> 121 |         ice =3D devm_of_qcom_ice_get(dev);
> |               ^~~~~~~~~~~~~~~~~~~~
> |               of_qcom_ice_get
> drivers/ufs/host/ufs-qcom.c:121:13: error: assignment to 'struct
> qcom_ice *' from 'int' makes pointer from integer without a cast
> [-Werror=3Dint-conversion]
> 121 |         ice =3D devm_of_qcom_ice_get(dev);
> |             ^
> cc1: all warnings being treated as errors
>=20
>=20
> ## Boot log arm64 dragonboard 410c:
> [    3.863371]  remoteproc:smd-edge: failed to parse smd edge
> [    3.989304] msm_hsusb 78d9000.usb: Failed to create device link
> (0x180) with supplier remoteproc for /soc@0/usb@78d9000/ulpi/phy
> [    3.993079] qcom-clk-smd-rpm
> remoteproc:smd-edge:rpm-requests:clock-controller: Error registering
> SMD clock driver (-1431655766)
> [    4.000071] qcom-clk-smd-rpm
> remoteproc:smd-edge:rpm-requests:clock-controller: probe with driver
> qcom-clk-smd-rpm failed with error -1431655766
> [    4.028243] sdhci_msm 7864900.mmc: Got CD GPIO
> [    4.039730] s3: Bringing 0uV into 1250000-1250000uV
> [    4.039886] s3: failed to enable: (____ptrval____)
> [    4.043538] ------------[ cut here ]------------
> [    4.048299] WARNING: CPU: 0 PID: 46 at
> drivers/regulator/core.c:2396 regulator_put
> (drivers/regulator/core.c:2419 drivers/regulator/core.c:2417)
> [    4.053085] Modules linked in:
> [    4.053087] input: gpio-keys as /devices/platform/gpio-keys/input/inpu=
t0
> [    4.060581] sdhci_msm 7864900.mmc: Got CD GPIO
> [    4.061476]
> [    4.061484] CPU: 0 UID: 0 PID: 46 Comm: kworker/u16:2 Not tainted
> 6.13.12-rc1 #1
> [    4.061495] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (D=
T)
> [    4.061501] Workqueue: async async_run_entry_fn
> [    4.069821] clk: Disabling unused clocks
> [    4.071199]
> [    4.071204] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [    4.076270] PM: genpd: Disabling unused power domains
> [    4.077108] pc : regulator_put (drivers/regulator/core.c:2419
> drivers/regulator/core.c:2417)
> [    4.084640] qcom-rpmpd
> remoteproc:smd-edge:rpm-requests:power-controller: failed to sync cx:
> -1431655766
> [    4.091163] lr : regulator_put (drivers/regulator/core.c:2390
> drivers/regulator/core.c:2417)
> [    4.091174] sp : ffff8000832eba50
> [    4.091178] x29: ffff8000832eba50
> [    4.095545] qcom-rpmpd
> remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
> cx_ao: -1431655766
> [    4.099579]  x28: 0000000000000000 x27: ffff800081b54020
> [    4.099592] x26: ffff800081b53fe0 x25: 0000000000000001
> [    4.101088] qcom-rpmpd
> remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
> cx_vfc: -1431655766
> [    4.107745]  x24: 00000000aaaaaaaa
> [    4.107752] x23: ffff000004362a80 x22: ffff0000045fa800
> [    4.112988] qcom-rpmpd
> remoteproc:smd-edge:rpm-requests:power-controller: failed to sync mx:
> -1431655766
> [    4.116953]  x21: ffff0000045fa800
> [    4.116961] x20: ffff0000038dfcc0 x19: ffff000003885d80 x18: 000000000=
0000068
> [    4.126432] qcom-rpmpd
> remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
> mx_ao: -1431655766
> [    4.130312]
> [    4.130315] x17: 0000000000000000 x16: 0000000000000001 x15: 000000000=
0000003
> [    4.133541] ALSA device list:
> [    4.136833]
> [    4.136836] x14: ffff80008284e1f0 x13: 0000000000000003 x12: 000000000=
0000003
> [    4.146411]   No soundcards found.
> [    4.151929]
> [    4.151933] x11: 0000000000000000 x10: 0000000000000000 x9 : 000000000=
0000000
> [    4.230459] x8 : 0000000000000001 x7 : 0720072007200720 x6 : 072007200=
7200720
> [    4.230478] x5 : ffff000003201f00 x4 : 0000000000000000 x3 : 000000000=
0000000
> [    4.230491] x2 : 0000000000000000 x1 : ffff8000801fe6e4 x0 : ffff00000=
3885d80
> [    4.230506] Call trace:
> [    4.230512] regulator_put (drivers/regulator/core.c:2419
> drivers/regulator/core.c:2417) (P)
> [    4.230529] regulator_register (drivers/regulator/core.c:5823)
> [    4.230543] devm_regulator_register (drivers/regulator/devres.c:477)
> [    4.230554] rpm_reg_probe
> (drivers/regulator/qcom_smd-regulator.c:1425
> drivers/regulator/qcom_smd-regulator.c:1462)
> [    4.230569] platform_probe (drivers/base/platform.c:1405)
> [    4.230583] really_probe (drivers/base/dd.c:581 drivers/base/dd.c:658)
> [    4.280941] __driver_probe_device (drivers/base/dd.c:0)
> [    4.284581] driver_probe_device (drivers/base/dd.c:830)
> [    4.288919] __device_attach_driver (drivers/base/dd.c:959)
> [    4.292911] bus_for_each_drv (drivers/base/bus.c:459)
> [    4.297426] __device_attach_async_helper
> (arch/arm64/include/asm/jump_label.h:36 drivers/base/dd.c:988)
> [    4.301593] async_run_entry_fn
> (arch/arm64/include/asm/jump_label.h:36 kernel/async.c:131)
> [    4.306626] process_scheduled_works (kernel/workqueue.c:3241
> kernel/workqueue.c:3317)
> [    4.310533] worker_thread (include/linux/list.h:373
> kernel/workqueue.c:946 kernel/workqueue.c:3399)
> [    4.315305] kthread (kernel/kthread.c:391)
> [    4.318863] ret_from_fork (arch/arm64/kernel/entry.S:863)
> [    4.322250] ---[ end trace 0000000000000=EF=BF=BD[    4.330596] s4:
> failed to enable: (____ptrval____)
> [    4.330739] ------------[ cut here ]------------
> [    4.334298] WARNING: CPU: 3 PID: 46 at
> drivers/regulator/core.c:2396 regulator_put
> (drivers/regulator/core.c:2419 drivers/regulator/core.c:2417)
> [    4.339086] Modules linked in:
> [    4.347491] CPU: 3 UID: 0 PID: 46 Comm: kworker/u16:2 Tainted: G
>     W          6.13.12-rc1 #1
> [    4.350372] Tainted: [W]=3DWARN
> [    4.359293] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (D=
T)
> [    4.360333] sdhci_msm 7864900.mmc: Got CD GPIO
> [    4.362242] Workqueue: async async_run_entry_fn
> [    4.373272] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [    4.377705] pc : regulator_put (drivers/regulator/core.c:2419
> drivers/regulator/core.c:2417)
> [    4.384641] lr : regulator_put (drivers/regulator/core.c:2390
> drivers/regulator/core.c:2417)
> [    4.388807] sp : ffff8000832eba50
> [    4.392711] x29: ffff8000832eba50 x28: 0000000000000000 x27: ffff80008=
1b54040
> [    4.395934] x26: ffff800081b53fe0 x25: 0000000000000001 x24: 00000000a=
aaaaaaa
> [    4.403052] x23: ffff000009d10c80 x22: ffff000009c48800 x21: ffff00000=
9c48800
> [    4.410170] x20: ffff0000044e2900 x19: ffff000003f90840 x18: ffff80008=
17025c0
> [    4.417287] x17: 0000000000000000 x16: 0000000000000001 x15: 000000000=
0000003
> [    4.424405] x14: ffff80008284e1f0 x13: 0000000000000003 x12: 000000000=
0000003
> [    4.431524] x11: 0000000000000000 x10: 0000000000000000 x9 : 000000000=
0000000
> [    4.438642] x8 : 0000000000000001 x7 : 0720072007200720 x6 : 072007200=
7200720
> [    4.445760] x5 : ffff000003201f00 x4 : 0000000000000000 x3 : 000000000=
0000000
> [    4.452878] x2 : 0000000000000000 x1 : ffff8000801fe6e4 x0 : ffff00000=
3f90840
> [    4.459997] Call trace:
> [    4.467103] regulator_put (drivers/regulator/core.c:2419
> drivers/regulator/core.c:2417) (P)
> [    4.469364] regulator_register (drivers/regulator/core.c:5823)
> [    4.473530] devm_regulator_register (drivers/regulator/devres.c:477)
> [    4.477437] rpm_reg_probe
> (drivers/regulator/qcom_smd-regulator.c:1425
> drivers/regulator/qcom_smd-regulator.c:1462)
> [    4.481948] platform_probe (drivers/base/platform.c:1405)
> [    4.485681] really_probe (drivers/base/dd.c:581 drivers/base/dd.c:658)
> [    4.489415] __driver_probe_device (drivers/base/dd.c:0)
> [    4.493062] driver_probe_device (drivers/base/dd.c:830)
> [    4.497401] __device_attach_driver (drivers/base/dd.c:959)
> [    4.501396] bus_for_each_drv (drivers/base/bus.c:459)
> [    4.505908] __device_attach_async_helper
> (arch/arm64/include/asm/jump_label.h:36 drivers/base/dd.c:988)
> [    4.510078] async_run_entry_fn
> (arch/arm64/include/asm/jump_label.h:36 kernel/async.c:131)
> [    4.515109] process_scheduled_works (kernel/workqueue.c:3241
> kernel/workqueue.c:3317)
> [    4.519017] worker_thread (include/linux/list.h:373
> kernel/workqueue.c:946 kernel/workqueue.c:3399)
> [    4.523790] kthread (kernel/kthread.c:391)
> [    4.527347] ret_from_fork (arch/arm64/kernel/entry.S:863)
> [    4.530735] ---[ end trace 0000000000000000 ]---
> [    4.535440] l2: Bringing 0uV into 1200000-1200000uV
> [    4.539050] qcom_rpm_smd_regulator
> remoteproc:smd-edge:rpm-requests:regulators: l2:
> devm_regulator_register() failed, ret=3D-517
> [    4.544075] Unable to handle kernel paging request at virtual
> address ffffffffaaaaae6a
> [    4.554991] Mem abort info:
> [    4.562869]   ESR =3D 0x0000000096000005
> [    4.565560]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> [    4.569384]   SET =3D 0, FnV =3D 0
> [    4.574846]   EA =3D 0, S1PTW =3D 0
> [    4.577710]   FSC =3D 0x05: level 1 translation fault
> [    4.580755] Data abort info:
> [    4.585612]   ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
> [    4.588742]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> [    4.594036]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> [    4.599158] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000000824a=
4000
> [    4.604544] [ffffffffaaaaae6a] pgd=3D0000000000000000,
> p4d=3D0000000082e7d403, pud=3D0000000000000000
> [    4.611238] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
> [    4.619631] Modules linked in:
> [    4.625875] CPU: 3 UID: 0 PID: 46 Comm: kworker/u16:2 Tainted: G
>     W          6.13.12-rc1 #1
> [    4.629015] Tainted: [W]=3DWARN
> [    4.637936] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (D=
T)
> [    4.640900] Workqueue: async async_run_entry_fn
> [    4.647664] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [    4.651924] pc : regulator_unregister (drivers/regulator/core.c:5850)
> [    4.658861] lr : devm_rdev_release (drivers/regulator/devres.c:453)
> [    4.663721] sp : ffff8000832ebaf0
> [    4.667974] x29: ffff8000832ebb10 x28: ffff000004520000 x27: 000000000=
00001c8
> [    4.671195] x26: ffff0000042c6040 x25: ffff000009d10c00 x24: ffff00000=
4520000
> [    4.678311] x23: ffff80008280ed00 x22: ffff8000823b07cd x21: ffff00000=
3f90780
> [    4.685431] x20: ffff000009c7b810 x19: ffff8000832ebbb8 x18: 000000000=
0000068
> [    4.692548] x17: 6f74616c75676572 x16: 3a73747365757165 x15: 00000ff00=
003fd3a
> [    4.699666] x14: 000000000000ffff x13: 0000000000000020 x12: 000000000=
0000003
> [    4.706784] x11: 0000000000000000 x10: 0000000000000000 x9 : ffff80008=
0b52bb0
> [    4.713901] x8 : 50dfedbf8d5fec00 x7 : 3d4e5f454c424954 x6 : 000000004=
e514553
> [    4.721021] x5 : 0000000000000008 x4 : ffff80008222c178 x3 : 000000000=
0000010
> [    4.728139] x2 : ffff8000832eba70 x1 : ffff000003f90800 x0 : ffffffffa=
aaaaaaa
> [    4.735257] Call trace:
> [    4.742362] regulator_unregister (drivers/regulator/core.c:5850) (P)
> [    4.744625] devm_rdev_release (drivers/regulator/devres.c:453)
> [    4.749484] release_nodes (drivers/base/devres.c:506)
> [    4.753388] devres_release_all (drivers/base/devres.c:0)
> [    4.756950] really_probe (drivers/base/dd.c:551 drivers/base/dd.c:724)
> [    4.760941] __driver_probe_device (drivers/base/dd.c:0)
> [    4.764588] driver_probe_device (drivers/base/dd.c:830)
> [    4.768842] __device_attach_driver (drivers/base/dd.c:959)
> [    4.772836] bus_for_each_drv (drivers/base/bus.c:459)
> [    4.777348] __device_attach_async_helper
> (arch/arm64/include/asm/jump_label.h:36 drivers/base/dd.c:988)
> [    4.781518] async_run_entry_fn
> (arch/arm64/include/asm/jump_label.h:36 kernel/async.c:131)
> [    4.786552] process_scheduled_works (kernel/workqueue.c:3241
> kernel/workqueue.c:3317)
> [    4.790458] worker_thread (include/linux/list.h:373
> kernel/workqueue.c:946 kernel/workqueue.c:3399)
> [    4.795229] kthread (kernel/kthread.c:391)
> [    4.798788] ret_from_fork (arch/arm64/kernel/entry.S:863)
> [ 4.802179] Code: d5384108 f9430508 f81f83a8 b4000bc0 (f941e014)
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [    4.805745] ---[ end trace 0000000000000000 ]---
> [   14.254255] platform ci_hdrc.0: deferred probe pending: (reason unknow=
n)
>=20
> ## Source
> * Kernel version: 6.13.12-rc1
> * Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-=
stable-rc.git
> * Git sha: d973e9e70c8f0ad1a53a96ce48db9f3f882db4a8
> * Git describe: v6.13.11-415-gd973e9e70c8f
> * Project details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.=
13.11-415-gd973e9e70c8f/
> * Architectures: arm64
> * Toolchains: clang-20, gcc-13
> * Kconfigs: allmodconfig, allyesconfig
>=20
> ## Build arm64
> * Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1=
3.y/build/v6.13.11-415-gd973e9e70c8f/testrun/28151211/suite/build/test/gcc-=
13-allmodconfig/log
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.=
13.11-415-gd973e9e70c8f/testrun/28151211/suite/build/test/gcc-13-allmodconf=
ig/history/
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.=
13.11-415-gd973e9e70c8f/testrun/28151211/suite/build/test/gcc-13-allmodconf=
ig/details/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrt=
UC0M5hDCMYsjZId4uKICXy7/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrtUC0M5hDCMYsjZI=
d4uKICXy7/config
>=20
> ## Steps to reproduce on arm64
> - tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
> --kconfig allmodconfig
>=20
>=20
> ## Boot arm64 dragonboard-410c
> * Boot log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13=
=2Ey/build/v6.13.11-415-gd973e9e70c8f/testrun/28155237/suite/boot/test/clan=
g-20-lkftconfig/log
> * Boot history:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.=
13.11-415-gd973e9e70c8f/testrun/28149517/suite/boot/test/clang-20-lkftconfi=
g/history/
> * Boot details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.=
13.11-415-gd973e9e70c8f/testrun/28151170/suite/boot/test/clang-20-lkftconfi=
g/details/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrt=
Sg9ngthHYlLhDI9xR3a2T5K/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrtSg9ngthHYlLhDI=
9xR3a2T5K/config
>=20
> --
> Linaro LKFT
> https://lkft.linaro.org
>=20




