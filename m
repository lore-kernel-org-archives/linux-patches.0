Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA2E26CE33;
	Fri, 21 Nov 2025 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732016; cv=none; b=feoYFSisNjWUSN6MLxO5YTFSQQ8Znlr4PpWtWL+pilpjEGEiXaKUbvUWqotD0bqPdRR2utzbiexuppXc7OJPgtRg7OhHbZ4rRvbYWae1wZ7d77Cq7fCf+dE/Y+Jqo2Zf5UNCg+PDoGTIDh6PnqTemKxvnWlswhbJQlujuXAsfC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732016; c=relaxed/simple;
	bh=uZ+9yy/22RHpHTF1PK1YB7b9bNedIO/s7hVaL+K5qv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEA5z5zODWH2cWMGK4K6KMwH/nz10fGaE604RzqODqGG/4cu9ldTa/f0hZXLv5T+PhLZBTRgQfhNe2eGCNIXpk88rOnJf6zobxXwA4EJVD3x7iVee3kYWSRMyT67/Bz8DMW0bhxmY26NHmOTbHOGl0duLjpI/m8FAU7iWV90XO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSQTWwZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSQTWwZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21844C4CEF1;
	Fri, 21 Nov 2025 13:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732016;
	bh=uZ+9yy/22RHpHTF1PK1YB7b9bNedIO/s7hVaL+K5qv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSQTWwZTnMKyJkijPLaokniAAqWaCwiOW91FzxbhMaQzUUKlrvrM480aVoPCrhlsv
	 w5o07tqtooxNlNrS447QvMfAlhhR6Q3dhSl25YzhiwjX3bQYMT8dMhMGrOzO7MhKAE
	 CzLN6xLZiE1Z6rPn2hD7SQEwX3KseyCKEqwpbNXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Alexey Charkov <alchark@gmail.com>,
	Hugh Cole-Baker <sigmaris@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 127/185] mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4
Date: Fri, 21 Nov 2025 14:12:34 +0100
Message-ID: <20251121130148.459835139@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

commit a28352cf2d2f8380e7aca8cb61682396dca7a991 upstream.

strbin signal delay under 0x8 configuration is not stable after massive
test. The recommandation of it should be 0x4.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Tested-by: Alexey Charkov <alchark@gmail.com>
Tested-by: Hugh Cole-Baker <sigmaris@gmail.com>
Fixes: 08f3dff799d4 ("mmc: sdhci-of-dwcmshc: add rockchip platform support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -94,7 +94,7 @@
 #define DLL_TXCLK_TAPNUM_DEFAULT	0x10
 #define DLL_TXCLK_TAPNUM_90_DEGREES	0xA
 #define DLL_TXCLK_TAPNUM_FROM_SW	BIT(24)
-#define DLL_STRBIN_TAPNUM_DEFAULT	0x8
+#define DLL_STRBIN_TAPNUM_DEFAULT	0x4
 #define DLL_STRBIN_TAPNUM_FROM_SW	BIT(24)
 #define DLL_STRBIN_DELAY_NUM_SEL	BIT(26)
 #define DLL_STRBIN_DELAY_NUM_OFFSET	16


