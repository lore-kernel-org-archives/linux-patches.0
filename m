Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3EA1D0B87;
	Wed,  2 Oct 2024 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880612; cv=none; b=PJ7D9Hgs2f1YRMPCGw1vSqTwW7Fsupp67lPmE60wpsDeLiG55Uq0uUv7bVCNm6eyvDpar0EFuuUuQp/WL63+cjgW8xR1+kLAXj3n95s+Gfijb4mfax0OYvY+8maVCQCXmbn7V8H3aoaCXVilZ5QL3ea4k2jCESYaHodQ4Ws8Wwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880612; c=relaxed/simple;
	bh=58ouqHDrfp3olj8EuRaXwfzkmZtwEreN6CcGNxlxPa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqBW3USygHDMNBpkPL/r4xHhYVccMLcEcceywi1RInX29+tOOFcQJ9b1sZcGNWVsbJOzX/qbu6eDW0t8XE/sldmtNQy4kR0ICiRswhcKrzPqF0accfXtXflbVyY4z/zxaknu7SaGsBzcXNS+KvjxkR9EvVLT0VE1Ij8Iox1VUNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlgtvkSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlgtvkSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BE1C4CEC2;
	Wed,  2 Oct 2024 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880612;
	bh=58ouqHDrfp3olj8EuRaXwfzkmZtwEreN6CcGNxlxPa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlgtvkSiCiSmZV+4oH84MeiQhT/jteHet+L+yNeLv+DdIAk4SYe33BQGnCy2W91eZ
	 86SORfCE9BkwMb4HL+OjNQuFiqJ2csl7aid2UUto5tNLfdywXcoEIFCjyztnyCHeZC
	 o/xftGiHuwl6aW7RWTxY20TQuhOO4qGoYeIA6tuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 501/538] dt-bindings: spi: nxp-fspi: add imx8ulp support
Date: Wed,  2 Oct 2024 15:02:20 +0200
Message-ID: <20241002125812.216318142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 12736adc43b7cd5cb83f274f8f37b0f89d107c97 ]

The flexspi on imx8ulp only has 16 number of LUTs, it is different
with flexspi on other imx SoC which has 32 number of LUTs.

Fixes: ef89fd56bdfc ("arm64: dts: imx8ulp: add flexspi node")
Cc: stable@kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240905094338.1986871-2-haibo.chen@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml b/Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml
index 4a5f41bde00f3..902db92da8320 100644
--- a/Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml
@@ -21,6 +21,7 @@ properties:
           - nxp,imx8mm-fspi
           - nxp,imx8mp-fspi
           - nxp,imx8qxp-fspi
+          - nxp,imx8ulp-fspi
           - nxp,lx2160a-fspi
       - items:
           - enum:
-- 
2.43.0



