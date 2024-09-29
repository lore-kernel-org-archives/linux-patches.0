Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A0B148FEC
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727608796; cv=pass; b=ZyKn6q7EJ9rdD2qUJXQPGo9flAR5yqM8MYn1fG3vzpR3bRaWIac9Q0OwP/f33EROu6Lf+tFy+oRRhaCbJFllWGgF4vU36yd2k1I7gKSCha3fXq3lZPyT3g7v4r+Z4Kdoe9PGYf5CGuJt1FqfTHYiyxnhysIHnBApPQDuAKAeXyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727608796; c=relaxed/simple;
	bh=7mMbxfj5uecDyMJoVfkl/zDJkNEtWO6SuaHNgr/ay0I=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jS9Q9sWP3eg7o9MiHPhSVvfRxWCVsg2JKcNn7KWj5SAmNaM8pxFIR+sd9wQIKLUSE64JZR0miVHz5mKEbvZQOpAyyogJA8oUcvu3rUKISd5LykeZQse2bcFEsryb1DHaAbVA7ZNyWyaPnt3PCzxCm7KTpi+CYqWtdDNGeUxZnms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=usama.anjum@collabora.com header.b=dDoY2+4C; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=usama.anjum@collabora.com header.b="dDoY2+4C"
ARC-Seal: i=1; a=rsa-sha256; t=1727608784; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZaaPZGZYsH/agUsRl0+cHimUwX4Spfw9WvURg1hptIl2HP829zd6kxODv8EXDgAnRUxpRXzBlEO4aB4Ig/YeYB4abVa0wQw/YJ2EHZrStVOAJzt8sVpx+zDe6TteieXrcMEM4HT8BCU8QtqPt/0IIJpdbMtwAHNpowHnl9QVL/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1727608784; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=/Wz3FuuXy8JQ2sA19BZqM+ZEwbQcxR1B3DEfqAwwS1g=; 
	b=dgV35JhUeCmRcQnlowFFfZtlvSErbYaBXtpSpia7m45MOFEjtdOSpFUiTJevZoL2NB705Pk+Sv6maxtb8aqvcWQL24Q5UYxDyLCWc7VDaw1Nd3RF79zoZRstWwM8rwCdXbn7VcSNy2aZlPaRRNYDAtjayxGSvrjgcFCDPYuXdew=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1727608784;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=/Wz3FuuXy8JQ2sA19BZqM+ZEwbQcxR1B3DEfqAwwS1g=;
	b=dDoY2+4CfYMLTGwroGd3NBEjimBzneMu3nVkJoQdPWuy94bKNyGo9ie6etTN7mER
	pkclqtnzO9OGmdW4B1Z0qy6gskzhUq3wq2Q8V32SaG92XKyddNA3JNPFPEnjsLYBWyW
	EUUYlzgSfGmoyCCde63b+ptsM3BYgeGDz+pR1xtQ=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 17276087839247.792067167454434; Sun, 29 Sep 2024 04:19:43 -0700 (PDT)
Date: Sun, 29 Sep 2024 16:19:43 +0500
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
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
	"broonie" <broonie@kernel.org>
Message-ID: <1923d82041c.de71f6821211146.7785525102914315480@collabora.com>
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
Subject: Re: [PATCH 6.1 00/73] 6.1.112-rc1 review
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

 ---- On Fri, 27 Sep 2024 17:23:11 +0500  Greg Kroah-Hartman  wrote ---=20
 > This is the start of the stable review cycle for the 6.1.112 release.
 > There are 73 patches in this series, all will be posted as a response
 > to this one.  If anyone has any issues with these being applied, please
 > let me know.
 >=20
 > Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
 > Anything received after that time might be too late.
 >=20
 > The whole patch series can be found in one patch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0https://www.kernel.org/pub/linux/kernel/v6.x/sta=
ble-review/patch-6.1.112-rc1.gz
 > or in the git tree and branch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git linux-6.1.y
 > and the diffstat can be found below.
 >=20
 > thanks,
 >=20
 > greg k-h
 >=20
 Hi,

Please find the KernelCI report below :-


OVERVIEW

        Builds: 26 passed, 0 failed

    Boot tests: 500 passed, 0 failed

    CI systems: maestro

REVISION

    Commit
        name: v6.1.110-137-g4f910bc2b928
        hash: 4f910bc2b928f935a8a8203ccfa7be8456ac8f29
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y


BUILDS

    No new build failures found

BOOT TESTS

    No new boot failures found

See complete and up-to-date report at:
 https://kcidb.kernelci.org/d/revision/revision?orgId=3D1&var-datasource=3D=
production&var-git_commit_hash=3D4f910bc2b928f935a8a8203ccfa7be8456ac8f29&v=
ar-patchset_hash=3D&var-origin=3Dmaestro&var-build_architecture=3DAll&var-b=
uild_config_name=3DAll&var-test_path=3D

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team

