Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624405;
	b=ndh+DXwK/jCZfKTGSrKwAl217aNTuVPs9Ws8GvwyOYTpQpNcdPKM130wWSLi2Cs0XDNO
	 TlMNlhJEe9PqtPJNUgvaJFHUDTN7maW5Vd34eZIVFcPO08SreacmEVKmJEmL78WEsbfXC
	 E+W+9t6i2IWYlf85y4BDsIbKvlvnXO/cfeBVD5rYlQpZpMPYTWdLt5Y1KZ6hj/bWx8/fI
	 mZnAzlDSQfkDq0CmcqbLkBkf4Vmetx5olu70hphyiKaOWY9SwhbdUetGvBfsu1rL5pcnj
	 IMxaNAvEbzu64DypTEXR0LRuS2Xem0fq8rlGHB6lNhK0bDnrSq8A96cJd57x3AJdyZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qR3PqFcBbotGNxhgRcHGViWWU0bwai+0yrfwzJrra40=;
	b=JnWtJmnzgqviLNtGS1nsk2DU66TcgAnQ0EwX+OmvtmVOG3MwUgkCqkbZ2e7lndcswIGB
	 lersgPiJozJDaJ5AWVbyq2Vx/Jyy4FlVxLtkYYY2l3D1wJUgTq+M5SRkgyhJJQbDamWbV
	 farpzX7DSofrS1UXJfO0/Uz5i3no7n98Os9oAgtf4XLcDCHXRlZ6WtUWtdb85ENHO3SZv
	 +Bx0QKxVq628hFuClGk9tW/OxVAC7slYVMssF+wqU0L8j6O1sNzByffla0os/NZsxeUZi
	 G/uUnkqoXGgdY6Z8MM1CcGlw4mYN2oMdYnokg6rnZuC86+4MjgbadLVMmtvP+fenxeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfjwaZij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78B0606A69B;
	Wed, 25 Nov 2026 16:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfjwaZij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053FE1F000C4;
	Wed, 25 Nov 2026 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624405;
	bh=qR3PqFcBbotGNxhgRcHGViWWU0bwai+0yrfwzJrra40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfjwaZijJPye+0BQ91Pbxf/6jazh85JyXB2O5RwnPOKwruDcZ5Vn1adRH+Gmigc2N
	 W7DF9ieVnLLxhYYyPWGqfWOBBk6zyqSFALlSFZ8prrh+FMvm7vpT4fdkOR8Ss4lrKQ
	 dLBn6LfpU6ckRtDCba+bY51/t6m6Yrk3tDFEbP70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/816] drm/panel: visionox-r66451: Wait longer after the panel reset
Date: Wed, 25 Nov 2026 15:27:55 +0100
Message-ID: <20261125143852.145371518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit b4b2778d5e175b166e4a27e5df5d61da468ad004 ]

The initialization sequence is sent 10ms after the panel reset is
deasserted, however on the SM8350-HDK display card the panel does not
answer a DCS read at that time, as a result the panel initialization
commands are lost, and the panel does not exit sleep mode and the display
stays black. With the first command sent about 15ms after the reset
the panel comes up reliably, so wait 20ms after deasserting the reset.

Fixes: a6dfab2738fc ("drm/panel: Add driver for Visionox r66451 panel")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20261101212458.2431191-3-vz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-visionox-r66451.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-visionox-r66451.c b/drivers/gpu/drm/panel/panel-visionox-r66451.c
index c2b53458a9698..5f2e0266373e1 100644
--- a/drivers/gpu/drm/panel/panel-visionox-r66451.c
+++ b/drivers/gpu/drm/panel/panel-visionox-r66451.c
@@ -36,7 +36,7 @@ static void visionox_r66451_reset(struct visionox_r66451 *ctx)
 	gpiod_set_value_cansleep(ctx->reset_gpio, 1);
 	usleep_range(10000, 10100);
 	gpiod_set_value_cansleep(ctx->reset_gpio, 0);
-	usleep_range(10000, 10100);
+	usleep_range(20000, 21000);
 }
 
 static int visionox_r66451_on(struct visionox_r66451 *ctx)
-- 
2.53.0



