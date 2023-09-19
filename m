Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2711A2E639
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 11:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD9AC433C7;
	Tue, 19 Sep 2023 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695121306;
	bh=c/PyV2hre80VbWwB9fK5oidLjC6ryxb/+42Jw2t/bFQ=;
	h=Date:From:To:Subject:In-Reply-To:References:Cc:From;
	b=ts37NcED95/E8MxaWIL/Kmj/KYCvkndLduGCPbwSkwEp238wn6v3uuDT11zSnZwZE
	 hkj4dGGnX7TjHVa+brG2BGNi/D18c+gUNAMFJ+2OvEgoyzlOQFt5vHSD5lyr6vdNww
	 eRq6xTdbF1y0xLy9HSO4XjTOwaOw7lIh6JtRCP6kH4hRwO4I+kBHlmmDZwGjM3aWs4
	 EUZ9gBnbJhTDAZ4F2DX/tuY+4FPy5KOinaBrKwICim+7iy5+c7t6s8tK+yuFvOeiw3
	 qChst3MRTSuRvgPMPECJeqbWRcZ3ugx/cKqbgF72QzJwVDdzzsrfR3jf65AAAc7EaM
	 l9p4bXFAAvdBg==
Message-ID: <f780cc47da223a96bdaffe2361388641.mripard@kernel.org>
Date: Tue, 19 Sep 2023 11:01:44 +0000
From: "Maxime Ripard" <mripard@kernel.org>
To: "Stephen Boyd" <sboyd@kernel.org>
Subject: Re: [PATCH 0/2] clk: Fix lockdep warnings in clk_test
In-Reply-To: <20230912175534.2427862-1-sboyd@kernel.org>
References: <20230912175534.2427862-1-sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, "Guenter
 Roeck" <linux@roeck-us.net>, "Maxime Ripard" <mripard@kernel.org>, "Michael
 Turquette" <mturquette@baylibre.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

On Tue, 12 Sep 2023 10:55:29 -0700, Stephen Boyd wrote:
> This is a replacement for the series from Maxime[1]. I didn't want to
> introduce more wrappers, so this series takes the approach of driving
> the test from a clk_op instead. The second patch extends the test to
> look at more determine_rate variants. We can probably extend the test
> further to set or not set the CLK_SET_RATE_PARENT flag as well but I
> 
> [ ... ]

Acked-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime
