Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951E32E1C55
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 07:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756886370; cv=none; b=jcsghSFn/eO+hgFAfYsPM2hpzWdYJVftbXM/WWoYl3bgZaoBj9yGRBgSN/ieLyWCXLT5PRgTS81v809+LlSP6t1WGUZbrp4TyiY3BOD1SzgYUMoVO7h/gmI30zs9kMHnBcFgPNsIC6DAuerqZpRf8lSktsFgW6fw9glYh+JqlkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756886370; c=relaxed/simple;
	bh=bWcrYa09wM8afU1is5QwkSNfFYCNQIT3VyOg4+tWgdw=;
	h=Message-ID:Date:From:To:Subject:In-Reply-To:References:Cc; b=XnLY1cwXdQt+Zv1pmwGSrsswXl/k/KLLmjCw8HkZs/JyjonE6WrTu08AzXmOAQLdr7tPUdJnTKgDYMsOXu/Wif9M47q3r1mQkwJWk61EgICdTVcBJ9jKgV+7Rit3vSZOiXo07AIncuXorfeUWYyQcjqwTR1lBzEL/YTI40MF8Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWU+9y6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWU+9y6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9D8C4CEF0;
	Wed,  3 Sep 2025 07:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756886370;
	bh=bWcrYa09wM8afU1is5QwkSNfFYCNQIT3VyOg4+tWgdw=;
	h=Date:From:To:Subject:In-Reply-To:References:Cc:From;
	b=bWU+9y6r/4lC5Fdio3/WKSQOcd0MXFT+s9wx8BhZIWggVhBpzfs134JZoYNsgV4PW
	 JAkEed7PrSjqxFE4GarQ4Ol4349O0qE5mYpC/z0j3lp5MJ2byJyURYE9FyErSu3vUo
	 tNYU+TaMH0TAbCCOkBM+mgmFntpFXld1+GTYcfwGU0lpRpoPXSw+yauuklHh2ZVkbj
	 hxysp/mqjiI7S2YJDoMRcMHI7YKRFCB5dYsCyjmdOK+7WsVARSyZyCm+XJ6s+2PssP
	 BPZwnwZ8/YfKR8HGZM6GMlqwg7LBn9QnJSzZpCZ1M+97R/3EcxV3/Qhhi9lP0Zhq8b
	 a/RJGiKeWG6/A==
Message-ID: <6f5d003df567ca8555c9b6e2a174ac6a@kernel.org>
Date: Wed, 03 Sep 2025 07:59:26 +0000
From: "Maxime Ripard" <mripard@kernel.org>
To: "Nathan Chancellor" <nathan@kernel.org>
Subject: Re: [PATCH] drm/tidss: dispc: Explicitly include bitfield.h
In-Reply-To: <20250902-drm-tidss-fix-missing-bitfield-h-v1-1-aaad4a285f98@kernel.org>
References: <20250902-drm-tidss-fix-missing-bitfield-h-v1-1-aaad4a285f98@kernel.org>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev, "Jyri Sarha" <jyri.sarha@iki.fi>, "Maarten
 Lankhorst" <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>, "Thomas
 Zimmermann" <tzimmermann@suse.de>, "Tomi Valkeinen" <tomi.valkeinen@ideasonboard.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

On Tue, 2 Sep 2025 14:15:50 -0700, Nathan Chancellor wrote:
> After a recent series to use FIELD_PREP and FIELD_MODIFY in
> tidss_dispc.c, there are many errors when bitfield.h is not implicitly
> included, such as when building allmodconfig for ARCH=3Dhexagon:
>=20
>   drivers/gpu/drm/tidss/tidss_dispc.c:1116:2: error: call to undeclared f=
unction 'FIELD_MODIFY'; ISO C99 and later do not support implicit function =
declarations [-Wimplicit-function-declaration]
>=20
> [ ... ]

Acked-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime
