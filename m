Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048660;
	b=IxDYfaM1LWNDLSa7ib7/FExLeUi/rCcKwZmC576mUnSsNx0MijsTZrx4Zp4HJVhthI5f
	 Ga8OC2ZuIYK9Xqsfwz1rxrmKx9k9lrYCZzxqmoGchWn+zUYxfwiwC29+Px8HUpAZ+EZwR
	 bN8kxxxd14aLCrKVH1YtiHhUZ4knhuIIXbikHZ7CwEFWEBqzwWAFK+VyEy2X8TyGlLrNC
	 ulaQAC64nmZcOQ3NphitXnF8NYJ29kVzD78Gm4d4rwEbvthCZ4ZJIHs3h2J9LD9kiN8Fk
	 0Cp+ajWNakFbHGRdv/NWPW90Io8DWWKAdqFOlzlTsflKVd8J07WKIec2eRuuBeDWHAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BUGby0eIgk+rdiwTX58kbDzGMX2hl6lAwixOcrAlBB0=;
	b=MdGh/ocJfiTS9TiAOBFUq5JHVVczDQc5h/2F66w3jMuGNff+UFGvTdQOD0AZljld84To
	 t/plMmwxT21ARdSLcpJ4GXo0uTbkja30+j1BHy4eDA5Kj9C4UtRQag6QbtjV9BnYzUEp9
	 QFpIexiskqPHLRyQRa+i018nkfbCnQOZZ7Z3OKTBESYOJB7/HkbNHDkzn2RkpgychHc2h
	 s76lyKoTpiSHSl39HXi9jTpZ6AEJCsrjXaL/YOaTD8UkpGpfWRmwNUEeNm5sWiLVXHoZE
	 FxYqT7FVXuYHJTisaHyIfvyuBMvmSGXPYEAjQNTVsU3Yb1jXYVmYfHW1dzLHM1uE4mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSXP692y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75081606A32F;
	Thu, 19 Nov 2026 00:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSXP692y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06FA1F000C4;
	Thu, 19 Nov 2026 00:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048660;
	bh=BUGby0eIgk+rdiwTX58kbDzGMX2hl6lAwixOcrAlBB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSXP692yga4/9p9DQsxHn1X9O6HgAYlMjj8azhGGOg0Xmesz2DAtkylydMkCHIh4a
	 JKFQoPGlu/tezN91oCq/sFLI8aDfmks8xJpZI+OIXhTER+LVrRN7+WHEoJwsNFsrEM
	 nbWhyDnj+NkhyeJ/Ku821RkYXihlazaYFRXbD/Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2072/2857] dt-bindings: vendor-prefixes: Add Retronix Technology Inc.
Date: Wed, 18 Nov 2026 15:51:46 +0100
Message-ID: <20261118150316.020616395@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3cadc10908bbd..68d89638e6f65 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1103,6 +1103,8 @@ patternProperties:
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



