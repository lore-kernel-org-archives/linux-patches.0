Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017058;
	b=yWeRM6L/BhEJONk3c4PDYOceTTQYHcKzp1MmVvor8zezrrcUOTfZZsnIV1hIx/43QEco
	 aRe5Puf+/KOTPj8xLxB8E4FNIU/m0LG3gKrQpnoGpY1FdyieiJpY18eFfeo0WEf8eWazs
	 kL0AgDuGwVlU+2LNxwTAikfu4WOeVHT/5qkXj6plLUTxaK44cvpNDw5pqEWH1zdyt0EWA
	 RjK0WacaUNrnRnhmUk/lsSSP1XFjaDiEzW9Wgtx9nmw2SEvIIXLEH24m73HHBE8DkB+5f
	 raNWDbx1gRfuAWd+bQ6en6xnDjIOwSegV4r2UmK9bvnDtzUpQb+GXQ0gT+1ZvgiEJNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJdWbd4FdNhe61qZF+PT+lVzLkBRumL0K3KeLbi+yj4=;
	b=1nNnTZmscMQi4VazS11F89Z07pn74y91R7mTed5AEV4wByyCcedHO0F55NjvWL55btg4
	 CdicQEqE2UpVTJB39krVwBbQOaKD/me0Fypazz4YCd+v0Tlnx5My2zdvry27h1XS3n7Nt
	 qAE6Qvn0AlQgM3ytfQTYJcfxBOXeYVrqPzBGbP1QHdHhd0Zn9uNN9TRZ7lO6URWX52GNS
	 1yqlds2PUo5lzkpwYOm1rCdA0DseSXA55icnVlb/x0ZvvEzoFYbNfCSwnmniLcgPNyD4g
	 sjzUUoTzOTqi7QKxTMMAkRROWlvis6mnCad04A4/yQvqvfg1o/4CsvMjs/JoK2MXvaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYq+pNJM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF01F606A32C;
	Wed, 18 Nov 2026 15:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYq+pNJM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6211F000C4;
	Wed, 18 Nov 2026 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017057;
	bh=TJdWbd4FdNhe61qZF+PT+lVzLkBRumL0K3KeLbi+yj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYq+pNJMnAauc+g69bdh5Gei1JdzHW7aqiVb9CxO5+cIVJGipLBmLW68YeZq2H//g
	 lFhRzmiDAo6+8I+cjgzxNyoHtFN7R9EIs9gmYNvuApOPYssRXMmL8Xea59SikdnFCp
	 /fF1TB+kkEgNxw4KIMp15Wwn/erTogSGV5g0WIVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0750/2651] dt-bindings: vendor-prefixes: add Free Mobile
Date: Wed, 18 Nov 2026 15:33:10 +0100
Message-ID: <20261118150314.885021030@linuxfoundation.org>
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

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit aa906abf611c7f37c0fe9171c1d33c40270aa5fe ]

Free Mobile is a French mobile network operator. Add its vendor
prefix, used by the Nodebox v3 CPU Module (freemobile,nbxv3).

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index e4f1363d144ca..8e7b69b9c1f9e 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -628,6 +628,8 @@ patternProperties:
     description: Freebox SAS
   "^freecom,.*":
     description: Freecom Gmbh
+  "^freemobile,.*":
+    description: Free Mobile
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
-- 
2.53.0



