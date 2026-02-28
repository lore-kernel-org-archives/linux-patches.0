Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B5129E114;
	Sat, 28 Feb 2026 17:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301361; cv=none; b=jYOkWF0+eDKYqQS9pl2Udn8t8EUeF9pzHtH2rvmx4jQbYQchYboPJONuMHBsntdOOA+aeJ/x1LVQWjBHK9pyFOshl1PICLGn4mTAxEKq56olTea7GLj2TcnmsFtlQ9cBypPaUV/d54Vp6PRe39Z0uklArRuC3OrLFXSgNUrrEZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301361; c=relaxed/simple;
	bh=OeBiOH2MaUBz2DQS4qmVwqoVgLtnGrd+D6Gji32gUUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFCghGsAyzAhiHDGS9X7QXqShE+/mAUkorRTN+PI8AJ48jhF3gQ+mCeZFn4t+llJaiXq+uawiuC6n1he4tXTe4bGkL3/16o2/Sr5KyVJg9k504iGaF/gT6MuF+Owl9d2NeAGSI14FZFoJwCx8JEOfPi3dvm/M3JgPlSCdRB9+Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kp11pT4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kp11pT4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEB4C19425;
	Sat, 28 Feb 2026 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301361;
	bh=OeBiOH2MaUBz2DQS4qmVwqoVgLtnGrd+D6Gji32gUUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kp11pT4CcpznlEsSQAwYnwfHDG6T+PW7+J0lh7SMxnQOww9T+CzdWQLH3H0lNNudV
	 m0TTw1UakcauOfHvqydHvLDWIGPlWowIt/TLJrxIOwnpu2Nn0JBerrVdrfb1mRx8vO
	 VIVbUtYCEf7CyXNXN6CTHvWaDtadP5LcboidsnIuFyGs1iGY2KArU/ZgKzAgnNjh9Z
	 5Am29Vdp7Nge/jGB1W9L2xOTQmM+wv1KHJ0lgNpMzu0EHPsiNAGXTpHZxLliXeLLPX
	 jDPvM9TYV30jWLq7zjov8Ktn1o1NqKx9MtzP67jjLQOOqa9nXHJSV7DOhwAQdujgQX
	 PDHbqVNKMfw2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alain Volmat <alain.volmat@foss.st.com>,
	Stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 549/752] media: stm32: dcmipp: avoid naming clock if only one is needed
Date: Sat, 28 Feb 2026 12:44:20 -0500
Message-ID: <20260228174750.1542406-549-sashal@kernel.org>
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

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 2f130245f2143fa8f4da77071f844911d2c69319 ]

When DCMIPP requires only a single clock (kclk), avoid relying on its
name to obtain it. The introduction of MP25 support added the mclk,
which necessitated naming the first clock kclk. However, this breaks
backward compatibility with existing MP13 device trees that do not
specify clock names.

Fixes: 686f27f7ea37 ("media: stm32: dcmipp: add core support for the stm32mp25")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Cc: Stable@vger.kernel.org # 6.14.x: 7f487562af49 media: stm32: dcmipp: correct ret type in dcmipp_graph_notify_bound
Cc: Stable@vger.kernel.org # 6.14.x: c715dd62da30 media: stm32: dcmipp: add has_csi2 & needs_mclk in match data
Cc: Stable@vger.kernel.org # 6.14.x:
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-core.c b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-core.c
index 1b7bae3266c8d..49398d0777646 100644
--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-core.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-core.c
@@ -526,7 +526,12 @@ static int dcmipp_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	kclk = devm_clk_get(&pdev->dev, "kclk");
+	/*
+	 * In case of the DCMIPP has only 1 clock (such as on MP13), the
+	 * clock might not be named.
+	 */
+	kclk = devm_clk_get(&pdev->dev,
+			    dcmipp->pipe_cfg->needs_mclk ? "kclk" : NULL);
 	if (IS_ERR(kclk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(kclk),
 				     "Unable to get kclk\n");
-- 
2.51.0

