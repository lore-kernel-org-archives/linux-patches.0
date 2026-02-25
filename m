Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4426F46F;
	Wed, 25 Feb 2026 01:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983692; cv=none; b=J5OZmMcq6f/io2dj523Haq+TSTOJLq5coc8MdatTFsBlALDmS640uOaix7EwkVkiLnF7rbdndNjmB4qL8YdLTgl59o/10mxO/EshquznS/EYHrK2UR+4tcc7nlJzXcoesOX2pVk2n6y1o5x2p4UZTeCp4zSjeROc0pG7PrufE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983692; c=relaxed/simple;
	bh=d6WbYNR1qkK3gR7egc7VHu9yXS/qyWkRFH+Kz8X1EFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKEwxtCqD0+4jvHdIYvaaIwW1s4nl9/Q3K2bNzQ211FLcAz/J9/dFS/ntNUUJnnAUvIG2QQNMZguCYvpQMQYaG9qPGePLrQDD2PsVqTdh5S5HieZUn82cj+ULGf/ZZgtzt7R85CO8CiGruNrxdO4tukO7072XDvFx8sBPKzpj+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epoy5u9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epoy5u9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF58C116D0;
	Wed, 25 Feb 2026 01:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983692;
	bh=d6WbYNR1qkK3gR7egc7VHu9yXS/qyWkRFH+Kz8X1EFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epoy5u9LE+EPrSUPExN1LJB7QGORKg6/ZwBganb485Qz8vJdFzh+9iIc3BiMLi12h
	 3by0tTaxfrF7UbDDZIP2UNijVMavXarK+p+VL3ZOKYfIerRxcNY+5f/SbdM4xQYz0u
	 fVen8ZbVSNLusDVBY6jmh6A9z9grZi2LJJbiNivQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 774/781] ASoC: dt-bindings: asahi-kasei,ak5558: Fix the supply names
Date: Tue, 24 Feb 2026 17:24:43 -0800
Message-ID: <20260225012418.700376069@linuxfoundation.org>
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

commit 80ca113671a005430207d351cb403c1637106212 upstream.

In the original txt format binding document ak4458.txt, the supply names
are 'AVDD-supply', 'DVDD-supply', and they are also used in driver. But in
the commit converting to yaml format, they are changed to 'avdd-supply',
'dvdd-supply'. After search all the dts file, these names 'AVDD-supply',
'DVDD-supply', 'avdd-supply', 'dvdd-supply' are not used in any dts
file. So it is safe to fix the yaml binding document.

Fixes: 829d78e3ea32 ("ASoC: dt-bindings: ak5558: Convert to dtschema")
Cc: stable@vger.kernel.org
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260212021829.3244736-4-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/sound/asahi-kasei,ak5558.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/sound/asahi-kasei,ak5558.yaml
+++ b/Documentation/devicetree/bindings/sound/asahi-kasei,ak5558.yaml
@@ -19,10 +19,10 @@ properties:
   reg:
     maxItems: 1
 
-  avdd-supply:
+  AVDD-supply:
     description: A 1.8V supply that powers up the AVDD pin.
 
-  dvdd-supply:
+  DVDD-supply:
     description: A 1.2V supply that powers up the DVDD pin.
 
   reset-gpios:


