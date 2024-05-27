Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9EF17E90E;
	Mon, 27 May 2024 19:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837255; cv=none; b=ZMuZ3SW6FUol/w90oeS+rDp8tnx90JP7FdA+Nvf3ab+lrvhNYUad1OtW5rzaknAoUzm24pXtrJpNozpyvaGmea/oF2PNiurrrYbn38QyHdScoQKy8wLZaPDfdMBQI2utYsvKQ0A89ymiF/aebYNvj+3INjbjcGkjuQKfaxI3STs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837255; c=relaxed/simple;
	bh=E3CyKUVotkzY4ndun1244uPDf7VV2hlRK2j50E1dmfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gW/fVHYGmMfXctnJfniltaR3rVu0IHNVZynEzNUXk6DJ+rzOEgKYEQn9cPSay1rf+90zEdJEKKa4jO8Er0ycOEGDkZMd/p6Xkx50oObhNXbnrVNwDbesQLAGKF7WFYF7dUk0/KV/yGEi24uXZ9ouzMlAg5sz2rd2X6Z+Le8URK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efMcjejS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efMcjejS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C4BC2BBFC;
	Mon, 27 May 2024 19:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837255;
	bh=E3CyKUVotkzY4ndun1244uPDf7VV2hlRK2j50E1dmfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efMcjejSoIyKR1PyVZ1N2U/OOW8m+WfdxfsR8eK01cF9Dshmx9uFtgUWxOZseEgTq
	 iy0q1/50koc5QTvvYQm2f5DLJ5b5uieyMXfh4uNW0zS/bmoyO6rbVh8SV8yZLxNFxM
	 QRVzRq9TBE6uqn5GaCstRhhAE735GKpYwMDFJk/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 371/427] clk: renesas: r8a779a0: Fix CANFD parent clock
Date: Mon, 27 May 2024 20:56:58 +0200
Message-ID: <20240527185634.207264474@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 4c2872f45387f..ff3f85e906fe1 100644
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



