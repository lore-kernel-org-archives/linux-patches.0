Received: from ci74p00im-qukt09082302.me.com (ci74p00im-qukt09082302.me.com [17.57.156.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9E4361
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 02:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.net;
	s=sig1; t=1681352267;
	bh=yFrXvH8+6qW3bma8qYo+SSJDTVohuGpOF+VWeDbjTNY=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
	b=LoBiwxh0zZ7HyCZ9LrNAktzMqgNz4J4iYpYwuvFa0VtsMRaDfp/joOWnjKNbGyNrm
	 cUjgBxtk+3f2BZL9pVcDeP3k+J6uOedE+PINJZSBFxhM50Bx72cZdnzVxfgEkdTsKT
	 9eeB2EULjK9F9pnk2FcVMIYh7iL/Mh7u2lSZWGxPyyXv9GKwXdMo49E3XfH8EyB3SY
	 O+8w04LnrwqGTHUSYsIXj0hoOXHxJmcycg9vjAtoQUqSlTEuUljdqpnsZdpaxy8ETh
	 1AvMPw00F39aCFcKvxMm8IcxE21ZiXXd4Bd/g71oTGf4wfle6cSbqiXRlaCi+47Pdq
	 esX+MVj4jgMYw==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
	by ci74p00im-qukt09082302.me.com (Postfix) with ESMTPSA id D0F2F2FC02B3;
	Thu, 13 Apr 2023 02:17:44 +0000 (UTC)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
Date: Wed, 12 Apr 2023 22:17:43 -0400
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Guenter Roeck <linux@roeck-us.net>,
 shuah@kernel.org,
 patches@kernelci.org,
 lkft-triage@lists.linaro.org,
 Pavel Machek <pavel@denx.de>,
 Jon Hunter <jonathanh@nvidia.com>,
 Florian Fainelli <f.fainelli@gmail.com>,
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 rwarsow@gmx.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <C9920C31-41F9-4AC8-B0DC-50A89BC5964E@sladewatkins.net>
References: <20230412082836.695875037@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Proofpoint-GUID: -qh5ZCfeGIniUCX2jjViAYdrisU8MVHk
X-Proofpoint-ORIG-GUID: -qh5ZCfeGIniUCX2jjViAYdrisU8MVHk
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1030 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=569 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2304130019


> On Apr 12, 2023, at 4:32 AM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =
https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.24-rc=
1.gz
> or in the git tree and branch at:
> =
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git =
linux-6.1.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h


Compiled & booted on two of my x86_64 test systems, no errors or =
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net =
<mailto:srw@sladewatkins.net>>

Slade=
