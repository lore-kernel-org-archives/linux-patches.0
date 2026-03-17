Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB863EC2C2;
	Tue, 17 Mar 2026 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765472; cv=none; b=a74TeR4PMHrK+DrtqOEk+8TcAf9hZoe4BceQM0LV3NSc41DsFIoBQYL7ZR4PjV5fGWr2GEvMAPsYpIw8LUMzr2qTxABopRUHlc8naSNW/WbyXuXxYk6ZbOUyGN5Of5O8l+7CUWsq5CGco1mMq5QK0Uceg9ABPklJP8Umg1E5kFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765472; c=relaxed/simple;
	bh=XAp/mjK4En7WHDJughDRRojviY1XYjb5IWxDBD4dLww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4ab1lG81vp9QHALd7qEE8LUzX5rw553GLkvgR/UldiNDxG8Kwp2xXq7jO7nsZY7qwbo14+0RzlOI5BvYDH5jDXwK1xnoddgvzb3gfVF7YQpG26i2HjVf8XX8l4RU6OlkEaPjTRZm31Wn75L6UHwpK6vH61NAxGLXRWAfKbCnFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=It35Xrwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="It35Xrwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC60C4CEF7;
	Tue, 17 Mar 2026 16:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765471;
	bh=XAp/mjK4En7WHDJughDRRojviY1XYjb5IWxDBD4dLww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=It35Xrwhr9UOaGsK+I0ODaJPec6Vu+D38aJEjv9IW/KCPtGoULu4dZKqVkJU4YDOL
	 GGEA814zZXVY9pXJJfVfUKS0PXUCxZ3CZZzi2HgVJ5Y9Jfrnp2ZU0ZnMl7mPyS38z0
	 4qhV9Cvc4uMFw0F4NKzTUkddcWRM90bM5cqX8X98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Azamat Almazbek uulu <almazbek1608@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 019/378] ASoC: amd: yc: Add ASUS EXPERTBOOK BM1503CDA to quirk table
Date: Tue, 17 Mar 2026 17:29:36 +0100
Message-ID: <20260317163007.681168842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Azamat Almazbek uulu <almazbek1608@gmail.com>

[ Upstream commit 32fc4168fa56f6301d858c778a3d712774e9657e ]

The ASUS ExpertBook BM1503CDA (Ryzen 5 7535U, Barcelo-R) has an
internal DMIC connected through the AMD ACP (Audio CoProcessor)
but is missing from the DMI quirk table, so the acp6x machine
driver probe returns -ENODEV and no DMIC capture device is created.

Add the DMI entry so the internal microphone works out of the box.

Signed-off-by: Azamat Almazbek uulu <almazbek1608@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260221114813.5610-1-almazbek1608@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index f1a63475100d1..7af4daeb4c6ff 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -703,6 +703,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 				DMI_MATCH(DMI_PRODUCT_NAME, "Vivobook_ASUSLaptop M6501RR_M6501RR"),
 			}
 		},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK BM1503CDA"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0



