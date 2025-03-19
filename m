Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEC01DB122;
	Wed, 19 Mar 2025 14:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394935; cv=none; b=Z+4UWopT7apVEMUztwh83OhGB/MjyCl8EYPyYRO2bBc0gccnhNJESfTDbVxqDelx8HliHDyxOhJ1pXKTgtzLPJDEJKjnXoscsVsqiKlSvychnuwEl44gde++SRZyp8vtu2kXm0id3458xooS7B5s1gdZ6o6R/i6/2WAg7u1dZ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394935; c=relaxed/simple;
	bh=HvHDul91zpTaoK4hlN/gDBiH6lHfMiIpUG6N9HrDDOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZpPkykf71sslpWfqEZbPAJTlw1MldosuUCx4L2gHKPoD40nFXVkgbGLNPQKPDDd5ntgt4KLASJQERz8ovrkfv8DbYiZ0QZiu0RVDyRM+XiYqIKFpMJjkXB81AKl37W6GmJD0SuoDS9dB8SW4baurWfn5YSoftoYBlyPGRqMHDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUMau3ID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUMau3ID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141E5C4CEE8;
	Wed, 19 Mar 2025 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394935;
	bh=HvHDul91zpTaoK4hlN/gDBiH6lHfMiIpUG6N9HrDDOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUMau3IDUpztEynzMM3jHTxyTRFBRWrZkRvlqRKQkNgOLKd8LaPpWaXQw8VrmFGMu
	 B3s4jf0s2Xpb2oRhGeJoY4tQFS1KzLjXQDUo3piSeK24doxhLsYrgcdNJ2Word3n+1
	 jxIq0ZBQPLrLZPUBy9s6AQBT+1F5E2+rxVfg2qhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 112/241] ASoC: rsnd: indicate unsupported clock rate
Date: Wed, 19 Mar 2025 07:29:42 -0700
Message-ID: <20250319143030.495969995@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 sound/soc/renesas/rcar/ssi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/renesas/rcar/ssi.c b/sound/soc/renesas/rcar/ssi.c
index b3d4e8ae07eff..0c6424a1fcac0 100644
--- a/sound/soc/renesas/rcar/ssi.c
+++ b/sound/soc/renesas/rcar/ssi.c
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



