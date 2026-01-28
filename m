Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CEF10A1E;
	Wed, 28 Jan 2026 15:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614445; cv=none; b=fVmTTgplv5O8YxF2Wz9Q8PTMOEtn84i51vCpZViHMQKiTAYt3wrC6nRlZsVxOHmOzXPlooRTNBuz947zWvXE2sFg32dsvUgUzGKg2W7tAdKH1ik1fOowxnEZNie/WzJmxu4WBTZmb56c6t/Px4E4guW+GfA1NW2ZzwkPSKbMPLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614445; c=relaxed/simple;
	bh=1trv7aExHzW1zhCiuAw2l6sVjeOkSUPkm33CneWEWAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw4igylO+ll3d/Rl7lTbbvpmwpSGEm+QR2kzQKlrVFORM6GqXw0EtF+SRxGhQ/OfxzewQBCjAyaqvNumMy2bCQXf2C1hco4+gEHxzOj0doGbimCWDXmVnnYjMKsuiOfwZ+0UhOW7rzvZL8S+DYuFKkQ8ybLr0/ymtDvlFxiteXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEWv3C31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEWv3C31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA074C4CEF1;
	Wed, 28 Jan 2026 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614445;
	bh=1trv7aExHzW1zhCiuAw2l6sVjeOkSUPkm33CneWEWAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEWv3C313x1R7FhOVA9IB/5cqRCAt+YjfBYqno8fEJwOvOZJMyJ5lKag/028W/+x9
	 SI0d4paD72d2J4bcX2l57KnFGboEBEVvYUQU9KPktZ4EZhjXTorEJW7ha0mK2LThTg
	 n08/KFzpRTmOSvpcrFbhBlWVcmzSN19juRfywAUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/254] dt-bindings: power: qcom,rpmpd: add Turbo L5 corner
Date: Wed, 28 Jan 2026 16:21:23 +0100
Message-ID: <20260128145348.675885994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 1c402295c10891988fb2a6fc658e6e95d4852a20 ]

Update the RPMH level definitions to include TURBO_L5 corner.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/661840/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Stable-dep-of: 45e1be5ddec9 ("dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/power/qcom-rpmpd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/power/qcom-rpmpd.h b/include/dt-bindings/power/qcom-rpmpd.h
index ced784a8afc12..73b3655155ec0 100644
--- a/include/dt-bindings/power/qcom-rpmpd.h
+++ b/include/dt-bindings/power/qcom-rpmpd.h
@@ -240,6 +240,7 @@
 #define RPMH_REGULATOR_LEVEL_TURBO_L2		432
 #define RPMH_REGULATOR_LEVEL_TURBO_L3		448
 #define RPMH_REGULATOR_LEVEL_TURBO_L4		452
+#define RPMH_REGULATOR_LEVEL_TURBO_L5		456
 #define RPMH_REGULATOR_LEVEL_SUPER_TURBO 	464
 #define RPMH_REGULATOR_LEVEL_SUPER_TURBO_NO_CPR	480
 
-- 
2.51.0



