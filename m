Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048880;
	b=UlkTLMjSDq7b/To2MY7un56rSSLninIYHKe6hOQ23mGtT1sjZi6xvXq/GS3PMB45ZuOB
	 apVvhqaRjICB9bxxYKmvWTToc9+BEdAnDnlMsDPDOLc3zk/BmkTWYdjRIMERg8pNHCw/i
	 1l7RKxZVd74DCbHFGnkWp6N5EzWHJue9xXTkkIcoA1YNG0XY2+KxeUkPZnh9lNDr6Nvx/
	 H2YlRwwnNN4bZW3fDtl24xAm9SWP3DI1YRkyWqoGbPC4OZ8Rp2+FaKkbEo8gR1on1IH7X
	 J8j6pEvQSXF46OFgibJqPI+pgNFltKhhaLaBNRF0eY6DsL9VYiPDg6cE8tMNUpOVVOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vtIJ/t7pKAK8wyAxIqOoKYjEZ+fnox93R9qat+nCJi8=;
	b=nNOP6o4KdbI7wVKKLLnoxObCjRNm2pv1ggGq/+U9VmY5qe/qM7qgF/hpvNCgrKXNogJB
	 23iHiaIabicqMT1y4fJU0KCupY2TO2dodJ0QU3Ed0OcbRLGhPC+zJGFo/B+oZKZCZ/oCZ
	 cizN19VQpAG2GTM+ZACDCNRKkZLYKZE++LfUMS/oAbSexTsoWS90JqjWhbKJiy8GCPvvL
	 NgjeGErklK2w33aQ95b4pX1DHlx9821xhCPt88VTpUDkdsROs8PRaDaqD5PToTzdD+tg+
	 YBznb/WbCN3y3nInWOxgzjPQR1OLm75ccoZ/VGTnOvcOhK0Znp88atz23l7lzXaQlzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T43b0dGB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAA5606A325;
	Thu, 19 Nov 2026 00:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T43b0dGB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386311F000C4;
	Thu, 19 Nov 2026 00:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048879;
	bh=vtIJ/t7pKAK8wyAxIqOoKYjEZ+fnox93R9qat+nCJi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T43b0dGBMj6Db0o2bRD4LNWyUuIVFzNsr/GSsjKEWaBmMuQIcYjPJDCgNedPYFTdD
	 ZCHbp1/YOQouMemAUJa0gjE9ZhD1P8ASKLOQ1iXWGITo1jCWsSZDSjh2052lq9nXJK
	 DRKE/6lfO8imry/6QkgEZwlUrWVe4Fk5mh21a3a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2151/2857] dt-bindings: vendor-prefixes: Add Sophos
Date: Wed, 18 Nov 2026 15:53:05 +0100
Message-ID: <20261118150318.846673322@linuxfoundation.org>
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
index 25e3309a8567f..b8fb542fa9d11 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1251,6 +1251,8 @@ patternProperties:
     description: Sony Corporation
   "^sophgo,.*":
     description: Sophgo Technology Inc.
+  "^sophos,.*":
+    description: Sophos Ltd.
   "^sourceparts,.*":
     description: Source Parts Inc.
   "^spansion,.*":
-- 
2.53.0



