Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98E7226CF1
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025778; cv=pass; b=qaTQHGmcLOce4R33PXQuHKUTXevG3j1sKlcPSQYA7+rhyTwFkntM34XzxRifFDas5Lz5qSQfV8823JzxhloEkZKSgKDkBBkFtR90AJ2fxfQdEDCfO02tRhZe9gBlIT1VngSVyFIXo8hUVz4TWK9VUZhaYNL6Wui4+ByQSvepBkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025778; c=relaxed/simple;
	bh=oqrEwbU9Ws+licgNX6KHiwLwg6WJR0pSwNq64zRx/I0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XUA4UcrUoYef+uwCLw5mbbrtJvYcKW5FtLnDIsWwvnSFaaDgRamo6OpiG90UHXydjJZPmPY0QbFxBHQ2Gsdo/lWCnsx94ryPslrlFyIERz8RUBi83QDaLGKX+55d3AHPy7ZdExWcjBqfhudSJBOnJSEN6y045iB9w8n81nTLPLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=icenowy.me; spf=pass smtp.mailfrom=icenowy.me; dkim=pass (2048-bit key) header.d=icenowy.me header.i=uwu@icenowy.me header.b=kyhC08v/; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=icenowy.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icenowy.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icenowy.me header.i=uwu@icenowy.me header.b="kyhC08v/"
ARC-Seal: i=1; a=rsa-sha256; t=1760025771; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gCk7BEbeKFQEm5xKcLZczDaRt6yQkS3ki/mqrIFfsbRGMlK8er6Lbb51BjEdtwONjK5AGQOvZgLMJYPc7sZ1agd9dewULp5osZDb5pfaWuX+DwH5r6EGo5zx+PlHBHPSK0Oo4ApPUb3em51pi7rZO0QXrLTWVv0eFlr62IHTIOo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1760025771; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=oqrEwbU9Ws+licgNX6KHiwLwg6WJR0pSwNq64zRx/I0=; 
	b=kzzcG1GlOb3hDj5MZRPHZJQrs4YiV9bFqHdT24wsQnNSyegpHiEZXYKFMec1R8nFag+c5LV5qIgXmuEYmoWjt6/v24p3R40mOe+pJUTGzuw8jLLo8T5P7ncgtP8TjyEXhR78yuRcW/47/TN9XRcXRGtzS0+i4Omn3Wk42Mz4Prw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=icenowy.me;
	spf=pass  smtp.mailfrom=uwu@icenowy.me;
	dmarc=pass header.from=<uwu@icenowy.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1760025771;
	s=zmail2; d=icenowy.me; i=uwu@icenowy.me;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=oqrEwbU9Ws+licgNX6KHiwLwg6WJR0pSwNq64zRx/I0=;
	b=kyhC08v/PgDZD1DOLoQNP1hJYdBvev6mQm1OjyzqTVsg+gOzJ76RbjR7LL55evxP
	GsTg2jXZVO1UY9JT02xrjd+BBV4tEEY8XROHxneJRWbfR79BJy21dddwTPTquYfeYbJ
	0QQvURFNang5bG+5YUK6Jw4rMH6tSKrtpgnsBo/cSmCg9arP/ZK/DSlJhjoKONGuooe
	u53l5mcxFI0E/3UOtSzTC8q2U7F2eQj49/z7ZPWOcqV+D/A/cXKxGRw0NOMhevbEtIB
	Tf88xiEj9l8UgIy9tpvUUsQ0izPLt6xM1qs2pkuOLkcoljkTHvFiMIxrz0QtGUkps/B
	4XPA9RvjWg==
Received: by mx.zohomail.com with SMTPS id 1760025769333597.2230245142908;
	Thu, 9 Oct 2025 09:02:49 -0700 (PDT)
Message-ID: <04c400064452a5afa36941a57ea0d620896878f0.camel@icenowy.me>
Subject: Re: [PATCH AUTOSEL 6.17] pmdomain: thead: create auxiliary device
 for rebooting
From: Icenowy Zheng <uwu@icenowy.me>
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, 
	stable@vger.kernel.org
Cc: Ulf Hansson <ulf.hansson@linaro.org>, fustini@kernel.org,
 guoren@kernel.org,  wefu@redhat.com, linux-riscv@lists.infradead.org
Date: Fri, 10 Oct 2025 00:02:41 +0800
In-Reply-To: <20251009155752.773732-69-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
	 <20251009155752.773732-69-sashal@kernel.org>
Organization: Anthon Open-Source Community
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ZohoMailClient: External

=E5=9C=A8 2025-10-09=E6=98=9F=E6=9C=9F=E5=9B=9B=E7=9A=84 11:55 -0400=EF=BC=
=8CSasha Levin=E5=86=99=E9=81=93=EF=BC=9A
> From: Icenowy Zheng <uwu@icenowy.me>
>=20
> [ Upstream commit 64581f41f4c4aa1845edeee6bb0c8f2a7103d9aa ]

This commit seems to be not backportable -- it depends on the new
driver for the auxiliary device.

I suggest not to backport it.

>=20
> The reboot / power off operations require communication with the AON
> firmware too.
>=20
> As the driver is already present, create an auxiliary device with
> name
> "reboot" to match that driver, and pass the AON channel by using
> platform_data.
>=20
> Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>=20
> LLM Generated explanations, may be completely bogus:
>=20
> YES
>=20
> - User-visible bugfix: Without this, TH1520 systems cannot register
> =C2=A0 platform reboot/poweroff handlers via the AON firmware, so
> =C2=A0 reboot/poweroff won=E2=80=99t work even though the AON protocol an=
d the
> reboot
> =C2=A0 driver exist. This commit wires them up by instantiating the
> auxiliary
> =C2=A0 device that the reboot driver matches on.
> - Small and contained: Adds a tiny helper and one call in the TH1520
> PM
> =C2=A0 domain driver; no architectural changes.
> - Specific code changes
> =C2=A0 - Adds `th1520_pd_reboot_init()` which creates an auxiliary device
> =C2=A0=C2=A0=C2=A0 named `reboot` and passes the AON channel through `pla=
tform_data`
> so
> =C2=A0=C2=A0=C2=A0 the reboot driver can use it: drivers/pmdomain/thead/t=
h1520-pm-
> =C2=A0=C2=A0=C2=A0 domains.c:176
> =C2=A0=C2=A0=C2=A0 - `adev =3D devm_auxiliary_device_create(dev, "reboot"=
, aon_chan);`
> =C2=A0 - Hooks it into probe after setting up PM domains and the optional
> GPU
> =C2=A0=C2=A0=C2=A0 pwrseq: drivers/pmdomain/thead/th1520-pm-domains.c:250
> =C2=A0=C2=A0=C2=A0 - `ret =3D th1520_pd_reboot_init(dev, aon_chan);`
> =C2=A0 - Error path is correctly routed back to the provider cleanup.
> - Correct driver pairing: The created device name matches the
> existing
> =C2=A0 driver=E2=80=99s ID table
> =C2=A0 - Reboot driver expects `th1520_pm_domains.reboot` and consumes
> =C2=A0=C2=A0=C2=A0 `adev->dev.platform_data` as the `th1520_aon_chan` to =
issue AON
> RPCs
> =C2=A0=C2=A0=C2=A0 for poweroff/restart: drivers/power/reset/th1520-aon-r=
eboot.c:51
> and
> =C2=A0=C2=A0=C2=A0 drivers/power/reset/th1520-aon-reboot.c:82
> - Risk and scope:
> =C2=A0 - TH1520-specific; no impact on other platforms.
> =C2=A0 - Only instantiates an auxiliary device; safe if the reboot driver
> =C2=A0=C2=A0=C2=A0 isn=E2=80=99t present.
> =C2=A0 - No ABI/uAPI changes.
> - Important follow-up fix to include: The original change used
> =C2=A0 `PTR_ERR_OR_ZERO(adev)` with `devm_auxiliary_device_create()`,
> which
> =C2=A0 returns NULL on failure (not an error pointer). That was fixed by
> =C2=A0 =E2=80=9Cpmdomain: thead: Fix error pointer vs NULL bug in
> =C2=A0 th1520_pd_reboot_init()=E2=80=9D (bbc3110823eca), which changes th=
e return
> to
> =C2=A0 `-ENODEV` on NULL and returns 0 otherwise:
> =C2=A0 drivers/pmdomain/thead/th1520-pm-domains.c:181. For stable
> =C2=A0 backporting, include this fix alongside the main commit to avoid
> =C2=A0 silently succeeding when the aux device creation fails.
> - Stable policy fit:
> =C2=A0 - Fixes a real functionality gap (reboot/poweroff) for TH1520
> users.
> =C2=A0 - Minimal code, clear intent, and contained to the TH1520 PM domai=
n
> =C2=A0=C2=A0=C2=A0 driver.
> =C2=A0 - No feature creep or architectural refactoring.
>=20
> Recommendation: Backport this commit together with the follow-up fix
> bbc3110823eca to ensure correct error handling.
>=20
> =C2=A0drivers/pmdomain/thead/th1520-pm-domains.c | 14 ++++++++++++++
> =C2=A01 file changed, 14 insertions(+)
>=20
> diff --git a/drivers/pmdomain/thead/th1520-pm-domains.c
> b/drivers/pmdomain/thead/th1520-pm-domains.c
> index 9040b698e7f7f..5213994101a59 100644
> --- a/drivers/pmdomain/thead/th1520-pm-domains.c
> +++ b/drivers/pmdomain/thead/th1520-pm-domains.c
> @@ -173,6 +173,16 @@ static int th1520_pd_pwrseq_gpu_init(struct
> device *dev)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0adev);
> =C2=A0}
> =C2=A0
> +static int th1520_pd_reboot_init(struct device *dev,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct th1520_aon_chan *aon_chan)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct auxiliary_device *adev;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0adev =3D devm_auxiliary_device=
_create(dev, "reboot", aon_chan);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return PTR_ERR_OR_ZERO(adev);
> +}
> +
> =C2=A0static int th1520_pd_probe(struct platform_device *pdev)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct generic_pm_domain =
**domains;
> @@ -235,6 +245,10 @@ static int th1520_pd_probe(struct
> platform_device *pdev)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto err_clean_provider;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D th1520_pd_reboot_init(=
dev, aon_chan);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0goto err_clean_provider;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> =C2=A0
> =C2=A0err_clean_provider:

