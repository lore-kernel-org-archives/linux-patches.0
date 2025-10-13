Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667233126A4;
	Mon, 13 Oct 2025 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368211; cv=none; b=UBBVoeR6eR92kq6lJw2t+aPDuEBbDkfpnkhKFSzHpNRvfckvmQ1HlOb/QaHqemwSG+iCg/1e2rI+6F9+rCXKsDT+S+TSIc8LlpwI32RL74oZRDWB7IbKbwEoILrxfKoz3OJ2n+S6sJZy+WPG6H9DjszB54ull3btUYTMeJpJijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368211; c=relaxed/simple;
	bh=eC4JGsw2uyLirOx093vRHvLhbFcFn7C4JLDHz40Yj7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1JuMCVLx0jwNd/eul2eO6D1AmMy0llu+c0QfB1tQyaoQWJUMc8UtuMvVXFpNkgAZ1HanPM8Z/NHaq5dOoPrJDHt7eoV7sjO4n/3+y50jyomJun0DCvu9Iy8xNc5OkqMCivzFD3xHAOtLjOLERwsSRz8A33AzsRUNENV6BfE80A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTsHDwJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTsHDwJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB75AC4CEE7;
	Mon, 13 Oct 2025 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368211;
	bh=eC4JGsw2uyLirOx093vRHvLhbFcFn7C4JLDHz40Yj7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTsHDwJA6GtQmQrjbwTXgJ7ZCFg9ikDrYFYdwmL6UU3dGaC/3BsqYDDROE+l/T35V
	 1ajGZG6bqPjIOiG18uqhNqloz1KLfH/8jjbb523IzS/CxpINU1A7uDvFjEue+q2NVY
	 7rtmfB+/9mDIcvncwGrPobxCWlqewuZbTfU7/x5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/262] thermal/drivers/qcom: Make LMH select QCOM_SCM
Date: Mon, 13 Oct 2025 16:43:45 +0200
Message-ID: <20251013144329.117467872@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 57eda47bd14b0c2876f2db42e757c57b7a671965 ]

The QCOM_SCM symbol is not user-visible, so it makes little sense to
depend on it. Make LMH driver select QCOM_SCM as all other drivers do
and, as the dependecy is now correctly handled, enable || COMPILE_TEST
in order to include the driver into broader set of build tests.

Fixes: 9e5a4fb84230 ("thermal/drivers/qcom/lmh: make QCOM_LMH depends on QCOM_SCM")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20250728-lmh-scm-v2-1-33bc58388ca5@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/Kconfig b/drivers/thermal/qcom/Kconfig
index 2c7f3f9a26ebb..a6bb01082ec69 100644
--- a/drivers/thermal/qcom/Kconfig
+++ b/drivers/thermal/qcom/Kconfig
@@ -34,7 +34,8 @@ config QCOM_SPMI_TEMP_ALARM
 
 config QCOM_LMH
 	tristate "Qualcomm Limits Management Hardware"
-	depends on ARCH_QCOM && QCOM_SCM
+	depends on ARCH_QCOM || COMPILE_TEST
+	select QCOM_SCM
 	help
 	  This enables initialization of Qualcomm limits management
 	  hardware(LMh). LMh allows for hardware-enforced mitigation for cpus based on
-- 
2.51.0



