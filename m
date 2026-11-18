Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040516;
	b=a885LF3NmhkdUcAFlNfdtHtLmPgVTXwAWzDql29CCDSoAuGlYjPFLGcbkU6rQdf4YVAy
	 vxF3zUrN3rmf0uVsVsu6+ptELcP0UN8NLJWUhCq2YFanefPuGwzpNwfoyOBXBKvVMbDad
	 BkoZb5i5eIAB/KfUIINeheVnUj5LF+Sy5Nc6gXHT/AAWzPyhIrMadXtQR1JOwQReIOF6R
	 JFORwS0I07XZffuR8H2BYBH0h0WNr7U5ktVGcnvBe/ejj1ViA0ww20eABQayXXNVm6VDH
	 kD3oYEBU+PRU2zcq/AaJaP4VIJL4w3QmyUjCbRiUgwgxmp0drO1Mh3L5zHWx5ZEzySg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LzkIiePmclYwd/VcMy6pqlCqJKixxNsbuZKDPSkaH6U=;
	b=n64brl70N8Erw0eIV7ldu6xkn6jVv6q8TE+bi1YIF+vMDaUNTxLsWyyKDpzfXCnbClmh
	 G96iSbKPfx4adUaMUNufxbirJywOd540JRGRhidmar9anelyMaYKqzly9hlNSnQd97UYj
	 E9bNF7LzT1/dJoDPUmifJKpcGP2ZZK9PD5UuBx4hByke0f1cbcCMarq1KQPImUWlZGxGT
	 cUZB+8+2j/G8WPqiUtZ98W06WMfwMTl0jznzJKbMmR6UGH9xh9ZvVaeB+nU4AP/bUA1PC
	 qx2UwmvjN41t5AjLSzflhP6VqS1Zc7qlXSXYsb62nsi3pW8VvEqkP2xIZiLX67vXiqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YJDy3Y4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCE5606A320;
	Wed, 18 Nov 2026 22:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YJDy3Y4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18C11F000C4;
	Wed, 18 Nov 2026 22:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040516;
	bh=LzkIiePmclYwd/VcMy6pqlCqJKixxNsbuZKDPSkaH6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YJDy3Y4u274186QlTsNvvC6igboQMVnKuK0t0JR5btWRoO0Bx7ZPkF4u3DfVPePB
	 V3z1qIpXN661lvu8wS/uHsk1iDtid7KPE6gPmCzZL2QeY2LLp8JtPiMJg0JUfIJZFj
	 d8st8M1bzmubJJUd79PSrouVwjIoSkDmFoq1o+yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2484/3318] dt-bindings: display/msm: hdmi: Correct name of disallowed supplies
Date: Wed, 18 Nov 2026 15:51:46 +0100
Message-ID: <20261118150435.924715580@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 3309f5c888602c647f50c1921c9b60759fa86c21 ]

There are no properties in DTS or Linux drivers called
"core-vcc-supplies" or "hdmi-mux-supplies", so the binding probably
wanted "-supply" properties instead (which are defined in the top-level
properties of the binding).

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Fixes: 2f14bc38d88a ("dt-bindings: display/msm: hdmi: split and convert to yaml")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752661/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-7-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/display/msm/hdmi.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/msm/hdmi.yaml b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
index 47e97669821c3..80c642e05cf91 100644
--- a/Documentation/devicetree/bindings/display/msm/hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
@@ -127,7 +127,7 @@ allOf:
             - const: core
             - const: master_iface
             - const: slave_iface
-        core-vcc-supplies: false
+        core-vcc-supply: false
 
   - if:
       properties:
@@ -149,7 +149,7 @@ allOf:
             - const: core
             - const: alt_iface
             - const: extp
-        hdmi-mux-supplies: false
+        hdmi-mux-supply: false
 
 additionalProperties: false
 
-- 
2.53.0



