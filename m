Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB2E2FA0F9;
	Tue, 12 Aug 2025 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022590; cv=none; b=taSG2CgDHSJix8AlQuqBRbOQReEvJJi0sAR+J9zzsL1tkI32N6dgqAQRWmSkg3GKbqn1jJepVkx0oSh9+OizpaYseu+T0ZlMySdqzICpAMjWnIT+8K6K/68gMQneVBdSxmK65X7x1H/kXdRHTUzXgZsv9VTWl2BqnwGE4MXzniY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022590; c=relaxed/simple;
	bh=YBZr5mkRSyXU25snQXAQDz8MeWJaxVUfLcjtgksYqvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo04qbHCgbbU8ioBNY+ZJ63mPQ9/RtgJMY7nDQDh0YaoP0LKsF91fbOZ53Tb+xKiIdvll7ZELHD44bp/28mRsq4zwxycZ9lhrGTrHBJEyQU0jmSeGx1bXiVHYsTZIIJP0OyHWNdoqINBgqI+pD7+1yzlbBc5i34se4TlruzyWZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJNYzm5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJNYzm5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A28C4CEF1;
	Tue, 12 Aug 2025 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022588;
	bh=YBZr5mkRSyXU25snQXAQDz8MeWJaxVUfLcjtgksYqvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJNYzm5lOZ6Sltdi3jfyJlscBJsgHpGkqJwflx1JU11rxsUDHEA1NN4mvIFsl7NPZ
	 0g798hTngYPHSKlPE6l7vWMu3DSWFXe1BsDtIi1YuheDyv3cvz/nBqvSA7uLBrUfuV
	 E1jEAwTBlr1II5yWMgeph5R1F61F3Il/9o43L8SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/369] clk: sunxi-ng: v3s: Fix de clock definition
Date: Tue, 12 Aug 2025 19:28:16 +0200
Message-ID: <20250812173022.250000642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d24c0d8dfee4..3416e0020799 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
@@ -347,8 +347,7 @@ static SUNXI_CCU_GATE(dram_ohci_clk,	"dram-ohci",	"dram",
 
 static const char * const de_parents[] = { "pll-video", "pll-periph0" };
 static SUNXI_CCU_M_WITH_MUX_GATE(de_clk, "de", de_parents,
-				 0x104, 0, 4, 24, 2, BIT(31),
-				 CLK_SET_RATE_PARENT);
+				 0x104, 0, 4, 24, 3, BIT(31), 0);
 
 static const char * const tcon_parents[] = { "pll-video" };
 static SUNXI_CCU_M_WITH_MUX_GATE(tcon_clk, "tcon", tcon_parents,
-- 
2.39.5



