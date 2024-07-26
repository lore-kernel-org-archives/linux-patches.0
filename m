Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1390179967
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721988235; cv=none; b=jKMf50jVJz3Tq8MYuxKQftt+P4eDDbYNzpUWLVEX+NuiNmuGmVGcLx7NRkyiJjwdx1BccHsXp25+cN7hSnI2eeiP8votk5yT005AvVmXKyRTgmu+7Q2iLpFanvd6bzxJlmrNVxN5gHruzrsG6ZrOyv5QV8tmSBQf++vjyftjAMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721988235; c=relaxed/simple;
	bh=Sr77s+/Ii927lX9PVWg0Bttm8hmTcDMtK+RtZJFMCkk=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=DqVc5rXGu938OTr3HiMr7TPrXbOYuGKIvScPfNuIQYOiwBIofmYhGu6nTyxeSRuPi/tyyv/tOLRup95bNj+TuyHO/der5BjmFsumnNgrrY7AENEtEqyja8mGeYIwAnKZFAbbuvum78ERKw+nfMfoq82ONAqT1fbgUyMNKNsXAKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id 8A6203780BDB;
	Fri, 26 Jul 2024 10:03:50 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240726070557.506802053@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240726070557.506802053@linuxfoundation.org>
Date: Fri, 26 Jul 2024 11:03:50 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1399f9-66a37480-3-413a9280@15567400>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?5=2E15?= 00/90] 
 =?utf-8?q?5=2E15=2E164-rc2?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Friday, July 26, 2024 12:42 IST, Greg Kroah-Hartman <gregkh@linuxfou=
ndation.org> wrote:

> This is the start of the stable review cycle for the 5.15.164 release=
.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Sun, 28 Jul 2024 07:05:35 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1=
5.164-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-5.15.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-5.15.y for this week.

Date: 2024-07-25

## Build failures:
No build failures seen for the stable-rc/linux-5.15.y commit head \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-5.15.y commit hea=
d \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

