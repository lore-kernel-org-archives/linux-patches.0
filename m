Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A741D0953;
	Wed,  2 Oct 2024 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878946; cv=none; b=WbUMXUeadeT4mFFAyjF4ip3U0bqyknOnXcH5T98ro4uM/EJ/BV4Vq2DQGWUA1Ta8mlG463J5uvLa1pcV03vp2piUg0S6R0wE30sBvcHm7ReuEFssAemImEomXc6AzEOq7vSO4reqkhS1xkrwybtR9BY/2zp0OeY7sXgFC5EL+D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878946; c=relaxed/simple;
	bh=fLdct5HtFPYOip4OT8nhifBJkxI9O6fwkrkt58IW1O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnB2E2q2vOSscwVY65aLlKK+g2nO8nDjE39i9/uIjNbMcVMzAW3fJzkf7nJDY+81SJo/MHhzOuq21VLccy3MgVpL2WrwhtOHSekANj04NttuA8cNV/XicFd4RQ5muDT43ogUgSS9WdGHTtabof8wxPjH5vAJTw4N2icf40f+M2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yxyje6by; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yxyje6by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3294CC4CEC2;
	Wed,  2 Oct 2024 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878946;
	bh=fLdct5HtFPYOip4OT8nhifBJkxI9O6fwkrkt58IW1O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yxyje6by0Cyej6f6KucyTKlkcRMmOgQiT7iyhmKdn+JE+scAwa0pn7FaiyeoR9zLy
	 Vb5Y16z393uP/3pvVVUGC81t184JRYZl1t//FQxYqCSd9fWL9dtHbrCarrUyD9SaZO
	 opwRci+DVf+r4j3ZYjp9f0Eib6YzlY7jhWw6NDuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 587/634] dt-bindings: spi: nxp-fspi: add imx8ulp support
Date: Wed,  2 Oct 2024 15:01:27 +0200
Message-ID: <20241002125834.285396422@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit 12736adc43b7cd5cb83f274f8f37b0f89d107c97 upstream.

The flexspi on imx8ulp only has 16 number of LUTs, it is different
with flexspi on other imx SoC which has 32 number of LUTs.

Fixes: ef89fd56bdfc ("arm64: dts: imx8ulp: add flexspi node")
Cc: stable@kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240905094338.1986871-2-haibo.chen@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/spi/spi-nxp-fspi.yaml |    1 +
 1 file changed, 1 insertion(+)

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


