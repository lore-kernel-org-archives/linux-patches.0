Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017516;
	b=BuUz+M9X+1k/VlkGHoWFTPRYgCZ2T9Vup8enpIJLQf9jVb3EwvP1yr/BgA5CzRR1KOjP
	 vYJMxLk4rgKJSYqOx4sDvbUvwBhF1ZQPQ0N+wbEnsaRcYX5ECow7lkVXgxnBSHHqVRIHp
	 E09OltIiil14t4WB6N7923m/DiMl9FIoEtqxDAgSZgFU5eaqfORTx9Yss2F71ZChYGnxT
	 4yWAlFbY40/5z77gUk+POp//Ce/32agoU3xMUtMFmRR96Awlp1ud0KbK+aE4obS204x9a
	 3FZB7hu68PlSilPdWyuVkyBPAolY359jCKwrIzdeDM/cQOof8zsB2SPm25d1Ym8dR6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jvgDMcrMIJdLC2/gVHFi2qXDcz0GSp9YC+aLCnYK/oU=;
	b=ORHF2TScmz6K3TcJpppvpsftW4FFFP5VKGR1PEVoH068UXn9en1//fw+FRwY/yspV1e1
	 /X/QI6qWtEHlzz771o3eFtEn4RGfnD0P9KZxsWRwb6WOHVNon6RL6bLVah+dCesgRr9Wc
	 C0AiO10B+wscU9gyfhhFAPp4hm5/KK9dbgfPECH7TwXkY5KwYXcY8bcLc0O363Y1Bj58K
	 +baaDHwhOyei91CAFqT9YgVi4r+67l07GqGm3f97SiHYxwN8XOGi1RlESffbQ33ghIJMJ
	 o0e+fhFrEno76SqMafjrwCKgh5aza0WowF5xUmMTsDsS4HkqhaG3NKF450QS2ESgjeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNj8Mkx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAC3606A31C;
	Wed, 18 Nov 2026 15:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNj8Mkx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B681F000C9;
	Wed, 18 Nov 2026 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017516;
	bh=jvgDMcrMIJdLC2/gVHFi2qXDcz0GSp9YC+aLCnYK/oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNj8Mkx4yIl/CYynCYN36HxqIO541LWNzeEsjolRkMhI+8VFwthwz6Ce3M5uL7HCV
	 mXcMR4OOg3daLcnjshSNtsJmHSEVzyWmhRAMNUzQWCauKS5zE1n+5CdRFPzZFDg1vI
	 Ge0WjcwGdsnwKHYkuPEqTUq5fhsKAATSFTZENXRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0871/2651] dt-bindings: vendor-prefixes: Add Chip Wealth Technology
Date: Wed, 18 Nov 2026 15:35:11 +0100
Message-ID: <20261118150319.212398138@linuxfoundation.org>
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

[ Upstream commit 058ee00216a1356e710446b59a800065d2abbd80 ]

Add an entry for Chip Wealth Technology (https://www.chipwealth.com/)

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260727-ayn-qcs8550-v9-1-e3db456e10e5@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index ba97798666cf7..71c7ca77aee1d 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -327,6 +327,8 @@ patternProperties:
     description: ChipOne
   "^chipspark,.*":
     description: ChipSPARK
+  "^chipwealth,.*":
+    description: Chip Wealth Technology
   "^chongzhou,.*":
     description: Shenzhen Chongzhou Electronic Technology Co., Ltd
   "^chrontel,.*":
-- 
2.53.0



