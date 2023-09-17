Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21386FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17102C433C7;
	Sun, 17 Sep 2023 20:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980899;
	bh=QoTljnFxla4At3mzawmjLwi1Y8Kn9ePbgWrYcL9baIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgpx4bwAvX4nX0+9z462tg2nMUz9T2TCtGWvsrvgLc6HhrvKCTmM1C/LCQXYw4TkO
	 rBXDop2Sni9Ual+nmeY0cjcFxV9fRdMDmAy2ow7vHi3ewPd3kk5BMjAHFWSAJ1Ufo+
	 cRLcP2+hBtv1pOGSmepdiFPJ8lj48vTTtc0Zo9bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.1 040/219] dt-bindings: clock: xlnx,versal-clk: drop select:false
Date: Sun, 17 Sep 2023 21:12:47 +0200
Message-ID: <20230917191042.447858376@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 172044e30b00977784269e8ab72132a48293c654 upstream.

select:false makes the schema basically ignored and not effective, which
is clearly not what we want for a device binding.

Fixes: 352546805a44 ("dt-bindings: clock: Add bindings for versal clock driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230728165923.108589-1-krzysztof.kozlowski@linaro.org
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/clock/xlnx,versal-clk.yaml |    2 --
 1 file changed, 2 deletions(-)

--- a/Documentation/devicetree/bindings/clock/xlnx,versal-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/xlnx,versal-clk.yaml
@@ -16,8 +16,6 @@ description: |
   reads required input clock frequencies from the devicetree and acts as clock
   provider for all clock consumers of PS clocks.
 
-select: false
-
 properties:
   compatible:
     const: xlnx,versal-clk


