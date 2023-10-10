Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793B81367
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 03:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBaoLD91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40113C433C8;
	Tue, 10 Oct 2023 03:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696908199;
	bh=svOySVpdTq4zrtHC4TrHg5u+BeEE9tyEDYgZhlD3pCQ=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=vBaoLD918wWXo8ktHuxu9HLV8XPLWeZoEb4PkV7WLRdsS8dJdPwo2Yl3gu3fDN+Kt
	 KFZuZDqxDW0gri1BStfkikMQssLJYUnxfulQBDJ61h0kzHUlJuM20FLNDhuJpvZaeA
	 ed/gsrgXSImJsZpf41m/rvaL5Sl7zUqwIbpAoRipQsu6UcMu5NnPNexkCE/YVL0S0c
	 rsXf3sabsU3K+wfI/209LMAQhY5FKQV7GW8MSWYo68QgcFV8ylxr9L5cbxJB5075Zj
	 O5huJv1ZaYxt7e0uAx0XfiCVXYRjjWHHBNsJzBCs7WH8m8VayReBpoThm6YWeg2kWE
	 YtTO63l0iHtqw==
Message-ID: <7be6d0f2101b82f423818a2bb82eee90.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230912175534.2427862-3-sboyd@kernel.org>
References: <20230912175534.2427862-1-sboyd@kernel.org> <20230912175534.2427862-3-sboyd@kernel.org>
Subject: Re: [PATCH 2/2] clk: Parameterize clk_leaf_mux_set_rate_parent
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Guenter Roeck <linux@roeck-us.net>, Maxime Ripard <mripard@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Mon, 09 Oct 2023 20:23:16 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-09-12 10:55:31)
> Transform the existing clk_leaf_mux_set_rate_parent test into a
> parameterized test that calls the various determine rate APIs that exist
> for clk providers. This ensures that whatever determine rate API is used
> by a clk provider will return the correct parent in the best_parent_hw
> pointer of the clk_rate_request because clk_rate_requests are forwarded
> properly.
>=20
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Maxime Ripard <mripard@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
