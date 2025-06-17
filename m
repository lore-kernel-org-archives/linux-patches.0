Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BFD2EA146;
	Tue, 17 Jun 2025 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175704; cv=none; b=XmWbfBdX06Tf40ErKAJuaD9XHb9EuNAiGYTua+ui/jY2I52QizFXDGNTEon+8HPDO5C49iiFaWhY1Y+L9Ho+2l2daaL8J7Dhs9WnAIMBRdkPHLVZY9mZl56sRCItKwtmRkNwwiFNM1skZETkX0qc8hCCEsZwPcygK0ggr3poUAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175704; c=relaxed/simple;
	bh=+2OcayYHWuO7Q1/occiu4fq5RMnT8ADu1o/zhfdBqfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA0lATdzadVSFsDwIP/Xg3QiehbwgYEjOO3Y3ww2Wdh9BR+Iv8TNkBGV+jle1bBvH7Lst2xhG2uFfk9fhStnGHE5WcmBir5fKGrV9P9yEsmCz6t+xb2fR5Gh0CIGmPyYcoYCAHL6OBsPA+QdzHbr/3H4oy9q8RtxAtz9tpfoZrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vS3bR4hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vS3bR4hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5F8C4CEE3;
	Tue, 17 Jun 2025 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175704;
	bh=+2OcayYHWuO7Q1/occiu4fq5RMnT8ADu1o/zhfdBqfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vS3bR4hbxhBW0Fkq3XKmhV1toDNUEynEOvbfnTxm4iuLN+tk5l9vG5hZTNw8BrumC
	 F0gJUjzCK+dCU7bZ1Vfz5FHtOHxrqQH2akSV3yuKX6QVH0Evk6/5NTjzeZ7818z3Fe
	 IzHqgzHqDzMrCE33wLoBXhkSc5MgH+biUXa669xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/356] backlight: pm8941: Add NULL check in wled_configure()
Date: Tue, 17 Jun 2025 17:25:17 +0200
Message-ID: <20250617152346.341651191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit e12d3e1624a02706cdd3628bbf5668827214fa33 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
wled_configure() does not check for this case, which results in a NULL
pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: f86b77583d88 ("backlight: pm8941: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: "Daniel Thompson (RISCstar)" <danielt@kernel.org>
Link: https://lore.kernel.org/r/20250401091647.22784-1-bsdhenrymartin@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 10129095a4c17..b19e5f73de8bb 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1406,9 +1406,11 @@ static int wled_configure(struct wled *wled)
 	wled->ctrl_addr = be32_to_cpu(*prop_addr);
 
 	rc = of_property_read_string(dev->of_node, "label", &wled->name);
-	if (rc)
+	if (rc) {
 		wled->name = devm_kasprintf(dev, GFP_KERNEL, "%pOFn", dev->of_node);
-
+		if (!wled->name)
+			return -ENOMEM;
+	}
 	switch (wled->version) {
 	case 3:
 		u32_opts = wled3_opts;
-- 
2.39.5



