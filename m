Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B658C757EE
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718033175; cv=none; b=u/JlLq45/f3GJBh01XdjLc6S3XyGLhLOyl45jzKV+M4enoZwjmwylFf7PQQ6vQXV6v4fQ0vS8mxSp45IP0vXvIkykbFS52ceheBpctwqZAq1tzw1esEVq3XtTt9jG6VJcZQy1Z52NnzXOr1VHO3dLt+V+B0s/7zOhNPHaB+RU3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718033175; c=relaxed/simple;
	bh=SlQFRSvVdbk5xiE5tYj3MMJfXr3zI7zmkNmvnKGpUzY=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=lJDqo56Zaz3gCRFsuJyksoLE63SD2OHeoHvs/f9delgOJ7zCJmcppPjlbZUzO41ipErgpzS/K+PMUml9BkfPKEu2oCe0751Lv3KQKe3oOS3lrW//EUOjwlPQc2qcN312Frt68kuPQsDU5MCcpnc7WYMMeOw3WmtivK47ELE+M2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id 6A24B3781107;
	Mon, 10 Jun 2024 15:26:10 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240609113903.732882729@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240609113903.732882729@linuxfoundation.org>
Date: Mon, 10 Jun 2024 16:26:10 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>, "Gustavo Padovan" <gustavo.padovan@collabora.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2ac6c7-66671b00-9-234d2f00@171268153>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E6?= 000/741] 
 =?utf-8?q?6=2E6=2E33-rc2?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Sunday, June 09, 2024 17:11 IST, Greg Kroah-Hartman <gregkh@linuxfou=
ndation.org> wrote:

> This is the start of the stable review cycle for the 6.6.33 release.
> There are 741 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6=
.33-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.6.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-6.6.y for this week :-

## stable-rc HEAD for linux-6.6.y:
Date: 2024-06-09
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/log/?h=3D7fa271200aef4ae8f0bed8a8ed81629ecd5ed2ab

## Build failures:
riscv:
    - defconfig (gcc-10) and rv32=5Fdefconfig (gcc-10)
    - Build details :- https://linux.kernelci.org/build/stable-rc/branc=
h/linux-6.6.y/kernel/v6.6.32-742-g7fa271200aef4/
    - Errors :-
arch/riscv/kernel/suspend.c:37:59: error: =E2=80=98RISCV=5FISA=5FEXT=5F=
XLINUXENVCFG=E2=80=99 undeclared (first use in this function); did you =
mean =E2=80=98RISCV=5FISA=5FEXT=5FZIFENCEI=E2=80=99?

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-6.6.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

