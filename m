Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C096615AD2
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 20:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5231EC433C7;
	Mon, 11 Sep 2023 20:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694463628;
	bh=t+7z6sKacC4bNsdeAQDIrInU1BgKBgiThKa36hekUHM=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=vIA7WWczePJi65XG6iZtGohn8yGNCzh3/cU2eYLsksjybLNOvWmnArQt3wxDYNQS1
	 SF5roN/gdpcp9fOyl2dovpcqOthXqzPsJE/+iIqLHcmN4XyeHHr8GvWeIwsIKEnrae
	 zDVZtvLR8zSsL1k51qQl34iQpvhUDrtz30Gxb2sMCseAz6scW40t7Eib2PLwdndVhL
	 SOVxXWFzz6KclxMRfHZLDnIPvt3FU26jgjckhXOESfWfNVPF8XBVBD+mLX1JiZTyzD
	 oF8Jqac4h5svNOooBowUX7LEhi0/AAWpnbKZ7YZ4Uqk2/uWNQif/AEmxemdwOZRSlq
	 6XSJyrR/2ArwA==
Message-ID: <a1b8a5bcbddc57cb3c62d3d81fdc4c4a.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230909000703.3478902-1-sboyd@kernel.org>
References: <20230909000703.3478902-1-sboyd@kernel.org>
Subject: Re: [PATCH] clk: asm9620: Remove 'hw' local variable that isn't checked
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, kernel test robot <lkp@intel.com>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Mon, 11 Sep 2023 13:20:26 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-09-08 17:07:02)
> The 'hw' pointer local variable in this function became unused after
> commit f5290d8e4f0c ("clk: asm9260: use parent index to link the
> reference clock"). Remove it to silence an unused but set variable
> warning.
>=20
>  drivers/clk/clk-asm9260.c:258:17: warning: variable 'hw' set but not use=
d [-Wunused-but-set-variable]
>            struct clk_hw *hw, *pll_hw;
>                           ^
>    1 warning generated.
>=20
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Fixes: f5290d8e4f0c ("clk: asm9260: use parent index to link the referenc=
e clock")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202309042014.IWERPl09-lkp@i=
ntel.com/
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
