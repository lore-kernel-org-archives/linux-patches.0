Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEEC42A9B;
	Tue, 27 May 2025 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367630; cv=none; b=FT8u3itqLQiaewRDZA+j++jGCoeMwZo2o4Ud7Y/wI6fO0Cm9F37KAc794vxb5ZUe8UUzWN7u9AxPr8DwSB8Bsmf1HcJ7kOfybujnZNRxo2wNmuEuRRSAnuhdNnCh9a8Gx1GEr7F6LXkjVZ/TK9TTBjNSwUa5j7T/hYEo6oDaS5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367630; c=relaxed/simple;
	bh=tmJgFD81VBaWskebJjjlOvHOiGJ/PYKeqcxSggmNPlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlOQJ8ARzROuoXnqnDrbIqCPxwanPcgsJSAv3vmz6EE83oBSeuDXaEhE+TArHTwWy8xYnBm8duH5L50tZUCN6oy64b9QjyBnuJDK7kmPT9Le3aMl+gUFNbXknCELB00jP5E/iCMZrV4b/ZBX6vasfnwGPPAIvoe4L7XyCJcyOJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaChRVpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaChRVpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F79FC4CEE9;
	Tue, 27 May 2025 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367629;
	bh=tmJgFD81VBaWskebJjjlOvHOiGJ/PYKeqcxSggmNPlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaChRVpWvqgMOPChSfAh8RS6CLltC2htr1gmYN91WAwvfu48HNallWHpaR4eb9VSZ
	 /6247v1LtppPNXQxV51AHtfJmXz2CdVFA2LB8RSXE4WxvbFS+vP6/VCmXoTPpWfG5L
	 6SsBCZSy1B+4CLyzI9wZZeEMVhWdt/bPrHB+7qBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 419/783] can: c_can: Use of_property_present() to test existence of DT property
Date: Tue, 27 May 2025 18:23:36 +0200
Message-ID: <20250527162530.161403148@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 399844809bbea..bb6071a758f36 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -324,7 +324,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 		/* Check if we need custom RAMINIT via syscon. Mostly for TI
 		 * platforms. Only supported with DT boot.
 		 */
-		if (np && of_property_read_bool(np, "syscon-raminit")) {
+		if (np && of_property_present(np, "syscon-raminit")) {
 			u32 id;
 			struct c_can_raminit *raminit = &priv->raminit_sys;
 
-- 
2.39.5



