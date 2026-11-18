Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020405;
	b=IJ6Dm1bUfQCX1SjR4e//+kDgl9b3Ga/nIb1X53P+1LmrNFISfFsfuIExueXhQwbhcnnL
	 IGXYWG1JHEWDKnPYs+fFkfghvewQvcTckPPpCjXP9DxJzeBA8azscVNNhs3+fEbS4l/n+
	 AcM8u1A7aMp43nwlG0E924RVwhJEzY4UIw7JCPsUBhADyAph8GgzqmTnF3PbiaG1JDnlQ
	 VcG3erYdyGu1fXKGTgJCxTFKtDuq+U2v2nbZjEPULkrNrSZtsz/QNujod5xy9YxESzh3q
	 C9YoVtXaJDdr2XVb6G4nos2LfD1OS7uHJW3SRAYzrbSceYrs/ij9b39A/9CFcXz2BWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YUThSPt3+RLDTfsQD3uw5AXBc31ITEM5spvw+Yi+VwI=;
	b=rPlf+BZKrc4eVF3VTOxoXf3fY4bwZxk6IQingeGiTRKv3aFV6g4ljSuSknb2JV9XNiIi
	 ZC0LcqsGisvyeXgNb7NuUZTcVBd9bYB+IFZ/8P/mJ8B7MsuMSISPWuZSQTFBlU3LvIkq7
	 h32HiArCUdWrLwTET7CuPku57y/kYARudNG4FLcnUOkPQBKiXFeGBpseSfhK14iEtDkAH
	 A/BJEm2dsx2sSpn7fSsmRkFP3R8xjm9lg1Gu9dRDCR/91r4UXYTbsqg2MTCGTuz9SCQM7
	 xC39zRSSeOB+r2kB6pHUvCuszfsZWtX9YFyDO5z8LvbrU1AgUuUqljve/K7CKbpD0gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmMJ0OGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406A9606A325;
	Wed, 18 Nov 2026 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmMJ0OGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844C31F000C6;
	Wed, 18 Nov 2026 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020405;
	bh=YUThSPt3+RLDTfsQD3uw5AXBc31ITEM5spvw+Yi+VwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmMJ0OGEgLSVGYsN++3eT6c0GoyI5+k1msFae8OSX/ItxDIlz+HpeaYm7GsE7/NSS
	 X5iSwN05BZkedNLMu94LQdcmEHKntDi63lp/WSW7BV4VZdoXL8DZmukHrwDizxE6Da
	 NTZK1YqWG05GZLyOlii/zpvTLMlFZ4BvGiD3fsSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Zhao <longzhao@ambarella.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1923/2651] dt-bindings: vendor-prefixes: add Ambarella
Date: Wed, 18 Nov 2026 15:52:43 +0100
Message-ID: <20261118150355.963525032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Zhao <longzhao@ambarella.com>

[ Upstream commit 5ef299ffb56531b3a4f2b311000da76beed403ee ]

Document the Ambarella, Inc. vendor prefix so Ambarella DT bindings
can be applied without waiting for the SoC series.

Signed-off-by: Long Zhao <longzhao@ambarella.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20261014-cv75-prefix-v1-1-fe95ed567880@ambarella.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2d93308624cea..fdc459eaa1211 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -114,6 +114,8 @@ patternProperties:
     description: Amarula Solutions
   "^amazon,.*":
     description: Amazon.com, Inc.
+  "^ambarella,.*":
+    description: Ambarella, Inc.
   "^amcc,.*":
     description: Applied Micro Circuits Corporation (APM, formally AMCC)
   "^amd,.*":
-- 
2.53.0



