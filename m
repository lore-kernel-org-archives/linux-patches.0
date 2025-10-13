Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EC721E0AD;
	Mon, 13 Oct 2025 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369356; cv=none; b=tQxO4xtVZleQrT/K/vpyUn1l5IvM7LqMhczmSs1fFiUVX75qAylhky5Q0oeOU1LWmyYdI6Mbvbc26HM9lRkyUXkkulaPRg+A95qBU0Wrj8F1vR6gRVxfv7KDNUCeRw0ZNasHsyWmS8mD2HrjSmZ0eVFqrSuQ8JLLdTIqveK69rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369356; c=relaxed/simple;
	bh=DI2NAFoNFWAUkzhHhBLJDDJhCYqJx0F/UXrqBhR+NJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEmhtx34Noq3uFonydx+W+++YUiQEPRZKswwMG47k6oKEcm8WZPaN70UPgz66HuW6kXIwzx+VVxzc+Sg5KzGTvy+HBFcd08OpWI4yEoT52LrbDmMMt5/+3Ob1G6PyIa8+HXYXcDVwFZ/Q4vpkzWL4TEnpHnfAKsxmvJD3TQjBVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYBY0M2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYBY0M2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C92C4CEFE;
	Mon, 13 Oct 2025 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369356;
	bh=DI2NAFoNFWAUkzhHhBLJDDJhCYqJx0F/UXrqBhR+NJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYBY0M2j3fTAetHYcyP6gka6WJK0zjpzIV20ns8IS6JCjBl0fQeLrnnBmywd3MSyR
	 BgUsDbMZ+2aOxJLgbHZpbx9hJscrRDJcSq+j+uEcwzv5vF+9i9lSoAml3sRXMgpj27
	 YflWWO7nUgYApwriHPvkrRNTTYdmQVpgZV4RbgEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 217/563] drm/panel: novatek-nt35560: Fix invalid return value
Date: Mon, 13 Oct 2025 16:41:18 +0200
Message-ID: <20251013144419.145421540@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brigham Campbell <me@brighamcampbell.com>

[ Upstream commit 125459e19ec654924e472f3ff5aeea40358dbebf ]

Fix bug in nt35560_set_brightness() which causes the function to
erroneously report an error. mipi_dsi_dcs_write() returns either a
negative value when an error occurred or a positive number of bytes
written when no error occurred. The buggy code reports an error under
either condition.

Fixes: 8152c2bfd780 ("drm/panel: Add driver for Sony ACX424AKP panel")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Brigham Campbell <me@brighamcampbell.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250731032343.1258366-2-me@brighamcampbell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35560.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35560.c b/drivers/gpu/drm/panel/panel-novatek-nt35560.c
index 98f0782c84111..17898a29efe87 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35560.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35560.c
@@ -161,7 +161,7 @@ static int nt35560_set_brightness(struct backlight_device *bl)
 		par = 0x00;
 		ret = mipi_dsi_dcs_write(dsi, MIPI_DCS_WRITE_CONTROL_DISPLAY,
 					 &par, 1);
-		if (ret) {
+		if (ret < 0) {
 			dev_err(nt->dev, "failed to disable display backlight (%d)\n", ret);
 			return ret;
 		}
-- 
2.51.0



