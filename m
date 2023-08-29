Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC0F18018
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 22:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10910C433C7;
	Tue, 29 Aug 2023 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693348185;
	bh=bu5nPZH/twQudeqjd6owfMX/QCBaqEXXy9/d+LqSoP4=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=Kq+GSPLzKR5nrtq2o1GZba6IYlQxolbfkwBJZNQPaZkww87rC7eQZx4KJQF7rVlWq
	 qs0LH6+UOsWk4xLX0O6/PkHfDnUdliCCx8O3UP+PE/6lQruS24xqeZPcYJQ+IFwGia
	 CFirLpO3HsH6qFsB57cYIWwxTgEve/3dIZpEhI55XR8qja3YDecaQ90aT6qiMe9cW9
	 DZGWzpRwE/Fat5p8QdlH4zklplHLYgfwzBcbTntB6JtRGpMXrJzEcJQQ8KP+IowK+X
	 zTLxEyAPQqtn/n+PyuXGzN49pd4l6xcvS0A2Z9dgradWTNBuSttd1dvi5EVGdI6dBx
	 3OFxw/DviaAmw==
Message-ID: <32d3fe2091017c168c082f2b02970768.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230829-fix-sm_gpucc_8550-deps-v1-1-d751f6cd35b2@kernel.org>
References: <20230829-fix-sm_gpucc_8550-deps-v1-1-d751f6cd35b2@kernel.org>
Subject: Re: [PATCH] clk: qcom: Fix SM_GPUCC_8450 dependencies
From: Stephen Boyd <sboyd@kernel.org>
Cc: mturquette@baylibre.com, linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>, agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org
Date: Tue, 29 Aug 2023 15:29:42 -0700
User-Agent: alot/0.10

Quoting Nathan Chancellor (2023-08-29 07:08:47)
> CONFIG_SM_GCC_8450 depends on ARM64 but it is selected by
> CONFIG_SM_GPUCC_8450, which can be selected on ARM, resulting in a
> Kconfig warning.
>=20
> WARNING: unmet direct dependencies detected for SM_GCC_8450
>   Depends on [n]: COMMON_CLK [=3Dy] && COMMON_CLK_QCOM [=3Dy] && (ARM64 |=
| COMPILE_TEST [=3Dn])
>   Selected by [y]:
>   - SM_GPUCC_8450 [=3Dy] && COMMON_CLK [=3Dy] && COMMON_CLK_QCOM [=3Dy]
>=20
> Add the same dependencies to CONFIG_SM_GPUCC_8450 to resolve the
> warning.
>=20
> Fixes: 728692d49edc ("clk: qcom: Add support for SM8450 GPUCC")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Applied to clk-next
