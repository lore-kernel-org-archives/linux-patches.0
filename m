Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DD446E005;
	Tue, 21 Jul 2026 17:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656182; cv=none; b=TDa7A4cKqz4UvS1M1ZSaLV+EPr1NzAYlAIWQQi7E70FUHJq0/jyGgH1B4C4aoDDWfWlE3Lfj2zbqw5fF5+MURf/wW9dzx7m/XyQkELOm00TxwHsGhCvIq7yZDFDAl0uYPuHn6jkycV8RQf5lJ8poUB1NG8WOH2AK0g2oF7bAwbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656182; c=relaxed/simple;
	bh=XrJWofvRZiACgFRZxj8GsVIomZx85YpW0yRqzkA7Bi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz8eIMIFo96yUZdDbGXu6f7K2J9Mu9pd0x3ljhzzA/GbPDMcCnULxMRsgjmlsSs/rX71LAU9+zH5SlBRSsKYqwuAPWgrfGlFg/+JzZxMyy3HCnIQzTdVVy1iNL1kRgmasc800s9YYKeL+Ga7+1cOBqPmvQXl9HR3lE6nDlQ0R9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fkXEEu9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fkXEEu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0F31F000E9;
	Tue, 21 Jul 2026 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656181;
	bh=fizq7GbHSFhdhsK5auoeUR7WECjHR8NA2yFzd9uFb0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fkXEEu94NZ4kFcSvKJovaLgbFuzkW8bMPToJqgUC3HeHSATys98Ptv/+dY5MizJW
	 jg8H5haL4ayEjJA9c46NOf0igUd+D+dMXqaoAAhubVDJPjlMDu4DbN5omY4frsW9+N
	 y5Nw/1NOKZlrbGVz8rdbVxqiqPX3ZKrUUEkKG/mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0291/1611] ASoC: rsnd: Fix RSND_SOC_MASK width to single nibble
Date: Tue, 21 Jul 2026 17:06:47 +0200
Message-ID: <20260721152521.610107980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/soc/renesas/rcar/rsnd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/renesas/rcar/rsnd.h b/sound/soc/renesas/rcar/rsnd.h
index 04c70690f7a258..3e666125959b47 100644
--- a/sound/soc/renesas/rcar/rsnd.h
+++ b/sound/soc/renesas/rcar/rsnd.h
@@ -624,7 +624,7 @@ struct rsnd_priv {
 #define RSND_GEN2	(2 << 0)
 #define RSND_GEN3	(3 << 0)
 #define RSND_GEN4	(4 << 0)
-#define RSND_SOC_MASK	(0xFF << 4)
+#define RSND_SOC_MASK	(0xF << 4)
 #define RSND_SOC_E	(1 << 4) /* E1/E2/E3 */
 
 	/*
-- 
2.53.0



