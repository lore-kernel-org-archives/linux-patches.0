Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB241F8EEE;
	Tue,  3 Dec 2024 15:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240745; cv=none; b=VF8ZdDoO87TvBynhGdePFNcXMYUOPOfbAPPyPBP0Xe1LgaAof+S1LEt9fGq8Bq/ey3XhKy7Ur/7l3DpgspqLcyKZb4WcJpN/UBEKsfOCPUfT+X++EXeUAW9KIoYs29cYyzC6EVVRsGwlNiPqdbKdl4UzjUpFRWUZulxX4WR73+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240745; c=relaxed/simple;
	bh=K6fDUQTyKKNjK0Hqyl2VqjNvImJ0C0/BjkoL6CkPFOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3G7Ohnch7zRQeNBvJVB1FNsXPKCODq66NgZfH1pdZ02qIPVzbpkYHpUHI783inhQAL0Kk3UOSGE+1/gkGExqrxi5XDHVNUKh3kzp2JCYwL9AgXVLwN+fkTYJy+d325pS1SwS+ITpPCMA6vJbMuVfXPWc3T1zCgOSjVy67KFizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwW/chTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwW/chTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CADC4CED8;
	Tue,  3 Dec 2024 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240745;
	bh=K6fDUQTyKKNjK0Hqyl2VqjNvImJ0C0/BjkoL6CkPFOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwW/chTS5xX0t/In9BizdxQ7D7BT2IS1aJ2UV/NqACcf1tUNAMQhU1QQy9RJbnRbr
	 exHcmGx3kBuB0DDEEySud71bY1k6GFnJqu31RNW0QPopZ3TUyQHsWTq4HXMJAQOx9s
	 FybpLAH7jOT42XYwRn2j7IzkPNZ0Pdqoux9RHaDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hansson <newbyte@postmarketos.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/826] drm/panel: nt35510: Make new commands optional
Date: Tue,  3 Dec 2024 15:38:52 +0100
Message-ID: <20241203144751.745607809@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 2418aa8516b26c5e332a1a8c216d4d620f965a56 ]

The commit introducing the Frida display started to write the
SETVCMOFF registers unconditionally, and some (not all!) Hydis
display seem to be affected by ghosting after the commit.

Make SETVCMOFF optional and only send these commands on the
Frida display for now.

Reported-by: Stefan Hansson <newbyte@postmarketos.org>
Fixes: 219a1f49094f ("drm/panel: nt35510: support FRIDA FRD400B25025-A-CTK")
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Tested-by: Stefan Hansson <newbyte@postmarketos.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240908-fix-nt35510-v2-1-d4834b9cdb9b@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35510.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35510.c b/drivers/gpu/drm/panel/panel-novatek-nt35510.c
index 57686340de49f..549b86f2cc288 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35510.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35510.c
@@ -38,6 +38,7 @@
 
 #define NT35510_CMD_CORRECT_GAMMA BIT(0)
 #define NT35510_CMD_CONTROL_DISPLAY BIT(1)
+#define NT35510_CMD_SETVCMOFF BIT(2)
 
 #define MCS_CMD_MAUCCTR		0xF0 /* Manufacturer command enable */
 #define MCS_CMD_READ_ID1	0xDA
@@ -721,11 +722,13 @@ static int nt35510_setup_power(struct nt35510 *nt)
 	if (ret)
 		return ret;
 
-	ret = nt35510_send_long(nt, dsi, NT35510_P1_SETVCMOFF,
-				NT35510_P1_VCMOFF_LEN,
-				nt->conf->vcmoff);
-	if (ret)
-		return ret;
+	if (nt->conf->cmds & NT35510_CMD_SETVCMOFF) {
+		ret = nt35510_send_long(nt, dsi, NT35510_P1_SETVCMOFF,
+					NT35510_P1_VCMOFF_LEN,
+					nt->conf->vcmoff);
+		if (ret)
+			return ret;
+	}
 
 	/* Typically 10 ms */
 	usleep_range(10000, 20000);
@@ -1319,7 +1322,7 @@ static const struct nt35510_config nt35510_frida_frd400b25025 = {
 	},
 	.mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
 			MIPI_DSI_MODE_LPM,
-	.cmds = NT35510_CMD_CONTROL_DISPLAY,
+	.cmds = NT35510_CMD_CONTROL_DISPLAY | NT35510_CMD_SETVCMOFF,
 	/* 0x03: AVDD = 6.2V */
 	.avdd = { 0x03, 0x03, 0x03 },
 	/* 0x46: PCK = 2 x Hsync, BTP = 2.5 x VDDB */
-- 
2.43.0



