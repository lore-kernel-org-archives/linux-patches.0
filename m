Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017422;
	b=lXaDeDdZcGWpQMg8lgsGNTXucuMVUcSR2tM7n0F1lSrPsqXNmpEtHPh/XbWxK9POLgX4
	 ktWDeVZin2C91Cp8EkYArscU3lloJcbJwlN5vi0NHr/JN4o3i2EVWDODYq3qAw4SUBxQE
	 iwLYIV/oO+HBuvankuYDRvxbO9ngPsNkthBXooen+1YVRVAA1Mf8JZEVB++mh7kEuzs8G
	 6wYNo6HWUE4zYAHvCF9rH1j2LPHMpJ570IABhOMIEfWhe/WbYCLZOxCDM0/N3eodzsfTe
	 hD7rmqaykBCt8b3bkV2S4SCNABjkPxcZYvy9Paah9Zp6shceAkP7QF0Tc4xt25jwJbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FyB9g1+tmuwajNXyCxAagZ85kNcVcbe1BMQGZfUvjEg=;
	b=DuHanKBPHHgNqkW4nQdOZIurEz3cCzeIyxBZ9MFo4/MndvbL997Z9EtbLbqBi19yxgaK
	 dtBCFB814X37KkVoysYurcyPeQqYXhHrM8q1JDgUcjN/rTJ4P2BGK4hXOrbt2RR8tbODB
	 tJFYF6zuCue+MdkOmrmYDQp8YiwKpaBK08GetbnR4IdmyYnDYltsk8BhDi+2ZZOHG8Gwl
	 nyjJjwy0FA2pACfMi64dqyvTopvddNI0p763UauDKyTRrS/jQBnWeRkTHYdDbZMujYvDy
	 AZZz3vrABisCcbgRluF+I0Zr93mdkj51IMJvlmGrMo/NdnUItBAktaDJjHMbcpHU1Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Llrus1ad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1663A606A325;
	Wed, 18 Nov 2026 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Llrus1ad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F1B1F000C4;
	Wed, 18 Nov 2026 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017421;
	bh=FyB9g1+tmuwajNXyCxAagZ85kNcVcbe1BMQGZfUvjEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Llrus1adXg7k4iZ38ff7UM2ob7g1+f/to+GSDqkiYkrbnI1OYVfrgZZUk8ElDAPJM
	 zOehnO4jNUfH0L6fLkF/063fJM8Z39+D5kb1amQhocle9GrYxvxvhIyGcmFB8VpISw
	 dj/lzo9Q5je4nKTJWmyVNFRowwedJdianWSkKwwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0880/2651] dt-bindings: vendor-prefixes: Add LeEco
Date: Wed, 18 Nov 2026 15:35:20 +0100
Message-ID: <20261118150319.537315471@linuxfoundation.org>
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

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 1658af4d25bd3133d1b3403ccdda6214d40c0ebb ]

Add vendor prefix for now dead ecosystem company LeEco

Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260821-next-patches-v5-1-ec81cee63e09@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 71c7ca77aee1d..8fd9d4b4af70a 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -957,6 +957,8 @@ patternProperties:
     description: Shenzen LC Technology Co., Ltd.
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
+  "^leeco,.*":
+    description: Leshi Holding Beijing.
   "^leez,.*":
     description: Leez
   "^lego,.*":
-- 
2.53.0



