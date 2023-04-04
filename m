Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AEDC95B
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 20:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D6DC4339B;
	Tue,  4 Apr 2023 20:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680641286;
	bh=xLG63kWnTU/8AzxYXtVE/BIEPcX9jGZ1ToVVaQos3GE=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=D82xyLD7HoLDMg9ck0fX4TGx0ez+pjFF+Gzlbz0pLG5X4QPcyw35Kh52DNC9C2vwk
	 yh6XgxmZnJy2EqyyYTjtibBkRjnWEXrgenvlmPKJr0fOTAqx1GZf2ZujjY16IxBVam
	 J8jBWWXh3TJYbNxsVeRgBYlhzgIxA+GxDG6ToZjqEqCwtzgh+LakIaPnvlV5D+OBgq
	 VD1brZkehCFpuGoZkgsiFeDsmcMgRkNf/LFHj545/6jlFP/BylnSmJSPcIl1WMav8h
	 lMvwPxKWBwFkvJzL0TRoVPNdhTlpJEAjwHoNiMYN0lOM+l4WdxWwsM4rqZefKK0RfJ
	 E/6VLXMrUKiKw==
Message-ID: <d415decc59aac39be25cd7916ae650cb.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230404204553.1256263-1-sboyd@kernel.org>
References: <20230404204553.1256263-1-sboyd@kernel.org>
Subject: Re: [PATCH v3] clk: mediatek: Use right match table, include mod_devicetable
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Garmin . Chang <Garmin.Chang@mediatek.com>, Chen-Yu Tsai <wenst@chromium.org>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, kernel test robot <lkp@intel.com>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Tue, 04 Apr 2023 13:48:04 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-04-04 13:45:53)
> This is copy/pasta that breaks modular builds. Fix the match table to
> use the right pointer, or the right device table type. And while we're
> including the header, fix the order to be linux, dt-bindings, and
> finally local.
>=20
> Cc: Garmin.Chang <Garmin.Chang@mediatek.com>
> Cc: Chen-Yu Tsai <wenst@chromium.org>
> Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Fixes: f42b9e9a43e3 ("clk: mediatek: Add MT8188 wpesys clock support")
> Fixes: 0d2f2cefba64 ("clk: mediatek: Add MT8188 adsp clock support")
> Fixes: e4aaa60eae16 ("clk: mediatek: Add MT8188 vdosys0 clock support")
> Fixes: cfa4609f9bbe ("clk: mediatek: Add MT8188 vdosys1 clock support")
> Fixes: bb87c1109ce2 ("clk: mediatek: Add MT8188 vencsys clock support")
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304011039.UBDX1UOT-lkp@int=
el.com/
> Link: https://lore.kernel.org/oe-kbuild-all/202304020649.QO2HlpD5-lkp@int=
el.com/
> Link: https://lore.kernel.org/oe-kbuild-all/202304021055.WDhQPcoS-lkp@int=
el.com/
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
