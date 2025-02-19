Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230581DEFF9;
	Wed, 19 Feb 2025 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956483; cv=none; b=GzM9CUx2hlMrNPZ+87I/UNShTTM0jhHmiBuweF3SP0HstYG54V6lThQ+iYMnosD9fDJFPKfBR8DJZdMgyPmPb/r2U9EC1A8mHlcZcEh0LRaFNanOgbBhE7Ls5GHllurkTfxNjGGhq9WDyg1o64o6mpEzLEvWTUGMAvKbAGk+Mu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956483; c=relaxed/simple;
	bh=0Sk6jn4rX4hG23zMk22GwDRjLTqPRnbYHgUjNm7I3js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMXLD74Ds3fDK/um0G7I3GXRV5j1IToNCSdP2nLytE5RTh8mMRJQsA3fvpengsf3o/j/JO25MxXr56xob77+QSYuBiBWiRefFX8hpp8MMNZHjAr1lhISN9T5ahGhWUdvUYslisrPrN/2lBLg1KVWkgnBi0Ln2/lhy4Qq8h8wpBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDdNQ6b4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDdNQ6b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5AFC4CED1;
	Wed, 19 Feb 2025 09:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956483;
	bh=0Sk6jn4rX4hG23zMk22GwDRjLTqPRnbYHgUjNm7I3js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDdNQ6b4M1Ufpa3+vAWmBr3Rt5AQvacI6Z1i11Dyn7sjJONAMpuRKFWYjZXPw6Oaw
	 yFE0v3iMDtV5I0RrloBH/mc/v2n0x2XsgoyFgAuvCf4uJlDawEcvIhkMNZ5NbSBG9S
	 2fUNeXdfDAWPVHUaQJau8WSTFhZdvpgvSXTt12Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/578] media: mipi-csis: Add check for clk_enable()
Date: Wed, 19 Feb 2025 09:23:18 +0100
Message-ID: <20250219082700.591624761@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6a0d35f33e8c6..f308ef6189863 100644
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



