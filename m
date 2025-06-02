Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D761E3772;
	Mon,  2 Jun 2025 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873668; cv=none; b=jreQ1u2UOHF3bAHr7JLWuGsqOipGNf6WUYRE5dwsmpYRcnBkAZMhILD7UEhQdkrTNCLWNwzszt1mv/H7M/IaQt5DfH+ipNG/ZXP8UHH+q2rCkapHGcYlmEKcnEI+yVW3LJEWa0NC1QaaHIQ6yR5EOt0j5smrDk0tkwNiHhGsDPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873668; c=relaxed/simple;
	bh=zrdEv7S8KJnFIpPrvvDZKKAaUylDKaJOzzqgVl1Gwrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoJRkjvq6BTzNmL9jY9BB3cyG05pYILPtgtY1KWnncn1dLnfSL1e9d6cvJe2xjv3ovUQEzdfU0v2d1y8k5d9IipmVF2yn8xzKxzAQ2ipxd4mzvETaQ6hJ2xluMHASy/4G9OWtwj+z+RmcIYg5SocpQ14RE7LInHXRuZC+g5RJzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAjmQQMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAjmQQMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AEEC4CEEB;
	Mon,  2 Jun 2025 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873667;
	bh=zrdEv7S8KJnFIpPrvvDZKKAaUylDKaJOzzqgVl1Gwrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAjmQQMUsZju2rbfjNb0AVBA3N6usbCh7GHJDuRyiDH8TfQMQH21pB+veWDRAAz/Q
	 9MdOzgEYuw6BObSt5JxX6QK2DLdqkrsDc5Di9+zXxivYbu3nL/L8v9IhzjhrjRRg8O
	 ihi4L1St9dx/+y9pVfUo5sMN2SJIX1TI9dqgBRgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/444] can: c_can: Use of_property_present() to test existence of DT property
Date: Mon,  2 Jun 2025 15:44:38 +0200
Message-ID: <20250602134349.594674202@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7f405bcf11c23..603680792f1ff 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -333,7 +333,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 		/* Check if we need custom RAMINIT via syscon. Mostly for TI
 		 * platforms. Only supported with DT boot.
 		 */
-		if (np && of_property_read_bool(np, "syscon-raminit")) {
+		if (np && of_property_present(np, "syscon-raminit")) {
 			u32 id;
 			struct c_can_raminit *raminit = &priv->raminit_sys;
 
-- 
2.39.5



