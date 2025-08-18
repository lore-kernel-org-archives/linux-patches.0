Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4C926FD8E;
	Mon, 18 Aug 2025 06:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755498847; cv=none; b=tOFzOnKEBu8Zmf8stjfxQsflZfkEslMpY6TUXOBtR+dbknf2thizSehoMfAiKCYZMnZpKWYz7ibqrfE0hlodhNEZE+IvKR8eTV5EwtqECIailVA6mJmb+7EG8ntbtZCQkI8/kfZoNOFN0vu2Djxe02pirCd7fgdbD/84qCF0Mtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755498847; c=relaxed/simple;
	bh=TuT1Q3ab9MEdA63O5u8QSJxHcrlpKFyOYhq7iu8xQKc=;
	h=Content-Type:Date:Message-Id:Subject:Cc:From:To:References:
	 In-Reply-To; b=mfskBrWbGWpnjWKozY3yTjMUMaYli0pBwEc5qhiHghAQLpwCpItIXwkLkHRPUKWROyvcm8IF3A2+byu408ra1oWwj/oaWYAFpftjjSyWGNTRNsHhjnnLoGBvjF8wPxN3QvXd0xS/JS8tSFtuRAVDuE9CSiWzd83LS0bqFUtBB6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqjgh3cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqjgh3cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13DAC4CEEB;
	Mon, 18 Aug 2025 06:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755498847;
	bh=TuT1Q3ab9MEdA63O5u8QSJxHcrlpKFyOYhq7iu8xQKc=;
	h=Date:Subject:Cc:From:To:References:In-Reply-To:From;
	b=kqjgh3cxyMw2Zu0BIe0IRTM5G68fDYWwP4MyCD0hkzIBjTBHFRTDilNoi2S1NWfYz
	 3owbAQAqsDS60lpBfzTIwqepD/5hVR1jF8HMPN6iCl9eSUaxsV3YUPBP8VhWvaMDem
	 On2OBFN7mrY0qbluRaYLfmDqEhmz4zFKWy1EDKSky+VjLp6OuFg4MWUwBuMwcVAjQY
	 Bh7Na2xUQaAk0p6ObgIDXFjzeMsoep6aaFAIN/+1F/Gbl9M7KM+cuEnGEK7WA4vI/A
	 AGwF+qc0WPmJE18lqK0OIacQ2BuBXE7oVmNaNIJrxa7hOvMFsIyGjCiOmnzGYLSsK1
	 MYdha2NyC2oxg==
Content-Type: multipart/signed;
 boundary=b0bb75deace1dbc2ddd5574427033e423afc4aadde330d8d0257abae0a9d;
 micalg=pgp-sha384; protocol="application/pgp-signature"
Date: Mon, 18 Aug 2025 08:34:03 +0200
Message-Id: <DC5CEJ4YYRRB.3VTJAONRBJPVB@kernel.org>
Subject: Re: [PATCH AUTOSEL 6.12 27/69] mfd: tps6594: Add TI TPS652G1
 support
Cc: "Lee Jones" <lee@kernel.org>
From: "Michael Walle" <mwalle@kernel.org>
To: "Sasha Levin" <sashal@kernel.org>, <patches@lists.linux.dev>,
 <stable@vger.kernel.org>
X-Mailer: aerc 0.16.0
References: <20250804003119.3620476-1-sashal@kernel.org>
 <20250804003119.3620476-27-sashal@kernel.org>
In-Reply-To: <20250804003119.3620476-27-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

--b0bb75deace1dbc2ddd5574427033e423afc4aadde330d8d0257abae0a9d
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi Sasha,

On Mon Aug 4, 2025 at 2:30 AM CEST, Sasha Levin wrote:
> From: Michael Walle <mwalle@kernel.org>
>
> [ Upstream commit 626bb0a45584d544d84eab909795ccb355062bcc ]
>
> The TPS652G1 is a stripped down version of the TPS65224. From a software
> point of view, it lacks any voltage monitoring, the watchdog, the ESM
> and the ADC.
>
> Signed-off-by: Michael Walle <mwalle@kernel.org>
> Link: https://lore.kernel.org/r/20250613114518.1772109-2-mwalle@kernel.or=
g
> Signed-off-by: Lee Jones <lee@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> LLM Generated explanations, may be completely bogus:
>
> **YES**
>
> This commit should be backported to stable kernel trees for the
> following reasons:
>
> 1. **Hardware Enablement (Device ID Addition)**: This patch adds support
>    for a new PMIC variant (TPS652G1) by adding its device ID and
>    configuration. According to stable kernel rules, patches that "just
>    add a device ID" are explicitly allowed for stable backporting.
>
> 2. **Self-Contained Changes**: The modifications are isolated to adding
>    support for the new device without altering existing functionality:
>    - Adds `TPS652G1` to the `enum pmic_id`
>    - Adds TPS652G1-specific MFD cells configuration
>    - Adds device-specific IRQ mappings (subset of TPS65224 IRQs)
>    - Adds compatible strings "ti,tps652g1" to I2C and SPI device tables
>    - Properly handles the stripped-down nature of TPS652G1 (no RTC, ADC,
>      watchdog, ESM)
>
> 3. **Low Risk**: The changes follow the existing driver pattern and only
>    add conditional paths for the new device:
>   ```c
>   if (tps->chip_id =3D=3D TPS65224 || tps->chip_id =3D=3D TPS652G1)
>   ```
>   This ensures existing device support remains unaffected.
>
> 4. **User Benefit**: Without this patch, users with TPS652G1 hardware
>    cannot use their devices on stable kernels. This directly impacts
>    hardware functionality for affected users.
>
> 5. **Proper Implementation**: The patch correctly handles the TPS652G1
>    as a feature-reduced variant of TPS65224, sharing the same register
>    layout and CRC handling while properly excluding unsupported
>    features.
>
> The patch is relatively small, follows established driver patterns, and
> enables essential hardware support without introducing architectural
> changes or new features beyond device enablement.

While this is correct, the MFD patch on it's own is rather useless,
as the individual driver implementations are missing. See
https://lore.kernel.org/all/20250703113153.2447110-1-mwalle@kernel.org/

I don't care too much, I just want to point out, that just having
this patch might be misleading regarding the support of this PMIC.

-michael

--b0bb75deace1dbc2ddd5574427033e423afc4aadde330d8d0257abae0a9d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iKgEABMJADAWIQTIVZIcOo5wfU/AngkSJzzuPgIf+AUCaKLJWxIcbXdhbGxlQGtl
cm5lbC5vcmcACgkQEic87j4CH/hUVQF+KHDTV7ZjbafCPzJFfLz7eU+lFnOpjOye
22pVQzCxqiSjaU0s69DCCRq22OVpF0LkAYDahGM/kSaSBhm/GSiMQtNhwohhQCuu
M9OuRbwrt+EPOFB8ksLrC0G2kvqL9sZcdxY=
=mxBt
-----END PGP SIGNATURE-----

--b0bb75deace1dbc2ddd5574427033e423afc4aadde330d8d0257abae0a9d--
