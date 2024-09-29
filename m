Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74CE566A
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 11:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727609541; cv=pass; b=VewgW0Gd/Vl1YiC8Hnyu34r1EIbK08yfk5UbYJtE32AHqRhiEUzcHc0n0aJ3VgdcSBLireM+J+2FNVunYEtFM9oi8gxq5y8fZSMSb+ohYINB3QcxSwGJ0ZQ0cC16Ej5rVdIJQo2PfdzcRxnB8g/0vLlHeF8uIgjbYZmFXlNRYPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727609541; c=relaxed/simple;
	bh=jUn3LPOskohkiFeSLA/8mPX4OEpGDlt97I7TIn2tSB4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=DHmqsyj0K5AMDbV7Jp0k/9wqtf9mPF/EtYrOs/aaI8U8uHXsO0O5D/dXhQfdHoAKoMEu7UPg4Z8KJkFxDv/odjQkSOexUUxUYp9YT1Svdd8sFwZKcJpjCbb8aJOYGtKsJpybIAbXklFn6YHqrrq4lLKWAlDxFh8ZHQ6QsBJrDuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=usama.anjum@collabora.com header.b=VR5vzQzq; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=usama.anjum@collabora.com header.b="VR5vzQzq"
ARC-Seal: i=1; a=rsa-sha256; t=1727609529; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=YKvmnT+iYERgFVgy4jnd7dT5CNmodaBaqdbxRV72cb7WVaw8sd8nn+1EgNT3VhUbEjIjLK0VmavXvUlZFxwb0on1n65M7ydjTA6HF61IHgZVMHIbmEgqzC3/9kAjM8Q0E24KphAqTVmzJnNdcqAWM98dUqtNw2t2OKIgEyHiKy8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1727609529; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+oapaXx3XFLk4WDQzU9G8+LiXmfm8UsE96Y61X7sWYY=; 
	b=LklGHro3DASUso/wOXJN6/J4Yi2wavrccy7fPJyan8EnzJ0mo21I9sydq5vh15M9HRO1H3wpdxQaUMel8c5OJujSZorpMfmcr2guG57kBTK+YewAoBVnEArHhhPTBGEbGnOfr88E825p6URUIxrdTxC6XiKY6vKE/ivNjua2WGA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1727609529;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=+oapaXx3XFLk4WDQzU9G8+LiXmfm8UsE96Y61X7sWYY=;
	b=VR5vzQzqRb9uJLwZ9Z2C0NdIWb6FNAl6vGncmdKAbKeBMAV22phs75haY0KVAAFu
	KjDklb6FYenznzFNfOyn//04o47CciIk0MrcUME9MN7rN3vQLssXJuQtIF7Y6havjL5
	Rt2LF0OnhaVhno/WOE4NgWBRPOAPb5m8+S3MIfbM=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1727609526930389.55279857088453; Sun, 29 Sep 2024 04:32:06 -0700 (PDT)
Date: Sun, 29 Sep 2024 16:32:06 +0500
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
Message-ID: <1923d8d5a7c.10afeb89b1212214.5394229206543380722@collabora.com>
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
References: <20240927121715.213013166@linuxfoundation.org>
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
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

 ---- On Fri, 27 Sep 2024 17:24:03 +0500  Greg Kroah-Hartman  wrote ---=20
 > This is the start of the stable review cycle for the 6.11.1 release.
 > There are 12 patches in this series, all will be posted as a response
 > to this one.  If anyone has any issues with these being applied, please
 > let me know.
 >=20
 > Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
 > Anything received after that time might be too late.
 >=20
 > The whole patch series can be found in one patch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0https://www.kernel.org/pub/linux/kernel/v6.x/sta=
ble-review/patch-6.11.1-rc1.gz
 > or in the git tree and branch at:
 > =C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git linux-6.11.y
 > and the diffstat can be found below.
 >=20
 > thanks,
 >=20
 > greg k-h
 >=20
 Hi,

Please find the KernelCI report below :-


OVERVIEW

        Builds: 25 passed, 0 failed

    CI systems: maestro

REVISION

    Commit
        name: v6.11-13-gcecd751a2d94b
        hash: cecd751a2d94beedbaab82f5eb42ed19b0bbff41
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.11.y


BUILDS

    No new build failures found

BOOT TESTS

    No new boot failures found

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team

