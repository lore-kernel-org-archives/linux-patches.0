Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775B82222AA;
	Mon,  2 Jun 2025 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875680; cv=none; b=R1mfFQVkdyYE8Zznuuv0FhUhG7YhwHJC/vh1DF3YDWNG+dKyH9nP6BJbpSRY0wwUz93s0kLhoxDZrEJ+Pi8b27Wj/U1lTTvPHv6JUUAOCPRIjXFcGr3ZQs60yTWV2vLBV6KQ6krsm+XMeqCZFgWoA3YMc4Cx7KUL/mc0R/ESCG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875680; c=relaxed/simple;
	bh=qLwWEd0LiUws3xetmB5BkZhJJ3IkznMer0dVj8/11d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/cPCxxGf1eUXfqodHysOEVseAeV9g4JJUJzdkzYQOAxA37/g6FtOYwasmA3bCBXSCb24cbPOGpBSVjFu836CLjpJPxYTabdV5xiWp0iZWi4kxlUEbpCwzB1Gq49aJ93xXkQiul7oNbuAr4o/168CUWdj/EdLes0cThnr1Qhgf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHemiul+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHemiul+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2747C4CEEB;
	Mon,  2 Jun 2025 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875680;
	bh=qLwWEd0LiUws3xetmB5BkZhJJ3IkznMer0dVj8/11d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHemiul+rWiOCqpNBTtOrx1zPWsmmo9L2hW+YcGT+x79RUreq13rMHaOWNBvql6uD
	 PrV3/4bx+xSdikx1lIBvhWYGPI1/AHsYWv+PACe031f2IKHVvbQgDXTiqNLV5/fjj3
	 OyfO1g6OP1okurbTP3vBpoIFmZT1M7pMlybSfjnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/270] can: c_can: Use of_property_present() to test existence of DT property
Date: Mon,  2 Jun 2025 15:47:58 +0200
Message-ID: <20250602134315.089653588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ab1bc2290fd8311d49b87c29f1eb123fcb581bee ]

of_property_read_bool() should be used only on boolean properties.

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250212-syscon-phandle-args-can-v2-3-ac9a1253396b@linaro.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/c_can/c_can_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 8f0dde85e3da2..1e0bf3405394a 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -330,7 +330,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 		/* Check if we need custom RAMINIT via syscon. Mostly for TI
 		 * platforms. Only supported with DT boot.
 		 */
-		if (np && of_property_read_bool(np, "syscon-raminit")) {
+		if (np && of_property_present(np, "syscon-raminit")) {
 			u32 id;
 			struct c_can_raminit *raminit = &priv->raminit_sys;
 
-- 
2.39.5



