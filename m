Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055409;
	b=SXfURmj4cy1XxbmeHygnvsOhXKOgkBb4bT5WmRn8s6QC0G3k2Gw/6H5PCp43Q9GtHhuR
	 Kth0IRLgJI/YEwFE+eYRVztkuvaQcG+qPYS8fJrlFCsLmHFv8Pa+1CCsfn2GWy/NzdOHC
	 qLJzSpQ8k4HL3jYMuaGYKhkahhJmZqW1a4l3mNLTx9bvfOwRGIP0PXKsEb7yBpESqxU78
	 GGPUrBFbSx3mi9EePEKdTT9ZdX4fdn4AkoJfQCKhfIBKoZ3XtCGddaS+wIzMjjrYKvNFi
	 yidZgR2Q+IOhNp4JAjGQHCMDuOHl/P+JKtC/BFIjNqmA0yBaTAC/U4NGBB+4cX5aL1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q9+KxLsI2weILujGYqs5KHSzX8Wj3HgDnhA5wrNPscc=;
	b=0WOVeumG8++jyd7goRBzGg9jC978WC7F+7gJL1H4gY7WA3Q9HBM7kv5RCSzA2WzeVkOQ
	 t25aOuAEU2wBMMJs2OANMv8Ma7Arj0E+e3zN8jqnHtyV2Q7naje7OIOIGyn3QnGW4zTNL
	 4Yx1sb3T2h7ueQE0uuOs/GA4vL75o2XEcNPssBsvR2Q6L9oR3MnbhwNQT+5yl/XMwiT1C
	 Mx5ruaj8c49kwLF4FCcU1rdiBNo+rd4HQrsb4N34ibpRk5WDKPJIal1LmVc2uZ0/3yHVn
	 +xtOebw8+NR9XJTSf52I8CqoTC0WPWznMJVToS1pbTZqpWlBveYvESPBItSbfXQAEnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3gdj3Fv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E47606A320;
	Thu, 19 Nov 2026 02:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3gdj3Fv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220981F000C4;
	Thu, 19 Nov 2026 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055409;
	bh=Q9+KxLsI2weILujGYqs5KHSzX8Wj3HgDnhA5wrNPscc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3gdj3FvsioE4O/5afGgSS0LWd6nffRABYTuCvWvuY9N+jATSwKcWPYVls3t2y+zO
	 ww380hgzxgCJh/cIZXaftdHC0vf1xRkRlJBD40WLu5a+O0ZL5XytF+SugTxmBeqgXW
	 74+75VA9ueXWcikLWRLHYOcHao58tOgUaweYj1wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1621/2214] dt-bindings: vendor-prefixes: Add Retroid Pocket
Date: Wed, 18 Nov 2026 15:54:57 +0100
Message-ID: <20261118150116.822623737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit ea55bba4c68a49fcb527da6c71dd48879b705fd1 ]

Add an entry for Retroid Pocket (https://www.goretroid.com/)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260829-rp-qcs8550-v3-1-198d5b2fc475@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index e70b0c59a0806..afe41204f4a56 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1004,6 +1004,8 @@ patternProperties:
     description: iMX6 Rex Project
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^retroidpocket,.*":
+    description: Retroid Pocket
   "^retronix,.*":
     description: Retronix Technology Inc.
   "^revotics,.*":
-- 
2.53.0



