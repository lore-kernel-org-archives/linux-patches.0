Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025013;
	b=rYurVk7CCjDS7bseq2NFw8uQ2pAVUhPzKTf6Xs1hiHMCLmwAX6HynUuXaSCEdcrqhcXi
	 N3v273LcXAur4Ebw5HkJsM89sWhgI5+s9drh7k9d6RozP7JGDqShoXZ88IBx56gDhenJi
	 lpI0yBtfLclnxq4u3Sb2D5dvZIfJbFfGRos5v40mksecwacrBh3m2kNKFKZTuMbwY6pxP
	 vPQtdbXZM5zjPeZ2whi6M9FRG4J/YNkIiXZkQbj4PydJ1xXZW7UpAz5/E3e4Xw2gqQPuK
	 IkaNh2+a0veQ9FPQ37s4BdBNTIuP+0l47GdHZgZRuyJZ+OWDg+cgFq/EdAEQAasX+0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7mk7PmiuRqzHzIMnQ8iwmArKIZVzjJeqk77ckVMk/i4=;
	b=Gt7d6blfgjsmPTHzBOntv+lC1j0bTfNDMrNE4gleViKbPWkvWZDs2AR4OHyfKiM2Voha
	 SJHXV43y2D2G5f/WbZtH82vL5unOk651vex8APYTnkT4vVDPIvfRG0Ar0+v81B9OCle5B
	 DzD3Mp8EOFQayvFUZ647uZIDVCp5D3fkXhd6QjVcJ+NLc1+SmwDF/WO0ZZN9QTmCADnf5
	 Obp32NUxuUdsO7rPC6/kMSFffnwiZGpLPZw6C+w8hBy/LUv3GKkkmL6Aj4CL2C9BgCzvz
	 9CJLaNI95QyoJ+0iAJsgeQpmd7FpbtgUgg39O/KpP6NgRTSM4yU9JN40W0+Tpy4CkFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FY7End7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3543606A32F;
	Wed, 18 Nov 2026 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FY7End7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118EB1F000C4;
	Wed, 18 Nov 2026 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025013;
	bh=7mk7PmiuRqzHzIMnQ8iwmArKIZVzjJeqk77ckVMk/i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FY7End7wtzrVnzVg2yzUbTUsoHCLKQqOkhmT4+POy0B5aB1R74DSdHMU/PXI2vDsH
	 KpmBWc9LIjoZKjRwVf4EpUximx4Hgx9mle3PCg0uuiA9xMce3ZlsQzCTlMb8HeDCbK
	 rmFpV9P7vqhHNvecmCIR/I8oQdvinEXFCx4LHY9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0914/2151] dt-bindings: display/msm: hdmi: Correct name of disallowed supplies
Date: Wed, 18 Nov 2026 15:44:09 +0100
Message-ID: <20261118150155.681324434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dfec6c3480f3f..02d27ccad0247 100644
--- a/Documentation/devicetree/bindings/display/msm/hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
@@ -113,7 +113,7 @@ allOf:
             - const: core
             - const: master_iface
             - const: slave_iface
-        core-vcc-supplies: false
+        core-vcc-supply: false
 
   - if:
       properties:
@@ -136,7 +136,7 @@ allOf:
             - const: core
             - const: alt_iface
             - const: extp
-        hdmi-mux-supplies: false
+        hdmi-mux-supply: false
 
   - if:
       properties:
-- 
2.53.0



