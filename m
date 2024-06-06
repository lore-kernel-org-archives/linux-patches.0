Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2E719ADBC;
	Thu,  6 Jun 2024 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683365; cv=none; b=EkJ8ot1ThsXyoXV/lxaFwEn7o22SYuG1+R6kVoZdI42PVhtoxoGmedix/+BQ1nzcmfEBqqohn8os2vg/KyhG7yYb2LDBN9ogz6cWJWcAE21I/Hev75I4oUVlQc1nRGEAAhXCbTfZH5a0nk8+GGZ9Wj0N8p1edpyzBv1Diku1hpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683365; c=relaxed/simple;
	bh=ObAtphp2THCVK7N6h2gYYgiJlhhb2jSdNDJmc5+7eog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uB1UxauNlrWlUPV7cJlq8CNQZz303pcyLPjNTxT0Vfg0RhTfcoDG+qYuJsmYv3Jg++AF1A/lkt6CRUKAy+eJIrrM8u05DUZ1hRcpUTnX4Cui2bt8OK//VO06iGBEmmcIDyV7/XZ2XzBEyx8k+ST44ldoTFnHBER2W9zqSxPUbQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaZnFS85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaZnFS85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE3BC32781;
	Thu,  6 Jun 2024 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683364;
	bh=ObAtphp2THCVK7N6h2gYYgiJlhhb2jSdNDJmc5+7eog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaZnFS858LMLo/WlpEr1uHdA/7QDLgkFY50KEiAfA8DbFI/czP+qtdg1sVQTMSpO+
	 QtbBgexdwJNDKUVQCH0pbWbKxWATo/kccKIP1tcX/nc3fqGsPoCsT4pmwkYFK2EF/l
	 9XN6A+wdR/6rBZ123OMG10Na3w0zGWINZfIPZsGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 249/473] clk: renesas: r8a779a0: Fix CANFD parent clock
Date: Thu,  6 Jun 2024 16:02:58 +0200
Message-ID: <20240606131708.222327348@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3b23118bdbd898dc2f4de8f549d598d492c42ba8 ]

According to Figure 52A.1 ("RS-CANFD Module Block Diagram (in classical
CAN mode)") in the R-Car V3U Series User’s Manual Rev. 0.5, the parent
clock for the CANFD peripheral module clock is the S3D2 clock.

Fixes: 9b621b6adff53346 ("clk: renesas: r8a779a0: Add CANFD module clock")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/aef9300f44c9141b1465343f91c5cc7303249b6e.1713279523.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r8a779a0-cpg-mssr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/r8a779a0-cpg-mssr.c b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
index e02542ca24a06..5c908c8c5180d 100644
--- a/drivers/clk/renesas/r8a779a0-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a779a0-cpg-mssr.c
@@ -139,7 +139,7 @@ static const struct mssr_mod_clk r8a779a0_mod_clks[] __initconst = {
 	DEF_MOD("avb3",		214,	R8A779A0_CLK_S3D2),
 	DEF_MOD("avb4",		215,	R8A779A0_CLK_S3D2),
 	DEF_MOD("avb5",		216,	R8A779A0_CLK_S3D2),
-	DEF_MOD("canfd0",	328,	R8A779A0_CLK_CANFD),
+	DEF_MOD("canfd0",	328,	R8A779A0_CLK_S3D2),
 	DEF_MOD("csi40",	331,	R8A779A0_CLK_CSI0),
 	DEF_MOD("csi41",	400,	R8A779A0_CLK_CSI0),
 	DEF_MOD("csi42",	401,	R8A779A0_CLK_CSI0),
-- 
2.43.0



