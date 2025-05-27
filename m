Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5880A19E7F9;
	Tue, 27 May 2025 16:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364715; cv=none; b=PSWmrp0O0/ofFNErOTW8lD0JErZurlqdLaH0Exl+0imYqDscmhugHBekuN3vCZhf5ELLIksw8msEq+FI/xdxiKm0wJJApoDArNUuOgDdDOWHfsVFXVAx85yNtOS+whW02Pf9cFhxgC76jqAjjQSsEb0565yVNHmjJCBrLz/NUHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364715; c=relaxed/simple;
	bh=LApymSNP8iPOvrJiriN3bTKJWlMjQPNJyGmGm8aD/Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2NenxWgRlQ3Qqinfyow1c8677teyhJlXWVEpb7QmUdHdrn/0vyz5tnzVApeHUO+MMp25DIVdoCuwiYsUkm2DAYnnAF8wXbZR7gBLNWc//Q2g4ZIZMbhiuanQIHbRhvKYltZdYD0sV0RWJImKvbM4ePzzPSJbX9uemm6Jyym4NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMHwgrcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMHwgrcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D81C4AF09;
	Tue, 27 May 2025 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364715;
	bh=LApymSNP8iPOvrJiriN3bTKJWlMjQPNJyGmGm8aD/Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMHwgrcYTdktgHsmi0xNArMrfSGgTdXuInKO0oHyGM8qfJOWKrGCMIFHAePyTonPy
	 ywHiOuUIrXgT9OYbkeXl+LluS9tzImJTflZaDdTInS7W7AoYR67bCLxLsMh9jEY1vg
	 0m/zWHcJ24xVTYVkE1xMtrm1PqQ2CNpEbjVuAr8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/626] rtc: rv3032: fix EERD location
Date: Tue, 27 May 2025 18:20:35 +0200
Message-ID: <20250527162450.799910764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit b0f9cb4a0706b0356e84d67e48500b77b343debe ]

EERD is bit 2 in CTRL1

Link: https://lore.kernel.org/r/20250306214243.1167692-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3032.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv3032.c b/drivers/rtc/rtc-rv3032.c
index 35b2e36b426a0..cb01038a2e27f 100644
--- a/drivers/rtc/rtc-rv3032.c
+++ b/drivers/rtc/rtc-rv3032.c
@@ -69,7 +69,7 @@
 #define RV3032_CLKOUT2_FD_MSK		GENMASK(6, 5)
 #define RV3032_CLKOUT2_OS		BIT(7)
 
-#define RV3032_CTRL1_EERD		BIT(3)
+#define RV3032_CTRL1_EERD		BIT(2)
 #define RV3032_CTRL1_WADA		BIT(5)
 
 #define RV3032_CTRL2_STOP		BIT(0)
-- 
2.39.5



