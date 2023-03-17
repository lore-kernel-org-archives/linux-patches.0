Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A7B79CC
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 19:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9419C433D2;
	Fri, 17 Mar 2023 19:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679080427;
	bh=kJ5KDDh2GLSsp9XhhD0hmVpezrJHgDMsml3WxRv/lhs=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=UjSlIS17umcmgDBUU3qnBIB1/Dr19nBLfB4H8rvE9ANxKHlWp3uBJZ1Ixmj5b8grd
	 ulJKA29Q/y6yHG4WG0/0Y9SVgX3y5lvbU/hrDLO7VhL1HJcwUFrHcO839IyBw/95r3
	 0I7Up7qJhHi3LsmhKGUhObKSvQM7HwBGMtxjcgFvEh6iYfhd1qgcQVY9Vh59aRu9mh
	 HbnxWSaiuTK/V9nQo0P7YXUs3+2kBM/VilZL31A5pHkImwswAtzqcCKW0upBu0uOIG
	 ilOXW6JF2Nj0cqu8em7UIEVef0L0qulDWDORPvdBgXD/zM1DgT+PpWGwwnYYp2OQm6
	 Lo0Aqva+x+/0A==
Message-ID: <3ed5634cd610fad7e3b46648e7e63260.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230316231118.2579242-1-sboyd@kernel.org>
References: <20230316231118.2579242-1-sboyd@kernel.org>
Subject: Re: [PATCH] clk: mediatek: Ensure fhctl code is available for COMMON_CLK_MT6795
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chen-Yu Tsai <wenst@chromium.org>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Fri, 17 Mar 2023 12:13:45 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-03-16 16:11:18)
> Without this select we get linker errors when linking
> clk-mt6795-apmixedsys
>=20
> arm-linux-gnueabi-ld: drivers/clk/mediatek/clk-mt6795-apmixedsys.o: in fu=
nction `clk_mt6795_apmixed_remove':
> clk-mt6795-apmixedsys.c:(.text+0x34): undefined reference to `mtk_clk_unr=
egister_pllfhs'
> arm-linux-gnueabi-ld: drivers/clk/mediatek/clk-mt6795-apmixedsys.o: in fu=
nction `clk_mt6795_apmixed_probe':
> clk-mt6795-apmixedsys.c:(.text+0x98): undefined reference to `fhctl_parse=
_dt'
> arm-linux-gnueabi-ld: clk-mt6795-apmixedsys.c:(.text+0xb8): undefined ref=
erence to `mtk_clk_register_pllfhs'
> arm-linux-gnueabi-ld: clk-mt6795-apmixedsys.c:(.text+0x1c4): undefined re=
ference to `mtk_clk_unregister_pllfhs'
>=20
> Fixes: f222a1baec5f ("clk: mediatek: mt6795: Add support for frequency ho=
pping through FHCTL")
> Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Cc: Chen-Yu Tsai <wenst@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
