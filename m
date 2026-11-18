Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039912;
	b=fpAguaTLy5fTeEqq388RNnfDBTJCkAK3QDjJxw4te1avmcm/bPMW1u7vCxGWoI2Bb5mI
	 759YHJ5Clk+mrCpRAT703UGf6lO0gm9Ex3Tble/EtJcFxNK8eNC/WegiUYv4IYojT66SK
	 B2zXScgxwK4A6t+LEHvE+5ulL5JqRz8zomqCNruU7ehoRelBln2pW15UPi+lFkyaN8MTq
	 j1W60em9tkTxMgNLtsS6TSXxqK2pw/wfWmBeoiH3LGeMF6HwYzRsp3dAS/Ad8Tkjqd4T8
	 O++vXcEnBWaCHAaqnNWJAetwGNzmh/5J5RWC6r2YJuBzEJvlny195xXdaLuacbUVHDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PnYaeDsdpH7/rmdBgwQWmvhLGapijPLLPc2+co0wl6o=;
	b=WcnQ23wb8O7Q3XNyWaAWKVgOb9hrOhxIF58m+6nv/PYxYZi6GiFFt3rp7LjhijvB6S7g
	 Nl0PnZ9zsg1vTRyHX36iM+9JJ/qozhr7FvNnPSS9ByocgExGDU8CZF56OgtR0h+O76aCi
	 vKvRv8ayYFPRHBhNuYNOPVXcyPsYClsBGZunM2qnOPylTBDdcQMiKcQoXjr6lXYD3SbhZ
	 /HRFMDg53M0JWf/DJ51XrJK1kcisZ/w1VKAl7ztF0/lu9SQGxArwzeV6ErEXE1KUYdlH6
	 7NRlnEdIna3v2DJ4GKz7W0xt8BPQ1W+T3FqjOiPd57/UZl9oBHvpMaCJQORU77WvaiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a1/qObvt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B502606A325;
	Wed, 18 Nov 2026 22:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1/qObvt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF021F000C4;
	Wed, 18 Nov 2026 22:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039912;
	bh=PnYaeDsdpH7/rmdBgwQWmvhLGapijPLLPc2+co0wl6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1/qObvtx3cf4Nx8CGcCa63l62u8qh1aX/EmpEEdtHsAjLc7G8Lwqp2VRiUBQ7DBu
	 6NxWRx187cSrNzPrsZQiyTCw5HPEhWmbwUStLqS8iK42yvWYe9FNV0RURL5R5uxSJB
	 jbwAkiRjUnGUEH8byuirmVnVIsjCc65GMZsUaWsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Asseily <karl@asseily.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2268/3318] dt-bindings: vendor-prefixes: add ESS Technology
Date: Wed, 18 Nov 2026 15:48:10 +0100
Message-ID: <20261118150429.841436001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7376a924e9aca..6d938b8d61d31 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -442,6 +442,8 @@ patternProperties:
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



