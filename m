Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060896;
	b=DqFZBW4sUZMHwyC8Nx6cCohgLlHQ8YB/xcqIcwu60H+L9bEoYWP8f1nbdC9uiDM0foyN
	 MQWUutU81Olv6JoJdg2ZLqlY16WRYEfEwZSx6Y46yLOnLoc9CXUDPkdOv1qFdlK1JoU6z
	 f7RBP4Lm7/WuVegF3Te5ROuzpsTkrxDIkmzyWzmzA8J7MlTdxHovMFw1JvFrEK+Ki8qzU
	 ypRucrlUJ6ROEosaiGDHsqMrvzrUsAyjOCi9bQhYWACK1pmxc+HGzHNhS5Xu5WOmelmCM
	 QDNnW6aNU+LYaaOFzE1VJWrV/9oAsb4cq0pzFW2Z7188mW94g8guk9tY4DeRAzOi6hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OOcnIb4aEXFNyUKokTyue7v+HYml8Io4f3hgzFSziIA=;
	b=TYI4326O8f7aeyUPO/Uu6dJICxy5QRormuLxfcTp77K7S9q1UwC6aVMXqGdBBA+1RZ3M
	 sFm4v9/7YKLwPZ3unnh45iSr6izrWLjJHmdXpnl+JIab6aVXqdN7CXFeNhiRIJRl1GOwu
	 ZnGM9BFtxtnHEylmiPVWXgEWOyS6hJg2PjtttVQ+kB+Bn1nUO0drrYXE6F3jYV+wlZE1a
	 xvY0iV92EuZjCtw2hjIK6SgiuBWaSml1l9bpP22Rcogq/Swq41p49r+8Z56XV8YxAH9rX
	 x2LyDKf9ejCFShlJonNk8vhY2o5psPJUOioNuMyIMNKp0NQiTfQivjK80V3r8LOU2JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E+E+9W5g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA4C606A32F;
	Thu, 19 Nov 2026 04:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E+E+9W5g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438411F000C4;
	Thu, 19 Nov 2026 04:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060896;
	bh=OOcnIb4aEXFNyUKokTyue7v+HYml8Io4f3hgzFSziIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+E+9W5g173nG4M/mjUKNmr1IUobbFhfenNu8/7+lJJrJ8tex0XhHRDRgywFttPLb
	 yx+7hLkaOOtOdBVJcgXHtDEodtb0CLpd03vV9uEz5ESC7aXROUX19Xnh33Fh8W1e58
	 fO9ixs1KgGKr8maymh6EEh8SE7FnMWbvA7dnNrz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jagan Teki <jagan@edgeble.ai>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1362/1848] dt-bindings: vendor-prefixes: Document Chongzhou
Date: Wed, 18 Nov 2026 15:56:40 +0100
Message-ID: <20261118150016.609416812@linuxfoundation.org>
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

From: Jagan Teki <jagan@edgeble.ai>

[ Upstream commit 90f86d0c617d9461cb00f4d8e861eda28011d46e ]

Chongzhou is a professional is a manufacturer of LCD panels
from Shenzhen.

Add vendor prefix for it.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221108173120.618312-1-jagan@edgeble.ai
Stable-dep-of: 058ee00216a1 ("dt-bindings: vendor-prefixes: Add Chip Wealth Technology")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index d5b0f3043ffa2..8dbd288fdd659 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -211,6 +211,8 @@ patternProperties:
     description: ChipOne
   "^chipspark,.*":
     description: ChipSPARK
+  "^chongzhou,.*":
+    description: Shenzhen Chongzhou Electronic Technology Co., Ltd
   "^chrontel,.*":
     description: Chrontel, Inc.
   "^chrp,.*":
-- 
2.53.0



