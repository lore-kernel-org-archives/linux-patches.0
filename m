Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048563;
	b=XHc3caOMgLOm+1qHgIYkKo3ustiimfZZrfEhiqz6T2o6rm73y2RivATVtyTmschpqPm0
	 eJcXBnM+CDMrnceX2X0z/k0l6EaxCrUpMbCAWtqCG26QWUxMpH51M42nDr1HfYFxfLPIb
	 AFzapMkWKUMTviJgcCD4Ti8MovgbKVn88cUyI3Bho2k9I4p8dFTlgC7WErZUspPgvykKx
	 2ET4TAdtWBvRQUdu8jbwSKEZZNdXLqaPmI3v5kSPgU6lSjzJddwbUKBlwDJcxxcoXbdG2
	 DlEFij0xlwgpP9+Lvpp1eGRiDyeolANVtDvb3snHrpyf8bgGI83uJLHeNM1U/vx4O/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0QUu/a8nMivPry0I8TJNc9fIj4pyvbMhf6OtNpj9POg=;
	b=CjcFiYmVa9lly7TgtILwYQs/j8WJEpjWRjOvi+aiKEZFad9xakXNEkjAb36lNWt7CIIK
	 2gayI/GIT9uTh5U0xJUT15hofoWtaIwwC4YkM+aOcoeYfNDKyACXn91BNmrFUQlyadXnE
	 q1ZqHSbpaqfIMztqyS5K1jNUDTyep1tK9FFYjmfhTHQYMMTV+Js/8POVXshyh/JOXFHti
	 zXTiYX7r9keG69o17HW0fnyGsvV6JnvUxUji6CC9jhxA1BkliR0RienVF6kqzrmEtEjs1
	 plEbdvXWgYTf79JdoFd1fg1YtDO6MV5litA+Y4RZcem6KFPLctcRcmsitUVcU/xSApA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQJtQzdo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66B7606A320;
	Thu, 19 Nov 2026 00:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQJtQzdo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380101F000C4;
	Thu, 19 Nov 2026 00:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048563;
	bh=0QUu/a8nMivPry0I8TJNc9fIj4pyvbMhf6OtNpj9POg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQJtQzdowwk+8IhGV6aZkeFQDISKqhwDULyHu/NsyKUehhQybmWxmO3Pg+dOvRaCj
	 eYlfDt+WE2C37Sa/t4AMo0ZRcBylxKQmQgXdoFcSRPlR0bkI+XOp509RsSEqxkqGfo
	 uTgTvL1wsRNsUwHTHlzX04ej4uSQ/RlzFDEG62H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2032/2857] dt-bindings: vendor-prefixes: add Genesys Logic
Date: Wed, 18 Nov 2026 15:51:06 +0100
Message-ID: <20261118150314.570282499@linuxfoundation.org>
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 38cea8e31e9ef143187135d714aed4d7bd18463c ]

Genesys Logic, Inc. is a manufacturer for interface chips, especially
USB hubs.

https://www.genesyslogic.com.tw/

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221206055228.306074-2-uwu@icenowy.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: aa906abf611c ("dt-bindings: vendor-prefixes: add Free Mobile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index e6e01951d51c0..a806202b80a78 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -490,6 +490,8 @@ patternProperties:
     description: GE Fanuc Intelligent Platforms Embedded Systems, Inc.
   "^gemei,.*":
     description: Gemei Digital Technology Co., Ltd.
+  "^genesys,.*":
+    description: Genesys Logic, Inc.
   "^geniatech,.*":
     description: Geniatech, Inc.
   "^giantec,.*":
-- 
2.53.0



