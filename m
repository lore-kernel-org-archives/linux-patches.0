Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EE52FA64D;
	Tue, 17 Jun 2025 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178242; cv=none; b=O8afHoQ2VF7X2emxLTml0IT76t77bJNxABVWCR42M+1WKg4krIiUarbihBQKAXjQ5fLBOeWB6nUGj2c2/j1H15/f/OSM1qKFQ62XZ0xZjsf14ZaN/CYSXnJ/4ljGf/UbkzQfYomLdR/AXZR/NHcsscS+FgSTgsHaMAd19+omGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178242; c=relaxed/simple;
	bh=620cGVCDZ7m0E+jqoz6BclSzn/mqpINx20Qt4gvEFuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UomVEAX7Uv6ryuYlAM0gn3FaCWIyyBhzSvIlcQ9fbUqY1zQ2wND20urUTNeiPsp6hcVUA+moiG/obb5aqD3SgesQxD31exGAt2SpcTz/5LUbP+Ci7yDIu1z/iHoaWAhJSNxLPE2cuoMeurHbvlgAuKqUrQZkjXiKb9dB2f7IC44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLl9IbZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLl9IbZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB240C4CEF2;
	Tue, 17 Jun 2025 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178242;
	bh=620cGVCDZ7m0E+jqoz6BclSzn/mqpINx20Qt4gvEFuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLl9IbZjh1M4SGdSwCMBNy2J/jiU7iG6lXVBVseJ7GgrplgEe6jLF6CJbCqyaXJoY
	 ZIe5eKPZbhh8mshVMNYpAHqOBu6F7gtjZrb/qW8tLRRXuPYqaOsyGjj0m8VMw10+jh
	 XDx/ZH+t2jizc+iAFIaIkHkmqQtmMZVC0w8LuCbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 428/780] backlight: pm8941: Add NULL check in wled_configure()
Date: Tue, 17 Jun 2025 17:22:16 +0200
Message-ID: <20250617152508.898124777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9afe701b2a1b6..a63bb42c8f8b0 100644
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



