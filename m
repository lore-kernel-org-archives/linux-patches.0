Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DA3EBE
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 00:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB852C433D2;
	Tue, 18 Apr 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681777820;
	bh=ZmFwJ7m5ZLxH+t58ZzfiJLOLdybzzWisxpx1qHDzVPU=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=qksOjS7UehQHQU48wzAd/nTyFi31TTsNEgEIWIKQGpsxL2pE8hf/dsvnj0/Jcqjp8
	 Vfineigagj/H2n+uleVsWnN8FPBxtpzGdFGz8Em4SnTJBpcV9yIcBDUNwuemcDSCYd
	 2WykdHQLpI2Mg02n8TPm5sysYZ0e9bGHJyUSb25fdoBg9DmXPRIeQrps4ULCRzTydQ
	 lceiWuzffBWt2lyYjxWIgIvUGL5Odt7WXCUv/soBT/6/CEmA5xGZzpXp6qRWC+WlIE
	 bx0RXZoxQeRvjv2Pq7g6bm1tn5cosbH1GUgPzNqjUrUvoDGhQD+93ld7ltPUX9e9VO
	 Yfln7MbSen6Uw==
Message-ID: <866ffea2459ba57328afa800a30421b4.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2aa668e3-d065-7376-5d41-ef855afa8518@starfivetech.com>
References: <20230413205528.4044216-1-sboyd@kernel.org> <b41d8cf4-70aa-3b64-5254-46d92a188f63@starfivetech.com> <2aa668e3-d065-7376-5d41-ef855afa8518@starfivetech.com>
Subject: Re: [PATCH] clk: starfive: Avoid casting iomem pointers
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Tommaso Merciai <tomm.merciai@gmail.com>, Emil Renner Berthing <emil.renner.berthing@canonical.com>, Conor Dooley <conor.dooley@microchip.com>
To: Hal Feng <hal.feng@starfivetech.com>, Michael Turquette <mturquette@baylibre.com>, Xingyu Wu <xingyu.wu@starfivetech.com>
Date: Mon, 17 Apr 2023 17:30:18 -0700
User-Agent: alot/0.10

Quoting Hal Feng (2023-04-14 16:31:45)
>=20
> Thanks for your fix to my previous patches, and I have tested this patch
> on VisionFive 2 board. As Xingyu said above, I think dev_set_drvdata()
> should also be dropped in clk-starfive-jh7110-sys.c and
> clk-starfive-jh7110-aon.c.
>=20

Sure. I see you sent the patch. Thanks.
