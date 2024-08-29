Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5159F18E755
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 12:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933241; cv=pass; b=oO537naR6RXvf6ZPAYfqFPk8/MeMp8BjwzKFzfIlYLkJsAtrS5Rln5IrFFIe942s3794MtQc8LJ8RSK/O7fL7kkRhOxzsMzBsaZa+1DL4zUwtTNGxy4d+cbG5UFhjd2+IZFij5xfdXeX8SrZoyI4fO3NbWOW58gUCgRYwant0Ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933241; c=relaxed/simple;
	bh=4I+e2okk/YXtq/9Vz9Ywovnl1TTnH572UNNPSZy1zgM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=pBNr8nqZNsgjSzyVlH/aSH3zn/5OkZ7y+AJAv/oHZ7cEfxtLove2zMUhcINettDz/25uB8GLyVVE/75Zu5Ll/P8q5pCJRPfSykxmApsL8pWH3t/2FMC3Jv/439OoxfBabcIXjRBE2GcjupRbgZRZ1wgntIEiEbAcHY/x5N6Fg+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=shreeya.patel@collabora.com header.b=GeM63ouC; arc=pass smtp.client-ip=136.143.184.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=shreeya.patel@collabora.com header.b="GeM63ouC"
ARC-Seal: i=1; a=rsa-sha256; t=1724933230; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lAgKO66A+YW8nXOM/2RPjho0fKN+McEJFnRbNCQ4B85A6hz8qHLTygeQitDEWEWuhvpBxR8NqXlnfM5FGSYjwP4VoC958q872KZmIKL7d2UR5IcrLKrqiFaONPrZAOSbkXCH/zIDjrrZFOIr7nrsWBe2AcjLK0MPRtV8rSpVxMY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1724933230; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=suyBxaZl/fG6Fm9ksWETuidxGq6YUFN7oHDB/v3rqIw=; 
	b=czOsfKpv/XYBqizsDvgmRpb/d9K+6eBpnwl6CPxS56H8Ds0B1f/k3mrfYEdxLGD/41uyeoeHpaWLESu9ZhfXCSkWc7FOm1RCiqSS24cKzkwe00G4C5DqYboaUjLqx0db8oVbk5t15egmNbZd80FY+xd3LMayGri/GVRbI2wROig=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=shreeya.patel@collabora.com;
	dmarc=pass header.from=<shreeya.patel@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1724933230;
	s=zohomail; d=collabora.com; i=shreeya.patel@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=suyBxaZl/fG6Fm9ksWETuidxGq6YUFN7oHDB/v3rqIw=;
	b=GeM63ouCQd+7kOawk7G+duxxreMxS7IuB96Dvnx0NxIaWwkT4IGbYtzZGO7ARF4l
	Af2nAlPhyLssZyIUIF1Hv5sbOyD3eRsJb2lgu7wAUSH3gqHAHTDzZNQhrEwjm9oxqRh
	khH7TbE4opIcwPCpv2IBwc01ZxlywtueaQArVNFg=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1724933227631219.01950855698306; Thu, 29 Aug 2024 05:07:07 -0700 (PDT)
Date: Thu, 29 Aug 2024 17:37:07 +0530
From: Shreeya Patel <shreeya.patel@collabora.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: "stable" <stable@vger.kernel.org>, "patches" <patches@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"torvalds" <torvalds@linux-foundation.org>,
	"akpm" <akpm@linux-foundation.org>, "linux" <linux@roeck-us.net>,
	"shuah" <shuah@kernel.org>, "patches" <patches@kernelci.org>,
	"lkft-triage" <lkft-triage@lists.linaro.org>,
	"pavel" <pavel@denx.de>, "jonathanh" <jonathanh@nvidia.com>,
	"f.fainelli" <f.fainelli@gmail.com>,
	"sudipm.mukherjee" <sudipm.mukherjee@gmail.com>,
	"srw" <srw@sladewatkins.net>, "rwarsow" <rwarsow@gmx.de>,
	"conor" <conor@kernel.org>, "allen.lkml" <allen.lkml@gmail.com>,
	"broonie" <broonie@kernel.org>,
	"Kernel CI - Regressions" <kernelci-regressions@collabora.com>,
	"Gustavo Padovan" <gustavo.padovan@collabora.com>,
	"Jeny Sheth" <jeny.sadadia@collabora.com>
Message-ID: <1919e08445a.c252539b484915.5023963413874535346@collabora.com>
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

 ---- On Tue, 27 Aug 2024 20:05:08 +0530  Greg Kroah-Hartman  wrote ---=20
 > This is the start of the stable review cycle for the 6.1.107 release.
 > There are 321 patches in this series, all will be posted as a response
 > to this one.  If anyone has any issues with these being applied, please
 > let me know.
 >=20
 > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
 > Anything received after that time might be too late.
 >=20
 > The whole patch series can be found in one patch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0https://www.kernel.org/pub/linux/kernel/v6.x/sta=
ble-review/patch-6.1.107-rc1.gz
 > or in the git tree and branch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git linux-6.1.y
 > and the diffstat can be found below.
 >=20

Hi,

Please find the KernelCI report below :-


OVERVIEW

    Builds: 25 passed, 2 failed

    Boot tests: 412 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.1.106-322-gb9218327d235
        hash: b9218327d235d21e2e82c8dc6a8ef4a389c9c6a6
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y


BUILDS

    Failures
      -i386 (tinyconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=3D1&var-=
id=3Dmaestro:66cdf1fffb8042744d0f1923
      Build error: kernel/rcu/rcu.h:218:17: error: implicit declaration of =
function =E2=80=98kmem_dump_obj=E2=80=99; did you mean =E2=80=98mem_dump_ob=
j=E2=80=99? [-Werror=3Dimplicit-function-declaration]
      -x86_64 (tinyconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=3D1&var-=
id=3Dmaestro:66cdf200fb8042744d0f192a
      Build error: kernel/rcu/rcu.h:218:17: error: implicit declaration of =
function =E2=80=98kmem_dump_obj=E2=80=99; did you mean =E2=80=98mem_dump_ob=
j=E2=80=99? [-Werror=3Dimplicit-function-declaration]
      CI system: maestro


BOOT TESTS

No new boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=3D1&var-git_commit=
_hash=3Db9218327d235d21e2e82c8dc6a8ef4a389c9c6a6&var-patchset_hash=3D


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
