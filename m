Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57412AE68;
	Mon, 30 Dec 2024 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574113; cv=none; b=gaBHbs03hSrvRRAzUBZpxEG1Cv21Ch+qdKM0VwB1vAEtycKzbIu0j2QuT/k5CZOeQyO0WRhVAjhIaZdSBGKyr+GmEFzEbMfq1r1cusHzBdXeWXSAq3hHmK8xHVyOx6XHjGF2Vk6TqvBQop3VrIm+U66rV5s4/10s+HW4lSk3EjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574113; c=relaxed/simple;
	bh=pVaGJ5v2SbKhRHu3LRDSjhkK5HjDCJrd1696O1zrRpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hltPQKeD52W37VBWLwviOz2+RkNteQ7wu7WWqkjpKreffncnw+Q1XZKznR6TSF6FI25s2oa14rcL1mGgk7mWybiw8NttvFLBKpiC3KejZ3gocJoMrU5S36fC2XeTg+S4zaa6MKFHRu7UAZ7Vm1iXsupndpyHnzCD2PI+Sq25kOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgErl+Ly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgErl+Ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3C2C4CED0;
	Mon, 30 Dec 2024 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574113;
	bh=pVaGJ5v2SbKhRHu3LRDSjhkK5HjDCJrd1696O1zrRpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgErl+LyRADHnn03osRT6L5x3glQgaxf31hWQwHN0s1k8yWILMO9DB2qkVlggHd5Y
	 sc3hMOWbDN31KEVDtMpVWIgIYNlCqD1wtvGknp6YVMSkYc0KHkBV9T/T9B2GjyRDOX
	 BBOknECni7zK/5OX32kZFOBgjY4Ivc34OTPNFR8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 040/114] ASoC: dt-bindings: realtek,rt5645: Fix CPVDD voltage comment
Date: Mon, 30 Dec 2024 16:42:37 +0100
Message-ID: <20241230154219.604319986@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit 6f4a0fd03ce856c6d9811429b9969b4f27e2eaee upstream.

Both the ALC5645 and ALC5650 datasheets specify a recommended voltage of
1.8V for CPVDD, not 3.5V.

Fix the comment.

Cc: Matthias Brugger <matthias.bgg@gmail.com>
Fixes: 26aa19174f0d ("ASoC: dt-bindings: rt5645: add suppliers")
Fixes: 83d43ab0a1cb ("ASoC: dt-bindings: realtek,rt5645: Convert to dtschema")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20241211035403.4157760-1-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/sound/realtek,rt5645.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/realtek,rt5645.yaml b/Documentation/devicetree/bindings/sound/realtek,rt5645.yaml
index 13f09f1bc800..0a698798c22b 100644
--- a/Documentation/devicetree/bindings/sound/realtek,rt5645.yaml
+++ b/Documentation/devicetree/bindings/sound/realtek,rt5645.yaml
@@ -51,7 +51,7 @@ properties:
     description: Power supply for AVDD, providing 1.8V.
 
   cpvdd-supply:
-    description: Power supply for CPVDD, providing 3.5V.
+    description: Power supply for CPVDD, providing 1.8V.
 
   hp-detect-gpios:
     description: 
-- 
2.47.1



