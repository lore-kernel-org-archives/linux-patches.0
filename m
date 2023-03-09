Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A522F50
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 23:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAACC433EF;
	Thu,  9 Mar 2023 23:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678404677;
	bh=XMIAuFTCpQukpN84ROT6/ts6CvHL1L9jkDiOtPUHxqg=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=aB6+rxR9vvN8i7vqNPjuqyqyRpDmMYWpaEQYkCUUzn7hgI6slmXltotVW87pLPAaS
	 R/siBnKOm1dxwMeFEFYA2zjQr7hbbk459jZQXxHlfQC2PHCDUXLTaNddLcrCnp2xQM
	 wuYuSgHnkwV722udtWhO9NskDC9Udui9+fyZUL7fef8gyD/VfGRzdPfPk+AF9RKbhu
	 WCXHmnwcac3WdDU86szAdMTdoAMbl7gxNlwbxGTN/rgYvZvf4/tGwKytI/AzaKEbP3
	 1pzYdg/vm/uEzBFAiHB0sjh10QSveGGgsKX5HW/PqI8ZRrXazA3giR6Fzi4QqwsILS
	 4T1vyZoV0T28Q==
Message-ID: <dea61f59ea83c772b693b18db43c3eb7.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230303143528.2dovipmqlms74vp2@houat>
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-4-sboyd@kernel.org> <CABVgOSmR0_u8Tw0E8C1mRFxSiGKwdKG5ka_+X_36Hj4VNLdg2g@mail.gmail.com> <20230303143528.2dovipmqlms74vp2@houat>
Subject: Re: [PATCH 3/8] kunit: Add test managed platform_device/driver APIs
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: David Gow <davidgow@google.com>, Maxime Ripard <maxime@cerno.tech>
Date: Thu, 09 Mar 2023 15:31:15 -0800
User-Agent: alot/0.10

Quoting Maxime Ripard (2023-03-03 06:35:28)
> On Fri, Mar 03, 2023 at 03:15:31PM +0800, David Gow wrote:
> >=20
> > DRM has a similar thing already (albeit with a root_device, which is
> > more common with KUnit tests generally):
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/include/drm/drm_kunit_helpers.h
> >=20
> > But that's reasonably drm-specific, so it makes sense that it lives
> > with DRM stuff. platform_device is a bit more generic.
>=20
> I'd be very happy to get something from the core to address the same
> thing.
>=20
> I think the main thing we needed that isn't covered by this patch is we
> wanted the device to be bound to its driver, so with probe being called
> before calling the test (see 57a84a97bbda).
>=20

Can you clarify? This patch makes a poor attempt at waiting for the
platform driver to bind, but in reality it may not be bound by the time
the driver register function returns.
