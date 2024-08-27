Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28704DDC1;
	Tue, 27 Aug 2024 15:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770831; cv=none; b=BnRCIqgL6h7J3vypyAfo3aWtEgh6o0PVwsWJzHPR64hGx1Lr7Qq5XlhIU7hKmVNACOIZ9vOXpd9MrLfqtcQLNeEQRMlGO0riKvIgShzI9Q3wNB7gRl8PrrJslmIFBR4sN1NXAFyvJoA89LmMe65pX3RrfeD/Wk1PoR+W6SI0EqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770831; c=relaxed/simple;
	bh=bvfY/1KC/AAlRInQb48DMX6rOsxJ+OGFa0M/98UoXVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFpep8l7rPboeGry0iGleIBkxG2MKv2haH0l9RLuF36u0DXoui5ONchatspzGp+7Ma6KPxGk6IplGRDD0jEZ93A2gia6YNrR/NFbTyskHX8G663VG88mXLLGBe7bhuTuJNQM4sQ0A65zp8lPEoq9zcczeaLddvyogxAFWQfA/Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpBJ7mHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpBJ7mHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B1BC4AF1C;
	Tue, 27 Aug 2024 15:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770831;
	bh=bvfY/1KC/AAlRInQb48DMX6rOsxJ+OGFa0M/98UoXVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpBJ7mHUvfnM9YjZzEiuZ0M/Ve1elizxFqAKYtzCMUtaDOEqJruREvGdtcqkEZwqg
	 dtAPnl1tptddLN4Kz4Z5E0t7Kz7Lw0e8BRfBlAExKQ2FSXCU1Mo7b6mQ3gJaF+0Dow
	 U/fVmThAb0/eMPAb6omo5IzK5VKxFWsiGe4/UJIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianhua Lu <lujianhua000@gmail.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 328/341] drm/panel: nt36523: Set 120Hz fps for xiaomi,elish panels
Date: Tue, 27 Aug 2024 16:39:19 +0200
Message-ID: <20240827143855.877666868@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianhua Lu <lujianhua000@gmail.com>

commit de8ac5696ebc3a2d89c88b70aa3996ee112e76ef upstream.

After commit e6c0de5f4450 ("drm/msm/dpu: try multirect based on mdp clock limits")
merged, 120Hz is working on xiaomi,elish panels, so feature it.

Signed-off-by: Jianhua Lu <lujianhua000@gmail.com>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20240112140047.18123-1-lujianhua000@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240112140047.18123-1-lujianhua000@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt36523.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/panel/panel-novatek-nt36523.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt36523.c
@@ -935,8 +935,7 @@ static int j606f_boe_init_sequence(struc
 
 static const struct drm_display_mode elish_boe_modes[] = {
 	{
-		/* There is only one 120 Hz timing, but it doesn't work perfectly, 104 Hz preferred */
-		.clock = (1600 + 60 + 8 + 60) * (2560 + 26 + 4 + 168) * 104 / 1000,
+		.clock = (1600 + 60 + 8 + 60) * (2560 + 26 + 4 + 168) * 120 / 1000,
 		.hdisplay = 1600,
 		.hsync_start = 1600 + 60,
 		.hsync_end = 1600 + 60 + 8,
@@ -950,8 +949,7 @@ static const struct drm_display_mode eli
 
 static const struct drm_display_mode elish_csot_modes[] = {
 	{
-		/* There is only one 120 Hz timing, but it doesn't work perfectly, 104 Hz preferred */
-		.clock = (1600 + 200 + 40 + 52) * (2560 + 26 + 4 + 168) * 104 / 1000,
+		.clock = (1600 + 200 + 40 + 52) * (2560 + 26 + 4 + 168) * 120 / 1000,
 		.hdisplay = 1600,
 		.hsync_start = 1600 + 200,
 		.hsync_end = 1600 + 200 + 40,


