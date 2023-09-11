Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515A61170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BA9C433C8;
	Mon, 11 Sep 2023 14:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441888;
	bh=/p5mMPAY7E+LuZwhJUH8AYOYE72wlgvSW7rnhTJEEQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rocttZmk568jxtizTgGSqQzW8cszPbW+cfUOKxqlzmkAWtS15D5LJvANtdibU3Wcc
	 aRaauy9VmKCzysYlYnx9AdXYo0ZzgCv2YlJjGuEz6wBT06kXpcWc8F+Tbg6yoO/7+d
	 uLNpCdfFN3m67zNGbO0t+x2zI83DivWRaEEkr4Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 571/739] dt-bindings: usb: samsung,exynos-dwc3: Fix Exynos5433 compatible
Date: Mon, 11 Sep 2023 15:46:10 +0200
Message-ID: <20230911134707.023339106@linuxfoundation.org>
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

From: Sam Protsenko <semen.protsenko@linaro.org>

[ Upstream commit 26f4f8358d89c0d9972a30abdb3f3a425ef49e38 ]

The correct compatible for Exynos5433 is "samsung,exynos5433-dwusb3".
Fix the typo in its usage.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Fixes: 949ea75b7ba4 ("dt-bindings: usb: samsung,exynos-dwc3: convert to dtschema")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230816201123.3530-1-semen.protsenko@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml b/Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml
index e61badb61b35a..deeed2bca2cdc 100644
--- a/Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/samsung,exynos-dwc3.yaml
@@ -72,7 +72,7 @@ allOf:
       properties:
         compatible:
           contains:
-            const: samsung,exynos54333-dwusb3
+            const: samsung,exynos5433-dwusb3
     then:
       properties:
         clocks:
-- 
2.40.1



