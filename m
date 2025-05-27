Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B91527D784;
	Tue, 27 May 2025 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366744; cv=none; b=EM43j8OWEBkJFdICPmORtzi85WOzNY4VCgzB/d7/Xa9Slao/n9aco/LErWu8+UqlqHRVJtk2gLrqOKEqw3godLjtynHSmvKH+gtdF0bAh66Up7WhMpGADPBIG0BpHkOhcSxlCuHnTJNj4kosDWtcoQyaJKgTB4/NDXB4tCHigD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366744; c=relaxed/simple;
	bh=O+AWwT4JXkwEYQ7Vu7y7EH0iC1ZbzpLmDpu7uhUYG8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akg/WFTkfn7yN/YXFGlU999sZaTSLYSv1lNO063iXESkk21I2ETjTSQt9LS0EpWyy/ScXKP0Nd6F5YD1GVBHTeorpaZ85freaMghMHgW6DklTSJ1UNNo4kM0e56jBll6H8WumwoCez+EUoa2q+UcrcGrmjo+s/Mx2IhncYfTKTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Twzc+jyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Twzc+jyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF82FC4CEE9;
	Tue, 27 May 2025 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366744;
	bh=O+AWwT4JXkwEYQ7Vu7y7EH0iC1ZbzpLmDpu7uhUYG8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Twzc+jyQnLrfI9WYzWUVjp8xvmlRojIFuzkW7yU57ORBIqBIVwAm9H630xGMZWxml
	 5CzYsu+V2f9tS2DrurmAHKfqsuqhCmEizZKsWEi8NuJnU4bDAJIYZLo19XT/KWfSp1
	 63xMJexPYspEqKZRRW7/kH3MMUMgUQxzckJBLuFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 167/783] rtc: rv3032: fix EERD location
Date: Tue, 27 May 2025 18:19:24 +0200
Message-ID: <20250527162519.970470115@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



