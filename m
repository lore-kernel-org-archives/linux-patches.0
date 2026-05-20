Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E31A372691;
	Wed, 20 May 2026 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295125; cv=none; b=ZZZ//txpRskI/ZZnMV3A8FB9gpOLO/eiJn9HG8l8di9ga1GHkM6MHSFhqloJxEc9X0DhUBcCriCIhIlDii8cxcltxpOpmsAnOhrTY73TdDaZ/ggLyp6QD4hWM6NEyLlg0pk29KE1/aVhrmGC0j/drBc2VRBwt0D0QqMJvBXqewk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295125; c=relaxed/simple;
	bh=2a+FkGN7Dt4Au0K7BzHrsc/hkeB8OnEOd38XclLmP9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3Bi4rlc/a7cXgLIdSJx4ahjw30KxkAY1Zgo5JGaPXPtSPdaPrijROBFXkHvfITCePKBPlbPv7CZnGxLhJVHZePf8xEGVezq7oN/VDcFmzUcFCFrgSUprgYECfdT8vNZf2rdiDE0DcizWHFeVQsOmhm+Zv/wcQYdTjFob5gaAc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlSgiZz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlSgiZz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A331F00893;
	Wed, 20 May 2026 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295121;
	bh=EmH4vFswc4W7FWZOG55HBGUfIPcgHu+3UFX49beVOZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlSgiZz6yjQgmN6fpaEyxHv38HHPj6Zk5JIp2Imqu0oinyeIibBGx7opGwEo0Esiq
	 i0XmDImzj6cFiNij1yWGK35k9TgrPCCVxiEOB0JJko4PmFNWyNSD4EYYWAcFEtSZ0N
	 QRDNpG7bpOnCb6DnbPo3zOA+DvYulDu56wxiL1Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pritesh Patel <pritesh.patel@einfochips.com>,
	Huan He <hehuan1@eswincomputing.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0258/1146] dt-bindings: mmc: dwcmshc-sdhci: Fix resets array validation
Date: Wed, 20 May 2026 18:08:28 +0200
Message-ID: <20260520162154.070522894@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huan He <hehuan1@eswincomputing.com>

[ Upstream commit 5f7ac24ba232180caf77e9ddd6ccad61b9948706 ]

The binding defines tuple-style reset-names items for some
compatibles, which implicitly enforces a fixed array length
via JSON Schema.

Defining global maxItems for resets and reset-names causes these
constraints to be intersected via allOf, resulting in an effective
minItems equal to the global maxItems. This leads to dtbs_check
failures reporting reset arrays as too short, even when the DTS
provides the correct number of entries.

Fixes: 30009a21f257 ("dt-bindings: mmc: sdhci-of-dwcmshc: Add Eswin EIC7700")
Co-developed-by: Pritesh Patel <pritesh.patel@einfochips.com>
Signed-off-by: Pritesh Patel <pritesh.patel@einfochips.com>
Signed-off-by: Huan He <hehuan1@eswincomputing.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml b/Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml
index 7e7c55dc24403..5cebe5eb1efb8 100644
--- a/Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/snps,dwcmshc-sdhci.yaml
@@ -50,9 +50,11 @@ properties:
     maxItems: 1
 
   resets:
+    minItems: 4
     maxItems: 5
 
   reset-names:
+    minItems: 4
     maxItems: 5
 
   rockchip,txclk-tapnum:
@@ -146,6 +148,7 @@ allOf:
     else:
       properties:
         resets:
+          minItems: 5
           maxItems: 5
         reset-names:
           items:
-- 
2.53.0



