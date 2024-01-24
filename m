Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F15131E33
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 20:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706128055; cv=none; b=KQqNwNLkdFY03eoMYtrXCrFZii5+kHySZlWBKDZtXLFClnUojv3eATPz6a/d7pPJCUZFIuSDrKC03GvIqRi+qUJcLc1LyZTWRiW1vxVG2sEOhYQ1dPBQgL/8UrQJ6iOLSOOCKz+SFIMtysxCuMr94EJhbgOZEaZou8yUwr6THAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706128055; c=relaxed/simple;
	bh=VDCwxQU9FEHBnkrktNliUQSJyl6fzdsH5Lr1UcvqzLU=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=WvQdJFNIxli5H6KzA1hbPhO2shUvoZGLMhPLrUc2qK8FwAGZJnn/uRyBv/xFw89fScx798EkyaYAo+dz8ezuv111zgufY43OVMznMW5QAeIduNrEWdK2YbJkS6bW+KROhF47pVS4Ap/rw8Ufh33rVHM7vVwTuo+VzBkYU/StNXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from hamburger.collabora.co.uk (hamburger.collabora.co.uk [IPv6:2a01:4f8:1c1b:c794::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id 8955337813E9;
	Wed, 24 Jan 2024 20:27:23 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240123174434.819712739@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240123174434.819712739@linuxfoundation.org>
Date: Wed, 24 Jan 2024 20:27:23 +0000
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, "Gustavo Padovan" <gustavo.padovan@collabora.com>, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <53f5-65b17280-3-34c04d40@156471994>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?5=2E4?= 000/193] 
 =?utf-8?q?5=2E4=2E268-rc2?= review
User-Agent: SOGoMail 5.9.1
Content-Transfer-Encoding: quoted-printable

On Tuesday, January 23, 2024 23:16 IST, Greg Kroah-Hartman <gregkh@linu=
xfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.4.268 release.
> There are 193 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Thu, 25 Jan 2024 17:44:10 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4=
.268-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-5.4.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-5.4.y for this week.

## stable-rc HEAD for linux-5.4.y:
Date: 2024-01-24
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/log/?h=3D6207e0931754e4be20272a062c996b9dc9e68d62

## Build failures:
No build failures seen for the stable-rc/linux-5.4.y commit head \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-5.4.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

