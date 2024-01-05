Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D97B2E855
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from hamburger.collabora.co.uk (hamburger.collabora.co.uk [IPv6:2a01:4f8:1c1c:f269::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id CF52437813CF;
	Fri,  5 Jan 2024 21:51:10 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240105143815.541462991@linuxfoundation.org>
Date: Fri, 05 Jan 2024 21:51:10 +0000
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, "Gustavo Padovan" <gustavo.padovan@collabora.com>, kernel@collabora.com
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1b20-65987a00-1-329a04c0@129853067>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?5=2E4?= 00/47] 
 =?utf-8?q?5=2E4=2E266-rc1?= review
User-Agent: SOGoMail 5.9.1
Content-Transfer-Encoding: quoted-printable

On Friday, January 05, 2024 20:08 IST, Greg Kroah-Hartman <gregkh@linux=
foundation.org> wrote:

> This is the start of the stable review cycle for the 5.4.266 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Sun, 07 Jan 2024 14:38:02 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4=
.266-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-5.4.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-5.4.y for this week :-

## stable-rc HEAD for linux-5.4.y:

Date: 2024-01-03
5.4: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git/log/?h=3D84ea024efd547b80abad91a30eb7c86d313eb6a7

## Build failures:

arm:
    - multi=5Fv7=5Fdefconfig (gcc-10) and omap2plus=5Fdefconfig (gcc-10=
)
    - Build details :- https://linux.kernelci.org/build/stable-rc/branc=
h/linux-5.4.y/kernel/v5.4.265-48-g84ea024efd54/
    - Errors :-
    drivers/bus/ti-sysc.c:1847:4: error: implicit declaration of functi=
on =E2=80=98fsleep=E2=80=99; did you mean =E2=80=98ssleep=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

## Boot failures:

No **new** boot failures seen for the stable-rc/linux-5.4.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

