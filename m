Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568433B8BB9;
	Tue, 21 Jul 2026 18:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660373; cv=none; b=h6UEmwr/JbBrBDJer5vhfxqoZ3CdcYP5ebewcHr5k6wIhxvJEYY3B6iRxedns37kZRELwlmPirZgZvQu9Z+QPiPPQqvbeALgTqTBCMQOFpvVJTE10mQO6TYLRAQs+DOEL+T2XH517cdXpJM/Xp9IAGGPuad6cr4vkfqIAyXNHJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660373; c=relaxed/simple;
	bh=K67oi1StmYSHstDP7c3j9GA2zKx9IPjnHfG9yiVzVhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB7erpmZb+52Alcked2Bb/vlJ5clHcqdanEySNZmT9JFxS6RTeg4kMAdgj/3OsYUec4Wr1GLXNSrJqToNe+vGUv2on9tSy0Gyyx0BqdNncvTGH+BEHCgQZd3PuyTPAV0mVWYYhez1LXGocE/04qq5sF5ivTW6eS/kGQftZTDF3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckLsJFYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckLsJFYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B761C1F00A3A;
	Tue, 21 Jul 2026 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660372;
	bh=BENit96ZXILQPycXJJkAAfQDjy+375zueZ+G29dSX7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckLsJFYSPR8Birng/UuqIuyxqFVUrRMbkksRcD0r2xl/RWXIqIQChD48E3Qi2UriH
	 Rcy0/8iu1Rdq097NfNQMTNyJkPBI4FrRvCwCwb4yoeEx0360SzcfWmvxHyGugucWQP
	 fT+4kVQUkOsyRjqQVILLBg1hZjieyXyYNjSIDyqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0954/2077] dt-bindings: clock: qcom: Add X1P42100 camera clock controller
Date: Tue, 21 Jul 2026 17:10:27 +0200
Message-ID: <20260721152615.320745906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 97a5e120be5d3d7cf7d221b8703921046b73f0d2 ]

Add X1P42100 camera clock controller support and clock bindings
for camera QDSS debug clocks which are applicable for both X1E80100
and X1P42100 platforms.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260507-purwa-videocc-camcc-v5-2-fc3af4130282@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 1e6ae74ac6f2 ("clk: qcom: camcc-x1e80100: Add support for camera QDSS debug clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/clock/qcom,x1e80100-camcc.yaml         | 1 +
 include/dt-bindings/clock/qcom,x1e80100-camcc.h                | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,x1e80100-camcc.yaml b/Documentation/devicetree/bindings/clock/qcom,x1e80100-camcc.yaml
index 938a2f1ff3fca8..b28614186cc098 100644
--- a/Documentation/devicetree/bindings/clock/qcom,x1e80100-camcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,x1e80100-camcc.yaml
@@ -23,6 +23,7 @@ properties:
   compatible:
     enum:
       - qcom,x1e80100-camcc
+      - qcom,x1p42100-camcc
 
   reg:
     maxItems: 1
diff --git a/include/dt-bindings/clock/qcom,x1e80100-camcc.h b/include/dt-bindings/clock/qcom,x1e80100-camcc.h
index d72fdfb06a7c71..06c316022fb0d2 100644
--- a/include/dt-bindings/clock/qcom,x1e80100-camcc.h
+++ b/include/dt-bindings/clock/qcom,x1e80100-camcc.h
@@ -115,6 +115,9 @@
 #define CAM_CC_SLEEP_CLK_SRC					105
 #define CAM_CC_SLOW_AHB_CLK_SRC					106
 #define CAM_CC_XO_CLK_SRC					107
+#define CAM_CC_QDSS_DEBUG_CLK					108
+#define CAM_CC_QDSS_DEBUG_CLK_SRC				109
+#define CAM_CC_QDSS_DEBUG_XO_CLK				110
 
 /* CAM_CC power domains */
 #define CAM_CC_BPS_GDSC						0
-- 
2.53.0



