Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE551F4C90;
	Tue, 26 Aug 2025 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217404; cv=none; b=BfHmoxhBm7sgmp58M1s1mfjttAckwsdHpHHfbBPLeBHYJ9VN2nx/lIVFzjxKart1H8Nk3QOqaluusCM/GVQM92VixiKp4YAFe1MdDIYb+8ZfZI7kWRy4lGJ8waqdHoGvZnqNtL28Aj5X93mDSojQupdxxXfPNpufkp8JI9ZfPiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217404; c=relaxed/simple;
	bh=MWU10ry0ceSSsieOAMqXI5qV5rGvZfWUv47aX/hRY4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTzn+zkLXKTb5eG5FsG4NCOMNGocb08hTn+9xeNJJKE0BvLekqjEhHiqBOW5/PSV+c6cg7VFc/TsXL4EI1W6K315p4fpLhw1wY2DwCQtaXIIUQBUSvXXR3gcQpJeMC56LGmW1Cr/RL7BqrZ9v4+IiJV72Qb+EAeoNM75rCEw46o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYDTQrsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYDTQrsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E83AC4CEF1;
	Tue, 26 Aug 2025 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217403;
	bh=MWU10ry0ceSSsieOAMqXI5qV5rGvZfWUv47aX/hRY4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYDTQrsH1pWyFMCoc3xB5AGd03OcrWKzR5Soh67qJYVkfDbFnQmJfOTrTcpmAxHKb
	 UrYS2aCVn3pSCLNUIXqQ1hZ5YZNL3EUndAT3qj4gOChrKpK+pC1e7Yc2dm5ir9jKNj
	 CtP5xtxQtxOjEWEK2B9xSPpxTv125SxODFR9sKrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/523] clk: sunxi-ng: v3s: Fix de clock definition
Date: Tue, 26 Aug 2025 13:05:39 +0200
Message-ID: <20250826110927.689094858@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Kocialkowski <paulk@sys-base.io>

[ Upstream commit e8ab346f9907a1a3aa2f0e5decf849925c06ae2e ]

The de clock is marked with CLK_SET_RATE_PARENT, which is really not
necessary (as confirmed from experimentation) and significantly
restricts flexibility for other clocks using the same parent.

In addition the source selection (parent) field is marked as using
2 bits, when it the documentation reports that it uses 3.

Fix both issues in the de clock definition.

Fixes: d0f11d14b0bc ("clk: sunxi-ng: add support for V3s CCU")
Signed-off-by: Paul Kocialkowski <paulk@sys-base.io>
Link: https://patch.msgid.link/20250704154008.3463257-1-paulk@sys-base.io
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
index 0e36ca3bf3d5..4fddb489cdce 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
@@ -334,8 +334,7 @@ static SUNXI_CCU_GATE(dram_ohci_clk,	"dram-ohci",	"dram",
 
 static const char * const de_parents[] = { "pll-video", "pll-periph0" };
 static SUNXI_CCU_M_WITH_MUX_GATE(de_clk, "de", de_parents,
-				 0x104, 0, 4, 24, 2, BIT(31),
-				 CLK_SET_RATE_PARENT);
+				 0x104, 0, 4, 24, 3, BIT(31), 0);
 
 static const char * const tcon_parents[] = { "pll-video" };
 static SUNXI_CCU_M_WITH_MUX_GATE(tcon_clk, "tcon", tcon_parents,
-- 
2.39.5



