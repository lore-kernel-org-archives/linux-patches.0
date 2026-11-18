Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040290;
	b=1JyQqT+9juuhcQ8omFZSbi4iAWN/GDsTddaVcOf7w+FoImHeTAgPSsxHAyGCdVMZG2k1
	 i8ZcaEvX6NFeCmdha4v60EVrhskzDyukq7ULj0pcOjny7rYRG0eRamX51QYOogrEq+uUD
	 KbvvRyVClivjPaTZ62/2jC9zvuZ58ezQghvDnWxIazuvPo0hr/NQ8JNfAEqL2Gjj/f2gA
	 wtREry7koijuGGjQhUwSVakloH26XNw7lH7z9THVAG/kpCSOF1IkIJqTF/KWgwJyD2jUH
	 uurvLO9lE5VV++NM+gMJaFuLNumGI11WrzShhO6XXqe6fMe8b3FWpQBerK1//09AmcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZ/RhoC4GKD7YBI3oK1julisl+72orvl+i006qRuAws=;
	b=2z9WibNUxjziqqYT9ICQC6Yl/6lmIRXUagNlntaiRZZF1cuQt9v4JmlgVN2Ekj14tk6H
	 pDDIZAVrYyRSWzOC+rXfE9rmB1f50huoVbdylEPty5/JeENE+nniXmRk8n1KX13yyOMh+
	 m0gxKOD3eitj8QBvv4zASI4PCLgVxMdmgSYA8kHwf3GLfkC4qLFhAbvGU0UE78d+q2Ud0
	 G3V1oBkaxNFy89+4bUMTzDcRo65qE1DN+JBr5xIPc/LBl4RIvKLaOI/zeFZDEws8UbZVf
	 vnNr3hyXvVxeY5gClrKyz/hSxMXxr/SeygfAyqtt14if5I72BI4I/1xEvLJSTCrM2Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvJj35lh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EEA606A320;
	Wed, 18 Nov 2026 22:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvJj35lh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F491F000C4;
	Wed, 18 Nov 2026 22:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040290;
	bh=eZ/RhoC4GKD7YBI3oK1julisl+72orvl+i006qRuAws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvJj35lhioeaGYE/M+Upo83lsraihTCX2rz5RJFr0DhE33U9iRADm5N0pElhbpSjQ
	 +VTH7wLsMmzAHbOjutCjZvn80XUSH3vy/3YeGJkJeH21xOaBG8Y65iyOlgv69fYVTg
	 v46+yNfmpJMYWeTGmVN2CPqzy7IOPK8nes+h2Xys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Muzaffer Kadir <muzafferkadir@mainlining.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2364/3318] dt-bindings: vendor-prefixes: Add General Mobile
Date: Wed, 18 Nov 2026 15:49:46 +0100
Message-ID: <20261118150432.497782170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muzaffer Kadir <muzafferkadir@mainlining.org>

[ Upstream commit 7034bec693b752bcd7ebb4fa00dc3b429b4dc4f7 ]

Add vendor prefix for General Mobile.
Link: https://www.generalmobile.com

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Muzaffer Kadir <muzafferkadir@mainlining.org>
Link: https://patch.msgid.link/20260921-msm8952-initial-support-v3-6-b96fd3fe298b@mainlining.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index e8ea99fc7b04f..58e6378c119da 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -524,6 +524,8 @@ patternProperties:
     description: Gemei Digital Technology Co., Ltd.
   "^gemtek,.*":
     description: Gemtek Technology Co., Ltd.
+  "^generalmobile,.*":
+    description: General Mobile Fzc.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^geniatech,.*":
-- 
2.53.0



