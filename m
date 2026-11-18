Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056592;
	b=CPVca7YZGrZZahF/OD2APXAmCTGgJavGWjsU7xDw9Xnj8dLZtTz89SFh0G3y1oJYQnfv
	 raX/OaXYPlPERlDNbpf8Cz2S41wtbSier2SMIc9jCtXjvh+2ku40661YfsCBVZXV2BQsV
	 NmzH9heEcJCQ9rqVpLq6260S2jIFO7SDEyhGeuDp7oxPQWp0TKiV6U87njuk5djt4/eZA
	 C1UWO9D9j1Pf1rnaWDUCfmM1K0nvQV+P9Cep60GGVXeCotdscCu4+DjcYE1lebHC8z6id
	 7EiWrz924GMSyWdbkjt2d94VQ6U4H4YYCCuWDFu0PL6y6LtxcVvhZqKfRbxHPdpheww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pvtJRYpbyJgU0OIbD+BpsIaKtfWydgexqPIpD+GVj08=;
	b=mjxUImIEONUYMt1lzaNZmKrEt2sJMinqnpSB2EX87bACzFhgQrAig6BOvQrZNSvYQ70s
	 lpMpUepIN0LZ3U5HrUWBI4L7tP3zX8eNJ1bDDuky6+AxHfjq+dA1Xyvr2l6DnheZKfDUu
	 XX6mG4dOJWHSiGKzE2CQOGK+eHByj40VQZxA7bCUMJJCV8xCvmRaD9YCRWMEcLo0JbxjH
	 NZmitLGdKi7PhFMZI3cLFj4OibFHqpEts7ac71lBXUDnop9KSCMkejrhJsQy3QC5FHv9k
	 0TuyJCKuE4cwrnhFlI8NGCIKiwiWXLfuTQRESDgndfHRrq2jfObiHlxbNx+W+CkcQ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anue2JQR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E01606A31C;
	Thu, 19 Nov 2026 02:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anue2JQR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C761F000C4;
	Thu, 19 Nov 2026 02:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056591;
	bh=pvtJRYpbyJgU0OIbD+BpsIaKtfWydgexqPIpD+GVj08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anue2JQRs7uaYNXgD8esWr+fIExUTqddPGUULsvqGdRX0c08XPT0bvw9eFXuEuhps
	 DnscR1SgSNKpsu9aGgaj3FfSbAMKTgMRGoIN8NZ4tMFGTcR2aOPVmnM7zTwkvAuMa8
	 gqCqKHdOZtm6ZuOUrd9NmIBPKsYtj11Vze6ZehnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zhilkin <csharper2005@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2043/2214] dt-bindings: Add Sercomm (Suzhou) Corporation vendor prefix
Date: Wed, 18 Nov 2026 16:01:59 +0100
Message-ID: <20261118150132.441929156@linuxfoundation.org>
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

From: Mikhail Zhilkin <csharper2005@gmail.com>

[ Upstream commit d217c4d968bb590e5aa1ff7d02f680c9ba5c1cec ]

Add "sercomm" vendor prefix for "Sercomm (Suzhou) Corporation".

Company website:
Link: https://www.sercomm.com/

Signed-off-by: Mikhail Zhilkin <csharper2005@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220516151637.885324-1-csharper2005@gmail.com
Stable-dep-of: f4ba4f8cc8e8 ("dt-bindings: vendor-prefixes: Add Sensylink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 5f4114bcb2e64..c538bd92b7af3 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1064,6 +1064,8 @@ patternProperties:
     description: Sensirion AG
   "^sensortek,.*":
     description: Sensortek Technology Corporation
+  "^sercomm,.*":
+    description: Sercomm (Suzhou) Corporation
   "^sff,.*":
     description: Small Form Factor Committee
   "^sgd,.*":
-- 
2.53.0



