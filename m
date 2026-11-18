Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056594;
	b=faoObuJRE5bpdfdv6Z7vqDaSHO8Ge5IjEXAE1i6w0UZsp8DvZIh/sjWF8J7513zwhYWB
	 2VYTFngP3BKyTt2xlyCO0sF4AJakGZQ2RsKxSeGBVf7FMSnYc/c0Tfyq2Nt74h0i10DkP
	 SoqdyF7dBsEZ/4TUCAMM+3avoe7vnk6GOwSnFtoBfONIBKecqXnlwIWfsCzGbNfRn4Y/r
	 quOoOLCXrAoz1QxNP+3RB3T+cBY/p7bLfQLqWPQ0KI04OJyaFa8nZEAkZ6gowDsXogKms
	 dvrBpzSkc2Qe27FE1goJHeS3MFnuGyVhUlxpVfzKZcgMsy5T3FN/NeV7IQvsVCYwFrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AamQqNSZAlmE4rEGw8sfRTFdG6kFsE9141ii2S3TSog=;
	b=1F9N9hzlzRpzmmadYg6lwRiKxzgu+HMs+oSq+lcQi5qaM4V3v/2hQJQWqGqd0ZZDW/SB
	 dgmb3m4BfKUuobI/qn8DSoyeFcokOUsuWvZ8AuEBNUg+7rAEARNSr3tZK4ndHoSnBZBkT
	 Db8aAzk4JxHSzq8jFQ03JwB/aAex5kvIHneK4Z3hXH36hDfues6cE4C2p1U756TMCBWPI
	 gHe+VBHx9qvJtWH2IPGbmlW5Fkuw1RTpGn+FXTkEhK4WQS8HGzQWZJFYsP/DJKoYrP3I5
	 1Edpp9OL+tekfggICAaJVT8wP38W9BUqvNM52+2ALS4ZoW2WFvJhjH9UHxzhNVFSL2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKs6jD09;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A506E606A32F;
	Thu, 19 Nov 2026 02:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKs6jD09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E031F000C5;
	Thu, 19 Nov 2026 02:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056594;
	bh=AamQqNSZAlmE4rEGw8sfRTFdG6kFsE9141ii2S3TSog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKs6jD095FonJuVDZ7boERyV51Yxv7baPFecagSmcF+9HYahskYBlSV3jZVFe6stt
	 7pp5mz5V0D/umeGzB8ynQP/q3lJBmNLmPDF7985mAcjmdqGl0ApeTQRO4dcYfcV/CE
	 +Plt3LlWATg/uEgorOIgYpkQIlzuojP5EMEe9ZiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2044/2214] dt-bindings: vendor-prefixes: Add Sensylink
Date: Wed, 18 Nov 2026 16:02:00 +0100
Message-ID: <20261118150132.484932089@linuxfoundation.org>
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
index c538bd92b7af3..3adb39d121ff7 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1064,6 +1064,8 @@ patternProperties:
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



