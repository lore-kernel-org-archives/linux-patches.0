Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A211D7999;
	Mon,  6 Jan 2025 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178075; cv=none; b=BF7kQgRcXQ8/zqdPrryPpAqu9ICirs0fGYpQRu4HXHhlBVsZD2/rqGVUxQS13Slw1TOpGQ4BnaOqW2GXRD05GuJGcUXarJ0MZIFWEcPooGSxaVu2l9TkBzaHLPn7qxvkHY7GhR16SYS/CtGtEwadkPuhVcy9JxjA4VndhSQT4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178075; c=relaxed/simple;
	bh=vCNj1gaNSnTNFX/BJfMU1Ovz4rICB4yjNCGMej8bvt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4HGjQbgvdehllAKAgzghyTSs2Ga/GdL0umpohAXNfCOkmlxPFszKM0dStVccIAFzp82QRhCZ9kszuulfHMsjiWDHr5GKgpAl5ii5cZxVQbVzliyK2oK7pDv9LalfwcBmPAV+FojI+qSE51ktp4CrEBAqAILO1nKBd1KN4Q6tGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCI02jYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCI02jYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D23C4CED2;
	Mon,  6 Jan 2025 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178075;
	bh=vCNj1gaNSnTNFX/BJfMU1Ovz4rICB4yjNCGMej8bvt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCI02jYRHnTKTozOS07100uh7r0T0quSI6sDv2zIvccpGn2R/ZgFADnl44ZgqXiE6
	 sQR/X68lcVnqf2BX5JfRpE7JNzzrdEHMw9GPii8k4CNvhMiGN0tN7rA/o89k53Rm66
	 j+GrSAUQ89zeX1G/M5ci9p+KpQOM9BWkQr+4PUWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaus Voss <nv@vosn.de>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 122/156] clk: clk-imx8mp-audiomix: fix function signature
Date: Mon,  6 Jan 2025 16:16:48 +0100
Message-ID: <20250106151146.324490412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Nikolaus Voss <nv@vosn.de>

commit c384481006476ac65478fa3584c7245782e52f34 upstream.

clk_imx8mp_audiomix_reset_controller_register() in the
"if !CONFIG_RESET_CONTROLLER" branch had the first
argument missing. It is an empty function for this branch
so it wasn't immediately apparent.

Fixes: 6f0e817175c5 ("clk: imx: clk-audiomix: Add reset controller")
Cc: <stable@vger.kernel.org> # 6.12.x
Signed-off-by: Nikolaus Voss <nv@vosn.de>
Link: https://lore.kernel.org/r/20241219105447.889CB11FE@mail.steuer-voss.de
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/imx/clk-imx8mp-audiomix.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/imx/clk-imx8mp-audiomix.c
+++ b/drivers/clk/imx/clk-imx8mp-audiomix.c
@@ -278,7 +278,8 @@ static int clk_imx8mp_audiomix_reset_con
 
 #else /* !CONFIG_RESET_CONTROLLER */
 
-static int clk_imx8mp_audiomix_reset_controller_register(struct clk_imx8mp_audiomix_priv *priv)
+static int clk_imx8mp_audiomix_reset_controller_register(struct device *dev,
+							 struct clk_imx8mp_audiomix_priv *priv)
 {
 	return 0;
 }


