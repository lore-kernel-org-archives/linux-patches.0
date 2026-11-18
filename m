Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023966;
	b=rrffeLiBceSgddBB0t++Cfnd6Rh7OLaAzXrPpOR6HwH8Lry3srzMLmkK7ab72VcXWtLM
	 l1ZAELYKjszVQSKDO5BPjt4QuucRHgCx9tITStpVMIG0jncohtAoXUFtjur4PRmiUoD4Y
	 Fk6GwDugirmZonleVP+2An5TnrP1TNiSDb3vtv8YTON7+fR4xOT1fLU2CJZaDzusQ7hJg
	 +/ZWqUh3/8hrlTSuGHVYdzDm/gXgxBZWfSIjL4W8A7/H1vKyStVdOocdCxrlUDlkthlq9
	 K4CZFsXrz9gQzg++tgYkTr3Rdf7JYYy60oisN2iJwrb1mghNUGLG8Wa9rRSxEdD7WOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SIcIlMldQAlvWFwLokBJUxxvxkvO2xkClk6k0oRP+I4=;
	b=1xsJ9LdOUG0uxx6JfgfhXohVajJdQCk6YP/mlrW46AKH5Z13j0ZaU+k9d5CUbkIan6AB
	 2B3xqMZstxBSUHxebpPCOxM1/si7GDFP8lAvKKExKzdjYKikvq2DS4yCE+Bh2qFhNratt
	 dG+iyQqE1nYU+H/nSfDcMhMnMXjJMG6f9jlhp13Ff6g6EAGQsDl6MgAeJi+RTMQtqH8V6
	 0rxRBiMn1MNZxxzCuSzYuZD2IcbOcp1ZP8xA4DG36PJOaSHTp0A6Mz17hGKFv0epkoUWZ
	 Px9MhyPusO0yjRWcX4QG0lZ48RXsuWh4eOwA0G2SivOJo6carT2Brv+q93xH5VDZDxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKyaD0mI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0538A606A320;
	Wed, 18 Nov 2026 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKyaD0mI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E701F000C7;
	Wed, 18 Nov 2026 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023965;
	bh=SIcIlMldQAlvWFwLokBJUxxvxkvO2xkClk6k0oRP+I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKyaD0mIQOiUEBkzVKah0JM8Yz4FOtou+O7KsI0MAD+jPVPpNpUz9ewfL1aJzMvgb
	 UkcvIyEHFWcUen/p9U3W5i49j+BtjUZb/FKda1Go+vnWryGHYWxYCuiwceuc43hP7P
	 eMrYSpqdnUj3X2/YZBTBti2MtbHO9TBuP0srIVHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0555/2151] dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.
Date: Wed, 18 Nov 2026 15:38:10 +0100
Message-ID: <20261118150142.177685252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 819a3e62d37a2fe73c1e7f241f2ac086042e7757 ]

Document the vendor prefix for the semiconductor company Nexperia B.V.

The company website is https://www.nexperia.com/

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260921-topic-sm8x50-nex10000ub-v2-1-eeeaf9b0c913@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 6de8d02320b52..61490f3e31498 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1122,6 +1122,8 @@ patternProperties:
     description: New Vision Display (Shenzhen) Co., Ltd.
   "^nexbox,.*":
     description: Nexbox
+  "^nexperia,.*":
+    description: Nexperia B.V.
   "^nextthing,.*":
     description: Next Thing Co.
   "^ni,.*":
-- 
2.53.0



