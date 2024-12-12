Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA5A213E99;
	Thu, 12 Dec 2024 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022246; cv=none; b=Jypb1kGPPlQc3lWZvMAOKTo5ATXfi4gLsSFo7MIr7labdSoXOlAmL+hAKP0GsZsPO7Cns/cIVnXYVeBmS2xdhEtBLqFIUP0B3xkqRf4FI7Gjz6vNVUNa66vteyttKyW0qqU/l28qewExrnGklPsALuur1TnZaLuCWaBEJN8nUx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022246; c=relaxed/simple;
	bh=P87MmYXbG6O8pbBdRnGoKpGDLGFxzdOXCT+3i6T3Yjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjqwPHWbz6ccUNOknpKx90MlCCkz9RuthIkZ9YEJYR5fy5RrITf1RKGk7/UhXW6z3vswU81wQbPzm4Ne8leLW44L3B9g6eqPLR35QCSAPMBpJZvOvGHlHEwvMRFiQa8Z4x6v05Nnz7/GMWCtEFjTdCTsznCJ6c/Igrbf9LRKphQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecXvyIHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecXvyIHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05A5C4CECE;
	Thu, 12 Dec 2024 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022245;
	bh=P87MmYXbG6O8pbBdRnGoKpGDLGFxzdOXCT+3i6T3Yjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecXvyIHz9wCByizqC7sondNYgFmk8LOQpShek2xA82nXnk+MZybL9vDNXtHOPhr8B
	 g87yMLOFgpIz9gwQNrQLs3gr4lWG7vJrWp0vPvobhq8QkYMLG1Dn9PymyqaCZjmK2s
	 PqLVn5nNz+alh45y+9xDRaqMlm5kvWxtrv/aizq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Prusov <ivprusov@salutedevices.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/565] dt-bindings: vendor-prefixes: Add NeoFidelity, Inc
Date: Thu, 12 Dec 2024 15:55:52 +0100
Message-ID: <20241212144317.685577707@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Prusov <ivprusov@salutedevices.com>

[ Upstream commit 5d9e6d6fc1b98c8c22d110ee931b3b233d43cd13 ]

Add vendor prefix for NeoFidelity, Inc

Signed-off-by: Igor Prusov <ivprusov@salutedevices.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240925-ntp-amps-8918-8835-v3-1-e2459a8191a6@salutedevices.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index a867f7102c35b..38fc30b90f6cd 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -782,6 +782,8 @@ patternProperties:
     description: National Semiconductor
   "^nec,.*":
     description: NEC LCD Technologies, Ltd.
+  "^neofidelity,.*":
+    description: Neofidelity Inc.
   "^neonode,.*":
     description: Neonode Inc.
   "^netgear,.*":
-- 
2.43.0



