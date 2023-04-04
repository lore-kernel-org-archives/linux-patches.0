Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86C0C964
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 20:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D29C433D2;
	Tue,  4 Apr 2023 20:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680639040;
	bh=8NUfYdl83Wf1rlp9nA8q3mD3Qtz+QSrDcBe+dW5wvpY=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=MUrbmte92NLuYtccpovD1o3doilGQ8+AjDut5SaxsFkfdTL7ngQ+bGs0AOFalhfSZ
	 wun4PqDNjntYkb3SkAaN56SjXRePdAONPuVeXpsCzb7u7jHRBkhxpq15uYznQoyuvF
	 2J3Vjfv2mKAfZ0Ln/UjxaHG1qhFOeQ2GC7OtbdH04EWHw5vBbKyPmikDqXwISfPXhy
	 ewEWk3R+6Y/yo0x8g9QAbutVp8AzHwrAXmfWKi4zwl76NKxRCZqSGjsDGhI+DwJoyN
	 xIPLu40GYq7RFfbEL05Ui0eYa00iHFuiuRZgkGuLZQP+gUWOWl3iAPykoU2KH+7VEV
	 DWmqCj4LdLBKA==
Message-ID: <e69cb2aba5e932491981eb6ccd320766.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230404045636.1114141-1-sboyd@kernel.org>
References: <20230404045636.1114141-1-sboyd@kernel.org>
Subject: Re: [PATCH v2] clk: mediatek: Use right match table, include mod_devicetable
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Garmin . Chang <Garmin.Chang@mediatek.com>, Chen-Yu Tsai <wenst@chromium.org>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, kernel test robot <lkp@intel.com>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Tue, 04 Apr 2023 13:10:38 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-04-03 21:56:36)
> diff --git a/drivers/clk/mediatek/clk-mt8188-wpe.c b/drivers/clk/mediatek=
/clk-mt8188-wpe.c
> index 5abded13cece..c372ff703f9c 100644
> --- a/drivers/clk/mediatek/clk-mt8188-wpe.c
> +++ b/drivers/clk/mediatek/clk-mt8188-wpe.c
> @@ -88,7 +88,7 @@ static const struct of_device_id of_match_clk_mt8188_wp=
e[] =3D {
>         { .compatible =3D "mediatek,mt8188-wpesys-vpp0", .data =3D &wpe_v=
pp0_desc },
>         { /* sentinel */ }
>  };
> -MODULE_DEVICE_TABLE(platform, clk_mt8188_vpp1_id_table);
> +MODULE_DEVICE_TABLE(platform, of_match_clk_mt8188_wpe);

This one is still wrong. v3 coming up.
