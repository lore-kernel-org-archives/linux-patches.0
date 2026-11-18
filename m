Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048384;
	b=br+e8GVyab2743xJT0J4A+h2ZmjNyYcuKRlHS7criH8ePWM0F80bIUEQTFymzCGggpPR
	 tgKIy+WJ5zGZfec2BulE7vFTACpDzO+lpFYwRE2VKz3DhwsXbCQfllcfsZU4vb3LHVEt0
	 fvK/NZ7mSp2mhUcOEirSmNZNhfAlXDA/BVJFE5jOS3+ovRf7OOSxVN/qq0+/c2HqWV8v3
	 CKFymyNrGtevJfcDcdoHDBM1qx21UMQB8zmFnhheW78K2n4Sg3e7khRcMYl+zPjXO5Tzq
	 8Ru/Wy9Fx8WRB+THUnkyEC44sFJCDuHTeBz8NeS5GKjwkJV1HXC2pGvniJRbYxSRBVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7gCFXFRDsLxWdYX5YsjAIgUupAMJjwvq/yibpyqTiTw=;
	b=OWfMUP5ymjLbhlaFxnygJQxfn0hU/zd+yWPRw79Cd1VFKTVskqBLRiROzg2FW/lRyQhj
	 Cu9he1kuposwL/+tXji7fcdpxjibUCLijtoBLsVX89FIyzxegCl33ncHhv9yViMaAjcdJ
	 2JXbbMW6D+4YSFABVU93KkIEOvje9Qy2FRRAGPt0DiCTpb8+H9wKxmtzFjilY88im2OfU
	 feiYgb0+JFTESjux6QETuQUmiEPWs7TgPftkiVU/MK2HJmJc9cm5f9pHdiUmB6m8VQzZv
	 ujsRJeZ1a7n4Foy+3NuxlrJKAuzTTFo0DaunbSd21tzhouAGxhTaV81HBIssnynoTqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qj1e89Kb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CD360A2622;
	Thu, 19 Nov 2026 00:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qj1e89Kb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2C11F000C5;
	Thu, 19 Nov 2026 00:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048384;
	bh=7gCFXFRDsLxWdYX5YsjAIgUupAMJjwvq/yibpyqTiTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qj1e89KbNNtWQkI6xW74dvkGnF6gy/4dDwA04oPKw0fTtxHGrP06tVLl+AD5IpfDG
	 lPyJqvz1DA6bYZHG380OITZIA5uVw5JcGUrXA30n+pBkVeTBJk8kOPei45VrFNlK+L
	 JKn3OwouIlxKm4LHeI5XTqrd0FFbkzbBFZlyCorI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Asseily <karl@asseily.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1974/2857] dt-bindings: vendor-prefixes: add ESS Technology
Date: Wed, 18 Nov 2026 15:50:08 +0100
Message-ID: <20261118150312.467455465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Asseily <karl@asseily.com>

[ Upstream commit beb56d1d3de522885b30bb97fee83825041d65c2 ]

Add the vendor prefix for ESS Technology, Inc., maker of the SABRE family
of audio DACs. The prefix follows the company's domain, esstech.com.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Asseily <karl@asseily.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260918182317.143223-2-karl@asseily.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index f955db429f55a..fdcfda32bc923 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -420,6 +420,8 @@ patternProperties:
     description: Seiko Epson Corp.
   "^esp,.*":
     description: Espressif Systems Co. Ltd.
+  "^esstech,.*":
+    description: ESS Technology, Inc.
   "^est,.*":
     description: ESTeem Wireless Modems
   "^ettus,.*":
-- 
2.53.0



