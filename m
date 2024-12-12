Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF206229679;
	Thu, 12 Dec 2024 17:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025486; cv=none; b=dQMLk6O84BHeEKUrilqsEIwSerBQndvp19c4ZIU72e2OSGNrSuRvV8F6Hc/64xkHar38ue0HiDaOJj+vxmXnb7cqLbD2t4FlAK4OecLI4La/0+sCd1UrBKWMIuHMVdFlmAccgLLcFhO1XuGrNdXneL2E4nba67COubPaqNSVPjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025486; c=relaxed/simple;
	bh=KCk3j4rJPTefhYnCQPH9ONRtRfnXNAJHQQ8DqIwMtOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blkL33rKuZ+J40PtiIw8DLC9o/IMOjdtKxHvCUYIAYDG7DWJ87PZME7jYTNO8+3l7dR5dzFus+VG+BV54Cgi+VLPXYAVvwMhcrgV4v+auG4pmUIYaK31d0ZUOL1dCbjDmlh2SwWstyf1QxQi9QuasRv4HE5mFwsa5nw+nhyzYY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOmRUcPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOmRUcPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03857C4CECE;
	Thu, 12 Dec 2024 17:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025485;
	bh=KCk3j4rJPTefhYnCQPH9ONRtRfnXNAJHQQ8DqIwMtOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOmRUcPCewRbl4Aa4RZIBpl0y/QQoGoHDpUNCzmfuJhvuKeWngsUKec2h0C+A+zmy
	 xZIoE5DKWx2p5Tu2nZ9OGyTgALSApmIAQceoYgkU6soZTmLf6NPoxZ7g81bXGmbrNz
	 GM5Pnc5S355nniz094ZUQOf+eaQjAedgjgsk+btQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Gebben <jgebben@sweptlaser.com>,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/321] rtc: abx80x: Fix WDT bit position of the status register
Date: Thu, 12 Dec 2024 16:01:44 +0100
Message-ID: <20241212144237.332965111@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

[ Upstream commit 10e078b273ee7a2b8b4f05a64ac458f5e652d18d ]

The WDT bit in the status register is 5, not 6. This fixes from 6 to 5.

Link: https://abracon.com/Support/AppsManuals/Precisiontiming/AB08XX-Application-Manual.pdf
Link: https://www.microcrystal.com/fileadmin/Media/Products/RTC/App.Manual/RV-1805-C3_App-Manual.pdf
Fixes: 749e36d0a0d7 ("rtc: abx80x: add basic watchdog support")
Cc: Jeremy Gebben <jgebben@sweptlaser.com>
Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Link: https://lore.kernel.org/r/20241008041737.1640633-1-iwamatsu@nigauri.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index 73830670a41f1..51cfe72787ce3 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -36,7 +36,7 @@
 #define ABX8XX_REG_STATUS	0x0f
 #define ABX8XX_STATUS_AF	BIT(2)
 #define ABX8XX_STATUS_BLF	BIT(4)
-#define ABX8XX_STATUS_WDT	BIT(6)
+#define ABX8XX_STATUS_WDT	BIT(5)
 
 #define ABX8XX_REG_CTRL1	0x10
 #define ABX8XX_CTRL_WRITE	BIT(0)
-- 
2.43.0



