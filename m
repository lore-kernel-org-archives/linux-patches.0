Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061078;
	b=MbAJ/FJPdq212mNQucd8gRU4ZuBI/W79INPEC8kNpAUTnKzrNmRcFeqNL0VafyKflDAs
	 VgT//B+ht5UPAbTZ7roViKsviakrX9G73FeoxbxsZhNWB0Co/46hrZuUUxwqhkrw2G1ew
	 Hqg/sD26qcGGTu/xrBQkLlFKhgV4D06jywEauaC4sW1HX+8yWhOc5nnSvK1qVrb2dpq9E
	 LWkwUnusOlywCdM7X8TVn0rYWTsad56XUlr5i/hyTUHMzzNAbZA9Y9nTr5oMRIZNT/8GL
	 Bfns9h66yI7d571WssxYq5Ar0XKFRcc5P1G2it6N3F9tjrfSorVJEYZzA8b475optHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1mjJkPCel0qG8MJGBmBZVEopEa8gbJZO5dGkmk6APos=;
	b=UOKDxiGoernw5S6sIBvrgAZofJiNCMP2HU34Pu2pKjgBwjvS85CSy1MNpG2D0RoVCi2q
	 0f56QY2WrDP/+HhM3YiOK43gw65YJyqxxeDWf7LHMj3gpRJstt8ERY+3httXlFm7KIKuJ
	 E5QK3d7ZCwmVKRMMrhj1rnZ13FV7l0OS37PpXtnNf7CfIUs9xAMMi8FKnduMs5tYeAFME
	 wmbCcrCYGTRoDYeEy7/n2/x7WIP6bnrnAaYc3wEsHToJ8CpI+H6jdCvkvv1kk3zhaMVxf
	 AZ5MIynhR34os3Pemy8X6bYN3wEnbc2Rmy7O8AziaEv3zDkYjILj8KReKfAjdM6t4lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M3wwwTUX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293E606A32A;
	Thu, 19 Nov 2026 04:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M3wwwTUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6801A1F000C5;
	Thu, 19 Nov 2026 04:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061077;
	bh=1mjJkPCel0qG8MJGBmBZVEopEa8gbJZO5dGkmk6APos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3wwwTUXBqsdJhZ0JDGGMKpkloWQ+LxA/EH8ZrczgUQO+V1pidR8uF4u3UAugOxX4
	 +H9iW6Oo4eIpXZjvQc0U5U0vvkmNLsVOPlxRxqEpR0cpMTIRf31dEhCCfoges8QfyF
	 ejszkNPzE7a/JLcD/6MGDzduLb5UJEhAuzyQkJPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1418/1848] dt-bindings: vendor-prefixes: Add Sophos
Date: Wed, 18 Nov 2026 15:57:36 +0100
Message-ID: <20261118150018.850721791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>

[ Upstream commit 538f8ec6b9c711833c5217a8bd8207a282265303 ]

Add the "sophos" vendor prefix for Sophos Ltd., a vendor of network
security appliances.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 307700c3b2aaa..6a18a2333ae04 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1056,6 +1056,8 @@ patternProperties:
     description: Sony Corporation
   "^sophgo,.*":
     description: Sophgo Technology Inc.
+  "^sophos,.*":
+    description: Sophos Ltd.
   "^sourceparts,.*":
     description: Source Parts Inc.
   "^spansion,.*":
-- 
2.53.0



