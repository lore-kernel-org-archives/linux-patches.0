Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016634;
	b=TpyRpGXAi1Kl9UNsIcZcpCJcD47Icf6voF1EjlwNsHpHWfT38CInIr0UC2RxjEFHDhAY
	 CnwGV1DcCDSGGgcqxrp3OZRwP0E97Gqh3rmpIFtaBDpHGEgXaEjY2mGUu/d+Z/RBrTujz
	 UiQBm8/XdUc6+IRi5seSk6LrJicIkiGnI01OQ+0UYea9144YKILxCQ3EiPBG5C3pMHayA
	 n/WyR1Gn8eHQfg1NE5bWN26ESIPhiOasTYrLAZZ3vy/2PboclVbYaThV+eTnEWw9QQybD
	 ShU9ggQ9Ckd5BfIVqPR3HrduamnI3Q9nzm1MdZFh24tEyO0iKxK/bYyzZHKWXb5VUZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VON4BMyFoT4BqSv2c4HpAGB+WejJ0quM0t8pp4spbcs=;
	b=aNMwiBfq8Rh+hp6nI6kTYFqo5q81dDSLX/6jL44SfJc+VlTPztBz4PlXogFQ1yUn+J+L
	 z3uYMROa+6DJ8867Whmw/FBscY56Wm41POfq154ptirEgK+veUEBC8vzwanVAPUfFBTSr
	 qTykwQi5xKYKY+X8F8ggsGKw/s08tqbzM8O454UtjmqhEMr6gyDWw22XG9h9wSg9Q5jhZ
	 mjLzg0xpMWdHvnChdZFWox2lneY7d7TMyBvLssLXGG0HTRAC4xwzbLD/Hegklc7wW1dAx
	 W/gmiNiOt6WKiOZxrmG03mrOqkhmcuNz1wISWzdqYh9KiQbNkTM06OEhOxEEqmNlC3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CmUfbtwM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65CE606A31C;
	Wed, 18 Nov 2026 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CmUfbtwM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0476F1F000C5;
	Wed, 18 Nov 2026 15:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016634;
	bh=VON4BMyFoT4BqSv2c4HpAGB+WejJ0quM0t8pp4spbcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmUfbtwMbmwEMvwzFCpPaEIzkpulg77YeD3RHlFA5KN5PHo01R7QsMmdx7Zyn2GDv
	 GH6zqJIpz0yteM0igqYGqUk6kG5OniSNbcQ0wQQRb5yxP4UHevzcpNE+CyOvhFrDRc
	 pU4ocvg2s1PojFd/PVXsvUK2Q9Hgq9VGGMS3D+5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Asseily <karl@asseily.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0597/2651] dt-bindings: vendor-prefixes: add ESS Technology
Date: Wed, 18 Nov 2026 15:30:37 +0100
Message-ID: <20261118150309.211593486@linuxfoundation.org>
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
index ba20029693734..ff4a85f4cbd4e 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -559,6 +559,8 @@ patternProperties:
     description: Seiko Epson Corp.
   "^esp,.*":
     description: Espressif Systems Co. Ltd.
+  "^esstech,.*":
+    description: ESS Technology, Inc.
   "^est,.*":
     description: ESTeem Wireless Modems
   "^eswin,.*":
-- 
2.53.0



