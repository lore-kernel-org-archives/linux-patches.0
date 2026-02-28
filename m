Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF84332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301217; cv=none; b=FIKo+MxggMpSvFjZbJK9Zv6XL1qGMfSa9WJSH5+GxctVeUN4bsqMfI9+XEZJ1aikUTWMJtIi0V6WNEV9R1EwYvGJYxyJbD8xDhm4Maw/rUoxhx9WpQ7ZkSTBGWXHOREwa60w63y9XpxKWBhQ5Qnio4zSqKY4PK9WVWAVpTKL6CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301217; c=relaxed/simple;
	bh=9JOA6572BYDqfDjY//bb7H4d1r4XQRYQMbcpDHSnCOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvEEXp/svWidJWSiEKHaIBrjL2Zbhnh3ZeuKnmlQSYHWZcabTpGqeXdL+fdCkWfbAhZ6m545xL2Xa5GsyQyTPq41v/yzoacoom5odpdQrXIcG8dr5IC8ujOh8nSLZEor3gq9EV2emo3OlHVKIAqtInAviUjZFVoLZgQ7Y46kIaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R32fIewi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R32fIewi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8D4C116D0;
	Sat, 28 Feb 2026 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301217;
	bh=9JOA6572BYDqfDjY//bb7H4d1r4XQRYQMbcpDHSnCOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R32fIewizg8IHPnFqXD10QFURLDBZStceiJ61oeMvJaFF+5OZ9PpNUUuGTCffkOjv
	 MQD/WwOlJBgPZ31mHKBlWVoqOWcoWIPrxLB36MItuPW99+4nf/0thh/jb3lO2xTMxm
	 la78jEfjisdaku4i8+fV5aqeUQ83JykNkxx/CKhVMVmOEOKz9MWCAg+dwBc4Z+iaE2
	 leNIR4wenH/PvNWQ4+qZMPeR29CyZE6Mg374e4vAjzgJ8W+a5sfZVX5Yy6HdruIats
	 282xNBt3xnHlyWAhHVmOo+yT7CNwak+ROs5nCmwDDYbUWGcIUuYAtyzRkXphFMYpZY
	 kohLyDJv48dOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tomas Melin <tomas.melin@vaisala.com>,
	Harini T <harini.t@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 393/752] rtc: zynqmp: correct frequency value
Date: Sat, 28 Feb 2026 12:41:44 -0500
Message-ID: <20260228174750.1542406-393-sashal@kernel.org>
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

From: Tomas Melin <tomas.melin@vaisala.com>

[ Upstream commit 2724fb4d429cbb724dcb6fa17953040918ebe3a2 ]

Fix calibration value in case a clock reference is provided.
The actual calibration value written into register is
frequency - 1.

Reviewed-by: Harini T <harini.t@amd.com>
Tested-by: Harini T <harini.t@amd.com>
Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260122-zynqmp-rtc-updates-v4-1-d4edb966b499@vaisala.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-zynqmp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-zynqmp.c b/drivers/rtc/rtc-zynqmp.c
index 3baa2b481d9f2..856bc1678e7d3 100644
--- a/drivers/rtc/rtc-zynqmp.c
+++ b/drivers/rtc/rtc-zynqmp.c
@@ -345,7 +345,10 @@ static int xlnx_rtc_probe(struct platform_device *pdev)
 					   &xrtcdev->freq);
 		if (ret)
 			xrtcdev->freq = RTC_CALIB_DEF;
+	} else {
+		xrtcdev->freq--;
 	}
+
 	ret = readl(xrtcdev->reg_base + RTC_CALIB_RD);
 	if (!ret)
 		writel(xrtcdev->freq, (xrtcdev->reg_base + RTC_CALIB_WR));
-- 
2.51.0

