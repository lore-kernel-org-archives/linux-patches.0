Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FB9309DC0;
	Mon, 13 Oct 2025 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367586; cv=none; b=Eht7B9/aBced9Jw4UqDk7QuEQmyo4nd0BmquLXGeUbEosy4bI7IS/Tm9xGSYJcNOxJCdu9DXkoCD8Rj4RbC02WxleB5wLIyHSN0gcK/FBVxiYTvfKzcwWydm9NkS3SGtWCgOoGclnpKN0y1GQbfhpQ4WeAkhrScq8EtXKt2NP2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367586; c=relaxed/simple;
	bh=6z/UT84n9sx431eCOFQqUvHkg70wyjy+D7RRZfGRNWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEaif9+FpaUEWP5MPYBe7tjTo/Ao1zp8wDDZLXKedJECoSszRu2aq0PsGqR1USd4aSdBlbQjdVIvhZYhYryscgi3UcgU227h3r5c40g19NiFCNM0HOQ7AAK+9zC3YmvTfZgzEjMK1opalkwgO2XFhVaElPhAWKKL3gTTxeidK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhOkJEE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhOkJEE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14677C4CEE7;
	Mon, 13 Oct 2025 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367586;
	bh=6z/UT84n9sx431eCOFQqUvHkg70wyjy+D7RRZfGRNWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhOkJEE7LxODPbrJcIjrk8cEMYDPZOV42PZD1xi648Y15VwLQ06Iz3wpeR5SKqcQM
	 l8IktIRb19P0xgUqcsnR7RZ8XuvruqWiitsriSqZtVTqrfpCSrCQ6AAxTF9bQJtLjT
	 ZCNQy3qb5pvuOhdaXTiI6BfBu28uQFiSamiYGzwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/196] drm/panel: novatek-nt35560: Fix invalid return value
Date: Mon, 13 Oct 2025 16:44:13 +0200
Message-ID: <20251013144317.439485778@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index 5bbea734123bc..ee04c55175bb8 100644
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



