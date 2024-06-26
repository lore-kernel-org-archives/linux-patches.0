Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7491B171E7F
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 10:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719398313; cv=none; b=mKrhoJWhFyR1Kc1GhkAbEgG/uZIX0aG2TeHKpSFjhM3Eph5sOSSIGKRrdt6RuptXs0kVVlQDP27uDaGgZNPw3MiB10vmlkjlrOcePk9eCStSiunZp6j2dTXpUSXG8OD5bGUl7AM2xKRm61gauPdHMy/zJ1Oz6tgNJRY3K8FqZqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719398313; c=relaxed/simple;
	bh=Xe0tWwWX3UXLh9yjAaR5X8wanKEVa3TLoFoffnYFyLg=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=joGXBxZrg50iJD/60uFE7rH2T3juM592UNEeqh9oqLxjOlFplt3fmsVlYM7IuMNOZ4iQP13WfK8YPtC6O/J//4K4k2CgVG/R6iWY7aOO/wQQdBjoIvQgCz/OCQr+PoRV3xr1iWzzSCGuuDE7T8iMyLEXN1A7vbUVMbxB6XvfFLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id 3850537810EF;
	Wed, 26 Jun 2024 10:38:29 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240625085537.150087723@linuxfoundation.org>
Date: Wed, 26 Jun 2024 11:38:28 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>, "Gustavo Padovan" <padovan@collabora.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <30762b-667bef80-5-529d9000@215728945>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E6?= 000/192] 
 =?utf-8?q?6=2E6=2E36-rc1?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Tuesday, June 25, 2024 15:01 IST, Greg Kroah-Hartman <gregkh@linuxfo=
undation.org> wrote:

> This is the start of the stable review cycle for the 6.6.36 release.
> There are 192 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6=
.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.6.y
> and the diffstat can be found below.
>=20
KernelCI report for stable-rc/linux-6.6.y for this week :-

Date: 2024-06-25

## Build failures:
arm:
    - multi=5Fv7=5Fdefconfig (gcc-10)
    - Build details :-
       http://localhost:3000/goto/RvP98cQIg?orgId=3D1
    - Errors :-
     arm-linux-gnueabihf-ld: drivers/firmware/efi/efi-init.o: in functi=
on `.LANCHOR1':
efi-init.c:(.data+0x0): multiple definition of `screen=5Finfo'; arch/ar=
m/kernel/setup.o:setup.c:(.data+0x12c): first defined here

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

