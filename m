Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DBE188A0E;
	Tue, 29 Apr 2025 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950645; cv=none; b=NPdGEx8k2V/uwLQqYdkOs5WilZXwsN5SD3hEes6pkdTc+kSyt6HE2fLHmcg8+fg13zqolyBsKdONmni6Sag5wjzXwVG/vSkm75Zoo4+2ZilerQApgzDGvUPucJwzJ5GVsL3zMXJAbpQUp9LhYO0grTfj7awtsY9WY7f7ZJzrkso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950645; c=relaxed/simple;
	bh=XaEExmu7Ac9kPFOYJx7kyPBaO1Ua4ndonbyiTwUKw/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckWjgSGOepXbm0YB7Z6cUchd4UKdUup/2vZWhDcN+CHEAnojSfIXkOMngNsGxzff2ivCRo/b0cmJ1QN8zhHMf110n7cwXHRH4HQeTGhpEHdkpdNfU4vMTQw/OHTlqj/Y1306XGoKHUCOIy07Um15cCEx8Io3aHmhdA5Xs7xytwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHwGhAAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHwGhAAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C77C4CEE3;
	Tue, 29 Apr 2025 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950644;
	bh=XaEExmu7Ac9kPFOYJx7kyPBaO1Ua4ndonbyiTwUKw/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHwGhAAB0lC+oEytnEaZtbvq2LDoEPccZXPpBe969ZFWTc/dsB8dRXNcE+VS3NMXb
	 IB4ycgzY4vmiK5yNdOCXdXF3Ukuk9sRxUoT/RObIblNxsroopvEzFd0GkZ+6HSjzsP
	 k8ofKh1961gcfQGffJIgYEu+jfpyQUcav0AoORbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/204] usb: host: max3421-hcd: Add missing spi_device_id table
Date: Tue, 29 Apr 2025 18:43:39 +0200
Message-ID: <20250429161104.787985497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@mailbox.org>

[ Upstream commit 41d5e3806cf589f658f92c75195095df0b66f66a ]

"maxim,max3421" DT compatible is missing its SPI device ID entry, not
allowing module autoloading and leading to the following message:
 "SPI driver max3421-hcd has no spi_device_id for maxim,max3421"

Fix this by adding the spi_device_id table.

Signed-off-by: Alexander Stein <alexander.stein@mailbox.org>
Link: https://lore.kernel.org/r/20250128195114.56321-1-alexander.stein@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index a219260ad3e6c..cc1f579f02de1 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1946,6 +1946,12 @@ max3421_remove(struct spi_device *spi)
 	usb_put_hcd(hcd);
 }
 
+static const struct spi_device_id max3421_spi_ids[] = {
+	{ "max3421" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, max3421_spi_ids);
+
 static const struct of_device_id max3421_of_match_table[] = {
 	{ .compatible = "maxim,max3421", },
 	{},
@@ -1955,6 +1961,7 @@ MODULE_DEVICE_TABLE(of, max3421_of_match_table);
 static struct spi_driver max3421_driver = {
 	.probe		= max3421_probe,
 	.remove		= max3421_remove,
+	.id_table	= max3421_spi_ids,
 	.driver		= {
 		.name	= "max3421-hcd",
 		.of_match_table = max3421_of_match_table,
-- 
2.39.5



