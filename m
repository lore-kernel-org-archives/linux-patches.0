Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E32237180;
	Tue, 21 Jul 2026 20:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665875; cv=none; b=X25qmbUBb+hsEtLNTRc2cwf7g2aEUmIR8P6v52iK9dQ5GIgL0FxubgpIkZD7MSz400DW8z2o2iQsYS3PxDu2Z+zH/K3CgsPLIR55A+6MroJ0K2yh4xEkgG5mGWimpzM8bTdz4GiznXsgz8qG0+2jAoX4pKhCkeIh50MqVtFBGK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665875; c=relaxed/simple;
	bh=9LGBvg513WxS4BcYnIXIY6+nkiTBQFNwF14CsTv4FrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KW/soTU//AgnFNe06SWbxpt+dH90z7FYhkaEguc+F21AzxcV/TlwTM0x/nv0a4cZM5KgfqEb73olTIKhBAyHFXOqnMh9YAg7Ct4AqABYBjKrn3makOJlaS1Uq8oKJ0IYXpQySO4VOgvWxqQhd/pkCJMu5GwiBKgzTSEwl6gIBCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yF4s/N/Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yF4s/N/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FEE1F000E9;
	Tue, 21 Jul 2026 20:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665874;
	bh=SC9v4mUzwyQ3ZoJHC+xotmzyR1PsFgZ3ACoqQUdsLhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yF4s/N/Y0Z+XYyPypW1TAV3ULw8Bzfab9o83i01vsSgDLSJ9PtKCqVx+aV+9QSqfh
	 lJTPFufCmhbKgSGfQVh6kuk+tZiPVGjmgKhInzvzDyTZsWcEkwPG/UJhFINpNkQ/uq
	 nGZ2j614IOS0OxK6JlJU9B4T2Y3018Qp3mTFQzrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0470/1266] ASoC: rsnd: Fix RSND_SOC_MASK width to single nibble
Date: Tue, 21 Jul 2026 17:15:07 +0200
Message-ID: <20260721152452.351450561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: John Madieu <john.madieu.xa@bp.renesas.com>

[ Upstream commit c0758279367e9d82eb7d7b4959718d7d32e96b7d ]

RSND_SOC_MASK was defined as (0xFF << 4), spanning bits 4-11. This is
wider than needed since only nibble B (bits 7:4) is used for SoC
identifiers. Narrow it to (0xF << 4) to match the intended single-nibble
allocation and prevent overlap with bits 8-11 which will be used by
upcoming RZ series flags.

No functional change, since the only current user (RSND_SOC_E) fits
within a single nibble.

Fixes: ba164a49f8f7 ("ASoC: rsnd: src: Avoid a potential deadlock")
Signed-off-by: John Madieu <john.madieu.xa@bp.renesas.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20260525110230.4014435-3-john.madieu.xa@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/rsnd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sh/rcar/rsnd.h b/sound/soc/sh/rcar/rsnd.h
index 1214dbba6898b1..923436ee6f7e0d 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -637,7 +637,7 @@ struct rsnd_priv {
 #define RSND_GEN2	(2 << 0)
 #define RSND_GEN3	(3 << 0)
 #define RSND_GEN4	(4 << 0)
-#define RSND_SOC_MASK	(0xFF << 4)
+#define RSND_SOC_MASK	(0xF << 4)
 #define RSND_SOC_E	(1 << 4) /* E1/E2/E3 */
 
 	/*
-- 
2.53.0



