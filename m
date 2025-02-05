Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B359F1519AA;
	Wed,  5 Feb 2025 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764966; cv=none; b=WYJE+21fNA/7X1XDfiCeu2BpxGlVcTmcYdqX9MQu4CJEOMew9FQs/mrsvGyrt9Qx4dCKV5teAq7oOrSeuRsmXAPbVFP7iLDLYBBtJ6zuNl78brW6j77+XMS9CiuIkhc3CNCOioNaGRpeEv0yn+Cc041d3zcsLrZVpJI8iN3nPbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764966; c=relaxed/simple;
	bh=Ya6jabkHZ0XB2uhaSH9p8qpwJ17/+m+C4vCE4IMK9Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoxOGLygVPiDa4B4qahmmF68++8DtoYln58MMcdoKStpB64qsIcnZaiPNCeUZZVqy2j0ggf8F+O2JUPj9YJXzJEBl+/nm0MCYh2EXWr9GdjMlIFnukvuoXtXT4L/okZdzKCu5wAoxQVbjQEI12fR60Qovs5kC5QqPdE+WtQ0JQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTitCohN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTitCohN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1345C4CED1;
	Wed,  5 Feb 2025 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764966;
	bh=Ya6jabkHZ0XB2uhaSH9p8qpwJ17/+m+C4vCE4IMK9Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTitCohNssHcyzyOaSkCTYrqmWzlE4gF3Gw/egEvXmefnjEeWvaFeQPSHTX7mUKwo
	 s5WprgsFJR+EgHzN7NIP/EgdTnEL+D5eJrdd250KZWkluI93hD5T2TH1DF4QVYZK/P
	 PYHLDWbPx2A0OC8FLSYXDASrLNVcP2k84t9YpKNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 131/623] dt-bindings: clock: imx93: Add SPDIF IPG clk
Date: Wed,  5 Feb 2025 14:37:53 +0100
Message-ID: <20250205134501.240998376@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 32e9dea2645fa10dfa08b4e333918affaf1e4de5 ]

Add SPDIF IPG clk. The SPDIF IPG clock and root clock
share same clock gate.

Fixes: 1c4a4f7362fd ("arm64: dts: imx93: Add audio device nodes")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241119015805.3840606-2-shengjiu.wang@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/imx93-clock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/imx93-clock.h b/include/dt-bindings/clock/imx93-clock.h
index 6c685067288b5..c393fad3a3469 100644
--- a/include/dt-bindings/clock/imx93-clock.h
+++ b/include/dt-bindings/clock/imx93-clock.h
@@ -209,5 +209,6 @@
 #define IMX91_CLK_ENET2_REGULAR     204
 #define IMX91_CLK_ENET2_REGULAR_GATE		205
 #define IMX91_CLK_ENET1_QOS_TSN_GATE		206
+#define IMX93_CLK_SPDIF_IPG		207
 
 #endif
-- 
2.39.5



