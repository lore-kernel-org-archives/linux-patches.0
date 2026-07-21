Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A341046AA9A;
	Tue, 21 Jul 2026 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648276; cv=none; b=WKmyp5rkr4S8UADp7ch+yl9LXwbuc1tvpEscK6svclsyRXcT3rulxwiyX1eamnKE5N5YCZUXt+w1awFiyAx4zpO6HdtRMyFLuhmgI51YCzMYPhE9xYd4heL30X0Vljzi79a0Uh6mMwzdXc35Wgq9K84IL+L4JLzbQ8FJ6vwn4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648276; c=relaxed/simple;
	bh=4heobmHRwqwJeujUyLMyLiQVR2YMeJQ4jxRsHNKHiw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Afe1aIx04IiTNwWjNIYDsIaAbdrUE7NDFnpyRHuGsMPzJLcc0OrOEFmhX9yNiL/8Tn4QL52Q9g7b4WR5YDzS6fOUwirJJEXH5tMOKuaiqmSWqVQQJAOG2AE7AI7CNRQWhUpge5j0Fsq+GaEEBnHiWZPATu/xL0+UHGFo1fdRMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hjsowy1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hjsowy1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146B61F000E9;
	Tue, 21 Jul 2026 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648275;
	bh=rLAjsOxcTBTK3V6Gjm0MUerIajUOXa6/a7h3HaGy0Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hjsowy1njacWv5uOurrKMUAYw36V6W/CRSlECtwEzolezE89U/f1KI0/6pgP6m3c/
	 g8qaPdn7lzYV5WqzVPxmqHnUPp3ftp1NLPFVO05YrBb8rNQVvLDeOuXQSpy8Rdf3bX
	 2UWH69ZPE3EZxSA1IfG7aBdzybPMKHIZoIIA0Q+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0139/2077] dt-bindings: vendor-prefixes: Add Displaytech Ltd.
Date: Tue, 21 Jul 2026 16:56:52 +0200
Message-ID: <20260721152555.968133251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 42112cff8cb78ff6120983ba71bd14d52ce9dccd ]

Add "displaytech" vendor prefix for Displaytech Ltd. .

Signed-off-by: Marek Vasut <marex@nabladev.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260422210806.80948-1-marex@nabladev.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 28784d66ae7ba5..11c55b5df0e4ca 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -437,6 +437,8 @@ patternProperties:
     description: Diodes, Inc.
   "^dioo,.*":
     description: Dioo Microcircuit Co., Ltd
+  "^displaytech,.*":
+    description: Displaytech Ltd.
   "^djn,.*":
     description: Shenzhen DJN Optronics Technology Co., Ltd
   "^dlc,.*":
-- 
2.53.0



