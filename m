Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030000;
	b=p43H6kbwTDHSZKLV52tqSCzUfN6pSFTjn+Mn6V80TNDJYf9aazmkxJ4EKRBYDhvZycse
	 tbZyF4MrSeIN43fQMaGh+5nqfp14EPZF+GvrXq2hCHuRQYKLtAQvEITzg52NkLgFelo2v
	 hYMmYf/J1MGi+pNRPj+6hO3WYjIM6y3TjqFV9fDQhmGitMmRx5QSaEJp4DdhYk0edmcGB
	 euY/EUT6QQJy+3BB45tUVm63O7YVeXTP4VAsPXMCk8ab1IT6CNGxNvxVjZuURnRn61fPm
	 6vGRJTiYdTwosD9Dnlp1Tn2OE7w0vsxusayGIO0VU5Rt88n8SM8zXYkQ5QCsM8LNFOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QXAhyJimFtb+EkU84+uv+2SbMp/lk0qAWmP+hUNS0CA=;
	b=25dzKjbyl65378H2DvFOrJt/sIrHBQIOOleI5ILjsyyDDwuKJ4EckBmXVNITv3MHhz3Y
	 s+pYuMeJVDHn4HqY9SG1DGcuhi2ZkJQk4siir9HkPGtVPvUYOf4NEhxdKRifEVfHr+4Hg
	 Au3qKPMZHCnYhFfvhWY7MC9en0YJYpn7EfAB1BgyaBOAEXvVA6o9zcYqgSzTZug3rWbEt
	 iUy1Ts1dQ3sVE2FOm5azdKJtUKymh5p7K29D0gqdVIpKZtWEFgKg9S+RKRjWvww5SNEm1
	 uEIpnPEz0WDHMeiADQT/uUc9peEVVgM7vOEjcT571fdfJAifB9smJYfvUMjmHJaV97A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TnOkk4+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42EA606A32A;
	Wed, 18 Nov 2026 19:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TnOkk4+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C041F000C4;
	Wed, 18 Nov 2026 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030000;
	bh=QXAhyJimFtb+EkU84+uv+2SbMp/lk0qAWmP+hUNS0CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnOkk4+DURHZBe8dTx5wG1Vh76tDQnp/APSRA3qegZfwpAxm4OzrxyYcbtvSY0WPd
	 yevW1TN/KE74tPpRcS/eGPKbOnh/A5FsudCmjQwKhiE76DbFskCdBb4umYKpYljtfj
	 yxDgN44AI0uBOenwD+4vmVNbvDbtrgroXun1uRHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0548/1756] dt-bindings: vendor-prefixes: add Free Mobile
Date: Wed, 18 Nov 2026 15:44:35 +0100
Message-ID: <20261118150030.946808253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit aa906abf611c7f37c0fe9171c1d33c40270aa5fe ]

Free Mobile is a French mobile network operator. Add its vendor
prefix, used by the Nodebox v3 CPU Module (freemobile,nbxv3).

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index e6e9aa82ce46c..600b42d555eb5 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -533,6 +533,8 @@ patternProperties:
     description: Freebox SAS
   "^freecom,.*":
     description: Freecom Gmbh
+  "^freemobile,.*":
+    description: Free Mobile
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
-- 
2.53.0



