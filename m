Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060916;
	b=3KjPvwp12zQ3rU2UTTIha7jZY2XiTHUETozRx4m/vYm1PSr4OsS9/aKAzszV2tTzCKoR
	 mqSE5vIO9TWYtpwZ0boClgUquJQh4hRCKl357ZkIcs7XkNNK6eiMU+IUVPvIcSVyKxI/P
	 Fxp/HvgSDQdu7j11qqWiqHX5LbFRVonPxO8Sk4p/1rIqRAKEhQvhihYai0anCmdrBJv3a
	 X8zYv7K9UUG+M2ihjGS9sNOAfIL9t86p0fQGJwXDRapGjrHmhLiXuu+tCHjOOU0zYdsGU
	 2KHYJx2f2RvhhNrwGxrj/5S6mE1v93wHrWcGAdKZcz6pyCBKDFbX9NcJxVNXzpnJH3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kho9CeQDf4I9svww3sNwd8xXB+JPSiwKehPa5mnZVio=;
	b=xl+l6hP3MPm77yXeVRMdcLG1hkp56iBeANT6QxapeTVGx6I8TOrzkcOunsFpE8Z5OxIO
	 KaTesQv+N6Z0CjLiToIQBeq0Os13ldIkekf7LyopgwkLzNPFRH9/eegY8swonmaq84l43
	 gd9kpvUrH3OTI+nQ64d6Y2qiDXHjwVf83Nu8kdU8pKXwb1xsPrqvhN5HsJ4NXP+1Vyem1
	 BH/EE4+r2+86zH9UN7GiVeDevGDF1n+bl/zIl3FE5MJbrerNa6x04iNVAiIiHcijcO8wL
	 tSi9eHIveuQbAqzV/Uv3nPIBCBHg98ciDTb/VDCFk6Q5bgARhIQLhYxVoqyumlh+5XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSmbsIut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AEA606A326;
	Thu, 19 Nov 2026 04:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSmbsIut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A531F000C4;
	Thu, 19 Nov 2026 04:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060916;
	bh=kho9CeQDf4I9svww3sNwd8xXB+JPSiwKehPa5mnZVio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSmbsIutLLN+ioG5cZCys1A+AMR6/IEl4NzdBirrFZp31fAXzzLDAVPz8XqeG8Hzm
	 lfuNQsGKvsNRob+cf3JgzAFcUH95voRc1YmrvuzC15BeOb4Jk5Seuevu4VM4jEt2y+
	 7IhUXGwBTFopUdI5f7F49IwSlWrvI/SOWB7MBizo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1368/1848] dt-bindings: vendor-prefixes: Add Retroid Pocket
Date: Wed, 18 Nov 2026 15:56:46 +0100
Message-ID: <20261118150016.834214241@linuxfoundation.org>
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
index f97134bb2a00a..79bd9ede837fc 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -928,6 +928,8 @@ patternProperties:
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



