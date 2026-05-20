Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152CE3D7D7E;
	Wed, 20 May 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294417; cv=none; b=oSQErAN0C98kzAQnuLdlz0Vxw1Nu1/Or1M7lpFZCBSYWLtmRzicZPJQTLEUQePZGLePeTeL5EP0qkdEpn7TdOQnWiDc9b7VtNnvwjPqF+g2FnLHipAZUX5JqzGBEMUc5UrxgCBOxIGn8jmxNtaFyEE5wRhf2nAKYfskhA7Uuz6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294417; c=relaxed/simple;
	bh=zpPBqMd0JNk2V4YwWA0FIGk1yt7NfDw7IA0BUYlAiSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdz9wcZ3ktLL/wddACVx0TtsjH6/HAENFztYUeQtRhHoELnKwt6AeTFQ6vBjelkEeXDs0JlfH5i9Gz7JupWDRjFjpqSgl1l3qYE7pLBVjUyfdiPlQM4zKnmBi0lwfekqayYZ8Y0zFEmV0Fkt9zlcvkZ4NRuTMdTAfmr+sa7TNh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ix1ojPMy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ix1ojPMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1D71F000E9;
	Wed, 20 May 2026 16:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294416;
	bh=fVNVHpmK/iXeGfuGmQJFSFRb6TPBoxyRBNFsMyKsCVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ix1ojPMyYipGkIXJgperv8KSDHcCz4SCI+CmaRkUyzA7Qwk66XbjHmX2yQKSU5kPV
	 wj26nQzYwlzDopL5CCdpSKLRy1PRJLmxV1woxUoyk1DhoAra8CX4xDKiOwOe63onrt
	 IbWO5e8kYlkN67cJShesnSmrszBDzRrNevzrZqQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopi Krishna Menon <krishnagopi487@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0030/1146] thermal/drivers/spear: Fix error condition for reading st,thermal-flags
Date: Wed, 20 May 2026 18:04:40 +0200
Message-ID: <20260520162149.065847026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gopi Krishna Menon <krishnagopi487@gmail.com>

[ Upstream commit da2c4f332a0504d9c284e7626a561d343c8d6f57 ]

of_property_read_u32 returns 0 on success. The current check returns
-EINVAL if the property is read successfully.

Fix the check by removing ! from of_property_read_u32

Fixes: b9c7aff481f1 ("drivers/thermal/spear_thermal.c: add Device Tree probing capability")
Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Suggested-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260327090526.59330-1-krishnagopi487@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/spear_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index 603dadcd3df58..5e3e9c1f32f8e 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -93,7 +93,7 @@ static int spear_thermal_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	int ret = 0, val;
 
-	if (!np || !of_property_read_u32(np, "st,thermal-flags", &val)) {
+	if (!np || of_property_read_u32(np, "st,thermal-flags", &val)) {
 		dev_err(&pdev->dev, "Failed: DT Pdata not passed\n");
 		return -EINVAL;
 	}
-- 
2.53.0



