Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB1F158D83
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721829395; cv=none; b=knzAwjjInaQgw+FE5wAMSExrQcAFB2JohNb0wnZLyDGjGL9x7A0+lxKjt2Li8Q9SOMsAapM1FxTLNmuoy/1q5seLzsXZjn7xqfCEWDc/Y+UcReIEaHf2Dsy1nFuyK+dlsQou22rT4cpJIey/j8/HPWGI6tS3B1BF+brl716QWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721829395; c=relaxed/simple;
	bh=ILnj0zrNHOQ4yQBEwNz/BYIysAnUuTUT3aSAck/yegM=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=IxIVNecX83HChmok50VhKL/rknmpqUMrOcs2jPHlOoPUBP/FrN4l9LS1tKHpa+cI6tANaseQCHAtB516I9ojbORkrJZ8Wb1iastTAiMTGv+6LVKKx5F5SVIwr1xQLcNkUnGniaAw6+gsAMZCe0uaY9QHo0L/HqEfN0KAJW2QvEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id BB70F37820C2;
	Wed, 24 Jul 2024 13:56:30 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240723180402.490567226@linuxfoundation.org>
Date: Wed, 24 Jul 2024 14:56:30 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3e829-66a10800-5-27bd0c00@125188431>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E1?= 000/105] 
 =?utf-8?q?6=2E1=2E101-rc1?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Tuesday, July 23, 2024 23:52 IST, Greg Kroah-Hartman <gregkh@linuxfo=
undation.org> wrote:

> This is the start of the stable review cycle for the 6.1.101 release.
> There are 105 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Thu, 25 Jul 2024 18:03:27 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1=
.101-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.1.y
> and the diffstat can be found below.
>=20
> thanks,
>=20

KernelCI report for stable-rc/linux-6.1.y for this week :-
Date: 2024-07-24

## Build failures:
No **new** build failures seen for the stable-rc/linux-6.1.y commit hea=
d \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-6.1.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

