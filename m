Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2677B11CA6
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 19:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F90C433C8;
	Wed, 14 Jun 2023 19:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686771814;
	bh=Kt6SJawEmJWtX3OTbjlzR1/a2xexuFr4PgAMHfuqpqc=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=WHhPJGi4JCpDvJJVFMj2VPcwyd1dt4StdWOi6o4PJtoNbC2BpPlPK2y3X158vC85D
	 i23nKtAzDelBVt/aLueNY1b/3+Ay2ilRlKZD2dCW92xnFftZnatfROwuM9V+g4TQXX
	 xJqubh6K+F6j89Y9UuAnl2CBKPsYLnMo2IOk9ly/QOw6Hfy57XfiaOekY90XvhcF1z
	 ZJ1hNMNMn9atmTQrdC14xUDP7FxW/UO6cOq3hU9fa5TygZ9Z78GFCV+qnsXFOINW6E
	 KhD7/BWp2Ew7u1TuqNQ5x7HKgxKuB5VIY6Fzryy9+Z3lEtJquqn4vqPEzpS2VmoUyH
	 su/okyOh3be5w==
Message-ID: <cca711ac7af8208949df09b811a13c81.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230613195443.1555132-1-sboyd@kernel.org>
References: <20230613195443.1555132-1-sboyd@kernel.org>
Subject: Re: [PATCH] clk: sprd: composite: Simplify determine_rate implementation
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, Maxime Ripard <maxime@cerno.tech>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Wed, 14 Jun 2023 12:43:32 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-06-13 12:54:42)
> The sprd_div_helper_round_rate() function calls divider_round_rate()
> which calls divider_round_rate_parent() which calls
> divider_determine_rate(). This call chain converts back and forth from
> the rate request structure to make a determine_rate clk_op fit with a
> round_rate clk_op. Simplify the code here by directly calling
> divider_determine_rate() instead.
>=20
> This fixes a smatch warning where an unsigned long is compared to less
> than zero, which is impossible. This makes sprd_div_helper_round_rate()
> unnecessary as well so simply remove it and fold it into the only caller
> left.
>=20
> Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Closes: https://lore.kernel.org/r/45fdc54e-7ab6-edd6-d55a-473485608473@or=
acle.com
> Cc: Maxime Ripard <maxime@cerno.tech>
> Fixes: 302d2f836d78 ("clk: sprd: composite: Switch to determine_rate")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
