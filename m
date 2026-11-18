Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017981;
	b=etb8ZvTLGNjzHEsECDHMnU6pny1KEuxh5c8tSYFTEZlMd7DIYQct4dAJhD0dkMa4hpFL
	 WGsvgbuLAbQh9oOpFHhGEGH9umGerr062Bxq/3HmexoOURc2N5JPv68JwzfJ/Qc2wYHjI
	 OMz0z2MOhWhLyc2a+Re4k86Y/Pvia9z6B/+2uefipKCd7qOWlrvyU8MChgxTI6EO5rZkQ
	 RauyMq8h/cuHW+45oUjH8mQObpkASfkpYru35RNvm+9oWJ8c7ddCBBDM4MJqvkDk1CJb7
	 5CUFiusRUR7qgLvO5qFGioDxFomUE9TrTE9wpkWR2+VkJZL3tjvQKVytIdKD3/E0Syg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UYwHu6EGLubTTyR8fnoy2u9qlCNk0kIEwTSovFTxHPk=;
	b=y4oDnnlBQwaM/5VcIWJveSXStmYtHOUro4EtlYtTGzIFZv/oDMB3zQM6bT9vt7w+l+SQ
	 Nq5TmRb8HbuOooCHZVv6WuReAEO9EUEBs2ONwV8fKzJP83OsKi4/q3PLZlzPNOMfkA8SB
	 h/2oL2CNPjFtCZhWMNdLoCyBgRWGcgZt0QZkjpjegtwXlwyaGuY/Opz10faKARl5NoMVw
	 JDs/eIwsEykxzx05Brd/1gCCmdWxIZARyq4/RyTFpYFeYfbzZNAgIW348muue0/EbCHXR
	 SNI9u2maPjkcvhIyq2mjc4os5KMUNyu5zkMwyJ/tThkfv2IvxJe1Tt7gctUJlB56lgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AeMOQLsg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FD9606A31C;
	Wed, 18 Nov 2026 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AeMOQLsg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCC11F000C4;
	Wed, 18 Nov 2026 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017981;
	bh=UYwHu6EGLubTTyR8fnoy2u9qlCNk0kIEwTSovFTxHPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AeMOQLsgPBp8uA6i1Ox07dlFXFNOwKz8NZot9W19go1yRcNJcdG72nMHM9fK4UWk2
	 VCMHLdkFplNqo8rPNerDOkX6OHCd70UQEVMiq+P4HHrdNWQtch5DcRsb8mSXnd0HCK
	 u80k39yRj8Jo7coAIeZZUOUr5wAMGJpkfwKj6L9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1077/2651] dt-bindings: vendor-prefixes: Add Sophos
Date: Wed, 18 Nov 2026 15:38:37 +0100
Message-ID: <20261118150326.766433376@linuxfoundation.org>
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
index f3e9129ee88eb..2d93308624cea 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1609,6 +1609,8 @@ patternProperties:
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



