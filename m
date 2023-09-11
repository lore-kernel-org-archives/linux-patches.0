Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E744D1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEB9C433C8;
	Mon, 11 Sep 2023 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441885;
	bh=91sQcF9Ly1eNrxGBSAlnQDD3ZzoQNu92ubCYxyDX7oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptm/2OZmk488OLlyEa1CZzs3RT/KmLF9J8ouxS7+PZSg+Xp0RgXmi7MTbao6QpjaQ
	 aXV5/cn3SgRPdHAthC4AxYPqu7Ol+YkfAvXotoOCvnvB18M9nCilPSre1BzXT+5fNs
	 inxua1Ga1tReQ2TmjEwX3j0VJ9zRKZbpAWlUUSEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 570/739] dt-bindings: usb: samsung,exynos-dwc3: fix order of clocks on Exynos5433
Date: Mon, 11 Sep 2023 15:46:09 +0200
Message-ID: <20230911134706.995200583@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 8d4ff1351801bd646c9fed7aedb9705250f2c87b ]

The Exynos5433 DTSI had always different order of DWC USB3 controller
clocks than the binding.  The order in the binding was introduced in the
commit 949ea75b7ba4 ("dt-bindings: usb: samsung,exynos-dwc3: convert to
dtschema") converting to DT schema.  The Linux driver does not care
about order and was always getting clocks by name.  Therefore assume the
DTS is the preferred order and correct the binding.

Fixes: 949ea75b7ba4 ("dt-bindings: usb: samsung,exynos-dwc3: convert to dtschema")
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Link: https://lore.kernel.org/r/20230818102911.18388-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml b/Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml
index 42ceaf13cd5da..e61badb61b35a 100644
--- a/Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml
@@ -82,8 +82,8 @@ allOf:
           items:
             - const: aclk
             - const: susp_clk
-            - const: pipe_pclk
             - const: phyclk
+            - const: pipe_pclk
 
   - if:
       properties:
-- 
2.40.1



