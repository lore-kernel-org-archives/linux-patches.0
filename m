Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055165;
	b=klXw2dxq/b3//ERI8zSvRHcI1fmAcbYGY7Gahil8p04NUhPe2JSD53k5DJjmO+PsZHoM
	 /GHfvAuXjig+x0G11g5uHj1P7uMaP8HCtLe7Iv08yWoKRdRSXdtXfos8xP4fMirSThqkk
	 mmI60gPJeWfxlfJzue8GehDcY5lBO8aTJabaPyWk6nb7l1mQ50ZoC+kpUk4F6eJiM3txR
	 h5V0tcTNMqkbMZl6N+raTBgLIZbUMLk7Eq71RcQj2b7IUBwYCEBC1HPqsC4UJ1XOxHuUw
	 fR/DdAHE3Ghko3KCc65V7KP2JW+bYTsxLYDp+zXyp7zys82hFS43/a1qTU1Q5/J47zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+O/AMZi+pRCgZ63+TSBarfKDiUeh6sajnleLQTf4wD0=;
	b=htXfTDsjH5Ik3/FPkBu4VqpQEKjd0kH1Dejuud/EjD6EZff3jVxQwjEI2gMTd1Xb7hrn
	 ekWjIfR5eB3eniNfI3gW8aED+vvWQLX1ght0AivdipolFQDYKfDghEg65N5aJiAnTPehC
	 p6d6XLgUWrvERGqjhq53DqE2xMRCZhVz3Vrj38Ejpmkjc4hHhnQmCywx/eAqbNkEEO9Lr
	 zD3//KoeRmu3Eg5NZ3RpWEAp/VPWjX9AqkASyqpNWNqi+FNwVXOxtjnOXA1su72LGoqh4
	 dq63FG6JO9xgPdiBM7Rdbkl+hIuLDsQgAnxjOZnUttX5+f95WQ9+iWJtkrgh2KWa8jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mcb2FtCy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFE4606A325;
	Thu, 19 Nov 2026 02:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mcb2FtCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D99F1F000C4;
	Thu, 19 Nov 2026 02:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055165;
	bh=+O/AMZi+pRCgZ63+TSBarfKDiUeh6sajnleLQTf4wD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mcb2FtCyjCFcamI4COMs+uNT+fw9CP0SgmI5+j5ivycEeNyeao24sipDXj5Gm2KBX
	 FbZVcQombFWYxpBViTvUA4H9ErFFC/J6Uz8ewZ9tlTvF+X0/Qa5j8n3Pf3CNm08OKq
	 Onz+HrcJ9nVmFkt58QDvf6ZQvqOwmqJkLWOdqlGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Asseily <karl@asseily.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1534/2214] dt-bindings: vendor-prefixes: add ESS Technology
Date: Wed, 18 Nov 2026 15:53:30 +0100
Message-ID: <20261118150113.538140051@linuxfoundation.org>
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
index 38fc30b90f6cd..2ca68ee8602cf 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -379,6 +379,8 @@ patternProperties:
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



