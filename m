Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030275;
	b=bKzuza3kHDPogezxx/Mitf+d1ulgue2ysqVRWc8DVup8NLtPAFsrBlI2+sBHdTfFK8mb
	 9h+U3Ouv5gOs7vRHf2UUmNay02TWVN3Uro+l/H640GBfMEoB7uBTKoZAnFH6FIJOa2GOG
	 NepKyWSPZ6bWmf1TV6YuDRECpbAjEK0XTMGSOHh/M42wXtWBLC4sMh/IpsEVQ9XuC6SCr
	 OK8ZP4Tc+szTAQdOy3BPYkV0OkqGDVMHkHz9aOJQRPN0nGXum/gczvEKw+OEPdg5u72fk
	 mLlgqmjtXSR3xAIZQV4c9Wmw5p+7TL5eis3iHqR2oDYXlMzAvU8yaXI79fIjuzxGT1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5DIETrX015Jkresk/YHn1nxBHc68WNdSj+VwfjK8Lf8=;
	b=QsRh7uUewgdTTTCNYc30DBCp5SkfsRD69UBsdAplks+EWSVjAfj2fq7ghdgOeC0O/qH/
	 RYIHQPsmAXRK4BK1V1AYiz1+qasxk1Pcljh9vLLqh0er8TMoDbPm7hqtFDLLb0I6J7iWG
	 1DshJKTxul99yI4dogohlIMVZ9FssEfsfo+HELTeG70laRqCA4Q+fylwgdSHA2dSNMNKc
	 UE7hWLoZhQoVi0o6Mm4ZYQBpuLRIczr2N7mvor6WsFanzaYvsa3nn5dRwMNdGi6EI8Yoj
	 +IdMEdF41VEwIEx7ebwPc3E78d4NYR893yIhIrXoHvgxykr50uEHX9qLJw7kSn4/G8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZguEAShz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAD2606FF6C;
	Wed, 18 Nov 2026 19:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZguEAShz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308EC1F000C4;
	Wed, 18 Nov 2026 19:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030275;
	bh=5DIETrX015Jkresk/YHn1nxBHc68WNdSj+VwfjK8Lf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZguEAShzrwgMMDcocGItYkzdejhLAgAR1ptC5QJ9aq73wgM8t8h3CRWO3aPFtXNLw
	 8Xogvke2nyQ+Q19JUmQy1c7b8trIlAvRsQhOllCAtwvPqMIz5E5yQxXdN5sKuzpvy2
	 bQVfkTItjjyv1irfZt1SrdBcW6hMSTAan9MTZBHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0606/1756] dt-bindings: vendor-prefixes: Add LeEco
Date: Wed, 18 Nov 2026 15:45:33 +0100
Message-ID: <20261118150033.085019937@linuxfoundation.org>
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

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 1658af4d25bd3133d1b3403ccdda6214d40c0ebb ]

Add vendor prefix for now dead ecosystem company LeEco

Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260821-next-patches-v5-1-ec81cee63e09@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 3db3503567422..10038744243b2 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -822,6 +822,8 @@ patternProperties:
     description: Shenzen LC Technology Co., Ltd.
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
+  "^leeco,.*":
+    description: Leshi Holding Beijing.
   "^leez,.*":
     description: Leez
   "^lego,.*":
-- 
2.53.0



