Received: from ci74p00im-qukt09082102.me.com (ci74p00im-qukt09082102.me.com [17.57.156.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27299EA2
	for <patches@lists.linux.dev>; Fri,  7 Apr 2023 02:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.net;
	s=sig1; t=1680833792;
	bh=DxNf46IodocOdGhLfCt9sHuddmm/GzOQ3GaXWEJ7Z6Y=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
	b=Sn4NeCUXZRrh0e4izVoN7N0FzhjF+mHgj6KLOmQbeKyyYbvN7tZ4ksCDb5MC850u6
	 8mp6vYBk5pvpTDCNGSddi9XLuBiedoEYfhrCA99GhYuHnOsZjw50jYmtcb/d0+bZ80
	 cAV00MmWnlhqOfObzHY7PnZuG5jP8qx/XEMuR6QpsgmF3HCTnYWIf0n/AjxX7SEG7q
	 SC7x9Gb5Hg8+nqs37WQG/rIRUb1WbTYZVjDkcQRkX78kuiLyTt/gmJ+bZAJP6vgH0A
	 YMfyN3Ezu0lKMqsnjuroQfgEpOVBk6TrNrfrIJa7Yko9T2jX/r1bg95v928JNsD0ap
	 qFxzz+DU3gfZQ==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
	by ci74p00im-qukt09082102.me.com (Postfix) with ESMTPSA id C8B9119C02D6;
	Fri,  7 Apr 2023 02:16:13 +0000 (UTC)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
From: srw@sladewatkins.net
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
Date: Thu, 6 Apr 2023 22:16:11 -0400
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
Message-Id: <0363D1C3-A098-4700-835F-A8D3EC9F3BD3@sladewatkins.net>
References: <20230405100309.298748790@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Proofpoint-GUID: 9CXD3jLi2nuE8j7M51upwSymZPYfq2NJ
X-Proofpoint-ORIG-GUID: 9CXD3jLi2nuE8j7M51upwSymZPYfq2NJ
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 clxscore=1030 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=723 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2304070019


> On Apr 5, 2023, at 6:03 AM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.

Compiles and boots on my x86_64 test system with no errors or =
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Slade=
