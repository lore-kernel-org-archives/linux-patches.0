Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A469E190468
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 11:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724930084; cv=pass; b=tJKAnusXhUXdk+QIyqhpgwiKfM/MZ25oBkBv0uj8Pile/r0s4BXnjKLj+g/65lpYrZKAFcp8dJQwROpH/OQRL561jGEVZ5NfxgL8pyHGnillYiSxjKADT5AP6xhzIXda4AYMzupbzW+8uBRM4fds80Wzjwo4HP/m2qyNKYWIBPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724930084; c=relaxed/simple;
	bh=XNgpgXy8BWzemPVyYyqvZqBqyMbZxQd898INyFO+4h8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=ip9sG2nj9U1gKCPS/dBYOl/081p4jYvrryKrKqnzLH4klyKnjtmqztNeIJEfMY5FS0dZr472OQmlqFndwZplg3Af7CpjK6rrxP4aaM7DKFvXk/wYzSIQRFsaIkLoc8b1Zf3sGsTx+Bz6nrMmSwu5fDrbeQPIIn1ec2R2Tp0nGoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=shreeya.patel@collabora.com header.b=Yd3VybFr; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=shreeya.patel@collabora.com header.b="Yd3VybFr"
ARC-Seal: i=1; a=rsa-sha256; t=1724930071; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=DfPzDSylb8U6ZKJWOTc60smxfv35Du8b/r3tLyf5hrGnUEJ9eA3WBXlVeEcYKcCg+ntZJA5awDSEFLXoTT4WY7H8m9H1V/Ul+AGyXlHxrVxiAW/WJv7mPMOWiWgR+0nXwZ6TGViCjxOVTUPMxYzCpFEe7r/8wLsZ5m4j0vCl/rA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1724930071; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FvUnkTngcFUqn+ENmgaZvQ/jbOmVX27wh0PL86ioFCQ=; 
	b=Gc6jxBWPf6IMZAJjleWz94PunDgX6xa5KT1rtw8wFtRXLprn6YFPzFumw0wcTJKamBMUZjmn5ZXnnBZpKhm4x42dt/ZsqoN7GUqlFQMm8LcyFzgxT5vZ5I25jX89Gg3pEDqcBPqV5u6nWOxX8upPm5rH3xFmmeRJXqwbWzzfdk8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=shreeya.patel@collabora.com;
	dmarc=pass header.from=<shreeya.patel@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1724930071;
	s=zohomail; d=collabora.com; i=shreeya.patel@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FvUnkTngcFUqn+ENmgaZvQ/jbOmVX27wh0PL86ioFCQ=;
	b=Yd3VybFrQf1WV/UpDb5Z5XC10pXlGAe+DdCVXpf0aZiqyM7nKPB3DHBb54wWBAP7
	0BbGmj8/RLbvYUYptC3sgs4VJ4NYhVU4mb2vRAD7H+g6ns1MbBoblki6KsEGHZsrH2M
	2B6adYvTJTJt/pK8mB3792qr5TKjtxFylkd2O7nw=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1724930068832649.3499772276887; Thu, 29 Aug 2024 04:14:28 -0700 (PDT)
Date: Thu, 29 Aug 2024 16:44:28 +0530
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
Message-ID: <1919dd8114b.bf596719466314.4771125099001339719@collabora.com>
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
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

 ---- On Tue, 27 Aug 2024 20:03:51 +0530  Greg Kroah-Hartman  wrote ---=20
 > This is the start of the stable review cycle for the 6.6.48 release.
 > There are 341 patches in this series, all will be posted as a response
 > to this one.  If anyone has any issues with these being applied, please
 > let me know.
 >=20
 > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
 > Anything received after that time might be too late.
 >=20
 > The whole patch series can be found in one patch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0https://www.kernel.org/pub/linux/kernel/v6.x/sta=
ble-review/patch-6.6.48-rc1.gz
 > or in the git tree and branch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git linux-6.6.y
 > and the diffstat can be found below.
 >=20

Hi,

Please find the KernelCI report below :-

OVERVIEW

        Builds: 30 passed, 2 failed

    Boot tests: 436 passed, 20 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.6.47-330-gfd01fbcb4e1b
        hash: fd01fbcb4e1b208d063aedf49e3af43655837eb2
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y


BUILDS

    Failures
      -i386 (tinyconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=3D1&var-=
id=3Dmaestro:66cdd5a3fb8042744d0e8d2b
      Build error: kernel/rcu/rcu.h:255:17: error: implicit declaration of =
function =E2=80=98kmem_dump_obj=E2=80=99; did you mean =E2=80=98mem_dump_ob=
j=E2=80=99? [-Werror=3Dimplicit-function-declaration]

      -x86_64 (tinyconfig)
      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=3D1&var-=
id=3Dmaestro:66cdd5a5fb8042744d0e8d36
      Build error: kernel/rcu/rcu.h:255:17: error: implicit declaration of =
function =E2=80=98kmem_dump_obj=E2=80=99; did you mean =E2=80=98kmemdup_nul=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]
      CI system: maestro


BOOT TESTS

    Failures

      arm:(multi_v7_defconfig)
      -bcm2836-rpi-2-b
      CI system: maestro

      x86_64: (x86_64_defconfig)
      -lenovo-TPad-C13-Yoga-zork
      -hp-x360-14a-cb0001xx-zork
      -hp-14b-na0052xx-zork
      -asus-CM1400CXA-dalboz
      -acer-cbv514-1h-34uz-brya
      -minnowboard-turbot-E3826
      CI system: maestro

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=3D1&var-git_commit=
_hash=3Dfd01fbcb4e1b208d063aedf49e3af43655837eb2&var-patchset_hash=3D


Tested-by: kernelci.org bot <bot@kernelci.org>


Thanks,
KernelCI team
