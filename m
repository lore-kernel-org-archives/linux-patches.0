Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061908;
	b=NDnkkJ4Vb7mkYUHavCjaCpEK5PDyF5Pay548syPvbi2D0Nng+ZT5PJOhdV6J9CI5YGH5
	 mk8pWYGBmesVdHJRf1/FpgkIWV7iqfaPQe5ub5gFerR40UMtBYZ6B9dcqvr+lx0ctUgjC
	 outiZnJ/y9IrBWXXz/ZPQz3V8IzfoZFyrdKcKvkVnxJwZWWrlXHjJscGO2nBMv15qWTHd
	 ATg7MyY3gLsrAgx7S1ulZp+bTQyrnIw53XMRKtvC3Yqh3DSltD8SuQoot+ogA2FlxSU39
	 W3ShrFIp3Av6ZT1F0lCiJuxbqMde1i/SHAckirs9mjd5It879pyErqYtkzw9frySH8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S971Qkp0xzB4dculn3K25j/ytP+7fRFkeuY/kNhMIyY=;
	b=brLTQW3sElQj0etLjOH7vycpZkCmiGb6AiI5M+6oseBqX3gEBFJ8CVGaKiA65RfhNc43
	 VQQEAQugDvdjTIKOu94/sEOPD7Bpzi00Eh1NE4MW/qPK/R8BlSkkMRseAhjstpA9fCtUS
	 +tsOpPHqEqHT57EYaBGppzR+U1kW4ZHe6dn+XdGU3IyjDeAvDb4dhT6Yd7MYsKC674gMq
	 cRSW0L+WEqJBLfRYoczyDRhli+ISrooSY/oOibt19kSL3Bd5ZLRP2fkNeHWk21CwHYeNs
	 ccrQlObIbULQGU6M8zCh9cj1KSz6WgdvvtxeD9X+yZpo4IE1F7rRam977gTXl5m1Z4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QXivdPl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F86606A320;
	Thu, 19 Nov 2026 04:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QXivdPl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C731F000C4;
	Thu, 19 Nov 2026 04:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061908;
	bh=S971Qkp0xzB4dculn3K25j/ytP+7fRFkeuY/kNhMIyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QXivdPlACb20SDFfVqLwAygf6s56QNakz3k+o8QB6UqSj1SS3Q0L/E3hpA9AmwkZ
	 DkeC75EdxWDs532P+BfWY4RQ5EBapQL4pXjQtv7brDMOXREmeVs20W0XFbVNmsezQ3
	 E5+ETBX201N3eOkc2apnBfrxI3ikCGrWh4yv7eiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1720/1848] dt-bindings: vendor-prefixes: Add Sensylink
Date: Wed, 18 Nov 2026 16:02:38 +0100
Message-ID: <20261118150031.654878574@linuxfoundation.org>
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
index c75aca426c110..a98cd1a5da4fa 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -988,6 +988,8 @@ patternProperties:
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



