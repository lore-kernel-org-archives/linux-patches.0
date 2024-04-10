Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520C813D274
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 08:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712738783; cv=none; b=MHwgH+C3vSEGUtYZoUbHZkHYmjnU+xr9TOhECgVtNpTF/Zx7DmwYsZLemgflyHM4NtQWOmCLpiH+esSwBG8p49snMDniZU5nKUioP3WS5jYg+u0TvBiymy4FSphgDJSe5NDZ81lzb69LmF9pNiScnyWwChMuRqYUt1PZQxs21Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712738783; c=relaxed/simple;
	bh=90hWQ+ubNEuCYKT0GJY7VybLwzVVSh8JhjHzzsQRa88=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=YTgRD76Hx4LiWlyqns242PTksGYXd+nAQ84CKIqlhkd5FensZ8997EZR43rGjMvv+CWUy8JSLT/cNhoronDFccaky+0QDi84Q5kO+ZzD5Lxy7jRPSKzCZKCkgXCv8q1H6xRF9LjZQIePQ4MesddlT6s98sDkqnNLochh16tIDxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id C91BB3781453;
	Wed, 10 Apr 2024 08:46:18 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240409172821.820897593@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240409172821.820897593@linuxfoundation.org>
Date: Wed, 10 Apr 2024 09:46:18 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "Gustavo Padovan" <gustavo.padovan@collabora.com>, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3c0c9c-66165200-11-194ac52@218875518>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E6?= 000/254] 
 =?utf-8?q?6=2E6=2E26-rc2?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Tuesday, April 09, 2024 23:00 IST, Greg Kroah-Hartman <gregkh@linuxf=
oundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.26 release.
> There are 254 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Thu, 11 Apr 2024 17:27:40 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6=
.26-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.6.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-6.6.y for this week :-

## stable-rc HEAD for linux-6.6.y:
Date: 2024-04-08
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/log/?h=3Dec59b99017e96d3bc8a6d5b87c01f47ec5a9bcb9

## Build failures:
No build failures seen for the stable-rc/linux-6.6.y commit head \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-6.6.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

