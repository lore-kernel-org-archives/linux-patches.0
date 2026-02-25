Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9950123D7CF;
	Wed, 25 Feb 2026 01:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983691; cv=none; b=KhQaZGce4jjKwz/hJP1JeA8r5O/fmXxJSfqKn0wwagyCzJxzeZ22T1rGfeeIc9PAmRSOgNQK52KNqyO+jvY/s85jyNGIge/SapysJY2cjpJnjr7EvTS0+c+UKhkUPmlnTTez8MWDZFeRiDt1/J0D9VfF7K31CXLonE3zFOrcgbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983691; c=relaxed/simple;
	bh=NhX+Lx5C6lna+ui3/1faHVijuhloBuVln1wq0WRHl78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmMB3KgdnaG3esnM82U//W/Wd4R15gcgAt2A0Gwa2kAuS72RE1Lt/+xl6/FH8SZ+4tIPFKIZWLH/+X4npu3kTmGJurU/pwVF/8cJ+nimOaEGRwWfwLKDXjgPbVPcCGf8XO2ynwhMqRMhRaEJ5r+kOWpOPKuRXXJHt0n6SNCVkgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTmFlNa6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTmFlNa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5201DC19423;
	Wed, 25 Feb 2026 01:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983691;
	bh=NhX+Lx5C6lna+ui3/1faHVijuhloBuVln1wq0WRHl78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTmFlNa6nVhkUQGrmjjtj7DdwmORFs4mAgZ+E0o4YEi+7Q4B9OlaIkcklmqRv5tUt
	 8ZXdx9te3LVOYGPxItxLSmWBLfVRasuSyd7KKvTOTGDZNdrE8zV6ycH5JiP5G4X64H
	 lFc0dblHhiKMX3+zRfCesGlibvf9HN6213LzUcgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 773/781] ASoC: dt-bindings: asahi-kasei,ak4458: Fix the supply names
Date: Tue, 24 Feb 2026 17:24:42 -0800
Message-ID: <20260225012418.675614873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit e570a5ca307f6d7a6acd080fc219db2ce3c0737b upstream.

In the original txt format binding document ak4458.txt, the supply names
are 'AVDD-supply', 'DVDD-supply', and they are also used in driver. But in
the commit converting to yaml format, they are changed to 'avdd-supply',
'dvdd-supply'. After search all the dts file, these names 'AVDD-supply',
'DVDD-supply', 'avdd-supply', 'dvdd-supply' are not used in any dts
file. So it is safe to fix this yaml binding document.

Fixes: 009e83b591dd ("ASoC: dt-bindings: ak4458: Convert to dtschema")
Cc: stable@vger.kernel.org
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260212021829.3244736-3-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/sound/asahi-kasei,ak4458.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/sound/asahi-kasei,ak4458.yaml
+++ b/Documentation/devicetree/bindings/sound/asahi-kasei,ak4458.yaml
@@ -21,10 +21,10 @@ properties:
   reg:
     maxItems: 1
 
-  avdd-supply:
+  AVDD-supply:
     description: Analog power supply
 
-  dvdd-supply:
+  DVDD-supply:
     description: Digital power supply
 
   reset-gpios:


