Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91402ED85E;
	Thu,  3 Jul 2025 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554016; cv=none; b=so8QVFt68xqds4bPKSTEb2xKCqO5rKWwRongCCJdXMm/zGS5a0nO/1yUkd7lv+sNV4eSQEPSLsGNdrZH9+ZaGMJObdiRvVFo/1PHtji62uPrJIzIeLqKIc0E/KibLQL4XWLr3H6FrHLFZsdySWZEPLtxgZDaOp3sr0z919fU2PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554016; c=relaxed/simple;
	bh=3/NxoIz+Zvk+biMn/RrPlDVrt4D0ZCXaIrunpHXwq+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTmz/kNreCRi9A2XFK/0EdkExsa7vHXgaNUP1/9sEsvn0HB2t0IwI5YtuHSff+OsLiZNAMDzTSQwlFnIBMma5/NSYdvrZlHipQq8Q+17cOhBjwAdOes8hX1g4ubN3vAnh20ysU9X8+PoNUfSSADMEHgSdifnfsVhB0jwc53C3Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGmDDhrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGmDDhrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F6AC4AF09;
	Thu,  3 Jul 2025 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554016;
	bh=3/NxoIz+Zvk+biMn/RrPlDVrt4D0ZCXaIrunpHXwq+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGmDDhrUHge4+2iqkC8T5nRkkLvm2I79eQ5cJsgOutD/JNzKFlN9afrt3zrcsOhcr
	 HVi68L//mCL5wD7PSiTftDdNOQwWlByNoeOyQG638ZsgzNY+b3GL48X3ovlSxYchz+
	 9QyeEKPCdQgVnzU6DFbX8lAnjKkybJfgJ8t/CUP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/218] ASoC: rt1320: fix speaker noise when volume bar is 100%
Date: Thu,  3 Jul 2025 16:40:01 +0200
Message-ID: <20250703143958.056669072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 9adf2de86611ac108d07e769a699556d87f052e2 ]

This patch updates the settings to fix the speaker noise.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250602085851.4081886-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1320-sdw.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index f2d194e76a947..8755a63478d79 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -2085,7 +2085,7 @@ static const struct reg_sequence rt1320_vc_patch_code_write[] = {
 	{ 0x3fc2bfc0, 0x03 },
 	{ 0x0000d486, 0x43 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT1320_SDCA_ENT_PDE23, RT1320_SDCA_CTL_REQ_POWER_STATE, 0), 0x00 },
-	{ 0x1000db00, 0x04 },
+	{ 0x1000db00, 0x07 },
 	{ 0x1000db01, 0x00 },
 	{ 0x1000db02, 0x11 },
 	{ 0x1000db03, 0x00 },
@@ -2106,6 +2106,21 @@ static const struct reg_sequence rt1320_vc_patch_code_write[] = {
 	{ 0x1000db12, 0x00 },
 	{ 0x1000db13, 0x00 },
 	{ 0x1000db14, 0x45 },
+	{ 0x1000db15, 0x0d },
+	{ 0x1000db16, 0x01 },
+	{ 0x1000db17, 0x00 },
+	{ 0x1000db18, 0x00 },
+	{ 0x1000db19, 0xbf },
+	{ 0x1000db1a, 0x13 },
+	{ 0x1000db1b, 0x09 },
+	{ 0x1000db1c, 0x00 },
+	{ 0x1000db1d, 0x00 },
+	{ 0x1000db1e, 0x00 },
+	{ 0x1000db1f, 0x12 },
+	{ 0x1000db20, 0x09 },
+	{ 0x1000db21, 0x00 },
+	{ 0x1000db22, 0x00 },
+	{ 0x1000db23, 0x00 },
 	{ 0x0000d540, 0x01 },
 	{ 0x0000c081, 0xfc },
 	{ 0x0000f01e, 0x80 },
-- 
2.39.5



