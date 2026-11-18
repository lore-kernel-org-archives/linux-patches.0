Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055404;
	b=E9+XALG1Lpse1MvNWZXkXYES+DUYJp41tcbVe3kwKuha/bGGQDhjldYanem8AkvGloQ9
	 8Youy/agpXPB9+nmQCLFmBs0Ywfwj8dAogJayR6Cik0XhzoaQFMDO8fmXb/+QFyuykZkO
	 P3REaiEIcCXGuok/NaUsa4RLGcr19rouIjqCGwWowNpeYk+etWg7xZo7HTHouCNjNm6o9
	 tQwm9lWlVk63j22RKbIDppfXBmzZhkwTuu1raM3J6LoKF1iXisMZUn3fSijf8WghkVguG
	 i+XAlFwY8rqhd02RnOBu71GvSjtbVvxw/FwQ/flp/jKYo5IxCRsAiyxYpgYcb7UrQuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aiJwCaaEKt6dhOihHrZdJmE+fsmTwo0kNaWXUDdcN8E=;
	b=hyWua1BLfPQba6IT83eLSAklyi7rMgjtVGDeybXpz9Q7Iwvzn6HLTcXabuMeUabaZKF6
	 Ne3vFBc8zmgntNmofeK0bmovS7CPo3sEj7zVcOLlOboCt/lZGDCMM8EkgavMxp12IDP3s
	 k11YLB570dZ5XhmUfG2iadNscq5f0ggWYmbGaJoczlAqdcw/5B3ve9Urhewxi/f5ILWh6
	 YYAU20Dyuh9jyXdkl2xeOf39Jv8/toUafQl2/0MEfWe5n4//06DDRwLzrk0jfuHTsVfqH
	 xM9u3cSWncLoEOYBWAF5lfUJOzyXHgTR0JTCU6dyV8WieTZ6TLQ9lUqucbgSTw4DYMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7uzIh0v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF8F606A32F;
	Thu, 19 Nov 2026 02:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7uzIh0v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D877D1F000C5;
	Thu, 19 Nov 2026 02:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055404;
	bh=aiJwCaaEKt6dhOihHrZdJmE+fsmTwo0kNaWXUDdcN8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7uzIh0vFnQVqaibQ07VExYSygERaYsGAqFW6ASXoloumE6RJTb+oBYwLnw3jBRh3
	 aHdqvWsY1H9oDbw16UCje3Apvg4dojFd2kn70GUZ7KylaDegUjlsf45uNtJhwXsxzD
	 Ma9MZUdXQFpsedOk0uM11/+N72s7f681Cgit4Pic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1619/2214] dt-bindings: vendor-prefixes: Add LeEco
Date: Wed, 18 Nov 2026 15:54:55 +0100
Message-ID: <20261118150116.747456443@linuxfoundation.org>
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
index aa06eff78e45b..2b4e259fd816a 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -651,6 +651,8 @@ patternProperties:
     description: Lattice Semiconductor
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
+  "^leeco,.*":
+    description: Leshi Holding Beijing.
   "^leez,.*":
     description: Leez
   "^lego,.*":
-- 
2.53.0



