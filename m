Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030281;
	b=0NlAUjhwmt6GSYe6zsGkAHyIsUAbNpKHttfJQT8a18OAwLEm+EnidBsDtRrIWDni7hLS
	 ZeMNg46PuonM3UmPmqrDb9iMJPFKsOX57AmZZQOn6UK2tqmQrWt2NrlJbr9R3y2/TPtFD
	 Umi+Dbk0jTgqdgH6+wr1321REAxcQvaU8siB+paz/rIRLQN2LxJ6ql2GG8Wc+XpmlpeEn
	 D2ZBEdaIT9uInPQB2GvuknS3AHLv4f4rmTxf7jOtnA3D6zZcd5CR4g6ZJUOuAm8YPIQop
	 uQti1dd/78mxXzzcbRsaiomBhnCkHjj3ZFRIaG2LCXhzfzOnMLI5oQY8ft0mYEKF5hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yI3N22e5DL8syIlA4OxMf3U6IHH/eet9MoRxh5bw8Ac=;
	b=OjbWCVLJgCDxZHYnxC/w/Y3qh17gAlfehsQvQ5E2yZI+LKtx/H7HyKiBvJhTpsnlxhuV
	 gThdYiHwJz8yIaZFDvO0aezoY+TKeZetuhRdbNMBE3ZTg/V8qEUJu4RJTGZKuW3DYBSAO
	 98eSFKEMesJrnFf6O0eaE+k0UZwDWEf87p5FPg4J9Hoh1LdSlsqKdj/PMpcjX57fw66WN
	 CzRQklNsNgUTE10ZEr67gdjU99nI1O6zWStDAETr5KBKYxa87dGNKa8JKh4JdFoqyjv/x
	 IQWEitD2zxj99FRO/maDpPHxUWZfP0JIkZocb2oeqGaJJ9IQrg6joTexfgXTqjOSE6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjqOpKQp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B638606A7CF;
	Wed, 18 Nov 2026 19:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjqOpKQp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43321F000C4;
	Wed, 18 Nov 2026 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030281;
	bh=yI3N22e5DL8syIlA4OxMf3U6IHH/eet9MoRxh5bw8Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjqOpKQpXuWYck9uWygkph0hzbuKJOoWVlmACL5kSr6G1p37iETs3YbqUDJcvtxVQ
	 NU06fpeBp53Bl0MTHeF6FjNlSMySL5n05lASUAiEMCkVBC53nXllarNH1FcZ66+3U+
	 af+CqT6/ykhrO8Yp2wwAZmB9blhE7X2rVgMHFiyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0608/1756] dt-bindings: vendor-prefixes: Add Retroid Pocket
Date: Wed, 18 Nov 2026 15:45:35 +0100
Message-ID: <20261118150033.164328640@linuxfoundation.org>
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
index a5202c82e7f21..633d540e504b3 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1248,6 +1248,8 @@ patternProperties:
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



