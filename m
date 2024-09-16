Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1BE15B108;
	Mon, 16 Sep 2024 12:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488179; cv=none; b=ZP5Yj0tyjsTlsUxnSImmty2Zbsxh3egORBApmqKmiMF87l4JPU3VLf9VKp39vZMPTW4gwoPI7T0Ux/WVEnEhZY5luOc7n7lCFYiEXQy2UeQZh8LF0aWKMdlJfWtaQoxR6z5RHp07RCU5WFYgRnbY7TeSqDmNEfbnP+A8tsIS4jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488179; c=relaxed/simple;
	bh=UUeWXZPvtJ5G9Y/1gyUZ8S0YneO1MDi8+DQTWibnb6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM/gXQVS7woGYMocvY81v10ceiWjSGZzPxMtyeh/l9YNW4H9XEhvPcChSbNnUy70MLda1G3y4UYQVkfsbR2iQZ9c4fFHdTQvhrRblJiTrKiIrkE/aHVDYjGSR/+p8mxFgGLLOA1qI7G1ZPUUtPWPwp32sRzgOQeZcLr28uo88Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QJTj2Fa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QJTj2Fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDCDC4CEC7;
	Mon, 16 Sep 2024 12:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488179;
	bh=UUeWXZPvtJ5G9Y/1gyUZ8S0YneO1MDi8+DQTWibnb6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QJTj2FaeiqwD+9hA4wou91of5Kax+Oq62SCHSxktuaGJ1/n1JIQ0GhBmf0Ybqaof
	 kOuW2nYUOyDLeeP1v6/JDNi3chWMc8HEQFj//EOC4fJ+bnvRpJQQfo1VUt2m1W3VPk
	 1mH+C+VhdcdvuPi6wsbw3djRf8CGHBTtzx5NNy6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kaechele <felix@kaechele.ca>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 023/121] Input: edt-ft5x06 - add support for FocalTech FT8201
Date: Mon, 16 Sep 2024 13:43:17 +0200
Message-ID: <20240916114229.764993384@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kaechele <felix@kaechele.ca>

[ Upstream commit fc289d3e8698f9b11edad6d73f371ebf35944c57 ]

The driver supports the FT8201 chip as well. It registers up to 10 touch
points.

Tested on: Lenovo ThinkSmart View (CD-18781Y), LCM: BOE TV080WXM-LL4

Signed-off-by: Felix Kaechele <felix@kaechele.ca>
Link: https://lore.kernel.org/r/20240804031310.331871-3-felix@kaechele.ca
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/edt-ft5x06.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 06ec0f2e18ae..b0b5b6241b44 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -1474,6 +1474,10 @@ static const struct edt_i2c_chip_data edt_ft6236_data = {
 	.max_support_points = 2,
 };
 
+static const struct edt_i2c_chip_data edt_ft8201_data = {
+	.max_support_points = 10,
+};
+
 static const struct edt_i2c_chip_data edt_ft8719_data = {
 	.max_support_points = 10,
 };
@@ -1485,6 +1489,7 @@ static const struct i2c_device_id edt_ft5x06_ts_id[] = {
 	{ .name = "ft5452", .driver_data = (long)&edt_ft5452_data },
 	/* Note no edt- prefix for compatibility with the ft6236.c driver */
 	{ .name = "ft6236", .driver_data = (long)&edt_ft6236_data },
+	{ .name = "ft8201", .driver_data = (long)&edt_ft8201_data },
 	{ .name = "ft8719", .driver_data = (long)&edt_ft8719_data },
 	{ /* sentinel */ }
 };
@@ -1499,6 +1504,7 @@ static const struct of_device_id edt_ft5x06_of_match[] = {
 	{ .compatible = "focaltech,ft5452", .data = &edt_ft5452_data },
 	/* Note focaltech vendor prefix for compatibility with ft6236.c */
 	{ .compatible = "focaltech,ft6236", .data = &edt_ft6236_data },
+	{ .compatible = "focaltech,ft8201", .data = &edt_ft8201_data },
 	{ .compatible = "focaltech,ft8719", .data = &edt_ft8719_data },
 	{ /* sentinel */ }
 };
-- 
2.43.0



