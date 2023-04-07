Received: from ci74p00im-qukt09090302.me.com (ci74p00im-qukt09090302.me.com [17.57.156.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3D6EA2
	for <patches@lists.linux.dev>; Fri,  7 Apr 2023 02:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.net;
	s=sig1; t=1680833442;
	bh=vgenMfSKtRXgiUIp+hur8G/7yMe0DexN9fQK0YxzSqA=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
	b=iNU3vhm7giVjM2QeiE9i1UqQKgwqYFdCtwELxeEr27kt5G/iBaXvj9wbI/CDBRKuY
	 aSZ0anuOLJAfaME4eUXWzROgGeE03OrAhgHTvKf7W0NQVuue1z1eclqPWwSS1rIFmk
	 dDuIFI6CUE1GqMNc9DFt2q1WxVnd7sCaztoDUVG5/iXnjV/0IYgyCPpLpc9QKZ8vOh
	 FAi7t4zd/ZdRBBPT5ScIRaX1LLuNZf2DbAGBkdVD6vTbG3q5JQ/VXomZqBLLfaQlW4
	 tyBhRxI7e27yyffBlYqDyjCc9Uq3+JEyK2SBAMwHd84qYpirZ5sGBtwiUkdqtVvb3a
	 dL/ejp87XPFeg==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
	by ci74p00im-qukt09090302.me.com (Postfix) with ESMTPSA id D315B5BC02CC;
	Fri,  7 Apr 2023 02:10:40 +0000 (UTC)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
From: srw@sladewatkins.net
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
Date: Thu, 6 Apr 2023 22:10:40 -0400
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
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
Message-Id: <CD9890B4-8C49-4616-B9DA-2408A60B73FF@sladewatkins.net>
References: <20230405100302.540890806@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Proofpoint-ORIG-GUID: Rz5-JXVxHCEyox4VTgX5CpVCIltQYCl2
X-Proofpoint-GUID: Rz5-JXVxHCEyox4VTgX5CpVCIltQYCl2
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.790,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-12=5F03:2020-02-14=5F02,2022-01-12=5F03,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1030
 mlxlogscore=698 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2304070018



> On Apr 5, 2023, at 6:03 AM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.


This compiles and boots on x86_64 with no errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Slade=
