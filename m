Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017496;
	b=v7XtX44oeR7/8mXdDVlQHQMUkTE45T4cTK9kARAqx/bgYAohJzAlQdiL+tToxEQd/9VL
	 Hr1ehSOc0A2YFgEgz7jUuQEn0WKfIwFa4y+CJ0aXAB8Mt71dgcq+zHJaV5fWHcI1F4q7/
	 e5rfigQg7cR7q16W0uG3Q5PrNNEmYLDCLr5IrS4hwchJ8he7AKJBwHfHZ6hWQifGNHtt3
	 nSlhzOjHORb19vrzrFu4BJj+7KI294zazkuCz+0u0iZJBZyHctsjlpnv5BEvnmm5oyXC3
	 uzxBsV1n5qbvGygfOX0pzIJh3PF58reptmQA90n6szB2Diw2JP8ZfSaLEg/bYVvSs9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z8l0+0o0NSnRX9lQTfrYCt6xELctr8rofQ3A1E28r0g=;
	b=deXd6rPa6BalNph7lMZeF/JSvrfJ1cWFcUZL/VbzXPdnF3WJ1e1cWlGu8cevnGi8Qsq7
	 Un/JeFNtjdIfXEE66m0680w7aMfmqwJmuWFzhESt7nInyDou0Ix1GY8sdyaz16OqPuxLv
	 RczaB+MNsTKJNHxfCv+ZqXic9IwkM5fXJhdAQruadrBJLB7KHetnFOhmgYXs3GfrrCf7o
	 GWRhDFXJrFI+Hb+mbugeBqwDpZtDl3uKUVGI/TloquvQoQyR/P14qiBEDyCfCFuYNa+Wa
	 DzxfV6c2iUc8D6r6H5rcFQKU4DUUsqiIFrEtLQayyPoXORH2TtFgsKxuVuPXazhJ8KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3eOYY4s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC37606A31C;
	Wed, 18 Nov 2026 15:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3eOYY4s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CA61F000C4;
	Wed, 18 Nov 2026 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017496;
	bh=z8l0+0o0NSnRX9lQTfrYCt6xELctr8rofQ3A1E28r0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3eOYY4seibMhYJT5QIsk3R+N0jVd1MJ7pDwD0rWFT77oGlLAgkD/S5WZlJLYo2Da
	 bIqTm76kc4TpLkW337INhc79nba2N5Yo9zLojh+hTtUVozDvqChqz4Gcwp8/o/3OdV
	 97ReS2Nctm6VLPnhJX0UeNcx/s0cUqOi8vZEgwMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0904/2651] dt-bindings: display/msm/gmu: Fix Glymurs compatible
Date: Wed, 18 Nov 2026 15:35:44 +0100
Message-ID: <20261118150320.418787016@linuxfoundation.org>
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

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit f221c5856392fc16f56c7aa709d18f6714ab6f82 ]

The Glymur GMU compatible string was incorrectly documented as
qcom,adreno-gmu-x285.1. Fix it to use the correct string
qcom,adreno-gmu-x290.1.

Fixes: 7bc29d5fb6fa ("dt-bindings: display/msm/gmu: Add Adreno X2-85 GMU")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/756251/
Message-ID: <20260925-mahua-gpu-v1-1-0fa0bfd8d315@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/display/msm/gmu.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/msm/gmu.yaml b/Documentation/devicetree/bindings/display/msm/gmu.yaml
index 9e459f12ce3f5..f22661447e7c7 100644
--- a/Documentation/devicetree/bindings/display/msm/gmu.yaml
+++ b/Documentation/devicetree/bindings/display/msm/gmu.yaml
@@ -363,7 +363,7 @@ allOf:
       properties:
         compatible:
           contains:
-            const: qcom,adreno-gmu-x285.1
+            const: qcom,adreno-gmu-x290.1
     then:
       properties:
         reg:
-- 
2.53.0



