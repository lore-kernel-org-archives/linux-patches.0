Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158951D015C;
	Wed,  2 Oct 2024 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877083; cv=none; b=CN9b+tL3jxuUY7XrAMmGTSxpwpvvCaGaGaLM3D653DLZNOghqo5yGSRFAUCQN29X3iO9HY+zD3oHHKUnjM0TAJOY2k9VA+crFvy/ljG6dwqbJSJGE8OiHjlJrY9R9XNAplH0iM8gRV3yGTFgLPHWuaiQC/YbgVNiqwpv54ysCog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877083; c=relaxed/simple;
	bh=4M0MvWibybZtQK4gyZb4OFGyBpmajThfX0w13mT94pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCCTncdJ9qeI9ryrIFwIMZJ0Pgvgt3dZGl8lMf0WGalzSUlU9ytnT/KZPLOB5APc3a6x0wZgT6EARUrYuGCsfThMEDoSih6aOgJ6W5ui+QWxpjh3+/A2cOXR8e8vfvE3P8XxbSqm2RxokrBEwgPYoEH6wIb/9eH0fy9x7yCVtiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P12Scy//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P12Scy//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0A7C4CEC2;
	Wed,  2 Oct 2024 13:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877083;
	bh=4M0MvWibybZtQK4gyZb4OFGyBpmajThfX0w13mT94pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P12Scy//1t7t17XEKwEeBA6b765+DbJQm9ozcr9wuRATcaetgWvQK1Yq7/SKVRI0N
	 HTj+T+o7z+QZjGcvTlkjdSCRAZO2ZErZoARYnHo4u17fFkwdToG4f5WYJGX02mirQ+
	 4K+Y1Jyubxa+5nlOoQtrA26lbkNsTLjEX/D1HmEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 657/695] dt-bindings: spi: nxp-fspi: add imx8ulp support
Date: Wed,  2 Oct 2024 15:00:55 +0200
Message-ID: <20241002125848.735576899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


