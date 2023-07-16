Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F318F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AECBC433C7;
	Sun, 16 Jul 2023 20:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540495;
	bh=Dr127yvcE77Ap6Ci6GNJeIIif9hHu6W3bkp0B4tEWKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnGdoIhJsTvwiqPxIg4kJfLtBhnz/zOsoeRNl4n7RRKHma9+vY0SYpy+mGB7/ekvx
	 XKEOe57nZk7oKwHDYDqBs65mfIAuP35Ov0btPFV4lPuAVYGS/qgoFb6UfOpZX9mBvd
	 hWLqyF4c7IaGeXq6dwlywDvxatEeowk5SIG8xnXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 384/591] dt-bindings: power: reset: qcom-pon: Only allow reboot-mode pre-pmk8350
Date: Sun, 16 Jul 2023 21:48:43 +0200
Message-ID: <20230716194933.855685517@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit d41dab4c031edaa460a484113394327aa52dc0bd ]

As pointed out by Shazad [1], PMICs using a separate HLOS+PBS scheme
(so PMK8350 and newer) are expected to pass reboot mode data through SDAM,
as the reboot mode registers are absent in the HLOS reg space.

Limit the reboot-mode.yaml inclusion to PMICs without a separate PBS
region.

[1] https://lore.kernel.org/linux-arm-msm/12f13183-c381-25f7-459e-62e0c2b19498@quicinc.com/

Fixes: 03fccdc76dce ("dt-bindings: power: reset: qcom-pon: Add new compatible "qcom,pmk8350-pon"")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/power/reset/qcom,pon.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/power/reset/qcom,pon.yaml b/Documentation/devicetree/bindings/power/reset/qcom,pon.yaml
index d96170eecbd22..0b1eca734d3b1 100644
--- a/Documentation/devicetree/bindings/power/reset/qcom,pon.yaml
+++ b/Documentation/devicetree/bindings/power/reset/qcom,pon.yaml
@@ -56,7 +56,6 @@ required:
 unevaluatedProperties: false
 
 allOf:
-  - $ref: reboot-mode.yaml#
   - if:
       properties:
         compatible:
@@ -66,6 +65,9 @@ allOf:
               - qcom,pms405-pon
               - qcom,pm8998-pon
     then:
+      allOf:
+        - $ref: reboot-mode.yaml#
+
       properties:
         reg:
           maxItems: 1
-- 
2.39.2



