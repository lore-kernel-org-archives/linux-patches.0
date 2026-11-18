Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055396;
	b=WSU7WuEAeftNtD2ZYBrq34Xaf3hMDNNcPafrKo71VG+rcn6KR2S3maUpIj+CNkH48jKG
	 q0hIW1Npgpb0LOoiSV+SufgQS4JZ6j06SdG22x7689P8IumgeX51qHyjj2iXv7XMkEuqs
	 QTxNr4vLl9yFtKNLaRafOLDHFI1IUUgV2E3J9gIolJYSqdHtSaDVJwFYeaYZ+UB66aePR
	 GhlFib5ai/GZe35LlmZMPeaCfRVSyqDntzta0WmTAo5FnTRI9GJO+nQKwTVBw/g5c48YN
	 oSYp8cxEEp4Yu0eaoXamXXZbMnjEpTmkmwRXidFEZwi4xiQh2hRy40zoCC6466WJenA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n4vB0tfjja3BeWjlyEqyuKOGXgUICc+8qjwHnk5peHM=;
	b=S2BJiGqWIKk6zPXWFphnnC78PwpPc2MSpq/Xq7uTuXf74ZJlrNgxcJtEjN2yagdMi3yk
	 QhHOfIOlPKogsnyHLMM2j1eGOsWlAH3+oXLIRNNaGqjFh0NbpW+blwdB/cL4TR1VLttU0
	 ufs3wZokiFbGthwDBF882APC7vU2S5Bj2Y1MQWDOS2NbNpneIshtR87kZPgMo54B80Eka
	 +3CQkJ2qLyTNUwNE5+ruFr+1GqPTSpvkuxccF0o/zPojHCCpOO5ucJfKHIEv/2z/ow3es
	 CzhdEKBoIpwe3cgxReUQMHPf1R86a0HKtw2/4LC0ojpxmLQu176X4M3D8YbuLKI1Pmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RCLT4/id";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBC4606A32A;
	Thu, 19 Nov 2026 02:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCLT4/id
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4221F000C5;
	Thu, 19 Nov 2026 02:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055396;
	bh=n4vB0tfjja3BeWjlyEqyuKOGXgUICc+8qjwHnk5peHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCLT4/idlg+mCgVqw1HpcOeTVH5WeoD4wIK0cZNWdMz7fFV1NYX+KgPrNKIF0Pq/P
	 CdNZRDX+qajfGl0ZimSwLuCSrjxebsGUNwMMAj5zQN2+TuiQphBehhmsOsY3OFphz3
	 BCzorfpC6YoUdp4Mv0kE3xbpZbAwtQHPqFB2+Ry8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jagan Teki <jagan@edgeble.ai>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1616/2214] dt-bindings: vendor-prefixes: Document Chongzhou
Date: Wed, 18 Nov 2026 15:54:52 +0100
Message-ID: <20261118150116.639612698@linuxfoundation.org>
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

From: Jagan Teki <jagan@edgeble.ai>

[ Upstream commit 90f86d0c617d9461cb00f4d8e861eda28011d46e ]

Chongzhou is a professional is a manufacturer of LCD panels
from Shenzhen.

Add vendor prefix for it.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221108173120.618312-1-jagan@edgeble.ai
Stable-dep-of: 058ee00216a1 ("dt-bindings: vendor-prefixes: Add Chip Wealth Technology")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index c5fabb4692902..9cb4c3b95bd1b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -229,6 +229,8 @@ patternProperties:
     description: ChipOne
   "^chipspark,.*":
     description: ChipSPARK
+  "^chongzhou,.*":
+    description: Shenzhen Chongzhou Electronic Technology Co., Ltd
   "^chrontel,.*":
     description: Chrontel, Inc.
   "^chrp,.*":
-- 
2.53.0



