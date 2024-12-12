Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254D8217664;
	Thu, 12 Dec 2024 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022878; cv=none; b=NbBW6hVobsuePUF0zDLeDnl1gaomh4fCFV82sK0HztkWLCPAzyVwG4LFLCLeGjwP3d7J+PEiBSMlFcu5mXMaB5CSgxpHLd4QDVpmhDSi432CKlLQwdzDMO/uRhrLZ71+8zRFB4gI8BH5vnYbvQFf4JGQERzthMXtQG8TvZtC+K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022878; c=relaxed/simple;
	bh=DKCtLftPcUYZpuOVCscS6pEXRCfuMbux9lZ4MqGclcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLCCcJaGXsBS3uqZ4kq4XAdc5j5RWLRVA/u3mgSSqXkdtMGcPGc1NUL3Jcxo7WUMZUBCuH7kEjvxtBPvWZCM9226H2n4AXv9Ta5GJzHUOpDX+MmWETWAsfliMM+6u8ulgkfLxH7e8Ul/nXsRwUclJmI1f0p2naF6F6U1Qzi+Pk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAiv9bnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAiv9bnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E375C4CECE;
	Thu, 12 Dec 2024 17:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022878;
	bh=DKCtLftPcUYZpuOVCscS6pEXRCfuMbux9lZ4MqGclcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAiv9bnZQYuTb5sdVztdp+OsTT52vpeL3V10Z0i/rNY4KTt6QPlDJ/q2RdjKX44Ov
	 /7Ek2PmSYDyxqW3Sw6TfA4A87/Lj6gmdYOoy4HTy6D05WnYKVIlSBYuQGiayHg6rTL
	 7o7MERSWRfpLVuEzNk2//kjGJpTtU5qaFy26tp8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Gebben <jgebben@sweptlaser.com>,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/565] rtc: abx80x: Fix WDT bit position of the status register
Date: Thu, 12 Dec 2024 15:59:14 +0100
Message-ID: <20241212144325.802568500@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9b0138d07232d..2ea6fdd2ae984 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -37,7 +37,7 @@
 #define ABX8XX_REG_STATUS	0x0f
 #define ABX8XX_STATUS_AF	BIT(2)
 #define ABX8XX_STATUS_BLF	BIT(4)
-#define ABX8XX_STATUS_WDT	BIT(6)
+#define ABX8XX_STATUS_WDT	BIT(5)
 
 #define ABX8XX_REG_CTRL1	0x10
 #define ABX8XX_CTRL_WRITE	BIT(0)
-- 
2.43.0



