Received: from ci74p00im-qukt09082302.me.com (ci74p00im-qukt09082302.me.com [17.57.156.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48564361
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 02:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.net;
	s=sig1; t=1681352323;
	bh=UmL6fMhjU+c1FvBuhRm+zZmRZCPUcuT6L5z367nRwoE=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
	b=awVlLCSFyPT2dCMdKibT+G6Tr1euL2+AEvYx68y8EV4g1c56/39W3kk9McFL7CFj7
	 rjcdNqXJJzeadvJ5ijIMesv9UpSw/3oeE+g749HV+f1Qv44s+lo21TppLNg/a6Y5Wp
	 9jnIZlqstAN2pZ/Srt1Jn/xUFqOIawtkzV0cJ/b4i1exMaq5/ntH2OzUHqBvst8xgk
	 utiUlaZ34oub3dvK4gbYPG8FVD5i2XyySqYaM53FpVICISn06/HybMzaOmXrM+eM1y
	 ug7Jo1fW7t85eDfp0UH0U2M6UMF6zvuEZmDLIOS/PaKvzaHOO6E8YJtdxe10vFwMW3
	 3MxcEbeaONryw==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
	by ci74p00im-qukt09082302.me.com (Postfix) with ESMTPSA id 725882FC01EA;
	Thu, 13 Apr 2023 02:18:40 +0000 (UTC)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
Date: Wed, 12 Apr 2023 22:18:40 -0400
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 akpm@linux-foundation.org,
 linux@roeck-us.net,
 shuah@kernel.org,
 patches@kernelci.org,
 lkft-triage@lists.linaro.org,
 pavel@denx.de,
 jonathanh@nvidia.com,
 f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <8DA42803-580A-41F6-B80F-45AE269EC38D@sladewatkins.net>
References: <20230412082838.125271466@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Proofpoint-GUID: diOa4PNWSrXGajGtsNDKza-HQnvqCva2
X-Proofpoint-ORIG-GUID: diOa4PNWSrXGajGtsNDKza-HQnvqCva2
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1030 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=546 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2304130019


> On Apr 12, 2023, at 4:32 AM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =
https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.11-rc=
1.gz
> or in the git tree and branch at:
> =
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git =
linux-6.2.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h


Compiled & booted on two of my x86_64 test systems, no errors or =
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Slade=
