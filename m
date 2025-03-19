Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521DB1CAA60;
	Wed, 19 Mar 2025 14:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395204; cv=none; b=Wn+fRovGH7+wRnQFQqmFZ5WR9iB1JSSVE3T331hvUeLBF7Pkm8RdFbwh0URXjNkMV4WKY5VyvgS/4CX+m+vrEacgAJCarhOAAaJUmKOLQTWkeIqEQBKmrp2Zxxno8HQn8FYyUQYKkG7O/5cdIp3W9f6st+bQG1PXd9GoU8hBUjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395204; c=relaxed/simple;
	bh=xfY8lhcRfjwA7Omv3RfDAP75Quas+7VBjJ8DJgZmiHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvnL0Ja9Tw4mBeSFdZnbGxx/gQ4Mvtn409sDX1/TCuL8lnVx3nZrCqtoWjfvUDhYZrPx00YD66dZTSxl0ZWzQAEB7PzSX8CSrYKRsQ/0kbXdq+PH4rpQm5wVWcKQl4kvUEgHYeIosXHrdUXiudLOTAedqZK0AIolWXcgJOkeoHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSZnl9ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSZnl9ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232FAC4CEE4;
	Wed, 19 Mar 2025 14:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395204;
	bh=xfY8lhcRfjwA7Omv3RfDAP75Quas+7VBjJ8DJgZmiHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSZnl9ib7deAWwv3qaroC3qrFCuxLe2cEQgwuT/ntaJv/4DtiDhx9rcPxAmKlpARb
	 A8I5LDFjKtjJ1yWn9c7ZXE1590booSGqyvGZMi72F0HDQRcxfanKWW9pLoWAtzh3pV
	 bAGr+2tw8MMeUS7Q4DE6R0s2uy/nNHvonjYmv0XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/166] ASoC: rsnd: indicate unsupported clock rate
Date: Wed, 19 Mar 2025 07:30:39 -0700
Message-ID: <20250319143021.856834498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 796106e29e5df6cd4b4e2b51262a8a19e9fa0625 ]

It will indicate "unsupported clock rate" when setup clock failed.
But it is unclear what kind of rate was failed. Indicate it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://patch.msgid.link/874j192qej.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/ssi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index 690ac0d6ef41a..2a9e8d20c23c3 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -334,7 +334,8 @@ static int rsnd_ssi_master_clk_start(struct rsnd_mod *mod,
 	return 0;
 
 rate_err:
-	dev_err(dev, "unsupported clock rate\n");
+	dev_err(dev, "unsupported clock rate (%d)\n", rate);
+
 	return ret;
 }
 
-- 
2.39.5



