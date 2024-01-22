Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D1514A4FE;
	Tue, 23 Jan 2024 00:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969238; cv=none; b=n46CXZSSJN3q/MDmBEtLujH4TKCQ189PP7DpbANCj+0NTXcm8xcddMotwxkUCc0GTBEMwJB3rcHwvnbkpAiVBe4pC2TMvbG/UsWyzZKq0QflZbzz2fVb7M5HnULNIohWz1qlM7/pKNEmtD9VF0CYtdBKj4+n4GEiyj6ktcChRE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969238; c=relaxed/simple;
	bh=5ZrnJWralw1O7SJ0dGSXnluH3064xayKzAtQFH/ieqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLJ5oBjL11dIb6F7sKdRd1d09RHNmJ4RRk8/pMIt9h5Qx6hTZIJ17M6zOB+XEjkFxIa6hjbuoki8IzDASKb4CQBbraTgpCvXZKO/bV8fs7Zcxf0PPxU5BJl1nW+hIWgH3PnF5hysnaeIO5gk6d9hlTJJRLraFRZhc05e2xL8bqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8obxM+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8obxM+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B768C433F1;
	Tue, 23 Jan 2024 00:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969237;
	bh=5ZrnJWralw1O7SJ0dGSXnluH3064xayKzAtQFH/ieqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8obxM+mQIsAk3aS4zKuvrT+OuDZiLKkUrWX+IHoBHAhUwDFgmFdrsjlmAQI2jTf0
	 DWjuwCWVxaXJ9e2Th0cHrOt24MAtiDOY1lHi1Lv0o2I2SkGdQxbvCj+4DAF3XMKgai
	 vbOFW/yXJnj7Xf/rjUveIj7eqFhllDReXArCqyow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre TORGUE <alexandre.torgue@foss.st.com>,
	Yanteng Si <siyanteng@loongson.cn>,
	Jonathan Corbet <corbet@lwn.net>,
	Douglas Anderson <dianders@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 119/641] dt-bindings: arm: qcom: Fix html link
Date: Mon, 22 Jan 2024 15:50:23 -0800
Message-ID: <20240122235821.776775879@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 3c3fcac8d3b1b0f242845c3b3c3263bd38b3b92f ]

This link got broken by commit e790a4ce5290 ("arm: docs: Move Arm
documentation to Documentation/arch/") when the doc moved from arm/ to
arch/arm/. Fix the link so that it can continue to be followed.

Fixes: e790a4ce5290 ("arm: docs: Move Arm documentation to Documentation/arch/")
Cc: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20231129030443.2753833-1-swboyd@chromium.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 7f80f48a0954..8a6466d1fc4e 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -138,7 +138,7 @@ description: |
   There are many devices in the list below that run the standard ChromeOS
   bootloader setup and use the open source depthcharge bootloader to boot the
   OS. These devices do not use the scheme described above. For details, see:
-  https://docs.kernel.org/arm/google/chromebook-boot-flow.html
+  https://docs.kernel.org/arch/arm/google/chromebook-boot-flow.html
 
 properties:
   $nodename:
-- 
2.43.0



