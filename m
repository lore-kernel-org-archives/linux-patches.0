Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75231A45
	for <patches@lists.linux.dev>; Tue,  2 May 2023 09:17:01 +0000 (UTC)
Received: from ip4d1634d3.dynamic.kabel-deutschland.de ([77.22.52.211] helo=phil.lan)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1ptm82-0006ax-H0; Tue, 02 May 2023 11:16:58 +0200
From: Heiko Stuebner <heiko@sntech.de>
To: Randy Dunlap <rdunlap@infradead.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Heiko Stuebner <heiko@sntech.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	patches@lists.linux.dev,
	linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] soc/rockchip: dtpm: use C99 array init syntax
Date: Tue,  2 May 2023 11:16:57 +0200
Message-Id: <168301900415.771484.18287072014273670563.b4-ty@sntech.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230501024950.31518-1-rdunlap@infradead.org>
References: <20230501024950.31518-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 30 Apr 2023 19:49:50 -0700, Randy Dunlap wrote:
> Eliminate sparse warnings in soc/rockchip/dtpm.c:
> 
> drivers/soc/rockchip/dtpm.c:15:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:17:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:20:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:23:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:26:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:29:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:32:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:35:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:38:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:41:12: sparse: warning: obsolete array initializer, use C99 syntax
> 
> [...]

Applied, thanks!

[1/1] soc/rockchip: dtpm: use C99 array init syntax
      commit: 7c8bfcf1fae4203142ac201d6ee450ac93b86269

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>
