Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E331429A2;
	Tue, 30 Jul 2024 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355777; cv=none; b=p7wN2m3hqBdK0sMoTiLOElTbl8JYHS7Zvr2GpP6pEbhNmg7LpbWmTpVmIghelfXqAHp8CW+or6GQVolCQ9zd9+xlZmWhK0LS3losogFyevdQn++r3lW24mIoMf658uFvezyPKeEgQpciNywitQZTOKFPtXcc1XOdX2ikrSRunyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355777; c=relaxed/simple;
	bh=UA/lj8aZHQb7n+tTKy+ATtUftmSQOqNIsF5jTA0n27E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aC0bdqmMTEI5l92lcfZWIbtczqIukDVd+ewfMmi8600He92BM7oNjZsr51fvobiMEqB4fSaThkLJO8io6ZCGIfKKDusbpZDxSCU4H+Th5H7aswvNBfd9mdjZiVul037L0LOuiCy2/OTHZ4218AhS2yeYE+5mq4Rbaw6bc8QPnI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmhACvvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmhACvvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47817C32782;
	Tue, 30 Jul 2024 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355776;
	bh=UA/lj8aZHQb7n+tTKy+ATtUftmSQOqNIsF5jTA0n27E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmhACvvywC7+d083zzhhsX9Pm2BFfaQzb7TJ8xfDpX10ukLGD1Tec/adsEWMXwzUm
	 vQCOcgKvNCQr/h7AhqvAxEOUART3oWwqeq6pN5DNjzvoX8M6nxQxhStHBjxqA8Bb4m
	 ZDMN/d6MqS28vJWRv2bCubiQVJpzYuEm5U2X8jfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/440] drm/mipi-dsi: Fix mipi_dsi_dcs_write_seq() macro definition format
Date: Tue, 30 Jul 2024 17:46:02 +0200
Message-ID: <20240730151620.921675937@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 51d3c0e7dc3cf1dd91c34b0f9bdadda310c7ed5b ]

Change made using a `clang-format -i include/drm/drm_mipi_dsi.h` command.

Suggested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230102202542.3494677-1-javierm@redhat.com
Stable-dep-of: 0b03829fdece ("drm/mipi-dsi: Fix theoretical int overflow in mipi_dsi_dcs_write_seq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_mipi_dsi.h | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index 66a7e01c62608..9dd1093b2dfa9 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -309,15 +309,18 @@ int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
  * @cmd: Command
  * @seq: buffer containing data to be transmitted
  */
-#define mipi_dsi_dcs_write_seq(dsi, cmd, seq...) do {				\
-		static const u8 d[] = { cmd, seq };				\
-		struct device *dev = &dsi->dev;	\
-		int ret;						\
-		ret = mipi_dsi_dcs_write_buffer(dsi, d, ARRAY_SIZE(d));	\
-		if (ret < 0) {						\
-			dev_err_ratelimited(dev, "sending command %#02x failed: %d\n", cmd, ret); \
-			return ret;						\
-		}						\
+#define mipi_dsi_dcs_write_seq(dsi, cmd, seq...)                           \
+	do {                                                               \
+		static const u8 d[] = { cmd, seq };                        \
+		struct device *dev = &dsi->dev;                            \
+		int ret;                                                   \
+		ret = mipi_dsi_dcs_write_buffer(dsi, d, ARRAY_SIZE(d));    \
+		if (ret < 0) {                                             \
+			dev_err_ratelimited(                               \
+				dev, "sending command %#02x failed: %d\n", \
+				cmd, ret);                                 \
+			return ret;                                        \
+		}                                                          \
 	} while (0)
 
 /**
-- 
2.43.0



