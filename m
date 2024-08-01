Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0775B157493
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 08:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722500990; cv=none; b=IgufxLXtGV9mtnccBCApUw1fXI2ceawJkZeTvNONC+FHuMcmYi8m4HPIcflMEyyi6jjYsj6cEw87i/BdiqvQB9GnvzYRx6cX8vXH3xBwk2AG4rNwlPskdOk+GZ/D0JpM9J+nu0V5XTibCDqAy98auGeHny+WS1LOijELb34steU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722500990; c=relaxed/simple;
	bh=jzSkptHy4LcCnyWy2MGmyqnssPs2XM2lp2+aSZOgw4o=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=L/ajG5qFvWkAdqMNePmKyU3L3HQbW4CJisBT+bh40As4ZMTxA2DqKweakEd1z4//y2Ib8P+/SYSjgSjhBtV42BFh1EHjnJCMK9fKhHoIClm7klUc2F97HJvS/X2MFnWo9jJzNT4+jbbFzWL3fdvT2tMJDELVks+u52zZ2O9kqcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id 0D3F03780520;
	Thu,  1 Aug 2024 08:29:45 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240730151639.792277039@linuxfoundation.org>
Date: Thu, 01 Aug 2024 09:29:45 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4fef0-66ab4780-f-4deb0a00@140848578>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E6?= 000/568] 
 =?utf-8?q?6=2E6=2E44-rc1?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Tuesday, July 30, 2024 21:11 IST, Greg Kroah-Hartman <gregkh@linuxfo=
undation.org> wrote:

> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6=
.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.6.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-6.6.y for this week :-
Date: 2024-07-30

## Build failures:
No **new** boot failures seen for the stable-rc/linux-6.6.y commit head=
 \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-6.6.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

