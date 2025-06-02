Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EEE1EDA02;
	Mon,  2 Jun 2025 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876972; cv=none; b=PpiyI/A5CB8mpqAEeizJ+Azj7Lx9+O9z4pXZ73IsmuNZjg6bwAoMIPH1cBN0IhJ/Y90NfCctzBRNfpbKdC+xChD9CrmoBU/KMRp99h4NINPQE2plPaTk0DWOyMd8I+z9+z4ZQxCZNV6x3V/p9hPuSqYD6O4rvqesQ6HDCqUB11o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876972; c=relaxed/simple;
	bh=aZ3kbk+1mAa5iU0cFWLZ4DYbDK6PGKL1s/dhNNmdl54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yrgve+U8r6g4dDroeQ7PVWqZ1K0D8XBUYcjp9bchPcSPXYBXaiomHPV3G4e2iNZgNBnhptbbBgS/0VP4u5sXyDI2bzya/dtUJJjbHSMHpbRFJXbYdCxuG54eJXEdJgZZE+yuE98Bad5zHppPeb3yhObV2PqR+3gC5PAQ7KEtT3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcpSq56R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcpSq56R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8851CC4CEEB;
	Mon,  2 Jun 2025 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876972;
	bh=aZ3kbk+1mAa5iU0cFWLZ4DYbDK6PGKL1s/dhNNmdl54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcpSq56RUdDy94iFMyAeTXzX4aFP3Ye1vR0CiX9Tx83OtpOEdHRoW1Y6/LL+vuvEN
	 U9jKnh2iu31mv8SIHs0QLmf9v43Rgfzln4EpaVmdk4OvUrVitMyOji5TsBbcJHk8y0
	 AT9RZZ7oIa8TB8S/t7Cbo6GJHG8liAjs9Lt2j7L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/325] leds: pwm-multicolor: Add check for fwnode_property_read_u32
Date: Mon,  2 Jun 2025 15:46:47 +0200
Message-ID: <20250602134325.130216904@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 6d91124e7edc109f114b1afe6d00d85d0d0ac174 ]

Add a check to the return value of fwnode_property_read_u32()
in case it fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://lore.kernel.org/r/20250223121459.2889484-1-ruc_gongyuanjun@163.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-pwm-multicolor.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/rgb/leds-pwm-multicolor.c b/drivers/leds/rgb/leds-pwm-multicolor.c
index da9d2218ae184..97aa06e2ff603 100644
--- a/drivers/leds/rgb/leds-pwm-multicolor.c
+++ b/drivers/leds/rgb/leds-pwm-multicolor.c
@@ -135,8 +135,11 @@ static int led_pwm_mc_probe(struct platform_device *pdev)
 
 	/* init the multicolor's LED class device */
 	cdev = &priv->mc_cdev.led_cdev;
-	fwnode_property_read_u32(mcnode, "max-brightness",
+	ret = fwnode_property_read_u32(mcnode, "max-brightness",
 				 &cdev->max_brightness);
+	if (ret)
+		goto release_mcnode;
+
 	cdev->flags = LED_CORE_SUSPENDRESUME;
 	cdev->brightness_set_blocking = led_pwm_mc_set;
 
-- 
2.39.5



