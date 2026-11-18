Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060913;
	b=bGwCoAakubXpmZ67OLxFvQqLQysQ+yz6CkGYAxdKt8YZLQ0ChNzQdPLjyTLwgttdHEmw
	 YH5MwubTNJp2uhhFXCgG5JFYOiy/jPSV0igdWR+rl42aBv3uMY/uYMlmvvn22gpHqD36D
	 al5KHBk87ZjAaUITeL4pXJ6uNUe7stJ8j1L/g1MUFwmol+sUXImjZ08/WmERTl0eysNT1
	 0P2Z/N0AGSLEaeuqfF16hOQs/MJPu6PbH8PFN+X3MJmZZoUQP9PjiFFDkRXFVdbSJEecW
	 OJ0fwczi9DiPMAE96Z0g+YnbmUFxkp0MicL6oI5ubxAsLtKNKmrhRCUqFCIo+UBg3fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=caLUJKnktNxC6rzlzx4c2LQwFesf+gZPeYlW+jvgDRw=;
	b=oIo323LND6cbwmrFYWAbUZs/QdfAYX/JJeG3UKzCDk5gXOljji8Qzv/KCNnxnro44X/C
	 c7IFnv937qVOPHji345HEu1ScwbZ8fF5WBdosTJQhyDmrJHs6wDot70OXEzKXLfLDkk1C
	 rIWbD3OtB12EbkEyBtaNEKmEWpfEAiRtuoxuUAWk3B0kCtuU2Otzi6BepmxKM7qB5HNmb
	 NX9QcZmOYurtOopvPRaZXi6FTDk7p4NitUIJNf+nGU7Qk3/73BxdhQTo2FvfrdxJfeuMq
	 6zdJdyWTl3T2nMhLizn0lZS9zwlt6oTSo0lZvexIhrGpo63m4ojc5YlF2IxygTnHbNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dV5PFSat;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B69606A325;
	Thu, 19 Nov 2026 04:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dV5PFSat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9161F000C4;
	Thu, 19 Nov 2026 04:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060913;
	bh=caLUJKnktNxC6rzlzx4c2LQwFesf+gZPeYlW+jvgDRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dV5PFSat+9iPDyOIneNdlxEk2CcHVpHZO/ilbzINtop3TEu+b6vnBr7oi3cHfEyBX
	 7I6o7d83cHe1qovw2UY2S+Ue8vr8KhfNVqdxn2V700+1ty9nIhozOWo1alVF26GUnL
	 x2XrqO5HEcPbKWZZqFZzH7R5adzEK2szY1COg5wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1367/1848] dt-bindings: vendor-prefixes: Add Retronix Technology Inc.
Date: Wed, 18 Nov 2026 15:56:45 +0100
Message-ID: <20261118150016.796423699@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7898b9c23ec8b..f97134bb2a00a 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -928,6 +928,8 @@ patternProperties:
     description: iMX6 Rex Project
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^retronix,.*":
+    description: Retronix Technology Inc.
   "^revotics,.*":
     description: Revolution Robotics, Inc. (Revotics)
   "^richtek,.*":
-- 
2.53.0



