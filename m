Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064618;
	b=u5mKsM+kmUNaHI7elCNsYdyGQIktmYgSSkKk4/E9pmMiAc0Mkuxqt4ZBWVBfm8PyUyiV
	 ULwwboq353RdCuYc7xrSBRXik3tvkRg0qc6T966nwuVGBU+GoZ44bmvROZYK0zC0oYHFv
	 fEQhGbptpmZCElVCiEhsdjv6NHt1yzVQwAjaOs6//jLPVzq3J/nMnfv9KJKHIDB59zqPc
	 6cQmh3pdQppCIPUjiQwaT/qVs724p6npnxC6JtvSTgjFL2SsjkQqy4SbCYCxuZGcJ+iJu
	 x4oRYlb8ejCWenGrQAfh4LjkemyGFs4bo2XRFM5KJy8VoIW+81MLONEZrQS0b0DivZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5zek28gdQfMTILdtwh26X0F1fgPuBWUcrtD661A7m2E=;
	b=U+ImBhlOIu/GjVcXHWx+7XT6cVC0XgLBzHc1pQ5AUoGAcug5996gdPfyzRx2ztDVL4Vg
	 ODF/dZ0GoISk2cRHoWP/5nmjGA2Pwhg9APTVQMSQisGHuAn4ZtiSnpQoAx6HO9N0WEcnL
	 q5GEWO+Yqs7pprj+mGN2tv7kdcLerQOKzE2GKvIElu7Z+lidSqxQOuXpqq1TxlmeoNTPn
	 vixPClcTq9bFb5GUfujAk6FbpdFFKuNQyrJYaRTOIxR/BT3rl9ainUj1wlO4/3ypMYgCz
	 tpvpL7L3haG+oz11FSegbNJGhxZKmMk/K1huah2q4q5QJvK6+9Li7pwpEnrLRpOOV1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FN72sAnQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3708606A9DE;
	Sat,  7 Nov 2026 15:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FN72sAnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AF11F0089F;
	Sat,  7 Nov 2026 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064618;
	bh=5zek28gdQfMTILdtwh26X0F1fgPuBWUcrtD661A7m2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FN72sAnQumvDXZK2wsDfI0NzacaasrrNM1eO/o0l8w3zrM4Us8ob2Bv0V5E/5iMAK
	 BN+Jv7gtXWPKgrkQq0wlq6i2O8N1ozWlJNwN3OiPT8FM22LKCD1x3qcGaJxe0Mt2WV
	 yOA7KEHdOIm4SE/rXmkTtWtzdXVedn21nv9WAS3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0590/1257] soc: fsl: cpm1: tsa: Fix clock leak in tsa_of_parse_tdms()
Date: Sat,  7 Nov 2026 08:48:06 -0500
Message-ID: <20261107134955.635135083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 46201d760c48e771fa2febfcb0787f22c3b71387 ]

The error cleanup loop puts l1rsync_clk and l1rclk_clk a second time
and never puts l1tsync_clk or l1tclk_clk, because the branches that
guard the transmit clocks use the receive clock field names.

Use the matching field in each branch so every clock acquired by
tsa_of_parse_tdms() is released exactly once.

Fixes: 1d4ba0b81c1c ("soc: fsl: cpm1: Add support for TSA")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20260917152719.2160395-1-vulab@iscas.ac.cn
[chleroy: Fixed the same in tsa_remove()]
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/tsa.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/fsl/qe/tsa.c b/drivers/soc/fsl/qe/tsa.c
index 4a88e54d25b94..502e2ffe86898 100644
--- a/drivers/soc/fsl/qe/tsa.c
+++ b/drivers/soc/fsl/qe/tsa.c
@@ -865,12 +865,12 @@ static int tsa_of_parse_tdms(struct tsa *tsa, struct device_node *np)
 			clk_put(tsa->tdm[i].l1rclk_clk);
 		}
 		if (tsa->tdm[i].l1tsync_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rsync_clk);
-			clk_put(tsa->tdm[i].l1rsync_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tsync_clk);
+			clk_put(tsa->tdm[i].l1tsync_clk);
 		}
 		if (tsa->tdm[i].l1tclk_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rclk_clk);
-			clk_put(tsa->tdm[i].l1rclk_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tclk_clk);
+			clk_put(tsa->tdm[i].l1tclk_clk);
 		}
 	}
 	return ret;
@@ -1039,12 +1039,12 @@ static void tsa_remove(struct platform_device *pdev)
 			clk_put(tsa->tdm[i].l1rclk_clk);
 		}
 		if (tsa->tdm[i].l1tsync_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rsync_clk);
-			clk_put(tsa->tdm[i].l1rsync_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tsync_clk);
+			clk_put(tsa->tdm[i].l1tsync_clk);
 		}
 		if (tsa->tdm[i].l1tclk_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rclk_clk);
-			clk_put(tsa->tdm[i].l1rclk_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tclk_clk);
+			clk_put(tsa->tdm[i].l1tclk_clk);
 		}
 	}
 }
-- 
2.53.0



