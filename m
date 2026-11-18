Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017425;
	b=KVJdSBsfcx/ECswwlVGWzQJj2+j9TFBXQV3Yix4xNSGFvNAkX8eMtdwDaGZF64g9KFaU
	 TX7TUp7UbLfJDRfW3Qbnufkt4rZpl+Hrr+UPDZwJbhyCeOMq8s196pv0qvjWDAnu+oywD
	 k9Lal0EutheGc8gq0Bkh/wfxeItwUJva/39fR/W7Gu4qq4X4etrWvve4trHiEs7YWvPkX
	 tfGSbialuXlUmdVtCTIoh4Dg7qlw+ERZBEWwGjvRxUaKa2uKuQu/yXMqX+ylHpccdJrdV
	 akUpPUapbFkbHnjqfHTHA8Yp5ejbqQFgT+pNwofKOpYhLiZn8z5JIkQ57Me/vCLiTWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i/HMK0BtdRY6z8dMx4tBPwj6cRYEw+dWX94tVqiyQsc=;
	b=3C4E0+z0QhI37VkpTzGipM4iFn5z5dM2rRZswg5Wv3++ZXUsfFWgHb7V7uNOblx4nTAU
	 oZPFQLBCfZug30aPFUadc1b6JPLOzYbtqiooPUOVm6es9EIN3PRKPPmA707P41E0wTgI9
	 KCtqdHmBJT+W3Syim453VBaXdS4TjFFVQEThYeaNpBkHBgUisw3NZWdnMkmKDAs21Zjo8
	 A3qbDZaI7tJtGoVO23wZ/UZDliNDCqDcO0MpYGowoYLZ+59cLGE61CbokUG77rz6vFZmX
	 MRJPjVcPuNPHrRO5MVmAfSfjcjxcWAiSFWBjgo/vAIUekgtCMscvlIE+NcfstauuTcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FtwMEa/D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D58606A31C;
	Wed, 18 Nov 2026 15:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtwMEa/D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE771F000C4;
	Wed, 18 Nov 2026 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017425;
	bh=i/HMK0BtdRY6z8dMx4tBPwj6cRYEw+dWX94tVqiyQsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtwMEa/DMIDs+20abhFsckWpxNzz3amou+eCvE68kQxvu7HSVlJnF2yxjGpN+QVf6
	 UKSWcJ2NaL+pTmmFYel6255Ayzc8IleIjpI8RPU/4+7C2lgNUi2yjSTNE7c4Yaw7Ds
	 W3QoCCVybQMseynCny8l9/UcHGXXHVSwEcwnP1iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0881/2651] dt-bindings: vendor-prefixes: Add Retroid Pocket
Date: Wed, 18 Nov 2026 15:35:21 +0100
Message-ID: <20261118150319.573951930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8fd9d4b4af70a..f3e9129ee88eb 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1431,6 +1431,8 @@ patternProperties:
     description: Renesas Electronics Corporation
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^retroidpocket,.*":
+    description: Retroid Pocket
   "^retronix,.*":
     description: Retronix Technology Inc.
   "^revotics,.*":
-- 
2.53.0



