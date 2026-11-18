Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060908;
	b=2+EzhD+StF9pD9AN6M6JBxyomqq7T+vWL+IfkyMYwF3HjfkcdC3z+BoTWKPZfLWZ974/
	 /6WTEZF3EfE6xWLJZiy8/uOFVFHhZYXLsPUumAVY8rc9MFCTsAt/IaFGIOsDoC2kDmqrU
	 g1y+qHOlpUDO0a7NVwf6KR5tp8tAslnyRgV7m+nrJdTZv2F9tD1myu5OgMpmn50R+XFWa
	 zCE7+SlgQdANGlMhV3v+A7+tb/2+OWbMOL7NtaW3AlGbybXZZoSEF/AC1ElJgcPZxxm2u
	 i49pAczszT7s/1eQAHvoT3AEu5m6MPZ33HbCDmwrd/+8f07Gr/PooNJ0lNKRG578nPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AT+EyrU5ucZvKjM8Kuy/hTHnEZKG+e4m7Sj7Rb3gU8s=;
	b=A1qxhXU0ncregnjv2olZE5ZXxYbIwJwCBbMAQJnEvX68we4006jIzh7gqkMUFrk0lNnG
	 Pq0sGIQEtsQ4M8nIWaORhD/UHFezhO0MsHrW/RVFLyRbeTQxS9DRGftD+c+4PhH/+aKgJ
	 SJmkYWJ+ACZy9JzTseHcxLMTDAX6T1fGQv7w9SIjH3BzjvTdHi7+gpj5sH/ejAWilVa4Q
	 7WMFsoGErhBOt4tQxoYWwNOhufnTh07vzc57zZUHaEIKDsA5JiIX/zRP+EecAYt/p1k8A
	 golJCa9VD7El3BV5Qq5erOKk0mhLbzRHM58dTczaOdm8I+ZiqudvQZS3ajk2qAD41wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wa8pxVq9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0980E606A320;
	Thu, 19 Nov 2026 04:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wa8pxVq9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597991F000C4;
	Thu, 19 Nov 2026 04:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060907;
	bh=AT+EyrU5ucZvKjM8Kuy/hTHnEZKG+e4m7Sj7Rb3gU8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wa8pxVq9i4Ixi6C0h6Ru+k/RIwDeWdUbfnYr9wihFDB1fS0FDEYDf71vICm0vKAMq
	 ly9Ok6WjH2Usxjs0LyjDxnRW1PUAPvaGesxdPo8riJNJhFLfs9fWMVeIhF+LWJWUIu
	 DYR+/F9cqOuopxFdT/BE5VEQ1p+9ddhSHFg4idcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1366/1848] dt-bindings: vendor-prefixes: add Revotics
Date: Wed, 18 Nov 2026 15:56:44 +0100
Message-ID: <20261118150016.757443901@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 1acb40298366b8350d34db47dd9aae72ff18691e ]

Document vendor prefix for Revotics (Revolution Robotics, Inc.).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: ea55bba4c68a ("dt-bindings: vendor-prefixes: Add Retroid Pocket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 03a5843661b70..7898b9c23ec8b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -928,6 +928,8 @@ patternProperties:
     description: iMX6 Rex Project
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^revotics,.*":
+    description: Revolution Robotics, Inc. (Revotics)
   "^richtek,.*":
     description: Richtek Technology Corporation
   "^ricoh,.*":
-- 
2.53.0



