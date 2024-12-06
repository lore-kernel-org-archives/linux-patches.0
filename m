Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D61210E0;
	Fri,  6 Dec 2024 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497167; cv=none; b=SO5/rYo53IHMcfNr9Nnn7hUXoI++vzkfWMSCihSXM5Pt/E4ySnes1jWvVsjNJ5QycQ6tBvOuw65vS8u7I7crSo/g0Tq0myCacxxEy2uBUQ4OmA5ubHFmwTamLWxIn85TAVdyalWGQJ4VBCQaGkRLbtYtkaWMnj0rdTd6XxZi5+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497167; c=relaxed/simple;
	bh=jTuHc2piSMASzSC1XV7lU9MAy4DY9SiPWk49yo2IPds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCwX7hq2dNuhNuqq49jScuoh09QJA6X9xgLflQr9McQn6t2SVLUcVn7rNKqCVeaK+MGSvn3X681RPoB2AGitBqCnCEAF+Kl9jL+Z7mEYQGXPOfUKR3gFlTbqKEhI/+kYNCv8uxmCaAGGkFUj5sto9HmCv1XS3EpjINkazyxlgwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGYg4Ni2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGYg4Ni2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1162C4CED1;
	Fri,  6 Dec 2024 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497167;
	bh=jTuHc2piSMASzSC1XV7lU9MAy4DY9SiPWk49yo2IPds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGYg4Ni2rmHbpKDJrZc71P828QgSG9O2+lZDuTiqkz3XO61dp1MGVw371/c854s8T
	 5sOtKrut3QTbwFufExsuKaFzbsUMROnPI5yDYQIzXWHwN7GipZTErFg+CyWZse+e1D
	 AVTk2x67G4mXyTdOZ/Q9sDBxODOr9yT7V5mxVL9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Prusov <ivprusov@salutedevices.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/676] dt-bindings: vendor-prefixes: Add NeoFidelity, Inc
Date: Fri,  6 Dec 2024 15:30:00 +0100
Message-ID: <20241206143700.417822300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Prusov <ivprusov@salutedevices.com>

[ Upstream commit 5d9e6d6fc1b98c8c22d110ee931b3b233d43cd13 ]

Add vendor prefix for NeoFidelity, Inc

Signed-off-by: Igor Prusov <ivprusov@salutedevices.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240925-ntp-amps-8918-8835-v3-1-e2459a8191a6@salutedevices.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 573578db95091..12a16031d7b6d 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -923,6 +923,8 @@ patternProperties:
     description: National Semiconductor
   "^nec,.*":
     description: NEC LCD Technologies, Ltd.
+  "^neofidelity,.*":
+    description: Neofidelity Inc.
   "^neonode,.*":
     description: Neonode Inc.
   "^netgear,.*":
-- 
2.43.0



