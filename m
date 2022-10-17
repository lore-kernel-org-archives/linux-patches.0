Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457DC7F
	for <patches@lists.linux.dev>; Mon, 17 Oct 2022 22:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E6CC433D6;
	Mon, 17 Oct 2022 22:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666045790;
	bh=o9CVNWd49B0uPG9CroMhov7CzALKXLQZhU8hnC2X5Gk=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=CrW/x9BxfBywHF1VJRZmtjIKJ3ONVWBBqWy5KztLFr4mLYH22246ObCWm5D107irc
	 eIWhjh/X+/3u2lNmyKiL1NeCv9McZI6OxkZdofWnapdDBWxw70GG2J1zUNqwQSKpOf
	 qwfPkxnQb6h5cbOuPh58hj59cQPr/zZg9k5+KKnC5ea9nXlKzyVc5xpmQLBb51kywV
	 6gq48ZKDuoKlMElfNKi1+hT1U7NRG+FSqxKo48Tv5LBVDj1o7bla2DCT1OAQ5+Uf6v
	 6SWqaESiYC5a0XBpLql3mUIWB3jXtV9jvEROTd0aO8qbrKPsMb2OSpv14XVpKdn7cV
	 1dkPSebigJRaw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221003203103.2705007-1-sboyd@kernel.org>
References: <20221003203103.2705007-1-sboyd@kernel.org>
Subject: Re: [PATCH] clk: xilinx: Drop duplicate depends on COMMON_CLK
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Mon, 17 Oct 2022 15:29:49 -0700
User-Agent: alot/0.10
Message-Id: <20221017222950.D4E6CC433D6@smtp.kernel.org>

Quoting Stephen Boyd (2022-10-03 13:31:03)
> This entire Kconfig file is only included within the if COMMON_CLK
> section of the drivers/clk/Kconfig file. That makes the depends on
> COMMON_CLK here redundant. Remove it.
>=20
> Cc: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
