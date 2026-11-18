Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060871;
	b=k5n2jqqz6t7Bn+gdjqgleldWS7zU81SqFoKcZEQ3LVIeIF4+DwULVgAC4rfTTvmgAl9c
	 uSZlyztKXKn/hNKykNuI5ZPZN6yGUmSl0ZZ3Onzex9LrQ7w0ck/59WypHKQwS+rGrgtS6
	 nZoDa693oMRMc0bZ7MK3/L282ZtsQouzVPvw+GvAC9UfnQdbiENGZvtSiFrNSOSskNytl
	 4AfpDxkji8CYLeYZGKt0ZXm7XtrGIibQ2zEY6FY3vs5B27cvD4KYdEe6DjQexjA1WeZbK
	 whDkhSeW99uNWYW2P4OqtdZ7Hp2u5PLao8VGYJF/MglAP3RGgAprv96sIg+ujNnDqnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pwwQgfftdQHWqg4M2iKcF9DGeK+IWKPanUfcER6GSJk=;
	b=fgw9fr/ESmVKwnfL/5c2Vn8jiXThToaKGwIn8dx+NgnFfv1F7RgwxMRZiv87dh1o92Yf
	 fvnW/D+b5YK0zUjWHE1Pd5unt12NXfKV8cLWrh9m6k0hepnPYHor3eZZZ60cQF5Sf7evH
	 5dOdsiKivPZ6b63kTtfdDJCBQWqM/u8MRfcdF3KLWeL0G3G6VMpuBMS4f3/DIBdb52Obs
	 rQVgacpfhF0BRGv0+NpgtrmagZEE5Cmlr/D3FaaKPMEzZampWPvsLTEwrCpfeCemW4I2t
	 KuFOALeHpBXjOMNP+K8VBjKGl6tUkifgUzISFwUVMCIlpJonRpmEZatUG/kfZqeVPPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=din7qM+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB57C606A320;
	Thu, 19 Nov 2026 04:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=din7qM+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279E71F000C4;
	Thu, 19 Nov 2026 04:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060871;
	bh=pwwQgfftdQHWqg4M2iKcF9DGeK+IWKPanUfcER6GSJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=din7qM+Ld/jLseAJB68Xeb5csu65R+11mHGbL/gfbFtCJFNtArz/M2/pU1lO/0aYa
	 wauCE+A76ra2dTQUdaDGjGEjYxHNVWrLcfxBCTbIj+7B+xFszOGmdguCFAUFBhJ6fy
	 r0QF+j42C2VduYpx+wr2+zlriDZU8uZF4Lpp27MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Muzaffer Kadir <muzafferkadir@mainlining.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1354/1848] dt-bindings: vendor-prefixes: Add General Mobile
Date: Wed, 18 Nov 2026 15:56:32 +0100
Message-ID: <20261118150016.315203284@linuxfoundation.org>
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
index 632c92ac6d0f7..d5b0f3043ffa2 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -421,6 +421,8 @@ patternProperties:
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



