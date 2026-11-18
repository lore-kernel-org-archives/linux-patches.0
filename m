Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048655;
	b=LPJeRBLNnQvzGuuUc/OXFkNSads1tlDcFFEm9BofvgcIuzfE/zdjhGJa2ZVpAmYGaA+Z
	 Ru3fPlu8R8cgUWPPwwRcMoj8wjgLApESttzL+JU6tLetXkd4mnz3w9tUiyZuBPlw14ts9
	 dx9mrWB7UibNy08ZfrzX9e0oOaU2PgsZuYszSAlrMmrLD8/s/ueD9u2f1ZHsdfOEDd4YN
	 t4+EZVZBiSqZ901f64gD2tsEZnT4WmlOxsDEXHd7Yy9kJ90y4+H0OjCitnjgTfSlDIeYF
	 QoDgfU3ek4EJGMKKO19Qnm8Jhx85DvpGza289YDOJwwMs7yPYZxmYSMdBPynp/CUmsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H5kHli/UWmagdjaDQTyAN/x0RONpHGrqMmtmOiRWuJ0=;
	b=43EEDixlk3F1j88D8+uEl11N8zbRdA54dn1sBcEozJFSaeaNnzuorb3tKmrBCzmUYC0A
	 wh02gfICZki7vr0lNpM1hFQEp1titkUG9L+23eyvpLt8aZ69ofbc99fg76fwwTIHTiDno
	 /fZMDkQ6OYh/Io1zUvQcDnlHDESphh3RL93J26D3uZYYi7qKI8Lj2lNC+VIgorSAdoear
	 9XkOrflWGxlxKWpB6DHs1iUh729HFSX1aQsnCnqAgXwn0JDJ2dLuULCS9Ny34CklLp9z/
	 m9mgyQZujVJ6URLK7qrGYHvyPPQOOcsnJqKzRxdh94gymu7QUdQDUzwsdkymDcNry+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ErLF+Xff;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183ED60A2606;
	Thu, 19 Nov 2026 00:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ErLF+Xff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4461F00925;
	Thu, 19 Nov 2026 00:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048655;
	bh=H5kHli/UWmagdjaDQTyAN/x0RONpHGrqMmtmOiRWuJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ErLF+XffljHijf12Lfl98BNQd4FNamV/MYwdDpGZUmyClA3GKeR3KT3y2UW3rDIZD
	 36LWV1OMZuSmU6Qk1KMXB8TA46E69pRhmHKCPzAjr9krn5cZNCk0HlPKNizU5xvZic
	 jLnWXgX53AfPEdZHBL37+5hX8+ZwFrSywH7fTVsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2035/2857] dt-bindings: vendor-prefixes: add Free Mobile
Date: Wed, 18 Nov 2026 15:51:09 +0100
Message-ID: <20261118150314.678818022@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5300ce3edf348..ab9238bb879f4 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -470,6 +470,8 @@ patternProperties:
     description: Baoding Forlinx Embedded Technology Co., Ltd.
   "^freecom,.*":
     description: Freecom Gmbh
+  "^freemobile,.*":
+    description: Free Mobile
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
-- 
2.53.0



