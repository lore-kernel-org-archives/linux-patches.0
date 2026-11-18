Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040229;
	b=zYqqV98+q2zhdXsNRi+7HxQuZuyyycQWdzpzYUJEHbHgci0AU1vIfuVxpqQzwRofhYe5
	 uyJQPF9jQN3aus5MkrOaZ3Bx9i1QcizTKYRk8wy3II4XFlsoQfJi8ivK7WyB5A8kgSHTb
	 AM0SSJH8kpDF71UiVP5lT1mozAqzADPaGjNFN3X7I5wo4NBpKLqrUqkKFrzzhd/7kJyba
	 YT48tG5ezsOQuVBVunWDO2UZYjVXF7uAfW0RywRwMlUkwNPh3/EbCJ/FetIl50NTAHkQK
	 OPCPFMb12WJCR1Aav9IyoF+VY+osdvXtQNyv517xploZ2cdwyH2ybKinkEcoc8XtP7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=43dgaPJec2zMOTjagkixR9xgWxKT5GliP4KLiXmBDyg=;
	b=T7QCcT5jLA2DkfTb4M2QIc58KXz2XPLR/d9F+VRBTPhRAz0Y/huNFvMwYPAJ/x3e1o33
	 8ZV81NPA9sJNBuwcc7gntXpes7Ym8LBo0hlCEtZqgXyrRmNOVh5Y1nk389S9cnCxEAmme
	 4XyOsFbx+ZWsDjpizIoRpnphGs7hcylEnOEHx0DkdU7ew9WtoiFm2dF3ObL6aOuWSleL9
	 c2bqRaXwEWAESpIZUO23/0FLtb59J6CZeZKIJRvpOL1gbLDY3z4FxF3CB5XUbgGrDMhcH
	 Eh8rWVbclVNf6u0JZ4ChdhNVnBaX6K+btyW3pCW27jcAgSgx7XQrxM6ZxZ03tJOKcyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHgr2cAN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ECA606A320;
	Wed, 18 Nov 2026 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHgr2cAN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236B81F000C4;
	Wed, 18 Nov 2026 22:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040229;
	bh=43dgaPJec2zMOTjagkixR9xgWxKT5GliP4KLiXmBDyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHgr2cANzxsnA5KC2ixemNgoR3N6JFVNqtKM2ErX16tU44NQM+XkqBkuHwU4mTs3E
	 pbuFYfqvjJEv1tA4TnbT6n6jTdaEpnWmLhof+KUGacvmgwbfVCnL6NSlywghGnAHOK
	 8G4pBqbW5TLK2vtDF7I/wLGbLXaGiWASgV67cfQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2383/3318] dt-bindings: vendor-prefixes: Add Retronix Technology Inc.
Date: Wed, 18 Nov 2026 15:50:05 +0100
Message-ID: <20261118150433.025492870@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit da076d5562d2fc99138ff8ab04ff82eee7a4a3d8 ]

Add vendor prefix for Retronix Technology Inc.
https://www.retronix.com.tw/en/about.html

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://lore.kernel.org/20250420173829.200553-2-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: ea55bba4c68a ("dt-bindings: vendor-prefixes: Add Retroid Pocket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index f4feafdb3cc56..d7bf41c3d440c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1161,6 +1161,8 @@ patternProperties:
     description: Renesas Electronics Corporation
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^retronix,.*":
+    description: Retronix Technology Inc.
   "^revotics,.*":
     description: Revolution Robotics, Inc. (Revotics)
   "^rex,.*":
-- 
2.53.0



