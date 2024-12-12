Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDAC222D72;
	Thu, 12 Dec 2024 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025116; cv=none; b=JiOcdfcIhS4E2TMyzWCjY/4CgoCTGiA9k8U7uoY9rZhZTL8p4iqcUbWNyhS0aMKnt+vlL6+tT4moGhBk/fbLmPJLsDxspZAhffwrXxx/bE4TrNgG/YAUTg8XkPDsE61mx6nujT4P5ewUJzyzT0eHwWK6ifNbv4r7nBOLaK/PI1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025116; c=relaxed/simple;
	bh=xA6rWXElClh2eRRl+g525V9OMPjJT+j8WTM35aBLH7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEw81piamGbrcy4lT7d3gP2pfnVVzxWZEGLeNEY5lffshQTXNFR/iqm0Wv/hVKB249DorhIVstAryiuCZzIpJJJHzlMyWHzy6Ltgtmu5EAOfUhrSAQdSF4+BpU35JdDvUcNxGCK1qnh0LcyzLqaGupMdZCt/7Ru28aMTFFRsJ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mbTjj/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mbTjj/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D923EC4CECE;
	Thu, 12 Dec 2024 17:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025116;
	bh=xA6rWXElClh2eRRl+g525V9OMPjJT+j8WTM35aBLH7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mbTjj/axOdvs02x20KjWbs5I4sX/9PVl4D0BEIHWKxJenJFLQ8DMMoFz9rWmcrYb
	 aaAup8cMeQnSZGaooRjI/Quuiz6x9k8yPGm9c7KgReBLplD9AK3SXeL8fxq+tmG/XX
	 VMDkLqx9ZSnRgPgEBDFy9QPSBOZqc1pz6uPsHzJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Prusov <ivprusov@salutedevices.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/321] dt-bindings: vendor-prefixes: Add NeoFidelity, Inc
Date: Thu, 12 Dec 2024 15:59:39 +0100
Message-ID: <20241212144232.402111994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 967e78c5ec0a1..e4d25efe49b8c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -633,6 +633,8 @@ patternProperties:
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



