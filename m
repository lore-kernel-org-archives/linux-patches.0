Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BE761665
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 10:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203890; cv=none; b=MEaItvUoVjcIlZ4QWmgcbySI/ogm1xMx6vABpV5srasGYY9Shean3dA0ugVpG5xiJgaSeV1wFw7b6+++q+eXoq5odoKweq1LjY/isgkqweR0G2LAm4w9FSTevDcFE3p7hCG/BwZENg02t+SMJltx2C7hnkYYg8MIi41GP6BBBbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203890; c=relaxed/simple;
	bh=mj8dOhDBEawOqZN4EsKS59pbFnAi/npto8QTvaPi9gU=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=G03Qh2CUQ/84lwzpTaHUHSJvUo9YJzwa1TgiaGrpKHCi1SICtCJYGKzLKynPkLM8f3/76RrpgIC7aVeyoL9kRJo8EePMefPZJ7gb2qASi14lfloOtKO8q1vv/Jx1qQ6nHhjgN591sXQXzDGJdRtpYVL64rWajJ79134qxuWupE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id 8CA0C3780029;
	Thu, 29 Feb 2024 10:51:25 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240227131630.636392135@linuxfoundation.org>
Date: Thu, 29 Feb 2024 10:51:25 +0000
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, "Gustavo Padovan" <gustavo.padovan@collabora.com>, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <95bf-65e06180-17-20e5b800@156243252>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E7?= 000/334] 
 =?utf-8?q?6=2E7=2E7-rc1?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Tuesday, February 27, 2024 18:47 IST, Greg Kroah-Hartman <gregkh@lin=
uxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.7.7 release.
> There are 334 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7=
.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.7.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-6.7.y for this week :-

## stable-rc HEAD for linux-6.7.y:

Date: 2024-02-27
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/log/?h=3Defce2e6615798a9e83b7a4798f3713414938ab6b

## Build failures:
No build failures seen for the stable-rc/linux-6.7.y commit head \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-6.7.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

