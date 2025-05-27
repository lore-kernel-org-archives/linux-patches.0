Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AC978F32;
	Tue, 27 May 2025 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365337; cv=none; b=jPD1F8wTW2VuBmup9FEz0KCWW5h6Shlp/Qgn++wB8FarcKeo7WH+2wKHVhfsY6HGsCAqesLA+vkKgLIfOHktnl5yiWQfGzNLi8L/5exj9zg4VOWwyRygbpfHTCkspTy0S/y5Zl76s3uSeDiRMLh1IbvJSlenIYtZZY7lXy59jR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365337; c=relaxed/simple;
	bh=eS4xTVFmjYWN+OGJVBaoFaXFmMBF1ExvLzmghaq1mTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDvDhxnACBZDUV/FmxkZyuiIh8FEbXY/OxFj/+FiEs00U/GWbPRALRMByU8iVB/o0UcVudoW9/euJqGkH9H4yw24D19I9vT4oSjOZzAjZoGdTzZuUsXjICRuIp0VoXXjrEh6Zkerg6Gt+uq/agB5iXRmMDUH7iNXC95yule/zs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfbUCSkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfbUCSkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A300EC4CEED;
	Tue, 27 May 2025 17:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365337;
	bh=eS4xTVFmjYWN+OGJVBaoFaXFmMBF1ExvLzmghaq1mTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfbUCSkDJfnw+7ebRVe/dFFcetVsn2p7QZN2nZed4W4sSe81N5coM37Z8lNMxq1rR
	 tuoZptINBDz8nwmNCTXq80bBRgUvS96dNHOLjuVqnjoZ8LP57TAnWFPphwBVUZVyrr
	 XCddzVqZnISGH2dj3oI6GIFPrBP1TK/gz/714mzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/626] can: c_can: Use of_property_present() to test existence of DT property
Date: Tue, 27 May 2025 18:23:55 +0200
Message-ID: <20250527162458.910670013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



