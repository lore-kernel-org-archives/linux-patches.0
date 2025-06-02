Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDFA230D0E;
	Mon,  2 Jun 2025 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876220; cv=none; b=Jf51Ud70WSFo8vgwP3TTEX6/LYJYLHl98RSIxMsVDnEB1NZxXfg9leiZ+DRu/dksG1kg3B9pSJQ2jl7D5QKTij67DhOpqupFr2SpO0JvjwEzYa2A25aNnBxPg6ritSUxpBdq1RMWjHHbyX3MWYZs7xG9LI6eU8dizwlKed/BTb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876220; c=relaxed/simple;
	bh=qv6qpCdalm8PfkBheaFurgR2DcgbOlTKQA0hXZRVMSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY3o5DcJHP03+vF8MfBK3sg4Nv0FtJDBa+5D77Fx911UtlEaKpXQPxA9liiRqXINglDBmMsERYIglkcsYsFQF/4Ye/9+6lh2swWRZUSjJj0+GXyrnKtN7ug/HscWaMJSLYM496m+Rkx+BwLyMSV3tJOWoemXwF0Qv8wwmOWEQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLBTGxqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLBTGxqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98376C4CEEB;
	Mon,  2 Jun 2025 14:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876219;
	bh=qv6qpCdalm8PfkBheaFurgR2DcgbOlTKQA0hXZRVMSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLBTGxqfpU1rrBSskVXBD+TBP0pJPUhx6yM9KDnz4HN9FywR8ut7Hw3V9rvRlPEf0
	 zFXLzVFcXwHw1IExgWfFWMYnj48nEnQ58DMS1tjfMmajzUpUigf1EOOAE/x6Df2GtW
	 4WGDlZfPjnzXWPOq+LdBpAcKVQkHccrYTOxK8kGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/207] can: c_can: Use of_property_present() to test existence of DT property
Date: Mon,  2 Jun 2025 15:48:01 +0200
Message-ID: <20250602134302.999754837@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c5d7093d54133..c29862b3bb1f3 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -334,7 +334,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 		/* Check if we need custom RAMINIT via syscon. Mostly for TI
 		 * platforms. Only supported with DT boot.
 		 */
-		if (np && of_property_read_bool(np, "syscon-raminit")) {
+		if (np && of_property_present(np, "syscon-raminit")) {
 			u32 id;
 			struct c_can_raminit *raminit = &priv->raminit_sys;
 
-- 
2.39.5



