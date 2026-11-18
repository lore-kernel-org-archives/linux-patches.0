Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032409;
	b=4Bm7xS1cPvX1IU/X0Y90Sq7ApzKul/SS8nxvP9406aFr1FAsWusgCPN9oBCsHnTBsYTA
	 8d1cbC+gr9ZyBrvcgiSgOiXM9lPP3sGSjT3sIw9wScusjuM17VvXAyqwdN9+SumFTaVu4
	 SqY4K9tA+z9qDI4/gwmEWsAbI4lgBCVwj8H0FWUB9ZH/06LEqrUOmv1CLcZVoasZENGT9
	 gOrjfK+geMi1Y/Y0vPKuOiHecYuALyTKM1VT+HakwNwfZ9Vax6iec/qSTQg09eWyGzibr
	 6BYE4UnUi3i9I7IjDOZbw1Lgps/skiqeXGSHGOrkxylAPsk5iLEi2vblCx/EiXa19GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3YzwWBQe+2osVUh8B+kNJi6Oj/q2m6/oHHCjzQrUPHE=;
	b=uOdK8+ZMu8Iz1Rr7OVEYkjdlZ8pljmZr8sGwQaQiqOqE28jTL+Ff+x04JWs3o4/gIEHq
	 vAVrKDGqmABkafZ1DgcKk+IByq5dkeNsT2qt56Woh/vLMVeEnjxnwaug67VO+Oxwenn0i
	 buea4cHHdr49ag7zhK6yrg1vTCBBMsVFX5+4Bc+wU0tDszmGjaO2jT+6A1XkA/b99zMIi
	 ShiwV3n0uBCHxcRwE0udMwOg0AQcUZKrAWO3lCtEAyex9kM8XWvT5KgwvH+0MrmNsF5y5
	 DDKQbCy7LDhBn4+entZxQFYcx4/Jo6Tz2qc2ffPZV4xPZDBbUeaHp9Atul/pN+31YzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVdb1rpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39721606A330;
	Wed, 18 Nov 2026 20:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVdb1rpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BB91F000C5;
	Wed, 18 Nov 2026 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032409;
	bh=3YzwWBQe+2osVUh8B+kNJi6Oj/q2m6/oHHCjzQrUPHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVdb1rpI5CLXR408Npf/hydLHK0mMFhF6HbbYyTqU3eWMUvVV5ispe6M6Ap4FndIe
	 /bxJ3V0Se6rqRWiB44KBukfepHZNz+L6PHWNaJA2DOttKOCovO2qJW5WEmi1Vv6bim
	 l7Ng6/nzZKFvrR4GzDWL55J89hd4YUhMkk7jT2S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1401/1756] dt-bindings: vendor-prefixes: Add Sensylink
Date: Wed, 18 Nov 2026 15:58:48 +0100
Message-ID: <20261118150104.966151746@linuxfoundation.org>
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

From: Troy Mitchell <troy.mitchell@linux.dev>

[ Upstream commit f4ba4f8cc8e8df45e57c1754955b3a6b9b089a97 ]

Add the vendor prefix for Sensylink Microelectronics.

Link: https://en.sensylink.com/
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Troy Mitchell <troy.mitchell@linux.dev>
Link: https://patch.msgid.link/20260914-ctl2301-v5-1-b44b81cd2c3c@linux.dev
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 5f577bb1b692c..18327da718f6f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1316,6 +1316,8 @@ patternProperties:
     description: Sensirion AG
   "^sensortek,.*":
     description: Sensortek Technology Corporation
+  "^sensylink,.*":
+    description: Sensylink Microelectronics Technology Co., Ltd.
   "^sercomm,.*":
     description: Sercomm (Suzhou) Corporation
   "^sff,.*":
-- 
2.53.0



