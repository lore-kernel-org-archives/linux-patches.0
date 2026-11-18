Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024960;
	b=vCSNH9bT4Yp+GB8a6Os4EGg4br3wn45CjuuajfN8GT36O6nSWsX2v5jb/Cgr42kvvaMK
	 L3mJ1mxS86SI6hlyJ0AEfgVUrifWKQLyREaqHSowqQ7c3m+duuGD1cGOZa0cDQzkkqzkF
	 NoE2VGBYXCRYk5kfDAdWtRUvcN4nf9ZS2nbPE0GA86WCriht2FrrgoesuP9uk2aOjQjsU
	 iQ/HH5gvxdqVeKnvYf9E5hHsc727/MLHiklahQPYtZV6UXH+cfcCnnx2nwpg1SR1UjJMf
	 VtILDqPzZXELqQboySTAr8ajBdfEsy5QI2mabVN7cqkmZZrXyAfXxb3UF4r33LF75IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5qDLqASf9G31JqBBBdZwMFe0A1o6unZWKfxgyIELU9Q=;
	b=RnqumyAESQsXicw1O2bPd6uK9VkEHO6CrsFgAwTKh7MBLPy7ZEf7clBwTZL3xQVfy3Ne
	 f6Mmw2bfhRyF7TUHTSifJ4yThsZP2m1B8nZAHh1oPd12MeRUDvNbQ4wmRDx76yLS1KWC5
	 0lwRYcrzhwYCVIgxXnAzBGdXpm78gNx7NmCOL4ZQg0p3Z3CWyCVCQXN6N11W8hX7PeiUq
	 1eStTwrOhl4Me9NVkzLrOiS7QR20GV4sOc3GrNEUpZsg0RdbRE1pvXs/v5H69RRF6tiPH
	 Nfj4N5p5UtbeHEoxPvPWe4vXNVey0lCIOa3ss5FsWe5LJVlXspRj15VJOsfWbG2YhDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFG4b5IF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A72606A331;
	Wed, 18 Nov 2026 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFG4b5IF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0255C1F000C4;
	Wed, 18 Nov 2026 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024960;
	bh=5qDLqASf9G31JqBBBdZwMFe0A1o6unZWKfxgyIELU9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFG4b5IFxTY8lTqonlT6zz3yC1jCqLQFPtLAxbTjlCGk6PJTYEZFVNcV2qWL9oh+N
	 M+a/b93qfy/w7DJ9nNQfxbS4Hta99OdN4dlt1BT32Pl9XXsmslCD5fY4ofKa5wu7nA
	 fnx3PFtq2wkZSCRbOCUwAByC5AVlGWHzd4AJumL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0908/2151] dt-bindings: vendor-prefixes: Add Sophos
Date: Wed, 18 Nov 2026 15:44:03 +0100
Message-ID: <20261118150155.426494200@linuxfoundation.org>
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

From: Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>

[ Upstream commit 538f8ec6b9c711833c5217a8bd8207a282265303 ]

Add the "sophos" vendor prefix for Sophos Ltd., a vendor of network
security appliances.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 80cbd78cc21df..52aa5da45d616 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1523,6 +1523,8 @@ patternProperties:
     description: Sony Corporation
   "^sophgo,.*":
     description: Sophgo Technology Inc.
+  "^sophos,.*":
+    description: Sophos Ltd.
   "^sourceparts,.*":
     description: Source Parts Inc.
   "^spacemit,.*":
-- 
2.53.0



