Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015213;
	b=FN/uh03+Gm2lX5zweuWENM0Ek8r3r08zdEYUJaMmnWdHqtoRvoLbX2d5an1qmN0uX6QU
	 3Mj69FF6DvK0n3AiocluaA/8HdlayLcVufM+nuMl6v1OaIS5PlQfkC1Zhkb4ouOk+UZWH
	 d1fECOyuy9x6sHn4jLF4pdAq+esTpECb+Ui7Hgl8SzeeqMdqiguDHphhqafy0tmbhWVf1
	 HTSsCoX+MZpvhANhSEPSPG1CjBAk9cDu5E0fo5bJWN8Jy2lC3aRhkY7+urpbfMEgyDpcc
	 nx7erQKT23rXDMvrBs6Dlab7RZtqxgk4brJAZ1llUwLpL3144ZqP784M7K/GChAmHyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=22EIFnYjitG/8eMx0B7CwR9p3Hvm6vQ2D9XNjJv+pGE=;
	b=Sf0FE/rwdJMU87x7yW/sRoYvTLfaATmbOT099ij0Np3miU/bYa/nnY0iiURnjAPKhleP
	 mZCWTjVfDSkMcegIvbWkE48EM7Th/011EaYGr0gI933evLYH8S+2+yYvUwDuxBDSeg4n0
	 0vhlRd9SzRakqWczRYPEm09lwdyiibiy+qpms+MgnOkTEr8fIJ3YICLMPhrQzwC0tWAGA
	 FnLEBQBOgcazt1+/W9n6pD62KaG/vLpgGOZleoKwsgOSg+dpWQS8VO6jLlPczMyCM1/Ag
	 KoVNxRrOYTKFAzpqE5ADYdRn1qC/AmDH1WAUOA25TvndxQ6JQYS43NWlfM/P67xO6PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqvXSY6B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C403606A330;
	Wed, 18 Nov 2026 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqvXSY6B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6861F000CA;
	Wed, 18 Nov 2026 15:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015212;
	bh=22EIFnYjitG/8eMx0B7CwR9p3Hvm6vQ2D9XNjJv+pGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqvXSY6BWIeNFySkvCC3M3DucGixccgwWgkmGVdoZl55g7Sz/lv4cwELUqzX0HCej
	 TMlimjVor/qy/wJoKG/WW4aLx94SB+UlIci5u8TUVxhrhwuVLD3unoDSNR6Yv2gwNY
	 HWJcmsg4lJskgODjLIyh6DY5BxeucPi7MAw0CMYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0093/2651] dt-bindings: iio: light: ltr501: Add missing ltr303 compatible
Date: Wed, 18 Nov 2026 15:22:13 +0100
Message-ID: <20261118150251.252582675@linuxfoundation.org>
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

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 198ed7962e42f1e45b7f48b9abc70aad9e3185f8 ]

When support for ltr303 was back in 2021, the bindings documentation was
not updated accordingly.

Fixes: 7d71d289e1ba ("iio: light: ltr501: Added ltr303 driver support")
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
index 480523ca37500..6234e2eaec2e4 100644
--- a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
+++ b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
@@ -16,6 +16,7 @@ properties:
   compatible:
     enum:
       - liteon,ltr301
+      - liteon,ltr303
       - liteon,ltr501
       - liteon,ltr559
 
-- 
2.53.0



