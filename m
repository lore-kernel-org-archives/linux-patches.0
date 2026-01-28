Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A541510A1E;
	Wed, 28 Jan 2026 15:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614357; cv=none; b=ZFIZuJIqlZuRIpQj2J6E/zWCfQkUDSds6p3/vjmvwL0tUMss+XJXRBt7TUpJx8mhDD8vcygRXBjcTU0xZ/9+53cw3uzY8rsZGN3CQJnvVThtdFCofUTws+FTY4PMEAKlaW/mqPGlx2DgNgApdk0GbWoNDVldDZ5jqcc1XAXbtJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614357; c=relaxed/simple;
	bh=+00gDk0Jcfx5kEgIDAo9dbwKwfLV1wKt2ADYr/4K8iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvQwahrPCkxQv5dYxedIR/c9cdptnnDgv/a5Zi8KW6/NESv6K5rw+F/nakBnOhs/ueWn8R39zCk1p5ejBOAyhvUTopgvmj/xWIY/jeeFHdtXz6bTac1qH4g8ayyWVtbnSQUwmiZDxmdTCHPKbULWiuEUQpSXJy+WgNvfvBMlNNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYTqmBkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYTqmBkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EFBC4CEF1;
	Wed, 28 Jan 2026 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614357;
	bh=+00gDk0Jcfx5kEgIDAo9dbwKwfLV1wKt2ADYr/4K8iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYTqmBkgA1ig7NfefNxzpd8D5U+tivE1Z2OnGoPIaZIQYda5hnf8deOHEMwf2YHy9
	 /yA8akCMqubnGxsAYs9oIsdOZ0sGjb74S+YdjsdePO6bjQCcEAUIf2i7uhUzXNb08v
	 JrHX3BI7p9avLd0oAdTEaKEdo2KUikdQOQEwuyp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/254] dt-bindings: power: qcom,rpmpd: document the SM8650 RPMh Power Domains
Date: Wed, 28 Jan 2026 16:21:20 +0100
Message-ID: <20260128145348.568426649@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit d4d56c079ddd19293b11de1f2309add0b8972af2 ]

Document the RPMh Power Domains on the SM8650 Platform.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231025-topic-sm8650-upstream-rpmpd-v1-1-f25d313104c6@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 45e1be5ddec9 ("dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 1 +
 include/dt-bindings/power/qcom,rpmhpd.h                 | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index d38c762e12804..2803f7d568217 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -55,6 +55,7 @@ properties:
           - qcom,sm8350-rpmhpd
           - qcom,sm8450-rpmhpd
           - qcom,sm8550-rpmhpd
+          - qcom,sm8650-rpmhpd
       - items:
           - enum:
               - qcom,msm8937-rpmpd
diff --git a/include/dt-bindings/power/qcom,rpmhpd.h b/include/dt-bindings/power/qcom,rpmhpd.h
index 7c201a66bc691..0f6a74e099701 100644
--- a/include/dt-bindings/power/qcom,rpmhpd.h
+++ b/include/dt-bindings/power/qcom,rpmhpd.h
@@ -26,5 +26,6 @@
 #define RPMHPD_QPHY             16
 #define RPMHPD_DDR              17
 #define RPMHPD_XO               18
+#define RPMHPD_NSP2             19
 
 #endif
-- 
2.51.0



