Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F2FBEF;
	Tue, 25 Jun 2024 09:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308115; cv=none; b=Q/UAbtr+tiyj2M3hH9kKuONeNE7MrFATZjAT7EavRGDZzkjeItEn1pt968UfL5GXOKBmRevsJGsUNvK3wo394QtM15YlEcqt7HhNxJ+FjPrTICLwJJqQ1ItxTheavhUfuzV6S3D+v5qVxeDxlbnQBJnL+qCzZUhwDt/Fhcs2A68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308115; c=relaxed/simple;
	bh=kaLCKwalu0IWl14KY0sUMxkNFXb3Gok32IYX25UN4W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM+oHzPb8BmfMsKJVWprtjea5Kx6nzEPrVbIoG9SKFuwil4jEkteM2qf0XPyM0Ndv8NpkzPwRWVMAYMKVg8YBptCznDQYM08CSKn7Gw/aAhY1YsHgLXSeGZAdwFoLcwIAgHXSdxlUkuuipy/cqq0gRsGyvTjTx+hWhe5nQQXLGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQQDjx60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQQDjx60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D85C32781;
	Tue, 25 Jun 2024 09:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308114;
	bh=kaLCKwalu0IWl14KY0sUMxkNFXb3Gok32IYX25UN4W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQQDjx6001rLpYO/52R28hG39Zq5Pn/VtIsLQJvQJbqe/QS//Hlu5RtZd7o4FbRU0
	 lMC4wT/GCDjr1W+BcPjh1XV+CafuD/phg8Zmjjw56M3QipDMTBY9gmP0OS5BS5Qewv
	 J9fkxZC/Qo5FAp4m/BwGnQaCeqsIiv+LUpdwrwr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 012/250] arm64: defconfig: select INTERCONNECT_QCOM_SM6115 as built-in
Date: Tue, 25 Jun 2024 11:29:30 +0200
Message-ID: <20240625085548.515809185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b052c7fe3cb787282ab7e1fa088c794a1eb7fdb0 ]

Enable CONFIG_INTERCONNECT_QCOM_SM6115 as built-in to enable the
interconnect driver for the SoC used on Qualcomm Robotics RB2 board.
Building as built-in is required as on this platform interconnects are
required to bring up the console.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240424-enable-sm6115-icc-v3-1-21c83be48f0e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 2c30d617e1802..8d39b863251b2 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1585,6 +1585,7 @@ CONFIG_INTERCONNECT_QCOM_SC8180X=y
 CONFIG_INTERCONNECT_QCOM_SC8280XP=y
 CONFIG_INTERCONNECT_QCOM_SDM845=y
 CONFIG_INTERCONNECT_QCOM_SDX75=y
+CONFIG_INTERCONNECT_QCOM_SM6115=y
 CONFIG_INTERCONNECT_QCOM_SM8150=m
 CONFIG_INTERCONNECT_QCOM_SM8250=y
 CONFIG_INTERCONNECT_QCOM_SM8350=m
-- 
2.43.0



