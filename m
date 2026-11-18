Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060678;
	b=SgouwFDedhaboqCd/Vp3jaySBDAR52Warg7Mikj26T3JPnHGByBVSpYw4+sQXtqBT6di
	 lRBparqZ/rZSuAGKl5cbf+TGcizIbjjFE8ZFdCt+YIJyl3UIYJjsv8aYI6tAM4nVezsvt
	 PHZfhn5ywwDrYz+dFmd3M3wMqmqPke5HABXm4XXx500XXhBX7wLAG4DF3QfbrWUSKc6bD
	 f+gwb79SUnQPA3eGWsoEKXvEhYEgWRdDTcLLqDxol+PsdYaObJ+Dn/3mh5pfKTzzQFXfJ
	 uDnJm9Dob2IbVRlGPZU46s3THNilekemfkOOCdrTFmdT7bX1b5u82o+5lBKrVP2lDgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9tSDkkQpSSrNuFUNnC/0oeK4ppbcDoJf6jqtNUEt9A=;
	b=cZ90ci8O4yq/2tB5VyaaqTRPZtFah1IvXTPaUHqQZYUqbWLkRB5C3xc+UuVQdk4WZ1fG
	 vUdpwfeEWQY4crf0nB88yw5MezwFOOBuo5KNtO5TlxhK3TbmSrdwsPrtNBP5sC70ZoC04
	 7ljSD7pjNYlXwPyNVXm6t2MhQ6wMbx1B7zYPrV1dm2sBSJH9FYQa8kYWlwAza3as1afxL
	 52Mya8RGMlugi5H/cbqgJdaZarv7DSZQuOUlIY1/Eng6BYnSkSjvUaTAyisr7MMEJ+vYr
	 MaoRxvdYHOvKcxxJ4AgAQ1BwLzBExABiiRBldBSnj1iXkz2zSWvFWQ3dPLxyesyjrZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UaS4r6pw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB0F606A320;
	Thu, 19 Nov 2026 03:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UaS4r6pw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ACA1F000C9;
	Thu, 19 Nov 2026 03:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060678;
	bh=V9tSDkkQpSSrNuFUNnC/0oeK4ppbcDoJf6jqtNUEt9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaS4r6pw3sCqj6HTF6HkHkaIAw4DKZfb6lxNsFK1f+UypYAL7Sao5yHC0qKGEpsZm
	 5DE1je7hIwHNgX7uf8ictcLLjqf9OaFimgVLVff5JJ3mVhtmOilmMqpOj02DnTHohq
	 dH6ra0Fvj5A/F7NEUWCFlhoIS10O5cijo2JT2uHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Asseily <karl@asseily.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1283/1848] dt-bindings: vendor-prefixes: add ESS Technology
Date: Wed, 18 Nov 2026 15:55:21 +0100
Message-ID: <20261118150013.310714887@linuxfoundation.org>
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

From: Karl Asseily <karl@asseily.com>

[ Upstream commit beb56d1d3de522885b30bb97fee83825041d65c2 ]

Add the vendor prefix for ESS Technology, Inc., maker of the SABRE family
of audio DACs. The prefix follows the company's domain, esstech.com.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Asseily <karl@asseily.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260918182317.143223-2-karl@asseily.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index e04be09dd0291..194f6480a8503 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -345,6 +345,8 @@ patternProperties:
     description: Seiko Epson Corp.
   "^esp,.*":
     description: Espressif Systems Co. Ltd.
+  "^esstech,.*":
+    description: ESS Technology, Inc.
   "^est,.*":
     description: ESTeem Wireless Modems
   "^ettus,.*":
-- 
2.53.0



