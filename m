Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05FD1F892E;
	Tue,  3 Dec 2024 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242694; cv=none; b=HxOjrr7klzhAdM5EQ90UQWdQVBUXim/Y8d19ef7RqXs25KPcQUOYYpAHAhbtGCcBLCZyXk22M5bi2bzi3nnQJSYl/7pqIFY/fs0r/n6ZzKr0chrS4g1xrgtlcENd98A362slWhUKXmmb365d071dPoFungHmPypneyrIci9Zdsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242694; c=relaxed/simple;
	bh=aQ087rllGSsPxNhyK11/q7sQNHDpjztEADyfP8hBYzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcOef6X/2md3Hn/hygV9u5CPeVpuO7SDH2KVGqkgABoXDExe6S9BGGI9oLTsRa2L4QNhvj7jGp36klS6DYuqKn49KWpQlY2oic4c/3fj3w2vgXUOarZSd5mYm5KMiDXcoJTtpYyWJs8XsWDu9ar1Yu+H27WPwymXpsxJslN9r+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lW4YvRKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lW4YvRKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AC0C4CECF;
	Tue,  3 Dec 2024 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242694;
	bh=aQ087rllGSsPxNhyK11/q7sQNHDpjztEADyfP8hBYzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lW4YvRKPuzZrBqU6BD+9pRfpVXBUm4lyxWNEX8mcz8oyQVvWhJWOM+V2f5rxmGH6X
	 Bs9sbEjD57fxdAtGsv3dW3ZOuBZ/6TOaGywaCrm0vgNM6iFmcuIsoSHsUS6od0fBeP
	 Q23KtwIEgMC4MvUCiJfFd4mO9vRlc8ZOz8ZmbjIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Gebben <jgebben@sweptlaser.com>,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 780/826] rtc: abx80x: Fix WDT bit position of the status register
Date: Tue,  3 Dec 2024 15:48:27 +0100
Message-ID: <20241203144814.190695635@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1298962402ff4..3fee27914ba80 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -39,7 +39,7 @@
 #define ABX8XX_REG_STATUS	0x0f
 #define ABX8XX_STATUS_AF	BIT(2)
 #define ABX8XX_STATUS_BLF	BIT(4)
-#define ABX8XX_STATUS_WDT	BIT(6)
+#define ABX8XX_STATUS_WDT	BIT(5)
 
 #define ABX8XX_REG_CTRL1	0x10
 #define ABX8XX_CTRL_WRITE	BIT(0)
-- 
2.43.0



