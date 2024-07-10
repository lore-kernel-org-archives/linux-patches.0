Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416D418D4BB
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 09:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720603086; cv=none; b=PKYMx2Bmd07ja4yxb+R0StK8NuLYv1IKsBf1JPKCZ1+ejsF5RgQhNRjJ091FnjO+INlPwb9epUgy7ojEpRjOX1DeJqZMdXlmBqGcLHEDLqU2eOBu9VqSsWQ5OMlV6Oo5qJcpsSCGRI4kpD88m+rmJ/Xr4HMHWgfwYTdu1Z0IGxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720603086; c=relaxed/simple;
	bh=a6WyJtmy/EX/kDAw2Lc7OK0n95L0YBQG/E9DydIrTug=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=QloCLqWlslDHesLuWq3av8RZ0QZldhttCj7F3Wx6K3rfYLoFzCuGzFFhWV9ZDBr4g6HUWZ1lm6hHjUNMn6HThq+hgNoFDejCGOm06aYGe2RPADpqeGwVfYyNz6pDHim39MZcWTNZcfRD2uGVfvmkDnBNpeBBdIERV57p4rIGHNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id E94D13780B79;
	Wed, 10 Jul 2024 09:18:01 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240709110651.353707001@linuxfoundation.org>
Date: Wed, 10 Jul 2024 10:18:01 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <241fc7-668e5200-3-114579a0@76186244>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E1?= 000/102] 
 =?utf-8?q?6=2E1=2E98-rc1?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Tuesday, July 09, 2024 16:39 IST, Greg Kroah-Hartman <gregkh@linuxfo=
undation.org> wrote:

> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1=
.98-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.1.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-6.1.y for this week :-
Date: 2024-07-10

## Build failures:

No **new** build failures seen for the stable-rc/linux-6.1.y commit hea=
d \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

