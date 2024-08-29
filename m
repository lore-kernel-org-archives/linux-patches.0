Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37A5191F9B
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 12:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724932844; cv=pass; b=FN+qiaNrQRS8WI+MxTjuT1UF1XgpjxL7eBl+q9vUxBbtrFho/LlKusdOG4wwfWEALGTS5CuVypl/1NWOJ1N2vfAD3ejvc4E8ShyzZXQO5/adnOLYVRFTefiOV5knn3ZzZ5ZlEQ72BNOqALvneEDIkZWsbR21A+SSWikDt7Q/KRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724932844; c=relaxed/simple;
	bh=5xKzhR89bpue/0eQdd1l6Vs4rAvduJP3oOA5bTwbmIk=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=qRLagAXNQO7Ym8zrIfmKAFCBMtUMW6BFlhnq6/oL3ImsQs9PEGEwUOAgRAW6heZpJ3mlYe9vF1e91Lv2MmjKfahENW8WB+Gkak2p6QFkDSYZOeQ8qgJpHUNUUJM1E0GI0A96eKJPeYq1otx08T0zor7BA9MeuVz/znp+s/SUOJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=shreeya.patel@collabora.com header.b=Ioj1IOK/; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=shreeya.patel@collabora.com header.b="Ioj1IOK/"
ARC-Seal: i=1; a=rsa-sha256; t=1724932824; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gEUeMDlknsslWudInFfO2h6SlRWRFz8XND0cvsGwBQ/fQtywnEdFo0aZieDmpTWLDI911lvKc7ZckDAI76uyL6XLj8o07bU1YyCstmO6RV1jI3PZMyakmzQC8RCXBQUpPVPI0gi/Bs9ODKijL1MIqdSWPGMTM+nJIHwl8SOhGXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1724932824; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XMih+Ra2OZEiXSZgd9Koud+lRr5eqpgf2Qoc0vzxEm4=; 
	b=eG7YYxRaEGau3ls8pZE8DqF00rerEyQ71WitZ2jVKVxjr5JwNVEU4lmdqGyqT3fvOZ6wTLNQ2NK8aotewuT9zsUNBYbmiZ5amxEnsN7q70TTdmVArFNPmoBeBe8rIdh54uyHm5a5tBdCWYAC7ZlG+AM9IWFObQ1XwJUU/Tb/MIo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=shreeya.patel@collabora.com;
	dmarc=pass header.from=<shreeya.patel@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1724932824;
	s=zohomail; d=collabora.com; i=shreeya.patel@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=XMih+Ra2OZEiXSZgd9Koud+lRr5eqpgf2Qoc0vzxEm4=;
	b=Ioj1IOK/vjqvnZtfGh7upF26YNk5tmY4nAAFNrDaw7RmWJB9nDjR7YL1tV4M9rYw
	muw8a2dsRTVPn+630DL6VBoNC5YLZ1LRwDeyLaXJAhavnnofQ1BJsc6gjGqTE3E1EBR
	sRl0G94hzwkBqP7h3ymlNwGSiKddhfq0wWb/IGFY=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1724932822202603.4018372370394; Thu, 29 Aug 2024 05:00:22 -0700 (PDT)
Date: Thu, 29 Aug 2024 17:30:22 +0530
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
Message-ID: <1919e0214a0.bc2e94fb482384.3257750178650984120@collabora.com>
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
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

 ---- On Tue, 27 Aug 2024 20:05:24 +0530  Greg Kroah-Hartman  wrote ---=20
 > This is the start of the stable review cycle for the 6.10.7 release.
 > There are 273 patches in this series, all will be posted as a response
 > to this one.  If anyone has any issues with these being applied, please
 > let me know.
 >=20
 > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
 > Anything received after that time might be too late.
 >=20
 > The whole patch series can be found in one patch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0https://www.kernel.org/pub/linux/kernel/v6.x/sta=
ble-review/patch-6.10.7-rc1.gz
 > or in the git tree and branch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git linux-6.10.y
 > and the diffstat can be found below.
 >=20

Hi,

Please find the KernelCI report below :-


OVERVIEW

        Builds: 30 passed, 0 failed

    Boot tests: 334 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.10.6-273-gb49f2df929ba
        hash: b49f2df929ba1bbf4ef3b81d88f8118cfbd8b936
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.10.y


BUILDS

    No new build failures found

BOOT TESTS

    No new boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=3D1&var-git_commit=
_hash=3Db49f2df929ba1bbf4ef3b81d88f8118cfbd8b936&var-patchset_hash=3D


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
