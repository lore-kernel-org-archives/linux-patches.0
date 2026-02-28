Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F8D4A2E3B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300982; cv=none; b=fLd9ezz2A58KnZ1IkaGD0eUZYD5vtH4LwlHNncaQHfxIoth2Ck99mPdWszPxXRI8O0XB4skS2mBhp0PocfMwuNqUyrWn4BTwfxj0cl9tvjPF68v4io6Dt1l/x5qDWp40zy6jJulBDTasdWRKO/1iHJ9Qduhj/EJ5qgRr4EjY7lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300982; c=relaxed/simple;
	bh=YE47e85RqDLcJ4xMF+9kJNvGP8g8151rwijD0gVedW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJEh3eKdh5sqBNEdKcsZNz/wSt9JZrTWp+7wsjLrGGk4aDIdGTUcK/1Xi9b49UxoVgZL+qCOEGgF9WDqwmw1Gz+65BMXaK3kfjj4M6pp29wtsm1AhI1vje6JlfxZsa6UZjynZ0OavvX3IYrRIBnzIC7QrFgBXTaOrkbGh667f4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sMua7vjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sMua7vjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A25C116D0;
	Sat, 28 Feb 2026 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300981;
	bh=YE47e85RqDLcJ4xMF+9kJNvGP8g8151rwijD0gVedW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMua7vjpqNpIkWTKJV/a8lnc4DbQzzTNo+UbHsUr4waCpFdHW0ECOPgK9mOVrnd44
	 eWgo6xkYnEsYMIPSgbKP/yu6K4sM2oR2oZuJhtOaM1u+ZMz9DMONv6jECUpRFU1UcN
	 u5Xc1ZIU0PWGiW9vfaLQRnU1Cu0PFwhIfIfulwdcBMeFOd+NYSY0eRpG+HqHD7T6NW
	 EWt5Uft5jt+zxxDd+urWWzLNJZZHnlC8n3eK986y00aZ+Df896m4vL1f+9qGMa+1Q7
	 UPmuYJG9dbczzMHNCxLS/GBA38ry8TSWU2nrZJ7YX8cXFflCSu77fagWy/ZUA1kbAf
	 TAjFmbVcLU2tw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexey Klimov <alexey.klimov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/752] gpu/panel-edp: add AUO panel entry for B140HAN06.4
Date: Sat, 28 Feb 2026 12:37:02 -0500
Message-ID: <20260228174750.1542406-111-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 2976aeb0de77da599ad37691963efbdcb07435ce ]

Add an eDP panel entry for AUO B140HAN06.4 that is also used in
some variants of Lenovo Flex 5G with Qcom SC8180 SoC.

The raw edid of the panel is:

00 ff ff ff ff ff ff 00 06 af 3d 64 00 00 00 00
2b 1d 01 04 a5 1f 11 78 03 b8 1a a6 54 4a 9b 26
0e 52 55 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 14 37 80 b8 70 38 24 40 10 10
3e 00 35 ae 10 00 00 18 10 2c 80 b8 70 38 24 40
10 10 3e 00 35 ae 10 00 00 18 00 00 00 fe 00 41
55 4f 0a 20 20 20 20 20 20 20 20 20 00 00 00 fe
00 42 31 34 30 48 41 4e 30 36 2e 34 20 0a 00 eb

I do not have access to the datasheet and but it is tested on above
mentioned laptop for a few weeks and seems to work just fine with
timing info of similar panels.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20251203074555.690613-1-alexey.klimov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 62435e3cd9f4d..aad5838cd700a 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1903,6 +1903,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x615c, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x635c, &delay_200_500_e50, "B116XAN06.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x639c, &delay_200_500_e50, "B140HAK02.7"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x643d, &delay_200_500_e50, "B140HAN06.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x723c, &delay_200_500_e50, "B140XTN07.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x73aa, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x8594, &delay_200_500_e50, "B133UAN01.0"),
-- 
2.51.0

