Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110A9522A;
	Wed,  5 Feb 2025 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765669; cv=none; b=dMQQHVRLJA6wLcKhQHoOnEVKCjsryGM/k+p49ZnKJzO/kScY7KykzdpE8WovPPbZSOCbMTYdE8sOZ3JO6zOnTzIPAQ847w6+SrZ7uEg1Kp35NTPmn4YrzxBYpziuShOfgYIVC761cNCXmdBZSowVMxqKV5j9PLTwyRYYveMBLXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765669; c=relaxed/simple;
	bh=xYZUICL9PfYkA30X2LLJKsc7Fs3Wyg79TjgXwfUldjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfmrJdYsy8ETnLzJHD9ZUfwDVj3xBjPOucxEscfQBKBtsEm5sy62Djl4m+WDaByoU1AhjhpYY/ayECLv6XD9lI3Heni9/0mzbSKtBwLvQcDXtCXK/lMQDqQUJzxmNELF2rfMgz3C+X73ah31mI83L8x8arPz0md8KuMAJDc8CUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xv6L+xUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xv6L+xUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C85C4CED1;
	Wed,  5 Feb 2025 14:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765668;
	bh=xYZUICL9PfYkA30X2LLJKsc7Fs3Wyg79TjgXwfUldjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xv6L+xUPXtCZMnFEyMCTzuYH+C08lADPncGVo1AGmMYIYXCacMDyLtGvMuUKYemAr
	 fR0NOftcjJpal7Il55/6YGosE/GznSKVcZuUlz65tA+BYFe7OSzcbNuLVfJG+CwD05
	 iGL9SsiUJJl6uJH166XAePvLe4pIt1kHxKemxXFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/393] media: mipi-csis: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:43:27 +0100
Message-ID: <20250205134431.331736479@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 125ad1aeec77eb55273b420be6894b284a01e4b6 ]

Add check for the return value of clk_enable() to gurantee the success.

Fixes: b5f1220d587d ("[media] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/exynos4-is/mipi-csis.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/mipi-csis.c b/drivers/media/platform/samsung/exynos4-is/mipi-csis.c
index 686ca8753ba22..87c6fb88ab920 100644
--- a/drivers/media/platform/samsung/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/samsung/exynos4-is/mipi-csis.c
@@ -940,13 +940,19 @@ static int s5pcsis_pm_resume(struct device *dev, bool runtime)
 					       state->supplies);
 			goto unlock;
 		}
-		clk_enable(state->clock[CSIS_CLK_GATE]);
+		ret = clk_enable(state->clock[CSIS_CLK_GATE]);
+		if (ret) {
+			phy_power_off(state->phy);
+			regulator_bulk_disable(CSIS_NUM_SUPPLIES,
+					       state->supplies);
+			goto unlock;
+		}
 	}
 	if (state->flags & ST_STREAMING)
 		s5pcsis_start_stream(state);
 
 	state->flags &= ~ST_SUSPENDED;
- unlock:
+unlock:
 	mutex_unlock(&state->lock);
 	return ret ? -EAGAIN : 0;
 }
-- 
2.39.5



