Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6454F33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0E8C433D2;
	Mon, 16 Jan 2023 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884974;
	bh=+Xg6VNqi33GeaIkwSMykubx4nUmPRrWrWGFxFztmAHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjhXhm6IEMr86e7TZYhFtfIcMozWV+A9ZjZXXleaxlc5QJ9E2ZgvcFkpLowBFPY4z
	 cVw0WXvZgs3aFl3MhNbaX9j2qwrutKXdc+O2cDdbIGgvcnqFakMwKU/DuGVf2H/Czj
	 0EiFKvebMSKaKeBoub1SZ8sMeeQD8oZ6ZvhtPTTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 5.15 26/86] dt-bindings: msm: dsi-controller-main: Fix description of core clock
Date: Mon, 16 Jan 2023 16:51:00 +0100
Message-Id: <20230116154748.190806746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 654ffe4b793b42ed6b5909daff0b91809916d94e upstream.

There's a typo in describing the core clock as an 'escape' clock. The
accurate description is 'core'.

Fixes: 4dbe55c97741 ("dt-bindings: msm: dsi: add yaml schemas for DSI bindings")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/515938/
Link: https://lore.kernel.org/r/20221223021025.1646636-4-bryan.odonoghue@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
+++ b/Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml
@@ -31,7 +31,7 @@ properties:
       - description: Display byte clock
       - description: Display byte interface clock
       - description: Display pixel clock
-      - description: Display escape clock
+      - description: Display core clock
       - description: Display AHB clock
       - description: Display AXI clock
 


