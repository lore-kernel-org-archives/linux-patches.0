Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7A81C5F2C;
	Wed, 19 Mar 2025 14:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395071; cv=none; b=lD3rOPSxpPIjcMB8HPBBoRMzSZjmnHUbgJuj+0Ez/xftWFZirSKVXUCUz70mFNEXoQIumhdERlHiVEbIiGqm5ZQ9Dp+rOj5Hx1GKYUV4kfiNi9kvMSrVEAbiWMS8ME5wdg9Bx8mWN3uB1pcUx4BXYBmBAeFpYkPYJ7m0FdcZ/AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395071; c=relaxed/simple;
	bh=ZljLT3wFVjO7naAwuTtkAgBPMpKrvtYdXMr5cKq9vwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLyL0ji54FzhbxkUANODILx0JZnVo+tb+irZaBeYZpTdH49kbNsr8qmZdhhT6rSfwSOco9z00rcwJfv5VETRkxtwa9XWu69Zae2DBrpp1Tv6oP19xJo77W5+cwXaZiO/U3jVobm1OlgtlRU/6OxjwpKFxKOeZP7KKyAWTTgVQ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaOF1btG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaOF1btG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB824C4CEE4;
	Wed, 19 Mar 2025 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395070;
	bh=ZljLT3wFVjO7naAwuTtkAgBPMpKrvtYdXMr5cKq9vwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaOF1btGRX4Ogp/VNABnHsPYEwA4MBvjGy5pGKHXoFzlyKXL9oTdZKZItg0NY4rDw
	 sNsOAqCLxstx/oZWy6Kj4TrQekDMnLoX4+RmkTb1b3+sWn293LW1zuRXsIb0fVIif6
	 4zVgTh/N//N808gm2EIHjL4V62se/X7IgxUEwd0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/231] ASoC: rsnd: indicate unsupported clock rate
Date: Wed, 19 Mar 2025 07:30:01 -0700
Message-ID: <20250319143029.506568909@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
index b3d4e8ae07eff..0c6424a1fcac0 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -336,7 +336,8 @@ static int rsnd_ssi_master_clk_start(struct rsnd_mod *mod,
 	return 0;
 
 rate_err:
-	dev_err(dev, "unsupported clock rate\n");
+	dev_err(dev, "unsupported clock rate (%d)\n", rate);
+
 	return ret;
 }
 
-- 
2.39.5



