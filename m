Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAED93ED3B2;
	Tue, 21 Jul 2026 19:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661816; cv=none; b=IpyQJWAW7z2/cNgq0Afd8f2ii+3g3avdrtAD7mhkAOq1zfmqngr/xeEjNl+sBApHDwiQnLMM086QS+eIeg5mhgJts3NaTuhBAJ1hqGnqqn45P4Pf/+oTmNy3YzcwpNl8zRUTlOYAaoTPU2yeh4DVkpqgniaxgldeGKTeoYghUho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661816; c=relaxed/simple;
	bh=u+fWQJ3Y8owZHaUUNh160WAeez1cPJ41N73PBTZ6ri4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmlzNrx2Z6IUBpmHwHT1/jdtYk026fFD7Tp90FGa5bnyGUIjr+s3hAfjOCONfacNP8ZgKJmNyFsCOisNz4+sulWn+uxRxtZF9ER77bs9n7xl9P7G4vw0zxxyGWq4le8x9fDHV9b/b40FvXHJNV6m8ru3NeCVsL3OT6EvCPr8fT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3Ksa79a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3Ksa79a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1C71F000E9;
	Tue, 21 Jul 2026 19:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661815;
	bh=fQIeedHED8ezMyEgYMclJapzgCx4WxMX2iNw4LcT4X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3Ksa79acYw3GE11PEIQePstDH0pjnFJY+kgooKvsjp4YxG3DYETeztX0L7CEEAQd
	 HO3x2wwcsTkkQxrDJGISaNt3FTd6vs34OJ1VDGHgy6UoAhENUXsbibKdUlJ0sw2DJX
	 cTu3/s1MlkVgXtYrM62XBDId4Iw8/DyV3YyksTA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0209/1276] ASoC: rsnd: Fix RSND_SOC_MASK width to single nibble
Date: Tue, 21 Jul 2026 17:10:52 +0200
Message-ID: <20260721152450.763463541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3f1100b98cdd33..286873effae28b 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
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



